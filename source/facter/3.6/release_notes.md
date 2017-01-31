---
layout: default
title: "Facter 3.6 Release notes"
---

This page documents the history of the Facter 3.6 series. If you're upgrading from Facter 2, review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality. 

## Facter 3.6.0

Released January 31, 2017.

Ships with Puppet agent 1.9.0.

* [Fixed in Facter 3.6.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.6.0%27)
* [Introduced in Facter 3.6.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.0%27)

### New features

#### New fact: `cloud`

The addition of a new top-level fact, `cloud`, is intended for discovering whether a node is running on a given public cloud provider. In this first release it currently detects whether a Linux-based node is running in Azure, and provides that information in the `cloud.provider` fact. 

No other cloud providers are currently detected. ([FACT-1441](https://tickets.puppetlabs.com/browse/FACT-1441))

```
"cloud": { 
    "provider": "azure" 
} 
```

### Enhancements

#### Structured fact support for AIX

We've added support for the `disks`, `filesystems`, `mountpoints`, and `partitions` facts on AIX. ([FACT-1552](https://tickets.puppetlabs.com/browse/FACT-1552))

### Bug fixes

* [FACT-1559](https://tickets.puppetlabs.com/browse/FACT-1559): Facter now reports the correct OS name for recent releases of CoreOS.

* [FACT-1527](https://tickets.puppetlabs.com/browse/FACT-1527): Previously, the Gentoo `os::release` fact was incorrectly reporting kernel version. This switches to reporting the release version from /etc/gentoo-release.

* [FACT-1520](https://tickets.puppetlabs.com/browse/FACT-1520): Facter again reports networking facts on FreeBSD (this was a regression from Facter 2). A case where the wrong system serial was used has also been fixed.

* [FACT-1394](https://tickets.puppetlabs.com/browse/FACT-1394): Facter no longer prints a false warning when `linkdown` is present in routing table entries

* [FACT-1510](https://tickets.puppetlabs.com/browse/FACT-1510): Facts from symlinked folders on Windows such as Virtualbox Shared Folders, should now resolve correctly.
