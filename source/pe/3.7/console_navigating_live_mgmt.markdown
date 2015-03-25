---
layout: default
title: "PE 3.7 » Console » Navigating Live Management"
subtitle: "Navigating Live Management"
canonical: "/pe/latest/console_navigating_live_mgmt.html"
---


What is Live Management?
-----

The Puppet Enterprise (PE) console's live management page is an interface to PE's orchestration engine. It can be used to browse resources on your nodes and invoke orchestration actions.

Related pages:

* [See the Orchestration: Overview page](./orchestration_overview.html) for background information about the orchestration engine.
* [See the Orchestration: Invoking Actions page](./orchestration_invoke_cli.html) to invoke the same orchestration actions on the command line.

> **Notes**: To invoke orchestration actions, you must be logged in as a read-write or admin level user. See [RBAC Permissions for more information](./rbac_permissions.html). Read-only users can browse resources, but cannot invoke actions.
>
> Since the live management page queries information directly from your nodes rather than using the console's cached reports, it responds more slowly than other parts of the console.

![The live management page][live_nav_main]

[live_nav_main]: ./images/console/live_nav_main.png

### Disabling/Enabling Live Management

In some cases, after you install PE, you may find that your workflow requires live management to be disabled. You can disable/enable live management at any time by editing the `disable_live_management` setting in `/etc/puppetlabs/puppet-dashboard/settings.yml` on the Puppet master. Note that after making your change, you must run `sudo /etc/init.d/pe-httpd restart` to complete the process.

By default, `disable_live_managment` is set to `false`, but you can also configure your [answer file installations][install_automated] or [upgrades][install_upgrading] to disable/enable live management as needed during installation or upgrade.

[install_automated]: ./install_automated.html
[install_upgrading]: ./install_upgrading.html#enabling_disabling-live-management-during-an-upgrade

The Node List
-----

Every task in live management inspects or modifies a **selection of nodes.** Use the **filterable node list** in the live management sidebar to select the nodes for your next action. (This list will only contain nodes that have completed at least one Puppet run, which may take up to 30 minutes after you've [signed their certificates][certsign].)

[certsign]: ./console_cert_mgmt.html


![The node list][live_nav_nodelist]

Nodes are listed by the same Puppet certificate names used in the rest of the console interface.

As long as you stay within the live management page, your selection and filtering in the node list will persist across all three tabs. The node list gets reset once you navigate to a different area of the console.

### Selecting Nodes

Clicking a node selects it or deselects it. Use the __select all__ and __select none__ controls to select and deselect all nodes that match the current filter.

Only visible nodes --- i.e. nodes that match the current filter --- can be selected. (Note that an empty filter shows all nodes.) You don't have to worry about accidentally commanding "invisibly" selected nodes.

### Filtering by Name

Use the __node filter__ field to filter your nodes by name.

![Nodes being filtered by name][live_nav_namefilter]

You can use the following wildcards in the node filter field:

- <big><strong>?</strong></big> matches one character
- <big><strong>\*</strong></big> matches many (or zero) characters

Use the __filter__ button or the enter key to confirm your search, then wait for the node list to be updated.

> **Hint**: Use the __Wildcards allowed__ link for a quick pop-over reminder.

### Advanced Search

You can also filter by Puppet class or by the value of any fact on your nodes. Click the __advanced search__ link to reveal these fields.

![The advanced search fields, filtering by the operatingsystem fact][live_nav_advancedsearch]

> **Hint**: Use the __common fact names__ link for a pop-over list of the most useful facts. Click a fact name to copy it to the filter field.
>
> ![The common fact names popover][live_nav_factlist]

You can browse the [inventory data](./console_reports.html#viewing-inventory-data) in the console's node views to find fact values to search with; this can help when looking for nodes similar to a specific node. You can also check the [list of core facts](/facter/1.7/core_facts.html) for valid fact names.

Filtering by Puppet class can be the most powerful filtering tool on this page, but it requires you to have already assigned classes to your nodes. See the chapter on [grouping and classifying nodes](./console_classes_groups.html) for more details.

[live_nav_advancedsearch]: ./images/console/live_nav_advancedsearch.png
[live_nav_factlist]: ./images/console/live_nav_factlist.png
[live_nav_namefilter]: ./images/console/live_nav_namefilter.png
[live_nav_nodelist]: ./images/console/live_nav_nodelist.png
[live_nav_tabs]: ./images/console/live_nav_tabs.png


Tabs
-----

The live management page is split into three **tabs**.

![The live management tabs][live_nav_tabs]

- [The **Browse Resources** tab](./orchestration_resources.html) lets you browse, search, inspect, and compare resources on any subset of your nodes.
- [The **Control Puppet** tab](./orchestration_puppet.html) lets you invoke Puppet-related actions on your nodes. These include telling any node to immediately fetch and apply its configuration, temporarily disabling Puppet agent on some nodes, and more.
- The **Advanced Tasks** tab lets you invoke orchestration actions on your nodes. It can invoke both the [built-in actions](./orchestration_actions.html) and any [custom actions](./orchestration_adding_actions.html) you've installed.

### The Browse Resources Tab

The interface of the Browse Resources tab is covered in [the Orchestration: Browsing Resources chapter](./orchestration_resources.html) of this manual.

### The Control Puppet Tab

The Control Puppet tab consists of a single **action list** ([see below](#action-lists)) with several Puppet-related actions. Detailed instructions for these actions are available in [the Orchestration: Control Puppet page](./orchestration_puppet.html) of this manual.

![The control puppet tab][live_puppet_main]

[live_puppet_main]: ./images/console/live_puppet_main.png

### The Advanced Tasks Tab

The Advanced Tasks tab contains a column of **task navigation** links in the left pane, which are used to switch the right pane between several **action lists** (and a summary list, which briefly describes each action list).

![The advanced tasks page][live_advanced_main]

#### Action Lists

Action lists contain groups of related actions --- for example, the __service__ list has actions for starting, stopping, restarting, and checking the status of services:

![The service action list][live_service_tasks]

These groups of actions come from the MCollective agent plugins you have installed, and each action list corresponds to one plugin. Both default and custom plugins are included on the Advanced Tasks page.

> For more information on these plugins, see:
>
> * [The "actions and plugins" section of the orchestration overview page](./orchestration_overview.html#actions-and-plugins)
> * [The list of built-in orchestration actions](./orchestration_actions.html)
> * [The "Orchestration: Adding Actions" page](./orchestration_adding_actions.html)
>
> Note that you can also trigger all of these actions from the command line:
>
> * [Invoking orchestration actions](./orchestration_invoke_cli.html)


Invoking Actions
-----

You can invoke actions from the [Control Puppet](#the-control-puppet-tab) and [Advanced Tasks](#the-advanced-tasks-tab) tabs.

To invoke an action, you must be viewing an **action list**.

1. Click the name of the action you want. It will reveal a red **Run** button and any available **argument fields** ([see below](#argument-fields)). Some actions do not have arguments.
2. Enter any arguments you wish to use.
3. Press the __Run__ button; Puppet Enterprise will show that the action is running, then display any results from the action.

If several nodes have similar results, they'll be collapsed to save space; you can click any result group to see which nodes have that result.

Invoking an action with an argument:

![Invoking the service agent's status action with httpd as an argument][live_advanced_args]

An action in progress:

![The running action spinner][live_advanced_running]

Results:

![Four nodes with a stopped httpd service][live_advanced_results]


### Argument Fields

Some arguments are mandatory, and some are optional. Mandatory arguments will be denoted with a red asterisk (\*).

Although all arguments are presented as text fields, some arguments have specific format requirements:

* The format of each argument should be clear from its description; otherwise, check the documentation for the action. Documentation for PE's built-in actions is available at [the list of built-in actions](./orchestration_actions.html).
* Arguments that are boolean in nature (on/off-type arguments) must have a value of `true` or `false` --- no other values are allowed.




[live_advanced_args]: ./images/console/live_advanced_args.png
[live_advanced_main]: ./images/console/live_advanced_main.png
[live_advanced_results]: ./images/console/live_advanced_results.png
[live_advanced_running]: ./images/console/live_advanced_running.png
[live_service_tasks]: ./images/console/live_service_tasks.png

* * *

- [Next: Managing Node Requests](./console_cert_mgmt.html)
