---
layout: default
title: "PE 3.0 » Console » Navigating Live Management"
subtitle: "Navigating Live Management"
---

What is Live Management?
-----

The PE console's live management page is an interface to PE's orchestration engine. It contains three important tools to help you inspect and command your nodes in real time.

> **NOTE:** To use live management, you must be logged in as a [read-write or admin level user](./console_auth.html#user-access-and-privileges). Read-only users cannot access the live management page and will not see the associated UI elements.

> **Note:** Since the live management page queries information directly from your nodes rather than using the console's cached reports, it responds more slowly than other parts of the console.

Tabs
-----

The live management page is split into three **tabs,** one for each of its tools.

![The live management tabs][live_nav_tabs] TODO screenshot

- [The **Browse Resources** tab](./orchestration_resources.html) lets you browse, search, inspect, and compare resources on any subset of your nodes.
- [The **Control Puppet** tab](./orchestration_puppet.html) lets you tell any node to immediately pull and apply its configuration. You can also temporarily disable puppet agent on some of your nodes to control the rollout speed of new configurations.
- [The **Advanced Tasks** tab](./orchestration_invoke_console.html) lets you directly invoke orchestration actions on your systems. It can invoke both the [built-in actions](./orchestration_actions.html) and any [custom actions](./orchestration_adding_actions.html) you've installed.

Subsequent chapters of this section cover the use of each tab.

The Node List
-----

Every task in live management inspects or modifies a **selection of nodes.** Use the node list in the live management sidebar to choose the nodes for your next action. (This list will only contain nodes that have completed at least one Puppet run, which may take up to 30 minutes after you've [signed their certificates][certsign].)

[certsign]: ./console_cert_mgmt.html


![The node list][live_nav_nodelist] TODO screenshot

Nodes are listed by the same Puppet certificate names used in the rest of the console interface.

As long as you stay within the live management page, your selection and filtering in the node list will persist across all three tabs. The node list gets reset once you navigate to a different area of the console.

### Selecting Nodes

Clicking a node selects it or deselects it. Use the "select all" and "select none" controls to select and deselect all nodes that match the current filter.

Only visible nodes --- i.e. nodes that match the current filter --- can be selected. (Note that an empty filter shows all nodes.) You don't have to worry about accidentally commanding "invisibly" selected nodes.

### Filtering by Name

Use the "node filter" field to filter your nodes by hostname. This type of filtering is most useful for small numbers of nodes, or for situations where your hostnames have been assigned according to some logical plan.

![Nodes being filtered by name][live_nav_namefilter] TODO screenshot

You can use the following wildcards in the node filter field:

- <big><strong>?</strong></big> matches one character
- <big><strong>\*</strong></big> matches many (or zero) characters

Use the "filter" button or the enter key to confirm your search, then wait for the node list to be updated.

> **Hint:** Use the "Wildcards allowed" link for a quick pop-over reminder.

### Advanced Search

You can also filter by Puppet class or by the value of any fact on your nodes. Click the "advanced search" link to reveal these fields.

![The advanced search fields, filtering by the operatingsystem fact][live_nav_advancedsearch] TODO screenshot

> **Hint:** Use the "common fact names" link for a pop-over list of the most useful facts. Click a fact name to copy it to the filter field.
>
> ![The common fact names popover][live_nav_factlist] TODO screenshot

You can browse the [inventory data](./console_reports.html#viewing-inventory-data) in the console's node views to find fact values to search with; this can help when looking for nodes similar to a specific node. You can also check the [list of core facts](/facter/1.7/core_facts.html) for valid fact names.

Filtering by Puppet class can be the most powerful filtering tool on this page, but it requires you to have already sorted your nodes by assigning distinctive classes to them. See the chapter on [grouping and classifying nodes](./console_classes_groups.html) for more details.

[live_nav_advancedsearch]: ./images/console/live_nav_advancedsearch.png
[live_nav_factlist]: ./images/console/live_nav_factlist.png
[live_nav_namefilter]: ./images/console/live_nav_namefilter.png
[live_nav_nodelist]: ./images/console/live_nav_nodelist.png
[live_nav_tabs]: ./images/console/live_nav_tabs.png


* * *

- [Next: Live Management: Managing Resources](./console_live_resources.html)
