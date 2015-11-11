---
layout: default
title: "Facter 3.1: Release Notes"
---

[puppet-agent]: /puppet/4.2/reference/about_agent.html

This page documents the history of the Facter 3.1 series. (Previous version: [Facter 3.0 release notes](../3.0/release_notes.html).)
## Facter 3.1.2

Released November 12, 2015.

Shipped in [puppet-agent][] version 1.3.0.

Facter 3.1.2 is a bug fix release in the Facter 3.1 series.

* [Fixes for Facter 3.1.2](https://tickets.puppetlabs.com/issues/?filter=16011)

### FIX: Correctly Report OSX Versions

Facter was incorrectly omitting a "point release" part of the full version of major releases of the OSX operating system when the point release is "0". For major new releases like "10.11.0", Facter was reporting this version as "10.11". For "10.11.1", Facter correctly reports "10.11.1". This has been addressed so that Facter consistently reports the full version (e.g. "10.11.0") even if the "point release" part of the version number is "0".

* [FACT-1267](https://tickets.puppetlabs.com/browse/FACT1267)

### FIX: Missing Required File

The tarball for Facter 3.1.1 failed to include .gemspec.in, which is required for building from source. This has been fixed.

* [FACT-1266](https://tickets.puppetlabs.com/browse/FACT-1266)

### FIX: Custom Structured Facts

Facter supports a command line syntax for querying into structured facts (e.g. "foo.bar" gets the "bar" member of the hash fact "foo"). This only worked with built-in and external facts, and not custom facts written in Ruby. This has been fixed so that the feature works with all facts.

* [FACT-1254](https://tickets.puppetlabs.com/browse/FACT-1254)

### FIX: System dmidecode on Older Linux

On older Linux kernels, Facter falls back to executing dmidecode to retrieve certain built-in facts. Facter was incorrectly using the system's dmidecode, if present, instead of the one that ships with Puppet Agent. This has been corrected so that the system installed with Puppet Agent is preferred.

* [FACT-1241](https://tickets.puppetlabs.com/browse/FACT-1254)

## Facter 3.1.1

Released October 29, 2015.

Shipped in [puppet-agent][] version 1.2.7.

Facter 3.1.1 fixes several bugs and adds functionality for AIX 5.3, 6.1, and 7.1, and Solaris 11.

* [Fixes for Facter 3.1.1](https://tickets.puppetlabs.com/issues/?filter=15777)
* [Introduced in Facter 3.1.1](https://tickets.puppetlabs.com/issues/?filter=15771)

### New Platforms: AIX and Solaris 11

Facter 3.1.1 now reports facts on AIX 5.3, 6.1, and 7.1 on PowerPC, and Solaris 11 on x86 and SPARC. Note that there are no open source Puppet all-in-one packages for these platforms; for more information, see the [puppet-agent][] 1.2.7 release notes.

* [FACT-890](https://tickets.puppetlabs.com/browse/FACT-890): Facter 3 AIX Support
* [FACT-549](https://tickets.puppetlabs.com/browse/FACT-549): `serialnumber` Fact for AIX
* [FACT-799](https://tickets.puppetlabs.com/browse/FACT-549): `operatingsystemmajrelease` Has Excessive Detail on AIX
* [FACT-1232](https://tickets.puppetlabs.com/browse/FACT-1232): AIX 5.3 `kernelrelease` and `operatingsystemrelease` Incorrect

### REGRESSION FIX: Running `facter --puppet` Produces Warning and Debug Messages

The legacy `--puppet` flag removed in Facter 3.0.0 was restored in Facter 3.0.2, but Facter's warning and debug messages were not logged when running it with that flag. Facter 3.1.1 resolves this issue.

* [FACT-780](https://tickets.puppetlabs.com/browse/FACT-780)

### Improvement: Reduced Filesystem Activity

Previous versions of Facter 3 would sometimes create and delete cache files it didn't use when probing for block devices via the `libblkid` library, resulting in unnecessary hits for users that audit file system interactions. Facter 3.1.1 now bypasses this cache and probes the system for block devices.

* [FACT-1231](https://tickets.puppetlabs.com/browse/FACT-1231)

### FIX: Correctly Handle Negative Integers

When invoking Facter on the command line to display a custom fact with a negative integer value, previous versions of Facter 3 would incorrectly print the number as a large unsigned value. This only affected command-line output in Facter; the fact's value was still being reported correctly to Puppet. Facter 3.1.1 correctly prints the signed value on the command line.

* [FACT-1235](https://tickets.puppetlabs.com/browse/FACT-1235)

### REGRESSION FIX: Respect Long-form Hostnames to Populate Related facts

Previous versions of Facter 3 did not respect fully-qualified system hostnames, sometimes resulting in an incorrect resolution of the system's domain for the `domain` and `fqdn` facts. This is a regression from Facter 2, which respected fully-qualified hostnames.  Facter 3.1.1 resolves this issue.

* [FACT-1238](https://tickets.puppetlabs.com/browse/FACT-1238)

### FIX: Gracefully Handle Unresolved Requests for Certain Windows DMI Facts

Previous versions of Facter 3 would halt if Windows Management Instrumentation (WMI) failed to resolve the Win32_ComputerSystemProduct's `Name`, or Win32_Bios's `SerialNumber` or `Manufacturer`. If Facter 3.1.1 encounters this, it fails to resolve only those DMI facts and doesn't prematurely halt its fact collection run.

* [FACT-1257](https://tickets.puppetlabs.com/browse/FACT-1257)

## Facter 3.1.0

Released September 14, 2015.

Shipped in [puppet-agent][] version 1.2.4.

Facter 3.1.0 fixes several bugs and introduces support for OpenBSD and Solaris 10.

For JIRA issues related to Facter 3.1.0, see:

* [Fixes for Facter 3.1.0](https://tickets.puppetlabs.com/issues/?filter=15500)
* [Introduced in Facter 3.1.0](https://tickets.puppetlabs.com/issues/?filter=15429)

### New Platforms: OpenBSD and Solaris 10

Facter 3.1.0 supports OpenBSD, as well as Solaris 10 on both x86 and SPARC systems.

Facter 3.1.0 also reports Solaris-specific LDom facts previously supported by Facter 2 and includes the new `ldom` mapped fact.

* [FACT-927](https://tickets.puppetlabs.com/browse/FACT-927): Facter 3 Solaris Support
* [FACT-1148](https://tickets.puppetlabs.com/browse/FACT-1148): Port Facter to OpenBSD

### Feature: Improve Cisco NX-OS `family` and `release` Fact Reporting

Facter 3.1.0 adds support for reporting a NX-OS guestshell's native family in the `family` fact, and its minor release in the `release` fact.

* [FACT-1138](https://tickets.puppetlabs.com/browse/FACT-1138)

### Feature: Networking Fact Includes Address Bindings

The `networking` fact now includes arrays of bound addresses for each network interface (as `networking[interfaces][<INTERFACE>][bindings]` and `...bindings6`).

* [FACT-1233](https://tickets.puppetlabs.com/browse/FACT-1233)

### REGRESSION FIX: Improve Handling of Non-Printable ASCII Characters in Disk UUIDs

Facter 3.0.2 did not properly encode non-printable ASCII data in `libblkid` output on Linux, resulting in invalid UTF-8 code sequence errors when handled in Puppet. Facter 3.1.0 resolves this issue.

* [FACT-1172](https://tickets.puppetlabs.com/browse/FACT-1172)

### FIX: Improve Handling of Invalid Locales

When running Facter 3 with an invalid locale setting, Facter would abort with an unhelpful error message. Facter 3.1.0 resolves this issue by falling back to the "C" locale if the LANG or LC-related environment variables are not set to a supported locale.

* [FACT-1123](https://tickets.puppetlabs.com/browse/FACT-1123)

### FIX: Improve Handling of Invalid Bytes in DMI Data

When interpreting BIOS data containing non-printable bytes, previous versions of Facter produced invalid character sequences. Facter 3.1.0 resolves this issue by replacing invalid characters with a dot (`.`).

* [FACT-1140](https://tickets.puppetlabs.com/browse/FACT-1140)

### REGRESSION FIX: Restore Docker support for `virtual` and `is_virtual` facts.

In Docker containers run on systemd-based Linux hosts, such as CentOS 7, previous versions of Facter might be unable to accurately report the `virtual` and `is_virtual` facts. Facter 3.1.0 resolves this issue.

* [FACT-704](https://tickets.puppetlabs.com/browse/FACT-704)

### REGRESSION FIX: Fix `productname` Fact Reporting on CentOS 5

Facter 3.0.0 incorrectly reported the `productname` fact on CentOS 5 with Linux kernels before version 2.6.23. Facter 3.1.0 resolves this issue.

* [FACT-1137](https://tickets.puppetlabs.com/browse/FACT-1137)

### REGRESSION FIX: Fix `partitions` Fact Reporting on CentOS 4 and 5, SLES 10

Facter 3.0.0 could not report the `partitions` fact on CentOS 4 and 5, and SUSE Linux Enterprise Server 10. Facter 3.1.0 resolves this issue.

* [FACT-1152](https://tickets.puppetlabs.com/browse/FACT-1152)

### REGRESSION FIX: Remove Trailing Dot from `fqdn` Fact

Facter 3.0.0 reintroduced a previously fixed bug that included the trailing dot (`.`) in a search path from `/etc/resolv.conf`---such as `domain www.example.com.`---when `/etc/hosts` doesn't contain an entry for the local host. Facter 3.1.0 resolves this issue.

* [FACT-1169](https://tickets.puppetlabs.com/browse/FACT-1169)

### REGRESSION FIX: Resolve Intermittent "Failed to Associate Process with Job Object" Errors on Windows

When running Facter 3.0 on Windows in job groups that prohibit detaching child processes, it could fail with an error when trying to attach a child process to its own job group. Facter 3.1.0 resolves this issue.

* [FACT-1128](https://tickets.puppetlabs.com/browse/FACT-1128)

### REGRESSION FIX: Fix Space Handling in Facter Execute Methods on Windows

When expanding commands passed to Facter execute methods, such as `Facter::Util::Resolution#exec`, Facter 3 did not properly handle spaces on Windows. Facter 3.1.0 resolves this issue.

* [FACT-1158](https://tickets.puppetlabs.com/browse/FACT-1158)

### REGRESSION FIX: Restore Colored Output on Windows

Facter 3.0.0 did not support colored output on Windows. Facter 3.1.0 resolves this issue.

* [FACT-1047](https://tickets.puppetlabs.com/browse/FACT-1047)

### FIX: Improve Resource Use when Requesting Facts from the Ruby API

When requesting a fact from the [Ruby API](./fact_overview.html), Facter converts the native representation of the fact's value to a Ruby object. This conversion should be cached so that subsequent requests for the same fact use the cached conversion. However, a bug prevented caching and a new object was allocated on each request, causing needless garbage for Ruby's garbage collector. Facter 3.1.0 resolves this issue.

* [FACT-1133](https://tickets.puppetlabs.com/browse/FACT-1133)

### REGRESSION FIX: Avoid Reporting Link-Local IPv6 Addresses if a Valid Address is Available

When reporting the `networking` fact, Facter 3.0.0 would report the link-local (scope:link) IPv6 address as the interface's address, even if it has a valid (scope:global) address. Facter 3.1.0 resolves this issue by always reporting the scope:global address if it exists.

* [FACT-1150](https://tickets.puppetlabs.com/browse/FACT-1150)

### FIX: Report Logical Threads on AIX

Facter 3.0.0 would report only physical processor cores on AIX systems. On other operating systems, Facter reports physical cores and logical threads. Facter 3.1.0 resolves this issue by reporting both cores and threads on AIX systems.

Note that Facter 3.1.0 doesn't yet have full AIX support.

* [FACT-970](https://tickets.puppetlabs.com/browse/FACT-970)

### Feature: Added 'noatime' Option to `mountpoints` Fact

Facter now reports the 'noatime' option in the `mountpoints` fact when it is set for a filesystem.

* [FACT-1118](https://tickets.puppetlabs.com/browse/FACT-1118)

### REGRESSION FIX: Create `rubysitedir`

The `puppet-agent` package that installs Facter 3.0.0 did not create the `rubysitedir` pointed to by the `rubysitedir` fact. The `puppet-agent` 1.2.4 update resolves this issue.

* [FACT-1154](https://tickets.puppetlabs.com/browse/FACT-1154)

