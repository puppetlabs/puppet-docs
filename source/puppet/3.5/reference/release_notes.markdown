---
layout: default
title: Puppet 3 Release Notes
description: Puppet release notes for version 3.x
canonical: "/puppet/latest/reference/release_notes.html"
---

[classes]: ./lang_classes.html
[lang_scope]: ./lang_scope.html
[qualified_vars]: ./lang_variables.html#accessing-out-of-scope-variables
[auth_conf]: /guides/rest_auth_conf.html
[upgrade]: /guides/upgrading.html
[upgrade_issues]: http://projects.puppetlabs.com/projects/puppet/wiki/Telly_Upgrade_Issues
[target_300]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f[]=fixed_version_id&op[fixed_version_id]=%3D&v[fixed_version_id][]=271&f[]=&c[]=project&c[]=tracker&c[]=status&c[]=priority&c[]=subject&c[]=assigned_to&c[]=fixed_version&group_by=
[unless]: ./lang_conditional.html#unless-statements
[target_310]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=288&f%5B%5D=&c%5B%5D=project&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=fixed_version&group_by=
[CVE-2013-2275]: http://puppetlabs.com/security/cve/cve-2013-2275
[CVE-2013-1655]: http://puppetlabs.com/security/cve/cve-2013-1655
[CVE-2013-1654]: http://puppetlabs.com/security/cve/cve-2013-1654
[CVE-2013-1653]: http://puppetlabs.com/security/cve/cve-2013-1653
[CVE-2013-1652]: http://puppetlabs.com/security/cve/cve-2013-1652
[CVE-2013-1640]: http://puppetlabs.com/security/cve/cve-2013-1640
[32issues]: http://projects.puppetlabs.com/versions/371
[32splay]: /references/latest/configuration.html#splay
[32modulo_operator]: /puppet/3/reference/lang_expressions.html#modulo
[32profiling_setting]: /references/3.stable/configuration.html#profile
[32cron_type]: /references/3.stable/type.html#cron
[32hiera_auto_param]: /hiera/1/puppet.html#automatic-parameter-lookup
[19983]: http://projects.puppetlabs.com/issues/19983 "egrammar parser loses filename in error messages"
[11331]: http://projects.puppetlabs.com/issues/11331 "Add 'foreach' structure in manifests"
[18494]: http://projects.puppetlabs.com/issues/18494 "Ensure that puppet works on Ruby 2.0"
[19877]: http://projects.puppetlabs.com/issues/19877 "Puppet Support for OpenWrt"
[15561]: http://projects.puppetlabs.com/issues/15561 "Fix for CVE-2012-3867 is too restrictive"
[17864]: http://projects.puppetlabs.com/issues/17864 "puppet client requests /production/certificate_revocation_list/ca even with certificate_revocation=false"
[19271]: http://projects.puppetlabs.com/issues/19271 "The HTTP SSL errors assume the puppet ca subject name starts with 'puppet ca'"
[20027]: http://projects.puppetlabs.com/issues/20027 "Puppet ssl_client_ca_auth setting does not behave as documented"
[18950]: http://projects.puppetlabs.com/issues/18950 "Add a modulo operator to puppet"
[17190]: http://projects.puppetlabs.com/issues/17190 "detailed accounting/debugging of catalog compilation times"
[593]: http://projects.puppetlabs.com/issues/593 "Puppet's cron type struggles with vixie-cron"
[656]: http://projects.puppetlabs.com/issues/656 "cron entries with newlines keep being updated"
[1453]: http://projects.puppetlabs.com/issues/1453 "removing a cron parameter does not change the object"
[2251]: http://projects.puppetlabs.com/issues/2251 "cron provider doesn't correctly employ user property for resource existence checks."
[3047]: http://projects.puppetlabs.com/issues/3047 "Cron entries using "special" parameter lose their title when changed"
[5752]: http://projects.puppetlabs.com/issues/5752 "Solaris 10 root crontab gets destroyed"
[16121]: http://projects.puppetlabs.com/issues/16121 "Cron user change results in duplicate entries on target user"
[16809]: http://projects.puppetlabs.com/issues/16809 "cron resource can destroy other resources"
[19716]: http://projects.puppetlabs.com/issues/19716 "cron job not sucked into puppet"
[19876]: http://projects.puppetlabs.com/issues/19876 "Regression: cron now matches on-disk records too aggressively"
[11276]: http://projects.puppetlabs.com/issues/11276 "Get puppet module tool working on Windows"
[13542]: http://projects.puppetlabs.com/issues/13542 "PMT cannot install tarballs for modules that don't exist on the Forge"
[14728]: http://projects.puppetlabs.com/issues/14728 "puppet module changes incorrectly errors when a file is missing"
[18229]: http://projects.puppetlabs.com/issues/18229 "Eroneous command given in puppet module error message"
[19128]: http://projects.puppetlabs.com/issues/19128 ""puppet module build" doesn't escape PSON correctly"
[19409]: http://projects.puppetlabs.com/issues/19409 "puppet module errors from Puppet::Forge don't obey render mode"
[15841]: http://projects.puppetlabs.com/issues/15841 "Consider bundling minitar (or equivalent) for use by puppet module face"
[7680]: http://projects.puppetlabs.com/issues/7680 "Checksum missmatch when copying followed symlinks"
[14544]: http://projects.puppetlabs.com/issues/14544 "The apply application should support writing the resources file and classes file"
[14766]: http://projects.puppetlabs.com/issues/14766 "2nd puppet run after restart is ignoring runinterval, negating splay"
[18211]: http://projects.puppetlabs.com/issues/18211 "puppet agent sleeping well past runinterval"
[14985]: http://projects.puppetlabs.com/issues/14985 "calling_module and calling_class don't always return the calling module/class"
[17474]: http://projects.puppetlabs.com/issues/17474 "Indirector treats false from a terminus as nil"


Puppet 3.5 Release Notes
------------------------

This page documents the history of the Puppet 3.5 series.

Starting from version 3.0.0, Puppet is semantically versioned with a three-part version number. In version X.Y.Z:

* X must increase for major backwards-incompatible changes.
* Y may increase for backwards-compatible new functionality.
* Z may increase for bug fixes.

> **Note:** If upgrading from Puppet 2.x, please read our [general recommendations for upgrading between two major versions of Puppet][upgrade], which include suggested roll-out plans and package management practices. In general, upgrade the puppet master servers before upgrading the agents they support.
>
> Also, before upgrading, look above at the _table of contents_ for this page. Identify the version you're upgrading TO and any versions you're upgrading THROUGH, and check them for a subheader labeled "Upgrade Warning," which will always be at the top of that version's notes. If there's anything special you need to know before upgrading, we will put it here.

Puppet 3.5.0
-----

todo.