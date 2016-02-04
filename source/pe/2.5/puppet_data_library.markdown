---
layout: default
title: "PE 2.5 » Puppet » Puppet Data Library"
subtitle: "The Puppet Data Library"
canonical: "/pe/latest/puppet_data_library.html"
---


The Puppet Data Library (PDL) consists of two elements:

* The large amount of data Puppet automatically collects about your infrastructure.
* The formats and APIs Puppet uses to expose that data.

Sysadmins can access information from the PDL with their choice of tools, including familiar scripting languages like Ruby, Perl, and Python. Use this data to build custom reports, add to existing data sets, or automate repetitive tasks.

Right now, the Puppet Data Library consists of three different data services:

Puppet Inventory Service
-----

The Puppet Inventory Service provides a detailed inventory of the hardware and software on nodes managed by Puppet.

* Using a simple RESTful API, you can query the inventory service for a node's MAC address, operating system version, DNS configuration, etc. The query results are returned as JSON.
* Inventory information consists of the facts reported by each node when it requests configurations. By installing [custom facts](/guides/custom_facts.html) on your puppet master server, you can extend the inventory service to contain any kind of data that can possibly be extracted from your nodes.

> **EXAMPLE:**  Using the Puppet Inventory Service, a customer automated the validation and reporting of their servers' warranty status.  Their automation used the Puppet Inventory Service to query all servers in the data center on a regular basis and retrieve their serial numbers.  These serial numbers are then checked against the server hardware vendor's warranty database using the vendor's public API to determine the warranty status for each.

[Learn more about the Puppet Inventory Service here](/guides/inventory_service.html).

Puppet Run Report Service
-----

The Puppet Run Report Service provides push access to the reports that every node submits after each Puppet run. By writing a custom report processor, you can divert these reports to any custom service, which can use them to determine whether a Puppet run was successful, or dig deeply into the specific changes for each and every resource under management for every node.

You can also write out-of-band report processors that consume the YAML files written to disk by the puppet master's default report handler.

[Learn more about the Puppet Run Report Service here](/guides/reporting.html).

Puppet Resource Dependency Graph
-----

The Puppet Resource Dependency Graph provides a complete, mathematical graph of the dependencies between resources under management by Puppet.  These graphs, which are stored in .dot format, can be used with any commercial or open source visualization tool to uncover hidden linkages and help understand how your resources interconnect to provide working services.

> EXAMPLE:  Using the Puppet Resource Dependency Graph and Gephi, a visualization tool, a customer identified unknown dependencies within a complicated set of configuration modules.  They used this knowledge to re-write parts of the modules to get better performance.

[Learn more about the Puppet Resource Dependency Graph here](/puppet/latest/reference/configuration.html#graph)


* * *

- [Next: Puppet References](./puppet_references.html)
