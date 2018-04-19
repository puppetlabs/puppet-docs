---
layout: default
title: "Facter release notes"
---

This page documents the history of the Facter 3.10 series.

## Facter 3.11.1

Released April 17, 2018.

This is a bug-fix and feature release that shipped with Puppet Platform 5.5.1.

-   [All issues resolved in Facter 3.11.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.1%27)

### Bug fixes

-   Facter 3.11.1 properly checks for errors when gathering disk information on AIX, and no longer warns or reports bogus results for devices assigned to special uses, such as databases. ([FACT-1597](https://tickets.puppetlabs.com/browse/FACT-1597))

-   Facter 3.11.1 reports MAC addresses on infiniband interfaces. ([FACT-1761](https://tickets.puppetlabs.com/browse/FACT-1761))

## Facter 3.11.0

Released March 20, 2018.

This is a bug-fix and feature release that shipped with Puppet Platform 5.5.0.

-   [All issues resolved in Facter 3.11.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.11.0%27)

### Bug fixes

-   The `uptime` fact for Windows now uses `GetTickCount64`, which is more reliable, minimizes clock skews, and offers better resolution than the previous method of computing using WMI BootUptime.

### New features

-   For each SSH key, Facter 3.11.0 includes the key type as part of its `ssh` fact.