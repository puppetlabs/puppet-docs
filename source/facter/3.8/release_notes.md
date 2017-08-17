---
layout: default
title: "Facter Release notes"
---

This page documents the history of the Facter 3.8 series.

## Facter 3.8.0

Released August 17, 2017.

This is a feature and improvement release of Facter that includes several bug fixes.

* [All issues resolved in Facter 3.8.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.8.0%27)

### New Features

* New facts, ZFS and ZPool have been aded to Facter's FreeBSD resolvers. Previously, these were only reported on Solaris.

* Added Go bindings. This release includes a function to gather default facts for Linux machines only. 


### Improvements

* BSDs now report hardware architecture.

* Virtualization detection for FreeBSD Jails has been added.

* Backward support added for zpool feature flags prior to verion 28.


### Bug fixes

These bugs have been fixed in this release:

* Free BSD OS release and Kernel release are now reported independently

* Memory reporting on FreeBSD now reports accurately.

* Facter is now compatible with OpenSSL 1.1.0

* Integers from feature descriptions are no longer reported as zpool feature numbers.


