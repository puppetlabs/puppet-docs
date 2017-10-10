---
layout: default
title: "Minor Upgrades: Within 4.x (Puppet Collection 1 / PC1)"
canonical: "/puppet/latest/upgrade_minor.html"
---

[`puppetlabs/puppetdb`]: https://forge.puppetlabs.com/puppetlabs/puppetdb
[Puppet Collection]: ./puppet_collections.md
[major upgrades]: ./upgrade_major_pre.html

A minor upgrade is an upgrade from one Puppet 4 release to another. If you are upgrading from Puppet 2 or 3, follow the instructions for [major upgrades][].

## Puppet Collections and upgrading

We deliver Puppet 4 (and all the stuff that works with it) in a group of packages called a **[Puppet Collection][]**. Puppet 4 is part of Puppet Collection 1 (PC1), which contains these packages:

{% include puppet-collections/_puppet_collection_1_contents.md %}

On \*nix systems, make sure the required PC1 repositories are installed and enabled before upgrading nodes.

The order in which you upgrade packages is important. Always upgrade `puppetserver` on your masters _before_ you upgrade agents. You can upgrade PuppetDB before or after you upgrade other nodes.

### Upgrading Puppet Server

Upgrade Puppet Server on the masters before upgrading any agents. 

> **Note**: Your Puppet masters are responsible for maintaining your site's infrastructure, and upgrading them disrupts their activities. If you only use one master, all Puppet services will be unavailable during the upgrade; avoid reconfiguring any Puppet-managed servers until your master is back up. If you use multiple load-balanced servers, upgrade them individually to avoid Puppet downtime or problems synchronizing configurations.

The `puppetserver` package depends on the `puppet-agent` package, and your node's package manager automatically upgrades `puppet-agent` if the new version of `puppetserver` requires it.

To upgrade the `puppetserver` package and its dependencies on masters that use `apt`, run:

~~~ bash
# apt-get update
# apt-get install --only-upgrade puppetserver
~~~

On masters that use `yum`, run:

~~~ bash
# yum update puppetserver
~~~

> **Note**: If you pinned or held your Puppet packages to a specific version, remove the pins or holds before continuing. On systems that use `apt`, remove any special `.pref` files from `/etc/apt/preferences.d/` that pin Puppet packages, and use the `apt-mark unhold` command on each held package. For `yum` packages locked with the versionlock plugin, edit `/etc/yum/pluginconf.d/versionlock.list` and remove the Puppet lock.

### Upgrading Puppet on Agents

You should regularly upgrade Puppet on agents, and in most cases you shouldn't need to do anything to prepare for such upgrades. Read the [release notes](./release_notes.html) before upgrading to learn about changes that affect specific systems or workflows.

To upgrade \*nix agents that use `apt`, run:

~~~ bash
# apt-get update
# apt-get install --only-upgrade puppet-agent
~~~

On \*nix agents that use `yum`, run:

~~~ bash
# yum update puppet-agent
~~~

On Windows agents, follow the [installation guide](./install_windows.html) to upgrade installed Puppet packages. You do not need to uninstall Puppet first unless you're changing from 64-bit Puppet to the 32-bit version or vice versa.

> **Note**: If you installed Puppet into a custom directory and are moving from a 32-bit version to a 64-bit version, you must specify the INSTALLDIR option and any other relevant MSI properties when re-installing.

### Upgrading PuppetDB

Upgrade PuppetDB nodes independently of masters and agents. 

You can automate PuppetDB upgrades using the `version` parameter of the [`puppetlabs/puppetdb`][] module's [`puppetdb::globals`](https://forge.puppetlabs.com/puppetlabs/puppetdb#usage) class. To manually upgrade the `puppetdb` package on nodes that use `apt`, run:

~~~ bash
# apt-get update
# apt-get install --only-upgrade puppetdb
~~~

On nodes that use `yum`, run:

~~~ bash
# yum update puppetdb
~~~

When you upgrade PuppetDB, you must also upgrade the `puppetdb-termini` package on all Puppet masters. To upgrade it on masters that use `apt`, run:

~~~ bash
# apt-get update
# apt-get install --only-upgrade puppetdb-termini
~~~

On masters that use `yum`, run:

~~~ bash
# yum update puppetdb-termini
~~~