---
layout: default
title: "Facter 3.0: Release Notes"
---

This page documents the history of the Facter 3.0 series. (Previous version: [Facter 2.4 release notes](../2.4/release_notes.html).)

Facter 3.1.0
-----

Released September 14, 2015.

Shipped in puppet-agent version: 1.2.4.

Facter 3.1.0 fixes several bugs and introduces support for OpenBSD and Solaris 10.

For JIRA issues related to Facter 3.1.0, see:

- [Fixes for Facter 3.1.0](https://tickets.puppetlabs.com/issues/?filter=15431)
- [Introduced in Facter 3.1.0](https://tickets.puppetlabs.com/issues/?filter=15429)

### New Supported Platforms: OpenBSD and Solaris 10

Facter 3.1.0 supports OpenBSD, as well as Solaris 10 on both x86 and SPARC systems.

Facter 3.1.0 also reports Solaris-specific LDom facts previously supported by Facter 2 and includes the new `ldom` mapped fact.

- [FACT-927](https://tickets.puppetlabs.com/browse/FACT-927): Facter 3 Solaris Support
- [FACT-910](https://tickets.puppetlabs.com/browse/FACT-910): Solaris is missing the LDom facts
- [FACT-1148](https://tickets.puppetlabs.com/browse/FACT-1148): Port Facter to OpenBSD

### Feature: Improve Cisco NX-OS `family` and `release` Fact Reporting

Facter 3.1.0 adds support for reporting a NX-OS guestshell's native family in the `family` fact, and its minor release in the `release` fact.

- [FACT-1138](https://tickets.puppetlabs.com/browse/FACT-1138)

### REGRESSION FIX: Improve Handling of Non-Printable ASCII Characters in Disk UUIDs

Facter 3.0.2 did not properly encode non-printable ASCII data in `libblkid` output on Linux, resulting in invalid UTF-8 code sequence errors when handled in Puppet. Facter 3.1.0 resolves this issue.

- [FACT-1172](https://tickets.puppetlabs.com/browse/FACT-1172)

### FIX: Improve Handling of Invalid Locales

When running Facter 3 with an invalid locale setting, Facter would abort with an unhelpful error message. Facter 3.1.0 resolves this issue by falling back to the "C" locale if the LANG or LC-related environment variables are not set to a supported locale.

- [FACT-1123](https://tickets.puppetlabs.com/browse/FACT-1123)

### FIX: Improve Handling of Invalid Bytes in DMI Data

When interpreting BIOS data containing non-printable bytes, previous versions of Facter produced invalid character sequences. Facter 3.1.0 resolves this issue by replacing invalid characters with a dot (`.`).

- [FACT-1140](https://tickets.puppetlabs.com/browse/FACT-1140)

### REGRESSION FIX: Restore Docker support for `virtual` and `is_virtual` facts.

In Docker containers run on systemd-based Linux hosts, such as CentOS 7, previous versions of Facter might be unable to accurately report the `virtual` and `is_virtual` facts. Facter 3.1.0 resolves this issue.

- [FACT-704](https://tickets.puppetlabs.com/browse/FACT-704)

### REGRESSION FIX: Fix `productname` Fact Reporting on CentOS 5

Facter 3.0.0 incorrectly reported the `productname` fact on CentOS 5 with Linux kernels before version 2.6.23. Facter 3.1.0 resolves this issue.

- [FACT-1137](https://tickets.puppetlabs.com/browse/FACT-1137)

### REGRESSION FIX: Fix `partitions` Fact Reporting on CentOS 4 and 5, SLES 10

Facter 3.0.0 could not report the `partitions` fact on CentOS 4 and 5, and SUSE Linux Enterprise Server 10. Facter 3.1.0 resolves this issue.

- [FACT-1152](https://tickets.puppetlabs.com/browse/FACT-1152)

### REGRESSION FIX: Remove Trailing Dot from `fqdn` Fact

Facter 3.0.0 reintroduced a previously fixed bug that included the trailing dot (`.`) in a search path from `/etc/resolv.conf`---such as `domain www.example.com.`---when `/etc/hosts` doesn't contain an entry for the local host. Facter 3.1.0 resolves this issue.

- [FACT-1169](https://tickets.puppetlabs.com/browse/FACT-1169)

### FIX: Resolve Intermittent "Failed to Associate Process with Job Object" Errors on Windows

When running previous versions of Facter on Windows in job groups that prohibit detaching child processes, it could fail with an error when trying to attach a child processes to its own job group. Facter 3.1.0 resolves this issue.

- [FACT-1128](https://tickets.puppetlabs.com/browse/FACT-1128)

### REGRESSION FIX: Fix Space Handling in Facter Execute Methods on Windows

When expanding commands passed to Facter execute methods, such as `Facter::Util::Resolution#exec`, Facter 3 did not properly handle spaces on Windows. Facter 3.1.0 resolves this issue.

- [FACT-1158](https://tickets.puppetlabs.com/browse/FACT-1158)

### REGRESSION FIX: Restore Colored Output on Windows

Facter 3.0.0 did not support colored output on Windows. Facter 3.1.0 resolves this issue.

- [FACT-1047](https://tickets.puppetlabs.com/browse/FACT-1047)

### FIX: Improve Resource Use when Requesting Facts from the Ruby API

When requesting a fact from the [Ruby API](./fact_overview.html), Facter converts the native representation of the fact's value to a Ruby object. This conversion should be cached so that subsequent requests for the same fact use the cached conversion. However, a bug prevented caching and a new object was allocated on each request, causing needless garbage for Ruby's garbage collector. Facter 3.1.0 resolves this issue.

- [FACT-1133](https://tickets.puppetlabs.com/browse/FACT-1133)

### REGRESSION FIX: Avoid Reporting Link-Local IPv6 Addresses if a Valid Address is Available

When reporting the `networking` fact, Facter 3.0.0 would report the link-local (scope:link) IPv6 address as the interface's address, even if it has a valid (scope:global) address. Facter 3.1.0 resolves this issue by always reporting the scope:global address if it exists.

- [FACT-1150](https://tickets.puppetlabs.com/browse/FACT-1150)

### FIX: Report Logical Threads on AIX

Facter 3.0.0 would report only physical processor cores on AIX systems. On other operating systems, Facter reports physical cores and logical threads. Facter 3.1.0 resolves this issue by reporting both cores and threads on AIX systems.

- [FACT-970](https://tickets.puppetlabs.com/browse/FACT-970)

### Feature: Added 'noatime' Option to `mountpoints` Fact

Facter now reports the 'noatime' option in the `mountpoints` fact when it is set for a filesystem.

- [FACT-1118](https://tickets.puppetlabs.com/browse/FACT-1118)

### REGRESSION FIX: Create `rubysitedir`

The `puppet-agent` package that installs Facter 3.0.0 did not create the `rubysitedir` pointed to by the `rubysitedir` fact. The `puppet-agent` 1.2.3 update resolves this issue.

- [FACT-1154](https://tickets.puppetlabs.com/browse/FACT-1154)

