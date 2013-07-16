---
layout: default
title: "PE 2.7  » Console » Viewing Reports"
subtitle: "Viewing Reports and Inventory Data"
canonical: "/pe/latest/console_reports.html"
---

When nodes fetch their configurations from the puppet master, they send back inventory data and a report of their run. These end up in the console, where you can view them in that node's page. 

Reading Reports
-----

### Graphs

Each node page has a pair of graphs: a histogram showing the number of runs per day and the results of those runs, and a line chart tracking how long each run took.

![The pair of graphs on a node page][reports_graphs]

The daily run status histogram is broken down with the same colors that indicate run status in the console's sidebar: red for failed runs, orange for pending runs (where a change would have been made, but the resource to be changed was marked as no-op), blue for successful runs where changes were made, and green for successful runs that did nothing. You can hover over a block of color for a tooltip showing how many runs of that type occurred:

![Tooltip showing two changed runs][reports_runcount]

**Note:** Run status histograms also appear on group pages, class pages, and run status pages. 

The run-time chart graphs how long each of the last 30 Puppet runs took to complete. A longer run usually means changes were made, but could also indicate heavy server load or some other circumstance. You can hover over a point on the line for a tooltip showing the number of seconds it represents:

![Tooltip showing how long a run took][reports_point]

### Normal Reports

Each node page has a short list of recent reports, with a "More" button at the bottom for viewing older reports:

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

The facts you see in the inventory can be useful when [filtering nodes in the live management page](./console_live.html#advanced-search).

### Searching by Fact

Use the "inventory search" page to find a list of nodes with a certain fact value.

![The inventory search page][reports_inventorysearch]

![Results of a search][reports_searchresults]

You can add more facts to further filter the search results , and you can change the comparison criteria for each one.

[reports_eventstab]: ./images/console/reports_eventstab.png
[reports_graphs]: ./images/console/reports_graphs.png
[reports_inventory_location]: ./images/console/reports_inventory_location.png
[reports_inventory]: ./images/console/reports_inventory.png
[reports_inventorysearch]: ./images/console/reports_inventorysearch.png
[reports_logtab]: ./images/console/reports_logtab.png
[reports_metricstab]: ./images/console/reports_metricstab.png
[reports_point]: ./images/console/reports_point.png
[reports_recent]: ./images/console/reports_recent.png
[reports_runcount]: ./images/console/reports_runcount.png
[reports_searchresults]: ./images/console/reports_searchresults.png


* * * 

- [Next: Managing Users](./console_auth.html) 
