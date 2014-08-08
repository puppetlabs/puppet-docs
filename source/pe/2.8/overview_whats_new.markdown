---
layout: default
title: "PE 2.8  » Overview » What's New"
subtitle: "New Features in PE 2.8"
canonical: "/pe/latest/release_notes.html"
---

### Version 2.8.6

PE 2.8.6 is a maintenance release that patches several security vulnerabilities. For details, check the [release notes](appendix.html#release-notes).

#### A Note about the Heartbleed Bug

We want to emphasize that Puppet Enterprise does not need to be patched for Heartbleed.  

No version of Puppet Enterprise has been shipped with a vulnerable version of OpenSSL, so Puppet Enterprise is not itself vulnerable to the security bug known as Heartbleed, and does not require a patch from Puppet Labs.

However, some of your Puppet Enterprise-managed nodes could be running operating systems that include OpenSSL versions 1.0.1 or 1.0.2, and both of these are vulnerable to the Heartbleed bug. Since tools included in Puppet Enterprise, such as PuppetDB and the Console, make use of SSL certificates we believe the safest, most secure method for assuring the security of your Puppet-managed infrastructure is to regenerate your certificate authority and all OpenSSL certificates. 

We have outlined the remediation procedure to help make it an easy and fail-safe process. You’ll find the details here: Remediation for [Recovering from the Heartbleed Bug](/trouble_remediate_heartbleed_overview.html).

We’re here to help. If you have any issues with remediating the Heartbleed vulnerability, one of your authorized Puppet Enterprise support users can always log into the [customer support portal](https://support.puppetlabs.com/access/unauthenticated). We’ll continue to update the email list with any new information.

Links:

* [Heartbleed and Puppet-Supported Operating Systems](https://puppetlabs.com/blog/heartbleed-and-puppet-supported-operating-systems)

* [Heartbleed Update: Regeneration Still the Safest Path](https://puppetlabs.com/blog/heartbleed-update-regeneration-still-safest-path)

### Version 2.8.5

PE 2.8.5 is a maintenance release that patches a security vulnerability and fixes several minor bugs. For details, check the [release notes](appendix.html#release-notes).

### Version 2.8.4
PE 2.8.4 is a maintenance release that patches several security vulnerabilities. For details, check the [release notes](appendix.html#release-notes)

### Version 2.8.3
PE 2.8.3 is a maintenance release that patches several security vulnerabilities. For details, check the [release notes](/pe/2.8/appendix.html#release-notes).


### Version 2.8.2
PE 2.8.2 is a maintenance release that patches a critical security vulnerability. For details, check the [release notes](/pe/2.8/appendix.html#release-notes).

### Version 2.8.1
PE 2.8.1 is a maintenance release. It includes a fix for a bug that caused Live Management and MCollective filtering failures.  Some other minor bug fixes are also included. For details, check the [release notes](/pe/2.8/appendix.html#release-notes). Users of 2.8.0 are strongly encouraged to upgrade to 2.8.1. If you applied the 2.8.0 hotfix that predates the 2.8.1 release, you should still upgrade to 2.8.1 in order to get all of the latest fixes.

### Version 2.8.0
PE 2.8.0 is a feature and maintenance release. Specifically, the 2.8.0 release includes:

  * *New Support for AIX*

    The puppet agent can now be installed on nodes running AIX so you can manage them using PE. To help you configure AIX nodes, support for AIX package providers, RPM, NIM and BFF, has been added as well. For information on installation on AIX nodes, check the [system requirements](/pe/2.8/install_system_requirements.html) and the [installing PE page](/pe/2.8/install_basic.html). In addition, the type reference has detailed information on [AIX package providers](/pe/2.8/reference_type.html#package).

  * *Component Version Bumps*

    Several of the components that comprise PE have been bumped to newer versions in 2.8. The updates include bug fixes and performance improvements. With PE 2.8, most users should notice faster compiliation times and better performance. The updated components include:

* Puppet 2.7.21
* Facter 1.6.17
* Hiera 1.1.2
* Hiera-Puppet 1.0.0
* Stomp 1.2.3

  * *Security Patch*

    A vulnerability in the PE installer has been patched. For details, check the [release notes](/pe/2.8/appendix.html#release-notes).

* * *

- [Next: Getting Support](./overview_getting_support.html)
