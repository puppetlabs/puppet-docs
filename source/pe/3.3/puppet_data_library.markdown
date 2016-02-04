---
layout: default
title: "PE 3.3 » Puppet » Puppet Data Library"
subtitle: "The Puppet Data Library"
canonical: "/pe/latest/puppet_data_library.html"
---


The Puppet Data Library (PDL) consists of two elements:

* The large amount of data Puppet automatically collects about your infrastructure.
* The formats and APIs Puppet uses to expose that data.

Sysadmins can access information from the PDL with their choice of tools, including familiar scripting languages like Ruby, Perl, and Python. This data can be used to build custom reports, add to existing data sets, or automate repetitive tasks.

Right now, the Puppet Data Library consists of three different data services:

PuppetDB
-----

PuppetDB is a built-in part of PE 3.0 and later.

PuppetDB stores up-to-date copies of every node's **facts,** **resource catalogs,** and **run reports** as part of each Puppet run. External tools can easily query and search all of this data over a stable, versioned HTTP query API. This is a more full-featured replacement for Puppet's older Inventory Service interface, and it enables entirely new functionality like class, resource, and event searches.

* [See the documentation for PuppetDB's query API here.][puppetdb_api]
* Since PuppetDB receives all facts for all nodes, you can extend its data with [custom facts](/guides/custom_facts.html) on your puppet master server.

[puppetdb_api]: /puppetdb/1.6/api/index.html

> **EXAMPLE:**  Using the old Puppet Inventory Service, a customer automated the validation and reporting of their servers' warranty status.  Their automation regularly retrieved the serial numbers of all servers in the data center, then checked them against the hardware vendor's warranty database using the vendor's public API to determine the warranty status for each.
>
> Using PuppetDB's improvements over the inventory API, it would also be possible to correlate serial number data with what the machines were actually being used for, by getting lists of the Puppet classes being applied to each machine.


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
