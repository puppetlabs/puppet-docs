---
layout: default
title: "Facter 2.3: Release Notes"
description: "Facter release notes for all 2.3 versions"
---

This page documents the history of the Facter 2.3 series. (Elsewhere: release notes for [Facter 2.2](../2.2/release_notes.html), [Facter 2.1](../2.1/release_notes.html), and [Facter 2.0](../2.0/release_notes.html)).

Facter 2.3.0
-----

Facter 2.3.0 is a backward-compatible features and fixes release in the Facter 2 series.

It doesn't add any new facts, but it adds new resolutions for several operating systems, expands support for some existing facts, and makes several facts return a more appropriate data type. It also fixes some bugs.


### New or Improved OS Support

Facter now has useful `os`, `operatingsystem`, `osfamily`, and `operatingsystemrelease` values for Manjaro Linux (a newish variant of Arch Linux) and Arista EOS (which runs on Arista network equipment).

We've also fixed the OS version numbers for Windows 8.1 and Windows 10.

* [FACT-690: Add manjaro linux to the operatingsystem fact](https://tickets.puppetlabs.com/browse/FACT-690)
* [FACT-728: OS release values not correctly reported for Windows kernel versions 6.3.x or 6.4.x](https://tickets.puppetlabs.com/browse/FACT-728)
* [FACT-727: Provide meaningful operating system fact values for Arista EOS](https://tickets.puppetlabs.com/browse/FACT-727)

### Integer and Boolean Data Types for Several Facts

Facter now returns the following facts as their actual boolean or integer values, instead of converting them into strings:

* `activeprocessorcount`
* `is_virtual`
* `mtu_<INTERFACE>`
* `physicalprocessorcount`
* `processorcount`
* `selinux_enforced`
* `selinux`
* `sp_number_processors`
* `sp_packages`

(We initially merged a similar change for some floating point values, but backed it out due to a bug with JSON under Ruby 1.8. We're tracking a fix for that as [FACT-723](https://tickets.puppetlabs.com/browse/FACT-723).)

* [FACT-695: Facter should return correct data types](https://tickets.puppetlabs.com/browse/FACT-695)

### Virtualization Data Improvements

OpenStack supports the same per-instance information as Amazon EC2, but the EC2 facts weren't working on OpenStack VMs. This is now fixed.

Also, now the `virtual` fact can more reliably tell when a system is running under KVM.

* [FACT-694: ec2 fact doesn't work for openstack with kvm as it is restricted for xen](https://tickets.puppetlabs.com/browse/FACT-694)
* [FACT-700: Detect KVM even when generic CPU Model Name is used.](https://tickets.puppetlabs.com/browse/FACT-700)

### An IPv6 Bug Fix

Facter tries to exclude link-local IP addresses from its network facts, since they aren't very useful for configuration management.

Link-local IPv6 addresses start with the digits `fe80`, but due to a faulty regex, Facter was excluding addresses that contained those digits _anywhere_ instead of just at the start. This has been fixed.

* [FACT-680: ipaddress6.rb will ignore all addresses with fe80 in them, not just link-local ones](https://tickets.puppetlabs.com/browse/FACT-680)

### Solaris Bug Fixes

The `uptime` facts weren't working on Solaris when the GNU utils were installed. This is now fixed.

* [FACT-658: facter doesn't parse gnu uptime output](https://tickets.puppetlabs.com/browse/FACT-658)

### OpenBSD Bug Fixes

OpenBSD now gets the `processors['speed']` sub-fact that other platforms already had.

* [FACT-685: Implement processors['speed'] for OpenBSD](https://tickets.puppetlabs.com/browse/FACT-685)

### Silencing Noisy Error Messages

We've silenced some unnecessary error messages on Solaris, on Xenserver VMs, and on systems where the raw DMI data isn't readable.

* [FACT-656: facter generates error on Solaris kernel zone due to prtdiag](https://tickets.puppetlabs.com/browse/FACT-656)
* [FACT-706: Rackspace facts trigger error on xenserver VMs](https://tickets.puppetlabs.com/browse/FACT-706)
* [FACT-719: facter doesn't cope with /sys/firmware/dmi/entries/1-0/raw not readable](https://tickets.puppetlabs.com/browse/FACT-719)
