---
layout: default
title: "Minor upgrades: From Puppet 4 and within Puppet 5.x"
---

[`puppetlabs/puppetdb`]: https://forge.puppetlabs.com/puppetlabs/puppetdb
[major upgrades]: ./upgrade_major_pre.html

A minor upgrade is an upgrade from Puppet 4 to Puppet 5, or from one Puppet 5 release to another.

The order in which you upgrade packages is important. Always upgrade your Puppet Server and PuppetDB nodes simultaneously, including the `puppetdb-termini` package on Puppet Server nodes, and always upgrade them before you upgrade agent nodes. Don't run different major versions on your Puppet masters (including Server) and PuppetDB nodes.


## Upgrade Puppet Server

Upgrade Puppet Server on the masters before upgrading any agents. 

> **Note**: Your Puppet masters are responsible for maintaining your site's infrastructure, and upgrading them disrupts their activities. If you only use one master, all Puppet services will be unavailable during the upgrade; avoid reconfiguring any Puppet-managed servers until your master is back up. If you use multiple load-balanced servers, upgrade them individually to avoid Puppet downtime or problems synchronizing configurations.

The `puppetserver` package depends on the `puppet-agent` package, and your node's package manager automatically upgrades `puppet-agent` if the new version of `puppetserver` requires it.

1. To upgrade the `puppetserver` package and its dependencies on masters that use `apt`, run:

   ``` bash
   # apt-get update
   # apt-get install --only-upgrade puppetserver
   ```

   On masters that use `yum`, run:

   ``` bash
   # yum update puppetserver
   ```

> **Note**: If you pinned or held your Puppet packages to a specific version, remove the pins or holds before continuing. On systems that use `apt`, remove any special `.pref` files from `/etc/apt/preferences.d/` that pin Puppet packages, and use the `apt-mark unhold` command on each held package. For `yum` packages locked with the versionlock plugin, edit `/etc/yum/pluginconf.d/versionlock.list` and remove the Puppet lock.

## Upgrade Puppet on agents

You should regularly upgrade Puppet on agents, and in most cases you shouldn't need to do anything to prepare for such upgrades.

Read the [release notes](./release_notes.html) before upgrading to learn about changes that affect specific systems or workflows.

1. To upgrade \*nix agents that use `apt`, run:

   ``` bash
   # apt-get update
   # apt-get install --only-upgrade puppet-agent
   ```

   On \*nix agents that use `yum`, run:

   ``` bash
   # yum update puppet-agent
   ```

On Windows agents, follow the [installation guide](./install_windows.html) to upgrade installed Puppet packages. You do not need to uninstall Puppet first unless you're changing from 32-bit Puppet to the 64-bit version. Running 32-bit Puppet on 64-bit Windows is now deprecated, so you should update your Puppet's architecture to match your system.

> **Note**: If you installed Puppet into a custom directory and are moving from a 32-bit version to a 64-bit version, you must specify the INSTALLDIR option and any other relevant MSI properties when re-installing.

On macOS, follow the [installation guide](./install_osx.html) to upgrade installed Puppet packages. You don't need to uninstall Puppet first.

## Upgrade PuppetDB

Upgrade PuppetDB nodes independently of masters and agents. 

You can automate PuppetDB upgrades using the `version` parameter of the [`puppetlabs/puppetdb`][] module's [`puppetdb::globals`](https://forge.puppetlabs.com/puppetlabs/puppetdb#usage) class.

1. To manually upgrade the `puppetdb` package on nodes that use `apt`, run:

   ``` bash
   # apt-get update
   # apt-get install --only-upgrade puppetdb
   ```

   On nodes that use `yum`, run:

   ``` bash
   # yum update puppetdb
   ```

2. When you upgrade PuppetDB, you must also upgrade the `puppetdb-termini` package on all Puppet masters.

   To upgrade it on masters that use `apt`, run:

   ``` bash
   # apt-get update
   # apt-get install --only-upgrade puppetdb-termini
   ```

   On masters that use `yum`, run:

   ``` bash
   # yum update puppetdb-termini
   ```
