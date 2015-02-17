---
layout: default
title: "PE 3.7 » Console » Rake API"
subtitle: "Rake API for Querying and Modifying Console Data"
canonical: "/pe/latest/console_rake_api.html"
---

The Puppet Enterprise (PE) console provides rake tasks that can add classes, nodes, and groups, and edit the configuration data assigned to nodes and groups. You can use these tasks as a minimal API to automate workflows, import or export data, or bypass the console’s GUI when performing large tasks.


Invoking Console Rake Tasks
-----

>**Note**: In the PE 3.7 series, console rake tasks use the node classifier instead of the puppet-dashboard. For more information, refer to the [node classifier documentation](./console_classes_groups.html) and the [node classifier REST API](./nc_index.html).

> **Deprecation note:** Invoking tasks like this will cause deprecation warnings, but it will continue to work for the duration of the Puppet Enterprise 3.x series, with removal tentatively planned for Puppet Enterprise 4.0.

* Console rake tasks must be invoked from the command line on the console server.
* They should be invoked by a user account with sufficient `sudo` privileges to modify items owned by the `puppet-dashboard` user.
* Every rake command should begin as follows:

        $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production <TASK AND ARGUMENTS>

    The `<TASK AND ARGUMENTS>` placeholder is the only part that will differ between the various tasks; the rest is boilerplate that should be used with every task.

There are two ways to specify arguments for a task. PE 3.0.1 and later can use both styles; PE 3.0.0 (and the PE 2.x series) can only use the environment variable style.

>**Note**: For information on the older invocation style with named arguments expressed as environment variables, refer to the [documentation for the previous version of PE](/pe/3.3/console_rake_api_old.html). Note that when you have finished reviewing this documentation, you will need to navigate back to the PE3.7 documentation.

### Task Arguments as Parameters (`task[argument,argument,...]`)

This invocation style is available in PE 3.0.1 and later. It allows invoking multiple tasks at once, which was not possible with the environment variable style.

Use the following syntax to specify arguments as parameters:

    node:addgroup["switch07.example.com","no mcollective"]

Specifically, you should provide:

* The name of the task
* An opening square bracket (`[`)
    * A comma-separated list of argument values
        * **No spaces** are allowed before or after commas. Spaces will cause the task to fail.
        * Each task requires its arguments in a specific order; [see the list of tasks below](#node-tasks-getting-info).
        * Some arguments are optional. To skip an optional argument but provide a later optional argument, provide an empty string. (For example, `node:add['web06.example.com',,'linux::base']`.)
        * Nearly all values should be quoted for safety, although values that consist of only alphanumeric characters with no spaces may be left unquoted.
        * Both single and double quotes are okay, but see [Escaping](#escaping) below.
* A closing square bracket (`]`)

To run multiple tasks, simply put multiple tasks and their arguments in the same command line, in the order they should run. For example:

    $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production node:addgroup["switch07.example.com","no mcollective"] node:addgroup["switch07.example.com","network devices"]

> **Note:** The PE console's rake tasks can all be invoked multiple times in the same run. This differs from rake's default behavior, which will suppress additional invocations of the same command. If you need tasks to run only once per command for some reason, you can add `allow_repeating_tasks=false` to the command line.

#### Escaping

If the **value** of any argument contains a comma, the comma must be escaped with one or more backslashes. The number of escape characters depends on how the string is quoted.

* With single quotes, use one backslash.
* With double quotes, use two backslashes.

The examples below would both set a value of `no mcollective,network devices` for the second argument:

    node:add['switch07.example.com','no mcollective\,network devices']

    node:add["switch07.example.com","no mcollective\\,network devices"]

In two tasks (`node:variables` and `nodegroup:variables`), the value of an argument might consist of a comma-separated list whose terms, themselves, contain commas. In these cases, the interior commas should be escaped with three backslashes for single-quoted strings, and six backslashes for double-quoted strings. The examples below would both set the value of the `haproxy_application_servers` variable to `web04.example.com,web05.example.com,web06.example.com`:

    nodegroup:variables['load balancers','haproxy_application_port=3000\,haproxy_application_servers=web04.example.com\\\,web05.example.com\\\,web06.example.com']

    nodegroup:variables["load balancers","haproxy_application_port=3000\\,haproxy_application_servers=web04.example.com\\\\\\,web05.example.com\\\\\\,web06.example.com"]


### Task Arguments as Environment Variables (`task argument=value argument=value`)

This invocation style is available in all PE 3.x and 2.x releases. It **does not** allow invoking multiple tasks at once; this can cause performance problems when running many tasks, as the preparation time for each rake command can be quite long.

> **Deprecation note:** Invoking tasks like this will cause deprecation warnings, but it will continue to work for the duration of the Puppet Enterprise 3.x series, with removal tentatively planned for Puppet Enterprise 4.0.

Use the following syntax to specify arguments as environment variables:

    node:addgroup name="switch07.example.com" group="no mcollective"

Specifically, you should provide:

* The name of the task
* For each argument:
    * A space
    * The name of the argument
    * An equals sign (`=`)
    * The value of the argument, as a quoted or unquoted string

Each task has specific names that must be used for its arguments. The arguments may be specified in any order. For the names of each task's arguments, [see the list of rake API tasks with environment variable argument names](/pe/3.3/console_rake_api_old.html), which is maintained on a different page.


Node Tasks: Getting Info
-----

>**Note**: In the PE 3.7 series, these rake tasks operate against nodes that have been pinned to a group. See the [node classifier documentation](./console_classes_groups.html) for details about groups and pinned nodes.

### `node:list[(match)]`

List nodes. Can optionally match nodes by regex. 

Will do a request against the /v1/nodes endpoint of the node classifier, which will only show nodes that have checked in with the node classifier.

**Parameters:**

- `match` (optional) --- regular expression to match (if omitted all nodes are listed)

### `node:listclasses[name]`

List classes for a node.

**Parameters:**

- `name` --- node name

### `node:listclassparams[name,class]`

List classparams for a node/class pair.

**Parameters:**

- `name` --- node name
- `class` --- class name

### `node:variables[name]`

List variables for a node.

**Parameters:**

- `name` --- node name

### `node:listgroups[name]`

In the PE 3.7 series, this rake task is no longer valid. Running this task will result in a no operation with a removal warning.

Node Tasks: Modifying Info
-----

>**Note**: In the PE 3.7 series, these rake tasks operate against nodes that have been pinned to a group. See the [node classifier documentation](./console_classes_groups.html) for details about groups and pinned nodes.

### `node:add[name,(groups),(classes),(onexists)]`

Add a new node. Classes and groups can be specified as [comma-separated lists](#escaping).

**Parameters:**

- `name` --- node name
- `groups` --- in the PE 3.7 series, this parameter will be ignored
- `classes` (optional) --- classes to assign to the newly added node
- `onexists` (optional) --- *skip* (do not add the node if it exists) or *fail* (exit with failure if the node exists); the default value is *fail*

### `node:del[name]`

Delete a node. 

**Note:** A node cannot be deleted if the node name contains a parenthesis. To delete a node with a name that contains a parenthesis, you will need to rename the node.

**Note:** You will need the PE 3.7.2 release of Puppet Enterprise to use this rake task. 

**Parameters:**

- `name` --- node name

### `node:delgroup[name]`

Delete the node group to which the node is pinned. **Note: A node group cannot be deleted if the node group name contains a parenthesis. To delete a node group with a name that contains a parenthesis, you will need to rename the node group.**

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)

### `node:classes[name,classes]`

**Replace** the list of classes assigned to the node group to which the node is pinned. This task **will destroy existing data.** Classes must be specified as a [comma-separated list](#escaping).

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)
- `classes` --- classes to assign to the node group

### `node:groups[name,groups]`

**Replace** the list of groups a node belongs to. This task **will destroy existing data.** Groups must be specified as a [comma-separated list](#escaping).

**Parameters:**

- `name` --- node name
- `groups` --- groups to assign to the node

### `node:addclass[name,class]`

Add a class to the node group to which the node is pinned.

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)
- `class` --- classes to add to the node

### `node:addclassparam[name,class,param,value]`

Add a classparam to the node group to which the node is pinned. If the parameter already exists its value is overwritten.

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)
- `class` --- class (already assigned to the node)
- `param` --- parameter name
- `value` --- parameter value

### `node:addgroup[name,group]`

In the PE 3.7 series, this rake task is no longer valid. Running this task will result in a no operation with a removal warning.

### `node:delclassparam[name,class,param]`

Remove a class param from the node group to which the node is pinned.

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)
- `class` --- class name
- `param` --- parameter name

### `node:variables[name,variables]`

Add (or edit, if they exist) variables to the node group to which the node is pinned. Variables must be specified as a comma-separated list of variable=value pairs. The list must be quoted and [the commas must be escaped](#escaping).

**Parameters:**

- `name` --- node group name (should be the same as the name of the pinned node)
- `variables` --- variables specified as "&lt;VARIABLE&gt;=&lt;VALUE&gt;,&lt;VARIABLE&gt;=&lt;VALUE&gt;,..."


Class Tasks
-----

In the PE 3.7 series, class rake tasks are no longer valid; running these task will result in a no operation with a removal warning. 


Group Tasks: Getting Info
-----

### `nodegroup:list[match]`

List node groups. Can optionally match groups by regex.

**Parameters:**

- `match` (optional) --- regular expression to match (if omitted all groups are listed)

### `nodegroup:listclasses[name]`

List classes that belong to a node group.

**Parameters:**

- `name` --- group name

### `nodegroup:listclassparams[name,class]`

List classparams for a nodegroup/class pair.

**Parameters:**

- `name` --- group name
- `class` --- class name

### `nodegroup:listgroups[name]`

In the PE 3.7 series, this rake task is no longer valid. Running this task will result in a no operation with a removal warning.

### `nodegroup:variables[name]`

List variables for a node group.

**Parameters:**

- `name` --- group name

Group Tasks: Modifying Info
-----

### `nodegroup:add[name,(classes),(onexists)]`

Create a new node group. Classes can be specified as a [comma-separated list](#escaping).

**Parameters:**

- `name` --- group name
- `classes` (optional) --- classes to assign to the newly added group
- `onexists` (optional) --- *skip* (do not add the group if it exists) or *fail* (exit with failure if the group exists); the default value is *fail*

### `nodegroup:del[name]`

Delete a node group.

**Parameters:**

- `name` --- group name

### `nodegroup:add_all_nodes[name]`

In the PE 3.7 series, this rake task is no longer valid. Running this task will result in a no operation with a removal warning. 

### `nodegroup:addclass[name,class]`

Assign a class to a group without overwriting its existing classes.

**Parameters:**

- `name` --- group name
- `class` --- class name

### `nodegroup:edit[name,classes]`

**Replace** the classes assigned to a node group. This task **will destroy existing data.** Classes must be specified as a [comma-separated list](#escaping).

**Parameters:**

- `name` --- group name
- `classes` --- classes to assign to the group

### `nodegroup:addclassparam[name,class,param,value]`

Add a class parameter to a node group. If the parameter already exists its value is overwritten.

- `name` --- group name
- `class` --- class (already assigned to the node)
- `param` --- parameter name
- `value` --- parameter value

### `nodegroup:addgroup[name,group]`

Add a child group to a node group.

**Parameters:**

- `name` --- parent group name
- `group` --- name of the group to add as a child group

### `nodegroup:delclass[name,class]`

Remove a class from a nodegroup.

**Parameters:**

- `name` --- group name
- `class` --- class name

### `nodegroup:delclassparam[name,class,param]`

Remove a class param from a node group.

**Parameters:**

- `name` --- group name
- `class` --- class name
- `param` --- parameter name

### `nodegroup:delgroup[name,group]`

Resets the parent node group to the `default` group.

**Parameters:**

- `name` --- parent group name
- `group` --- child group name

### `nodegroup:variables[name,variables]`

Add (or edit, if they exist) variables for a node group. Variables must be specified as a comma-separated list of variable=value pairs. The list must be quoted and [the commas must be escaped](#escaping).

**Parameters:**

- `name` --- group name
- `variables` --- variables specified as `"<VARIABLE>=<VALUE>,<VARIABLE>=<VALUE>,..."`
