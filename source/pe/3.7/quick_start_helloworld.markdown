---
layout: default
title: "PE 3.7 » Quick Start » Helloworld"
subtitle: "Hello World! Quick Start Guide"
canonical: "/pe/latest/quick_start_helloworld.html" 
---

## Overview

The following quick start guide introduces the essential components of Puppet module writing. In this guide, you will write a simple *nix-based module that contains two classes---one that will manage your motd (message of the day) and one that will create a notification on on the command line when you run Puppet. 

While the module you'll write doesn't have an incredible amount of functionality, you'll learn the basic module directory structure and how to apply classes using the PE console. You'll encounter more complex module writing scenarios in other quick start guides. 

## Write the `helloworld` Class

Some modules can be large, complex, and require a significant amount of trial and error. This module will be a very simple module to write; it contains just two classes.  

> ### A Quick Note about Modules
>
>The first thing to know is that, by default, the modules you use to manage nodes are located in `/etc/puppetlabs/puppet/environments/production/modules`---this includes modules installed by PE, those that you download from the Forge, and those you write yourself.
>
>**Note**: PE also installs modules in `/opt/puppet/share/puppet/modules`, but don’t modify anything in this directory or add modules of your own to it.

Modules are directory trees. For this task, you'll create the following files:

 - `helloworld` (the module name)
   - `manifests/`
      - `init.pp` (contains the `helloworld` class)
      - `motd.pp` (contains a file resource that ensures the creation of the MOTD)

**To write the `helloworld` class**:

1. From the command line on the Puppet master, navigate to the modules directory (`cd /etc/puppetlabs/puppet/environments/production/modules`).
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
           mode    => 0644,
           content => "hello, world!\n",
           }

        }

6. Save and exit the file.

> That's it! You've written a module that contains two classes that will, once applied, show a notification message when Puppet runs, and manage the motd on your server---we'll take a closer at these actions after we add the classes. Please note that you'll need to wait a short time for the Puppet server to refresh before the classes are available to add to your nodes.

## Add the `helloworld` and `helloworld::motd` Classes in the Console

[classification_selector]: ./images/quick/classification_selector.png

For this procedure, you're going to add the classes to the **default** group. 

The **default** group contains all the nodes in your deployment (including the Puppet master), but you can [create your own group](./console_classes_groups.html#creating-new-node-groups) or add the classes to individual nodes, depending on your needs. 

**To add the classes to the default group**:

1. In the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]

2. In the __Classification page__, select the __default__ group.

3. Click the __Classes__ tab. 
   
4. In the __Class name__ field, begin typing `helloworld`, and select it from the autocomplete list. 

5. Click __Add class__. 

6. Repeat steps 4 and 5 to add the `helloworld::motd` class. 

7. Click the Commit changes button.

   **Note**: The classes now appear in the list of classes for the __default__ group, but they have not yet been configured on your nodes. For that to happen, you need to kick off a Puppet run. 
   
8. From the command line on the Puppet master, run `puppet agent -t`. 

### Viewing the Results

After you kick off the Puppet run, you should see the following on the command line as the `helloworld` class is applied: 

    [root@master manifests]# puppet agent -t
    Info: Retrieving pluginfacts
    Info: Retrieving plugin
    Info: Loading facts
    Info: Caching catalog for master.example.com
    Info: Applying configuration version '1416331291'
    Notice: hello, world!
    Notice: /Stage[main]/Helloworld/Notify[hello, world!]/message: defined 'message' as 'hello, world!'
    Notice: Finished catalog run in 9.42 seconds
    
Now run `cat /etc/motd`. The result should show, `hello, world!`    

## Other Resources

>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Modules and Manifests](./puppet_modules_manifests.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).
>
> Check out the remainder of the [Quick Start Guide series](./quick_start.html) for additional module writing exercises. 

---------
Next: [Installing Modules (*nix)](./quick_start_module_install_nix.html) or [Installing Modules (Windows)](./quick_start_module_install_windows.html)
