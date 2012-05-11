---
title: "PuppetDB 0.9 » System Requirements"
layout: pe2experimental
nav: puppetdb0.9.html
---

### Basic Requirements

* JDK 1.6 or above. The built-in Java support on recent versions of
  MacOS X works great, as do the OpenJDK packages available on nearly
  any linux distribution. Or if you like, you can download a recent
  JDK directly from Oracle.

* An existing Puppet infrastrucure. You must first setup a
  Puppetmaster installation, then setup PuppetDB, then configure the
  Puppetmaster to enable _storeconfigs_ and point it at your PuppetDB
  installation.

* A Puppetmaster running Puppet version 2.7.12 or better.

### Storage Requirements

There are 2 currently supported backends for PuppetDB storage:

* PuppetDB's embedded database
* PostgreSQL

The embedded database works well for small deployments (say, less than
100 hosts). It requires no additional daemons or setup, and as such is
very simple to get started with. It supports all PuppetDB features.

However, there is a cost: the embedded database requires a fair amount
of RAM to operate correctly. We'd recommend allocating 1G to PuppetDB
as a starting point. Additionally, the embedded database is somewhat
opaque; unlike more off-the-shelf database daemons, there isn't much
companion tooling for things like interactive SQL consoles,
performance analysis, or backups.

That said, if you have a small installation and enough RAM, then the
embedded database can work just fine.

For most "real" use, we recommend running an instance of
PostgreSQL. Simply install PostgreSQL using a module from the Puppet
Forge or your local package manager, create a new (empty) database for
PuppetDB, and verify that you can login via `psql` to this DB you
just created. Then just supply PuppetDB with the DB host, port, name,
and credentials you've just configured, and we'll take care of the
rest!

### Memory

As mentioned above, if you're using the embedded database we recommend
using 1G or more (to be on the safe side). If you are using an
external database, then a decent rule-of-thumb is to allocate 128M
base + 1M for each node in your infrastructure.

For more detailed RAM requirements, we recommend starting with the
above rule-of-thumb and experimenting. The PuppetDB Web Console shows
you real-time JVM memory usage; if you're constantly hovering around
the maximum memory allocation, then it would be prudent to increase
the memory allocation. If you rarely hit the maximum, then you could
likely lower the memory allocation without incident.

In a nutshell, PuppetDB's RAM usage depends on several factors: how
many nodes you have, how many resources you're managing with Puppet,
and how often those nodes check-in (your `runinterval`). 1000 nodes
that check in once a day will require much less memory than if they
check in every 30 minutes.

The good news is that if you under-provision memory for PuppetDB,
you'll see `OutOfMemoryError` exceptions. However, nothing terrible
should happen; you can simply restart PuppetDB with a larger memory
allocation and it'll pick up where it left off (any requests
successfully queued up in PuppetDB *will* get processed).

So essentially, there's not a slam-dunk RAM allocation that will work
for everyone. But we recommend starting with the rule-of-thumb and
dialing things up or down as necessary, and based on observation of
the running system.

### Large-scale requirements

For truly large installations, we recommend terminating SSL using
Apache or Nginx instead of within PuppetDB itself. This permits much
greater flexibility and control over bandwidth and clients.

