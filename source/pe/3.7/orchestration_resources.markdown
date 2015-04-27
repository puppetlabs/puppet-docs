---
layout: default
title: "PE 3.7 » Orchestration » Browsing Resources"
subtitle: "Orchestration: Browsing and Comparing Resources"
canonical: "/pe/latest/orchestration_resources.html"
---

Use the live management page's __Browse Resources__ tab to browse the resources on your nodes and inspect their current state.

[live]: ./console_navigating_live_mgmt.html
[selected_nodes]: ./console_navigating_live_mgmt.html#selecting-nodes

> **Note:** Resource browsing and comparison are **only** available in the PE console; there is not a command line interface for these features.
>
> If you need to do simple resource inspections on the command line, you can investigate the `puppetral` plugin's `find` and `search` actions. These give output similar to what you can get from running `puppet resource <type> [<name>]` locally.

Live Management Basics
-----

Browsing resources requires you to select a node or group of nodes to inspect.

To learn how to navigate the live management page and select/filter nodes, see [the Navigating Live Management page][live] of this manual.

The Browse Resources Tab
-----

The Browse Resources tab contains a **resource type navigation** list in its left pane. This is used to switch the right pane between several **resource type pages** (and a summary page, which includes an __Inspect All__ button for pre-caching resource data).

![The Browse Resources tab][live_resources_main]

### Resource Types

The Browse Resources tab can inspect the following resource types:

- [group](/references/3.7.latest/type.html#group)
- [host](/references/3.7.latest/type.html#host)
- [package](/references/3.7.latest/type.html#package)
- [service](/references/3.7.latest/type.html#service)
- [user](/references/3.7.latest/type.html#user)

For an introduction to resources and types, please see [the Resources chapter of Learning Puppet](/learning/ral.html).

### The __Inspect All__ Button

The summary view's __Inspect All__ button scans all resources of all types and reports on their **similarity**. This is mostly useful when you think you've selected a group of very similar nodes but want to make sure.

![Similarity for resources after clicking __inspect all__][live_resources_all_similarity]

After clicking __Inspect All,__ the Browse Resources tab will use the lists of resources it got to pre-populate the corresponding lists in each resource type page. This can save you a few clicks on the __Find Resources__ buttons (see below).

### Resource Type Pages

Resource type pages contain a **search field,** a **Find Resources button,** and (if the Find Resources button has been used) a list of resources labeled with their nodes and number of variants.

![An empty list of user resources][live_resources_none]

Browsing All Resources of a Type
-----

To browse resources, you must first select a resource type. You must also have one or more [nodes selected.][selected_nodes]

If you have previously clicked the __Inspect All__ button, the resource type page will be pre-populated; if it is empty, you must click the __Find Resources__ button.

![Browsing a list of users on more than 400 nodes][live_resources_browse_users]

The resource type page will display a list of all resources of that type on the selected nodes, plus a summary of how similar the resources are. An __Update__ button is available for re-scanning your nodes. In general, a set of nodes that perform similar tasks should have very similar resources.

The resource list shows the name of each resource, the number of nodes it was found on, and how many variants of it were found. You can sort the list by any of these properties by clicking the headers.

To [inspect a resource](#inspecting-and-comparing-resources), click its name.

Finding Resources by Name
-----

To find resources by name, you must first select a resource type. You must also have one or more [nodes selected.][selected_nodes]

The **search field** on a resource type page is not a standard search field; it only works with the exact name of a resource. Wildcards are not allowed. If you are unsure of the name of the resource you're looking for, you should browse instead.

To search, enter a resource name in the search field and confirm with the enter key or the __search__ button.

![A search in progress][live_resources_searching]

Once located, you will be taken directly to the inspect view for that resource. This is the same as the inspect view available when browsing (see below).

![The user resource we found][live_resources_found]


Inspecting and Comparing Resources
-----

![The gopher user, with two variants][live_resources_gopher]

When you inspect a resource, you can see the values of all its properties. If there is more than one variant, you can see all of them and the properties that differ across nodes will be highlighted.

To see which nodes have each variant, click the __on N nodes__ labels to expand the node lists.

![Nodes with the gopher user][live_resources_gopher_withnodes]


[live_resources_browse_users]: ./images/console/live_resources_browse_users.png
[live_resources_found]: ./images/console/live_resources_found.png
[live_resources_main]: ./images/console/live_resources_main.png
[live_resources_none]: ./images/console/live_resources_none.png
[live_resources_searching]: ./images/console/live_resources_searching.png
[live_resources_gopher_withnodes]: ./images/console/live_resources_gopher_withnodes.png
[live_resources_gopher]: ./images/console/live_resources_gopher.png
[live_resources_all_similarity]: ./images/console/live_resources_all_similarity.png

* * *

- [Next: List of Built-In Orchestration Actions](./orchestration_actions.html)
