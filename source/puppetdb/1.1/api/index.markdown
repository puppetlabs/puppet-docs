---
title: "PuppetDB 1.1 » API » Overview"
layout: default
canonical: "/puppetdb/1/api/index.html"
---

Since PuppetDB collects lots of data from Puppet, it's an ideal platform for new tools and applications that use that data. You can use the HTTP API described in these pages to interact with PuppetDB's data.

Architecture
-----

PuppetDB's API uses a Command/Query Responsibility Separation (CQRS) pattern. This means:

* Data can be **queried** using a standard REST-style API.
* When **making changes** to data (facts, catalogs, etc), you must send an explicit command, instead of simply submitting data and allowing intent to be determined by the receiver. Commands do not use a REST-style interface.

Queries are processed immediately. Commands are processed asynchronously, although we've done our best to ensure that a command will eventually be executed once it has been accepted. Ordering of commands is also preserved: incoming commands are placed in a message queue which the command processing subsystem reads from in FIFO order.

The PuppetDB API also encompasses the wire formats that PuppetDB requires incoming data to use.

Queries
-----

PuppetDB 1.1 supports versions 1 and 2 of the query API. Version 1 is backwards-compatible with PuppetDB 1.0.x, but version 2 has significant new capabilities, including subqueries. 

PuppetDB's data can be queried with a REST API; the available endpoints are documented in the pages linked below. 

TODO capsule description of query syntax and links to deeper info inc. curl

### Query Endpoints

#### Experimental

These endpoints are not yet set in stone, and their behavior may change at any time without regard for normal versioning rules. We invite you to play with them, but you should be ready to adjust your application on your next upgrade. 

TODO LINK LIST

#### Version 2

Version 2 of the query API adds new endpoints, and introduces subqueries and regular expression operators for more efficient requests and better insight into your data. The following endpoints will continue to work for the foreseeable future. 

TODO LINK LIST

#### Version 1

Version 1 of the query API works with PuppetDB 1.1 and 1.0. It isn't deprecated, but we encourage you to use version 2 if you can.

In PuppetDB 1.0, you could access the version 1 endpoints without the `/v1/` prefix. This still works but **is now deprecated,** and we currently plan to remove support in PuppetDB 2.0. Please change your version 1 applications to use the `/v1/` prefix.

TODO LINK LIST

Commands
-----

PuppetDB supports a relatively small number of commands. The command submission API and the available commands are all described at the commands page:

* [Commands (all commands, all API versions)][commands]

Unlike the query API, these commands are generally only useful to Puppet itself, and all format conversion and command sending is handled by the [PuppetDB terminus plugins][terminus] on your puppet master.

The "replace" commands all require data in one of the wire formats described below.

Wire Formats
-----

PuppetDB requires its "replace" commands to contain payload data in one of the following formats. The format required by each command is listed in that command's description. 

* [Facts wire format](./wire_format/facts_format.html)
* [Catalog wire format](./wire_format/catalog_format.html)
* [Report wire format (experimental)](./wire_format/report_format.html)
