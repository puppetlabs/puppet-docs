---
layout: default
title: "Quick Start » Module Installation (*nix)"
subtitle: "Module Installation Quick Start Guide"
canonical: "/puppet/latest/quick_start_module_install_nix.html"
---

## Overview

In this guide, you'll install the puppetlabs-apache module, a Puppet-supported module. Modules contain [classes](/puppet/4.2/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet configures and manages nodes.  
In the [Module Writing Basics for Linux QSG](./quick_writing_nix.html) you'll learn more about modules, including customizing and writing your own modules on [*nix](./quick_writing_nix.html) platforms.

The process for installing a module is the same on both Windows and *nix operating systems.

> **Prerequisites**: This guide assumes you've already [installed Puppet](./guides/install_puppet/pre_install.html), and have installed at least one [*nix agent node](./guides/install_puppet/post_install.html).

> Before starting this walkthrough, you might want to complete the previous exercise in the [introductory quick start guide](./quick_start.html), called [Hello World](./quick_start_helloworld). You should still be logged in as root or administrator on your nodes.


## Installing a Forge Module

1. **On the Puppet master**, run `puppet module search apache`. This command searches for modules from the Puppet Forge with `apache` in their names or descriptions.

   Your search will have a list of results that are displayed as follows:

        Searching http://forgeapi.puppetlabs.com ...
        NAME                  DESCRIPTION                           AUTHOR        KEYWORDS
        puppetlabs-apache     Puppet module for apache              @puppetlabs   apache


   You can view detailed info about the module on the [Forge](http://forge.puppetlabs.com/puppetlabs/apache).

2. To install the Apache module, run, `puppet module install puppetlabs-apache`. The result looks like this:

        Preparing to install into /etc/puppetlabs/code/environments/production/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/code/environments/production/modules
        └── puppetlabs-apache (v1.1.1)

> You have just installed a Puppet module. All of the classes in the module are now available to be assigned to nodes.

> ### A Quick Note about Module Directories
>
>By default, the modules you use to manage nodes are located in `/etc/puppetlabs/code/environments/production/modules`---this includes modules installed by Puppet, those that you download from the Forge, and those you write yourself.
>





--------

Next: [Adding Classes to Puppet Agent Nodes (*nix)](./quick_start_adding_class_nix.html)



