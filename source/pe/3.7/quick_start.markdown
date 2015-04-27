---
layout: default
title: "PE 3.8 » Quick Start » Intro for *Nix Users"
subtitle: "Puppet Enterprise Quick Start Guide Series: 3.8.0"
canonical: "/pe/latest/quick_start.html"
---

Welcome to the Puppet Enterprise Quick Start Guide. Whether you’re setting up a PE installation for actual deployment or want to learn some fundamentals of configuration management with Puppet Enterprise, this series of guides provides the steps you need to get up and running relatively quickly. We’ll walk you through the setup of a monolithic (all-in-one node) installation and show you how to automate some basic tasks that sysadmins regularly perform.

The following guides present tasks in the order that you would most likely perform them. See the prerequisite sections in each guide to ensure you have the correct setup to perform the steps as they're provided:

### 1. Install a Monolithic Puppet Enterprise Deployment
Follow [these instructions](./quick_start_install_mono.html) to quickly install a monolithic PE deployment on a linux machine. A monolithic PE deployment entails installing the Puppet master, the PE console, and PuppetDB all on one node. Note you will need to review some prerequisites.

### 2. Install the Puppet Agent
Follow these instructions to quickly install a Puppet agent. A computer running the Puppet agent is usually referred to as an “agent node”. The Puppet agent regularly pulls configuration catalogs from a Puppet master and applies them to the local system.

Instructions are available for [Windows](./quick_start_install_agents_windows.html) and [*nix](./quick_start_install_agents_nix.html) users. These instructions include how to sign the agent cert request in the console.

### 3. Hello, World!
The instructions in [this guide](./quick_start_helloworld.html) lead you through the fundamentals of Puppet module writing. You'll write a very simple module that contains classes to manage your motd (message of the day) and create a Hello, World! notification on the command line.

### 4. Install a Module
Follow these instructions to install a Puppet Labs module. Modules contain [classes](./puppet/3.8/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures and manages nodes.

Instructions are available for [Windows](./quick_start_module_install_windows.html) and [*nix](./quick_start_module_install_nix.html) users.

### 5. Add Classes from the Console
Follow these instructions to quickly add a class to your Puppet agent. The class you’ll install is derived from the module you installed in the module install QSG.

Instructions are available for [Windows](./quick_start_adding_class_windows.html) and [*nix](./quick_start_adding_class_nix.html) users.

### 6. Classifying Nodes and Managing users
These steps introduce you to node classification and role-based access control. You'll create a new node group and add nodes to it. You'll add classes to a node, a process that's also known as classifying a node. Then you'll create a new user role, and grant that role permission to work with the node group you created.

See [this guide](./quick_start_nc_rbac.html) for instructions.

### 7. Module Writing Quick Start Guide
Follow these instructions for exercises in writing modules to help you become more familiar with Puppet modules and module development.

Instructions are available for [Windows](./quick_writing_windows.html) and [*nix](./quick_writing_nix.html) users.



