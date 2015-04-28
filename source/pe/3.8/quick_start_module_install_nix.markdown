---
layout: default
title: "PE 3.8 » Quick Start » Module Installation (*nix)"
subtitle: "Module Installation Quick Start Guide"
canonical: "/pe/latest/quick_start_module_install_nix.html"
---

## Overview

In this guide, you'll install the puppetlabs-apache module, a Puppet Enterprise supported module. Modules contain [classes](/puppet/3.8/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures and manages nodes.  While you can use any module available on the Forge, PE customers can take advantage of [supported modules](http://forge.puppetlabs.com/supported); these modules--designed to make common services easier--are tested, and maintained by Puppet Labs.

In the [Module Writing Basics for Linux QSG](./quick_writing_nix.html) you'll learn more about modules, including customizing and writing your own modules on either [Windows](./quick_writing_windows.html) or [*nix](./quick_writing_nix.html) platforms.

The process for installing a module is the same on both Windows and *nix operating systems.

> **Prerequisites**: This guide assumes you've already [installed a monolithic PE deployment](./quick_start_install_mono.html), and have installed at least one [*nix agent node](./quick_start_install_agents_nix.html).

## Installing a Forge Module

1. **On the Puppet master**, run `puppet module search apache`. This command searches for modules from the Puppet Forge with `apache` in their names or descriptions.

   Your search will have a list of results that are displayed as follows:

        Searching http://forgeapi.puppetlabs.com ...
        NAME                  DESCRIPTION                           AUTHOR        KEYWORDS
        puppetlabs-apache     Puppet module for apache              @puppetlabs   apache


   You can view detailed info about the module on the [Forge](http://forge.puppetlabs.com/puppetlabs/apache).

2. To install the Apache module, run, `puppet module install puppetlabs-apache`. The result looks like this:

        Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/environments/production/modules
        └── puppetlabs-apache (v1.1.1)

> You have just installed a Puppet module. All of the classes in the module are now available to be added to the console and assigned to nodes.

> ### A Quick Note about Module Directories
>
>By default, the modules you use to manage nodes are located in `/etc/puppetlabs/puppet/environments/production/modules`---this includes modules installed by PE, those that you download from the Forge, and those you write yourself.
>
>**Note**: PE installs additional modules in `/opt/puppet/share/puppet/modules`. These must not be modified, and you should not add your own modules to this directory, as they may be removed during upgrades.





--------

Next: [Adding Classes to Puppet Agent Nodes (*nix)](./quick_start_adding_class_nix.html)



