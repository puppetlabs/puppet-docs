---
title: "PuppetDB 0.9 » Known Issues"
layout: default
canonical: "/puppetdb/latest/known_issues.html"
---


Significant Bugs
-----

### None
If you are aware of any major issues, please file a bug report and we'll get right on it.


Minor Issues
-----

### PuppetDB does not restart after running Redhat Package Manager

This is [issue #15075][rpm]. Running RPM will correctly stop PuppetDB if it is enabled, but fails to restart it. You will need to manually restart PuppetDB. Please comment on the bug report if you have any additional information. 

[rpm]: http://projects.puppetlabs.com/issues/15075


Broader Issues
-----

### Autorequire relationships are opaque

We don't correctly model dependencies between Puppet resources that have an auto-require relationship. If you have 2 file resources where one is a parent directory of the other, Puppet will automatically create a dependency such that the child requires the parent. The problem is that such a dependency is *not* reflected in the catalog. As currently represented, the catalog contains no hint that such a relationship ever existed.
