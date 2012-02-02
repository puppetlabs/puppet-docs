---
layout: default
title: "Dashboard Manual: Rake API"
---

Puppet Dashboard's Rake API
=====

This is a chapter of the [Puppet Dashboard 1.2 manual](./index.html).

#### Navigation

* [Installing Dashboard](./bootstrapping.html)
* [Upgrading Dashboard](./upgrading.html)
* [Configuring Dashboard](./configuring.html)
* [Maintaining Dashboard](./maintaining.html)
* [Using Dashboard](./using.html)
* **Rake API**

* * * 


Rake API
-----

Puppet Dashboard provides rake tasks that can create nodes, group nodes, create classes, and assign classes to nodes and groups. You can use these as an API to automate workflows or bypass Dashboard's GUI when performing large tasks.

**This list of tasks applies to Dashboard 1.2.4 and later.** Some of these tasks were not included in prior releases of Dashboard 1.2.

All of these tasks should be run as follows, replacing `<TASK>` with the task name and any arguments it requires:

    # sudo rake -f <FULL PATH TO DASHBOARD'S DIRECTORY>/Rakefile <TASK>

### Node Tasks

`rake node:list [match=<REGULAR EXPRESSION>]`
: List nodes. Can optionally match nodes by regex.

`rake node:add name=<NAME> [groups=<GROUPS>] [classes=<CLASSES>]`
: Add a new node. Classes and groups can be specified as comma-separated lists.

`rake node:del name=<NAME>`
: Delete a node.

`rake node:classes name=<NAME> classes=<CLASSES>`
: Replace the list of classes assigned to a node. Classes must be specified as a comma-separated list.

`rake node:groups name=<NAME> groups=<GROUPS>`
: Replace the list of groups a node belongs to. Groups must be specified as a comma-separated list.

### Class Tasks

`rake nodeclass:list [match=<REGULAR EXPRESSION>]`
: List node classes. Can optionally match classes by regex.

`rake nodeclass:add name=<NAME>`
: Add a new class. This must be a class available to the Puppet autoloader via a module.

`rake nodeclass:del name=<NAME>`
: Delete a node class.

### Group Tasks

`rake nodegroup:list [match=<REGULAR EXPRESSION>]`
: List node groups. Can optionally match gorups by regex.

`rake nodegroup:add name=<NAME> [classes=<CLASSES>]`
: Create a new node group. Classes can be specified as a comma-separated list.

`rake nodegroup:del name=<NAME>`
: Delete a node group.

`rake nodegroup:add_all_nodes name=<NAME>`
: Add every known node to a group.

`rake nodegroup:addclass name=<NAME> class=<CLASS>`
: Assign a class to a group without overwriting its existing classes.

`rake nodegroup:edit name=<NAME> classes=<CLASSES>`
: Replace the classes assigned to a node group. Classes must be specified as a comma-separated list.


* * * 

#### Navigation

* [Installing Dashboard](./bootstrapping.html)
* [Upgrading Dashboard](./upgrading.html)
* [Configuring Dashboard](./configuring.html)
* [Maintaining Dashboard](./maintaining.html)
* [Using Dashboard](./using.html)
* **Rake API**
