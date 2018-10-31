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

The Puppet Forge is a community repository of modules, written and contributed by  Puppet Open Source and Puppet Enterprise users. Using the Puppet Forge is a great way to build on the work others have done and get updates and expansions on your own module work. This document describes how to publish your own modules to the Puppet Forge so that other users can [install][installing] them.


* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.

>**DEPRECATION WARNING** As of Puppet 3.6 the Modulefile has been deprecated in favor of the metadata.json file. We strongly suggest that you use `puppet module generate` to create new modules, as it now includes a dialog for creating your metadata.json. You can read more about how to [deal with your Modulefile](#build-your-module) below.


Overview
-----

This guide assumes that you have already [written a useful Puppet module][fundamentals]. To publish your module, you will need to:

1. Create a Puppet Forge account, if you don't already have one.
2. Prepare your module.
3. Write a metadata.json file with the required metadata.
4. Build an uploadable tarball of your module.
5. Upload your module using the Puppet Forge's web interface.

> ### A note on module names
>
> Because many users have published their own versions of modules with common names ("mysql," "bacula," etc.), the Puppet Forge requires module names to have a username prefix. That is, if a user named "puppetlabs" maintained a "mysql" module, it would be known to the Puppet Forge as "puppetlabs-mysql".
>
> **Be sure to use this long name in your module's [metadata.json file](#write-a-metadatajson-file).** However, you do not have to rename the module's directory, and can leave the module in your active modulepath --- the build action will do the right thing as long as the metadata.json is correct.

> ### Another note on module names
>
> Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style in your metadata files and when issuing commands.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge. You will need to know your username when publishing any of your modules.

1. Start by navigating to the [Puppet Forge website][forge] and clicking the "Sign Up" link in the sidebar:

![The "sign up" link in the Puppet Forge sidebar][signup]

2. Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Puppet Forge.

Prepare the Module
-----

If you already have a Puppet module with the [correct directory layout][fundamentals], you may continue to the next step.

Alternately, you can use the `puppet module generate` action to generate a template layout. Generating a module will provide you with a sample README and a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. It will also launch a series of questions that will create your metadata.json file. If you decided to construct a module on your own first, you will need to manually copy that module's files into the generated module.

Follow the directions to [generate a new module](https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html#writing-modules)

### Set files to be ignored

It's not unusual to have some files in your module that you want to exclude from your build. You may exclude files by including them in .gitgnore or .pmtignore. To be read during the build process, your .pmtignore or .gitignore file must be in the module's root directory.

If you have both a .pmtignore and a .gitignore file, the Puppet module tool will read the .pmtignore file over the .gitignore.

### Remove symlinks

Before you build your module, you must make sure that symlinks are either removed or set to be [ignored](#set-files-to-be-ignored). If you try to build a module with symlinks, you will recieve the following error:

~~~
Warning: Symlinks in modules are unsupported. Please investigate symlink manifests/foo.pp->manifests/init.pp.
Error: Found symlinks. Symlinks in modules are not allowed, please remove them.
Error: Try 'puppet help module build' for usage
~~~

Write a metadata.json File
-----

If you generated your module using the `puppet module generate` command, you'll already have a metadata.json file. If you put your module together without using the `puppet module generate` command, you must make sure that you have a metadata.json file in your module's main directory.

The metadata.json is a JSON-formatted file containing information about your module, such as its name, version, and dependencies.

Your metadata.json will look something like

    {
      "name": "examplecorp-mymodule",
      "version": "0.0.1",
      "author": "Pat",
      "license": "Apache-2.0",
      "summary": "A module for a thing",
      "source": "https://github.com/examplecorp/examplecorp-mymodule",
      "project_page": "https://forge.puppetlabs.com/examplecorp/mymodule",
      "issues_url": "https://github.com/examplecorp/examplecorp-mymodule/issues",
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
       ],
      "dependencies": [
        { "name": "puppetlabs/stdlib", "version_requirement": ">=3.2.0 <5.0.0" },
        { "name": "puppetlabs/firewall", "version_requirement": ">= 0.0.4" }
      ]
    }

### Fields in metadata.json

* `name` --- REQUIRED. The **full name** of your module, including the username (e.g. "username-module" --- [see note above](#a-note-on-module-names)).
* `version` --- REQUIRED. The current version of your module. This should be a [semantic version](http://semver.org/).
* `author` --- REQUIRED. The person who gets credit for creating the module. If not provided, this field will default to the username portion of the `name` field.
* `license` --- REQUIRED. The license under which your module is made available. License metadata should match an identifier provided by [SPDX](http://spdx.org/licenses/).
* `summary` --- REQUIRED. A one-line description of your module.
* `source` --- REQUIRED. The source repository for your module.
* `dependencies` --- REQUIRED. A list of the other modules that your module depends on to function. See [Dependencies in metadata.json](#dependencies-in-metadatajson) below for more details.
* `project_page` --- A link to your module's website. This will typically be the Puppet Forge.
* `issues_url` --- A link to your module's issue tracker.
* `operatingsystem_support` --- A list of operating system compatibility for your module. See [Operating system compatibility in metadata.json](#operating-system-compatibility-in-metadatajson) below for more details.
* `tags` --- A list of key words that will help others find your module (not case sensitive)(e.g. [“mysql”, “database”, “monitoring”]). Tags cannot contain whitespace. We recommend using four to six tags. Note that certain tags are prohibited including profanity, and anything resembling the `$::operatingsystem` fact, including, but not necessarily limited to: `redhat`, `centos`, `rhel`, `debian`, `ubuntu`, `solaris`, `sles`, `aix`, `windows`, `darwin`, and `osx`. Use of prohibited tags will lower your module's quality score on the Forge.


##### DEPRECATED

* `checksums`--- File checksums generated by the Puppet module tool as part of `puppet module build`. **You should remove this field from your metadata.json.**
* `description` --- Legacy field used to describe the purpose of the module. You should use the `summary` field instead.
* `types` --- Resource type documentation generated by the Puppet module tool as part of `puppet module build`. **You should remove this field from your metadata.json.**

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

##### DEPRECATED

* `versionRequirement`--- Another way of specifying `version_requirement`, `versionRequirement` was never officially supported and is slated for removal in Puppet 4. Please use `version_requirement` as noted above instead. 

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

> ### A Note on Semantic Versioning
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

The process for  building your module will be slightly different based on the files in your module's directory.

* [I generated a new module using `puppet module generate`](#brand-new-module)
* [I have a Modulefile and no metadata.json](#modulefile-no-metadatajson)
* [I have a Modulefile and a metadata.json](#modulefile-and-metadatajson)
* [I have a metadata.json and no Modulefile](#metadatajson-no-modulefile)

In order for your module to be successfully uploaded to and displayed on the Forge, your metadata.json file will need to have the following [fields](#fields-in-metadatajson): name, version, author, license, summary, source, dependencies, project_page, operatingsystem_support, and tags.

### Brand new module

If you used Puppet 3.6+ to run Puppet module generate to create your module, your metadata.json file was created for you! To build your module:

1. Run `# puppet module build <MODULE DIRECTORY>`. A .tar.gz package will be generated and saved in the module’s pkg/ subdirectory. For example:

~~~
# puppet module build /etc/puppetlabs/puppet/modules/mymodule
Building /etc/puppetlabs/puppet/modules/mymodule for release
/etc/puppetlabs/puppet/modules/mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz
~~~

### Modulefile, no metadata.json

1. Run `# puppet module build <MODULE DIRECTORY>`.
2. If you have a Modulefile but no metadata.json file, you will receive a deprecation warning when you run the build command. The PMT will build you a complete metadata.json file using the information in your Modulefile, and will place the metadata.json in both your build directory and root module directory.
3. In your module’s root directory, delete your Modulefile.

### Modulefile and metadata.json

1. Run `# puppet module build <MODULE DIRECTORY>`. The PMT will merge your Modulefile and metadata.json files and issue a deprecation warning.
2. In your module’s root directory, delete your Modulefile.

### metadata.json, no Modulefile

1. Make sure, before you build, that your metadata.json contains all of the fields required for publishing to the Forge.
2. Run `# puppet module build <MODULE DIRECTORY>`. A .tar.gz package will be generated and saved in the module’s pkg/ subdirectory.

Upload to the Puppet Forge
------

Now that you have a compiled `tar.gz` package, you can upload it to the Puppet Forge. *Note:* Your tarball must be 10MB or less. There is currently no command line tool for publishing; you must use the Puppet Forge's web interface.

If you are uploading a brand new module, you no longer need to create a page for it! Releasing a new module follows the same process as releasing a new version of a module.

1. In your web browser, navigate [to the Puppet Forge][forge] and log in.

2. Click on "Publish" in the upper right hand corner of the screen.


   ![publish a module][publishmodule]

3. This will bring you to the upload page:


   ![upload a tarball][uploadtarball]

4. Click "Choose File" and use the file browser to locate and select the release tarball you created with the `puppet module build` action. Then click the "Upload Release" link.

5. A successful upload will result in you being taken to the new release page of your module. Any errors will come up on the same screen. Once your module has been published to the Puppet Forge, the Forge will pull your README, Changelog, and License files from your tarball to display on your module's page. To confirm that it was published correctly, you can [install it][installing] on a new system using the `puppet module install` action.


#### Notes

1. You must make sure that your [metadata](#write-a-metadatajson-file) is correct and entirely located in metadata.json, otherwise your module will either not display correctly on the Forge or will error out during upload.
2. When you release a new version of an already published module, you must increment the `version` field in the metadata.json file (ensuring you use a valid [semantic version](http://semver.org/)).
3. You are highly encouraged to fix any problems or mistakes with your module by issuing another release.
