---
layout: default
title: "Facter release notes"
---

These are the new features, resolved issues, and deprecations in this version of Facter. 

## Facter 3.12.3

Released 15 January 2019

This is a bug-fix release that shipped with Puppet Platform 6.0.5

### Resolved issues

- Facter now correctly returns the path to system32 on 64-bit systems when a user has manually created the "sysnative" folder. [FACT-1900](https://tickets.puppetlabs.com/browse/FACT-1900)

## Facter 3.12.2

Released 1 November 2018

This is a bug-fix release that shipped with Puppet Platform 6.0.4

### Bug fixes

- Previously, if you had multiple custom versions of a built-in fact, and only those with a weight of 0 could resolve, Facter used those zero-weighted values. Now, if only zero-weighted custom facts resolve, Facter uses built-in fact values instead. ([FACT-1873](https://tickets.puppetlabs.com/browse/FACT-1873))

## Facter 3.12.1

Released 25 October 2018 and shipped with Puppet Platform 6.0.3.

### Resolved issues

- Facter now correctly distinguishes between Windows Server 2016 and Windows Server 2019. ([FACT-1889](https://tickets.puppetlabs.com/browse/FACT-1889))

## Facter 3.12.0

Released 18 September 2018 and shipped with Puppet Platform 6.0.0

### New features

- Key type will now be included as part of the facts for each SSH key. ([FACT-1377](https://tickets.puppetlabs.com/browse/FACT-1377))

### Resolved issues

- Systems relying entirely on `systemd-networkd` for DHCP management do not use `dhclient`. This checks the DHCP leases directory of `systemd-networkd` (`/run/systemd/netif/leases`) in addition to the lease files of `dhclient` when attempting to identify DHCP servers. ([FACT-1851](https://tickets.puppetlabs.com/browse/FACT-1851))
- Facter no longer checks for missing `dmidecode` and does not report a warning when it's missing on POWER Linux machines.([FACT-1765](https://tickets.puppetlabs.com/browse/FACT-1765) and [FACT-1763](https://tickets.puppetlabs.com/browse/FACT-1763))

