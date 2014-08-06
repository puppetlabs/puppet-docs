---
layout: default
title: "PE 2.6  » Overview » What's New"
subtitle: "New Features in PE 2.6"
canonical: "/pe/latest/release_notes.html"
---
### Version 2.6.1
PE 2.6.1 is a bug fix release and security update. 

#### ConsoleAuth Session Error
Users who attempted to upgrade to 2.6.0 while they had an active console session encountered an error caused by an older, incompatible cookie. This could also cause a low-risk security vulnerability. PE 2.6.1 addresses this by correctly logging out the user and creating new, fully compatible cookies. For more information, see [CVE-2012-5158](http://puppetlabs.com/security/cve/cve-2012-5158/).

#### Manpages Location Conflicted with FOSS Puppet
PE 2.6.0 packages conflicted with FOSS puppet because they placed manpages in a location unrecognized by FOSS puppet. This has been corrected. For more information, see [ticket #16502](http://projects.puppetlabs.com/issues/16502)

#### Comments Not Added to cas_client_config.yml
When upgrading from 2.5.0 to 2.6.0, commented out sections in the cas_client_config.yml file were not preserved. This has been corrected. For more information, see [ticket #16556](http://projects.puppetlabs.com/issues/16556)

#### CVE-2012-5158
2.6.0 introduced a low-risk vulnerability wherein user sessions were not fully terminated. This has been resolved in 2.6.1. For more information, see [CVE-2012-5158](http://puppetlabs.com/security/cve/cve-2012-5158/).

### Version 2.6.0 

PE 2.6.0 is a maintenance and feature release of Puppet Enterprise (PE). In addition to fixes and corrections, PE 2.6 introduces the following new features and improvements:

#### Third Party Authentication Support

The Puppet Enterprise Console now supports the use of third party authentication tools such as LDAP, Active Directory or Google. Now, users of PE can be managed and authenticated with your existing infrastructure. For more information, see the [Console Access page](./console_auth.html).

#### Installation Improvements

Extensive revisions to the installer have improved its performance and reliability for both new installs and upgrades.

#### Windows improvements

Service management behavior has been improved with the ability to now synchronously start and stop Windows services (see [ticket #13489](http://projects.puppetlabs.com/issues/13489)).

Package management has also been improved. The MSI package provider now uses the Installer Automation (COM) interface to query system state. This provides accurate reporting on all packages, even those not installed by puppet (see [ticket #11868](http://projects.puppetlabs.com/issues/11868)).

#### New Versions of Installed Packages and Modules

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


* * * 

- [Next: Getting Support](./overview_getting_support.html)
