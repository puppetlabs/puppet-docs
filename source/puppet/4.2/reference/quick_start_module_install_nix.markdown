---
layout: default
title: "Quick Start » Module Installation (*nix)"
subtitle: "Module Installation Quick Start Guide"
canonical: "/puppet/latest/quick_start_module_install_nix.html"
---

## Overview

In this guide, you'll install the puppetlabs-apache module, a Puppet-supported module. Modules contain [classes](./lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet configures and manages nodes.  
In the [Module Writing Basics for Linux Quick Start Guide](./quick_writing_nix.html) you'll learn more about modules, including customizing and writing your own modules on *nix platforms.

The process for installing a module is the same on both Windows and *nix operating systems.

> **Prerequisites**: This guide assumes you've already [installed Puppet](/2.1/install_from_packages.html), and have installed at least one [*nix agent](./install_linux.html).

> Before starting this walk-through, complete the [Hello World](./quick_start_helloworld) exercise in the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.


## Installing a Forge Module

1. **On the Puppet master**, run `puppet module search apache`. This command searches for modules from the Puppet Forge with `apache` in their names or descriptions.

    The search results will display:

        Searching http://forgeapi.puppetlabs.com ...
        NAME                  DESCRIPTION                           AUTHOR        KEYWORDS
        puppetlabs-apache     Puppet module for apache              @puppetlabs   apache


    To view detailed information about the module, see the [Apache module on Forge](https://forge.puppetlabs.com/puppetlabs/apache).

2. To install the Apache module, run:  `puppet module install puppetlabs-apache`. The result looks like this:

        Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/code/environments/production/modules
        └── puppetlabs-apache (v1.1.1)

>  That's it! You have installed a Puppet module. All of the classes in the module are now available to be assigned to nodes.

> ### A Quick Note about Module Directories
>
>By default, Puppet keeps modules in an environment's [`modulepath`](./dirs_modulepath.html), which for the production environment defaults to `/etc/puppetlabs/code/environments/production/modules`. This includes modules that Puppet installs, those that you download from the Forge, and those you write yourself.
>
>**Note:** Puppet also creates another module directory: `/opt/puppetlabs/puppet/modules`. Don't modify or add anything in this directory, including modules of your own.

>`puppetlabs-apache` is a [PE-supported module](https://forge.puppetlabs.com/supported). It is tested and maintained by Puppet Labs, and Puppet Enterprise users are able to file support escalations on these modules.

--------

Next: [Adding Classes to Puppet Agents (*nix)](./quick_start_adding_classes_nix.html)



