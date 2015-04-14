---
layout: default
title: "PE 3.7 » Quick Start » Writing Modules (*nix)"
subtitle: "Module Writing Basics for *nix"
canonical: "/pe/latest/quick_writing_nix.html"
---

Welcome to the writing modules section of the Quick Start Guide series. This document is a short walkthrough to help you become more familiar with Puppet modules, module development, and additional PE features. Follow along to learn how to:

* Modify a module obtained from the Forge
* Write your own Puppet module
* Create a site module that composes other modules into machine roles
* Apply Puppet classes to groups with the console

> Before starting this walkthrough, you should have completed the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.

## Getting Started

In the [Apache installation QSG](./quick_start_module_install_nix.html), you installed the latest version of the puppetlabs-apache module. However for the exercises in this guide, you'll need a specific version of the module---version 1.2.0. 

To install this version, first remove the previous version of the Apache module if you have it installed. Navigate to `/etc/puppetlabs/puppet/environments/production/modules` and run `puppet module uninstall puppetlabs-apache`.

Next from that same directory run `puppet module install puppetlabs-apache --version 1.2.0`.

## Editing a Forge Module

Although many Forge modules are exact solutions that fit your site, many are *almost* but not quite what you need. Sometimes you will need to edit some of your Forge modules.

### Module Basics

By default, modules are stored in `/etc/puppetlabs/puppet/environments/production/modules`. If need be, you can configure this path with the [`modulepath`](/references/3.7.latest/configuration.html#modulepath) setting in `puppet.conf`.)

Modules are directory trees. For these exercises you'll use the following files:

- `apache/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `apache` class)
        - `php.pp` (contains the `php` class to install PHP for Apache)
        - `vhost.pp` (contains the Apache virtual hosts class)
    - `templates/`
        - `vhost.conf.erb` (contains the vhost template, managed by PE)

Every manifest (.pp) file contains a single class. File names map to class names in a predictable way: `init.pp` contains a class with the same name as the module; `<NAME>.pp` contains a class called `<MODULE NAME>::<NAME>`; and `<NAME>/<OTHER NAME>.pp` contains `<MODULE NAME>::<NAME>::<OTHER NAME>`.

Many modules, including Apache, contain directories other than `manifests` and `templates`; for simplicity's sake, we do not cover them in this introductory guide.

* For more on how modules work, see [Module Fundamentals](/puppet/3.7/reference/modules_fundamentals.html) in the Puppet documentation.
* For more on best practices, methods, and approaches to writing modules, see the [Beginners Guide to Modules](/guides/module_guides/bgtm.html).
* For a more detailed guided tour, also see [the module chapters of Learning Puppet](/learning/modules1.html).

### Editing a Manifest

This simplified exercise modifies a template from the Puppet Labs Apache module, specifically `'vhost.conf.erb`. You'll edit the template to include some simple variables that will be populated by facts (using PE's implementation of Facter) about your node.

1. **On the Puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/puppet/environments/production/modules`.
2. Run `ls` to view the currently installed modules; note that `apache` is present.
3. Open `apache/templates/vhost.conf.erb`, using the text editor of your choice (vi, nano, etc.). Avoid using Notepad since it can introduce errors.
      `vhost.conf.erb` contains the following header:

        # ************************************
        # Vhost template in module puppetlabs-apache
        # Managed by Puppet
        # ************************************

4. Collect the following facts about your agent node:
   - run `facter osfamily` (this returns your agent node's OS)
   - run `facter id` (this returns the id of the currently logged in user)
5. Edit the header of `vhost.conf.erb` so that it contains the following variables for Facter lookups:

        # ************************************
        # Vhost template in module puppetlabs-apache
        # Managed by Puppet
        #
        # This file is authorized for deployment by <%= scope.lookupvar('::id') %>.
        #
        # This file is authorized for deployment ONLY on <%= scope.lookupvar('::osfamily') %> <%= scope.lookupvar('::operatingsystemmajrelease')     %>.
        #
        # Deployment by any other user or on any other system is strictly prohibited.
        # ************************************

6. **On the console**, add `apache` to the available classes, and then add that class to your agent node. Refer to the [Adding Classes Quick Start Guide](./quick_start_adding_class_nix.html).
7. Use live management to kick off a Puppet run.

At this point, Puppet configures apache and starts the httpd service. When this happens, a default apache vhost is created based on the contents of `vhost.conf.erb`.

8. **On the agent node**, navigate to one of the following locations based on your operating system:
   - Redhat-based: `/etc/httpd/conf.d`
   - Debian-based: `/etc/apache2/sites-available`

9. View `15-default.conf`; depending on the node's OS, the header will show some variation of the following contents:

        # ************************************
        # Vhost template in module puppetlabs-apache
        # Managed by Puppet
        #
        # This file is authorized for deployment by root.
        #
        # This file is authorized for deployment ONLY on Redhat 6.
        #
        # Deployment by any other user or on any other system is strictly prohibited.
        # ************************************

As you can see, PE has used Facter to retrieve some key facts about your node, and then used those facts to populate the header of your vhost template.

But now, let's see what happens you write your own Puppet code.

## Writing a Puppet Module

Puppet Labs modules save time, but at some point you may that you'll need to write your own modules.

### Writing a Class in a Module

During this exercise, you will create a class called `pe_quickstart_app` that will manage a PHP-based web app running on an Apache virtual host.

1. **On the Puppet master**, make sure you're still in the modules directory (`cd /etc/puppetlabs/puppet/environments/production/modules`) and then run `mkdir -p pe_quickstart_app/manifests` to create the new module directory and its manifests directory.
2. Use your text editor to create and open the `pe_quickstart_app/manifests/init.pp` file.
3. Edit the `init.pp` file so it contains the following Puppet code, and then save it and exit the editor:

        class pe_quickstart_app {

          class { 'apache':
            mpm_module => 'prefork',
          }

          include apache::mod::php

          apache::vhost { 'pe_quickstart_app':
            port     => '80',
            docroot  => '/var/www/pe_quickstart_app',
            priority => '10',
          }

          file { '/var/www/pe_quickstart_app/index.php':
            ensure  => file,
            content => "<?php phpinfo() ?>\n",
            mode    => '0644',
          }

        }

> You have written a new module containing a new class that includes two other classes. Puppet now knows about this your new class, and it can be added to the console and assigned to your node.
>
> Note the following about your new class:
>
> * The class `apache` has been modified to include the `mpm_module` attribute; this attribute determines which multi-process module is configured and loaded for the Apache (HTTPD) process. In this case, the value is set to `prefork`.
> * `include apache::mod::php` indicates that your new class relies on those classes to function correctly. However, PE understands that your node needs to be classified with these classes and will take care of that work automatically when you classify your node with the `pe_quickstart_app` class; in other words, you don't need to worry about classifying your nodes with Apache and Apache PHP.
> * The `priority` attribute of `10` ensures that your app has a higher priority on port 80 than the default Apache vhost app.
> * The file `/var/pe_quickstart_app/index.php` contains whatever is specified by the `content` attribute. This is the content you will see when you launch your app. PE uses the `ensure` attribute to create that file the first time the class is applied. This the content you will see when you launch your app.

For more information about writing classes, refer to the following documentation:

* To learn how to write resource declarations, conditionals, and classes in a guided tour format, [start at the beginning of Learning Puppet.](/learning/)
* For a complete but succinct guide to the Puppet language's syntax, [see the Puppet 3 language reference](/puppet/3.7/reference/lang_summary.html).
* For complete documentation of the available resource types, [see the type reference](/references/3.7.latest/type.html).
* For short, printable references, see [the modules cheat sheet](/module_cheat_sheet.pdf) and [the core types cheat sheet](/puppet_core_types_cheatsheet.pdf).

### Using Your Custom Module in the Console

[php_info]: ./images/quick/php_info.png

1. **On the console**, click the __Add classes__ button, choose the `pe_quickstart_app` class from the list, and then click the __Add selected classes__ button to make it available, just as in the [previous example](./quick_start.html#using-modules-in-the-console). You may need to wait a moment or two for the class to show up in the list.
2. Navigate to the node view page for your agent node, and use the __Edit__ button to add the `pe_quickstart_app` class to your agent node, and remove the `apache` class you previously added.

   >**Note**: Since the `pe_quickstart_app` includes the `apache` class, you need to remove the first `apache` class you added the master node, as Puppet will only allow you to declare a class once.

3. Use live management to run the __runonce__ action your agent node.

     When the Puppet run is complete, you will see in the node's log that a vhost for the app has been created and the Apache service (httpd) has been started.

4. Use a browser to navigate to port 80 of the IP address for your node; e.g, `http://<yournodeip>:80`.

   >**Tip**: Be sure to use `http` instead of `https`.

   ![PHP Info Page][php_info]

You have created a new class from scratch and used it to launch a Apache PHP-based web app. Needless to say, in the real world, your apps will do a lot more than display PHP info pages. But for the purposes of this exercise, let's take a closer look at how PE is managing your app.

### Using PE to Manage Your App

1. **On the agent node**, open `/var/www/pe_quickstart_app/index.php`, and change the content; change it to something like, "THIS APP IS MANAGED BY PUPPET!"
2. Refresh your browser, and notice that the PHP info page has been replaced with your new message.
3. **On the console**, use live management to run the __runonce__ action on your node.
4. Refresh your browser, and notice that Puppet has reset your web app to display the PHP info page. (You can also see that the contents of `/var/www/pe_quickstart_app/index.php` has been reset to what was specified in your manifest.)

## Using a Site Module

Many users create a "site" module. Instead of describing smaller units of a configuration, the classes in a site module describe a complete configuration for a given *type* of machine. For example, a site module might contain:

* A `site::basic` class, for nodes that require security management but haven't been given a specialized role yet.
* A `site::webserver` class for nodes that serve web content.
* A `site::dbserver` class for nodes that provide a database server to other applications.

Site modules hide complexity so you can more easily divide labor at your site. System architects can create the site classes, and junior admins can create new machines and assign a single "role" class to them in the console. In this workflow, the console controls policy, not fine-grained implementation.

* **On the Puppet master**, create `/etc/puppetlabs/puppet/environments/production/modules/site/manifests/basic.pp`, and edit the file to contain the following:


        class site::basic {
          if $kernel == 'Linux' {
            include pe_quickstart_app
          }
          elsif $kernel == 'windows' {
            include registry::compliance_example
          }
        }


This class declares other classes with the `include` function. Note the "if" conditional that sets different classes for different kernels using the `$kernel` fact. In this example, if an agent node is a Linux machine, Puppet will apply your `pe_quickstart_app` class; if it is a window machines, Puppet will apply the `registry::compliance_example` class. For more information about declaring classes, see the [modules and classes chapters of Learning Puppet](/learning/modules1.html).

1. **On the console**, remove all of the previous example classes from your nodes and groups, using the __Edit__ button in each node or group page. Be sure to leave the `pe_*` classes in place.
2. Add the `site::basic` class to the console with the __Add classes__ button in the sidebar as before.
3. Assign the `site::basic` class to the default group.

> Your nodes are now receiving the same configurations as before, but with a simplified interface in the console. Instead of deciding which classes a new node should receive, you can decide what *type* of node it is and take advantage of decisions you made earlier.


## Summary

You have now performed the core workflows of an intermediate Puppet user. In the course of their normal work, intermediate users:

* Download and modify Forge modules to fit their deployment's needs.
* Create new modules and write new classes to manage many types of resources, including files, services, and more.
* Build and curate a site module to safely empower junior admins and simplify the decisions involved in deploying new machines.

* * *

- [Next: System Requirements](./install_system_requirements.html)
