---
layout: default
title: "Quick Start » Intro for *Nix Users"
subtitle: "Open Source Puppet Quick Start Guide Series: 3.8.0"
canonical: "/puppet/latest/quick_start.html"
---

Welcome to the Open Source Puppet Quick Start Guide. Whether you’re setting up a Puppet installation for actual deployment or want to learn some fundamentals of configuration management with Open Source Puppet, this series of guides provides the steps you need to get up and running relatively quickly. We’ll walk you through Puppet installation and show you how to automate some basic tasks that sysadmins regularly perform.

The following guides present tasks in the order that you would most likely perform them. See the prerequisite sections in each guide to ensure you have the correct setup to perform the steps as they're provided:

### 1. Perform Pre-Install Tasks
Follow [these instructions](./install_pre.html) to ensure you meet the system requirements for Puppet, designate servers, decide on a deployment type, and more.

### 2. Install Puppet and the Puppet Agent
Next, you'll be installing Puppet and the Puppet agent. [This is the clearest guide for doing so](#/install_linux.html). [links and clarification to come, navigation is messy in the switch from 3.8 to 2015.2]
Follow these instructions to quickly install a Puppet agent. A computer running the Puppet agent is often referred to as an “agent node”. The Puppet agent regularly pulls configuration catalogs from a Puppet master and applies them to the local system.

Instructions are available for [Windows](./quick_start_install_agents_windows.html) and [*nix](./install_linux.html) users.

### 3. Hello, World!
The instructions in [this guide](./quick_start_helloworld.html) lead you through the fundamentals of Puppet module writing. You'll write a very simple module that contains classes to manage your motd (message of the day) and create a Hello, World! notification on the command line.

### 4. Install a Module
Follow these instructions to install a Puppet Labs module. Modules contain [classes](./puppet/3.8/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet configures and manages nodes.

Instructions are available specifically for [*nix](./quick_start_module_install_nix.html) users, but the installation process is the same for both Windows and *nix.

### 5. Add Classes
Follow these instructions to quickly add a class to your Puppet agent. The class you’ll install is derived from the module you installed in the module install QSG.

Instructions are available for [*nix](./quick_start_adding_class_nix.html) users.


### 6. Module Writing Quick Start Guide
Follow these instructions for exercises in writing modules to help you become more familiar with Puppet modules and module development.

Instructions are available for [*nix](./quick_writing_nix.html) users.



