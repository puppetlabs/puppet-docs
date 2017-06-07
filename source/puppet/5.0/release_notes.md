---
layout: default
toc_levels: 1234
title: "Puppet 5.0 Release Notes"
---

This page lists the changes in Puppet 5.0 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), because they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.9 release notes](/puppet/4.9/release_notes.html) and [Puppet 4.8 release notes](/puppet/4.8/release_notes.html).

## Puppet 5.0

Released

* [Fixed in Puppet 5.0]()
* [Introduced in Puppet 5.0]()

### Bug fixes

* [PUP-7594](https://tickets.puppetlabs.com/browse/PUP-7594): In Puppet 4.9 and greater, a regression converted integer or float keys in Hiera data to strings. The intended behavior was to filter out Ruby Symbol keys. Integer and Float keys in hashes now work as they should.


