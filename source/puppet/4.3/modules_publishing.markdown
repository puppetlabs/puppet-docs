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
[metadata]: ./modules_metadata.html

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

### A Note on Module Names

Because many users have published their own versions of modules with common names ("mysql," "bacula," etc.), the Puppet Forge (Forge) requires module names to have a username prefix. That is, if a user named "puppetlabs" maintained a "mysql" module, it would be known to the Forge as "puppetlabs-mysql". **Be sure to use this long name in your module's [metadata.json file][inpage_metadata].**

However, your module's directory on disk must use the short name, without the username prefix. (Module directory names cannot contain dashes or periods; only letters, numbers, and underscores). Using the the build action will do the right thing as long as the metadata.json is correct.

### Another Note on Module Names

Although the Puppet Forge expects to receive modules named `username-module`, its web interface presents them as `username/module`. There isn't a good reason for this, and we are working on reconciling the two; in the meantime, be sure to always use the `username-module` style in your metadata files and when issuing commands.

Create a Puppet Forge Account
--------

Before you begin, you should create a user account on the Puppet Forge (Forge). You will need to know your username when publishing any of your modules.

1. Start by navigating to the [Forge website][forge] and clicking the "Sign Up" link in the sidebar:

![The "sign up" link in the Puppet Forge sidebar][signup]

2. Fill in your details. After you finish, you will be asked to verify your email address via a verification email. Once you have done so, you can publish modules to the Forge.

Prepare the Module
-----

If you already have a Puppet module with the [correct directory layout][fundamentals], you can continue to the next step.

Alternately, you can use the `puppet module generate` action to generate a template layout. Generating a module will provide you with a sample README and a copy of the `spec_helper` tool for writing [rspec-puppet][rspec] tests. It will also launch a series of questions that will create your metadata.json file.

Follow the directions to [generate a new module](./modules_fundamentals.html#writing-modules).

>**Note:** In order to successfully publish your module to the Puppet Forge and ensure everything can be rendered correctly, your README, license file, changelog, and metadata.json must be UTF-8 encoded.

### Set Files to Be Ignored

It's not unusual to have some files in your module that you want to exclude from your build. You can exclude files by including them in .gitgnore or .pmtignore. Your .pmtignore or .gitignore file must be in the module's root directory, and will be read during the build process.

If you have both a .pmtignore and a .gitignore file, the Puppet module tool will read the .pmtignore file over the .gitignore.

### Remove Symlinks

Before you build your module, you must make sure that symlinks are either removed or set to be [ignored](#set-files-to-be-ignored). If you try to build a module with symlinks, you will recieve the following error:

~~~
Warning: Symlinks in modules are unsupported. Please investigate symlink manifests/foo.pp->manifests/init.pp.
Error: Found symlinks. Symlinks in modules are not allowed, please remove them.
Error: Try 'puppet help module build' for usage
~~~

Write a metadata.json File
-----

[inpage_metadata]: #write-a-metadatajson-file

If you generated your module using the `puppet module generate` command, you'll already have a metadata.json file. Check it and make any necessary edits.

If you assembled your module manually, you must make sure that you have a metadata.json file in your module's main directory.

[See the page about `metadata.json` for full details about its format.][metadata]


Build Your Module
------
In order for your module to be successfully uploaded to and displayed on the Forge, your [metadata.json][] file must include the following keys:

* `name`
* `version`
* `author`
* `license`
* `summary`
* `source`
* `dependencies`
* `project_page`
* `operatingsystem_support`
* `tags`

To build your module:

1. Run `# puppet module build <MODULE DIRECTORY>`. A .tar.gz package will be generated and saved in the module's pkg/ subdirectory. For example:

~~~
# puppet module build /etc/puppetlabs/puppet/modules/mymodule
Building /etc/puppetlabs/puppet/modules/mymodule for release
/etc/puppetlabs/puppet/modules/mymodule/pkg/examplecorp-mymodule-0.0.1.tar.gz
~~~

>**Note:**
>
>Throughout the Puppet 3.x series, deprecation warnings were issued for Modulefile. If you still have a Modulefile, it will be treated like any other text file in the root directory of the module. You will need to move any metadata contained in it to the [metadata.json][inpage_metadata].

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

1. You must make sure that your [metadata][inpage_metadata] is correct and entirely located in metadata.json, otherwise your module will either not display correctly on the Forge or will error out during upload.
2. When you release a new version of an already published module, you must increment the `version` field in the metadata.json file (ensuring you use a valid [semantic version](http://semver.org/)).
3. You are highly encouraged to fix any problems or mistakes with your module by issuing another release.

Delete a Release
----

At some point, you might want to delete a release of your module. You can accomplish this easily from the Forge's web interface.

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
