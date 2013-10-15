---
layout: default
title: "PE 3.1 » Console » Navigating"
subtitle: "Navigating the Console"
canonical: "/pe/latest/console_navigating.html"
---

Getting Around
-----

### The Main Navigation

Navigate between sections of the console using the **main navigation** at the top.

![The navigation bar][nav_navbar]

The following navigation items all lead to their respective **sections** of the console:

* [Nodes](#nodes-groups-classes-and-reports)
* [Groups](#nodes-groups-classes-and-reports)
* [Classes](#nodes-groups-classes-and-reports)
* [Reports](#nodes-groups-classes-and-reports)
* [Inventory Search](./console_inventory_search.html)
* [Live Management](./console_navigating_live_mgmt.html)
* [Node requests](./console_cert_mgmt.html)

The navigation item containing your **username** ("admin," in the screenshot above) is a menu which provides access to your account information and (for admin users) [the user management tools](./console_auth.html).

The **help** menu leads to the Puppet Enterprise documentation.

The **licenses** menu shows you the number of nodes that are currently active and the number of nodes still available on your current license. See below for more information on working with licenses.

> **Note:** For users limited to read-only access, some elements of the console shown here will not be visible.

### The Sidebar

Within the [node/group/class/report pages of the console](#nodes-groups-classes-and-reports), you can also use the **sidebar** as a shortcut to many sections and subsections.

![The sidebar][nav_sidebar]

The sidebar contains the following elements:

* The **background tasks indicator.** The console handles Puppet run reports asynchronously using several background worker processes. This element lets you monitor the health of those workers. The number of tasks increases as new reports come in, and decreases as the workers finish processing them. If the number of tasks increases rapidly and won't go down, something is wrong with the worker processes and you may need to [use the advanced tasks tab](./console_navigating_live_mgmt.html#the-advanced-tasks-tab) to restart the `pe-puppet-dashboard-workers` service on the console node. A green check-mark with the text "All systems go" means the worker processes have caught up with all available reports.
* The **node state summary.** Depending on how its last Puppet run went, every node is in one of six states. [A description of those states is available here.](./console_reports.html#node-states) The state summary shows how many nodes are in each state, and you can click any of the states for a view of all nodes in that state. You can also click the "Radiator view" link for a high-visibility dashboard (see below for a screenshot) and the "Add node" button to add a node before it has submitted any reports. (Nodes are automatically added to the console after they have submitted their first report, so this button is only useful in certain circumstances.)
* The **group summary,** which lists the [node groups](./console_classes_groups.html#grouping-nodes) in use and shows how many nodes are members of each. You can click each group name to view and edit that group's detail page. You can also use the "Add group" button to create a new group.
* The **class summary,** which lists the [classes](./console_classes_groups.html#classes) in use and shows how many nodes have been **directly** assigned each class. (The summary doesn't count nodes that receive a class due to their group membership.) You can click each class name to view and edit that class's detail page. You can also use the "Add classes" button to add a new class to the console.

A screenshot of the "radiator view:"

![The radiator view][radiator]

[radiator]: ./images/console/nav_radiator.png

What's in the Console?
-----


### Node Requests

Whenever you install Puppet Enterprise on a new node, it will ask to be added to the deployment. You must [use the request manager](./console_cert_mgmt.html) to approve the new node before you can begin managing its configuration.

### Orchestration

[The live management section](./console_navigating_live_mgmt.html) allows you to invoke orchestration actions and browse and compare resources on your nodes.

### Nodes, Groups, Classes, and Reports

The **nodes, groups, classes,** and **reports** sections of the console are closely intertwined, and contain tools for **inspecting the status** of your systems and **assigning configurations** to them.

* See [the Grouping and Classifying Nodes page][classify] for details about **assigning configurations** to nodes.
* See [the Viewing Reports and Inventory Data page][report] for details about **inspecting the status** of your nodes.

[classify]: ./console_classes_groups.html
[report]: ./console_reports.html

#### Nodes and Node Lists

Many pages in the console --- including class and group detail pages --- contain a **node list** view. A list will show the name of each node that is relevant to the current view (members of a group, for example), a graph of their recent aggregate activity, and a few details about each node's most recent run. Node names will have icons next to them [representing their most recent state.](./console_reports.html#node-states)

Every node list includes an "Export nodes as CSV" link, for use when importing data into a spreadsheet.

Certain node lists (the main node list and the per-state lists) include a **search field.** This field accepts partial node names, and narrows the list to show only nodes whose names match the search.

![The nodes page][nav_node]

Clicking the name of a node will take you to that node's **node detail page,** where you can see in-depth information and assign configurations directly to the node. See the [Grouping and Classifying Nodes][classify] and [Viewing Reports and Inventory Data][report] pages for information about node detail pages.

#### Reports and Report Lists

Node detail pages contain a **report list.** If you click a report in this list, or a timestamp in the "Latest report" column of a node list view, you can navigate to a **report detail page.** See the [Viewing Reports and Inventory Data][report] page for information about report detail pages.

#### Groups

Groups can contain any number of nodes, and nodes can belong to more than one group. Each **group detail page** contains a node list view.

![A group page][nav_group]

You can use a group page to view aggregate information about its members, or to assign configurations to every member at once. See the [Grouping and Classifying Nodes][classify] page for information about assigning configurations to groups.

#### Classes

**Classes** are the main unit of Puppet configurations. You must deliberately add classes to the console with the "Add classes" button before you can assign them to nodes or groups. See the [Grouping and Classifying Nodes][classify] page for information about adding classes and assigning them to nodes or groups. If you click the name of a class to see its **class detail page,** you can view a node list of every node assigned that class.

### Working with Licenses

The **licenses** menu shows you the number of nodes that are currently active and the number of nodes still available on your current license. If the number of available licenses is exceeded, a warning will be displayed. The number of licenses used is determined by the number of active nodes known to Puppetdb. This is a change from previous behavior which used the number of unrevoked certs known by the CA to determine used licenses. The menu item provides convenient links to purchase and pricing information.

Unused nodes will be deactivated automatically after seven days with no activity (no new facts, catalog or reports), or you can use `puppet node deactivate` for immediate results. The console will cache license information for some time, so if you have made changes to your license file (e.g. adding or renewing licenses), the changes may not show for up to 24 hours. You can restart the `pe-memcached` service in order to update the license display sooner.

[certsign]: ./console_cert_mgmt.html
[nav_group]: ./images/console/nav_group.png
[nav_navbar]: ./images/console/nav_navbar.png
[nav_node]: ./images/console/nav_node.png
[nav_sidebar]: ./images/console/nav_sidebar.png




* * *

- [Next: Navigating the Live Management Page](./console_navigating_live_mgmt.html)
