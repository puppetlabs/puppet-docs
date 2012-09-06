---
title: "PuppetDB 1 » Overview"
layout: default
---

[exported]: /puppet/2.7/reference/lang_exported.html
[inventory]: /guides/inventory_service.html
[apply]: ./connect_puppet_apply.html
[connect]: ./connect_puppet_master.html
[install_advanced]: ./install_from_source.html
[install]: ./install.html
[scaling]: ./scaling_recommendations.html

PuppetDB is a companion service for Puppet. It can be connected to a puppet master (or to standalone nodes running puppet apply) and enables advanced Puppet features

[exported resources][exported]






System Requirements
-----

### \*nix Server with JDK 1.6+

#### Easy Install: RHEL, CentOS, Debian, Ubuntu, or Fedora

Puppet Labs provides packages for PuppetDB, which greatly simplify configuration of its SSL certificates and init scripts. These packages are available for the following operating systems:

* Red Hat Enterprise Linux 5 or 6 or any distro derived from it (including CentOS)
* Debian Squeeze, Lenny, Wheezy, or Sid
* Ubuntu 12.04 LTS, 10.04 LTS, 8.04 LTS, 11.10, or 11.04
* Fedora 15 or 16

[See here for installation instructions.][install]

#### Advanced Install: Any Unix-like OS

If you're willing to do some manual configuration, PuppetDB can run on any Unix-like OS with JDK 1.6 or higher, including:

* Recent MacOS X versions (using built-in Java support)
* Nearly any Linux distribution (using vendor's OpenJDK packages)
* Nearly any \*nix system running a recent Oracle-provided JDK

[See here for advanced installation instructions.][install_advanced]

### Puppet 2.7.12

Your site's puppet masters must be running Puppet 2.7.12 or later. [You will need to connect your puppet masters to PuppetDB after installing it][connect]. If you wish to use PuppetDB with [standalone nodes running puppet apply][apply], every node must be running 2.7.12 or later.

### Robust Hardware

PuppetDB will be a critical component of your Puppet deployment, and should be run on a robust and reliable server. 

However, it can do a lot with fairly modest hardware: in benchmarks using real-world catalogs from a customer, a single 2012 laptop (16 GB of RAM, consumer-grade SSD, and quad-core processor) running PuppetDB and PostgreSQL was able to keep up with sustained input from 8,000 simulated Puppet nodes checking in every 30 minutes. Powerful server-grade hardware will perform even better.

The actual requirements will vary wildly depending on your site's size and characteristics. At smallish sites, you may even be able to run PuppetDB on your puppet master server.

For more on fitting PuppetDB to your site, [see "Scaling Recommendations."][scaling]