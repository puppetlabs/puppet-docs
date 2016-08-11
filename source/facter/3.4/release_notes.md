---
layout: default
title: "Facter 3.4 Release notes"
---

[puppet-agent 1.5.x]: /puppet/4.5/reference/about_agent.html

This page documents the history of the Facter 3.4 series. If you're upgrading from Facter 2, review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality. 

## Facter 3.4.0

Released August 10, 2016.

* [Fixed in Facter 3.4.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.4.0%27)
* [Introduced in Facter 3.4.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.4.0%27)


### Enhancements

* [FACT-1419](): The `identity` structured fact has been enhanced with the `privileged` element - a boolean flag which is set to true if facter is running as a privileged process or false if not.

* [FACT-1428](https://tickets.puppetlabs.com/browse/FACT-1428): Facter 3 can now report a subset of standard facts on FreeBSD

#### Facter detects PhotonOS

This release adds PhotonOS detection to the Facter `os` structured facts and related legacy flat facts. The OS name is "PhotonOS", and its family is "RedHat".

* [FACT-1422](https://tickets.puppetlabs.com/browse/FACT-1422)

### New features

#### HOCON config file for Facter

This release adds support for a HOCON config file for Facter, which has fields for certain global settings that can currently only be set from the command line. These come in two groups: global, which contains settings for fact directories and Ruby, and CLI, which contains fields for configuring command line output.

There is now a command line flag for Facter (`--config`) which allows the user to specify the path to the config file.

* [FACT-1458](https://tickets.puppetlabs.com/browse/FACT-1458)
* [FACT-1459](https://tickets.puppetlabs.com/browse/FACT-1459)


### Bug fixes

* [FACT-1406](https://tickets.puppetlabs.com/browse/FACT-1406): On 32-bit Linux or BSD, several individual fields within the `mountpoints` fact could be corrupt. This fixes that problem.

* [FACT-1448](https://tickets.puppetlabs.com/browse/FACT-1488): Previously, all Facter boolean values were returned true when JSON output was requested. This corrects the issue so that `false` is returned when the fact value is `false`.

* [FACT-1405](https://tickets.puppetlabs.com/browse/FACT-1405): Facter now constructs IP route information correctly when there are additonal flags in the ip route.

* [FACT-1449](https://tickets.puppetlabs.com/browse/FACT-1449): Facter treated quoted numeric and boolean values in YAML external fact files as numeric/boolean instead of respecting the quotes and treating the value as a string. Facter has been fixed to only perform the conversion for unquoted scalar values.

* [FACT-1434](https://tickets.puppetlabs.com/browse/FACT-1434): Facter now correctly reports the `wxallowed` mount flag on OpenBSD.

* [FACT-1454](https://tickets.puppetlabs.com/browse/FACT-1454): This updates the Ruby object collection process in Leatherman to fix a segfault issue when using libfacter with Ruby 2.3.1.

* [FACT-1432](https://tickets.puppetlabs.com/browse/FACT-1432): Facter now correctly reports the link address of a network interface on OpenBSD.
