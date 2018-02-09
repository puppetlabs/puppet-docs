---
layout: default
title: "Facter 3.6 Release notes"
---

This page documents the history of the Facter 3.6 series. If you're upgrading from Facter 2, review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality.

## Facter 3.6.9

Released February 5, 2018.

This is a bug-fix release that shipped with Puppet agent 1.10.10.

-   [All issues resolved in Facter 3.6.9](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.6.9%27)

### Bug fixes

-   Facter no longer attempts to check the `dmidecode` fact in Linux systems running on POWER architectures.

-   Facter 3.6.9 can interpret YAML or JSON output from external facts written in Powershell as structured facts.

## Facter 3.6.8

Released November 6, 2017.

This is a bug-fix release that shipped with Puppet agent 1.10.9.

-   [All issues resolved in Facter 3.6.8](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.6.8%27)

### Bug fixes

Facter 3.6.8 resolves issues on Power8 architectures and with custom fact evaluation.

-   On Power8 architectures, previous versions of Facter reported inaccurate counts of logical and physical processors in the `processors` fact. Facter 3.6.8 resolves the issue by using the `/sys/devices/system/cpu` directory to compute only the physical CPU count, and computes the logical CPU count by incrementing the number of processor entries in `/proc/cpuinfo`.

Also, previous versions of Facter used the wrong fields of `/proc/cpu/info` on Power8 architectures when determining the CPU model and clock speed. Facter 3.6.8 correctly uses the `cpu` and `clock` fields when populating relevant facts.

-   Since Facter 3.6.0, Facter evaluated custom facts from Puppet twice. Facter 3.6.8 resolves this issue by evaluating them only once, which significantly reduces the time required to evaluate facts.

## Facter 3.6.7

Released September 6, 2017.

This is a minor bug-fix and Windows security improvement release that shipped with Puppet agent 1.10.7.

-   [All issues resolved in Facter 3.6.7](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.6.7%27)

## Security improvement: Enable Data Execution Prevention (DEP)

As part of security robustness measure, the Windows binaries for Facter 3.6.7 enable Data Execution Prevention (aka /NX) and address space layout randomization. There was no specific known vulnerability, but this improvement reduces the changes of unknown vulnerabilities being exploited.

* [FACT-1730](https://tickets.puppetlabs.com/browse/FACT-1730)

## Bug fixes

* [FACT-1728](https://tickets.puppetlabs.com/browse/FACT-1728): Facter provides an improved error message when `facter -p` is specified but Puppet cannot be loaded.

## Facter 3.6.6

Released July 26, 2017.

This is a minor bug fix release that shipped with Puppet agent 1.10.5.

* [All resolved issues in Facter 3.6.6](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.6.6%27)

### Bug fixes

* [FACT-1455](https://tickets.puppetlabs.com/browse/FACT-1455): Facter now correctly returns the `id` fact when a group file entry is larger than 1KiB.

## Facter 3.6.5

Released June 12, 2017.

This is a minor bug fix release that shipped with Puppet agent 1.10.2.

* [Fixed in Facter 3.6.5](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.6.5%27)
* [Introduced in Facter 3.6.5](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.5%27)

### Bug fixes

* [FACT-1627](https://tickets.puppetlabs.com/browse/FACT-1627): Facter computes more accurate version information for AIX.
* [FACT-1610](https://tickets.puppetlabs.com/browse/FACT-1610): Facter correctly handles AIX volume groups that have been inherited from AIX 4 versions.

## Facter 3.6.4

Released May 11, 2017.

Shipped with Puppet agent 1.10.1. This is a minor bug fix release, and most issues contained in it to do not affect users.

* [Fixed in Facter 3.6.4](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.6.4%27)
* [Introduced in Facter 3.6.4](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.4%27)

### Bug fixes

* [FACT-1578](https://tickets.puppetlabs.com/browse/FACT-1578): Facter had an integer overflow when reporting on large numeric fact values like disk sizes, so the values were reported as negative numbers. This fix ensures Facter uses 64-bit longs to correctly report on the data.

## Facter 3.6.3

Released April 5, 2017.

Shipped with Puppet agent 1.10.0. This minor release contains one bug fix, and the remaining issues do not affect users.


* [Fixed in Facter 3.6.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.6.3%27)
* [Introduced in Facter 3.6.3](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.3%27)

### Bug fixes

* [FACT-1585](https://tickets.puppetlabs.com/browse/FACT-1585): GCE metadata collection now works correctly when Google's DNS is not used.


## Facter 3.6.2

Released March 9, 2017.

Shipped with Puppet agent 1.9.3.

* [Fixed in Facter 3.6.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.6.2%27)
* [Introduced in Facter 3.6.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.2%27)

This is a minor release that does not affect users.

## Facter 3.6.1

Released February 10, 2017.

Shipped with Puppet agent 1.9.1.

* [Fixed in Facter 3.6.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.6.1%27)
* [Introduced in Facter 3.6.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.6.1%27)

This is a minor release that does not affect users.

## Facter 3.6.0

Released February 1, 2017.

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
