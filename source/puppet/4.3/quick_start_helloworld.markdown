---
layout: default
title: "Quick Start » Hello World!"
subtitle: "Hello World! Quick Start Guide"
canonical: "/puppet/latest/quick_start_helloworld.html"
---

## Overview

The following Quick Start Guide introduces the essential components of Puppet module writing. In this guide, you will write a simple *nix-based module that contains two classes---one that manages your message of the day (motd) and one that creates a notification on the command line when you run Puppet.

While the module you'll write doesn't have an incredible amount of functionality, you'll learn the basic module directory structure and how to apply classes to the main manifest. You'll encounter more complex module writing scenarios in other quick start guides.

> For this walk-through, log in as root or administrator on your nodes.

## Write the `helloworld` Class

Some modules can be large, complex, and require a significant amount of trial and error. This module will be a very simple module to write; it contains just two classes.

> ### A Quick Note about Modules
>
>By default, Puppet keeps modules in an environment's [`modulepath`](./dirs_modulepath.html), which for the production environment defaults to `/etc/puppetlabs/code/environments/production/modules`. This includes modules that Puppet installs, those that you download from the Forge, and those you write yourself.
>
>**Note:** Puppet also creates another module directory: `/opt/puppetlabs/puppet/modules`. Don't modify or add anything in this directory, including modules of your own.

Modules are directory trees. For this task, you'll create the following structure and files:

 - `helloworld/` (the module name)
   - `manifests/`
      - `init.pp` (manifest file that contains the `helloworld` class)
      - `motd.pp` (manifest file that contains a file resource that ensures the creation of the motd)

Every manifest (.pp file) in a module contains a single class. File names map to class names in a predictable way, described in the [Autoloader Behavior documentation](https://docs.puppetlabs.com/puppet/latest/lang_namespaces.html#autoloader-behavior). The `init.pp` file is a special case that contains a class named after the module, `helloworld`. Other manifest files contain classes called `<MODULE NAME>::<FILE NAME>`, or in this case, `helloworld::motd`.

* For more on how modules work, see [Module Fundamentals](/puppet/3.8/modules_fundamentals.html) in the Puppet documentation.
* For more on best practices, methods, and approaches to writing modules, see the [Beginners Guide to Modules](/guides/module_guides/bgtm.html).
* For a more detailed guided tour, also see [the module chapters of Learning Puppet](/learning/modules1.html).

**To write the `helloworld` class**:

1. From the command line on the Puppet master, navigate to the modules directory: `cd /etc/puppetlabs/code/environments/production/modules`.
2. Run `mkdir -p helloworld/manifests` to create the new module directory and its manifests directory.
3. In the `manifests` directory, use your text editor to create the `init.pp` file, and edit it so that it contains the following Puppet code: 

        class helloworld {
           notify { 'hello, world!': }
        }

4. Save and exit the file.
5. In the `manifests` directory, use your text editor to create the `motd.pp` file, and edit it so that it contains the following Puppet code:

        class helloworld::motd {

           file { '/etc/motd':
           owner  => 'root',
           group  => 'root',
           mode    => '0644',
           content => "hello, world!\n",
           }

        }

6. Save and exit the file.

>  Hooray! You've written a module that contains two classes that will, once applied, show a notification message when Puppet runs, and manage the motd on your server. 

## Add the `helloworld` and `helloworld::motd` Classes to the Main Manifest

For this procedure, you're going to add the `helloworld` classes to the default node in the main manifest. You will be using the default node throughout the Quick Start Guide.

The [default node](.puppet/latest/reference/lang_node_definitions.html#the-default-node) is a special value for node names. If no node statement matching a given node name can be found, the default node will be used, making it an easy way to ensure compilation for any node will be successful. In Puppet, a given agent will only get the contents of one node definition. In order to simplify this process, and ensure that compilations are always successful, this guide will consistently use the `default` node in the `site.pp` manifest. The default node's properties apply to all the agents which have not had definitions applied to them yet, so in the case of this guide, the contents of the default node will apply to all of your agents.

**To create the default node**

1. From the command line on the Puppet master, navigate to the main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to create the `site.pp` file, and edit it so that it contains the following Puppet code:

        node default {
        
        }

3. Add the following Puppet code within `node default {  }`:

        class { 'helloworld': }
		class { 'helloworld::motd': }
		   
4. Save and exit the file.

5. Ensure that there are no errors in the Puppet code by running `puppet parser validate site.pp` on your Puppet master. The parser will return nothing if there are no errors. If it does detect a syntax error, open the file again and fix the problem before continuing.

6. From the CLI of your Puppet agent, use `puppet agent -t` to trigger a Puppet run.

### Viewing the Results

After you kick off the puppet run, you will see the following on the command line as the `helloworld` class is applied:

		[root@agent1 ~]# puppet agent -t
		Info: Retrieving pluginfacts
		Info: Retrieving plugin
		Info: Loading facts
		Info: Caching catalog for agent1.example.com
		Info: Applying configuration version '1437172035'
		Notice: hello, world!
		Notice: /Stage[main]/Main/Node[default]/Notify[hello, world!]/message: defined 'message' as 'hello, world!'
		Notice: Applied catalog in 1.25 seconds

From the command line of your agent, run `cat /etc/motd`. The result should show `hello, world!`

## Other Resources

>There are plenty of resources about modules and the creation of modules that you can reference. Check out [Modules and Manifests](./puppet_modules_manifests.html), the [Beginner's Guide to Modules](/guides/module_guides/bgtm.html), and the [Puppet Forge](https://forge.puppetlabs.com/).
>
> Check out the remainder of the [Quick Start Guide series](./quick_start.html) for additional module writing exercises.

---------
Next: [Installing Modules (*nix)](./quick_start_module_install_nix.html)