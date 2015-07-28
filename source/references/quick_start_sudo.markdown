---
layout: default
title: "Quick Start » Sudo Users"
subtitle: "Sudo Users Quick Start Guide"
canonical: "/puppet/latest/quick_start_sudo.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Puppet Enterprise Sudo Users Quick Start Guide. This document provides instructions for getting started managing sudo privileges across your Puppet deployment, using a module from the Puppet Forge in conjunction with a simple module you will write.

In most cases, you want to manage sudo on your agent nodes to control which system users have access to elevated privileges. Using this guide, you will:

* [install the saz-sudo module as the foundation for your management of sudo privileges ](#install-the-saz-sudo-module).
* [write a simple module that contains a class called `privileges` to manage a few resources that set privileges for certain users, which will be managed by the saz-sudo module](#write-the-privileges-class).
* [use the main manifest to add classes from the privileges and sudo modules to your agent nodes](#use-the-main-manifest-to-add-the-privileges-and-sudo-classes).

## Install Puppet and the Puppet Agent

If you haven't already done so, you'll need to get Puppet installed. See the [system requirements][sys_req] for supported platforms.

1. [Download and verify the appropriate tarball][downloads].
2. Refer to the [installation overview][install_overview] to determine how you want to install Puppet, and then follow the instructions provided.
3. Refer to the [agent installation instructions][agent_install] to determine how you want to install your Puppet agent(s), and then follow the instructions provided.
4. Follow the [Quick start Guide for Users and Groups](./quick_start_user_group) to set up your `jargyle` user and `web` group.

>**Tip**: Follow the instructions in the [NTP Quick Start Guide](./quick_start_ntp.html) to have Puppet ensure time is in sync across your deployment.

>**Note**: You can add the sudo and privileges classes to as many agents as needed. For ease of explanation, our console images or instructions might show only two agent nodes.

## Install the saz-sudo Module

The saz-sudo module, available on the Puppet Forge, is one of many modules written by a member of our user community.  You can learn more about the module by visiting [http://forge.puppetlabs.com/saz/sudo](http://forge.puppetlabs.com/saz/sudo).

**To install the saz-sudo module**:

From the Puppet master, run `puppet module install saz-sudo`.

You should see output similar to the following:

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── saz-sudo (v2.3.6)
              └── puppetlabs-stdlib (3.2.2) [/opt/puppet/share/puppet/modules]

> That's it! You've just installed the saz-sudo module. You'll need to wait a short time for the Puppet server to refresh before the classes are available to add to your agent nodes.

## Write the `privileges` Class

Some modules can be large, complex, and require a significant amount of trial and error as you create them, while others often work "right out of the box." This module will be a very simple module to write: it contains just one class.

> ### A Quick Note about Modules Directories
>
>The first thing to know is that, by default, the modules you use to manage nodes are located in `/etc/puppetlabs/puppet/environments/production/modules`---this includes modules installed by Puppet, those that you download from the Forge, and those you write yourself.
>
>**Note**: Puppet also installs modules in `/opt/puppet/share/puppet/modules`, but don’t modify anything in this directory or add modules of your own to it.
>
>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Modules and Manifests](./puppet_modules_manifests.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).

Modules are directory trees. For this task, you'll create the following files:

 - `privileges` (the module name)
   - `manifests/`
      - `init.pp` (contains the `privileges` class)

**To write the `privileges` class**:

1. From the command line on the Puppet master, navigate to the modules directory (`cd /etc/puppetlabs/code/environments/production/modules`).
2. Run `mkdir -p privileges/manifests` to create the new module directory and its manifests directory.
3. From the `manifests` directory, use your text editor to create the `init.pp` file, and edit it so it contains the following Puppet code.

        class privileges {
          user { 'root':
            ensure   => present,
            password => '$1$oST1TkX7$p21hU2qzMkR4Iy7HK6zWq0',
            shell    => '/bin/bash',
            uid      => '0',
          }

          sudo::conf { 'admins':
            ensure  => present,
            content => '%admin ALL=(ALL) ALL',
          }

          sudo::conf { 'wheel':
            ensure  => present,
            content => '%wheel ALL=(ALL) ALL',
          }

        }

5. Save and exit the file.

> That's it! You've written a module that contains a class that, once applied, ensures that your agent nodes have the correct sudo privileges set for the root user and the “admin” and “wheel” groups.
>
> Note the following about the resources in the `privileges` class:
>
> * `user ‘root’`: This resource ensures that the root user has a centrally defined password and shell. Puppet enforces this configuration and report on, and remediate, any drift detected, such as if a rogue admin logs in and changes the password on an agent node.
>
> * `sudo::conf ‘admins’`: Create a sudoers rule to ensure that members of the admin group have the ability to run any command using sudo. This resource creates configuration fragment file to define this rule in `/etc/sudoers.d/`. It will be called something like `10_admins`.
>
> * `sudo::conf ‘wheel’`: Create a sudoers rule to ensure that members of the wheel group have the ability to run any command using sudo. This resource creates a configuration fragment to define this rule in `/etc/sudoers.d/`. It will be called something like `10_wheel`.

## Use the Main Manifest to Add the Privileges and Sudo Classes

1. From the command line on the Puppet master, navigate to the main manifest (`cd /etc/puppetlabs/code/environments/production/manifests`).
2. Open `site.pp` with your text editor and add the following Puppet code to the `default` node:

			class { 'sudo': }
    		sudo::conf { 'web':
    		  content  => "web ALL=(ALL) NOPASSWD: ALL",
    		}
    		sudo::conf { 'admins':
      		  priority => 10,
      		  content  => "%admins ALL=(ALL) NOPASSWD: ALL",
    		}
   		    sudo::conf { 'jargyle':
      		  priority => 60,
      		  content  => "jargyle ALL=(ALL) NOPASSWD: ALL",
    		}

3. Save and exit the file.
4. From the CLI of your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.
5. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

> That's it! You have successfully installed the Sudo module and applied privileges and classes to it. 

From the CLI of the Puppet agent, run `sudo -l -U jargyle` to confirm it worked. The results should resemble the following:

	 Matching Defaults entries for jargyle on this host:
    !visiblepw, always_set_home, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE
    INPUTRC KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS
    LC_CTYPE", env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES",
    env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME
    LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/usr/local/bin\:/sbin\:/bin\:/usr/sbin\:/usr/bin

	 User jargyle may run the following commands on this host:
    (ALL) NOPASSWD: ALL
    
> That's it! Yay.




