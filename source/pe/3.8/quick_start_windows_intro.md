---
layout: default
title: " PE 3.8 » Quick Start Guide » Intro for Windows Users"
subtitle: "Puppet Enterprise Quick Start Guide For Windows Users"
canonical: "/pe/latest/quick_start_windows_intro.html"

---

Welcome to the Puppet Enterprise (PE) Quick Start Guide for Windows users. Whether you’re setting up a PE installation for actual deployment or want to learn some fundamentals of configuration management with Puppet Enterprise, this series of guides provides the steps you need to get up and running relatively quickly. We’ll walk you through the setup of a monolithic installation, a PE deployment in which the Puppet master, the PE console, and PuppetDB are all installed on one node. The monolithic install is recommended for those who have a small number of nodes to manage, which makes it a good option for trying out PE. The various sections of the Quick Start Guide also show you how to automate some basic tasks that sysadmins regularly perform.

The following guides present tasks in the order that you would most likely perform them. See the prerequisite sections in each guide to ensure you have the correct setup to perform the steps as they're provided.

>**Important**: Windows users should be aware that the Puppet master components can currently only be installed on a Linux machine. Puppet agent components can be installed on Windows machines and you can manage those machines with your Puppet master.

### 1. Install a Monolithic Puppet Enterprise Deployment
Follow [these instructions](./quick_start_install_mono.html) to quickly install a monolithic PE deployment on a linux machine. A monolithic PE deployment entails installing the Puppet master, the PE console, and PuppetDB all on one node. Note that these steps are the same for Windows and *nix users.

### 2. Install the Puppet Agent
Follow [these instructions](./quick_start_install_agents_windows.html) to quickly install a Puppet agent. A computer running the Puppet agent is usually referred to as an “agent node”. The Puppet agent regularly pulls configuration catalogs from a Puppet master and applies them to the local system.

These instructions include how to sign the agent cert request in the console.

### 3. Install a Module
Follow [these instructions](./quick_start_module_install_windows.html) to install a Puppet Labs module. Modules contain [classes](./puppet/3.8/reference/lang_classes.html), which are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures and manages nodes.

### 4. Add Classes from the Console
Follow [these instructions](./quick_start_adding_class_windows.html) to quickly add a class to your Puppet agent. The class you’ll install is derived from the module you installed in the module install QSG.

### 5. Classifying Nodes and Managing users
[These steps](./quick_start_nc_rbac.html) introduce you to node classification and role-based access control. You'll create a new node group and add nodes to it. You'll add classes to a node, a process that's also known as classifying a node. Then you'll create a new user role, and grant that role permission to work with the node group you created.

### 6. Module Writing Quick Start Guide
Follow these instructions for [writing Windows modules](./quick_writing_windows.html) to help you become more familiar with Puppet modules and module development.
