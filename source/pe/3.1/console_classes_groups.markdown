---
layout: default
title: "PE 3.0 » Console » Grouping and Classifying Nodes"
subtitle: "Grouping and Classifying Nodes"
canonical: "/pe/latest/console_classes_groups.html"
---

[puppet]: ./puppet_overview.html
[puppet_assign]: ./puppet_assign_configurations.html
[lang_classes]: /puppet/3/reference/lang_classes.html
[learn]: /learning/
[forge]: http://forge.puppetlabs.com
[modules]: /puppet/3/reference/modules_fundamentals.html
[topscope]: /puppet/3/reference/lang_scope.html#top-scope
[sidebar]: ./console_navigating.html#the-sidebar

This page describes how to use the Puppet Enterprise (PE) console to **assign configurations** to nodes. (For help with **inspecting status and activity** among your nodes, see [the Viewing Reports and Inventory Data page](./console_reports.html).)

> **Note:** To use the console to assign node configurations, you must be logged in as a read-write or admin level user. Read-only users can view node configuration data, but cannot modify it.

Overview: Assigning Configurations With the PE Console
-----

> **Note:** As described in [the Puppet section of this manual][puppet], node configurations are compiled from a variety of sources, including the PE console.
>
> For a complete description of Puppet Enterprise's configuration data sources, see [the Assigning Configurations to Nodes page][puppet_assign] of the Puppet section of this manual.

**Puppet classes** are the primary unit of node configuration in PE.  [Classes are named blocks of Puppet code][lang_classes] which can be either **declared** by other Puppet code or **directly assigned** to nodes or groups of nodes.

The console allows you to [**assign** classes](./puppet_assign_configurations.html#assigning-classes) and [**configure** their behavior](./puppet_assign_configurations.html#configuring-classes).

> ### Creating Puppet Classes
>
> Before you can assign classes in the console, the classes need to be available to the puppet master server. This means they must be located in an installed [module][modules]. There are several ways to get modules:
>
> * [Download modules from the Puppet Forge][forge] --- there are many public modules available for free, with instructions for how to use them.
> * [Write your own classes][lang_classes], and put them in a [module][modules].
> * If you are new to Puppet and have not written Puppet code before, [follow the Learning Puppet tutorial][learn], which walks you through the basics of Puppet code, classes, and modules.

### Navigating the Console

* See [the Navigating the Console page](./console_navigating.html) for details on navigating the PE console.
* See [the Viewing Reports and Inventory Data page](./console_reports.html) for details on inspecting the status and recent activity of your nodes.


Classes
-----

The classes the console knows about are a subset of the classes available to the puppet master. You must add classes to the console manually if you want to assign them to any nodes or groups.

### Viewing the Known Classes

You can view a list of classes in [the console's sidebar][sidebar], or by clicking the "Classes" item in the main navigation.

You can see a **class detail page** by clicking the name of that class in the sidebar, the main class list, or any node or group detail page that includes that class. Class detail pages contain a list of nodes with the class assigned, but it **is not a complete list;** it only includes nodes which have the class **directly** assigned, and excludes nodes that receive the class from a group.

### Adding a New Class

Use the "Add class" button in [the console's sidebar][sidebar], then type the new class's name in the text field and click "create." You can also add an optional description.

![The console's Add class button][classes_addclass]

![The console's Add node class page][classes_typingclass]

In this case, we're adding a class that manages the standard \*nix "message of the day" file; you can get a module containing this class at <http://forge.puppetlabs.com/puppetlabs/motd>.

When adding a class, you must use its complete name. (`base::centos`, for example, not just `centos`.)

Once you have added a class, you can assign it to nodes and groups.


Nodes
-----

### Node Detail Pages

Each **node** in a Puppet Enterprise deployment has its own **node detail page** in the PE console. You can reach a node detail page by clicking that node's name in any [node list view](./console_navigating.html#nodes-and-node-lists).

From a node detail page, you can view the currently assigned configuration data for that node, or use the "Edit" button to assign new configuration data. You can also hide the node (cause it to not appear in node list views) or delete it (remove all reports and information about that node from the console; note that the node will automatically reappear if it ever submits another Puppet run report).

![The edit button][classes_editbutton]

Each node detail page has tables to display the current **variables, groups,** and **classes** assigned to that node. Each of these tables has a **"source"** column --- if the source of an item is the node's own name, it was assigned **directly to that node;** if the source is the name of a group, the item was assigned to that group and the node inherited it by being a member of that group.

Clicking the "Edit" button brings up the **node edit page,** which allows you to edit the node's variables, classes, and groups. You can also add an optional description for the node.

![Editing a node][classes_add_variable]

### Assigning Classes and Groups to Nodes

When you start typing the name of a class or group in a node's edit page, the PE console will offer an auto-completion list of the most likely choices. The list will continue to narrow as you type more.

To finish assigning the class or group, either click a choice from the list, or use the arrow keys to select one and press enter.

Use the "Update" button to save after assigning new classes and groups.

> **Note:** You can only assign classes or groups that already exist. See [Adding a New Class](#adding-a-new-class) and [Adding a New Group](#adding-a-new-group) for details.

![Typing a class name][classes_typing_class]

### Setting Class Parameters on Nodes

After you have assigned a class to a node, you can set [class parameters](#class-parameters) to configure it.

> **Note:** You can only set class parameters **at the place where the class was assigned.**
>
> * If the class was assigned **directly** to a node, you can set class parameters from that node's detail page.
> * If the class was assigned **to a group** and then inherited by members of the group, you must set parameters from **that group's** detail page instead.

To set class parameters, view a **node detail page** and click an enabled **parameters link,** in the "Parameters" column of the "Classes" table. Enabled parameters links are blue. (Disabled black parameters links mean that the class came from a group, and parameters can only be set in the group's page.)

![An enabled class parameter link][classes_class_param_links]

Clicking a parameters link will take you to the **class parameters detail page** for that class _as assigned_ to that node. This page is node-specific --- each node with this class assigned will have its own similar version of this detail page if you click its parameters link.

![A class parameters detail page][classes_parameters_detail]

To add or change parameters, click the "Edit" button, which will take you to a **class parameters edit page** (labeled "Edit node class membership").

![A class parameters edit page][classes_parameters_edit]

Parameters are added with pairs of key/value fields. There will always be at least one empty pair of key/value fields on a parameters edit page. You can use the "Add parameter" button to add more empty fields, in order to add multiple parameters at once. You can also edit existing parameters, or use the red trash button to delete a parameter entirely.

> **Note:** Class parameters can only be strings. The PE console does not support setting arrays, hashes, or booleans as parameters.

Click the "Update" button to save your changes. The next time you view that node's detail page, you'll see a "2 Parameters" (or appropriate number) link in the "Parameters" column of the "Classes" table.

![After adding some parameters][classes_parameters_done]

### Setting Variables on Nodes

You can also set **variables** from a node's edit page. Variables set in the console become [top-scope variables available to all Puppet manifests][topscope].

To add a variable, look under the "Variables" heading. You should put the name of the variable in the "Key" field and the value in the "Value" field.

There will always be at least one empty pair of variable fields on a node's edit page. You can use the "Add variable" button to add more empty fields, in order to add multiple variables at once. You can also edit existing variables, or use the red trash button to delete a variable entirely.

> **Note:** Variables can only be strings. The PE console does not support setting arrays, hashes, or booleans as variables.

![Adding another variable][classes_add_multiple_variables]


Groups
-----

Groups let you assign classes and variables to many nodes at once. This saves you time and makes the structure of your site more visible.

Nodes can belong to many groups, and will inherit classes and variables from all of them. Groups can also be members of other groups, and will inherit configuration information from their parent group the same way nodes do.

### Special Groups

Puppet Enterprise automatically creates and maintains several special groups in the console:

#### The Default Group

The console automatically adds every node to a group called `default`. You can use this group for any classes you need assigned to every single node.

Nodes are added to the default group by a periodic background task, so it may take a few minutes after a node first checks in before it joins the group.

#### The MCollective and No MCollective Groups

These groups are used to manage Puppet Enterprise's [orchestration engine](./orchestration_overview.html).

* The `no mcollective` group is **manually** managed by the admin user. You can add any node which **should not** have orchestration features enabled to this group. This is generally used for non-PE nodes like network devices, which cannot support orchestration.
* The `mcollective` group is **automatically** managed by a periodic background task; it contains every node which **is not** a member of the `no mcollective` group. The admin user can add classes to this group if they have any third-party classes that should be assigned to every node that has orchestration enabled. However, you **should not** remove the `pe_mcollective` class from this group.


#### The Master, Console, and PuppetDB Groups

These groups are created when initially setting up a Puppet Enterprise deployment, but are not automatically added to.

* `puppet_master` --- this group contains the original puppet master node.
* `puppet_console` --- this group contains the original console node.
* `puppet_puppetdb` --- this group contains the original database support node.


### Adding a New Group

Use the "add group" button in the console's sidebar, then enter the group's name and any classes or variables you want to assign.

![The add group button][classes_group_button]

![Adding a group][classes_add_group]

### Group Detail Pages

You can see a list of groups in the "Groups" section of the [sidebar][], or by clicking the "Groups" item in the main navigation.

Clicking the name of a group in a group list or the node detail page of one of that group's members will take you to its **group detail page.**

![A group detail page][classes_group_detail]

From a group detail page, you can view the currently assigned configuration data for that group, or use the "Edit" button to assign new configuration data. You can also delete the group, which will cause any members to lose membership in the group.

Group detail pages also show any groups of which that group is a member (under the "Groups" header) and any groups that are members of that group (under the "Derived groups" header).


### Adding Nodes to a Group

You can change the membership of a group from both node detail views and group detail views. Click the edit button and use the "groups" or "nodes" fields, as needed. These fields will offer auto-completions the same way the classes field does.

Editing a node to join a new group:

![Adding groups to a node][classes_groups_to_node]

Editing a group to include a new node:

![Adding nodes to a group][classes_nodes_to_group]

### Assigning Classes, Class Parameters, and Variables to a Group

Editing the configuration data assigned to a group works identically to editing a single node. See the following sections above for details:

* [Assigning classes](#assigning-classes-and-groups-to-nodes)
* [Setting class parameters](#setting-class-parameters-on-nodes)
* [Setting variables](#setting-variables-on-nodes)


Automating Class and Group Edits
-----

The console provides rake tasks that can add classes, nodes, and groups, and edit the configuration data assigned to nodes and groups. You can use these tasks as a minimal API to automate workflows, import or export data, or bypass the console's GUI when performing large tasks.

For information about these tasks, [see the Rake API page](./console_rake_api.html).



[classes_add_group]: ./images/console/classes_add_group.png
[classes_add_variable]: ./images/console/classes_add_variable.png
[classes_addclass]: ./images/console/classes_addclass.png
[classes_editbutton]: ./images/console/classes_editbutton.png
[classes_group_button]: ./images/console/classes_group_button.png
[classes_groups_to_node]: ./images/console/classes_groups_to_node.png
[classes_nodes_to_group]: ./images/console/classes_nodes_to_group.png
[classes_typing_class]: ./images/console/classes_typing_class.png
[classes_typingclass]: ./images/console/classes_typingclass.png
[classes_add_multiple_variables]: ./images/console/classes_add_multiple_variables.png

[classes_class_param_links]: ./images/console/classes_class_param_links.png
[classes_parameters_detail]: ./images/console/classes_parameters_detail.png
[classes_parameters_edit]: ./images/console/classes_parameters_edit.png
[classes_parameters_done]: ./images/console/classes_parameters_done.png
[classes_group_detail]: ./images/console/classes_group_detail.png

* * *

- [Next: Viewing Reports and Inventory Data](./console_reports.html)
