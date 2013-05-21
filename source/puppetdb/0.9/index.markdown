---
title: "PuppetDB 0.9 » Overview"
layout: default
canonical: "/puppetdb/latest/index.html"
---


Welcome to the beta release of PuppetDB!

PuppetDB is a Puppet data warehouse; it manages storage and retrieval
of all platform-generated data. Currently, it stores catalogs and facts; in future releases, it will expand to include more data, like reports. 

So far, we've implemented the following features:

* Fact storage
* Full catalog storage
  * Containment edges
  * Dependency edges
  * Catalog metadata
  * Full resource list with all parameters
  * Node-level tags
  * Node-level classes
* REST Fact retrieval
  * all facts for a given node
* REST Resource querying
  * super-set of storeconfigs query API
  * boolean operators
  * can query for resources spanning multiple nodes and types
* Storeconfigs terminus
  * drop-in replacement of stock storeconfigs code
  * export resources
  * collect resources
  * fully asynchronous operation (compiles aren't slowed down)
  * _much_ faster storage, in _much_ less space
* Inventory service API compatibility
  * query nodes by their fact values
  * drop-in replacement for Puppet Dashboard and PE console inventory service

## Components

PuppetDB consists of several, cooperating components:

### REST-based command processor

PuppetDB uses a CQRS pattern for making changes to its domain objects
(facts, catalogs, etc). Instead of simply submitting data to PuppetDB
and having it figure out the intent, the intent needs to be explicitly
codified as part of the operation. This is known as a "command"
(e.g. "replace the current facts for node X").

Commands are processed asynchronously; however, do our best
to ensure that once a command has been accepted, it will eventually be
executed. Ordering is also preserved. To do this, all incoming
commands are placed in a message queue which the command processing
subsystem reads from in FIFO order.

Submission of commands is done via HTTP. See the API spec in the navigation sidebar for complete documentation. There is a specific required wire format for commands, and
failure to conform to that format will result in an HTTP error.

### Storage subsystem

Currently, PuppetDB's data is stored in a relational database. There
are two supported databases:

* An embedded HSQLDB. This does not require a separate database
  service, and is thus trivial to setup. This database is intended for
  proof-of-concept use; we do not recommend it for long-term
  production use.
* PostgreSQL

There is no MySQL support, as MySQL lacks support for recursive queries
(critical for future graph traversal features).

### REST-based retrieval

Read-only requests (resource queries, fact queries, etc.) are done
using PuppetDB's REST APIs. Each REST endpoint is documented in the API spec; see the navigation sidebar.

### Remote REPL

For debugging purposes, you can open up a remote clojure
[REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
and use it to modify the behavior of PuppetDB, live.

Vim support would be a welcome addition; please submit patches!

### Puppet terminuses

There are a set of Puppet terminuses that acts as a drop-in replacement for
stock storeconfigs functionality. By asynchronously storing catalogs
in PuppetDB, and by leveraging PuppetDB's fast querying, compilation
times are much reduced compared to traditional storeconfigs.
