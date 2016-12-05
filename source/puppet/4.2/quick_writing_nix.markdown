---
layout: default
title: "Quick Start » Writing Modules (*nix)"
subtitle: "Module Writing Basics for *nix"
canonical: "/puppet/latest/quick_writing_nix.html"
---

Welcome to the Module Writing section of the Quick Start Guide series. This walk-through will help you become more familiar with Puppet modules and module development. Follow along to learn how to:

* [Modify a module obtained from the Forge](#editing-a-forge-module)
* [Write your own Puppet module](#writing-a-puppet-module)
* [Create a site module that composes other modules into machine roles](#using-a-site-module)

> Before starting this walk-through, complete the previous exercises in the [introductory quick start guide](./quick_start.html). These steps assume that you have installed Puppet and Puppet agents, and have [installed the latest version of the puppetlabs-apache module](./quick_start_module_install_nix.html). 
You should still be logged in as root or administrator on your nodes.

## Editing a Forge Module

Although many Forge modules are exact solutions that fit your site, many are *almost* but not quite what you need. Sometimes you will need to edit some of your Forge modules.

### Module Basics
> ### About Module Directories
>
>By default, Puppet keeps modules in an environment's [`modulepath`](./dirs_modulepath.html), which for the production environment defaults to `/etc/puppetlabs/code/environments/production/modules`. This includes modules that Puppet installs, those that you download from the Forge, and those you write yourself. In a fresh installation, you need to create this `modules` subdirectory yourself by navigating to `/etc/puppetlabs/code/environments/production` and running `mkdir modules`.
>
>**Note:** Puppet also creates another module directory: `/opt/puppetlabs/puppet/modules`. Don't modify or add anything in this directory, including modules of your own.
>
>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Modules and Manifests](./puppet_modules_manifests.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).



Modules are directory trees. For these exercises you'll use the following files:

- `apache/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `apache` class)
    - `templates/`
        - `vhost/`
            - `_file_header.erb` (contains the vhost template, managed by Puppet)

Every manifest (.pp file) in a module contains a single class. File names map to class names in a predictable way, described in the [Autoloader Behavior documentation](./lang_namespaces.html#autoloader-behavior). The `init.pp` file is a special case that contains a class named after the module, `apache`. Other manifest files contain classes called `<MODULE NAME>::<FILE NAME>` or `<MODULE NAME>::<FOLDER>::<FILE NAME>`.
Many modules, including Apache, contain directories other than `manifests` and `templates`. For simplicity's sake, we do not cover them in this introductory guide.

* For more on how modules work, see [Module Fundamentals](./modules_fundamentals.html) in the Puppet documentation.
* For more on best practices, methods, and approaches to writing modules, see the [Beginners Guide to Modules](/guides/module_guides/bgtm.html).
* For a more detailed guided tour, also see [the module chapters of Learning Puppet](/learning/modules1.html).

### Writing a Puppet Module

 In this simplified exercise, you'll modify a template from the Puppet Labs Apache module, specifically `vhost.conf.erb`, to include some simple variables that will be populated by facts (using Puppet's implementation of Facter) about your node.

1. **On the Puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/code/environments/production/modules`.
2. Run `ls` to view the currently installed modules, and note that `apache` is present.
3. Open `apache/templates/vhost/_file_header.erb` in a text editor. Avoid using Notepad because it can introduce errors.
      `_file_header.erb` contains the following header:

        # ************************************
        # Vhost template in module puppetlabs-apache
        # Managed by Puppet
        # ************************************

4. Collect the following facts about your agent:
   - on your Puppet agent, run `facter osfamily`. This returns your agent's OS. 
   - on your Puppet agent, run `facter id`. This returns the id of the currently logged in user. 
5. Edit the header of `_file_header.erb` so that it contains the following variables for Facter lookups:

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
        
6. From the command line of your Puppet agent, run `puppet agent -t` to trigger a Puppet run.

At this point, Puppet configures Apache and starts the httpd service. When this happens, a default Apache virtual host is created based on the contents of `_file_header.erb`.

1. **On the agent**, navigate to one of the following locations based on your operating system:
   - Redhat-based: `/etc/httpd/conf.d`
   - Debian-based: `/etc/apache2/sites-available`

2. View `15-default.conf`. Depending on the node's OS, the header will show some variation of the following contents:

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

As you can see, Puppet has used Facter to retrieve some key facts about your node, and then used those facts to populate the header of your vhost template.

But now, let's see what happens when you write your own Puppet code.

## Writing a Puppet Module

Puppet Labs modules save time, but at some point you may need to write your own modules.

### Writing a Class in a Module

 In this exercise, you will create a class called `puppet_quickstart_app` that will manage a PHP-based web app running on an Apache virtual host.

1. **On the Puppet master**, make sure you're still in the modules directory (`cd /etc/puppetlabs/code/environments/production/modules`) and then run `mkdir -p puppet_quickstart_app/manifests` to create the new module directory and its manifests directory.
2. Use your text editor to create and open the `puppet_quickstart_app/manifests/init.pp` file.
3. Edit the `init.pp` file so it contains the following Puppet code, and then save it and exit the editor:

        class puppet_quickstart_app {

          class { 'apache':
            mpm_module => 'prefork',
          }

          include apache::mod::php

          apache::vhost { 'puppet_quickstart_app':
            port     => '80',
            docroot  => '/var/www/puppet_quickstart_app',
            priority => '10',
          }

          file { '/var/www/puppet_quickstart_app/index.php':
            ensure  => file,
            content => "<?php phpinfo() ?>\n",
            mode    => '0644',
          }

        }

> You have written a new module containing a new class that includes two other classes: `apache` and `apache::mod::php`.
>
> Note the following about your new class:
>
> * The class `apache` has been configured to include the `mpm_module` attribute. This attribute determines which multi-process module is configured and loaded for the Apache (HTTPD) process. In this case, the value is set to `prefork`.
> * `include apache::mod::php` indicates that your new class relies on those classes to function correctly. Puppet understands that your node needs to be classified with these classes and will take care of that work automatically when you classify your node with the `puppet_quickstart_app` class. In other words, you don't need to worry about classifying your nodes with Apache and Apache PHP.
> * The `priority` attribute of `10` ensures that your app has a higher priority on port 80 than the default Apache vhost app.
> * The file `/var/puppet_quickstart_app/index.php` contains whatever is specified by the `content` attribute. This is the content you will see when you launch your app. Puppet uses the `ensure` attribute to create that file the first time the class is applied.

### Using Your Custom Module in the Main Manifest

1. From the command line on the Puppet master, navigate to the main manifest (`cd /etc/puppetlabs/code/environments/production/manifests`).
2. With your text editor, open `site.pp` and add the following Puppet code to your default node. **Remove the apache class you added previously.** Your site.pp file should look like this after you make your changes (although you may have portions from earlier in the Quick Start Guide):

		 node default {
           class { 'puppet_quickstart_app': }
		 }
   
   >**Note**: Since the `puppet_quickstart_app` includes the `apache` class, you need to remove the first `apache` class you added the master node, as Puppet will only allow you to declare a class once.

3. From the command line on your agent, run `puppet agent -t` to trigger a Puppet run.

     When the Puppet run is complete, you will see in the agent's log that a vhost for the app has been created and the Apache service (httpd) has been started.

4. Use a browser to navigate to port 80 of the IP address for your node, as in `http://<yournodeip>:80`.

   >**Tip**: Be sure to use `http` instead of `https`.

 Congratulations! You have created a new class from scratch and used it to launch a Apache PHP-based web app. Needless to say, in the real world, your apps will do a lot more than display PHP info pages. But for the purposes of this exercise, let's take a closer look at how Puppet is managing your app.

### Using Puppet to Manage Your App

1. **On the Puppet agent**, open `/var/www/puppet_quickstart_app/index.php`, and change the content to something like, "THIS APP IS MANAGED BY PUPPET!"
2. Refresh your browser, and notice that the PHP info page has been replaced with your new message.
3. Run `puppet agent -t --onetime` on your Puppet agent.
4. Refresh your browser, and notice that Puppet has reset your web app to display the PHP info page. (You can also see that the contents of `/var/www/puppet_quickstart_app/index.php` has been reset to what was specified in your manifest.)

## Using a Site Module

Many users create a "site" module. Instead of describing smaller units of a configuration, the classes in a site module describe a complete configuration for a given *type* of machine. For example, a site module might contain:

* A `site::basic` class, for nodes that require security management but haven't been given a specialized role yet.
* A `site::webserver` class for nodes that serve web content.
* A `site::dbserver` class for nodes that provide a database server to other applications.

Site modules hide complexity so you can more easily divide labor at your site. System architects can create the site classes, and junior admins can create new machines.

* **On the Puppet master**, create `/etc/puppetlabs/code/environments/production/modules/site/manifests/basic.pp`, and edit the file to contain the following:


        class site::basic {
          if $::kernel == 'Linux' {
            include puppet_quickstart_app
          }
          elsif $::kernel == 'windows' {
            include registry::compliance_example
          }
        }


This class declares other classes with the `include` function. Note the "if" conditional that sets different classes for different kernels using the `$kernel` fact. In this example, if an agent is a Linux machine, Puppet will apply your `puppet_quickstart_app` class. If it is a Windows machine, Puppet will apply the `registry::compliance_example` class. For more information about declaring classes, see the [modules and classes chapters of Learning Puppet](/learning/modules1.html).

1. From the command line on the Puppet master, navigate to the main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Add the following Puppet code to the default node in `site.pp`, retaining the classes you have already added:
       
        class { ‘site::basic’: }
        
3. Save and exit, then run `puppet agent -t` from the command line of your Puppet agent.

## Summary

You have now performed the core workflows of an intermediate Puppet user. In the course of their normal work, intermediate users:

* Download and modify Forge modules to fit their deployment's needs.
* Create new modules and write new classes to manage many types of resources, including files, services, and more.
* Build and curate a site module to safely empower junior admins and simplify the decisions involved in deploying new machines.

* * *

- [Next: Essential Configuration Tasks](./quick_start_essential_config.html)