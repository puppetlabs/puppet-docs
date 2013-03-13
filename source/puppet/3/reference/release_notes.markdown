---
layout: default
title: Puppet 3 Release Notes
description: Puppet release notes for version 3.x
---

[classes]: ./lang_classes.html
<!-- TODO better hiera url -->
[hiera]: https://github.com/puppetlabs/hiera
[lang_scope]: ./lang_scope.html
[qualified_vars]: ./lang_variables.html#accessing-out-of-scope-variables
[auth_conf]: /guides/rest_auth_conf.html
[upgrade]: /guides/upgrading.html
[upgrade_issues]: http://projects.puppetlabs.com/projects/puppet/wiki/Telly_Upgrade_Issues
[target_300]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f[]=fixed_version_id&op[fixed_version_id]=%3D&v[fixed_version_id][]=271&f[]=&c[]=project&c[]=tracker&c[]=status&c[]=priority&c[]=subject&c[]=assigned_to&c[]=fixed_version&group_by=
[unless]: ./lang_conditional.html#unless-statements
[target_310]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=288&f%5B%5D=&c%5B%5D=project&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=fixed_version&group_by=
[new_in_31]: ./whats_new.html#new-features-in-puppet-310
[CVE-2013-2275]: http://puppetlabs.com/security/cve/cve-2013-2275
[CVE-2013-1655]: http://puppetlabs.com/security/cve/cve-2013-1655
[CVE-2013-1654]: http://puppetlabs.com/security/cve/cve-2013-1654
[CVE-2013-1653]: http://puppetlabs.com/security/cve/cve-2013-1653
[CVE-2013-1652]: http://puppetlabs.com/security/cve/cve-2013-1652
[CVE-2013-1640]: http://puppetlabs.com/security/cve/cve-2013-1640


Puppet 3.x Release Notes
------------------------

For a full description of the Puppet 3 release, including major changes, backward incompatibilities, and focuses of development, please see the [long-form Puppet 3 "What's New" document](./whats_new.html). 

## 3.1.1

Puppet 3.1.1 is a **security release** addressing several vulnerabilities discovered in the 3.x line of Puppet. These
vulnerabilities have been assigned Mitre CVE numbers [CVE-2013-1640][], [CVE-2013-1652][], [CVE-2013-1653][], [CVE-2013-1654][], [CVE-2013-1655][] and [CVE-2013-2275][].

All users of Puppet 3.1.0 and earlier are strongly encouraged to upgrade to 3.1.1.

### Puppet 3.1.1 Downloads 

* Source: <https://downloads.puppetlabs.com/puppet/puppet-3.1.1.tar.gz>
* Windows package: <https://downloads.puppetlabs.com/windows/puppet-3.1.1.msi>
* RPMs: <https://yum.puppetlabs.com/el> or `/fedora`
* Debs: <https://apt.puppetlabs.com>
* Mac package: <https://downloads.puppetlabs.com/mac/puppet-3.1.1.dmg>
* Gems are available via rubygems at <https://rubygems.org/downloads/puppet-3.1.1.gem> or by using `gem
install puppet --version=3.1.1`

See the Verifying Puppet Download section at:  
<https://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet>

Please report feedback via the Puppet Labs Redmine site, using an affected puppet version of 3.1.1:  
<http://projects.puppetlabs.com/projects/puppet/>

### Puppet 3.1.1 Changelog 

* Andrew Parker (3):
     * (#14093) Cleanup tests for template functionality
     * (#14093) Remove unsafe attributes from TemplateWrapper
     * (#14093) Restore access to the filename in the template

* Jeff McCune (2):
     * (#19151) Reject SSLv2 SSL handshakes and ciphers
     * (#19531) (CVE-2013-2275) Only allow report save from the node matching the certname

* Josh Cooper (7):
     * Fix module tool acceptance test
     * Run openssl from windows when trying to downgrade master
     * Remove unnecessary rubygems require
     * Don't assume puppetbindir is defined
     * Display SSL messages so we can match our regex
     * Don't require openssl client to return 0 on failure
     * Don't assume master supports SSLv2

* Justin Stoller (6):
     * Acceptance tests for CVEs 2013 (1640, 1652, 1653, 1654,2274, 2275)
     * Separate tests for same CVEs into separate files
     * We can ( and should ) use grep instead of grep -E
     * add quotes around paths for windows interop
     * remove tests that do not run on 3.1+
     * run curl against the master on the master

* Moses Mendoza (1):
     * Update PUPPETVERSION for 3.1.1

* Nick Lewis (3):
     * (#19393) Safely load YAML from the network
     * Always read request body when using Rack
     * Fix order-dependent test failure in network/authorization_spec

* Patrick Carlisle (3):
     * (#19391) (CVE-2013-1652) Disallow use\_node compiler parameter for remote requests
     * (#19392) (CVE-2013-1653) Validate instances passed to indirector
     * (#19392) Don't validate key for certificate_status

* Pieter van de Bruggen (1):
     * Updating module tool acceptance tests with new expectations.


## 3.1.0

For a full description of all the major changes in Puppet 3.1, please see the list of [new features in Puppet 3.1][new_in_31].

### All Bugs Fixed in 3.1.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.1.0][target_310] (approx. 53)


## 3.0.2

3.0.2 Target version and resolved issues: <https://projects.puppetlabs.com/versions/337>

## 3.0.1

3.0.1 Target version and resolved issues: <https://projects.puppetlabs.com/versions/328>

## 3.0 

For a full description of the Puppet 3 release, including major changes, backward incompatibilities, and focuses of development, please see the [long-form Puppet 3 "What's New" document](./whats_new.html). 

### All Bugs Fixed in 3.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.0.0][target_300] (approx. 220)


