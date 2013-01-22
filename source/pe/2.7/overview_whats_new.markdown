---
layout: default
title: "PE 2.7  » Overview » What's New"
subtitle: "New Features in PE 2.7"
---

### Version 2.7.1
PE 2.7.1 is a maintenance release. It makes a modification to [the way PE manages auth_conf]() and adds some patches to address security issues.

#### Changes to auth_conf Management

#### Security Patches

*CVE-2013-1398 MCO Private Key Leak*

Under certain circumstances, a user with root access to a single node in a PE deployment could possibly manipulate that client's local facts in order to force the pe_mcollective module to deliver a catalog containing SSL keys. These keys could be used to access other nodes in the collective and send them arbitrary commands as root. For the vast majority of users, the fix is to apply the 2.7.1 upgrade. 

For PE users who do not use the Console, this can be fixed by making sure that the pe_mcollective::role::master class is applied to your master, and
the pe_mcollective::role::console class is applied to your console. This can be as simple as adding the following to your site.pp manifest or other node classifier:


node console {
  include pe_mcollective::role::console
}

node master {
  include pe_mcollective::role::master
}

*CVE 2012-5664 SQL Injection Vulnerability*
 
This CVE addresses an SQL injection vulnerability in Ruby on Rails and Active Record. The vulnerability is related to the way dynamic finders are processed in Active Record wherein a method parameter could be used as scope. PE 2.7.1 provides patches to Puppet Dashboard and the Active Record packages to eliminate the vulnerabilitly. More information is available on this [CVE's page](http://puppetlabs.com/security/cve/cve-2012-5664/). 

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
