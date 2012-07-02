---
layout: legacy
nav: puppet27.html
title: "Publishing Modules on the Forge"
---


[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[forge]: https://forge.puppetlabs.com/


Publishing Modules on the Forge
=====

* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.

Create a Forge Account
--------

Before you begin, you should create a forge account. This account name will be used to uniquely identify your set of modules and will be required during module packaging, so its best to do this early.

Start by navigating to the [Forge website][forge] and selecting 'Register'. Fill in your details, and you will be asked to verify your email address via a verification email. Once this has been done, you are ready to move on.

Module Template Generation
--------

The puppet module face has the ability to generate a template for you to get started developing a module. While this is optional, it does help get you up and running. If you already have content that you wish to publish, skip ahead to creating your Modulefile.

To get started, you need to run the module generate command using the following convention:

    puppet module generate <forgeusername>-<modulename>

As an example, say if your username was 'fred' and you wanted to publish a module called 'mymodule'. You could run the command as such:

    # puppet module generate fred-mymodule
    Generating module at /Users/fred/Development/fred-mymodule
    fred-mymodule
    fred-mymodule/tests
    fred-mymodule/tests/init.pp
    fred-mymodule/spec
    fred-mymodule/spec/spec_helper.rb
    fred-mymodule/README
    fred-mymodule/Modulefile
    fred-mymodule/manifests
    fred-mymodule/manifests/init.pp

Now you can either start modifying the content as provided, or if you already have module content you can being to copy it over into the template.

For more information on the details of module development [see “Module Fundamentals”][fundamentals] for how to write and use your own Puppet modules.

Writing a valid `Modulefile`
--------------------------

The Modulefile resembles a configuration or data file, but is actually a Ruby domain-specific language (DSL), which means it's evaluated as code by the puppet-module tool. A Modulefile consists of a series of method calls which write or append to the available fields in the metadata object.

Normal rules of Ruby syntax apply:

    name 'myuser-mymodule'
    version '0.0.1'
    dependency 'otheruser-othermodule', '1.2.3'
    description "This is a full description
        of the module, and is being written as a multi-line string."

The following metadata fields/methods are available:

* `name` -- The full name of the module (e.g. "username-module").
* `version` -- The current version of the module.
* `dependency` -- A module that this module depends on. Unlike the other fields, the `dependency` method accepts up to three arguments: a module name, a version requirement, and a repository. A Modulefile may include multiple `dependency` lines.
* `source` -- The module's source. The use of this field is not specified.
* `author` -- The module's author. If not specified, this field will default to the username portion of the module's `name` field.
* `license` -- The license under which the module is made available.
* `summary` -- One-line description of the module.
* `description` -- Complete description of the module.
* `project_page` -- The module's website.

Building your module
------

Now that you have the content and Modulefile created, you can build your module by running the following command:

    puppet module build <moduledir>

This will generate a package in `tar.gz` format for you in the modules `pkg/` directory.

For example:

    # puppet module build fred-mymodule 
    Building /Users/fred/Development/fred-mymodule for release
    fred-mymodule/pkg/fred-mymodule-0.0.1.tar.gz

Publishing your module on the forge
------

Now that you have your ready-built `tar.gz` file, you can publish this on the Forge.

First of all, navigate [to the Forge][forge] and login as yourself. Create a module by clicking on the link for 'Add a module'. Fill in all the required fields, especially the name of the module. The name of the module must match the name you specified in the `Modulefile`.

Once that is complete you must then `Add a release` to the module you have just created. Choose the `tar.gz` file that was created with the `puppet module build` action, and enter some release notes if applicable and click `Add release`.

Congratulations, you should now have a published module. To confirm everything is okay test its functionality by trying to [install it][installing] on your own systems.
