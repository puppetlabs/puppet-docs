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

We publish and test official `puppet-agent` packages for the following platforms. Less common, and brand new platforms may not be automatically tested, but packages are still available for them.

<table>
  <tr>
    <th>Operating system</th>
    <th>Tested</th>
    <th>Untested</th>
  </tr>
  <tr>
    <td>Red Hat Enterprise Linux (and derivatives)</td>
    <td>5, 6, 7</td>
    <td></td>
  </tr>
  <tr>
    <td>SUSE Linux Enterprise Server</td>
    <td>11,12</td>
    <td></td>
  </tr>
  <tr>
    <td>Debian</td>
    <td>Wheezy (7), Jessie (8)</td>
    <td></td>
  </tr>
  <tr>
    <td>Ubuntu</td>
    <td>12.04, 14.04, 16.04</td>
    <td></td>
  </tr>
  <tr>
    <td>Fedora</td>
    <td>23, 24, 25</td>
    <td></td>
  </tr>
  <tr>
    <td>Microsoft Windows (Server OS)</td>
    <td>2008R2, 2012R2, 2016</td>
    <td>2008, 2012</td>
  </tr>
  <tr>
    <td>Microsoft Windows (Consumer OS)</td>
    <td>10 Enterprise</td>
    <td>Vista, 7, 8, 10</td>
  </tr>
  <tr>
    <td>macOS</td>
    <td>10.10 Yosemite, 10.11 El Capitan, 10.12 Sierra</td>
    <td></td>
</table>


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
