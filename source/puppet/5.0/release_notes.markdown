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

## If you're upgrading from Puppet 4.x

## Puppet 5.0.0

This version of Puppet has not been released yet, and these docs are an unfinished draft until their release.

### New features

### Enhancements

### Deprecations

### Known issues

### Bug fixes

* [PUP-7594](https://tickets.puppetlabs.com/browse/PUP-7594): In Puppet 4.9 and greater, a regression converted integer or float keys in Hiera data to strings. The intended behavior was to filter out Ruby Symbol keys. Integer and Float keys in hashes now work as they should.

