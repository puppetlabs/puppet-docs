---
layout: legacy
nav: puppet27.html
title: "Publishing Modules on the Puppet Forge"
---


[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[forge]: https://forge.puppetlabs.com/
[rspec]: http://rspec-puppet.com/

[register]: ./images/forge_register.png
[addmodule]: ./images/forge_add_module.png
[addrelease]: ./images/forge_add_release.png
[upload]: ./images/forge_upload.png

Publishing Modules on the Puppet Forge
=====

The Puppet Forge is a repository of modules, written and contributed by users. This document describes how to publish your own modules to the Puppet Forge so that other users can [install][installing] them.


* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.

Overview
-----

This guide assumes that you have already [written a useful Puppet module][fundamentals]. To publish your module, you will need to:

1. Create a Puppet Forge account, if you don't already have one
2. Prepare your module
3. Write a Modulefile with the required metadata
4. Build an uploadable tarball of your module
5. Upload your module using the Puppet Forge's web interface.

> ### A Note on Module Names
>
> Because many users have published their own versions of modules with common names ("mysql," "bacula," etc.), the Puppet Forge requires module names to have a username prefix. That is, if a user named "puppetlabs" maintained a "mysql" module, it would be known to the Puppet Forge as `puppetlabs-mysql`. 
>
> **Be sure to use this long name in your module's [Modulefile](#write-a-modulefile).** However, you do not have to rename the module's directory, and can leave the module in your active modulepath --- the build action will do the right thing as long as the Modulefile is correct. 

> ### Another Note on Module Names
> 
> Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style in your metadata files and when issuing commands.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge. You will need to know your username when preparing to publish any of your modules. 

Start by navigating to the [Puppet Forge website][forge] and clicking the "Register" link in the sidebar:

![The "register" link in the Puppet Forge sidebar][register]

Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Puppet Forge.

Prepare the Module
-----

If you already have a Puppet module with the [correct directory layout][fundamentals], you may continue to the next step. 

Alternately, you can use the `puppet module generate` action to generate a template layout. This is mostly useful if you need an example Modulefile and README, and also includes a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. If you choose to do this, you will need to manually copy your module's files into the template.

To generate a template, run `puppet module generate <USERNAME>-<MODULE NAME>`. For example:

    # puppet module generate examplecorp-mymodule
    Generating module at /Users/fred/Development/examplecorp-mymodule
    examplecorp-mymodule
    examplecorp-mymodule/tests
    examplecorp-mymodule/tests/init.pp
    examplecorp-mymodule/spec
    examplecorp-mymodule/spec/spec_helper.rb
    examplecorp-mymodule/README
    examplecorp-mymodule/Modulefile
    examplecorp-mymodule/manifests
    examplecorp-mymodule/manifests/init.pp

> Note: This action is of limited use when developing a module from scratch, as the module must be renamed to remove the username prefix before it can be used with Puppet. 

Write a Modulefile
-----

In your module's main directory, create a text file named `Modulefile`. If you generated a template, you'll already have an example Modulefile.

The Modulefile resembles a configuration or data file, but is actually a simple Ruby domain-specific language (DSL), which is executed when you build a tarball of the module. This means Ruby's normal rules of string quoting apply:

    name 'examplecorp-mymodule'
    version '0.0.1'
    dependency 'puppetlabs-mysql', '1.2.3'
    description "This is a full description
        of the module, and is being written as a multi-line string."

Modulefiles support the following pieces of metadata:

* `name` --- REQUIRED. The **full name** of the module, including the username (e.g. "username-module" --- [see note above](#a-note-on-module-names)).
* `version` --- REQUIRED. The current version of the module. This should be a [semantic version](http://semver.org/).
* `summary` --- REQUIRED. A one-line description of the module.
* `description` --- REQUIRED. A more complete description of the module.
* `dependency` --- A module that this module depends on. Unlike the other fields, the `dependency` method accepts up to three arguments (separated by commas): a module name, a version requirement, and a repository. A Modulefile may include multiple `dependency` lines.
* `project_page` --- The module's website.
* `license` --- The license under which the module is made available.
* `author` --- The module's author. If not provided, this field will default to the username portion of the module's `name` field.
* `source` --- The module's source. This field's purpose is not specified.

Dependancies in the Modulefile
-----

If you choose to rely on another Forge module, you can express this in the 'dependency' field of your Modulefile. The following is a list of operators that can be used like in the following complete example.

`dependency 'puppetlabs/stdlib', '>= 2.2.1'`

### Operators
### `>1.2.3` (Greater than a specific version.)
### `<1.2.3` (Less than a specific version.)
### `>=1.2.3` (Greater than or equal to a specific version.)
### `<=1.2.3` (Less than or equal to a specific version.)
### `>=1.0.0 <2.0.0` (Range of versions)
### `1.2.3` (A specific version.)
### `1.x` (A semantic major version.)
Example. 1.0.1 but _not_ 2.0.1. It's also shorthand for `>=1.0.0 <2.0.0`.
### `1.2.x` (A semantic major & minor version.)
Example. 1.2.3 but not 1.3.0. It's also shorthand for `>=1.2.0 <1.3.0`.

> ### A Note on Semantic Versioning
-----
> When building your Modulefile, you're setting both a module version and optionally expressing dependancies on others module versions. Following the [Semantic Versioning](http://semver.org/spec/v1.0.0.html) specification is strongly recommended. Doing so not only provides a contract to others that might use your module but provides a way for you to rely on others modules without unexpected change.

> For example, if you depend on puppetlabs-stdlib but want to protect against breaking changes, you could write the following line in your Modulefile (assuming the current module version of 2.2.1).  
> `dependency 'puppetlabs/stdlib', '2.x'`

Build Your Module
------

Now that the content and Modulefile are ready, you can build a package of your module by running the following command:

    puppet module build <MODULE DIRECTORY>

This will generate a `.tar.gz` package, which will be saved in the module's `pkg/` subdirectory.

For example:

    # puppet module build /etc/puppetlabs/puppet/modules/mymodule 
    Building /etc/puppetlabs/puppet/modules/mymodule for release
    /etc/puppetlabs/puppet/modules/mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz

Upload to the Puppet Forge
------

Now that you have a compiled `tar.gz` package, you can upload it to the Puppet Forge. There is currently no command line tool for publishing; you must use the Puppet Forge's web interface.

In your web browser, navigate [to the Puppet Forge][forge]; log in if necessary. 

### Create a Module Page

If you have never published this module before, you must create a new page for it. Click on the "Add a module" link in the sidebar:

![the "add a module" link in the Forge's sidebar][addmodule]

This will bring up a form for info about the new module. Only the "name" field is required. **Use the module's short name, not the long `username-module` name.**

Clicking the "add module" button at the bottom of the form will automatically navigate to the new module page.

### Upload a Release

Navigate to the module's page if you are not already there, and click the "add a release" link:

![the "add a release" link on a module's page][addrelease]

This will bring you to the upload form:

![the upload form for a new release of a module][upload]

Click "browse," and use the file browser to locate and select the release tarball you created with the `puppet module build` action. Write some release notes, if applicable, and click the "add release" link.

Your module has now been published to the Puppet Forge. To confirm that it was published correctly, you can [install it][installing] on a new system using the `puppet module install` action.


Release a New Version
-----

To release a new version of an already published module:

1. Make any necessary edits to your module.
2. Increment the `version` field in the Modulefile (ensuring you use a valid [semantic version](http://semver.org/).
3. Follow the instructions above for [uploading a release](#upload-a-release).

