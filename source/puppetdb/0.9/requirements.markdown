---
title: "PuppetDB 0.9 » System Requirements"
layout: default
canonical: "/puppetdb/latest/index.html"
---

[configure_heap]: ./configure.html#configuring-the-java-heap-size
[tuning]: ./maintain_and_tune.html#monitor-the-performance-console

Once installed and configured, PuppetDB will be a critical component of your Puppet deployment, and agent nodes will be unable to request catalogs if it becomes unavailable. In general, it should be run on a robust and reliable server, like any critical service. 


Basic Requirements
-----

PuppetDB will run on any **\*nix system** with **JDK 1.6** or higher. This includes:

* Recent MacOS X versions using built-in Java support
* Nearly any Linux distribution using its own OpenJDK packages
* Nearly any \*nix system running a recent Oracle-provided JDK


Easy Install Requirements
-----

Puppet Labs provides PuppetDB packages for several major Linux distributions; these packages automate the complex process of setting up SSL, and make it easier to keep PuppetDB up to date.

To take advantage of this, you should install PuppetDB on a server running one of the following operating systems:

* Red Hat Enterprise Linux 5 or 6
* Any Linux distro derived from RHEL 5 or 6, including (but not limited to) CentOS, Scientific Linux, and Ascendos
* Debian Squeeze, Lenny, Wheezy, or Sid
* Ubuntu 12.04 LTS, 10.04 LTS, 8.04 LTS, 11.10, or 11.04
* Fedora 15 or 16

Puppet Requirements
-----

Any puppet master you wish to connect to PuppetDB must be running **Puppet version 2.7.12** or higher. You will also need to install extra components on your puppet master(s) before they can speak to PuppetDB. 

After installing PuppetDB, [see here to configure a puppet master to use it.](./connect_puppet.html)


Database Recommendations
-----

Deployments with more than 100 nodes should configure a PostgreSQL database for PuppetDB. Smaller deployments may also wish to use the PostgreSQL backend.

There are two available backends for PuppetDB storage:

* PuppetDB's embedded database
* PostgreSQL

The embedded database works well for small deployments (up to approximately 100 hosts). It requires no additional daemons or setup, and as such is very simple to get started with. It supports all PuppetDB features.

However, there is a cost: the embedded database requires a fair amount of RAM to operate correctly. We'd recommend [allocating 1GB to PuppetDB][configure_heap] as a starting point. Additionally, the embedded database is somewhat opaque; unlike more off-the-shelf database daemons, there isn't much companion tooling for things like interactive SQL consoles, performance analysis, or backups.

That said, if you have a small installation and enough RAM, then the embedded database will work just fine.

For most "real" use, we recommend running an instance of PostgreSQL. Simply install PostgreSQL using a module from the Puppet Forge or your local package manager, create a new (empty) database for PuppetDB, and verify that you can login via `psql` to this DB you just created. Then just supply PuppetDB with the DB host, port, name, and credentials you've just configured, and we'll take care of the rest!

Memory Recommendations
-----

PuppetDB runs on the JVM, and the maximum amount of memory it is allowed to use is set when the service is started. The optimal value of this maximum will vary depending on the nature of your site.

### For Embedded DB Users

If you're using the embedded database, we recommend using 1GB or more (to be on the safe side).

### For PostgreSQL users

If you are using an external database, then a decent rule-of-thumb is to allocate 128MB of memory as a base, plus 1MB for each node in your infrastructure. To get a more exact measure of the required RAM, you should start with the rule-of-thumb, then [watch the performance console and experiment][tuning].


Large-scale Recommendations
-----

For truly large installations, we recommend terminating SSL using Apache or Nginx instead of within PuppetDB itself. This permits much greater flexibility and control over bandwidth and clients. Instructions for configuring this are currently beyond the scope of this manual.

