---
layout: default
title: "Facter 2.1: Release Notes"
description: "Facter release notes for all 2.1 versions"
---

This page documents the history of the Facter 2.1 series. (Elsewhere: release notes for [Facter 2.0](../2.0/release_notes.html) and [Facter 1.7](../1.7/release_notes.html))

Facter 2.1.0
-----

Released June 25, 2014.

Facter 2.1.0 is a backward-compatible features and fixes release in the Facter 2 series. In addition to squashing a variety of bugs, it includes a couple of new (structured) facts, adds support for detecting Docker containers, and improves operating system detection.

### New Facts: `dhcp_servers` and `partitions`

Facter 2.1.0 ships with 2 new [structured facts](fact_overview.html#writing-structured-facts): the `dhcp_servers` fact returns a hash of DHCP server addresses, and `partitions` returns a hash of partition information. Please note that you'll need to set `stringify_facts = false` in each puppet agent's `[main]` config section to use structured facts.

Related issues:

- [FACT-233: Fact to add DHCP Server Details](https://tickets.puppetlabs.com/browse/FACT-233)

- [FACT-234: Add Facts showing the UUID of partitions](https://tickets.puppetlabs.com/browse/FACT-234)

### LXC Container (Docker) Support

As of this release, Docker-based LXC containers are detected as `is_virtual => true` and `virtual => docker`.

Related Issues:

- [FACT-377: Does not detect LXC virtualization](https://tickets.puppetlabs.com/browse/FACT-377)

- [FACT-189: LXC Container support](https://tickets.puppetlabs.com/browse/FACT-189)

### Improvements to Operating System Detection

Mandrake, LinuxMint, and CumulusLinux are now supported by the `operatingsystem` and `osfamily` facts.

Related issues:

- [FACT-464: Mandrake osfamily is missing in stable/facter-2](https://tickets.puppetlabs.com/browse/FACT-464)

- [FACT-465: LinuxMint support is missing in facter stable/facter-2](https://tickets.puppetlabs.com/browse/FACT-465)

- [FACT-451: Cumulus Linux distro detection needs to be ported to facter-2](https://tickets.puppetlabs.com/browse/FACT-451)

### Fixes for GCE/EC2 Facts

This release fixes a few bugs that were preventing Amazon EC2 and Google Compute Engine facts from loading properly on those platforms.

Related issues:

- [FACT-185: No EC2 facts shown on newly-built Amazon Linux host](https://tickets.puppetlabs.com/browse/FACT-185)

- [FACT-335: Revisit how facter detects GCE instances](https://tickets.puppetlabs.com/browse/FACT-335)

### Windows Fixes

- [FACT-567: Support Bundler workflow on x64](https://tickets.puppetlabs.com/browse/FACT-567)

- [FACT-482: processor.rb crashes Facter within MCollective on MS Windows](https://tickets.puppetlabs.com/browse/FACT-482)

- [FACT-570: Remove windows-pr as a Windows gem dependency](https://tickets.puppetlabs.com/browse/FACT-570)

- [FACT-550: Specs are broken on windows due to unvendoring CFPropertyList](https://tickets.puppetlabs.com/browse/FACT-550)

### Solaris Fixes

- [FACT-197: processorcount counting CPU cores on Solaris](https://tickets.puppetlabs.com/browse/FACT-197)

- [FACT-337: facter/master on solaris 11: "Caught recursion on virtual"](https://tickets.puppetlabs.com/browse/FACT-337)

### Miscellaneous Fixes

- [FACT-179: fqdn Fact returns nil when hostname or domain are nil](https://tickets.puppetlabs.com/browse/FACT-179)

- [FACT-353: some facts do not work with locales set](https://tickets.puppetlabs.com/browse/FACT-353)

- [FACT-429: facter fails on smartos when dmidecode returns non-utf8 strings.](https://tickets.puppetlabs.com/browse/FACT-429)

- [FACT-459: MTU interface facts not being reported on Archlinux.](https://tickets.puppetlabs.com/browse/FACT-459)

- [FACT-593: Facter assumes that route is in the path](https://tickets.puppetlabs.com/browse/FACT-593)

- [FACT-231: PR (608): Fix to Virtual Machine detection on Darwin - keeleysam](https://tickets.puppetlabs.com/browse/FACT-231)

- [FACT-247: Support netmask fact on AIX](https://tickets.puppetlabs.com/browse/FACT-247)

- [FACT-190: couldn't find HOME environment --expanding '~/.facter/facts.d'](https://tickets.puppetlabs.com/browse/FACT-190)

- [FACT-471: Swap size reported as 0 for SmartOS zone](https://tickets.puppetlabs.com/browse/FACT-471)

- [FACT-476: Make the 'processor' fact for OpenBSD consistent with other systems](https://tickets.puppetlabs.com/browse/FACT-476)
