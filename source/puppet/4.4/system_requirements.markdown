---
layout: default
title: "Puppet 4.4 System Requirements"
canonical: "/puppet/latest/system_requirements.html"
---

[pe-requirements]: {{pe}}/install_system_requirements.html#supported-operating-systems
[preinstall-network]: ./install_pre.html#check-your-network-configuration

Puppet can run on many operating systems and hardware configurations. Before installing Puppet, first [view the pre-install tasks](./install_pre.html).

> **Note:** For [Puppet Enterprise's](/pe/) supported platforms, see its [system requirements][pe-requirements].

## Puppet agent

The Puppet agent service is lightweight enough to run on nearly any system capable of running a Ruby interpreter. To be managed by a Puppet master, the agent must be able to communicate with the master. See the [pre-installation instructions][preinstall-network] for details about the required DNS and port configuration for agents.

For simple installation, Puppet builds and packages the open source agent and its prerequisites for 32-bit (i386) and 64-bit (x86_64 and amd64) versions of many Linux distributions, OS X, and Windows.

-   For more information about the `puppet-agent` package, see [its documentation](./about_agent.html).
-   For a list of platforms and architectures with official Puppet packages, see the [Puppet Collections documentation](./puppet_collections.html).

## Puppet master and Puppet Server

The demands on the Puppet master vary widely between deployments. The total needs are affected by the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity of the manifests and modules in use.

All Puppet masters must be available to agents over the network. See the [pre-installation instructions][preinstall-network] for details about the required DNS and port configuration for masters.

The Puppet master service built into the `puppet-agent` package is a resource-intensive service that performs best on a robust dedicated server. To manage more than 10 nodes, the master server should have at least two processor cores and 1 GB of RAM. To manage more than 1,000 nodes, the server should have at least 4 processor cores and 4 GB of RAM.

To scale Puppet beyond more than a few hundred nodes, however, we recommend using [Puppet Server]({{puppetserver}}) instead of the built-in Puppet master. Puppet Server is a much more efficient implementation of the Puppet master service. See [its documentation]({{puppetserver}}/install_from_packages.html#system-requirements) for system requirements and installation instructions.

## Puppet agent and operating system support life cycles

In PE 2015.2 and open source Puppet 4.0 and onward, we use the same Puppet agent packages in our open source and Puppet Enterprise ecosystems. Because of this, we've set guidelines for how we manage Puppet agent life cycles.

* Community-supported operating systems:

  On community-supported operating systems, we support Puppet agent for the operating system's life cycle. Essentially, Puppet stops publishing packages for a platform 30 days after its end-of-life (EOL) date. For example, Fedora 20 reached its EOL on June 23, 2015. This means on or around July 23, Puppet stopped providing fixes, updates, or support for either the Puppet Enterprise or open source versions of that agent package.

* Enterprise-class operating systems:

  On enterprise-class operating systems, we support Puppet agent for _at least_ the operating system's life cycle. In Puppet Enterprise, Puppet continues to support certain enterprise-class agent platforms after their EOL, though we do so solely at our own discretion.

## Platforms without packages

Puppet and its prerequisites can also run on the following platforms, but we do not provide official open-source packages or perform automated testing of open source Puppet for them.

### Linux

-   SUSE Linux Enterprise Server, version 11 and higher
-   Gentoo Linux
-   Mandriva Corporate Server 4
-   Arch Linux

### Unix

-   Oracle Solaris, version 10 and higher (Puppet performs limited automated testing on Solaris 11)
-   AIX, version 5.3 and higher
-   FreeBSD, version 4.7 and later
-   OpenBSD, version 4.1 and later
-   HP-UX

> **Note:** For platforms supported in Puppet Enterprise, see its [System Requirements][pe-requirements].

Puppet also makes the `puppet-agent` packaging process available as an open source project. For information about building the package yourself, see the [`puppetlabs/puppet-agent` repository on GitHub](https://github.com/puppetlabs/puppet-agent).

### Prerequisites

The official `puppet-agent` package either includes or instructs your operating system's package manager to install all prerequisites, including its own Ruby interpreter. When running Puppet from source, building your own `puppet-agent` package, or otherwise running Puppet binaries without installing the official package, Puppet services have the following prerequisites:

#### Ruby

Use one of the following versions of MRI (standard) Ruby:

-   2.1.x
-   2.0.x
-   1.9.3

> **Note:** We package 2.1.x versions of MRI Ruby in `puppet-agent` and recommend that you use only this version. We perform little or no testing of Puppet with other interpreters and versions of Ruby.

#### Mandatory libraries

-   [Facter]({{facter}}/) 2.4.3 or later. Facter 3 is recommended.
-   [Hiera]({{hiera}}/) 2.0.0 or later.
-   The `json` gem (any modern version; included with Ruby).
-   The [`rgen` gem](http://ruby-gen.org/downloads) version 0.6.6 or later. If you're upgrading from Puppet 3, note that the "future parser" in Puppet 3 (which introduced the `rgen` dependency) is the default parser in Puppet 4. [Update your manifests appropriately.](./lang_updating_manifests.html)

#### Optional libraries

-   The `msgpack` gem is required only if you are using [experimental msgpack serialization](./experiments_msgpack.html).
