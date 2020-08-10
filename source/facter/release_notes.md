---
layout: default
title: "Facter 3.1: Release notes"
---

[puppet-agent 1.2.x]: /puppet/4.2/reference/about_agent.html
[puppet-agent 1.3.x]: /puppet/4.3/reference/about_agent.html
[puppet-agent 1.4.x]: /puppet/4.4/reference/about_agent.html
[puppet-agent 1.5.x]: /puppet/4.5/reference/about_agent.html

This page documents the history of the Facter 3.1 series. If you're upgrading from Facter 2, also review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality.

## Facter 3.1.8

Released June 1, 2016.

Shipped in [`puppet-agent` 1.5.1.][puppet-agent 1.5.x].

Facter 3.1.8 is a bug fix release in the Facter 3.1 series.

### Bug fixes

* [FACT-1416](https://tickets.puppetlabs.com/browse/FACT-1416): Previously, the `solaris_zones` fact was only displaying information about zones which were running. This was fixed, and that fact now includes information about all zones on the system, whether they are running or not.

* [FACT-1409](https://tickets.puppetlabs.com/browse/FACT-1409): Previously, Facter assumed that an inability to initialize locales on common Linux environments was a catastrophic failure. It now continues with a warning.

* [FACT-1408](https://tickets.puppetlabs.com/browse/FACT-1408): In Facter 3, the `productname` fact in Solaris was less detailed than its predecessor in Facter 2. The fact has been updated to use the `prtdiag` command which restores the original level of detail.

## Facter 3.1.7

Released May 17, 2016.

Shipped in [`puppet-agent` 1.5.0][puppet-agent 1.5.x].

Facter 3.1.7 is a minor bug fix release in the Facter 3.1 series.

* [Fixed in Facter 3.1.7](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.1.7%27)
* [Introduced in Facter 3.1.7](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.1.7%27)

### Bug fixes

*[FACT-1387](https://tickets.puppetlabs.com/browse/FACT-1387): Google Cloud Windows instances are now recognized as virtual and will collect GCE metadata.

* [FACT-1375](https://tickets.puppetlabs.com/browse/FACT-1375): Before this fix, `facter ipaddress` could return the address of the wrong network interface when there were routes for 0.0.0.0, with non-zero subnet mask, in addition to the default route. The correct ip address is the address of the interface associated with the interface on the route table entry for the default gateway.

* [FACT-1373](https://tickets.puppetlabs.com/browse/FACT-1373): Previously, if Facter was called from an external fact it would generate endless recursive Facter calls and fork bomb the agent. In order to prevent this, we will now detect recursive calls to evaluate external facts, and if we encounter one we will log a warning and stop evaluating external facts. 

  To do this, we set an environment variable called `INSIDE_FACTER` the first time external facts are evaluated and check this variable before we evaluate external facts to ensure it hasn't been set. It is possible that a user may have their own environment variable called `INSIDE_FACTER` set to true, so anytime we encounter that variable set to true, we log a debug warning.

## Facter 3.1.6

Released April 26, 2016.

Shipped in [`puppet-agent` 1.4.2.][puppet-agent 1.4.x].

Facter 3.1.6 is primarily a Windows bug fix release, however it also includes one improvement, and a few other miscellaneous bug fixes.

### Improvement

#### `facter -h` is the same as `facter --help`

For consistency with other command-line tools, `facter -h` is now equivalent to `facter --help`.

[FACT-1376](https://tickets.puppetlabs.com/browse/FACT-1376)


### Bug fixes: Windows

#### Facter would not serialize large integers in structured facts

This fix corrects a bug in Facter preventing it from properly serializing integers exceeding the 32bit boundary.

[FACT-1364](https://tickets.puppetlabs.com/browse/FACT-1364)


#### Google Cloud instances not recognized as virtual
	
Google Cloud Windows instances are now recognized as virtual, and will collect GCE metadata.

[FACT-1387](https://tickets.puppetlabs.com/browse/FACT-1387)


#### Module level external facts not resolved when using Vagrant

Facter can now resolve external facts across NTFS reparse points.	

[FACT-1276](https://tickets.puppetlabs.com/browse/FACT-1276)

#### Facter falsely reported OpenStack instances virtual as physical

Facter incorrectly reported OpenStack based Windows VMs as not virtual. This fix changes them to report as virtual, with the label 'openstack'.	

[FACT-1043](https://tickets.puppetlabs.com/browse/FACT-1043)

### Bug fixes: Misc

#### Regression of `Facter::Util::Resolution.exec` not setting `$?.exitstatus` based on exec result

`Facter::Util::Resolution.exec` will now set the Ruby `$?` exit status variable.	

[FACT-1284](https://tickets.puppetlabs.com/browse/FACT-1284)


#### Facter failed when locale files were missing for a specified locale on CentOS 7	

An issue where Facter failed in some invalid locale environments with `failed to initialize logging system due to a locale error: Invalid or unsupported charset:ANSI_X3.4-1968` has been addressed; it should now always fall back to a C locale.

[FACT-1392](https://tickets.puppetlabs.com/browse/FACT-1392)


## Facter 3.1.5

Released March 16, 2016.

Shipped in [`puppet-agent` 1.4.0][puppet-agent 1.4.x].

Facter 3.1.5 is an improvement and bug fix release in the Facter 3.1 series.

* [Fixed in Facter 3.1.5](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27FACT+3.1.5%27)
* [Introduced in Facter 3.1.5](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27FACT+3.1.5%27)

### Improvement: networking.ip fallback

Facter will now consider the 'source' attribute of routing table entries associated with an interface to be an additional address tied to that interface.

* [FACT-1282](https://tickets.puppetlabs.com/browse/FACT-1282)

### FIX: Windows extended characters

In Puppet with Facter 3, using Windows-1252 extended characters such as ö and æ in a user name on Windows would cause an exception to be thrown by Facter. This has been fixed.

* [FACT-1341](https://tickets.puppetlabs.com/browse/FACT-1341)

### FIX: YAML

Previously, Facter 3 YAML output would not quote some strings that YAML 1.1 and 1.2 allow interpreting as other types such as booleans, sexagesimal patterns, and comma-separated lists of integers. These will now be correctly quoted.

* [FACT-1317](https://tickets.puppetlabs.com/browse/FACT-1317)

## Facter 3.1.4

Released January 25, 2016.

Shipped in [`puppet-agent` 1.3.4][puppet-agent 1.3.x].

Facter 3.1.4 is a platform packaging release in the Facter 3.1 series.

* [Fixed in Facter 3.1.4](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27FACT%203.1.4%27)
* [Introduced in Facter 3.1.4](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27FACT%203.1.4%27)

### NEW PLATFORM: Ubuntu Wily 15.10

As of `puppet-agent` 1.3.4, packages are available for Ubuntu Wily 15.10.

## Facter 3.1.3

Released November 30, 2015.

Shipped in [`puppet-agent` 1.3.1][puppet-agent 1.3.x].

Facter 3.1.3 is a bug-fix release in the Facter 3.1 series.

* [Fixed in Facter 3.1.3](https://tickets.puppetlabs.com/issues/?filter=16212)
* [Introduced in Facter 3.1.3](https://tickets.puppetlabs.com/issues/?filter=16213)

### REGRESSION FIX: Report `puppetversion` Fact

We didn't report the `puppetversion` fact when when we restored `facter -p` functionality to Facter 3.0.2. This release restores the fact.

* [FACT-1277](https://tickets.puppetlabs.com/browse/FACT-1277)

## Facter 3.1.2

Released November 17, 2015.

Shipped in [`puppet-agent` 1.3.0][puppet-agent 1.3.x].

Facter 3.1.2 is a bug-fix release in the Facter 3.1 series.

* [Fixed in Facter 3.1.2](https://tickets.puppetlabs.com/issues/?filter=16110)
* [Introduced in Facter 3.1.2](https://tickets.puppetlabs.com/issues/?filter=16111)

### FIX: Correctly Report OS X Versions

Facter incorrectly omitted a "point release" part of the full version of major releases of OS X when the point release is "0". For instance, Facter incorrectly reported major releases like "10.11.0" as "10.11". This has been addressed so that Facter consistently reports the full version number even if the "point release" part of the version number is "0".

* [FACT-1267](https://tickets.puppetlabs.com/browse/FACT-1267)

### FIX: Restore Missing Required File

The tarball for Facter 3.1.1 failed to include `.gemspec.in`, which is required for building from source. This release includes the file.

* [FACT-1266](https://tickets.puppetlabs.com/browse/FACT-1266)

### FIX: Access Members of Custom Structured Facts

Facter supports a command-line syntax for querying structured facts. For example, "os.name" gets the "name" member of the hash fact "os". However, in previous versions of Facter 3 this didn't work with custom facts written in Ruby. This release fixes this behavior to work with all facts.

* [FACT-1254](https://tickets.puppetlabs.com/browse/FACT-1254)

### FIX: System `dmidecode` on Older Linux

On older Linux kernels, Facter falls back to executing `dmidecode` to retrieve certain built-in facts. Previous versions of Facter incorrectly used the system's `dmidecode`, if present, instead of the one that ships with Puppet Agent. This release corrects this behavior to use the version installed with Puppet Agent.

* [FACT-1241](https://tickets.puppetlabs.com/browse/FACT-1254)

## Facter 3.1.1

Released October 29, 2015.

Shipped in [`puppet-agent` 1.2.7][puppet-agent 1.2.x].

Facter 3.1.1 fixes several bugs and adds functionality for AIX 5.3, 6.1, and 7.1, and Solaris 11.

* [Fixed in Facter 3.1.1](https://tickets.puppetlabs.com/issues/?filter=15777)
* [Introduced in Facter 3.1.1](https://tickets.puppetlabs.com/issues/?filter=15771)

### New Platforms: AIX and Solaris 11

Facter 3.1.1 now reports facts on AIX 5.3, 6.1, and 7.1 on PowerPC, and Solaris 11 on x86 and SPARC. Note that there are no open source Puppet all-in-one packages for these platforms; for more information, see the [`puppet-agent` 1.2.7](/puppet/4.2/reference/release_notes_agent.html#puppet-agent-127) release notes.

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

Shipped in [`puppet-agent` 1.2.4][puppet-agent 1.2.x].

Facter 3.1.0 fixes several bugs and introduces support for OpenBSD and Solaris 10.

For JIRA issues related to Facter 3.1.0, see:

* [Fixed in Facter 3.1.0](https://tickets.puppetlabs.com/issues/?filter=15500)
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
