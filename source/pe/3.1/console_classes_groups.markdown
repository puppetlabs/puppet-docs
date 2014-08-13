---
layout: default
title: "PE 3.1 » Console » Grouping and Classifying Nodes"
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
[environment]: /puppet/latest/reference/environments_classic.html

This page describes how to use the Puppet Enterprise (PE) console to **assign configurations** to nodes. (For help with **inspecting status and activity** among your nodes, see [the Viewing Reports and Inventory Data page](./console_reports.html).)

> **Note:** To use the console to assign node configurations, you must be logged in as a read-write or admin level user. Read-only users can view node configuration data, but cannot modify it.

Overview: Assigning Configurations With the PE Console
-----

> **Note:** As described in [the Puppet section of this manual][puppet], node configurations are compiled from a variety of sources, including the PE console.
>
> For a complete description of Puppet Enterprise's configuration data sources, see [the Assigning Configurations to Nodes page][puppet_assign] of the Puppet section of this manual.

**Puppet classes** are the primary unit of node configuration in PE.  [Classes are named blocks of Puppet code][lang_classes] that can be either **declared** by other Puppet code or **directly assigned** to nodes or groups of nodes.

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

The classes the console knows about are a subset of the classes available to the puppet master. You must explicitly **add** classes to the console before you can assign them to any nodes or groups.

### Adding New Classes

To add a new class to the console, navigate to the "Add classes" page by clicking one of the following:

* The "Add classes" button in [the console's sidebar][sidebar]
* The "Add new classes" link in the upper right corner of [the class list page](#viewing-the-known-classes)

![The console's Add classes button][classes_addclass]

The "Add classes" page allows you to easily add classes that are detected on the puppet master server, as well as manually add classes that can't be autodetected.

![The console's Add classes page][classes_adding_classes]

#### Adding Detected Classes

The "Add classes" page displays a list of classes from the puppet master server. The list **only includes classes from the default `production` [environment][]** --- classes that only exist in other environments (`test`, `dev`, etc.) will not be in the list and must be added manually (see below).

To select one or more classes from the list, click the checkbox next to each class you wish to add.

To browse more easily, you can use the text field above the list, which filters the list as you type. Filtering is not limited to the start of a class name; you can type substrings from anywhere within the class name.

![Filtering the class list to find classes containing "auth"][classes_adding_filter]

Once you have selected the classes you want, click the "Add selected classes" button at the bottom of the page to finalize your choices. The classes you added can now be assigned to nodes and groups. Note that **you must click "Add selected classes" to finish**; otherwise your classes will not be added to the console.

#### Viewing Documentation for Detected Classes

The list of detected classes includes short descriptions, which are extracted from comments in the Puppet code where the class is defined.

To view the full documentation from these comments, you can click the "show more" link next to a description. This will display the docs for that class, formatted using RDoc markup.

![Showing the RDoc-formatted documentation for a class][classes_adding_show_more]


#### Manually Adding Classes

You may need to manually add certain classes to the console. This can be necessary if you are running multiple [environments][environment], some of which contain classes that cannot be found in the `production` environment.

To manually add a class, use the text fields under the "Don't see a class?" header near the bottom of the page.

![Typing a name and description in order to manually add a class][classes_adding_manual_plus_button]

1. Type the complete, fully qualified name of the class in the "class name" field.
2. Optionally, type a description for the class in the "description" field.
3. Click the green plus (+) button to the right of the text fields, which becomes enabled after you have entered a name.

![The manually added class, visible in a new list below the text fields][classes_adding_manual_checked]

After you click the plus (+) button, the class will appear in a new list below, with its checkbox already selected. You may now click the "Add selected classes" button at the bottom of the page to finish adding the class, or you can select additional classes, either manually or from the list of detected classes. **You must click "Add selected classes" to finish**; otherwise, your classes will not be added to the console.

Once you have finished adding a class, you can assign it to nodes and groups.

If you change your mind about adding a class you entered manually, you can click the "remove" link next to it in the list. You can then continue selecting more classes.


### Viewing the Known Classes

There are two lists of classes in the console: One in [the console's sidebar][sidebar], and one reached by clicking the "Classes" item in the main navigation.

The sidebar list also includes counts of nodes with the class assigned, but these numbers are not complete: they only include nodes that have the class **directly** assigned, excluding nodes that receive the class from a group.

In the class list page, reached by clicking the "Classes" navigation item, classes that were manually added are marked with an asterisk (\*) to show that they are not available in the puppet master's `production` environment.

### Class Detail Pages

You can view an individual **class detail page** by clicking the name of that class in one of the following places:

* The sidebar's class list
* The class list page
* A node or group detail page

Class detail pages contain a description of the class, a recent run summary, and a list of all nodes to which the class is assigned. The node list includes a "source" column that shows, for each node, whether the class was assigned directly or via a group. (When assigned via a group, the group name is a link to the group detail page.)

The upper right corner of a class detail page has an "Edit" button that you can use to change the name and description of the class. There is also a "Delete" button.

![A class detail page, containing a description, recent run summary, and node list][classes_class_detail]

For classes added from the autodetected list, the description on the class detail page will be automatically filled in with documentation extracted from that class's Puppet code; however, this documentation will be displayed raw instead of formatted as RDoc markup.

Nodes
-----

### Node Detail Pages

Each **node** in a Puppet Enterprise deployment has its own **node detail page** in the PE console. You can reach a node detail page by clicking that node's name in any [node list view](./console_navigating.html#nodes-and-node-lists).

From a node detail page, you can:

* View the node's current variables, groups, and classes
* Click the "Edit" button to navigate to the node edit page
* Hide the node, causing it to stop appearing in node list views
* Delete the node, removing all reports and information about that node from the console (it will reappear as a new node if it submits a new Puppet run report)
* [View the node's recent activity and run status (see "Viewing Reports & Inventory Data")][reports_etc]
* [View the node's inventory data (see "Viewing Reports & Inventory Data")][reports_etc]

[reports_etc]: ./console_reports.html

![A node detail page][classes_node_detail_page]

### Viewing Current Configuration Data

Each node detail page has three tables near the top that display the current **variables**, **groups**, and **classes** assigned to that node. Each of these tables has a **"source"** column.

* If the source of an item is the node's own name, it was assigned **directly to that node**. You can change it by editing the node.
* If the source of an item is the name of a group, the item was assigned to that group and the node inherited it. The group name is a link to the group detail page; if you need to change the item, you can navigate to the group's page.

In PE 3.1, class parameters are not shown on the node detail page; to see them, you must go to the node edit page or the group edit page, if the class is inherited from a group.

### Node Edit Pages

Clicking the "Edit" button on a node detail page navigates to the **node edit page**, which allows you to edit the node's classes, groups, and variables. You can also add an optional description for the node.

The main functions of node edit pages are described below.

![The edit button][classes_editbutton]

![Editing a node][classes_add_variable]

### Editing Classes on Nodes

Assigning a class to a node will cause that node to manage the resources declared by that class. Some classes may need to be configured by setting either variables or class parameters. See [Puppet: Assigning Configurations to Nodes][puppet_assign] for more background information.

[puppet_assign]: ./puppet_assign_configurations.html

To assign a class, start typing the class's name into the "Add a class" text field on the node edit page. As you type, an auto-completion list of the most likely choices appears; the list continues to narrow as you type more. To finish selecting a class, click a choice from the list or use the arrow keys to select one and press enter.

> **Note:** You can only assign classes that are already known to the console. See [Adding New Classes](#adding-new-classes) on this page for details.

To remove a class from a node, click the "Remove class" link next to the class's name. Note that classes inherited from a group can't be modified from the node edit page --- you must either edit it from the group page, or remove the node from that group.

To edit class parameters for a class, click the "Edit parameters" link next to its name. See the next section of this page for details.

**After making edits, always click the "Update" button to save your changes**.

![Typing a class name][classes_typing_class]

### Editing Class Parameters on Nodes

After you have assigned a class to a node, you can set class parameters to configure it. (See ["Puppet: Assigning Configurations to Nodes"][puppet_assign] for more details.) Note that if the class was inherited from a group, its parameters can't be modified from the node edit page --- you must edit them from the group page, or else explicitly add the class to the node.

To set class parameters, click the "Edit parameters" link next to a class name on a node edit page. This will bring up a **class parameters dialog**.

![An edit parameters link][classes_class_param_links]

![A class parameters dialog][classes_class_param_dialog]

The class parameters dialog allows you to easily add values for any parameters that can be detected from the puppet master server. It also lets you manually add parameters that can't be autodetected.

> **Note:** Class parameters can be strings or booleans --- the PE console will automatically convert the strings `true` and `false` to real boolean values. The console does not support setting arrays or hashes as parameters.

#### Adding Values for Detected Parameters

The class parameters dialog displays a list of parameters from the puppet master server. The list **only includes the parameters this class has in the default `production` [environment][]**. If a version of this class in another environment has extra parameters, or if the class doesn't exist in `production`, those parameters won't appear and must be added manually.

The main (autodetected) parameter list includes the names of the known parameters under the "Key" heading and their current values.

* Parameters that are using their default values will have that value shown in **grey text**. This value may be a literal value, or it may be a Puppet variable. (This is generally the case for modules that use the "params class" pattern, or for classes whose parameters default to fact values.) You can enter a new value if you choose.
* Parameters that have had values set by a user are displayed with **black text** and a **blue background**. They also have a "Reset to default" control next to the value.
* Parameters with no user-set value and no default value are displayed with a white background and no text. These parameters generally must be assigned a value before the class will work.

To add or change a value for a detected parameter, type a new value in the "Value" field. Alternately, you can use the "Reset to default" control next to the value to restore the default value. Default values can be viewed in a tooltip by hovering your cursor over the "Value" field for the parameter.

Remember to **click the "Done" button** to exit the dialog, and **click the "Update" button** on the node edit page to save your changes.


#### Manually Adding Parameters

You may need to manually add certain parameters for a class. This can be necessary if you are running multiple [environments][environment] and some of them contain newer versions of certain classes that include parameters that can't be found in the `production` versions.

To manually add a parameter, use the text fields under the "Other parameters" header.

![Typing a name and value for a manual class parameter][classes_class_param_manual_plus_button]

Type the name of the class parameter in the "Add a parameter" field, then type a value in the "Value" field. Click the green plus (+) button to the right of the text fields, which becomes enabled after you have entered a name.

![The manually added parameter, visible in a new list below the text fields][classes_class_param_manual_added]

Instead of a "Reset to default" control, the list of manually-added parameters includes "Delete" links for each parameter, which will remove the parameter and its value.

Remember to **click the "Done" button** to exit the dialog, and **click the "Update" button** on the node edit page to save your changes.


### Editing Groups on Nodes

Assigning a node to a group will cause that node to inherit all of the classes, class parameters, and variables assigned to that group. It will also inherit the configuration data from any group that group is a member of.

Nodes can override the configuration data they inherit from their group(s); the main limitation on this is that you must explicitly add a class to a node before assigning class parameters that differ from those inherited from a group.

To add a node to a group, start typing the group's name into the "Add a group" text field on the node edit page. As you type, an auto-completion list of the most likely choices appears; the list continues to narrow as you type more. To finish selecting a group, click a choice from the list or use the arrow keys to select one and press enter.

To remove a node from a group, click the "Remove node from group" link next to the group's name. Note that groups inherited from another group can't be removed via the node edit page --- you must either remove it from the other group's page, or remove the node from the other group.

Note that you can also edit group membership from a group edit page.

![Adding groups to a node][classes_groups_to_node]

### Editing Variables on Nodes

You can also set **variables** from a node's edit page. Variables set in the console become [top-scope variables available to all Puppet manifests][topscope].

To add a variable, look under the "Variables" heading. You should put the name of the variable in the "Key" field and the value in the "Value" field.

There will always be at least one empty pair of variable fields on a node's edit page. You can use the "Add variable" button to add more empty fields, in order to add multiple variables at once. You can also edit existing variables, or use the grey delete (x) button to delete a variable entirely.

> **Note:** Variables can only be strings. The PE console does not support setting arrays, hashes, or booleans as variables.

![Adding another variable][classes_add_multiple_variables]


Groups
-----

Groups let you assign classes and variables to many nodes at once. This saves you time and makes the structure of your site more visible.

Nodes can belong to many groups and will inherit classes and variables from all of them. Groups can also be members of other groups and will inherit configuration information from their parent group the same way nodes do.

### Special Groups

Puppet Enterprise automatically creates and maintains several special groups in the console:

#### The Default Group

The console automatically adds every node to a group called `default`. You can use this group for any classes you need assigned to every single node.

Nodes are added to the default group by a periodic background task, so it may take a few minutes after a node first checks in before it joins the group.

#### The MCollective and No MCollective Groups

These groups are used to manage Puppet Enterprise's [orchestration engine](./orchestration_overview.html).

* The `no mcollective` group is **manually** managed by the admin user. You can add any node that **should not** have orchestration features enabled to this group. This is generally used for non-PE nodes like network devices, which cannot support orchestration.
* The `mcollective` group is **automatically** managed by a periodic background task; it contains every node that **is not** a member of the `no mcollective` group. Admin users can add classes to this group if they have any third-party classes that should be assigned to every node that has orchestration enabled; however, you **should not** remove the `pe_mcollective` class from this group.


#### The Master, Console, and PuppetDB Groups

These groups are created when initially setting up a Puppet Enterprise deployment, but are not automatically added to.

* `puppet_master` --- this group contains the original puppet master node.
* `puppet_console` --- this group contains the original console node.
* `puppet_puppetdb` --- this group contains the original database support node.


### Adding a New Group

Use the "Add group" button in the console's sidebar or the "Add group" link in the main groups page, then enter the group's name and any classes, groups, variables, and nodes you want to assign to the new group.

![The add group button][classes_group_button]

![Adding a group][classes_add_group]

### Group Detail Pages

You can see a list of groups in the "Groups" section of the [sidebar][], or by clicking the "Groups" item in the main navigation.

Clicking the name of a group in a group list or the node detail page of one of that group's members will take you to its **group detail page**.

![A group detail page][classes_group_detail]

From a group detail page, you can view the currently assigned configuration data for that group, or use the "Edit" button to assign new configuration data. You can also delete the group, which will cause any members to lose membership in the group.

Group detail pages also show any groups of which that group is a member (under the "Groups" header) and any groups that are members of that group (under the "Derived groups" header).


### Editing Nodes on Groups

You can change the membership of a group from both node edit pages and group edit pages.

To add a node to a group from a group edit page, start typing into the "Add a node" text field. As you type, an auto-completion list of the most likely choices appears; the list continues to narrow as you type more. To finish selecting a node, click a choice from the list or use the arrow keys to select one and press enter.

![Adding nodes to a group][classes_nodes_to_group]

### Editing Classes, Class Parameters, and Variables on Groups

Editing classes, class parameters, and variables for a group works much the same way as editing them for a single node. See the following sections above for details:

* [Assigning classes](#assigning-classes-and-groups-to-nodes)
* [Setting class parameters](#setting-class-parameters-on-nodes)
* [Setting variables](#setting-variables-on-nodes)

The one major difference involves **variable and class parameter conflicts**. Since nodes can belong to multiple groups, and since groups are not necessarily arranged in a strict hierarchy, it's possible for two equal groups to contribute **conflicting values** for variables and for class parameters.

If you attempt to set values that would cause a conflict, the PE console will warn you and give you a chance to back out. The warning will show where the conflict is arising, and which nodes are affected:

![A value conflict warning][classes_group_value_conflict]

If you choose to go ahead and create a conflict, **any affected nodes will receive reduced configurations** from the puppet master --- the console will decline to provide any configuration data for that node until you resolve the conflict. **Note that this will not necessarily appear as a run failure** --- the node will simply not attempt to manage resources that would have been managed by classes from the PE console. To restore the nodes to full management, you must fix the conflict.

When viewing a node page, conflicts are shown as red warning (!) icons next to the affected variables or classes. You can click the icon to bring up a summary of the conflict, showing the sources of the conflicting values.

![A conflict warning icon][classes_node_value_conflict_icon]

![A summary of the conflict][classes_node_value_conflict_popup]

### Editing Groups on Groups

Groups can also be members of other groups. Nodes that belong to a group will also inherit configuration data from any groups that group belongs to.

Adding group membership from a group works the same way as [adding group membership from a node](#editing-groups-on-nodes).


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
[classes_add_multiple_variables]: ./images/console/classes_add_multiple_variables.png

[classes_class_param_links]: ./images/console/classes_class_param_links.png
[classes_group_detail]: ./images/console/classes_group_detail.png
[classes_class_detail]: ./images/console/classes_class_detail.png
[classes_adding_classes]: ./images/console/classes_adding_classes.png
[classes_adding_filter]: ./images/console/classes_adding_filter.png
[classes_adding_manual_plus_button]: ./images/console/classes_adding_manual_plus_button.png
[classes_adding_manual_checked]: ./images/console/classes_adding_manual_checked.png
[classes_adding_show_more]: ./images/console/classes_adding_show_more.png
[classes_node_detail_page]: ./images/console/classes_node_detail_page.png
[classes_class_param_dialog]: ./images/console/classes_class_param_dialog.png
[classes_class_param_manual_plus_button]: ./images/console/classes_class_param_manual_plus_button.png
[classes_class_param_manual_added]: ./images/console/classes_class_param_manual_added.png
[classes_node_value_conflict_popup]: ./images/console/classes_node_value_conflict_popup.png
[classes_node_value_conflict_icon]: ./images/console/classes_node_value_conflict_icon.png
[classes_group_value_conflict]: ./images/console/classes_group_value_conflict.png

* * *

- [Next: Using Event Inspector](./console_event-inspector.html)
