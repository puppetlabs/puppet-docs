---
layout: default
title: "Puppet system requirements"
---

Puppet's system requirements can vary depending on your deployment type and size. Before installing, ensure your hardware and operating systems are compatible with the `puppet-agent` packages we publish.

> To install Puppet, first [view the pre-install tasks](./install_pre.html).

## Hardware

The Puppet agent service has no particular hardware requirements and can run on nearly anything.

However, the Puppet master service is fairly resource intensive, and should be installed on a robust dedicated server.

* At a minimum, your Puppet master server should have two processor cores and at least 1 GB of RAM.
* To comfortably serve at least 1,000 nodes, it should have 2-4 processor cores and at least 4 GB of RAM.

The demands on the Puppet master vary widely between deployments. The total needs are affected by the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity of the manifests and modules in use.

{% include agent_lifecycle.md %}

## Platforms with packages

We publish and test official `puppet-agent` packages for the following platforms. Less common and sometimes brand new platforms may not be automatically tested, but packages are still available for them.

| Operating system                           | Tested                                         | Untested        |
|--------------------------------------------|------------------------------------------------|-----------------|
| Red Hat Enterprise Linux (and derivatives) | 5, 6, 7                                        |                 |
| SUSE Linux Enterprise Server               | 11, 12                                         |                 |
| Debian                                     | Wheezy (7), Jessie (8)                         |                 |
| Ubuntu                                     | 12.04, 14.04, 16.04                            |                 |
| Fedora                                     | 23, 24, 25                                     |                 |
| Microsoft Windows (Server OS)              | 2008R2, 2012R2, 2016                           | 2008, 2012      |
| Microsoft Windows (Consumer OS)            | 10 Enterprise                                  | Vista, 7, 8, 10 |
| macOS                                      | 10.10 Yosemite, 10.11 El Capitan, 10.12 Sierra |                 |

## Platforms without packages

Puppet and its prerequisites are known to run on the following platforms, but we do not provide official open source packages or perform automated testing. For platforms supported in Puppet Enterprise, see its [system requirements]({{pe}}/sys_req_os.html).

### Other Linux

* Gentoo Linux
* Mandriva Corporate Server 4
* Arch Linux

### Other Unix

* Oracle Solaris, version 10 and higher (Puppet performs limited automated testing on Solaris 11)
* AIX, version 5.3 and higher
* FreeBSD 4.7 and later
* OpenBSD 4.1 and later
* HP-UX

## Prerequisites

If you're installing Puppet via the official packages, you don't need to worry about these prerequisites; your system's package manager handles all of them. These are only listed for those running Puppet from source or on unsupported systems.

Puppet has the following prerequisites:

### Ruby

> **Note:** We currently only test and package with 2.1.x versions of Ruby, therefore we recommend you only use this version. Other interpreters and versions of Ruby are not covered by our tests.

### Mandatory libraries

* [Facter](http://www.puppetlabs.com/puppet/related-projects/facter/) 2.4.3 or later
* [Hiera]({{hiera}}/) 2.0.0 or later
* The `json` gem (any modern version)
* The [`rgen` gem](http://ruby-gen.org/downloads) version 0.6.6 or later is now required because Puppet [`parser = future` is enabled by default](./lang_updating_manifests.html)

### Optional libraries

* The `msgpack` gem is required if you are using [msgpack serialization](./experiments_msgpack.html).
