---
layout: default
title: "PE 2.0 » Puppet » Overview"
canonical: "/pe/latest/puppet_overview.html"
---

* * *

&larr; [Console: Live Management: Advanced Tasks](./console_live_advanced.html) --- [Index](./) --- [Puppet: Your First Module](./puppet_first_module.html) &rarr;

* * *

Puppet For New Users: Overview
=====

Puppet is divided into two main components:

* The puppet agent daemon runs on every agent node. At regular intervals, it pulls configuration "catalogs" from the puppet master and applies them to the local system. (Puppet catalogs are idempotent: they can be run any number of times and will always converge to the same state.)
* The puppet master service runs on a central server. It decides what configurations each agent node should receive, and compiles nodes' catalogs from "manifests" written by a user.


Where Configurations Come From
-----

Configurations for nodes are compiled from [**manifests**](/learning/manifests.html), which are documents written in Puppet's custom language. Manifests declare [**resources**](/learning/ral.html), each of which represents the desired state of some _thing_ (software package, service, user account, file...) on a system. Resources are grouped into [**classes**](/learning/modules1.html#classes), and classes are grouped into [**modules**](/learning/modules1.html#modules). Modules are structured collections of manifest files where each file contains a single class (or defined type).

The puppet master's collection of modules lives in the `/etc/puppetlabs/puppet/modules` directory. Any class stored in one of the master's modules can be assigned to any of your nodes.

How Configurations are Assigned to Nodes
-----

In Puppet Enterprise, the console controls which classes are assigned to nodes. You can assign classes to nodes individually, or you can collect nodes into groups and assign classes to large numbers of nodes at a time. You can also declare variables ("parameters") that can be read by any of the classes assigned to the node.

When an agent node requests its catalog from the master, the master asks the console which classes and parameters to use, then compiles those classes into the node's catalog.

What Nodes Do With Catalogs
-----

The heart of Puppet is the resource abstraction layer (RAL), which lets the puppet agent turn abstract resource declarations into concrete actions specific to the local system. Once the agent has its catalog of resource declarations, it uses the system's own tools to bring those resources into their desired state.

When New Configurations Take Effect
-----

By default, puppet agent will pull a catalog and run it every 30 minutes (counted from when the agent service started, rather than on the half-hour). You can change this by setting the [`runinterval`](/puppet/2.7/reference/configuration.html#runinterval) option in an agent's [`/etc/puppetlabs/puppet/puppet.conf`](/puppet/3.6/reference/config_file_main.html) file to a new value. (The `runinterval` is measured in seconds.)

If you need a node or group of nodes to retrieve a new configuration _now,_ use the "Control Puppet" section of the console's live management page. 

* * *

&larr; [Console: Live Management: Advanced Tasks](./console_live_advanced.html) --- [Index](./) --- [Puppet: Your First Module](./puppet_first_module.html) &rarr;

* * *

