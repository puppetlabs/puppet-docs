---
layout: default
title: "Quick Start » Helloworld"
subtitle: "Hello World! Quick Start Guide"
canonical: "/puppet/latest/quick_start_helloworld.html"
---

## Overview

The following quick start guide introduces the essential components of Puppet module writing. In this guide, you will write a simple *nix-based module that contains two classes---one that will manage your motd (message of the day) and one that will create a notification on on the command line when you run Puppet.

While the module you'll write doesn't have an incredible amount of functionality, you'll learn the basic module directory structure and how to apply classes to the main manifest. You'll encounter more complex module writing scenarios in other quick start guides.

## Write the `helloworld` Class

Some modules can be large, complex, and require a significant amount of trial and error. This module will be a very simple module to write; it contains just two classes.

> ### A Quick Note about Modules
>
>The first thing to know is that, by default, the modules you use to manage nodes are located in `/etc/puppetlabs/code/environments/production/modules`---this includes modules installed by PE, those that you download from the Forge, and those you write yourself.
>
>**Note**: PE also installs modules in `/opt/puppetlabs/puppet/modules`, but don’t modify anything in this directory or add modules of your own to it.

Modules are directory trees. For this task, you'll create the following files:

 - `helloworld` (the module name)
   - `manifests/`
      - `init.pp` (contains the `helloworld` class)
      - `motd.pp` (contains a file resource that ensures the creation of the MOTD)

**To write the `helloworld` class**:

1. From the command line on the Puppet master, navigate to the modules directory (`cd /etc/puppetlabs/code/environments/production/modules`).
2. Run `mkdir -p helloworld/manifests` to create the new module directory and its manifests directory.
3. In the `manifests` directory, use your text editor to create the `init.pp` file, and edit it so that it contains the following Puppet code.

        class helloworld {

           notify { 'hello, world!': }

        }

4. Save and exit the file.
5. In the `manifests` directory, use your text editor to create the `motd.pp` file, and edit it so that it contains the following Puppet code.

        class helloworld::motd {

           file { '/etc/motd':
           owner  => 'root',
           group  => 'root',
           mode    => '0644',
           content => "hello, world!\n",
           }

        }

6. Save and exit the file.

> That's it! You've written a module that contains two classes that will, once applied, show a notification message when Puppet runs, and manage the motd on your server---we'll take a closer at these actions after we add the classes. 

## Add the `helloworld` and `helloworld::motd` Classes to the Main Manifest

For this procedure, you're going to add the `helloworld` classes to the [default node group](.puppet/latest/reference/lang_node_definitions.html#the-default-node) in the main manifest. You will be using the default node group throughout the Quick Start Guide.

**To create the default node**

1. From the command line on the Puppet master, navigate to the main manifest (`cd /etc/puppetlabs/code/environments/production/manifests`).
2. Use your text editor to create the `site.pp` file, and edit it so that it contains the following Puppet code:

        node default {
        
           notify { 'hello, world!': }
           
           file { '/etc/motd':
           owner  => 'root',
           group  => 'root',
           mode    => '0644',
           content => "hello, world!\n",
           }

        }

3. Save and exit the file.
4. Ensure that there are no errors in the Puppet code by running `puppet parser validate site.pp` on the CLI of your Puppet master. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.
5. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

### Viewing the Results

After you kick off the puppet run, you should see the following on the command line as the 'helloworld' class is applied:

		[root@agent1 ~]# puppet agent -t
		Info: Retrieving pluginfacts
		Info: Retrieving plugin
		Info: Loading facts
		Info: Caching catalog for agent1.example.com
		Info: Applying configuration version '1437172035'
		Notice: hello, world!
		Notice: /Stage[main]/Main/Node[default]/Notify[hello, world!]/message: defined 'message' as 'hello, world!'
		Notice: Applied catalog in 1.25 seconds

From the CLI of your Puppet agent, run `cat /etc/motd`. The result should show `hello, world!`

## Other Resources

> NOTHING YET

---------
Next: ???

