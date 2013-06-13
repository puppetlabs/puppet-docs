---
layout: default
title: "PE 3.0 » Orchestration » List of Built-In Actions"
---

Available Actions
-----

The following orchestration actions are available in PE:

* `rpcutil` plugin
  - `find` action returns a list of all nodes matching a search filter
  - `ping` action returns a list of all nodes and their latencies
  - `inventory` action returns a list of Facts, Classes, and other information from all nodes
  - this plugin's actions are exposed via higher-level wrappers, such as the `mco ping` command
* `puppetral` plugin
  - `find` action returns a Puppet resource of a given type and title and its variations across all nodes
  - `search` action returns all Puppet resources of a given type across all nodes
  - `create` action creates a given resource across all nodes
    - creating an exec resource allows for arbitrary management of nodes
* `puppetd` plugin
  - `enable` and `disable` actions will enable and disable puppet agent on a node or nodes
  - `runonce` action initiates a puppet agent run on all nodes
  - `last_run_summary` action retrieves the most recent Puppet run summary from all nodes
  - `status` action returns puppet agent's run status on all nodes
* `service` plugin
  - `start, stop, restart,` and `status` actions allow direct management of services across the deployment
* `package` plugin
  - `install, purge, checkupdate, update,` and `status` actions work through the system package manager to query and ensure the state of software packages across the deployment
* `controller` plugin
  - `stats` action returns cumulative statistics about MCollective messages passed between nodes
  - `reload_agent` action refreshes from disk the code for a specific plugin
  - `reload_agents` action refreshes from disk the code for all plugins
  - `exit` action removes nodes from the MCollective network
