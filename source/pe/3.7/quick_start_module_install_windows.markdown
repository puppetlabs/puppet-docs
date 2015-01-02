---
layout: default
title: "PE 3.7 » Quick Start » Module Installation (Windows)"
subtitle: "Module Installation Quick Start Guide"
canonical: "/pe/latest/quick_start_module_install_windows.html"
---

### Overview

In this guide, you'll install the puppetlabs-registry module, a Puppet Enterprise supported module. Modules contain [classes](../puppet/3/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures and manages nodes.

The [Puppet Labs Forge](http://forge.puppetlabs.com) contains thousands of modules submitted by users and Puppet Labs module developers that you can use. In addition, PE customers can take advantage PE customers can take advantage of [supported modules](http://forge.puppetlabs.com/supported); these modules--designed to make common services easier--are tested, and maintained by Puppet Labs.

In [Module Writing Basics for Windows QSG](./quick_writing_windows.html) you'll learn more about modules, including how to customize and write your own modules on either  [Windows](./quick_writing_windows.html) or [*nix](./quick_writing_nix.html) platforms.

The process for installing a module is the same on both Windows and *nix operating systems.

> **Prerequisites**: This guide assumes you've already [installed a monolithic PE deployment](./quick_start_install_mono.html), and have installed at least one [Windows agent node](./quick_start_install_agents_windows.html).

### Installing a Forge Module

1. **On the Puppet master**, run `puppet module search registry`. This searches for modules from the Puppet Forge with `registry` in their names or descriptions and results in something like:

        Searching http://forgeapi.puppetlabs.com ...
        NAME                 DESCRIPTION               AUTHOR        KEYWORDS
        puppetlabs-registry  This module provides...   @puppetlabs   type registry

   The module you want is `puppetlabs-registy`. You can view detailed info about the module in the ["ReadMe" on the Puppet Forge](https://forge.puppetlabs.com/puppetlabs/registry).

2. To install the module, run `puppet module install puppetlabs-registry`. Here’s what happens:

        Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/environments/production/modules
        └── puppetlabs-registry (v1.0.2)

> You have just installed a Puppet module. All of the classes in the module are now available to be added to the console and assigned to nodes.

> #### A Quick Note about Modules Directories
>
>By default, the modules you use to manage nodes are located in `/etc/puppetlabs/puppet/environments/production/modules`---this includes modules installed by PE, those that you download from the Forge, and those you write yourself.
>
>**Note**: PE installs additional modules in `/opt/puppet/share/puppet/modules`. These must not be modified, and you should not add your own modules to this directory, as they may be removed during upgrades.


--------

Next: [Adding Classes to Puppet Agent Nodes (Windows)](./latest/quick_start_adding_class_windows.html)

