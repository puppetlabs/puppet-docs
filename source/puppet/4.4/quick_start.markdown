---
layout: default
title: "Quick Start » Intro for *Nix Users"
subtitle: "Open Source Puppet Quick Start Guide Series: 3.8.0"
canonical: "/puppet/latest/quick_start.html"
---

Welcome to the Open Source Puppet Quick Start Guide. Whether you’re setting up a Puppet installation for a real deployment or simply want to learn some fundamentals of configuration management with Open Source Puppet, this series of guides provides the steps you need to get up and running relatively quickly. We’ll walk you through Puppet installation and show you how to automate some basic tasks that sysadmins regularly perform.

The following guides present tasks in the order that you would most likely perform them. See the prerequisite sections in each guide to ensure you have the correct setup to perform the steps as they're provided:

### 1. Perform Pre-Install Tasks
Follow [these instructions](./install_pre.html) to ensure you meet the system requirements for Puppet, to designate servers, to decide on a deployment type, and more.

### 2. Install Puppet
Next, you'll install and configure your Puppet master and agents.

 A computer that runs the Puppet Server is called the "master." Follow [these instructions]({{puppetserver}}/install_from_packages.html) to install and configure Puppet Server.

A computer that runs the Puppet agent is called a "Puppet agent" or simply "agent". The Puppet agent regularly pulls configuration catalogs from a master and applies them to the local system.

 Follow these instructions to install a Puppet agent on [Windows](./install_windows.html) or [*nix](./install_linux.html).

To learn how to get your Puppet master and agents to communicate with each other and to ensure your Puppet master will receive certificates from its agents, follow the instructions in the [Master/Agent Communication Quick Start Guide](./quick_start_master_agent_communication.html).

### 3. Create a User and Group
Learn how to create a Puppet user and group with [these instructions](./quick_start_user_group.html).

Instructions are available for *nix only.

### 4. Hello, World!
 Modules contain [classes](./puppet/3.8/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet configures and manages nodes. The instructions in the [Hello World! Quick Start Guide](./quick_start_helloworld.html) lead you through the fundamentals of Puppet module writing. You'll write a very simple module that contains classes to manage your message of the day (motd) and create a Hello, World! notification on the command line.

### 5. Install a Module
 Next, learn how to install a Puppet module by following the [Module Installation Quick Start Guide](./quick_start_module_install_nix.html).

 The instructions are written specifically for *nix, but the installation process is the same for Windows.

### 6. Add Classes
Follow the [Adding Classes Quick Start Guide](./quick_start_adding_classes_nix.html) to add a class to your module. The class you’ll install is derived from the module you installed in the Module Installation Quick Start Guide.

Instructions are available for *nix only.


### 7. Write Modules
Follow the [Writing Modules Quick Start Guide](./quick_writing_nix.html) for exercises in writing modules to help you become more familiar with Puppet modules and module development.

Instructions are available for *nix only.



