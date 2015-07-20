---
layout: default
title: "Minor Upgrades: Within 4.x (Puppet Collection 1 / PC1)"
canonical: "/puppet/latest/reference/upgrade_minor.html"
---

[`puppetlabs/puppetdb`]: https://forge.puppetlabs.com/puppetlabs/puppetdb

Since Puppet likely manages your entire infrastructure, you should update it with care. This page describes our recommendations for updating Puppet.

## Using Puppet Collections

We deliver Puppet 4 (and all the stuff that works with it) in a group of releases served from a repository and called a **Puppet Collection**. Puppet 4 is part of Puppet Collection 1 (PC1), which contains these packages:

Package        | Contents
---------------|------------------------------------------------------
`puppet-agent` | Puppet, [Facter](http://docs.puppetlabs.com/facter/), and [Hiera](http://docs.puppetlabs.com/hiera/), and prerequisites like Ruby and [Augeas](http://augeas.net/)
`puppetserver` | Puppet master; depends on `puppet-agent`
`puppetdb`     | PuppetDB

## Updating within Versions of Puppet 4

Compared to upgrades between major versions, updates between minor versions of Puppet 4 (and its associated tools) are simple to execute and carry few risks.

### Updating Puppet Server

> **Note:** Update Puppet Server on the masters before updating any agents.

The `puppetserver` package depends on the `puppet-agent` package. When updating Puppet Server, update `puppet-agent` on that master at the same time. Your server's package manager might update both packages automatically if the new version of `puppetserver` depends on a specific version of `puppet-agent`.

> **Note**: Puppet Server is responsible for maintaining your site's infrastructure, and updating it disrupts its activities. Be careful and test the results of updates frequently while installing them.

### Updating *nix Agents

You should regularly update the `puppet-agent` package, and in most cases you shouldn't need to do anything to prepare for such updates. However, we strongly recommend reading the [release notes](/release_notes/) before updating in case there are changes that might affect specific systems or workflows.

### Updating PuppetDB

You can update `puppetdb` independently of `puppetserver` and `puppet-agent`. You should use the [`puppetlabs/puppetdb`](https://forge.puppetlabs.com/puppetlabs/puppetdb) module to manage it.

Remember to also update the `puppetdb-terminus` package on your Puppet Server nodes every time you update `puppetdb`.

### Updating Puppet on Windows agents

On Windows agents, follow the [installation guide](./install_windows.html) to update installed Puppet packages. You do not need to uninstall Puppet first unless you're changing the architecture of the Puppet installation, whether from 64-bit Puppet to the 32-bit version or vice versa.

> **Note**: If you installed Puppet into a custom directory and are moving from a 32-bit version to a 64-bit version, you must specify the INSTALLDIR option and any other relevant MSI properties when re-installing.

