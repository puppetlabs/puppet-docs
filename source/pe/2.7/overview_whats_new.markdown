---
layout: default
title: "PE 2.7  » Overview » What's New"
subtitle: "New Features in PE 2.7"
canonical: "/pe/latest/release_notes.html"
---

### Version 2.7.2
PE 2.7.2 is a maintenance and security release. It changes a couple of modules, applies several security patches and updates the defaults for auth.conf.

#### Changes to Modules
Two modules, `java_ks` and `pe_mcollective` (which depends on `java_ks`) have been updated. 

#### Security Patches
Several security patches are included to address vulnerabilities in either Puppet itself or underlying technologies Puppet is built on (e.g. JSON, Rails). The [release notes](appendix.html#release-notes) have a complete list.

#### Update to auth.conf 
One of the security fixes involves modifying a code stanza in the auth.conf file. If you  are using a manually customized version of this file (e.g. for cloud provisioning purposes, or custom report or cert management), you will need to modify the file by editing the stanza. The [release notes](appendix.html#release-notes) have the details.

### Version 2.7.1
PE 2.7.1 is a maintenance release. It modifies the way PE manages the auth_conf file, fixes an issue with puppet's augeas lenses, and adds several patches to address security issues. See the [Appendix](appendix.html#release-notes) for release notes detailing these changes.

#### Changes to auth.conf Management

PE's management of the auth.conf file has been changed. Now, after upgrading, the file will not be over-written on the subsequent puppet run.

#### Puppet Augeas Lens Fix

An issue with PE's file paths has been fixed so that augeas now runs correctly on Solaris systems.

#### Security Patches

Several security patches have been rolled into the packages for PE 2.7.1. These patches address vulnerabilities discovered in Ruby on Rails, an issue with keys in MCollective, and the addition of CSRF protection to HTTP requests. The [release notes](appendix.html#release-notes) have the details.

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
On platforms that use RPM packages (EL 5,6-based and SLES 11 platforms), you can now choose to verify those packages on installation/upgrade using Puppet Labs' public GPG key. For more information, see the [installation page](/pe/2.7/install_basic.html).


* * * 

- [Next: Getting Support](./overview_getting_support.html)
