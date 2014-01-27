---
layout: default
title: "PE 3.2 » Overview » What's New"
subtitle: "New Features in PE 3.2"
canonical: "/pe/latest/overview_whats_new.html"
---

### Version 3.2.0

Puppet Enterprise (PE) version 3.2.0 is a feature and maintenance release. It adds new features and improvements, fixes bugs, and addresses security issues. Specifically, the 3.1.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes)):

* *Network Device Support*

* *Puppet Labs Supported Modules*

* *Razor Provisioning Tech Preview*

Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. It's aimed at solving the problem of how to bring new metal into a state that your existing configuration management systems, PE for example, can then take over.

*Note*: This is a Technical Preview release of Razor. For more information about Razor and what constitutes a Technical Preview, please see the [Razor documentation](./razor_intro.html).

* *Puppet Agent with Non-Root Privileges*

In some situations, it may be desirable for a development team to manage their infrastructure on nodes to which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. Details can be found in the new [guide to non-root agents](./guides/nonroot_agent.html).

*  *Support for Solaris 11*

* *Enable/Disable Live Management*

Some workflows require that you have live management disabled in your PE console. PE 3.2 allows you to add a question to your answer file to disable/enable live management during installations or upgrades. You can also disable/enable live management during normal operations. For more details, refer to the [live management page](console_navigating_live_mgmt.html#disabling/enabling-live-management).

* *Security Patches*

A handful of vulnerabilities have been addressed in PE 3.2.0. For details, check the [release notes](appendix.html#release-notes).

* *Component Package Upgrades*

Several of the “under the hood” constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:
* 

* * *

- [Next: Getting Support](./overview_getting_support.html)
