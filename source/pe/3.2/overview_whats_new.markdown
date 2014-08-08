---
layout: default
title: "PE 3.2 » Overview » What's New"
subtitle: "New Features in PE 3.2"
canonical: "/pe/latest/release_notes.html"
---

### Version 3.2.3

PE 3.2.3 is a maintenance release that patches several security vulnerabilities in Java. For details, check the [release notes](appendix.html#release-notes).

### Version 3.2.2

PE 3.2.2 is a maintenance release that patches several security vulnerabilities and a few minor bugs. For details, check the [release notes](appendix.html#release-notes).

#### A Note about the Heartbleed Bug

We want to emphasize that Puppet Enterprise does not need to be patched for Heartbleed.

No version of Puppet Enterprise has been shipped with a vulnerable version of OpenSSL, so Puppet Enterprise is not itself vulnerable to the security bug known as Heartbleed, and does not require a patch from Puppet Labs.

However, some of your Puppet Enterprise-managed nodes could be running operating systems that include OpenSSL versions 1.0.1 or 1.0.2, and both of these are vulnerable to the Heartbleed bug. Since tools included in Puppet Enterprise, such as PuppetDB and the Console, make use of SSL certificates we believe the safest, most secure method for assuring the security of your Puppet-managed infrastructure is to regenerate your certificate authority and all OpenSSL certificates.

We have outlined the remediation procedure to help make it an easy and fail-safe process. You’ll find the details here: Remediation for [Recovering from the Heartbleed Bug](/trouble_remediate_heartbleed_overview.html).

We’re here to help. If you have any issues with remediating the Heartbleed vulnerability, one of your authorized Puppet Enterprise support users can always log into the [customer support portal](https://support.puppetlabs.com/access/unauthenticated). We’ll continue to update the email list with any new information.

Links:

* [Heartbleed and Puppet-Supported Operating Systems](https://puppetlabs.com/blog/heartbleed-and-puppet-supported-operating-systems)

* [Heartbleed Update: Regeneration Still the Safest Path](https://puppetlabs.com/blog/heartbleed-update-regeneration-still-safest-path)

### Version 3.2.1

PE 3.2.1 is a maintenance release that fixes several minor bugs, including issues related to specific install and upgrade scenarios.  PE 3.2.1 also adds built-in support for OpenSSL on AIX nodes.
For details, check the [release notes](appendix.html#release-notes).

### Version 3.2.0

Puppet Enterprise (PE) version 3.2.0 is a feature and maintenance release. It adds new features and improvements, fixes bugs, and addresses security issues. Specifically, the 3.2.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes)):

#### Puppet Enterprise Supported Modules

PE 3.2 introduces [Puppet Enterprise supported modules](http://forge.puppetlabs.com/supported). PE supported modules allow you to manage core services quickly and easily, with very little need for you to write any code. PE supported modules are:

* rigorously tested with PE
* supported by Puppet Labs via the usual [support channels](http://puppetlabs.com/services/customer-support) (PE customers only)
* maintained for a long-term lifecycle
* compatible with multiple platforms and architectures.

Visit the [supported modules page](http://forge.puppetlabs.com/supported) to learn more. You can also check out the Read Me for each supported module being released with PE 3.2: [Apache][pe-apache], [NTP][pe-ntp], [MySQL][pe-mysql], [Windows Registry][windows-registry], [PostgreSQL][pe-postgresql], [stdlib][pe-stdlib], [reboot][pe-reboot], [firewall][pe-firewall], [apt][pe-apt], [INI-file][pe-inifile], [java_ks][pe-javaks], [concat][pe-concat].

[pe-apache]: http://forge.puppetlabs.com/puppetlabs/apache
[pe-ntp]: http://forge.puppetlabs.com/puppetlabs/ntp
[pe-mysql]: http://forge.puppetlabs.com/puppetlabs/mysql
[windows-registry]: http://forge.puppetlabs.com/puppetlabs/registry
[pe-postgresql]: http://forge.puppetlabs.com/puppetlabs/postgresql
[pe-stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[pe-reboot]: http://forge.puppetlabs.com/puppetlabs/reboot
[pe-firewall]: http://forge.puppetlabs.com/puppetlabs/firewall
[pe-apt]: http://forge.puppetlabs.com/puppetlabs/apt
[pe-inifile]: http://forge.puppetlabs.com/puppetlabs/inifile
[pe-javaks]: http://forge.puppetlabs.com/puppetlabs/java_ks
[pe-concat]: http://forge.puppetlabs.com/puppetlabs/concat

#### Simplified Agent Install

On platforms that natively support remote package repos, agents can now be installed via package management tools, making the installation process faster and simpler. This will be especially useful for highly dynamic, virtualized infrastructures. For details, visit the [PE installation page](install_basic.html#installing-agents).

#### Razor Provisioning Tech Preview

PE 3.2 offers a [tech preview](http://puppetlabs.com/services/tech-preview) of new, bare-metal provisioning capabilities using Razor technology. Razor aims to solve the problem of how to bring new metal, be it in your machine room or in the cloud, into a state that PE can then take over and manage. It does this by discovering bare metal machines and then installing and configuring operating systems and/or hypervisors on them. For more information, refer to the [Razor documentation](./razor_intro.html).

> *Note*: Razor is included in Puppet Enterprise 3.2 as a tech preview. Puppet Labs tech previews provide early access to new technology still under development. As such, you should only use them for evaluation purposes and not in production environments. You can find more information on tech previews on the [tech preview support scope page](http://puppetlabs.com/services/tech-preview).


#### Puppet Agent with Non-Root Privileges

In some situations, a development team may wish to manage infrastructure on nodes to which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. You can learn more in the new [guide to non-root agents](deploy_nonroot-agent.html).

#### Agent Support for Solaris 11

The puppet agent can now be installed on nodes running Solaris 11. Other roles (e.g., master, console) are not supported. For more information, see the [system requirements](install_system_requirements.html).

#### Disable/Enable Live Management

In some cases, you may want to disable PE's orchestration capabilities. This can now be done easily by disabling live management, either by changing a config setting or during installation with an answer file entry. For more information, see [navigating live management](console_navigating_live_mgmt.html) and the [installation instructions](install_basic.html).

#### Security Patches

A handful of vulnerabilities have been addressed in PE 3.2.0. For details, check the [release notes](appendix.html#release-notes).

#### Component Package Upgrades

Several of the "under the hood" constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:

* Puppet 3.4.3
* PuppetDB 1.5.2
* Facter 1.7.5
* MCollective 2.2.4
* Hiera 1.3.2
* Dashboard 2.1.1

Visit the [What Gets Installed page](./install_what_and_where.html#puppet-enterprise-components) for a comprehensive list of packages installed by PE.

* * *

[Next: Getting Support](./overview_getting_support.html)
