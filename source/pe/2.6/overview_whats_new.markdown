---
layout: default
title: "PE 2.6  » Overview » What's New"
subtitle: "New Features in PE 2.6"
---


Version 2.6 is a maintenance and feature release of Puppet Enterprise (PE). In addition to fixes and corrections, PE 2.6 introduces the following new features and improvements:

### Third Party Authentication Support

The Puppet Enterprise Console now supports the use of third party authentication tools such as LDAP, Active Directory or Google. Now, users of PE can be managed and authenticated with your existing infrastructure. For more information, see the [Console Access page](./console_auth.html).

### Installation Improvements

Extensive revisions to the installer have improved its performance and reliability for both new installs and upgrades.

### Windows improvements

Service management behavior has been improved with the ability to now synchronously start and stop Windows services (see ticket #13489).

Package management has also been improved. The MSI package provider now uses the `Installer` Automation (COM) interface to query system state. This provides accurate reporting on all packages, even those not installed by puppet (see ticket #11868).

### New Versions of Installed Packages and Modules

PE 2.6 updates numerous dependent packages and modules. The versions used in 2.6 are as follows:

* pe\_mcollective: 0.56
* pe\_accounts 1.1.0
* stdlib: 2.3.3
* Fog: 1.5.0
* Excon: 0.14.1
* Rubygems: 1.5.3
* Ruby: 1.8.7-p370
* Puppet: 2.7.19
* Facter: 1.6.10
* Dashboard: 1.2.10
* Dashboard-baseline: 2.0.5 (make baselines cron fire on ubuntu/debian)
* Console-auth: 1.1.4
* Live-management: 1.1.18

In addition, the libaugeas package is now installed on Solaris.
<!-- 
See the [Puppet Enterprise 2.6 release notes](./appendix.html#release-notes) for more details.
 -->


* * * 

- [Next: Getting Support](./overview_getting_support.html)
