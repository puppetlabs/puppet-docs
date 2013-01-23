---
layout: default
title: "PE 2.7  » Overview » What's New"
subtitle: "New Features in PE 2.7"
---

### Version 2.7.1
PE 2.7.1 is a maintenance release. It modifies the way PE manages auth_conf, fixes an issue with puppet's augeas lenses, and adds three patches to address security issues. See the [Appendix](appendix.html#release-notes) for release notes detailing the changes.

#### Changes to auth_conf Management

PE's management of the auth_conf file has been changed such that it will not be over-written during puppet runs after upgrading.

#### Puppet Augeas Lens Fix

An issue with PE's file paths have been fixed so that augeas now runs correctly on Solaris systems.

#### Security Patches

Three security patches have been rolled into the packages for PE 2.7.1. These address an SQL injection vulnerability, an issue with keys in MCollective, and add CSRF protection to HTML requests. The [release notes](appendix.html#release-notes) have the details.

### Version 2.7.0

PE 2.7.0 adds new node request management capabilities to the console. It also fixes several bugs and adds to or modifies some existing capabilities. 

#### Node Request Management

You can now use the console to view, approve or reject requests coming from nodes or services attempting to join your site. PE's new request management capabilities let you view incoming node requests, including their CSR's fingerprint, and accept or reject them singly or as a batch. For more information, see the [Node Request Management page](./console_cert_mgmt.html). 

#### New and Updated Modules
Three new modules have been added in PE 2.7: `puppetlabs-certificate_manager`, `puppetlabs-auth_conf`, and `ripienaar-concat`. The new certificate_manager module, which provides the new node request management capabilities, uses the auth_conf module, which depends on the concat module, to update and manage `auth.conf` on the master and console.

In addition, `puppetlabs-stdlib` has been updated to version 2.5.1 to include new PE version facts puppetlabs-pe_compliance. For details, see [Issue 16485](http://projects.puppetlabs.com/issues/16485).

#### Puppet patches
PE 2.7.0 uses a specially patched version of puppet 2.7.19.  See the [Appendix](appendix.html) for release notes detailing these patches.


#### RPM Package Verification
On platforms that use RPM packages (EL 5,6-based and SLES 11 platforms), you can now choose to verify those packages on installation/upgrade using Puppet Labs' public GPG key. For more information, see the [installation page](http://docs.puppetlabs.com/pe/2.7/install_basic.html).


* * * 

- [Next: Getting Support](./overview_getting_support.html)
