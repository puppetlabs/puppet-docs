---
layout: default
title: "Quick Start » Classifying Agents (*nix)"
subtitle: "Adding Classes Quick Start Guide"
canonical: "/puppet/latest/quick_start_adding_class_nix.html"
---


## Overview

Every module contains one or more **classes**. [Classes](./puppet/4.2/reference/lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures nodes. The puppetlabs-apache module you installed in the [Module Installation QSG](./quick_start_module_install_nix.html) contains a class called `apache`. In this example, you'll use the `apache` class to launch the default Apache virtual host. You'll create a group called __apache_example__ and add the `apache` class to it.

> **Prerequisites**: This guide assumes you've already [installed a monolithic Puppet deployment](./guides/install_puppet/pre_install.html), and have installed at least one [*nix agent node](./guides/install_puppet/post_install.html) and the [puppetlabs-apache module](./quick_start_module_install_nix.html).

## Add Apache to the Main Manifest

1. From the command line of your Puppet master, navigate to the main manifest directory (`cd etc/puppetlabs/code/environments/production/manifests`).
2. Use your text editor to open the `site.pp` file, and edit it so that it contains the following Puppet code:

        node default {

			include apache
			
        }

**Note: If you have already created the default node class, simply add `include apache` to it.**

3. Ensure that there are no errors in the Puppet code by running `puppet parser validate site.pp` on the CLI of your Puppet master. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.
4. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

## Ensure Web Access

In order to ensure you are able to view the results in your web browser, install `httpd` (for RedHat/CentOS/Fedora) or `apache2` (for Debian/Ubuntu) on your agent node.

#### For RedHat/CentOS/Fedora Users
1. **On the Puppet agent**, run `sudo yum search httpd`.
2. **On the Puppet agent**, install the "Apache HTTP Server" by running `sudo yum install httpd.x86_64`.

#### For Debian/Ubuntu Users
1. **On the Puppet agent**, run `apt-get search apache2`.
2. **On the Puppet agent**, install the "Apache HTTP Server" by running `apt-get install apache.x86_64`.

## Create the index.html file
1. **On the Puppet agent**, navigate to `/var/www/html`, and create a file called `index.html`.
2. Open `index.html` with the text editor of your choice and fill it with some content (e.g., "Hello World").
3. From the CLI of your Puppet agent node, run `puppet agent -t`.
4. Open a browser and enter the IP address for the agent node, adding port 80 on the end (e.g., `http://myagentnodeIP:80/`).

   You will see the contents of `/var/www/html/index.html` displayed.
   
## Editing Class Parameters in the Main Manifest

You can edit the [parameters](./puppet/latest/reference/lang_classes.html#defining-classes) of a class in site.pp as well. Parameters allow a class to request external data. If a class needs to configure itself with data other than facts, that data should usually enter the class via a parameter.
**To edit the parameters of the** `apache` **class**:

1. From the CLI of your Puppet master, navigate to `etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to open `site.pp`. 
3. Replace the `include apache` command with the following Puppet code:

        class { 'apache':
    	docroot => '/var/www'
		}
		
That's it! If you refresh `http://myagentnodeIP:80/`, you'll see that the page has changed to reflect the files in `/var/www`. If you click `html`, you'll again be presented with the contents of `/var/www/html/index.html`.

----------

Next: [Quick Start: Writing Modules](./quick_writing_nix.html)
