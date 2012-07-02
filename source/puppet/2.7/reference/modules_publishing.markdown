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
2. Prepare a copy of your module and give it a Forge-ready filename
3. Write a Modulefile with the required metadata
4. Build an uploadable tarball of your module
5. Upload your module using the Puppet Forge's web interface.

> ### A Note on Filenames
>
> (This note applies to all Puppet versions through 3.x.)
>
> Puppet and the Puppet Forge have conflicting rules for how a module's directory should be named. 
> 
> * Puppet expects a module's directory to be the name of the module. (e.g. `mysql`)
> * The Puppet Forge expects a module's directory to be the author's username, a hyphen, and then the name of the module. (e.g. `puppetlabs-mysql`)
> 
> This means you cannot directly publish a module that is currently being used by Puppet --- you must publish a renamed copy of it instead.

> ### Another Note on Filenames
> 
> Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style when working on the command line.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge. You will need to know your username when preparing to publish any of your modules. 

Start by navigating to the [Puppet Forge website][forge] and clicking the "Register" link in the sidebar:

![The "register" link in the Puppet Forge sidebar][register]

Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Puppet Forge.

Prepare the Module
-----

As [mentioned above](#a-note-on-filenames), the Puppet Forge expects modules to have a username prefix, which is not compatible with Puppet's normal operation. 

To prepare your module for publication, you can do either of the following:

* Copy and rename the entire directory containing your module, or...
* Generate a new module template and copy the individual files into place

### Copy and Rename 

The Puppet Forge expects module names to be in the form `<FORGE USERNAME>-<MODULE NAME>`. If your module is otherwise ready, you can simply copy it to a directory outside Puppet's [modulepath][] and rename it:

    $ cp /etc/puppetlabs/puppet/modules/mymodule ~/Development/examplecorp-mymodule

### Generate a Module Template

Alternately, you can use the `puppet module generate` action to generate a template. This is mostly useful if you need an example Modulefile and README, and also includes a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. It is not particularly useful for developing a module from scratch, as you would have to rename the module before attempting to use it with Puppet. 

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

After generating the template, you will need to manually copy your module's files into place.

Write a Modulefile
-----

In your module's main directory, create a text file named `Modulefile`. If you generated a template, you'll already have an example Modulefile.

The Modulefile resembles a configuration or data file, but is actually a simple Ruby domain-specific language (DSL), which is executed when you build a tarball of the module. This means Ruby's normal rules of string quoting apply:

    name 'myuser-mymodule'
    version '0.0.1'
    dependency 'otheruser-othermodule', '1.2.3'
    description "This is a full description
        of the module, and is being written as a multi-line string."

Modulefiles support the following pieces of metadata:

* `name` --- REQUIRED. The full name of the module, including the username (e.g. "username-module").
* `version` --- REQUIRED. The current version of the module.
* `summary` --- REQUIRED. A one-line description of the module.
* `description` --- REQUIRED. A more complete description of the module.
* `dependency` --- A module that this module depends on. Unlike the other fields, the `dependency` method accepts up to three arguments (separated by commas): a module name, a version requirement, and a repository. A Modulefile may include multiple `dependency` lines.
* `project_page` --- The module's website.
* `license` --- The license under which the module is made available.
* `author` --- The module's author. If not provided, this field will default to the username portion of the module's `name` field.
* `source` --- The module's source. This field's purpose is not specified.


Build Your Module
------

Now that the content and Modulefile are ready, you can build a package of your module by running the following command:

    puppet module build <MODULE DIRECTORY>

This will generate a `.tar.gz` package, which will saved in the module's `pkg/` subdirectory.

For example:

    # puppet module build ~/Development/examplecorp-mymodule 
    Building /Users/fred/Development/examplecorp-mymodule for release
    examplecorp-mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz

Upload to the Puppet Forge
------

Now that you have a compiled `tar.gz` package, you can upload it to the Puppet Forge. There is currently no command line tool for publishing; you must use the Puppet Forge's web interface.

In your web browser, navigate [to the Puppet Forge][forge]; log in if necessary. 

### Create a Module Page

If you have never published a copy of this module before, you must create a new page for this module. Click on the "Add a module" link in the sidebar:

![the "add a module" link in the Forge's sidebar][addmodule]

This will bring up a form for info about the new module. Only the "name" field is required. **Use the module's short name, not the long `username-module` name.**

Clicking the "add module" button at the bottom of the form will automatically navigate to the new module page.

### Upload a Release

Navigate to the module's page if you are not already there, and click the "add a release" link:

[the "add a release" link on a module's page][addrelease]

This will bring you to the upload form:

[the upload form for a new release of a module][upload]

Click "browse," and use the file browser to locate and select the release tarball you created with the `puppet module build` action. Write some release notes, if applicable, and click the "add release" link.

Your module has now been published to the Puppet Forge. To confirm that it was published correctly, you can [install it][installing] on a new system using the `puppet module install` action.


Release a New Version
-----

To release a new version of an already published module:

1. Make any necessary edits to the publishable copy of your module.
2. Increment the `version` field in the Modulefile.
3. Follow the instructions above for [uploading a release](#upload-a-release).

