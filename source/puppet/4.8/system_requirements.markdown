---
layout: default
title: "Puppet system requirements"
canonical: "/puppet/latest/system_requirements.html"
---

> To install Puppet, first [view the pre-install tasks](./install_pre.html).

## Hardware

The Puppet agent service has no particular hardware requirements and can run on nearly anything.

However, the Puppet master service is fairly resource intensive, and should be installed on a robust dedicated server.

* At a minimum, your Puppet master server should have two processor cores and at least 1 GB of RAM.
* To comfortably serve at least 1,000 nodes, it should have 2-4 processor cores and at least 4 GB of RAM.

The demands on the Puppet master vary widely between deployments. The total needs are affected by the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity of the manifests and modules in use.

## Puppet agent and operating system support life cycles

In PE 2015.2 and open source Puppet 4.0 and onward, we use the same Puppet agent packages in our open source and Puppet Enterprise ecosystems. Because of this, we've set guidelines for how we manage Puppet agent life cycles.

* Community-supported operating systems:

  On community-supported operating systems, we support Puppet agent for the operating system's life cycle. Essentially, Puppet stops publishing packages for a platform 30 days after its end-of-life (EOL) date. For example, Fedora 20 reached its EOL on June 23, 2015. This means on or around July 23, Puppet stopped providing fixes, updates, or support for either the Puppet Enterprise or open source versions of that agent package.

* Enterprise-class operating systems:

  On enterprise-class operating systems, we support Puppet agent for _at least_ the operating system's life cycle. In Puppet Enterprise, Puppet continues to support certain enterprise-class agent platforms after their EOL, though we do so solely at our own discretion.

## Platforms with packages

Puppet and all of its prerequisites run on the following platforms, and Puppet provides official packages in [Puppet Collections](./puppet_collections.html).

### Red Hat Enterprise Linux (and derivatives)

We publish and test official [`puppet-agent`](/puppet/latest/about_agent.html) packages for the following versions of Red Hat Enterprise Linux (RHEL):

* Enterprise Linux 7
* Enterprise Linux 6
* Enterprise Linux 5

This information applies to RHEL itself, as well as any distributions that maintain binary compatibility with it, including but not limited to CentOS, Scientific Linux, and Oracle Linux.

### Debian and Ubuntu

We publish and test official `puppet-agent` packages for the following versions of Debian:

-   Debian 8 "Jessie" (current stable release)
-   Debian 7 "Wheezy" (previous stable release)

We also publish and test official `puppet-agent` packages for the following versions of Ubuntu:

-   Ubuntu 16.04 LTS "Xenial Xerus"
-   Ubuntu 15.10 "Wily Werewolf"
-   Ubuntu 14.04 LTS "Trusty Tahr"
-   Ubuntu 12.04 LTS "Precise Pangolin"

### Fedora

We publish and test official [`puppet-agent`](/puppet/latest/about_agent.html) packages for the following versions of Fedora:

* Fedora 24
* Fedora 23

### Windows

We publish and test official [`puppet-agent`](/puppet/latest/about_agent.html) packages for the following versions of Windows:

* Windows Server 2012 R2
* Windows Server 2008 R2
* Windows 10 Enterprise

We also publish, but do not automatically test `puppet-agent` packages for the following versions of Windows:

* Windows Server 2016 
* Windows Server 2012 
* Windows Server 2008
* Windows 8.1
* Windows 7, 8, and 10
* Windows Vista (**Note:** Service Pack 2 end of life date is April 11,2017)

### OS X

We publish and test official [`puppet-agent`](/puppet/latest/about_agent.html) packages for the following OS X versions:

* 10.11 El Capitan
* 10.10 Yosemite

We also publish, but do not automatically test `puppet-agent` packages for the following versions of macOS:

* 10.12 Sierra

## Platforms without packages

Puppet and its prerequisites are known to run on the following platforms, but we do not provide official open source packages or perform automated testing. For platforms supported in Puppet Enterprise, see its [System Requirements]({{pe}}/sys_req_os.html).

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

>*Note:* While installing `puppet-agent` on Solaris, you may see an error like the following:
>
>  ERROR: attribute verification of </lib/svc/method/puppet.
>    pathname does not exist
>
>This is because you must have Read-Write access on the filesystem to install `puppet-agent`.

## Basic requirements

If you're installing Puppet via the official packages, you won't need to worry about these prerequisites; your system's package manager handles all of them. These are only listed for those running Puppet from source or on unsupported systems.

Puppet has the following prerequisites:

### Ruby

Use one of the following versions of MRI (standard) Ruby:

* 2.1.x
* 2.0.x
* 1.9.3

> **Note:** We currently only test and package with 2.1.x versions of Ruby, therefore we recommend you only use this version. Other interpreters and versions of Ruby are not covered by our tests.

### Mandatory libraries

* [Facter](http://www.puppetlabs.com/puppet/related-projects/facter/) 2.4.3 or later
* [Hiera]({{hiera}}/) 2.0.0 or later
* The `json` gem (any modern version).
* The [`rgen` gem](http://ruby-gen.org/downloads) version 0.6.6 or later is now required because Puppet [`parser = future` is enabled by default](./lang_updating_manifests.html).

### Optional libraries

* The `msgpack` gem is required if you are using [msgpack serialization](./experiments_msgpack.html).
