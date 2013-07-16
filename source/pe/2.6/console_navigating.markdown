---
layout: default
title: "PE 2.6  » Console » Navigating"
subtitle: "Navigating the Console"
canonical: "/pe/latest/console_navigating.html"
---

Getting Around
-----

Navigate between sections of the console using the menu bar at the top. 

![The navigation bar][nav_navbar]

All of the menu items deal with aspects of your nodes and their configuration except:

- ***Help*** which provides help, obviously.
- Your ***username*** which provides access to your account information and, if you are an admin user, also provides access to user management tools. For information on the user management tools, see the [User Management and Authentication page](./console_auth.html).

**Note:** For users limited to read-only access, some elements of the console shown here will not be visible.

What's in the Console?
-----

The console deals with three main objects:

- A **node** represents a single system being managed by Puppet. It can have classes applied to it, and can be a member of groups.
- A **group** is an arbitrary set of nodes. It can have classes applied to it, and can contain nodes.
- A **class** represents a Puppet class available in your puppet master's collection of modules. It can be applied to nodes or to groups. 

### Nodes

![The nodes page][nav_node]

After a node completes its first Puppet run (which may take up to 30 minutes after you've [signed its certificate][certsign]), it will appear in the console and can be added to groups and have classes applied to it.

[certsign]: ./install_basic.html#signing-agent-certificates

Since the console receives a report every time Puppet runs on a node, it keeps a running count in the sidebar of what state your nodes are in:

![The node state display][nav_nodestatus]

This can tell you at a glance whether your nodes have suddenly started failing their Puppet runs, whether any nodes have stopped responding, and whether Puppet is making many changes to your systems. Click these state totals to see complete lists of nodes in each state. 

Individual node pages contain graphs of recent runs, lists of reports, inventory data, compliance data, and any classes the node has or groups it's a part of.

### Groups

![A group page][nav_group]

Groups contain nodes. Any classes applied to a group will also be applied to all the nodes in it. 

### Classes

Classes aren't automatically detected or validated; you have to enter a class's name yourself before you can apply it to a node or group. Once you do, though, you're all set; Puppet will apply it as needed, and you can click the class in the console to see which nodes it's been assigned to. 

[nav_group]: ./images/console/nav_group.png
[nav_navbar]: ./images/console/nav_navbar.png
[nav_node]: ./images/console/nav_node.png
[nav_nodestatus]: ./images/console/nav_nodestatus.png


* * * 

- [Next: Viewing Reports and Inventory Data](./console_reports.html)
