---
layout: default
nav: puppet27.html
title: "Publishing Modules on the Forge"
---


[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html


Publishing Modules on the Forge
=====

**This is a placeholder page, which will be fleshed out further at a later date. We know what should be on it, but haven't had a chance to write it yet.**

* Continue reading to learn how to publish your modules to the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] for how to write and use your own Puppet modules.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.


Write a valid `Modulefile`
--------------------------

The Modulefile resembles a configuration or data file, but is actually a Ruby domain-specific language (DSL), which means it's evaluated as code by the puppet-module tool. A Modulefile consists of a series of method calls which write or append to the available fields in the metadata object.

Normal rules of Ruby syntax apply:

    name 'myuser-mymodule'
    version '0.0.1'
    dependency( 'otheruser-othermodule', '1.2.3' )
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
