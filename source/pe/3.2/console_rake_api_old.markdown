---
layout: default
title: "PE 3.2 » Console » Rake API: Environment Variable Names"
subtitle: "List of Rake API Tasks with Environment Variable Argument Names"
canonical: "/pe/latest/console_rake_api_old.html"
---

This page contains a complete list of console Rake tasks in Puppet Enterprise 3.0, using the older invocation style with named arguments expressed as environment variables.

- For more complete information on the Puppet Enterprise console's Rake API, [see the main Rake API page][rake_api].
- For a list of tasks with the newer style of parameters, [see the task list section of the main Rake API page][new_tasks].

> **Deprecation note:** Invoking tasks like this will cause deprecation warnings, but it will continue to work for the duration of the Puppet Enterprise 3.x series, with removal tentatively planned for Puppet Enterprise 4.0.

Node Tasks: Getting Info
-----

### `node:list [match=<REGULAR EXPRESSION>]`

List nodes. Can optionally match nodes by regex.

### `node:listclasses name=<NAME>`

List classes for a node.

### `node:listclassparams name=<NAME> class=<CLASS>`

List classparams for a node/class pair.

### `node:listgroups name=<NAME>`

List groups for a node.

### `node:variables name=<NAME>`

List variables for a node.


Node Tasks: Modifying Info
-----

### `node:add name=<NAME> [groups=<GROUPS>] [classes=<CLASSES>]`

Add a new node. Classes and groups can be specified as comma-separated lists.

### `node:del name=<NAME>`

Delete a node.

### `node:classes name=<NAME> classes=<CLASSES>`

**Replace** the list of classes assigned to a node. Classes must be specified as a comma-separated list.

### `node:groups name=<NAME> groups=<GROUPS>`

**Replace** the list of groups a node belongs to. Groups must be specified as a comma-separated list.

### `node:addclass name=<NAME> class=<CLASS>`

Add a class to a node.

### `node:addclassparam name=<NAME> class=<CLASS> param=<PARAM> value=<VALUE>`

Add a classparam to a node.

### `node:addgroup name=<NAME> group=<GROUP>`

Add a group to a node.

### `node:delclassparam name=<NAME> class=<CLASS> param=<PARAM>`

Remove a class param from a node.

### `node:variables name=<NAME> variables="<VARIABLE>=<VALUE>,<VARIABLE>=<VALUE>,..."`

Add (or edit, if they exist) variables for a node. Variables must be specified as a comma-separated list of variable=value pairs; the list must be quoted.

If you want to set a variable's value to a string containing commas, you must escape those commas. Use a single backslash for single-quoted strings, and two backslashes for double-quoted strings.

Class Tasks: Getting Info
-----

### `nodeclass:list [match=<REGULAR EXPRESSION>]`

List node classes. Can optionally match classes by regex.

Class Tasks: Modifying Info
-----

### `nodeclass:add name=<NAME>`

Add a new class. This must be a class available to the Puppet autoloader via a module.

### `nodeclass:del name=<NAME>`

Delete a node class.

Group Tasks: Getting Info
-----

### `nodegroup:list [match=<REGULAR EXPRESSION>]`

List node groups. Can optionally match groups by regex.

### `nodegroup:listclasses name=<NAME>`

List classes that belong to a node group.

### `nodegroup:listclassparams name=<NAME> class=<CLASS>`

List classparams for a nodegroup/class.

### `nodegroup:listgroups name=<NAME>`

List child groups that belong to a node group.

### `nodegroup:variables name=<NAME>`

List variables for a node group.


Group Tasks: Modifying Info
-----

### `nodegroup:add name=<NAME> [classes=<CLASSES>]`

Create a new node group. Classes can be specified as a comma-separated list.

### `nodegroup:del name=<NAME>`

Delete a node group.

### `nodegroup:add_all_nodes name=<NAME>`

Add every known node to a group.

### `nodegroup:addclass name=<NAME> class=<CLASS>`

Assign a class to a group without overwriting its existing classes.

### `nodegroup:edit name=<NAME> classes=<CLASSES>`

**Replace** the classes assigned to a node group. Classes must be specified as a comma-separated list.

### `nodegroup:addclassparam name=<NAME> class=<CLASS> param=<PARAM> value=<VALUE>`

Add classparam to a nodegroup.

### `nodegroup:addgroup name=<NAME> group=<GROUP>`

Add a child group to a nodegroup.

### `nodegroup:delclass name=<NAME> class=<CLASS>`

Remove a class from a nodegroup.

### `nodegroup:delclassparam name=<NAME> class=<CLASS> param=<PARAM>`

Remove a class param from a node group.

### `nodegroup:delgroup name=<NAME> group=<GROUP>`

Remove a child group from a nodegroup.

### `nodegroup:variables name=<NAME> variables="<VARIABLE>=<VALUE>,<VARIABLE>=<VALUE>,..."`

Add (or edit, if they exist) variables for a node group. Variables must be specified as a comma-separated list of variable=value pairs; the list must be quoted.

If you want to set a variable's value to a string containing commas, you must escape those commas. Use a single backslash for single-quoted strings, and two backslashes for double-quoted strings.
