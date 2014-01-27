---
layout: default
title: "PE 3.2 » Overview » What's New"
subtitle: "New Features in PE 3.2"
canonical: "/pe/latest/overview_whats_new.html"
---

### Version 3.2.0

Puppet Enterprise (PE) version 3.2.0 is a feature and maintenance release. It adds new features and improvements, fixes bugs, and addresses security issues. Specifically, the 3.2.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes)):

* *Simplified Agent Install*

Installing agents on all platforms can now be done via package manager, making the installation process faster and simpler. For details, visit the [PE installation page](install_basic.html).

* *Puppet Labs Supported Modules*

PE 3.2 introduces Puppet Labs supported modules. (TODO: link)

* *Razor Provisioning Tech Preview*

PE 3.2 offers a preview of new, bare-metal provisioning capabilities using Razor technology. 

* *Puppet Agent with Non-Root Privileges*

In some situations, it may be desirable for a development team to manage their infrastructure on nodes to which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. Details can be found in the new [guide to non-root agents](./guides/deploy_nonroot-agent.html).

*  *Support for Solaris 11*

PE now supports agents on nodes running Solaris 11.

* *Enable/Disable Live Management*

In some cases, it may be desirable to disable PE's orchestration capabilities. This can now be done easily by changing a config setting or during installation with an answer file entry. For more information, see [navigating live management](console_navigating_live_mgmt.html) and the [installation instructions](install_basic.html).

* *Security Patches*

A handful of vulnerabilities have been addressed in PE 3.2.0. For details, check the [release notes](appendix.html#release-notes).

* *Component Package Upgrades*

Several of the “under the hood” constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:
* 

* * *

- [Next: Getting Support](./overview_getting_support.html)
