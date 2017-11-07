---
layout: default
title: "Publishing Modules on the Puppet Forge"
canonical: "/puppet/latest/modules_publishing.html"
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
[yourmodules]: ./images/yourmodules.png
[selectrelease]: ./images/selectrelease.png
[deletebutton]: ./images/deletebutton.png
[deletionpage]: ./images/deletionpage.png
[deleteconfirmation]: ./images/deleteconfirmation.png
[deletedrelease]: ./images/deletedrelease.png
[delteddownloadwarning]: ./images/delteddownloadwarning.png
[onereleasesearch]: ./images/onereleasesearch.png
[noreleasesearch]: ./images/noreleasesearch.png
[noreleasesearchfilter]: ./images/noreleasesearchfilter.png


Publishing Modules on the Puppet Forge
=====

The Puppet Forge is a community repository of modules, written and contributed by  Puppet Open Source and Puppet Enterprise users. Using the Puppet Forge (Forge) is a great way to build on the work others have done and get updates and expansions on your own module work. This document describes how to publish your own modules to the Forge so that other users can [install][installing] them, as well as how to maintain your releases once published.


* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.

Overview
-----

This guide assumes that you have already [written a useful Puppet module][fundamentals]. To publish your module, you will need to:

1. Create a Puppet Forge account, if you don't already have one.
2. Prepare your module.
3. Write a metadata.json file with the required metadata.
4. Build an uploadable tarball of your module.
5. Upload your module using the Puppet Forge's web interface.

### A note on module names
Because many users have published their own versions of modules with common names ("mysql," "bacula," etc.), the Puppet Forge (Forge) requires module names to have a username prefix. That is, if a user named "puppetlabs" maintained a "mysql" module, it would be known to the Forge as "puppetlabs-mysql".**Be sure to use this long name in your module's [metadata.json file](#write-a-metadatajson-file).**

As of Puppet 4, your module's directory cannot share this long name, as module directory names cannot contain dashes or periods (only letters, numbers, and underscores). Using the the build action will do the right thing as long as the metadata.json is correct.

### Another note on module names
Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style in your metadata files and when issuing commands.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge (Forge). You will need to know your username when publishing any of your modules.

1. Start by navigating to the [Forge website][forge] and clicking the "Sign Up" link in the sidebar:

![The "sign up" link in the Puppet Forge sidebar][signup]

2. Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Forge.

Prepare the Module
-----

If you already have a Puppet module with the [correct directory layout][fundamentals], you may continue to the next step.

Alternately, you can use the `puppet module generate` action to generate a template layout. Generating a module will provide you with a sample README and a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. It will also launch a series of questions that will create your metadata.json file.

Follow the directions to [generate a new module](https://docs.puppetlabs.com/puppet/latest/modules_fundamentals.html#writing-modules)

### Set files to be ignored

It's not unusual to have some files in your module that you want to exclude from your build. You may exclude files by including them in .gitgnore or .pmtignore. Your .pmtignore or .gitignore file must be in the module's root directory, and will be read during the build process.

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

* `name` --- REQUIRED. The full name of your module, including the username (e.g. "username-module" --- [see note above](#a-note-on-module-names)).
* `version` --- REQUIRED. The current version of your module. This should be a [semantic version](http://semver.org/).
* `author` --- REQUIRED. The person who gets credit for creating the module. If not provided, this field will default to the username portion of the `name` field.
* `license` --- REQUIRED. The license under which your module is made available. License metadata should match an identifier provided by [SPDX](http://spdx.org/licenses/).
* `summary` --- REQUIRED. A one-line description of your module.
* `source` --- REQUIRED. The source repository for your module.
* `dependencies` --- REQUIRED. A list of the other modules that your module depends on to function. See [Dependencies in metadata.json](#dependencies-in-metadatajson) below for more details.
* `project_page` --- A link to your module's website that will be linked on the Forge.
* `issues_url` --- A link to your module's issue tracker.
* `operatingsystem_support` --- A list of operating system compatibility for your module. See [Operating system compatibility in metadata.json](#operating-system-compatibility-in-metadatajson) below for more details.
* `tags` --- A list of key words that will help others find your module (not case sensitive)(e.g. `["msyql", "database", "monitoring"]`). Tags cannot contain whitespace. We recommend using four to six tags. Note that certain tags are prohibited, including profanity and anything resembling the `$::operatingsystem` fact, including, but not necessarily limited to: `redhat`, `centos`, `rhel`, `debian`, `ubuntu`, `solaris`, `sles`, `aix`, `windows`, `darwin`, and `osx`. Use of prohibited tags will lower your module's quality score on the Forge.

##### DEPRECATED

* `types` --- Resource type documentation generated by older versions of the Puppet module tool as part of `puppet module build`. **You should remove this field from your metadata.json.**

### Dependencies in metadata.json

If your module's functionality depends upon functionality in another module, you can express this in the `dependencies` field of your metadata.json file. The `dependencies` field accepts an array of hashes. Here's an example from the [puppetlabs-postgresql](https://forge.puppetlabs.com/puppetlabs/postgresql) module:

~~~
    "dependencies": [
      { "name": "puppetlabs/stdlib", "version_requirement": ">=3.2.0 <5.0.0" },
      { "name": "puppetlabs/firewall", "version_requirement": ">= 0.0.4" },
      { "name": "puppetlabs/apt", "version_requirement": ">=1.1.0 <2.0.0" },
      { "name": "puppetlabs/concat", "version_requirement": ">= 1.0.0 <2.0.0" }
    ]
~~~

**Note:** Once you've generated your module and gone through the metadata.json dialog, you must manually edit the metadata.json file to include the dependency information.

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

If you are publishing your module to the Forge, we highly recommend that you include `operatingsystem_support` in your metadata.json. Even if you do not intend to publish your module, including this information can be helpful for tracking your work.

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

Since the numeric values corresponding to `operatingsystemrelease` are strings, they can be formatted in any way that makes sense to the operating system in question. Setting `operatingsystemrelease` to '6' indicates that your module is compatible with the entire 6.x series of that operating system.  If you know it to be incompatible with versions in that series you should be more specific (for example, Ubuntu 14.04 and 14.10 are two different major releases).

### A Note on Semantic Versioning

When writing your metadata.json file, you're setting a version for your own module and optionally expressing dependencies on others' module versions. We strongly recommend following the [Semantic Versioning](http://semver.org/spec/v1.0.0.html) specification. Doing so allows others to rely on your modules without unexpected change.

Many other users already use semantic versioning, and you can take advantage of this in your modules' dependencies. For example, if you depend on puppetlabs-stdlib and want to allow updates while avoiding breaking changes, you could write the following line in your metadata.json (assuming a current stdlib version of 4.2.1):

~~~
     "dependencies": [
       { "name": "puppetlabs/stdlib", "version_requirement": "4.x" },
     ]
~~~

Build Your Module
------
In order for your module to be successfully uploaded to and displayed on the Forge, your metadata.json file will need to have the following [fields](#fields-in-metadatajson): name, version, author, license, summary, source, dependencies, project_page, operatingsystem_support, and tags.

To build your module:

1. Run `# puppet module build <MODULE DIRECTORY>`. A .tar.gz package will be generated and saved in the module's pkg/ subdirectory. For example:

~~~
# puppet module build /etc/puppetlabs/puppet/modules/mymodule
Building /etc/puppetlabs/puppet/modules/mymodule for release
/etc/puppetlabs/puppet/modules/mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz
~~~

>**Note:**
>
>Throughout the Puppet 3.x series, deprecation warnings were issued for Modulefile. If you still have a Modulefile, it will be treated like any other text file in the root directory of the module. You will need to move any metadata contained in it to the [metadata.json](#write-a-metadatajson-file).

Upload to the Puppet Forge
------

Now that you have a compiled `tar.gz` package, you can upload it to the Forge. There is currently no command line tool for publishing; you must use the Forge's web interface. *Note:* Your tarball must be 10MB or less.

Whether you are uploading a brand new module or a new release of an existing module, follow the steps below to publish your release:

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

Delete a Release
----

At some point, you may want to delete a release of your module. You can accomplish this easily from the Forge's web interface.

>**Note**
>
>A deleted release will still be downloadable via the Forge page or Puppet module tool (PMT) if a user requests the module by specific version. **You cannot delete a released version and upload a new version of the same release.**

Follow the steps below to delete your release:

1. In your web browser, navigate [to the Puppet Forge][forge] and log in.

2. Click **Your Modules**.


   ![your modules button][yourmodules]

3. Go to the module page of the module whose release you want to delete.

4. Locate **Select another release**, choose the release you want from the drop down, and click **Delete**.


   ![select the release to delete][selectrelease]


   ![delete][deletebutton]

5. You will be taken to a new page. On that page, you must supply a reason for the deletion. **Note:** Your reason will be visible to users on the Forge.


   ![deletion page][deletionpage]

6. Click **Yes, delete it.**

7. On your module page, you will see a banner confirmation of the deletion.


   ![confirmation banner][deleteconfirmation]


Once you receive the confirmation banner, your release is officially deleted!

## Downloading a Deleted Release

It is still possible to download a specific release of a module, even if it has been deleted. If you check the **Select another release** drop down, the release is still an option in the menu, but is marked as deleted.

   ![the deleted release is still there][deletedrelease]

If you select the deleted release, a warning banner will appear on the page with the reason for deletion. However, you can still download the deleted release using the PMT or by clicking **Download**.

   ![download deleted release][delteddownloadwarning]

## Searching For a Deleted Module

If the only release of a module is deleted, or if all the releases of a module are deleted, the module will still show up in the Forge's search under some circumstances.

For example, puppetlabs-appdirector has only one release. It is the only result when we search for the word 'appdirector'.

   ![one module one release][onereleasesearch]

If that one release is deleted and we search for the word 'appdirector', no results are found.

   ![no module][noreleasesearch]

However, if we check the box to **Include deleted modules** in our search, the appdirector module is found.

  ![there it is][noreleasesearchfilter]
