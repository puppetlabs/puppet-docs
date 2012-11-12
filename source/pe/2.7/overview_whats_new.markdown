---
layout: default
title: "PE 2.7  » Overview » What's New"
subtitle: "New Features in PE 2.7"
---
### Version 2.7.0
PE 2.7.0 adds new node request management capabilities to the console. It also fixes several bugs and adds to or modifies some existing capabilities. 

#### Node Request Management

You can now use the console to view, approve or reject requests coming from nodes or services attempting to join your site. PE's new request management capabilities let you view incoming node requests, including their CSR's fingerprint, and accept or reject them singly or as a batch. For more information, see the [Node Request Management page](./cert_mgmt.html). 

#### New and Updated Modules
Three new modules have been added in PE 2.7: `puppetlabs-certificate_manager`, `puppetlabs-auth_conf`, and `ripienaar-concat`. The new certificate_manager module, which provides the new node request management capabilities, uses the auth_conf module, which depends on the concat module, to update and manage `auth.conf` on the master and console.

In addition, `puppetlabs-stdlib` has been updated to version 2.5.1 to include new PE version facts puppetlabs-pe_compliance. For details, see [Issue 16485](http://projects.puppetlabs.com/issues/16485).

#### Puppet patches
PE 2.7.0 uses a specially patched version of puppet 2.7.19.  See the [Appendix](appendix.html) for release notes detailing these patches.





* * * 

- [Next: Getting Support](./overview_getting_support.html)
