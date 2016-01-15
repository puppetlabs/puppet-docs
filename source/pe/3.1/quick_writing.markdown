---
layout: default
title: "PE 3.1 » Quick Start » Writing Modules"
subtitle: "Module Writing Basics"
canonical: "/pe/latest/quick_writing_nix.html"
---

Welcome to the PE 3.1 advanced quick start guide. This document is a continuation of the introductory [quick start guide](./quick_start.html), and is a short walkthrough to help you become more familiar with PE's features. Follow along to learn how to:

* Modify modules obtained from the Forge
* Write your own Puppet module
* Investigate events and view run reports in the console
* Create a site module that composes other modules into machine roles
* Apply Puppet classes to groups with the console

> Before starting this walkthrough, you should have completed the [introductory quick start guide](./quick_start.html). You should still be logged in as root or administrator on your nodes.


Editing a Forge Module
-----

Although many Forge modules are exact solutions that fit your site, many more are _almost_ what you need. Typically, users will edit many of their Forge modules.

### Module Basics

By default, modules are stored in `/etc/puppetlabs/puppet/modules`. (This can be configured with the [`modulepath`](/puppet/3.3/reference/configuration.html#modulepath) setting in `puppet.conf`.)

Modules are directory trees. Their basic structure looks like this:

- `motd/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `motd` class)
        - `public.pp` (contains the `motd::public` class)

Every manifest (.pp) file contains a single class. File names map to class names in a predictable way: `init.pp` will contain a class with the same name as the module, `<NAME>.pp` will contain a class called `<MODULE NAME>::<NAME>`, and `<NAME>/<OTHER NAME>.pp` will contain `<MODULE NAME>::<NAME>::<OTHER NAME>`.

Many modules contain directories other than `manifests`; these will not be covered in this guide.

* For more on how modules work, see [Module Fundamentals](/puppet/3/reference/modules_fundamentals.html) in the Puppet documentation.
* For a more detailed guided tour, see [the module chapters of Learning Puppet](/learning/modules1.html).

### Editing a Manifest

This exercise will modify the desktop shortcut being managed on your Windows node.

* **On the puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/puppet/modules`.
* Run `ls` to view the currently installed modules; note that `motd` and `win_desktop_shortcut` are present.
* Open and begin editing `win_desktop_shortcut/manifests/init.pp`, using the text editor of your choice.
    * If you do not have a preferred Unix text editor, run `nano win_desktop_shortcut/manifests/init.pp`.
        * If Nano is not installed, run `puppet resource package nano ensure=installed` to install it from your OS's package repositories.
* Note that the desktop shortcut is being managed as a `file` resource, and its content is being set with the `content` attribute:

~~~ ruby

    class win_desktop_shortcut {

      if $osfamily == "windows" {
        if $win_common_desktop_directory {

          file { "${win_common_desktop_directory}\\PuppetLabs.URL":
            ensure  => present,
            content => "[InternetShortcut]\nURL=http://puppetlabs.com",
          }

        }
      }

    }
    
~~~

For more on resource declarations, see the [manifests chapter of Learning Puppet](/learning/manifests.html) or the [resources page of the language reference](/puppet/3/reference/lang_resources.html). For more about how file paths with backslashes work in manifests for Windows, see the page on [writing manifests for Windows](/windows/writing.html).

* Change the `ensure` attribute of the `file` resource to `absent`.
* Delete the `content` line of the `file` resource.
* Create two new `file` resources to manage other files on the desktop, mimicking the structure of the first resource:

~~~ ruby
    file { "${win_common_desktop_directory}\\RunningPuppet.URL":
      ensure  => present,
      content => "[InternetShortcut]\nURL=http://docs.puppetlabs.com/windows/running.html",
    }

    file { "${win_common_desktop_directory}\\Readme.txt":
      ensure  => present,
      content => "This node is managed by Puppet. Some files and services cannot be edited locally; contact your sysadmin for details.",
    }
~~~

Make sure that these resources are within the two "if" blocks, alongside the first resource.

* Save and close the file.
* On the console, invoke the "runonce" action on the Windows node.
* Note that the original shortcut is gone, and a new shortcut and `Readme.txt` file have appeared on the desktop.

> Your copy of the Windows example module now behaves differently.
>
> If you had deleted the original resource instead of setting `ensure` to `absent,` it would have become a normal, unmanaged file --- Puppet would not have deleted it, but it also would not have restored it if a local user were to delete it. Puppet does not care about resources that are not declared.

### Editing a Template

* **On the puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/puppet/modules`.
* Open and begin editing `motd/manifests/init.pp`, using the text editor of your choice.
* Note that the content of the `motd` file is being filled with the `template` function, referring to a template within the module:

~~~ ruby
    class motd {
      if $kernel == "Linux" {
        file { '/etc/motd':
          ensure  => file,
          backup  => false,
          content => template("motd/motd.erb"),
        }
      }
    }
~~~

* Close the manifest file, then open and begin editing `motd/templates/motd.erb`.
* Add the line `Welcome to <%= hostname %>` at the beginning of the template file.
* Save and close the file.
* Use the console to invoke the "runonce" action on the agent. Then, go to the agent node and log out and back in again.
* Note that the message of the day has changed to show the machine's hostname.

> Your copy of the `motd` module now behaves differently.
>
> * For more about templates, see [the templates chapter of Learning Puppet][templates] or the [templates section of the Puppet documentation][tempdoc].
> * For more about variables, including "facts" like `hostname`, see [the variables chapter of Learning Puppet][variables] or the [variables page of the language reference][langvar].

[templates]: /learning/templates.html
[tempdoc]: /guides/templating.html
[variables]: /learning/variables.html
[langvar]: /puppet/3/reference/lang_variables.html

Writing a Puppet Module
-----

Third-party modules save time, but at some point **most users will also need to write their own modules.**

### Writing a Class in a Module

This exercise will create a class that manages the permissions of the `fstab`, `passwd`, and `crontab` files.

* **On the puppet master**, make sure you're still in the modules directory, `cd /etc/puppetlabs/puppet/modules`, and then run `mkdir -p core_permissions/manifests` to create the new module directory and its manifests directory.
* Use your text editor to create and open the `core_permissions/manifests/init.pp` file.
* Edit the init.pp file so it contains the following, then save it and exit the editor:

~~~ ruby
    class core_permissions {
      if $osfamily != 'windows' {

        $rootgroup = $operatingsystem ? {
          'Solaris' => 'wheel',
          default   => 'root',
        }
        $fstab = $operatingsystem ? {
          'Solaris' => '/etc/vfstab',
          default   => '/etc/fstab',
        }

        file {'fstab':
          path   => $fstab,
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => "$rootgroup",
        }

        file {'/etc/passwd':
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => "$rootgroup",
        }

        file {'/etc/crontab':
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => "$rootgroup",
        }

      }
    }
~~~

> You have created a new module containing a single class. Puppet now knows about this class, and it can be added to the console and assigned to nodes.
>
> This new class:
>
> * Uses an "if" [conditional][] to only manage \*nix systems.
> * Uses a selector [conditional][] and a variable to change the name of the root user's primary group on Solaris.
> * Uses three [`file` resources][file_type] to manage the `fstab`, `passwd`, and `crontab` files on \*nix systems. These resources do not manage the content of the files, only their ownership and permissions.

[file_type]: /puppet/3.3/reference/type.html#file
[conditional]: /puppet/3/reference/lang_conditional.html

For more information about writing classes, refer to the following documentation:

* To learn how to write resource declarations, conditionals, and classes in a guided tour format, [start at the beginning of Learning Puppet.](/learning/)
* For a complete but succinct guide to the Puppet language's syntax, [see the Puppet 3 language reference](/puppet/3/reference/lang_summary.html).
* For complete documentation of the available resource types, [see the type reference](/puppet/3.3/reference/type.html).
* For short, printable references, see [the modules cheat sheet](/module_cheat_sheet.pdf) and [the core types cheat sheet](/puppet_core_types_cheatsheet.pdf).

### Using a Homemade Module in the Console

* **On the console,** use the "Add classes" button to choose the core_permissions class from the list and make it available, just as in the [previous example](./quick_start.html#using-modules-in-the-console). You may need to wait a moment or two for the class to show up in the list.
* Instead of assigning the class to a single node, **assign it to a group.** Navigate to the default group and use the edit button, then **add the `core_permissions` class to its list of classes.** Click "Update" to assign the class to the group. Do not delete the existing classes, which are necessary for configuring new nodes.

![adding the `core_permissions` class](./images/quick/add_core_permissions.png)

* **On the puppet master node,** manually set dangerous permissions for the `crontab` and `passwd` files. This will make them editable by any unprivileged user.

        # chmod 0666 /etc/crontab /etc/passwd
        # ls -lah /etc/crontab /etc/passwd /etc/fstab
        -rw-rw-rw- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-r--r-- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-rw-rw- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **On the first agent node,** manually set dangerous permissions for the `fstab` file:

        # chmod 0666 /etc/fstab
        # ls -lah /etc/crontab /etc/passwd /etc/fstab
        -rw-r--r-- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-rw-rw- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-r--r-- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **Run puppet agent once on every node.** You can do this by:
    * Doing nothing and waiting 30 minutes
    * Using live management to run the "runonce" action on the agent nodes
    * Triggering a manual run on every node, with either `puppet agent --test` or the "Run Puppet Agent" Start menu item (on Windows)
* **On the master and first agent nodes,** note that the permissions of the three files have been returned to safe defaults, such that only root can edit them:

        # ls -lah /etc/fstab /etc/passwd /etc/crontab
        -rw-r--r-- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-r--r-- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-r--r-- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **On the Windows node,** note that the class has safely done nothing, and has not accidentally created any files in `C:\etc\`.

> You have created a new class from scratch and used it to manage the security of critical files on your \*nix servers.
>
> Instead assigning it directly to nodes, you assigned it to a group. Using node groups can save you time and allow better visibility into your site. They are also crucial for taking advantage of the [cloud provisioning tools](./cloudprovisioner_overview.html). You can create new groups in the console with the "New group" button, and add new nodes to them using the "Edit" button on a group's page.

### Analyzing Your Changes With Event Inspector

**On the console,** load the event inspector by clicking "Events" in the main nav bar. Note the summary pane on the left is showing change events for Classes, Nodes, and Resources. Explore these changes by clicking on "With Changes" in each group. 

![Change Event Summary][event_change_summary-node]

For example, if you click "Nodes... With Changes", you can see that two nodes, agent1.example.com and master.example.com, had successful changes to resources. Two resources were changed on master (specifically, the crontab and passwd files in `/etc/`).  If you drill down further by clicking on one of the changes, you can see the specifics of the change event. Under "Event location" you can see which manifest generated the change, down to the specific line number where the setting is defined. 

![Details of the Change Event][change_event_detail]

To view the run report that logs the puppet run which generated the change, click the "View run report" link at the top of the summary pane. Note that the report header is blue, signifying that changes were made. The run report shows metrics and what happened during that run. The "Log" tab will show the two changes made to file permissions.

![the report tabs, with the log tab circled][report_tabs]

![events logged in the node's report][report_log]

[event_change_summary-node]: ./images/quick/event_summary-node.png
[change_event_detail]: ./images/quick/change_event_detail.png
[report_tabs]: ./images/quick/report_tabs.png
[report_log]: ./images/quick/report_log.png

> You have explored a change event brought about by applying classes created by a new module. You now know how to discover how changes take place, what effects those changes have, and how to find the exact cause of those changes. 
>
> With this knowledge, you have the basics of how to analyze Puppet events with Event Inspector, which will allow you to monitor and troubleshoot in the future. For more details, look at the [event inspector documentation](./console_event-inspector).



Using a Site Module
-----

Many users create a "site" module. Instead of describing smaller units of a configuration, the classes in a site module describe **a complete configuration** for a given _type_ of machine. For example, a site module might contain:

* A `site::basic` class, for nodes that require security management but haven't been given a specialized role yet.
* A `site::webserver` class for nodes that serve web content.
* A `site::dbserver` class for nodes that provide a database server to other applications.

Site modules hide complexity so you can more easily divide labor at your site. System architects can create the site classes, and junior admins can create new machines and assign a single "role" class to them in the console. In this workflow, the console controls **policy,** not fine-grained implementation.

* **On the puppet master,** create the `/etc/puppetlabs/puppet/modules/site/manifests/basic.pp` file, and edit it to contain the following:

~~~ ruby
    class site::basic {
      if $osfamily == 'windows' {
        include win_desktop_shortcut
      }
      else {
        include motd
        include core_permissions
      }
    }
~~~

This class **declares** other classes with the `include` function. Note the "if" conditional that sets different classes for different OS's using the `$osfamily` fact. For more information about declaring classes, see [the modules and classes chapters of Learning Puppet](/learning/modules1.html).

* **On the console,** remove all of the previous example classes from your nodes and groups, using the "edit" button in each node or group page. Be sure to leave the `pe_*` classes in place.
* Add the `site::basic` class to the console with the "add classes" button in the sidebar as before.
* Assign the `site::basic` class to the default group.

> Your nodes are now receiving the same configurations as before, but with a simplified interface in the console. Instead of deciding which classes a new node should receive, you can decide what _type_ of node it is and take advantage of decisions you made earlier.


Summary
-----

You have now performed the core workflows of an intermediate Puppet user. In the course of their normal work, an intermediate user will:

* Download and modify Forge modules that almost (but not quite) fit their deployment's needs.
* Create new modules and write new classes to manage many types of resources, including files, services, packages, user accounts, and more.
* Build and curate a site module to safely empower junior admins and simplify the decisions involved in deploying new machines.
* Monitor and troubleshoot events that affect your infrastructure.

* * *

- [Next: System Requirements](./install_system_requirements.html)
