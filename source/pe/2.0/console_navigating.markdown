---
layout: default
title: "PE 2.0 » Console » Navigating"
canonical: "/pe/latest/console_navigating.html"
---

* * *

&larr; [Console: Accessing the Console](./console_accessing.html) --- [Index](./) --- [Console: Viewing Reports and Inventory Data](./console_reports.html) &rarr;

* * *

Navigating the Console
=====

Getting Around
-----

Navigate between sections of the console using the navigation bar at the top. 

![The navigation bar][nav_navbar]

What's in the Console?
-----

The console deals with three main objects:

- A **node** represents a single system being managed by Puppet. It can have classes applied to it, and can be a member of groups.
- A **group** is an arbitrary set of nodes. It can have classes applied to it, and can contain nodes.
- A **class** represents a Puppet class available in your puppet master's collection of modules. It can be applied to nodes or to groups. 

### Nodes

![A node page][nav_node]

After a node completes its first Puppet run (which may take up to 30 minutes after you've [signed its certificate][certsign]), it will appear in the console, and can be added to groups and have classes applied to it.

[certsign]: ./install_basic.html#signing-agent-certificates

Since the console receives a report every time Puppet runs on a node, it keeps a running count in the sidebar of what state your nodes are in:

![The node state display][nav_nodestatus]

This can tell you at a glance whether your nodes have suddenly started failing their Puppet runs, whether any nodes have stopped responding, and whether Puppet is making many changes to your systems. You can click through these state totals to see complete lists of nodes in each state. 

Individual node pages contain graphs of recent runs, lists of reports, inventory data, compliance data, and any classes the node has or groups it's a part of.

### Groups

![A group page][nav_group]

Groups contain nodes. Any classes applied to a group will also be applied to all the nodes in it. 

### Classes

Classes aren't automatically detected or validated; you have to enter a class's name yourself before you can apply it to a node or group. Once you do, though, you're good to go; Puppet will apply it as needed, and you can click the class in the console for a view of which nodes it's been assigned to. 

[nav_group]: ./images/console/nav_group.png
[nav_navbar]: ./images/console/nav_navbar.png
[nav_node]: ./images/console/nav_node.png
[nav_nodestatus]: ./images/console/nav_nodestatus.png

* * *

&larr; [Console: Accessing the Console](./console_accessing.html) --- [Index](./) --- [Console: Viewing Reports and Inventory Data](./console_reports.html) &rarr;

* * *

