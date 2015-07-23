---
layout: default
title: "Minor Upgrades: Within 4.x (Puppet Collection 1 / PC1)"
canonical: "/puppet/latest/reference/upgrade_minor.html"
---

[`puppetlabs/puppetdb`]: https://forge.puppetlabs.com/puppetlabs/puppetdb

Since Puppet likely manages your entire infrastructure, you should upgrade it with care. This page describes our recommendations for upgrading Puppet.

## Using Puppet Collections

We deliver Puppet 4 (and all the stuff that works with it) in a group of releases served from a repository and called a **Puppet Collection**. Puppet 4 is part of Puppet Collection 1 (PC1), which contains these packages:

Package        | Contents
---------------|------------------------------------------------------
`puppet-agent` | Puppet, [Facter](http://docs.puppetlabs.com/facter/), and [Hiera](http://docs.puppetlabs.com/hiera/), and prerequisites like Ruby and [Augeas](http://augeas.net/)
`puppetserver` | Puppet master; depends on `puppet-agent`
`puppetdb`     | PuppetDB

## Upgrading Within Versions of Puppet 4

Compared to upgrades between major versions, upgrades between minor versions of Puppet 4 (and its associated tools) are simple to execute and carry few risks.

### Upgrading Puppet Server

> **Note:** Upgrade Puppet Server on the masters before upgrading any agents.

The `puppetserver` package depends on the `puppet-agent` package. When upgrading Puppet Server, upgrade `puppet-agent` on that master at the same time. Your server's package manager might upgrade both packages automatically if the new version of `puppetserver` depends on a specific version of `puppet-agent`.

> **Note**: Puppet Server is responsible for maintaining your site's infrastructure, and upgrading it disrupts its activities. Be careful and test the results of upgrades frequently while installing them.

### Upgrading *nix Agents

You should regularly upgrade the `puppet-agent` package, and in most cases you shouldn't need to do anything to prepare for such upgrades. However, we strongly recommend reading the [release notes](/release_notes/) before upgrading in case there are changes that might affect specific systems or workflows.

### Upgrading PuppetDB

You can upgrade `puppetdb` independently of `puppetserver` and `puppet-agent`. You should use the [`puppetlabs/puppetdb`](https://forge.puppetlabs.com/puppetlabs/puppetdb) module to manage it.

Remember to also upgrade the `puppetdb-terminus` package on your Puppet Server nodes every time you upgrade `puppetdb`.

### Upgrading Puppet on Windows agents

On Windows agents, follow the [installation guide](./install_windows.html) to upgrade installed Puppet packages. You do not need to uninstall Puppet first unless you're changing the architecture of the Puppet installation, whether from 64-bit Puppet to the 32-bit version or vice versa.

> **Note**: If you installed Puppet into a custom directory and are moving from a 32-bit version to a 64-bit version, you must specify the INSTALLDIR option and any other relevant MSI properties when re-installing.

