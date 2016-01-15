---
layout: default
title: "PE 3.3 » Quick Start » Writing Modules (Windows)"
subtitle: "Module Writing Basics for Windows"
canonical: "/pe/latest/quick_writing_windows.html"
---

Welcome to the writing modules section of the Quick Start Guide series. This document is a short walkthrough to help you become more familiar with Puppet modules, module development, and additional PE features. Follow along to learn how to:

* Install a module obtained from the Forge
* Write your own Puppet module
* Create a site module that assigns other modules into machine roles
* Apply Puppet classes to groups with the console

> Before starting this walkthrough, you should have completed the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.

### Getting Started

First, you'll need to [install the puppet agent](./install_windows.html) on a node running a [supported version](./install_system_requirements.html#operating-system) of Windows. Once the agent is installed, sign its certificate to add it to the console. (You can find instructions for installing Windows agents and signing their certificates in the [Windows agent installation instructions](./quick_start_install_agents_windows.html).

Next, install the [Puppet Labs Registry module](https://forge.puppetlabs.com/puppetlabs/registry) on your puppet master.

To do this, run this command:
	`puppet module install puppetlabs-registry`

Once the module has been installed, add its class as described in the section [Using Modules in the PE Console](./quick_start.html#using-modules-in-the-pe-console).

#### Module Basics

By default, modules are stored in `/etc/puppetlabs/puppet/modules`. You can configure this path with the [`modulepath`](/puppet/3.4/reference/configuration.html#modulepath) setting in `puppet.conf`.)

Modules are directory trees. The manifest directory of the Puppet Labs Registry module contains the following files:

- `registry/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `registry` class)
        - `service_example.pp` (provides an example `registry::service` class)
        - `compliance_example.pp` (provides an example `registry::compliance_example` class)
        - `purge_example.pp` (provides an example `registry::purge_example` class)
        - `service.pp` (defines `registry::service`)
        - `value.pp` (defines `registry::value`)

Every manifest (.pp) file contains a single class. File names map to class names in a predictable way: `init.pp` contains a class with the same name as the module; `<NAME>.pp` contains a class called `<MODULE NAME>::<NAME>`; and `<NAME>/<OTHER NAME>.pp` contains `<MODULE NAME>::<NAME>::<OTHER NAME>`.

Many modules contain directories other than `manifests`; for simplicity's sake, we will not cover them in this introductory guide.

* For more on how modules work, see [Module Fundamentals](/puppet/3.6/reference/modules_fundamentals.html) in the Puppet documentation.
* For more on best practices, methods, and approaches to writing modules, see the [Beginners Guide to Modules](/guides/module_guides/bgtm.html).
* For a more detailed guided tour, also see [the module chapters of Learning Puppet](/learning/modules1.html).

### Writing a Puppet Module

Puppet Labs modules save time, but at some point most users will also need to write their own modules.

#### Writing a Class in a Module

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


> You have written a new module containing a single class. Puppet now knows about this class, and it can be added to the console and assigned to your Windows nodes.
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
* For a complete but succinct guide to the Puppet language's syntax, [see the Puppet 3 language reference](/puppet/3.6/reference/lang_summary.html).
* For complete documentation of the available resource types, [see the type reference](/puppet/3.4/reference/type.html).
* For short, printable references, see [the modules cheat sheet](/module_cheat_sheet.pdf) and [the core types cheat sheet](/puppet_core_types_cheatsheet.pdf).

#### Using Your Custom Module in the Console

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

### Using a Site Module

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


### Summary

You have now performed the core workflows of an intermediate Puppet user. In the course of their normal work, intermediate users:

* Download and modify Forge modules to fit their deployment's needs.
* Create new modules and write new classes to manage many types of resources, including files, services, packages, user accounts, and more.
* Build and curate a site module to safely empower junior admins and simplify the decisions involved in deploying new machines.
* Monitor and troubleshoot events that affect their infrastructure.

* * *

- [Next: System Requirements](./install_system_requirements.html)
