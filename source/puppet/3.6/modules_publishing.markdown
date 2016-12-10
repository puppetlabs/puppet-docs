---
layout: default
title: "Publishing Modules on the Puppet Forge"
canonical: "/puppet/latest/reference/modules_publishing.html"
---


[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[forge]: https://forge.puppetlabs.com/
[rspec]: http://rspec-puppet.com/
[signup]: ./images/forge_signup.png
[publishmodule]: ./images/forge_publish_module.png
[uploadtarball]: ./images/forge_upload_tarball.png
[uploadtarball2]: ./images/forge_upload_tarball2.png
[forgenewrelease]: ./images/forge_new_release.png
[documentation]: ./modules_documentation.html
[errors]: ./modules_installing.html#errors

Publishing Modules on the Puppet Forge
=====

>**A Note for Puppet Enterprise 3.3.1 users**
>
>A bug present in Puppet 3.6 was fixed in PE's 3.3.1 release. Please go to the [PE-specific](https://docs.puppetlabs.com/pe/3.3/modules_publishing.html) page for an updated workflow.

The Puppet Forge is a community repository of modules, written and contributed by  Puppet Open Source and Puppet Enterprise users. Using the Puppet Forge is a great way to build on the work others have done and get updates and expansions on your own module work. This document describes how to publish your own modules to the Puppet Forge so that other users can [install][installing] them.


* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.

>**DEPRECATION WARNING** As of Puppet 3.6 the Modulefile has been deprecated in favor of the metadata.json file. We strongly suggest that you use `puppet module generate` to create new modules, as it now includes a dialog for creating your metadata.json. You can read more about how to [deal with your Modulefile](#build-your-modulefile) below.


Overview
-----

This guide assumes that you have already [written a useful Puppet module][fundamentals]. To publish your module, you will need to:

1. Create a Puppet Forge account, if you don't already have one.
2. Prepare your module.
3. Write a metadata.json file with the required metadata.
4. Build an uploadable tarball of your module.
5. Upload your module using the Puppet Forge's web interface.

> ###A Note on Module Names
>
> Because many users have published their own versions of modules with common names ("mysql," "bacula," etc.), the Puppet Forge requires module names to have a username prefix. That is, if a user named "puppetlabs" maintained a "mysql" module, it would be known to the Puppet Forge as `puppetlabs-mysql`.
>
> **Be sure to use this long name in your module's [metadata.json file](#write-a-metadatajson-file).** However, you do not have to rename the module's directory, and can leave the module in your active modulepath --- the build action will do the right thing as long as the metadata.json is correct.

> ###Another Note on Module Names
>
> Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style in your metadata files and when issuing commands.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge. You will need to know your username when preparing to publish any of your modules.

1. Start by navigating to the [Puppet Forge website][forge] and clicking the "Sign Up" link in the sidebar:

![The "sign up" link in the Puppet Forge sidebar][signup]

2. Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Puppet Forge.

Prepare the Module
-----

If you already have a Puppet module with the [correct directory layout][fundamentals], you may continue to the next step.

Alternately, you can use the `puppet module generate` action to generate a template layout. Generating a module will provide you with a sample README and a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. It will also launch a series of questions that will create your metadata.json file. If you decided to construct a module on your own first, you will need to manually copy that module's files into the generated module.

To generate a new module, run `puppet module generate <USERNAME>-<MODULE NAME>`. For example:

    # puppet module generate examplecorp-mymodule
    Generating module at /Users/Pat/Development/examplecorp-mymodule
    examplecorp-mymodule
    examplecorp-mymodule/manifests
    examplecorp-mymodule/manifests/init.pp
    examplecorp-mymodule/metadata.json
    examplecorp-mymodule/Rakefile
    examplecorp-mymodule/README.md
    examplecorp-mymodule/spec
    examplecorp-mymodule/spec/classes
    examplecorp-mymodule/spec/classes/init_spec.rb
    examplecorp-mymodule/spec/spec_helper.rb
    examplecorp-mymodule/tests
    examplecorp-mymodule/tests/init.pp


Write a metadata.json File
-----

If you generated your module using the `puppet module generate` command, you'll already have a metadata.json file. If you put your module together without using the `puppet module generate` command, you must make sure that you have a metadata.json file in your module's main directory.

The metadata.json is a JSON-formatted file containing information about your module, such as its name, version, and dependencies.

Your metadata.json will look something like

    {
      "name": "examplecorp-mymodule",
      "version": "0.0.1",
      "author": "Pat",
      "license": "Licensed under (Apache 2.0)",
      "summary": "A module for a thing",
      "source": "https://github.com/examplecorp/examplecorp-mymodule",
      "project_page": "(https://forge.puppetlabs.com/examplecorp/mymodule)",
      "issues_url": "",
      "tags": ["things", "stuff"],
      "operatingsystem_support": [
        {
        "operatingsystem":"RedHat",
        "operatingsystemrelease":[ "5.0", "6.0" ]
        },
        {
        "operatingsystem": "Ubuntu",
        "operatingsystemrelease": [ "12.04", "10.04" ]
        }
       ]
      "dependencies": [
        { "name": "puppetlabs/stdlib", "version_requirement": ">=3.2.0 <5.0.0" },
        { "name": "puppetlabs/firewall", "version_requirement": ">= 0.0.4" },
      ]
    }

### Fields in metadata.json

* `name` --- REQUIRED. The **full name** of your module, including the username (e.g. "username-module" --- [see note above](#a-note-on-module-names)).
* `version` --- REQUIRED. The current version of your module. This should be a [semantic version](http://semver.org/).
* `author` --- REQUIRED. The person who gets credit for creating the module. If not provided, this field will default to the username portion of the `name` field.
* `license` --- REQUIRED. The license under which your module is made available.
* `summary` --- REQUIRED. A one-line description of your module.
* `source` --- REQUIRED. The source repository for your module.
* `dependencies` --- REQUIRED. A list of the other modules that your module depends on to function. See [Dependencies in metadata.json](#dependencies-in-metadatajson) below for more details.
* `project_page` --- A link to your module's website. This will typically be the Puppet Forge.
* `issues_url` --- A link to your module's issue tracker.
* `operatingsystem_support` --- A list of operating system compatibility for your module. See [Operating system compatibility in metadata.json](#operating-system-compatibility-in-metadatajson) below for more details.
* `tags` --- A list of key words that will help others find your module (not case sensitive)(e.g. [“msyql”, “database”, “monitoring”]). Tags cannot contain whitespace. We recommend using four to six tags.

##### DEPRECATED

* `types` --- Resource type documentation generated by the puppet module tool as part of `puppet module build`. **You must [remove this field](#migrate-from-modulefile-to-metadatajson) from your metadata.json or else your module will break.**
* `checksums`--- File checksums generated by the puppet module tool as part of `puppet module build`. **You must [remove this field](#migrate-from-modulefile-to-metadatajson) from your metadata.json or else your module will break.**

### Dependencies in metadata.json

If your module's functionality depends upon functionality in another module, you can express this in the `dependencies` field of your metadata.json file. The `dependencies` field accepts an array of hashes. Here's an example from the [puppetlabs-postgresql](https://forge.puppetlabs.com/puppetlabs/postgresql) module:

    "dependencies": [
      { "name": "puppetlabs/stdlib", "version_requirement": ">=3.2.0 <5.0.0" },
      { "name": "puppetlabs/firewall", "version_requirement": ">= 0.0.4" },
      { "name": "puppetlabs/apt", "version_requirement": ">=1.1.0 <2.0.0" },
      { "name": "puppetlabs/concat", "version_requirement": ">= 1.0.0 <2.0.0" }
    ]


**Note:** Once you've generated your module and gone through the metadata.json dialog, you must manually edit the metadata.json file to include the dependency information.

> **Warning:** The full name in a dependency **must** use a slash between the username and module name. **This is different from the name format used elsewhere in metadata.json.** This is a legacy architecture problem with the Puppet Forge, and we apologize for the inconvenience. We are working on a solution.

The version requirement in a dependency isn't limited to a single version; you can use several operators for version comparisons.

* `1.2.3` --- A specific version.
* `>1.2.3` --- Greater than a specific version.
* `<1.2.3` --- Less than a specific version.
* `>=1.2.3` --- Greater than or equal to a specific version.
* `<=1.2.3` --- Less than or equal to a specific version.
* `>=1.0.0 <2.0.0` --- Range of versions; both conditions must be satisfied. (This example would match 1.0.1 but not 2.0.1)
* `1.x` --- A semantic major version. (This example would match 1.0.1 but not 2.0.1, and is shorthand for `>=1.0.0 <2.0.0`.)
* `1.2.x` --- A semantic major and minor version. (This example would match 1.2.3 but not 1.3.0, and is shorthand for `>=1.2.0 <1.3.0`.)

**Note:** You cannot mix semantic versioning shorthand (.x) with greater/less than versioning syntax. The following would be incorrect.

* `>= 3.2.x`
* `< 4.x`

### Operating system compatibility in metadata.json

If you are publishing your module to the Puppet Forge, we highly recommend that you include `operatingsystem_support` in your metadata.json. Even if you do not intend to publish your module, including this information can be helpful for tracking your work.

You can express this field through an array of hashes, classified under `operatingsystem` or `operatingsystemrelease`. `operatingsystem` will be used with Forge search filters, and `operatingsystemrelease` will be treated as strings on module pages. You can format it in either way shown below:

    "operatingsystem_support": [
      {
      "operatingsystem":"RedHat",
      "operatingsystemrelease":[ "5.0", "6.0" ]
      },
      {
      "operatingsystem": "Ubuntu",
      "operatingsystemrelease": [
        "12.04",
        "10.04"
        ]
      }
    ]

> ###A Note on Semantic Versioning
>
> When writing your metadata.json file, you're setting a version for your own module and optionally expressing dependencies on others' module versions. We strongly recommend following the [Semantic Versioning](http://semver.org/spec/v1.0.0.html) specification. Doing so allows others to rely on your modules without unexpected change.
>
> Many other users already use semantic versioning, and you can take advantage of this in your modules' dependencies. For example, if you depend on puppetlabs/stdlib and want to allow updates while avoiding breaking changes, you could write the following line in your metadata.json (assuming a current stdlib version of 4.2.1):
>
>     "dependencies": [
>       { "name": "puppetlabs/stdlib", "version_requirement": "4.x" },
>     ]

Build Your Module
------

With Puppet 3.6's updates to the puppet module tool (PMT), the process for  building your module will be slightly different based on the files in your module's directory.

* [I generated a new module using `puppet module generate`](#brand-new-module)
* [I have a Modulefile and no metadata.json](#modulefile-no-metadatajson)
* [I have a Modulefile and a metadata.json](#modulefile-and-metadatajson)
* [I have a metadata.json and no Modulefile](#metadatajson-no-modulefile)

In order for your module to be successfully uploaded to and displayed on the Forge, your metadata.json file will need to have the following [fields](#fields-in-metadatajson): name, version, author, license, summary, source, dependencies, project_page, operatingsystem_support, and tags.

### Brand new module

If you used Puppet 3.6 to run `puppet module generate` to create your module, your metadata.json file was created for you! To build your module:

1. Run `# puppet module build <MODULE DIRECTORY>`. A .tar.gz package will be generated and saved in the module's pkg/ subdirectory. For example:

~~~
    # puppet module build /etc/puppetlabs/puppet/modules/mymodule
    Building /etc/puppetlabs/puppet/modules/mymodule for release
    /etc/puppetlabs/puppet/modules/mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz
~~~

2. Navigate to your module in the pkg/ subdirectory, `#cd <username-modulename>/pkg/<username-modulename-version>`.
3. Copy the metadata.json file to the root of your module.
4. Navigate out of the pkg/ subdirectory to your module's root directory. Run `# puppet module build <MODULE DIRECTORY>` again. (If you do not rebuild your module before publishing, you will cause users of your module to face [errors][errors]).
5. Run `puppet module changes pkg/<username-modulename-version>` to determine whether your build was successful. A successful build will return: `Notice: No modified files`. An unsuccessful build will show modified files, which means you must start the process again.

### Modulefile, no metadata.json

1. Run `# puppet module build <MODULE DIRECTORY>`.
2. If you have a Modulefile but no metadata.json file, you will receive a deprecation warning when you run the build command. The PMT will build you a complete metadata.json file using the information in your Modulefile, and will place the metadata.json in both your build directory and root module directory.
3. Navigate to your module in the pkg/ subdirectory, `#cd <username-modulename>/pkg/<username-modulename-version>`.
4. Copy the metadata.json file to the root of your module.
5. Navigate out of the pkg/ subdirectory to your module's root directory. Delete your Modulefile.
6. Run `puppet module build <MODULE DIRECTORY>` again. (If you do not rebuild your module before publishing, you will cause users of your module to face [errors][errors]).
7. Run `puppet module changes pkg/<username-modulename-version>` to determine whether your build was successful. A successful build will return: `Notice: No modified files`. An unsuccessful build will show modified files, which means you must start the process again.

### Modulefile and metadata.json

1. Open the metadata.json file in your editor and remove the `types` and `checksums` fields entirely, if present.
2. Make sure your dependencies are expressed in the metadata.json and **NOT** in the Modulefile.
3. Run `# puppet module build <MODULE DIRECTORY>`. The PMT will merge your Modulefile and metadata.json files and issue a deprecation warning.
4. Navigate to your module in the pkg/ subdirectory, `#cd <username-modulename>/pkg/<username-modulename-version>`.
5. Copy the metadata.json file to the root of your module.
6. Navigate out of the pkg/ subdirectory to your module's root directory. Delete your Modulefile.
7. Run `# puppet module build <MODULE DIRECTORY>` again. (If you do not rebuild your module before publishing, you will cause users of your module to face [errors][errors]).
8. Run `puppet module changes pkg/<username-modulename-version>` to determine whether your build was successful. A successful build will return: `Notice: No modified files`. An unsuccessful build will show modified files, which means you must start the process again.

### metadata.json, no Modulefile

1. Open the metadata.json file in your editor and remove the `types` and `checksums` fields entirely, if present.
2. Run `# puppet module build <MODULE DIRECTORY>`.
3. Navigate to your module in the pkg/ subdirectory, `#cd <username-modulename>/pkg/<username-modulename-version>`.
4. Copy the metadata.json file to the root of your module.
5. Navigate out of the pkg/ subdirectory to your module's root directory. Run `# puppet module build <MODULE DIRECTORY>` again. (If you do not rebuild your module before publishing, you will cause users of your module to face [errors][errors]).
6. Run `puppet module changes pkg/<username-modulename-version>` to determine whether your build was successful. A successful build will return: `Notice: No modified files`. An unsuccessful build will show modified files, which means you must start the process again.

Upload to the Puppet Forge
------

Now that you have a compiled `tar.gz` package, you can upload it to the Puppet Forge. *Note:* Your tarball must be 10MB or less. There is currently no command line tool for publishing; you must use the Puppet Forge's web interface.

In your web browser, navigate [to the Puppet Forge][forge] and log in.

### Create a Module Page

If you have never published this module before, you must create a new page for it.

1. Click the "Publish a Module" in the sidebar:

![the "publish a module"" link in the Forge's sidebar][publishmodule]

2. Fill in the module form that opens. Only the "Module Name" field is required. **Use the module's short name, not the long `username-module` name.**

3. Click the "Publish Module" button at the bottom of the form. Doing so automatically takes you to the new module page.

### Create a Release

1. Navigate to the module's page if you are not already there, and click the "Click here to upload your tarball" link:

![the "upload a tarball" link on a module's page][uploadtarball]

This will bring you to the upload form:

![the upload form for a new release of a module][uploadtarball2]

2. Click "Choose File" and use the file browser to locate and select the release tarball you created with the `puppet module build` action. Then click the "Upload Release" link.

Your module has now been published to the Puppet Forge. The Forge will pull your README, Changelog, and License files from your tarball to display on your module's page. To confirm that it was published correctly, you can [install it][installing] on a new system using the `puppet module install` action.


Release a New Version
-----

1. To release a new version of an already published module, make any necessary edits to your module, and then increment the `version` field in the metadata.json file (ensuring you use a valid [semantic version](http://semver.org/)).

2. When you're ready to publish your new version, navigate [to the Puppet Forge][forge] and log in if necessary. Click the "Upload a New Release" link:

![the upload a new release link][forgenewrelease]

This will bring you to the upload form as mentioned in [Create a Release](#create-a-release) above, where you can select the new release tarball and upload the release.
