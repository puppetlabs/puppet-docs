---
layout: default
title: "PE 3.7 » Console » Viewing Reports"
subtitle: "Viewing Reports and Inventory Data"
canonical: "/pe/latest/console_reports.html"
---

When nodes fetch their configurations from the Puppet master, they send back inventory data and a report of their run. These end up in the console, where you can view them in that node's detail page.


Node States
-----

Depending on how its last Puppet run went, every node is in one of six states. Each state is indicated by a specific color in graphs and the node state summary, and by an icon beside the report or the node name in a report list or node list view.

- <span style="font-family: Helvetica, Arial, Verdana; color: #818285;">Unresponsive:</span> The node hasn't reported to the Puppet master recently; something may be wrong. The cutoff for considering a node unresponsive defaults to one hour, and can be configured in `settings.yml` with the `no_longer_reporting_cutoff` setting. Represented by dark grey text. This state has no icon; the node retains whatever icon the last report used.
- <span style="font-family: Helvetica, Arial, Verdana; color: #D93129;">Failed:</span> During its last Puppet run, this node encountered some error from which it couldn't recover. Something is probably wrong, and investigation is recommended. Represented by red text or the ![failed][failed] failed icon.
- <span style="font-family: Helvetica, Arial, Verdana; color: #EFA92D;">No-op:</span> During its last Puppet run, this node _would_ have made changes, but since it was either running in no-op mode or found a discrepancy in a resource whose `noop` metaparameter was set to `true`, it _simulated_ the changes instead of enforcing them. See the node's last report for more details. Represented by orange text or the ![pending][pending] pending icon.
- <span style="font-family: Helvetica, Arial, Verdana; color: #78B7D2;">Changed:</span> This node's last Puppet run was successful, and changes were made to bring the node into compliance. Represented by blue text or the ![changed][changed] changed icon.
- <span style="font-family: Helvetica, Arial, Verdana; color: #78C145;">Unchanged:</span> This node's last Puppet run was successful, and it was fully compliant; no changes were necessary. Represented by green text or the ![unchanged][unchanged] unchanged icon.
- <span style="font-family: Helvetica, Arial, Verdana; color: #818285;">Unreported:</span> Although Dashboard is aware of this node's existence, it has never submitted a Puppet report. It may be a newly-commissioned node, it may have never come online, or its copy of Puppet may not be configured correctly. Represented by light grey text or the ![error][error] error icon.

[changed]: ./images/console/icon_changed.png
[error]: ./images/console/icon_error.png
[failed]: ./images/console/icon_failed.png
[pending]: ./images/console/icon_pending.png
[unchanged]: ./images/console/icon_unchanged.png

## Background Tasks

The console handles Puppet run reports asynchronously using several background worker processes. The background tasks indicator in the sidebar lets you monitor the health of those processes. The number of tasks increases as new reports come in, and decreases as the processes finish processing them. If the number of tasks increases rapidly and won't go down, something is wrong with the worker processes and you may need to [use the advanced tasks tab](./console_navigating_live_mgmt.html#the-advanced-tasks-tab) to restart the `pe-puppet-dashboard-workers` service on the console node. A green check-mark with the text "All systems go" means the processes have caught up with all available reports.

Reading Reports
-----

### Graphs

Each **node detail page** has a pair of graphs: a histogram showing the number of runs per day and the results of those runs, and a line chart tracking how long each run took.

![The pair of graphs on a node page][reports_graphs]

The daily run status histogram uses the following colors:

* red for failed runs
* orange for pending runs (where a change would have been made, but the resource to be changed was marked as no-op)
* blue for successful runs where changes were made
* green for successful runs that did nothing

The run-time chart graphs how long each of the last 30 Puppet runs took to complete. A longer run usually means changes were made, but could also indicate heavy server load or some other circumstance.

### Reports

Each node page has a short list of recent reports, with a __More__ button at the bottom for viewing older reports:

![The list of recent reports][reports_recent]

Each report represents a single Puppet run. Clicking a report will take you to a tabbed view that splits the report up into **metrics, log,** and **events.**

**Metrics** is a rough summary of what happened during the run, with resource totals and the time spent retrieving the configuration and acting on each resource type.

![The metrics tab of a report][reports_metricstab]

**Log** is a table of all the messages logged during the run.

![The log tab of a report][reports_logtab]

**Events** is a list of the resources the run managed, sorted by whether any changes were made. You can click on a changed resource to see which attributes were modified.

![The events tab of a report][reports_eventstab]


Viewing Inventory Data
-----

Each node's page has a section called inventory. This section contains all of the fact values reported by the node on its most recent run.

![The location of the inventory section][reports_inventory_location]

![Facts in the inventory][reports_inventory]

Facts include things like the operating system (`operatingsystem`), the amount of memory (`memorytotal`), and the primary IP address (`ipaddress`). You can also [add arbitrary custom facts][customfacts] to your Puppet modules, and they too will show up in the inventory.

[customfacts]: /guides/custom_facts.html

The facts you see in the inventory can be useful when [filtering nodes in the live management page](./console_navigating_live_mgmt.html#advanced-search).

Exporting Data
-----

You can export the inventory and report tables to a CSV file using the __Export as CSV__ link at the top right of the tables.

[reports_eventstab]: ./images/console/reports_eventstab.png
[reports_graphs]: ./images/console/reports_graphs.png
[reports_inventory_location]: ./images/console/reports_inventory_location.png
[reports_inventory]: ./images/console/reports_inventory.png
[reports_logtab]: ./images/console/reports_logtab.png
[reports_metricstab]: ./images/console/reports_metricstab.png
[reports_recent]: ./images/console/reports_recent.png


* * *

- [Next: Inventory Search](./console_inventory_search.html)
