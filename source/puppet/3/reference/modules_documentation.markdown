---
layout: default
title: "Documenting Modules"
canonical: "/puppet/latest/reference/modules_documentation.html"
---

[installing]: ./modules_installing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[publishing]: ./modules_publishing.html
[template]: ./READMEtemplate.txt
[forge]: https://forge.puppetlabs.com/

Documenting Modules
=====

You are encouraged to document any module you write, whether you intend the module solely for internal use or for publication on the [Puppet Forge][forge]. Documenting your module will help future-you remember what your module was built to do and can help explain why you chose to do things one way versus another. And anyone else using your module will definitely appreciate it.

There is a [README template][template] to assist you in putting together complete and clear documentation.

* Continue reading to learn README best practices.
* [See "Installing Modules"][installing] for how to install pre-built modules from the Puppet Forge.
* [See "Publishing Modules"][publishing] for how to publish your modules to the Puppet Forge.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.


README Template
---

Below we will walk through the template. If you would like a standalone copy of the template, you can find it [here][template].

We start with listing the module's name, followed by a table of contents.

    #modulename

    ####Table of Contents

    1. [Overview](#overview)
    2. [Module Description - What the module does and why it is useful](#module-description)
    3. [Setup - The basics of getting started with [Modulename]](#setup)
        * [What [Modulename] affects](#what-[modulename]-affects)
        * [Setup requirements](#setup-requirements)
        * [Beginning with [Modulename]](#beginning-with-[Modulename])
    4. [Usage - Configuration options and additional functionality](#usage)
    5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    5. [Limitations - OS compatibility, etc.](#limitations)
    6. [Development - Guide for contributing to the module](#development)

The table of contents is optional but suggested as best practice, particularly for larger or more complicated modules.

The table of contents is followed by a brief, overview summary of your module.

    ##Overview

    A one-maybe-two sentence summary of what the module does/what problem it solves. This is your 30 second elevator pitch for your module. Consider including OS/Puppet version it works with.

For modules used internally, the overview section may be omitted.

The overview is followed by a more-detailed description of your module.

    ##Module Description

    If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"

    If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

The module description is the section that will explain to future-you why present-you created the module and what you were trying to do with it.

Then we get to the parts dealing with actually using the module, beginning with setting the module up.

    ##Setup

    ###What [Modulename] affects

    * A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
    * This is a great place to stick any warnings.
    * Can be in list or paragraph form.

    ###Setup Requirements **OPTIONAL**

    If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here.

    ###Beginning with [Modulename]

    The very basic steps needed for a user to get the module up and running.

    If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

The setup section is really intended as a guide to getting the module installed and running at a very basic level so the user can get a sense of what it does and how it works in their environment.

After setting the module up, the template moves on to using the module and configuring it to a user or environment's particular needs.

    ##Usage

    Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here.

`If you only fill out one section, make it the usage section.

All of the technical details come through in the reference section.

    ##Reference

    Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

As it notes, the reference section is in the process of being automated.

Finally, include any additional information about your module and its limitations, contribution requirements, etc.

    ##Limitations

    This is where you list OS compatibility, version compatibility, etc.

    ##Development

    Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

    ##Release Notes/Contributors/Etc **Optional**

    If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.

Style guide for module documentation is coming soon!