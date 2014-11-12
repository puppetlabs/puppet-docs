---
layout: default
title: "PE 3.7 » Orchestration » List of Built-In Actions"
subtitle: "List of Built-In Orchestration Actions"
canonical: "/pe/latest/orchestration_actions.html"
---

[fundamentals]: ./orchestration_overview.html#orchestration-fundamentals

About This Page
-----

This page is a comprehensive list of Puppet Enterprise (PE)'s built-in orchestration actions. These actions can be invoked on the command line or in the PE console.

> ### Related Topics
>
> * For an overview of orchestration topics, see [the Orchestration Overview page][fundamentals].
> * To invoke actions in the PE console, see [Navigating Live Management](./console_navigating_live_mgmt.html).
> * To invoke actions on the command line, see [Invoking Actions](./orchestration_invoke_cli.html).
> * To add your own actions, see [Adding Orchestration Actions](./orchestration_adding_actions.html).

Actions and Plugins
-----

Sets of related actions are bundled together as **MCollective agent plugins.** Every action is part of a plugin.

A default Puppet Enterprise install includes the [package](#the-package-plugin), [puppet](#the-puppet-plugin), [puppetral](#the-puppetral-plugin), [rpcutil](#the-rpcutil-plugin), and [service](#the-service-plugin) plugins. See [the table of contents above](#content) for an outline of each plugin's actions; click an action for details about its inputs, effects, and outputs.

You can easily add new orchestration actions by distributing custom MCollective agent plugins to your nodes. See [Adding Orchestration Actions](./orchestration_adding_actions.html) for details.


[↑ Back to top](#content)

The `package` Plugin
-----

Install and uninstall software packages

Actions: `apt_checkupdates`, `apt_update`, `checkupdates`, `install`, `purge`, `status`, `uninstall`, `update`, `yum_checkupdates`, `yum_clean`

### apt_checkupdates

Check for APT updates

(no inputs)

**Outputs:**

`exitcode`
: (Appears as "Exit Code" on CLI)

  The exitcode from the apt command

`outdated_packages`
: (Appears as "Outdated Packages" on CLI)

  Outdated packages

`output`
: (Appears as "Output" on CLI)

  Output from APT


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### apt_update

Update the apt cache

(no inputs)

**Outputs:**

`exitcode`
: (Appears as "Exit Code" on CLI)

  The exitcode from the apt-get command

`output`
: (Appears as "Output" on CLI)

  Output from apt-get


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### checkupdates

Check for updates

(no inputs)

**Outputs:**

`exitcode`
: (Appears as "Exit Code" on CLI)

  The exitcode from the package manager command

`outdated_packages`
: (Appears as "Outdated Packages" on CLI)

  Outdated packages

`output`
: (Appears as "Output" on CLI)

  Output from Package Manager

`package_manager`
: (Appears as "Package Manager" on CLI)

  The detected package manager


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### install

Install a package

**Input:**

`package` **(required)**
: Package to install

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 90


**Outputs:**

`arch`
: (Appears as "Arch" on CLI)

  Package architecture

`ensure`
: (Appears as "Ensure" on CLI)

  Full package version

`epoch`
: (Appears as "Epoch" on CLI)

  Package epoch number

`name`
: (Appears as "Name" on CLI)

  Package name

`output`
: (Appears as "Output" on CLI)

  Output from the package manager

`provider`
: (Appears as "Provider" on CLI)

  Provider used to retrieve information

`release`
: (Appears as "Release" on CLI)

  Package release number

`version`
: (Appears as "Version" on CLI)

  Version number


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### purge

Purge a package

**Input:**

`package` **(required)**
: Package to purge

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 90


**Outputs:**

`arch`
: (Appears as "Arch" on CLI)

  Package architecture

`ensure`
: (Appears as "Ensure" on CLI)

  Full package version

`epoch`
: (Appears as "Epoch" on CLI)

  Package epoch number

`name`
: (Appears as "Name" on CLI)

  Package name

`output`
: (Appears as "Output" on CLI)

  Output from the package manager

`provider`
: (Appears as "Provider" on CLI)

  Provider used to retrieve information

`release`
: (Appears as "Release" on CLI)

  Package release number

`version`
: (Appears as "Version" on CLI)

  Version number


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### status

Get the status of a package

**Input:**

`package` **(required)**
: Package to retrieve the status of

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 90


**Outputs:**

`arch`
: (Appears as "Arch" on CLI)

  Package architecture

`ensure`
: (Appears as "Ensure" on CLI)

  Full package version

`epoch`
: (Appears as "Epoch" on CLI)

  Package epoch number

`name`
: (Appears as "Name" on CLI)

  Package name

`output`
: (Appears as "Output" on CLI)

  Output from the package manager

`provider`
: (Appears as "Provider" on CLI)

  Provider used to retrieve information

`release`
: (Appears as "Release" on CLI)

  Package release number

`version`
: (Appears as "Version" on CLI)

  Version number


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### uninstall

Uninstall a package

**Input:**

`package` **(required)**
: Package to uninstall

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 90


**Outputs:**

`arch`
: (Appears as "Arch" on CLI)

  Package architecture

`ensure`
: (Appears as "Ensure" on CLI)

  Full package version

`epoch`
: (Appears as "Epoch" on CLI)

  Package epoch number

`name`
: (Appears as "Name" on CLI)

  Package name

`output`
: (Appears as "Output" on CLI)

  Output from the package manager

`provider`
: (Appears as "Provider" on CLI)

  Provider used to retrieve information

`release`
: (Appears as "Release" on CLI)

  Package release number

`version`
: (Appears as "Version" on CLI)

  Version number


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### update

Update a package

**Input:**

`package` **(required)**
: Package to update

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 90


**Outputs:**

`arch`
: (Appears as "Arch" on CLI)

  Package architecture

`ensure`
: (Appears as "Ensure" on CLI)

  Full package version

`epoch`
: (Appears as "Epoch" on CLI)

  Package epoch number

`name`
: (Appears as "Name" on CLI)

  Package name

`output`
: (Appears as "Output" on CLI)

  Output from the package manager

`provider`
: (Appears as "Provider" on CLI)

  Provider used to retrieve information

`release`
: (Appears as "Release" on CLI)

  Package release number

`version`
: (Appears as "Version" on CLI)

  Version number


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### yum_checkupdates

Check for YUM updates

(no inputs)

**Outputs:**

`exitcode`
: (Appears as "Exit Code" on CLI)

  The exitcode from the yum command

`outdated_packages`
: (Appears as "Outdated Packages" on CLI)

  Outdated packages

`output`
: (Appears as "Output" on CLI)

  Output from YUM


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### yum_clean

Clean the YUM cache

**Input:**

`mode`
: One of the various supported clean modes

  - **Type:** list
  - **Valid Values:** `all`, `headers`, `packages`, `metadata`, `dbcache`, `plugins`, `expire-cache`


**Outputs:**

`exitcode`
: (Appears as "Exit Code" on CLI)

  The exitcode from the yum command

`output`
: (Appears as "Output" on CLI)

  Output from YUM

[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

The `puppet` Plugin
-----

Run Puppet agent, get its status, and enable/disable it

Actions: `disable`, `enable`, `last_run_summary`, `resource`, `runonce`, `status`

### disable

Disable the Puppet agent

**Input:**

`message`
: Supply a reason for disabling the Puppet agent

  - **Type:** string
  - **Format/Validation:** `shellsafe`
  - **Length:** 120


**Outputs:**

`enabled`
: (Appears as "Enabled" on CLI)

  Is the agent currently locked

`status`
: (Appears as "Status" on CLI)

  Status


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### enable

Enable the Puppet agent

(no inputs)

**Outputs:**

`enabled`
: (Appears as "Enabled" on CLI)

  Is the agent currently locked

`status`
: (Appears as "Status" on CLI)

  Status


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### last_run_summary

Get the summary of the last Puppet run

(no inputs)

**Outputs:**

`changed_resources`
: (Appears as "Changed Resources" on CLI)

  Resources that were changed

`config_retrieval_time`
: (Appears as "Config Retrieval Time" on CLI)

  Time taken to retrieve the catalog from the master

`config_version`
: (Appears as "Config Version" on CLI)

  Puppet config version for the previously applied catalog

`failed_resources`
: (Appears as "Failed Resources" on CLI)

  Resources that failed to apply

`lastrun`
: (Appears as "Last Run" on CLI)

  When the Agent last applied a catalog in local time

`out_of_sync_resources`
: (Appears as "Out of Sync Resources" on CLI)

  Resources that were not in desired state

`since_lastrun`
: (Appears as "Since Last Run" on CLI)

  How long ago did the Agent last apply a catalog in local time

`summary`
: (Appears as "Summary" on CLI)

  Summary data as provided by Puppet

`total_resources`
: (Appears as "Total Resources" on CLI)

  Total resources managed on a node

`total_time`
: (Appears as "Total Time" on CLI)

  Total time taken to retrieve and process the catalog

`type_distribution`
: (Appears as "Type Distribution" on CLI)

  Resource counts per type managed by Puppet


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### resource

Evaluate Puppet RAL resources

**Inputs:**

`name` **(required)**
: Resource Name

  - **Type:** string
  - **Format/Validation:** `^.+$`
  - **Length:** 150

`type` **(required)**
: Resource Type

  - **Type:** string
  - **Format/Validation:** `^.+$`
  - **Length:** 50


**Outputs:**

`changed`
: (Appears as "Changed" on CLI)

  Was a change applied based on the resource

`result`
: (Appears as "Result" on CLI)

  The result from the Puppet resource


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### runonce

Invoke a single Puppet run

**Inputs:**

`environment`
: Which Puppet environment to run

  - **Type:** string
  - **Format/Validation:** `puppet_variable`
  - **Length:** 50

`force`
: Will force a run immediately else is subject to default splay time

  - **Type:** boolean

`noop`
: Do a Puppet dry run

  - **Type:** boolean

`server`
: Address and port of the Puppet Master in server:port format

  - **Type:** string
  - **Format/Validation:** `puppet_server_address`
  - **Length:** 50

`splay`
: Sleep for a period before initiating the run

  - **Type:** boolean

`splaylimit`
: Maximum amount of time to sleep before run

  - **Type:** number

`tags`
: Restrict the Puppet run to a comma list of tags

  - **Type:** string
  - **Format/Validation:** `puppet_tags`
  - **Length:** 120


**Output:**

`summary`
: (Appears as "Summary" on CLI)

  Summary of command run


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### status

Get the current status of the Puppet agent

(no inputs)

**Outputs:**

`applying`
: (Appears as "Applying" on CLI)

  Is a catalog being applied

`daemon_present`
: (Appears as "Daemon Running" on CLI)

  Is the Puppet agent daemon running on this system

`disable_message`
: (Appears as "Lock Message" on CLI)

  Message supplied when agent was disabled

`enabled`
: (Appears as "Enabled" on CLI)

  Is the agent currently locked

`idling`
: (Appears as "Idling" on CLI)

  Is the Puppet agent daemon running but not doing any work

`lastrun`
: (Appears as "Last Run" on CLI)

  When the Agent last applied a catalog in local time

`since_lastrun`
: (Appears as "Since Last Run" on CLI)

  How long ago did the Agent last apply a catalog in local time

`status`
: (Appears as "Status" on CLI)

  Current status of the Puppet agent

[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

The `puppetral` Plugin
-----

View resources with Puppet's resource abstraction layer

Actions: `find`, `search`

### find

Get the attributes and status of a resource

**Inputs:**

`title` **(required)**
: Name of resource to check

  - **Type:** string
  - **Format/Validation:** `.`
  - **Length:** 90

`type` **(required)**
: Type of resource to check

  - **Type:** string
  - **Format/Validation:** `.`
  - **Length:** 90


**Outputs:**

`exported`
: (Appears as "Exported" on CLI)

  Boolean flag indicating export status

`managed`
: (Appears as "Managed" on CLI)

  Flag indicating managed status

`parameters`
: (Appears as "Parameters" on CLI)

  Parameters of the inspected resource

`tags`
: (Appears as "Tags" on CLI)

  Tags of the inspected resource

`title`
: (Appears as "Title" on CLI)

  Title of the inspected resource

`type`
: (Appears as "Type" on CLI)

  Type of the inspected resource


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### search

Get detailed info for all resources of a given type

**Input:**

`type` **(required)**
: Type of resource to check

  - **Type:** string
  - **Format/Validation:** `.`
  - **Length:** 90


**Output:**

`result`
: (Appears as "Result" on CLI)

  The values of the inspected resources

[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

The `rpcutil` Plugin
-----

General helpful actions that expose stats and internals to SimpleRPC clients

Actions: `agent_inventory`, `collective_info`, `daemon_stats`, `get_config_item`, `get_data`, `get_fact`, `inventory`, `ping`

### agent_inventory

Inventory of all agents on the server

(no inputs)

**Output:**

`agents`
: (Appears as "Agents" on CLI)

  List of agents on the server


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### collective_info

Info about the main and sub collectives

(no inputs)

**Outputs:**

`collectives`
: (Appears as "All Collectives" on CLI)

  All Collectives

`main_collective`
: (Appears as "Main Collective" on CLI)

  The main Collective


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### daemon_stats

Get statistics from the running daemon

(no inputs)

**Outputs:**

`agents`
: (Appears as "Agents" on CLI)

  List of agents loaded

`configfile`
: (Appears as "Config File" on CLI)

  Config file used to start the daemon

`filtered`
: (Appears as "Failed Filter" on CLI)

  Didn't pass filter checks

`passed`
: (Appears as "Passed Filter" on CLI)

  Passed filter checks

`pid`
: (Appears as "PID" on CLI)

  Process ID of the daemon

`replies`
: (Appears as "Replies" on CLI)

  Replies sent back to clients

`starttime`
: (Appears as "Start Time" on CLI)

  Time the server started

`threads`
: (Appears as "Threads" on CLI)

  List of threads active in the daemon

`times`
: (Appears as "Times" on CLI)

  Processor time consumed by the daemon

`total`
: (Appears as "Total Messages" on CLI)

  Total messages received

`ttlexpired`
: (Appears as "TTL Expired" on CLI)

  Messages that did pass TTL checks

`unvalidated`
: (Appears as "Failed Security" on CLI)

  Messages that failed security validation

`validated`
: (Appears as "Security Validated" on CLI)

  Messages that passed security validation

`version`
: (Appears as "Version" on CLI)

  MCollective Version


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### get_config_item

Get the active value of a specific config property

**Input:**

`item` **(required)**
: The item to retrieve from the server

  - **Type:** string
  - **Format/Validation:** `^.+$`
  - **Length:** 50


**Outputs:**

`item`
: (Appears as "Property" on CLI)

  The config property being retrieved

`value`
: (Appears as "Value" on CLI)

  The value that is in use


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### get_data

Get data from a data plugin

**Inputs:**

`query`
: The query argument to supply to the data plugin

  - **Type:** string
  - **Format/Validation:** `^.+$`
  - **Length:** 50

`source` **(required)**
: The data plugin to retrieve information from

  - **Type:** string
  - **Format/Validation:** `^\w+$`
  - **Length:** 50


**Outputs:**


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### get_fact

Retrieve a single fact from the fact store

**Input:**

`fact` **(required)**
: The fact to retrieve

  - **Type:** string
  - **Format/Validation:** `^[\w\-\.]+$`
  - **Length:** 40


**Outputs:**

`fact`
: (Appears as "Fact" on CLI)

  The name of the fact being returned

`value`
: (Appears as "Value" on CLI)

  The value of the fact


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### inventory

System Inventory

(no inputs)

**Outputs:**

`agents`
: (Appears as "Agents" on CLI)

  List of agent names

`classes`
: (Appears as "Classes" on CLI)

  List of classes on the system

`collectives`
: (Appears as "All Collectives" on CLI)

  All Collectives

`data_plugins`
: (Appears as "Data Plugins" on CLI)

  List of data plugin names

`facts`
: (Appears as "Facts" on CLI)

  List of facts and values

`main_collective`
: (Appears as "Main Collective" on CLI)

  The main Collective

`version`
: (Appears as "Version" on CLI)

  MCollective Version


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### ping

Responds to requests for PING with PONG

(no inputs)

**Output:**

`pong`
: (Appears as "Timestamp" on CLI)

  The local timestamp

[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

The `service` Plugin
-----

Start and stop system services

Actions: `restart`, `start`, `status`, `stop`

### restart

Restart a service

**Input:**

`service` **(required)**
: The service to restart

  - **Type:** string
  - **Format/Validation:** `service_name`
  - **Length:** 90


**Output:**

`status`
: (Appears as "Service Status" on CLI)

  The status of the service after restarting


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### start

Start a service

**Input:**

`service` **(required)**
: The service to start

  - **Type:** string
  - **Format/Validation:** `service_name`
  - **Length:** 90


**Output:**

`status`
: (Appears as "Service Status" on CLI)

  The status of the service after starting


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### status

Gets the status of a service

**Input:**

`service` **(required)**
: The service to get the status for

  - **Type:** string
  - **Format/Validation:** `service_name`
  - **Length:** 90


**Output:**

`status`
: (Appears as "Service Status" on CLI)

  The status of the service


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

### stop

Stop a service

**Input:**

`service` **(required)**
: The service to stop

  - **Type:** string
  - **Format/Validation:** `service_name`
  - **Length:** 90


**Output:**

`status`
: (Appears as "Service Status" on CLI)

  The status of the service after stopping


[↑ Back to top](#content)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

- [Next: Adding New Orchestration Actions](./orchestration_adding_actions.html)