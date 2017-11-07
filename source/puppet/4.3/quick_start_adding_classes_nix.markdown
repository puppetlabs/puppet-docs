---
layout: default
title: "Quick Start » Adding Classes (*nix)"
subtitle: "Adding Classes Quick Start Guide"
canonical: "/puppet/latest/quick_start_adding_class_nix.html"
---


## Overview

Every module contains one or more **classes**. [Classes](./lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet configures nodes. The puppetlabs-apache module you installed in the [Module Installation Quick Start Guide ](./quick_start_module_install_nix.html) contains a class called `apache`. In this example, you will:

* [Use the `apache` class to launch the default Apache virtual host](#add-apache-to-the-main-manifest)
* [Edit class parameters in the main manifest](#editing-class-parameters-in-the-main-manifest)

> **Prerequisites**: This guide assumes you've already [installed Puppet](/puppetserver/2.2/install_from_packages.html), and have installed at least one [*nix agent](./install_linux.html) and the [puppetlabs-apache module](./quick_start_module_install_nix.html).

> Before starting this walk-through, complete the previous exercises in the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.

## Add Apache to the Main Manifest

1. From the command line of your Puppet master, navigate to the main manifest directory: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to open the `site.pp` file, and edit it so that it contains the following Puppet code:

        node default {
		  include apache
        }

	>**Note**: If you have already created the default node class, simply add `include apache` to it. Code from the [Hello World! exercise](./quick_start_helloworld.html) does not need to be removed, but a class cannot be declared twice. We will explore this later in the guide.

3. Ensure that there are no errors in the Puppet code by running `puppet parser validate site.pp` on the command line of your Puppet master. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file and fix the problem before continuing.
4. From the command line of your Puppet agent, run `puppet agent -t` to trigger a Puppet run.

## Create the index.html file
1. **On the Puppet agent**, navigate to `/var/www/html`, and create a file called `index.html` if it does not already exist.
2. Open `index.html` in your text editor and fill it with some content (for example, "Hello World") or edit what is already there.
3. From the command line of your Puppet agent, run `puppet agent -t`.
4. Open a web browser and enter the IP address for the Puppet agent, adding port 80 on the end, as in `http://myagentnodeIP:80/`.

   You will see the contents of `/var/www/html/index.html` displayed.

## Editing Class Parameters in the Main Manifest

You can edit the [parameters](https://docs.puppetlabs.com/puppet/latest/lang_classes.html#defining-classes) of a class in `site.pp` as well. Parameters allow a class to request external data. If a class needs to configure itself with data other than [Puppet facts](https://docs.puppetlabs.com/puppet/latest/lang_facts_and_builtin_vars.html), provide that data to the class via a parameter.


**To edit the parameters of the** `apache` **class**:

1. From the command line of your Puppet master, navigate to `/etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to open `site.pp`.
3. Replace the `include apache` command with the following Puppet code:

        class { 'apache':
    	  docroot => '/var/www'
		}

	>**Note**: You must remove `include apache` because Puppet will only allow you to [declare a class once](https://docs.puppetlabs.com/puppet/latest/lang_classes.html#declaring-classes).

> That's it! You have set the Apache web server's root directory to `/var/www` instead of its default `/var/www/html`. If you refresh `http://myagentnodeIP:80/` in your web browser, it shows the list of files in `/var/www`. If you click `html`, the browser will again show the contents of `/var/www/html/index.html`.
>
> **Note:**
> If you have Puppet Enterprise, you can do the steps in this guide through the PE web UI, [the console](https://docs.puppetlabs.com/pe/latest/console_accessing.html).


----------

Next: [Quick Start: Writing Modules](./quick_writing_nix.html)
