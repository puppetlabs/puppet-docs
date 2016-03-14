---
layout: default
title: "PE 2.5 » Console » Live Mgmt: Managing Resources"
subtitle: "Live Management: Managing Resources"
canonical: "/pe/latest/orchestration_resources.html"
---
> ![windows-only](./images/windows-logo-small.jpg) **NOTE:** Live management and MCollective are not yet supported on Windows nodes.

Use the "Manage Resources" tab to browse the resources on your nodes and clone any of them across your infrastructure.

![The manage resources tab][live_resources_main]


Resource Types
-----

The live management tools can manage the following resource types:

- [user](/puppet/2.7/reference/type.html#user)
- [group](/puppet/2.7/reference/type.html#group)
- [host](/puppet/2.7/reference/type.html#host)
- [package](/puppet/2.7/reference/type.html#package)

For an introduction to resources and types, please see [the Resources chapter of Learning Puppet](/learning/ral.html).

The Summary View
-----

The summary view "Inspect All" button scans all resources of all types and reports on their similarity. This is mostly useful when you think you've selected a group of identical nodes but want to make sure.

Using "Inspect All" at the start of a session will pre-load a lot of information into memory, which can speed up later operations.

Finding Resources
-----

To find a resource to work with, you must first select a resource type. Then, either search for your resource by name or load all resources of the type and browse them. 

Searching and browsing only use the current selection of nodes. 

### Browsing a Type

When you select a type for the first time in a session, it won't automatically display any resources:

![An empty list of user resources][live_resources_none]

To browse a list of all resources, use the "find resources" button.

![The find resources button][live_resources_findbutton]

![Browsing a list of users on more than 400 nodes][live_resources_browse_users]

This will return a list of all resources of the selected type on the selected nodes, plus a summary of how similar the resources are. In general, a set of nodes that perform similar tasks should have very similar resources. You can make a set of nodes more similar by cloning resources across them.

The resource list shows the name of each resource, the number of nodes it was found on, and how many variants of it were found. You can sort the list by any of these properties.

To inspect a resource, click its name. 

![The sshd user, with three variants][live_resources_sshd]

When you inspect a resource, you can see the values of all its properties. If there is more than one variant, you can see all of them and the properties that differ will be highlighted.

To see which nodes have each variant, click the "on N nodes" labels to expand the node lists.

![Nodes with the sshd user][live_resources_sshd_withnodes]

### Searching by Name

To search, enter a resource name in the search field and confirm with the enter key or the "search" button. 

![A search in progress][live_resources_searching]

The name you search for has to be exact; wildcards are not allowed.

Once you've located a resource, the inspect view is the same as that used when browsing.

![The user resource we found][live_resources_found]


Cloning Resources
-----

You can use the "clone resource" links on a resource's inspect view to make it identical on all of the selected nodes. This lets you make your population of nodes more alike without having to write any Puppet code. 

Clicking the clone link for one of the variants will raise a confirmation dialog. You can change the set of selected nodes before clicking the "preview" button.

![The confirmation dialog before previewing][live_resources_clone_before]

Clicking "preview" will show the pending changes and enable the "clone" button. If the changes look good, click "clone." 

![Previewing changes to the gopher user][live_resources_clone_previewing]

![Cloning...][live_resources_cloning]

After the resource has been cloned, you can see a summary of the results and the new state of the resource. 

![After cloning][live_resources_cloning_after]


### Special Behavior When Cloning Users

When you clone a user, any groups it belongs to are also automatically cloned. 

Note also that the UID of a user and the GIDs of its groups aren't cloned across nodes. This means a cloned user's UID will likely differ across nodes. We hope to support UID/GID cloning in a future release.

[live_resources_browse_users]: ./images/console/live_resources_browse_users.png
[live_resources_clone_before]: ./images/console/live_resources_clone_before.png
[live_resources_clone_previewing]: ./images/console/live_resources_clone_previewing.png
[live_resources_cloning_after]: ./images/console/live_resources_cloning_after.png
[live_resources_cloning]: ./images/console/live_resources_cloning.png
[live_resources_findbutton]: ./images/console/live_resources_findbutton.png
[live_resources_found]: ./images/console/live_resources_found.png
[live_resources_main]: ./images/console/live_resources_main.png
[live_resources_none]: ./images/console/live_resources_none.png
[live_resources_searching]: ./images/console/live_resources_searching.png
[live_resources_sshd_withnodes]: ./images/console/live_resources_sshd_withnodes.png
[live_resources_sshd]: ./images/console/live_resources_sshd.png


* * * 

- [Next: Live Management: Controlling Puppet](./console_live_puppet.html)
