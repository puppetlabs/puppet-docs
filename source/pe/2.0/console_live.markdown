---
layout: default
title: "PE 2.0 » Console » Live Management"
canonical: "/pe/latest/console_navigating_live_mgmt.html"
---

* * *

&larr; [Console: Grouping and Classifying Nodes](./console_classes_groups.html) --- [Index](./) --- [Console: Live Management: Managing Resources](./console_live_resources.html) &rarr;

* * *

Live Management
=====

What's Live Management?
-----

The console's live management page contains tools for inspecting and editing your nodes in real time. It is powered by MCollective.

Since the live management page queries information directly from your nodes rather than using the console's cached reports, it responds more slowly than other parts of the console.

Tabs
-----

The live management page is split into three **tabs,** one for each of its tools.

![The live management tabs][live_nav_tabs]

- The **manage resources** tab lets you browse the resources on your nodes and clone any of them across your infrastructure.
- The **control Puppet** tab lets you tell any node to immediately pull and apply its configuration. It can also temporarily disable puppet agent on some of your nodes to control the rollout speed of new configurations.
- The **advanced tasks** tab is a direct interface to the MCollective agents on your systems, and will auto-generate a GUI for any new agents you install.

The following chapters of this section cover the use of each tab.

The Node List
-----

Every task in live management inspects or modifies a **selection of nodes.** Use the node list in the live management sidebar to choose the nodes for your next action. (This list will only contain nodes that have completed at least one Puppet run, which may take up to 30 minutes after you've [signed its certificate][certsign].)

[certsign]: ./install_basic.html#signing-agent-certificates


![The node list][live_nav_nodelist]

Nodes are listed by their **hostnames** in the live management pages. A node's hostname may match the name Puppet knows it by, but this isn't necessarily the case, especially under cloud environments like EC2.

As long as you stay within the live management page, your selection and filtering in the node list will persist across all three tabs. The node list gets reset once you navigate to a different area of the console.

### Selecting Nodes

Clicking a node selects it or deselects it. Use the "select all" and "select none" controls to select and deselect all nodes that match the current filter.

Only nodes that match the current filter can be selected; you don't have to worry about acidentally modifying "invisibly" selected nodes.

### Filtering by Name

Use the "node filter" field to filter your nodes by hostname. This type of filtering is most useful for small numbers of nodes, or for situations where your hostnames have been assigned according to some logical plan.

![Nodes being filtered by name][live_nav_namefilter]

You can use the following wildcards in the node filter field:

- <big><strong>?</strong></big> matches one character
- <big><strong>\*</strong></big> matches many (or zero) characters

Use the "filter" button or the enter key to confirm your search, then wait for the node list to be updated.

### Advanced Search

You can also filter by Puppet class or by the value of any fact on your nodes. Click the "advanced search" link to reveal these fields.

![The advanced search fields, filtering by the operatingsystem fact][live_nav_advancedsearch]

You can select from some of the more useful fact names with the "common fact names" popover:

![The common fact names popover][live_nav_factlist]

The [inventory data](./console_reports.html#viewing-inventory-data) in the console's node views is another good source of facts to search with.

Filtering by Puppet class can be the most powerful filtering tool on this page, but it requires you to have already sorted your nodes by assigning distinctive classes to them. See the chapter on [grouping and classifying nodes](./console_classes_groups.html) for more details.

[live_nav_advancedsearch]: ./images/console/live_nav_advancedsearch.png
[live_nav_factlist]: ./images/console/live_nav_factlist.png
[live_nav_namefilter]: ./images/console/live_nav_namefilter.png
[live_nav_nodelist]: ./images/console/live_nav_nodelist.png
[live_nav_tabs]: ./images/console/live_nav_tabs.png

* * *

&larr; [Console: Grouping and Classifying Nodes](./console_classes_groups.html) --- [Index](./) --- [Console: Live Management: Managing Resources](./console_live_resources.html) &rarr;

* * *

