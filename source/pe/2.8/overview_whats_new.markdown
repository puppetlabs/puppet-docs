---
layout: default
title: "PE 2.8  » Overview » What's New"
subtitle: "New Features in PE 2.8"
---

### Version 2.8.2
PE 2.8.2 is a maintenance release that patches a critical security vulnerability. For details, check the [release notes](http://docs.puppetlabs.com/pe/2.8/appendix.html#release-notes).

### Version 2.8.1
PE 2.8.1 is a maintenance release. It includes a fix for a bug that caused Live Management and MCollective filtering failures.  Some other minor bug fixes are also included. For details, check the [release notes](http://docs.puppetlabs.com/pe/2.8/appendix.html#release-notes). Users of 2.8.0 are strongly encouraged to upgrade to 2.8.1. If you applied the 2.8.0 hotfix that predates the 2.8.1 release, you should still upgrade to 2.8.1 in order to get all of the latest fixes.

### Version 2.8.0
PE 2.8.0 is a feature and maintenance release. Specifically, the 2.8.0 release includes:

*1. New Support for AIX*
The puppet agent can now be installed on nodes running AIX so you can manage them using PE. To help you configure AIX nodes, support for AIX package providers, RPM, NIM and BFF, has been added as well. For information on installation on AIX nodes, check the [system requirements](http://docs.puppetlabs.com/pe/2.8/install_system_requirements.html) and the [installing PE page](http://docs.puppetlabs.com/pe/2.8/install_basic.html). In addition, the type reference has detailed information on [AIX package providers](http://docs.puppetlabs.com/pe/2.8/reference_type.html#package).

*2. Component Version Bumps*
Several of the components that comprise PE have been bumped to newer versions in 2.8. The updates include bug fixes and performance improvements. With PE 2.8, most users should notice faster compiliation times and better performance. The updated components include:

* Puppet 2.7.21
* Facter 1.6.17
* Hiera 1.1.2
* Hiera-Puppet 1.0.0
* Stomp 1.2.3

*3. Security Patch*
A vulnerability in the PE installer has been patched. For details, check the [release notes](http://docs.puppetlabs.com/pe/2.8/appendix.html#release-notes).

* * *

- [Next: Getting Support](./overview_getting_support.html)
