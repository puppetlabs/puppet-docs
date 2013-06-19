---
layout: default
title: "PE 3.0 » Orchestration » Controlling Puppet"
subtitle: "Orchestration: Controlling Puppet"
---

[certsign]: ./install_basic.html#signing-agent-certificates
[puppet_tab]: ./console_navigating_live_mgmt.html#tabs
[peadmin]: todo
[inpage_stop]: #start-and-stop-the-puppet-agent-service
[filter]: todo
[environment]: todo
[tags]: todo
[batch]: todo
[data_plugins]: todo

Puppet Enterprise (PE)'s configuration management features rely on the **puppet agent service,** which runs on every node and fetches configurations from the puppet master server. [(See the Puppet section of this manual for more details.)](./puppet_tools.html)

By default, puppet agent idles in the background and performs a run every 30 minutes, but the orchestration engine can give complete control over this behavior. See the table of contents above for an overview of the available features.

> **Note:** The orchestration engine cannot trigger a node's _very first_ puppet agent run. A node's first run will happen automatically within 30 minutes after you [sign its certificate][certsign].

Basics
-----

### Invoking Actions

The orchestration engine can control Puppet from the **web console** and from the puppet master server's Linux **command line.** These interfaces don't have identical capabilities, so this page will call out any differences when applicable.

In the console, most of these tasks use [the "Control Puppet" tab of the live management page][puppet_tab], which behaves much like the "Advanced Tasks" tab. On the command line, most of these tasks use the `mco puppet` subcommand.

![The control puppet tab][live_puppet_main] TODO chop this down a bit

> See the following pages for basic instructions on invoking actions, including how to log in:
>
> * [Invoking Actions (In Console)][cli]
> * [Invoking Actions (Command Line)][console]

[console]: ./orchestration_invoke_cli.html
[cli]: ./orchestration_invoke_console.html

### The Puppet Agent Service

In PE 3.0, puppet agent runs in the background as a system service.

* On \*nix nodes, this service is named `pe-puppet`.
* On Windows nodes, this service's display name is `Puppet Agent` and its short name is `pe-puppet`.

### Agent Status: Enabled, Disabled, etc.

Puppet agent can be in many possible states, which are represented by three attributes:

* **Running** or **stopped** --- whether the agent _service_ (`pe-puppet`) is running in the background. Even if it's running, the service may or may not be doing anything at the moment. If the service is stopped, no scheduled runs will occur but you can trigger on-demand runs.
* **Applying,** **idling,** or **neither** --- whether puppet agent is in the process of applying a configuration. Idling is only applicable if the service is running, but Puppet may be applying an on-demand configuration even if the service is stopped.
* **Enabled** or **disabled** --- whether there's a lockfile preventing puppet agent from performing _any_ configuration runs. If puppet agent is disabled, the service can idle in the background but no configurations can be applied --- even on-demand runs will be rejected until the agent is re-enabled.

The orchestration engine can trigger on-demand Puppet runs unless the agent is **applying** or **disabled.** Scheduled runs will only take place if the agent is both **running** and **enabled.**


Run Puppet on Demand
-----

Use the `runonce` action to trigger an immediate Puppet run on a few nodes. If you need to run Puppet on many nodes (more than about 10), you should see [the "many nodes" section below](#run-puppet-on-many-nodes-in-a-controlled-series).

[options]: #behavior-note-running-vs-stopped

> ### Behavior Differences: Running vs. Stopped
>
> You can trigger on-demand Puppet runs whether the `pe-puppet` service is running or stopped, but on \*nix nodes these cases will behave slightly differently:
>
> * When the service is **running,** all of the selected nodes will begin a run _immediately,_ and you _cannot_ specify any special options like `noop` or `tags`; they will be ignored. This behavior is usually fine but sometimes undesirable.
> * When the service is **stopped,** the selected nodes will randomly stagger the start of their runs ("splay") over a default interval of _two minutes._ If you wish, you _can_ specify special options, including a longer interval ("splaylimit"). You can also set the `force` option to `true` if you want the selected nodes to start immediately. This behavior is more flexible and resilient.
>
> This difference only affects \*nix nodes; Windows nodes always behave like a **stopped** \*nix node. The difference will be addressed in a future version of PE; for now, you may wish to [stop the `pe-puppet` service][inpage_stop] before trying to do `noop` or `tags` runs.


### In the Console

TODO

### On the Command Line

While [logged in to the puppet master server as `peadmin`][peadmin], run the `mco puppet runonce` command.

    $ mco puppet runonce -I web01.example.com -I web02.example.com
    $ mco puppet runonce -F kernelversion=2.6.32

Be sure to [specify a filter][filter] to limit the number of nodes; you should generally invoke this action on fewer than 10 nodes at a time, especially if the agent service is running and you cannot specify extra options ([see above][options]).

#### Extra Options

If the agent service is stopped (on affected \*nix nodes; [see above][options]), you can change the way Puppet runs with command line options. You can see a list of these by running `mco puppet --help`.

    --force                      Bypass splay options when running
    --server SERVER              Connect to a specific server or port
    --tags, --tag TAG            Restrict the run to specific tags
    --noop                       Do a noop run
    --no-noop                    Do a run with noop disabled
    --environment ENVIRONMENT    Place the node in a specific environment for this run
    --splay                      Splay the run by up to splaylimit seconds
    --no-splay                   Do a run with splay disabled
    --splaylimit SECONDS         Maximum splay time for this run if splay is set
    --ignoreschedules            Disable schedule processing

The most useful options are:

* `--noop`, which causes puppet agent to only _simulate_ changes, and submit a report describing what _would_ have changed in a real run. Useful for safely testing new manifests. If you have configured puppet agent to _always_ run in no-op mode (via `/etc/puppetlabs/puppet/puppet.conf`), you can use `--no-noop` to do an enforcing Puppet run.
* `--environment ENVIRONMENT`, which causes puppet agent to run in the specified [environment][]. Also useful for testing new manifests on a subset of nodes.
* `--tags TAGS`, which takes a comma-separated list of [tags][] and applies only resources with those tags. Tags can be class names, and this is a fast way to test changes to a single class without performing an entire Puppet run.
* `--server SERVER`, which causes puppet agent to contact a different puppet master than normal. Also useful for testing new manifests (or a new version of PE) on a subset of nodes.

Run Puppet on Many Nodes in a Controlled Series
-----

> **Note:** In PE 3.0, this feature is only available on the command line; you cannot do a controlled run series in the console.

If you want to trigger a run on a large number of nodes --- more than about 10 --- the `runonce` action isn't always the best tool. You can splay or [batch][] the runs, but this requires you to guess how long each run is going to take, and a wrong guess can either waste time or temporarily overwhelm the puppet master server.

Instead, use the special `runall` action of the `mco puppet` subcommand.

    $ mco puppet runall 5 -F operatingsystem=CentOS -F operatingsystemrelease=6.4

This action requires an argument, which must be the number of nodes allowed to run at once. It invokes a run on that many nodes, then only starts the next node when one has finished. This prevents your puppet master from being overwhelmed by the herd, and will delay only as long as is necessary. The ideal concurrency will vary from site to site, depending on how powerful your puppet master server is and how complex your configurations are.

The `runall` action can take extra options like `--noop` [as described for the `runonce` action](#extra-options); however, note that [restrictions still apply for \*nix nodes where the pe-puppet service is running](#behavior-differences-running-vs-stopped).

Enable and Disable Puppet Agent
-----

Disabling Puppet will block **all** Puppet runs, including both scheduled and on-demand runs. This is usually used while you investigate some kind of problem. Use the `enable` and `disable` actions of the `puppet` plugin.

The `disable` action accepts an optional reason for the lockdown; take advantage of this to keep your colleagues informed. The reason will be shown when checking Puppet's status on those nodes.

### In the Console

TODO

### On the Command Line

While [logged in to the puppet master server as `peadmin`][peadmin], run `mco puppet disable` or `mco puppet enable` with or without a filter.

**Example:** You noticed Puppet runs failing on a load balancer and expect they'll start failing on the other ones too:

    $ mco puppet disable "Investigating a problem with the haproxy module. -NF" -C /haproxy/


Start and Stop the Puppet Agent Service
-----

You can start or stop the `pe-puppet` service with the `start` and `stop` actions of the `service` plugin. This can be useful if you need to do noop runs, or if you wish to stop all scheduled runs and only run puppet agent on demand.

### In the Console

TODO

### On the Command Line

While [logged in to the puppet master server as `peadmin`][peadmin], run `mco service pe-puppet stop` or `mco service pe-puppet start` with or without a filter.

To prepare all web servers for a manifest update and no-op run:

    $ mco service pe-puppet stop -C /apache/


View Puppet Agent's Status
-----

> **Note:** Although you can view status on both the console and the command line, the command line currently gives much better summaries when checking large numbers of nodes.

[As mentioned above](#agent-status-enabled-disabled-etc), puppet agent can be in various states. The orchestration engine lets you check the current status on any number of nodes.

### In the Console

TODO

### On the Command Line

#### Aggregate Status

While [logged in to the puppet master server as `peadmin`][peadmin], run `mco puppet status` with or without a filter. This returns an abbreviated status for each node, and a summarized breakdown of how many nodes are in which conditions.

    $ mco puppet status

#### Viewing Disable Messages

The one thing `mco puppet status` doesn't show is the [reason why puppet agent was disabled](#enable-and-disable-puppet-agent). If you're checking up on disabled nodes, you can get a more raw view of the status by running `mco rpc puppet status` instead. This will display the reason in the "Lock Message" field.

**Example:** Get the detailed status for every disabled node, using the `puppet` [data plugin][data_plugins]:

    $ mco rpc puppet status -S "puppet().enabled=false"


View Statistics About Recent Runs
-----

> **Note:** Detailed statistics are available on both the console and the command line, but the population summary graphs are only available on the command line.

Puppet keeps records of the last run, including the amount of time spent per resource type, the number of changes, number of simulated changes, time since last run, etc. You can retrieve and summarize these statistics with the orchestration engine.

### In the Console

TODO

### On the Command Line

#### Population Summary Graphs

You can get sparkline graphs for the last run statistics across all your nodes with the `mco puppet summary` command. This shows the distribution of your nodes, so you can see whether a significant group is taking notably longer or seeing more changes.

    $ mco puppet summary
    Summary statistics for 10 nodes:

                      Total resources: ▇▁▁▂▁▁▁▂▁▁▁▁▁▁▁▃▁▁▁▁  min: 93.0   max: 155.0
                Out Of Sync resources: ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁  min: 0.0    max: 0.0
                     Failed resources: ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁  min: 0.0    max: 0.0
                    Changed resources: ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁  min: 0.0    max: 0.0
      Config Retrieval time (seconds): ▇▇▃▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁  min: 1.9    max: 5.8
             Total run-time (seconds): ▇▆▃▄▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁  min: 2.2    max: 6.7
        Time since last run (seconds): ▇▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▂  min: 314.0  max: 23.4k

#### Detailed Statistics

While [logged in to the puppet master server as `peadmin`][peadmin], run `mco rpc puppet last_run_summary` with or without a filter. This returns detailed run statistics for each node. (Note that this uses the `rpc` subcommand instead of the `puppet` subcommand.)


------OLD--------

Use the "Control Puppet" tab to immediately trigger a puppet agent run on any of your nodes. You can also check puppet agent's status, and enable or disable it to control the spread of new configurations.



Invoking an Action
-----

The "Control Puppet" tab can perform five actions:

- Disable
- Enable
- Last Run Summary
- Runonce
- Status

To use one, click the name of the action, then confirm with the red "Run" button.

![The red Run button revealed][live_puppet_runbutton]

Running an action returns a results view. Results views will attempt to group similar results to reduce noise; click the "on N nodes" links to see which nodes returned a given result.

A collapsed results view:

![A collapsed results view][live_puppet_results_collapsed]

An expanded results view:

![An expanded results view][live_puppet_results_expanded]

Actions
-----

### Run Puppet Once

Use the "runonce" action to make the selected nodes immediately pull and apply their configurations from the puppet master.

Normally, puppet agent pulls configurations at a regular interval (30 minutes, by default). However, when testing new Puppet classes, you'll probably need to trigger agent runs at irregular times on your test nodes.

Nodes where puppet agent is disabled will ignore this action.

### Enable and Disable

Use the "enable" and "disable" actions to control whether puppet agent _does_ anything. When you disable Puppet on a node, the agent daemon will continue running, but it will not pull configurations from the master.

After a node has been disabled for an hour, it will appear as "unresponsive" in the console's node views, and will stay that way until it is re-enabled. Disabled nodes will ignore runonce commands from the "Control Puppet" tab.

Disabling nodes is great for hedging your bets when you've made major changes to an existing Puppet module:

* Filter the node list by Puppet class to find every node that will be affected by the change
* Disable Puppet on all but a few of these nodes
* Run Puppet on the test nodes, and carefully examine the reports to make sure the changes worked
* Re-enable Puppet on the rest of your nodes (or a subset thereof, if you think you need more testing)

A confirmation screen will appear after disabling some nodes:

![The disable confirmation, with four nodes revealed][live_puppet_disable_results]

Results after trying to run a mix of enabled and disabled nodes --- note the three nodes whose only response was "---":

![Runonce results, with three disabled nodes revealed][live_puppet_disabled_wont_run]

A view of unresponsive nodes in the console (note that node certnames on EC2 don't necessarily align with hostnames):

![An unresponsive node view with three nodes][live_puppet_unresponsive]

### Status

Use the "status" action to check up on puppet agent.

The status action gets three pieces of information from each node:

* Whether Puppet is enabled or disabled
* Whether Puppet is idle ("not running") or actively applying a configuration ("running")
* When the last Puppet run occurred

The results of the status action, with a mix of enabled and disabled nodes:

![The results of the status action][live_puppet_status]

### Last Run Summary

Use the "last\_run\_summary" action for a quick view of what the most recent Puppet run did.

Usually, you should use the graphs and reports on the console's node views to investigate previous Puppet runs; they are more detailed, and provide more historical context. However, the overview provided by this action can be useful when combined with live management's class and fact filtering.

Part of a last run summary results view:

![Part of a last run summary results view][live_puppet_lastrun]

[live_puppet_disable_results]: ./images/console/live_puppet_disable_results.png
[live_puppet_disabled_wont_run]: ./images/console/live_puppet_disabled_wont_run.png
[live_puppet_lastrun]: ./images/console/live_puppet_lastrun.png
[live_puppet_main]: ./images/console/live_puppet_main.png
[live_puppet_results_collapsed]: ./images/console/live_puppet_results_collapsed.png
[live_puppet_results_expanded]: ./images/console/live_puppet_results_expanded.png
[live_puppet_runbutton]: ./images/console/live_puppet_runbutton.png
[live_puppet_status]: ./images/console/live_puppet_status.png
[live_puppet_unresponsive]: ./images/console/live_puppet_unresponsive.png


* * *

- [Next: Live Management: Advanced Tasks](./console_live_advanced.html)
