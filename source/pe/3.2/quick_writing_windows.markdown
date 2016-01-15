---
layout: default
title: "PE 3.2 » Quick Start » Writing Modules (Windows)"
subtitle: "Module Writing Basics for Windows"
canonical: "/pe/latest/quick_writing_windows.html"
---

Welcome to part two of the PE 3.2 quick start guide---the Windows track. This document is a continuation of the introductory [quick start guide](./quick_start.html), and is a short walkthrough to help you become more familiar with Puppet modules, module development, and additional PE features for your Windows agent nodes. Follow along to learn how to:

* Modify a module obtained from the Forge
* Write your own Puppet module
* Create a site module that assigns other modules into machine roles
* Apply Puppet classes to groups with the console

> Before starting this walkthrough, you should have completed the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.

Getting Started
-----

First, you'll need to [install the puppet agent](./install_windows.html) on a node running a [supported version](./install_system_requirements.html#operating-system) of Windows. Once the agent is installed, sign its certificate to add it to the console just as you did for the first agent node in part one of this guide.

Next, install the [Puppet Labs Registry module](https://forge.puppetlabs.com/puppetlabs/registry) on your puppet master. The process is identical to how you [installed the NTP module](./quick_start.html#installing-a-forge-module) in part one. Once the module has been installed, add its class as you did with NTP.

Editing a Forge Module
-----

Although many Forge modules are exact solutions that fit your site, many more are *almost* but not quite what you need. Typically, you will edit many of your Forge modules.

### Module Basics

By default, modules are stored in `/etc/puppetlabs/puppet/modules`. You can configure this path with the [`modulepath`](/puppet/3.4/reference/configuration.html#modulepath) setting in `puppet.conf`.)

Modules are directory trees. The manifest directory of the Puppet Labs Registry module contains the following files:

- `registry/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `registry` class)
        - `service_example.pp` (contains the `registry::service` class used in an example below)
        - `compliance_example.pp` (provides an example `registry::compliance_example` class)
        - `purge_example.pp` (provides an example `registry::purge_example` class)
        - `service.pp` (defines `registry::service`)
        - `value.pp` (defines `registry::value`)

Every manifest (.pp) file contains a single class. File names map to class names in a predictable way: `init.pp` contains a class with the same name as the module; `<NAME>.pp` contains a class called `<MODULE NAME>::<NAME>`; and `<NAME>/<OTHER NAME>.pp` contains `<MODULE NAME>::<NAME>::<OTHER NAME>`.

Many modules contain directories other than `manifests`; for simplicity's sake, we will not cover them in this introductory guide.

* For more on how modules work, see [Module Fundamentals](/puppet/3/reference/modules_fundamentals.html) in the Puppet documentation.
* For more on best practices, methods, and approaches to writing modules, see the [Beginners Guide to Modules](/guides/module_guides/bgtm.html).
* For a more detailed guided tour, also see [the module chapters of Learning Puppet](/learning/modules1.html).

### Editing a Manifest

This simplified exercise will modify an example manifest from the Puppet Labs Registry module, specifically `service_example.pp`. The `registry::service` [defined resource type](./puppet/3/reference/lang_defined_types.html) makes it easy to control your registry; you can avoid having to declare both `registry_key` and `registry_value` resources with just a bit of puppet code.  

1. **On the puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/puppet/modules`.
2. Run `ls` to view the currently installed modules; note that `registry` is present.
3. Open `registry/manifests/service_example.pp`, using the text editor of your choice (vi, nano, etc.). Avoid using Notepad since it can introduce errors.

    `service_example.pp` contains the following:

	
        class registry::service_example {
        # Define a new service named "Puppet Test" that is disabled.
        registry::service { 'PuppetExample1':
            display_name => "Puppet Example 1",
            description  => "This is a simple example managing the registry entries for a Windows Service",
            command      => 'C:\PuppetExample1.bat',
            start        => 'disabled',
        }
        registry::service { 'PuppetExample2':
          display_name => "Puppet Example 2",
          description  => "This is a simple example managing the registry entries for a Windows Service",
          command      => 'C:\PuppetExample2.bat',
          start        => 'disabled',    
          }
        }   
  
4. Remove the "PuppetExample2" `registry::service` resource, and add the following `file` resource:
 	
        class registry::service_example {
        # Define a new service named "Puppet Test" that is disabled.
          registry::service { 'PuppetExample1':
            display_name => "Puppet Example 1",
            description  => "This is a simple example managing the registry entries for a Windows Service",
            command      => 'C:\PuppetExample1.bat',
            start        => 'disabled',
            }
      
        file { 'C:\PuppetExample1.bat':
            ensure  => file,
            content => ":loop\r\nTIMEOUT /T 300\r\ngoto loop\r\n",
            notify  => registry::service['PuppetExample1'],
            }	
        }
   
    The `registry::service_example` class is now managing `C:\PuppetExample1.bat`, and the contents of that file are being set with the `content` attribute. For more on resource declarations, see the [manifests chapter of Learning Puppet](/learning/manifests.html) or the [resources page of the language reference](/puppet/3/reference/lang_resources.html). For more about how file paths with backslashes work in manifests for Windows, see the page on [writing manifests for Windows](/windows/writing.html).

5. Save and close the file.
6. **On the console**, add `registry::service_example` to the available classes, and then add that class to the Windows agent node. Refer to [the introductory section of this guide if you need help adding classes in the console](./quick_start#using_modules_in_the_pe_console).
7. Kick off a puppet run. 

On the windows agent node, navigate to your `C:\` directory. Puppet has created the `file` resource `PuppetExample1.bat`, which is one of the resources that Puppet manages when it applies the class `registry::service_example`. 

![PuppetExample1][puppet_example_batch]

Puppet has also set a number of Registry keys to define the `PuppetExample1` Windows service. You can use event inspector to view the specific changes.

![EI registry service example][ei_registry_example]

To see `PuppetExample1` in the list of services that are running, you'll first need to reboot your Windows agent node, and then navigate to __Services__ via the __Administrative Tools.__ 

[puppet_example_batch]: ./images/quick/puppet_example_batch.png
[ei_registry_example]: ./images/quick/ei_registry_example.png

Writing a Puppet Module
--------------

Puppet Labs modules save time, but at some point most users will also need to write their own modules.

### Writing a Class in a Module

During this exercise, you will create a class called `critical_policy` that will manage a collection of important settings and options in your Windows registry, most notably the legal caption and text users will see before the login screen. 

1. **On the puppet master**, make sure you're still in the modules directory, `cd /etc/puppetlabs/puppet/modules`, and then run `mkdir -p critical_policy/manifests` to create the new module directory and its manifests directory.
2. Use your text editor to create and open the `critical_policy/manifests/init.pp` file.
3. Edit the init.pp file so it contains the following puppet code, and then save it and exit the editor:

        class critical_policy {
        
          registry::value { 'Legal notice caption':
            key   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System',
            value => 'legalnoticecaption',
            data  => 'Legal Notice',
            }
 
          registry::value { 'Legal notice text':
            key   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System',
            value => 'legalnoticetext',
            data  => 'Login constitutes acceptance of the End User Agreement',
            }
 
          registry::value { 'Allow Windows Update to Forcibly reboot':
            key   => 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU',
            value => 'NoAutoRebootWithLoggedOnUsers',
            type  => 'dword',
            data  => '0',
            }
          }
  

> You have written a new module containing a single class. Puppet now knows about this class, and it can be added to the console and assigned to your Windows nodes, just as you did in part one of this guide.
>
> Note the following about this new class:
>
> * The `registry::value` defined resource type allows you to use Puppet to manage the parent key for a particular value automatically. 
> * The `key` parameter specifies the path the key the value(s) must be in.
> * The `value` parameter lists the name of the registry value(s) to manage. This is copied from the resource title if not specified.
> * The `type` parameter determines the type of the registry value(s). Defaults to 'string'. Valid values are 'string', 'array', 'dword', 'qword', 'binary', or 'expand'.
> * `data` Lists the data inside the registry value. 


[registry::value]: http://forge.puppetlabs.com/puppetlabs/registry

For more information about writing classes, refer to the following documentation:

* To learn how to write resource declarations, conditionals, and classes in a guided tour format, [start at the beginning of Learning Puppet.](/learning/)
* For a complete but succinct guide to the Puppet language's syntax, [see the Puppet 3 language reference](/puppet/3/reference/lang_summary.html).
* For complete documentation of the available resource types, [see the type reference](/puppet/3.4/reference/type.html).
* For short, printable references, see [the modules cheat sheet](/module_cheat_sheet.pdf) and [the core types cheat sheet](/puppet_core_types_cheatsheet.pdf).

### Using Your Custom Module in the Console

[legal_notice_text_larry]: ./images/quick/legal_notice_larry.png
[legal_notice_text_values]: ./images/quick/legal_notice_values.png

1. **On the console,** use the __Add classes__ button to choose the `critical_policy` class from the list, and then click the __Add selected classes__ button to make it available, just as in the [previous example](./quick_start.html#using-modules-in-the-console). You may need to wait a moment or two for the class to show up in the list.
2. Add the `critical_policy` class to your Wiindows agent node.
3. **On the Windows agent node,** manually set the data values of `legalnoticecaption` and `legalnoticetext` to some other values. For example, set `legalnoticecaption` to "Larry's Computer" and set `legalnoticetext` to "This is Larry's computer."

   ![Legal notice text larry][legal_notice_text_larry]
    
4. Use live management to run the __runonce__ action on your Windows agent node.         
5. **On the Windows agent node,** refresh the registry and note that the values of `legalnoticecaption` and `legalnoticetext` have been returned to the values specified in your `critical_policy` manifest.

   ![Legal notice text original value][legal_notice_text_values]

If you reboot your Windows machine, you will see the legal caption and text before you log in again. 
       
> You have created a new class from scratch and used it to manage registry settings on your Windows server.

Using a Site Module
-----

Many users create a "site" module. Instead of describing smaller units of a configuration, the classes in a site module describe a complete configuration for a given _type_ of machine. For example, a site module might contain:

* A `site::basic` class, for nodes that require security management but haven't been given a specialized role yet.
* A `site::webserver` class for nodes that serve web content.
* A `site::dbserver` class for nodes that provide a database server to other applications.

Site modules hide complexity so you can more easily divide labor at your site. System architects can create the site classes, and junior admins can create new machines and assign a single "role" class to them in the console. In this workflow, the console controls policy, not fine-grained implementation.

* **On the puppet master,** create the `/etc/puppetlabs/puppet/modules/site/manifests/basic.pp` file, and edit it to contain the following:


        class site::basic {
          if $osfamily == 'windows' {
            include critical_policy
          }
          else {
            include motd
            include core_permissions
          }
        }


This class declares other classes with the `include` function. Note the "if" conditional that sets different classes for different OS's using the `$osfamily` fact. In this example, if an agent node is not a Windows agent, puppet will apply the `motd` and `core_permissions` classes. For more information about declaring classes, see the [modules and classes chapters of Learning Puppet](/learning/modules1.html).

1. **On the console,** remove all of the previous example classes from your nodes and groups, using the __Edit__ button in each node or group page. Be sure to leave the `pe_*` classes in place.
2. Add the `site::basic` class to the console with the __Add classes__ button in the sidebar as before.
3. Assign the `site::basic` class to the default group.

> Your nodes are now receiving the same configurations as before, but with a simplified interface in the console. Instead of deciding which classes a new node should receive, you can decide what _type_ of node it is and take advantage of decisions you made earlier.


Summary
-----

You have now performed the core workflows of an intermediate Puppet user. In the course of their normal work, intermediate users:

* Download and modify Forge modules to fit their deployment's needs.
* Create new modules and write new classes to manage many types of resources, including files, services, packages, user accounts, and more.
* Build and curate a site module to safely empower junior admins and simplify the decisions involved in deploying new machines.
* Monitor and troubleshoot events that affect their infrastructure.

* * *

- [Next: System Requirements](./install_system_requirements.html)
