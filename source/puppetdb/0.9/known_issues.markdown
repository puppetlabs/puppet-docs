---
title: "PuppetDB » Known Issues"
layout: default
nav: puppetdb0.9.html
---


Significant Bugs
-----

### On Debian and Ubuntu, the init script kills other Java instances

This is [issue #14586][shutdown], and currently does not appear to affect EL or Fedora systems. Please comment on the bug report if you have any additional information. 

[shutdown]: http://projects.puppetlabs.com/issues/14586

Longer-Term Design Issues
-----

### Autorequire relationships are opaque

We don't correctly model dependencies between Puppet resources that have an auto-require relationship. If you have 2 file resources where one is a parent directory of the other, Puppet will automatically create a dependency such that the child requires the parent. The problem is that such a dependency is *not* reflected in the catalog...the catalog, as currently represented, contains no hint that such a relationship ever existed.
