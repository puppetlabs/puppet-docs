---
layout: default
title: "PE 3.2 » Overview » What's New"
subtitle: "New Features in PE 3.2"
canonical: "/pe/latest/overview_whats_new.html"
---

### Version 3.2.0

Puppet Enterprise (PE) version 3.2.0 is a feature and maintenance release. It adds new features and improvements, fixes bugs, and addresses security issues. Specifically, the 3.2.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes)):

#### Simplified Agent Install

On platforms that support remote package repos, installing agents can now be done via package manager, making the installation process faster and simpler. For details, visit the [PE installation page](install_basic.html).

#### Puppet Labs Supported Modules

PE 3.2 introduces Puppet Labs supported modules. Supported modules will allow you to manage core services quickly and easily, with very little need for you to write any code. Supported modules are

* rigorously tested with PE
* supported by PL via the usual [support channels](http://puppetlabs.com/services/customer-support)
* maintained for a long-term lifecycle
* compatible with multiple platforms and architectures.

Visit the [Supported Modules page](TODO: link) to learn more. You can also check out the Read Me for each supported module being released with PE 3.2: [Apache][pe-apache], [NTP][pe-ntp], [MySQL][pe-mysql], [Windows Registry][windows-registry], [PostgreSQL][pe-postgresql], [stdlib][pe-stdlib], [reboot][pe-reboot], [firewall][pe-firewall], [apt][pe-apt], [INI-file][pe-inifile], [java_ks][pe-javaks], [Concat][pe-concat].

[pe-apache]: http://forge.puppetlabs.com/puppetlabs/apache
[pe-ntp]: http://forge.puppetlabs.com/puppetlabs/ntp
[pe-mysql]: http://forge.puppetlabs.com/puppetlabs/ntp
[windows-registry]: http://forge.puppetlabs.com/puppetlabs/registry
[pe-postgresql]: http://forge.puppetlabs.com/puppetlabs/postgresql
[pe-stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[pe-reboot]: http://forge.puppetlabs.com/puppetlabs/reboot
[pe-firewall]: http://forge.puppetlabs.com/puppetlabs/firewall
[pe-apt]: http://forge.puppetlabs.com/puppetlabs/apt
[pe-inifile]: http://forge.puppetlabs.com/puppetlabs/inifile
[pe-javaks]: http://forge.puppetlabs.com/puppetlabs/java_ks
[pe-concat]: http://forge.puppetlabs.com/puppetlabs/concat

#### Razor Provisioning Tech Preview

PE 3.2 offers a preview of new, bare-metal provisioning capabilities using Razor technology. 

Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. It's aimed at solving the problem of how to bring new metal into a state that your existing configuration management systems, PE for example, can then take over.

*Note*: This is a Technical Preview release of Razor. For more information about Razor and what constitutes a Technical Preview, please see the [Razor documentation](./razor_intro.html).

#### Puppet Agent with Non-Root Privileges

In some situations, it may be desirable for a development team to manage their infrastructure on nodes to which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. Details can be found in the new [guide to non-root agents](./guides/deploy_nonroot-agent.html).

#### Support for Solaris 11

The puppet agent can now be installed on nodes running Solaris 11. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

#### Disable/Enable Live Management

In some cases, it may be desirable to disable PE's orchestration capabilities. This can now be done easily by disabling live management, either by changing a config setting or during installation with an answer file entry. For more information, see [navigating live management](console_navigating_live_mgmt.html) and the [installation instructions](install_basic.html).


#### Security Patches

A handful of vulnerabilities have been addressed in PE 3.2.0. For details, check the [release notes](appendix.html#release-notes).

#### Component Package Upgrades

Several of the “under the hood” constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:

* Puppet 3.4.2
* PuppetDB 1.5.2
* Facter 1.7.4.
* MCollective 2.2.4
* Hiera 1.3.0.
* Dashboard 2.1.0

* * *

- [Next: Getting Support](./overview_getting_support.html)
