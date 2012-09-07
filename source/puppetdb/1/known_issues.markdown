---
title: "PuppetDB » Known Issues"
layout: default
---


Bugs and Feature Requests
-----

[redmine]: http://projects.puppetlabs.com/projects/puppetdb/issues

PuppetDB's bugs and feature requests are managed in [Puppet Labs's issue tracker][redmine]. Search this database if you're having problems, and please report any new issues to us!

Broader Issues
-----

### Autorequire relationships are opaque

We don't correctly model dependencies between Puppet resources that have an auto-require relationship. For example, if you have two file resources where one is a parent directory of the other, Puppet will automatically create a dependency such that the child requires the parent. The problem is that such a dependency is *not* reflected in the catalog; puppet agent creates these relationships on the fly when it reads the catalog. 

Showing these relationships in PuppetDB will require a significant change to Puppet's core.
