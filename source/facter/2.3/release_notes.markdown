---
layout: default
title: "Facter 2.3: Release Notes"
description: "Facter release notes for all 2.3 versions"
---

This page documents the history of the Facter 2.3 series. (Elsewhere: release notes for [Facter 2.2](../2.2/release_notes.html), [Facter 2.1](../2.1/release_notes.html), and [Facter 2.0](../2.0/release_notes.html)).

Facter 2.3.0
-----

Facter 2.3.0 is a backward-compatible feature release in the Facter 2 series. It adds two new facts that should improve life for Windows users, and makes PowerShell-based external facts behave more reliably.

This release also adds new resolutions for several operating systems, expands support for some existing facts, and makes several facts return a more appropriate data type. It also fixes some bugs.

### New Fact: `system32`

On Windows systems, Facter now includes [a `system32` fact,](./core_facts.html#system32) whose value is the path to the native `system32` directory. The first Windows Puppet installer that will include this fact is Puppet 3.7.3.

This fact should make it easy to manage system files on any combination of Windows architecture and Puppet architecture, including x64/x64, x86/x86, and x64/x86. (We needed this fact because the `sysnative` alias doesn't exist on all architectures, so there wasn't a reliable one-stop way to refer to the native `system32` directory. See [the Puppet docs about file system redirection][fs_redir] for more details.)

[fs_redir]: /puppet/latest/reference/lang_windows_file_paths.html#file-system-redirection-when-running-32-bit-puppet-on-64-bit-windows

* [FACT-699: Create a fact to report on ruby architecture](https://tickets.puppetlabs.com/browse/FACT-699)


### New Fact: `rubyplatform`

The [new `rubyplatform` fact](./core_facts.html#rubyplatform) reports the value of Ruby's `RUBY_PLATFORM` constant. This value depends on what flavor of Ruby you're using, what kernel Ruby was compiled for, what architecture it was compiled for, and other related info.

This fact can help you work around situations where different Ruby platforms will subtly change Puppet's behavior. (Most notoriously: file system and registry redirection on Windows when running 32-bit binaries on 64-bit systems. Most users' needs should be met by the `system32` fact, but if you're doing something complicated, you can fall back on `rubyplatform` for full control.)

* [FACT-699: Create a fact to report on ruby architecture](https://tickets.puppetlabs.com/browse/FACT-699)

### PowerShell External Facts Now Prefer 64-Bit PowerShell

Previously, if Facter was running in a 32-bit Ruby platform on a 64-bit Windows system, it would always use the 32-bit copy of Windows PowerShell to evaluate [external facts](./custom_facts.html#external-facts). This was bad and unexpected. Now it's fixed, and even 32-bit Facter installs will shell out to the 64-bit PowerShell on x64 Windows systems.

The first Windows Puppet installer that will include this fix is Puppet 3.7.3.

* [FACT-710: powershell external facts should prefer 64-bit powershell](https://tickets.puppetlabs.com/browse/FACT-710)

### New or Improved OS Support

Facter now has useful `os`, `operatingsystem`, `osfamily`, and `operatingsystemrelease` values for Manjaro Linux (a new-ish variant of Arch Linux) and Arista EOS (which runs on Arista network equipment).

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

The `gid` fact was broken on Solaris 10, and Facter 2.2 broke the `operatingsystemmajrelease` fact. Also, the `uptime` facts weren't working on Solaris when the GNU utils were installed.

* [FACT-658: facter doesn't parse gnu uptime output](https://tickets.puppetlabs.com/browse/FACT-658)
* [FACT-683: facter id broken on solaris10 as root](https://tickets.puppetlabs.com/browse/FACT-683)
* [FACT-692: Facter reports operatingsystemmajrelease incorrectly in Solaris 10](https://tickets.puppetlabs.com/browse/FACT-692)

### OpenBSD Bug Fixes

OpenBSD now gets the `processors['speed']` sub-fact that other platforms already had.

* [FACT-685: Implement processors['speed'] for OpenBSD](https://tickets.puppetlabs.com/browse/FACT-685)

### Silencing Noisy Error Messages

We've silenced some unnecessary error messages on OS X Yosemite, Solaris, Xenserver VMs, and systems where the raw DMI data isn't readable.

* [FACT-654: facter ldom.rb generate virtinfo usage error on Solaris 11.2 x86 boxes](https://tickets.puppetlabs.com/browse/FACT-654)
* [FACT-656: facter generates error on Solaris kernel zone due to prtdiag](https://tickets.puppetlabs.com/browse/FACT-656)
* [FACT-706: Rackspace facts trigger error on xenserver VMs](https://tickets.puppetlabs.com/browse/FACT-706)
* [FACT-719: facter doesn't cope with /sys/firmware/dmi/entries/1-0/raw not readable](https://tickets.puppetlabs.com/browse/FACT-719)
* [FACT-724: Warnings about X86PlatformPlugin on OS X 10.10 Yosemite](https://tickets.puppetlabs.com/browse/FACT-724)
