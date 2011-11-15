---
layout: pe2experimental
title: "PE 2.0 » Console » Grouping and Classifying Nodes"
---

Grouping and Classifying Nodes
=====

Use groups, classes, and parameters to control which Puppet configurations your nodes receive. 

Parameters
-----

Parameters are simple: they're top-scope variables that your Puppet manifests can use. Use them to configure the behavior of classes.

Add parameters by clicking the edit button in a node view (or group view) and typing a key and value under the "parameters" heading. Use the "add parameter" button below to make additional key/value fields. Be sure to save your changes when done.

![The edit button][classes_editbutton]

![Adding a parameter][classes_add_parameter]

Parameters can only be strings, not arrays or hashes. 

Classes
-----

The classes the console knows about are a subset of the classes in your puppet master's collection of modules. You must add classes to the console manually if you want to assign them to any nodes or groups.

See [the Puppet section of this user's guide][puppetnew] for an introduction to Puppet classes.

[puppetnew]: ./puppet_overview.html

### Adding a New Class

Use the "Add class" button in the console's sidebar, then type the new class's name in the text field and click "create."

![The console's Add class button][classes_addclass]

![The console's Add node class page][classes_typingclass]

In this case, we're adding a tiny class that makes sure [ack](http://betterthangrep.com/) is present in `/usr/local/bin`.

When adding a class, you must use its fully qualified name. (`base::centos`, for example.)

### Assigning a Class to a Node

Assign classes by clicking the edit button in a node view (or group view). Start typing the class's name in the "classes" field, then choose the class you want from the auto-completion list. Be sure to save your changes when done.

![Typing a class name][classes_typing_class]


### Writing Classes for the Console

Defining wrapper classes in a "site" module can help you use the console more effectively, and may be mandatory if you use [parameterized classes][paramclass] heavily.

Most Puppet modules are written so each class manages a logical chunk of configuration. This means any node's configuration could be composed of dozens of Puppet classes. Although you can add these dozens of classes to the console, it's often better to create a module called `site` and populate it with super-classes, which declare all of the smaller classes a given _type_ of machine will need. 

There are many ways to compose these classes, and you'll have to decide based on how your own collection of modules works. Some possibilities:

* Create many non-overlapping classes such that any node will only have one class assigned to it
* Create several separated "levels" of classes --- a "base" layer, a layer for role-specific packages and services, a layer for application data, etc. This way, each node can get the base class for its own OS or machine type, but use the same application classes as some other quite different node.

Wrapper classes are also necessary for working with [parameterized classes][paramclass] --- you can declare parameters in nodes and groups, then have your wrapper classes pass them through when they declare each smaller class.

[paramclass]: /guides/parameterized_classes.html

Grouping Nodes
-----

Groups let you assign a class or parameter to many nodes at once. This saves you time and makes the structure of your site more knowable.

Nodes can belong to many groups, and inherit classes and parameters from all of them. Groups can also contain other groups, which will inherit information the same way nodes do.

### Adding a New Group

Use the "add group" button in the console's sidebar, then enter the group's name and any classes or parameters you want to assign. 

![The add group button][classes_group_button]

![Adding a group][classes_add_group]

### Adding Nodes to a Group

You can change the membership of a group from both node views and group views. Click the edit button and use the "groups" or "nodes" fields, as needed. These fields will offer auto-completions the same way the classes field does. 

![Adding groups to a node][classes_groups_to_node]

![Adding nodes to a group][classes_nodes_to_group]

### Assigning Classes and Parameters to a Group

This works identically to assigning classes and parameters to a single node. Use the edit button and the classes or key/value fields.
