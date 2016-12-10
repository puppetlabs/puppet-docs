---
layout: default
title: "Quick Start » Sudo Users"
subtitle: "Sudo Users Quick Start Guide"
canonical: "/puppet/latest/quick_start_sudo.html"
---

[downloads]: https://puppetlabs.com/puppet/puppet-open-source
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Open Source Puppet Sudo Users Quick Start Guide. This document provides instructions for getting started managing sudo privileges across your Puppet deployment, using a module from the Puppet Forge in conjunction with a simple module you will write.

In most cases, managing sudo on your agents involves controlling which users have access to elevated privileges. Using this guide, you will learn how to do the following tasks: 

* [Install the `saz-sudo` module as the foundation for managing sudo privileges](#install-the-saz-sudo-module).
* [Write a simple module that contains a class called `privileges` to manage a resource that sets privileges for certain users, which will be managed by the `saz-sudo` module](#write-the-privileges-class).
* [Add classes from the privileges and sudo modules to your agents](#use-the-main-manifest-to-add-the-privileges-and-sudo-classes).

> Before starting this walk-through, complete the previous exercises in the [essential configuration tasks](./quick_start_essential_config.html). Log in as root or administrator on your nodes.

> **Prerequisites**: This guide assumes you've already [installed Puppet](/puppetserver/2.1/install_from_packages.html), and have installed at least one [*nix agent](./install_linux.html).

>**Note**: You can add the sudo and privileges classes to as many agents as needed, although we describe only one for ease of explanation. 

## Install the `saz-sudo` Module

The `saz-sudo` module, available on the Puppet Forge, is one of many modules written by a member of the Puppet user community.  You can learn more about the module by visiting [https://forge.puppetlabs.com/saz/sudo](https://forge.puppetlabs.com/saz/sudo).

**To install the `saz-sudo` module**:

As the root user on the Puppet master, run `puppet module install saz-sudo`.

You should see output similar to the following:

 		Preparing to install into /etc/puppetlabs/code/environments/production/modules  ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── saz-sudo (v2.3.6)
              └── puppetlabs-stdlib (3.2.2) [/opt/puppet/share/puppet/modules]

> That's it! You've just installed the `saz-sudo` module.

## Write the `privileges` Class

Some modules can be large, complex, and require a significant amount of trial and error as you create them, while others often work right out of the box. This module will be a very simple module to write. It contains just one class.

> ### A Quick Note about Modules Directories
>
>By default, Puppet keeps modules in an environment's [`modulepath`](./dirs_modulepath.html), which for the production environment defaults to `/etc/puppetlabs/code/environments/production/modules`. This includes modules that Puppet installs, those that you download from the Forge, and those you write yourself.
>
>**Note:** Puppet also creates another module directory: `/opt/puppetlabs/puppet/modules`. Don't modify or add anything in this directory, including modules of your own.
>
>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Modules and Manifests](./puppet_modules_manifests.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).

Modules are directory trees. For this task, you'll create the following files:

 - `privileges/` (the module name)
   - `manifests/`
      - `init.pp` (contains the `privileges` class)

**To write the `privileges` class**:

1. From the command line on the Puppet master, navigate to the modules directory: `cd /etc/puppetlabs/code/environments/production/modules`.
2. Run `mkdir -p privileges/manifests` to create the new module directory and its manifests directory.
3. From the `manifests` directory, use your text editor to create the `init.pp` file, and edit it so it contains the following Puppet code:

        class privileges {
        
		  sudo::conf { 'admins':
          ensure  => present,
          content => '%admin ALL=(ALL) ALL',
          }

        }

5. Save and exit the file.

> That's it! You've written a module that contains a class that, once applied, ensures that your agents have the correct sudo privileges set for the root user and the “admins” and “wheel” groups.
>
> Note the following about the resource in the `privileges` class:
>
> * The `sudo::conf ‘admins’` line creates a sudoers rule to ensure that members of the `admins` group have the ability to run any command using sudo. This resource creates configuration fragment file to define this rule in `/etc/sudoers.d/`. It will be called something like `10_admins`.

## Add the Privileges and Sudo Classes

1. From the command line on the Puppet master, navigate to the main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Open `site.pp` with your text editor and add the following Puppet code to the `default` node:

~~~puppet
class { 'sudo': }
sudo::conf { 'web':
  content  => "web ALL=(ALL) NOPASSWD: ALL",
}
class { 'privileges': }
sudo::conf { 'jargyle':
  priority => 60,
  content  => "jargyle ALL=(ALL) NOPASSWD: ALL",
}
~~~

3. Save and exit the file.

4. From the command line on your Puppet master, run `puppet parser validate site.pp` to ensure that there are no errors. The parser will return nothing if there are no errors.

5. From the command line on your Puppet agent, run `puppet agent -t` to trigger a Puppet run.

> That's it! You have successfully installed the Sudo module and applied privileges and classes to it. 
>
> Note the following about your new resources in the `site.pp` file:
>
> * `sudo::conf ‘web’`: Creates a sudoers rule to ensure that members of the web group have the ability to run any command using sudo. This resource creates a configuration fragment file to define this rule in `/etc/sudoers.d/`.
>
> * `sudo::conf ‘admins’`: Creates a sudoers rule to ensure that members of the admins group have the ability to run any command using sudo. This resource creates a configuration fragment file to define this rule in `/etc/sudoers.d/`. It will be called something like `10_admins`.
>
> * `sudo::conf ‘jargyle’`: Creates a sudoers rule to ensure that the user `jargyle` has the ability to run any command using sudo. This resource creates a configuration fragment to define this rule in `/etc/sudoers.d/`. It will be called something like `60_jargyle`.

From the command line on the Puppet agent, run `sudo -l -U jargyle` to confirm it worked. The results should resemble the following:

	 Matching Defaults entries for jargyle on this host:
    !visiblepw, always_set_home, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE
    INPUTRC KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS
    LC_CTYPE", env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES",
    env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME
    LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/usr/local/bin\:/sbin\:/bin\:/usr/sbin\:/usr/bin

	 User jargyle may run the following commands on this host:
    (ALL) NOPASSWD: ALL
    
    
### Other Resources

For more information about working with Puppet and Sudo Users, check out our [Module of The Week: saz/sudo - Manage sudo configuration](https://puppetlabs.com/blog/module-of-the-week-sazsudo-manage-sudo-configuration) blog post.

Puppet Labs offers many opportunities for learning and training, from formal certification courses to guided online lessons. We've noted one below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* [Learning Puppet](/learning/) is a series of exercises on various core topics about deploying and using Puppet.
* The Puppet Labs workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).
* Learn about [Managing sudo Privileges](https://puppetlabs.com/learn/managing-sudo-privileges) through this online training workshop.

----------

Next: [Firewall Quick Start Guide](./quick_start_firewall.html)



