---
layout: default
title: "PE 3.1 » Console » Inventory Search"
subtitle: "Searching for Nodes by Fact"
canonical: "/pe/latest/console_inventory_search.html"
---

The **Inventory Search** section of the Puppet Enterprise console lets you search Puppet's inventory of node data. This search utility uses Puppet Enterprise's central data storage layer, PuppetDB.

## Using the Inventory Search

Use console's main navigation to reach the "Inventory Search" section.

![The inventory search page][inventory_zoom]

This field allows you to enter a **fact name,** a **value,** and a **comparison operator.** After you have searched for one fact, you may narrow down the search by adding additional facts.

![Results of a search][inventory_search]

The search results page will show a list of nodes, as well as a summary of their recent Puppet runs. You can click nodes in the list to browse to their detail pages.

To choose facts to search for, you should [view the inventory data][inventory] for a node that resembles the nodes you are searching for.

[inventory]: ./console_reports.html#viewing-inventory-data
[inventory_search]: ./images/console/inventory_search.png
[inventory_zoom]: ./images/console/inventory_zoom.png

* * *

- [Next: Configuring & Tuning the Console](./console_config.html)
