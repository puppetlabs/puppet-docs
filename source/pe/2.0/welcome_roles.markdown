---
layout: default
title: "PE 2.0 » Welcome » Components and Roles"
canonical: "/pe/latest/install_basic.html"
---

* * *

&larr; [Welcome: Getting Started](./welcome_getting_started.html) --- [Index](./) --- [Welcome: New Features and Release Notes](./welcome_whats_new.html) &rarr;

* * *

Components and Roles
========

Puppet Enterprise's features are divided into four main **roles,** any or all of which can be installed on a single system:

The Puppet Agent Role
-----

This role should be installed on **every node** you plan to manage with Puppet Enterprise. Nodes with the puppet agent role:

* Run the puppet agent daemon, which pulls configurations from the puppet master and applies them.
* Listen for MCollective messages, and invoke MCollective agent actions when they receive a valid command.
* Report changes to any resources being audited for PE's compliance workflow.

The Puppet Master Role
-----

This role should be installed on **one node,** which should be a robust, dedicated server; see the [system requirements](./install_system_requirements.html) for more detail. The puppet master server:

* Serves configuration catalogs on demand to puppet agent nodes.
* Routes MCollective messages through its ActiveMQ server.
* Can issue valid MCollective commands (from an administrator logged in as the `peadmin` user). 


The Console Role
-----

This role should be installed on **one node.** The console can be installed on the same server as the puppet master, or they can run on separate servers. The console server: 

* Serves the console web interface, with which administrators can directly edit resources on nodes, trigger immediate Puppet runs, group and assign classes to nodes, view reports and graphs, view inventory information, approve and reject audited changes, and invoke MCollective agent actions. 
* Collects reports from and serves node definitions to the puppet master


The Cloud Provisioner Role
-----

This role should be installed on a secure node to which administrators have shell access. It installs the cloud provisioner tool, which allows a user to:

* Create new VMware and Amazon EC2 virtual machine instances.
* Install Puppet Enterprise on any virtual or physical system.
* Add newly provisioned nodes to a group in the console. 

* * *

&larr; [Welcome: Getting Started](./welcome_getting_started.html) --- [Index](./) --- [Welcome: New Features and Release Notes](./welcome_whats_new.html) &rarr;

* * *

