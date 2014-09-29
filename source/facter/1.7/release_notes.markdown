---
layout: default
title: Facter 1.7 Release Notes
description: Facter release notes for all 1.7 versions
---

This page documents the history of the Facter 1.7 series.

Facter 1.7.6
-----

Released June 16, 2014.

Facter 1.7.6 is a security fix release in the 1.7 series. It has no other bug fixes or new features.

### Security Fixes

[CVE-2014-3248]: http://puppetlabs.com/security/cve/CVE-2014-3248

#### [CVE-2014-3248 (An attacker could convince an administrator to unknowingly execute malicious code on platforms with Ruby 1.9.1 and earlier)][CVE-2014-3248]

When running on Ruby 1.9.1 or earlier, previous versions of Facter would load Ruby source files from the current working directory. This could lead to the execution of arbitrary code.

Facter 1.7.5
-----

Facter 1.7.5 is a bug fix release in the 1.7 series. It fixes two issues with the packaged installer on OS X 10.9 and adds support for Red Hat Enterprise Linux 7.

### Support for Red Hat Enterprise Linux 7

Facter now supports RHEL 7, although it is currently limited to x86_64.

### Support for OS X 10.9

**Facter DMG packages on OSX will attempt to load Facter from rbenv PATH and fail**

The Facter DMG package on OSX was identifying the path to ruby with `/usr/bin/env ruby`, which would cause it to load Facter from the wrong path if rbenv was installed. The package now uses `/usr/bin/ruby`. 

[FACT-182: Facter Does not run on OS X 10.9 Mavericks](https://tickets.puppetlabs.com/browse/FACT-182)

Previously, Facter would not run on OS X 10.9 when installed from the pre-built package, although installing through RubyGems would still work. Now, it runs properly either way.

### Miscellaneous Fixes

[FACT-82: Force ASCII-8BIT encoding on raw data in property lists](https://tickets.puppetlabs.com/browse/FACT-82)

Facter now forces ASCII-8BIT encoding when reading from property lists whenever possible, which allows it to read strings encoded in binary plists. This fix primarily affects OS X Mavericks.


Facter 1.7.4
-----

Facter 1.7.4 is a bug fix release in the 1.7 series.

### External Fact Fixes

This release fixes several issues related to external facts:

[Bug #22944: External facts are evaluated many times](https://projects.puppetlabs.com/issues/22944)

Facter was evaluating each external fact several times per run, which could cause significant slowdowns. This is now fixed, and Facter will load each external fact once.


[Bug #22349: Facter fails to run as a non-root user when /etc/facter/facts.d is not readable](https://projects.puppetlabs.com/issues/22349)

When running as a non-root user, Facter will now load external facts from a `.facter/facts.d/` directory in the current user's home directory. This works on both Windows and \*nix. (Prior to this fix, Facter would try to load external facts from the system-wide external facts directory, and would bail with an error if that directory wasn't readable.)

[Bug #22622: Facter (and Puppet) broken when executable external facts return no output](https://projects.puppetlabs.com/issues/22622)

Facter was making a bad assumption that the output of an executable external fact would always consist of at least one line of text. What this fix presupposes is... maybe it doesn't??


Maint: Do not execute com, cmd, exe, or bat files if not on windows

In preparation for pluginsync support for external facts, Facter needed a bit of defense for situations where Windows external facts may be present on non-Windows systems.


### Windows Fixes

[Bug #22619: Error when NetConnectionId is missing on NetworkAdapter](https://projects.puppetlabs.com/issues/22619)

This was a regression in Facter 1.7.3 --- Facter would fail and quit on systems where a network adapter was configured in a specific way.


[Bug #23368: Executable external facts fail on Windows 2003](https://projects.puppetlabs.com/issues/23368) 

This was a problem with file paths containing a space, which included the default directory for external facts under Windows 2003.

### Miscellaneous Fixes

[Bug #15586: 'facter --help' does not work with Ruby 1.9.3](https://projects.puppetlabs.com/issues/15586)

Facter was using an Rdoc feature that went away, so we replaced it with something else. You can now get help on the command line when running Facter under Ruby 1.9.3.


[Bug #22322: facter should suppress stderr from "swap" commands on Solaris](https://projects.puppetlabs.com/issues/22322)

This was causing noisy logging on Solaris.

[Bug #22334: Facter outputs information to stderr regardless of whether --debug is enabled](https://projects.puppetlabs.com/issues/22334)

This was causing noisy logging everywhere.

### Fact Resolution Fixes (Various OSes)

This release fixes several bugs where facts reported incorrect values on certain operating systems.

[Bug #21604: Xen virtual fact doesn't work on Windows](https://projects.puppetlabs.com/issues/21604) 

[Bug #16081: Facter reports bogus arch on AIX](https://projects.puppetlabs.com/issues/16081)

[Bug #12504: operatingsystemrelease doesn't work for Ubuntu LTS 12.04](https://projects.puppetlabs.com/issues/12504)

[Bug #18215: processorcount counting CPU cores on Solaris](https://projects.puppetlabs.com/issues/18215)

[Bug #20739: processorX facts fail on HP superdome servers](https://projects.puppetlabs.com/issues/20739)

[Bug #20994: memoryfree and memorysize facts are set to 0 on AIX](https://projects.puppetlabs.com/issues/20994)

[Bug #22844: The 'virtual' and 'is_virtual' facts are incorrect for Windows guests hosted on kvm](https://projects.puppetlabs.com/issues/22844)

[Bug #22789: is_virtual incorrectly shows true for vserver_host](https://projects.puppetlabs.com/issues/22789)


### Testing Fixes and Administrivia

[Refactor #22651: add fixture access methods for example /proc/cpuinfo files](https://projects.puppetlabs.com/issues/22651)

[Bug #22238: Remove Fedora 17 from build_defaults.yaml](https://projects.puppetlabs.com/issues/22238)

[Bug #23135: Update Facter Master Windows/Solaris jobs to use vcloud.](https://projects.puppetlabs.com/issues/23135)


Facter 1.7.3
-----

### Windows Executable External Facts (#22077)

Facter on Windows now supports generating external facts from
executables (.exe, .com, .bat, .ps1). Text-based external facts (.txt) have been supported since 1.7.0. See [the custom facts guide](/facter/1.7/custom_facts.html#executable-facts-----windows) for more information.

### Windows IP related Facts (#12116, #16665, #16668, #21518)

Facter on Windows used to gather IP related facts using `netsh`, which
did not work reliably on 2003,
due to a dependency on the Routing and Remote Access service, nor did
it work on non EN_US systems.

Version 1.7.3 has been updated to use WMI, which resolves these
issues. It also adds the `ipaddress6`
fact on systems where this is available.

### Fedora 19 Support (#21762)

Facter packages are now available for Fedora 19.


Facter 1.7.2
-----

### (#14522) Invalid byte sequence message for virtual fact on Solaris 10 x86_64

The previous attempt fix this issue did not handle the case where the data being read from /proc/self/status was already UTF-8 encoded, resulting in 'Could not retrieve virtual: invalid byte sequence in US-ASCII' messages to still occur.


### (#19764) Linux ipaddress not captured according to documentation

Previously, if the ipconfig command listed the loopback address first, then facter on linux would report the ipaddress fact as nil. Now, facter will continue looking and report on the first non 127.0.0.0/8 subnetted IP it finds.


### (#20229) Network facts not working on Archlinux with net-tools 1.60

Previously, the ipconfig command with net-tools 1.60 output the netmask differently causing facter's regular expression matching to fail. As a result, the global netmask and per-interface netmask_* facts were nil on Archlinux.


### (#20236) Refactor the virtual fact

Previously, if Facter executed lspci and was unable to determine the virtual platform from the output, dmidecode wass never consulted. Now dmidecode is always consulted regardless of whether lspci is present or not.


### (#20915) Invalid byte sequence message for virtual fact on Linux

Previously, Facter was reading DMI entries from sysfs and interpreting it as an encoded string, resulting in 'Could not retrieve virtual: invalid byte sequence in US-ASCII' messages to occur. Now, Facter reads the data as binary.


### (#20938) Domain facter print spurious warnings to stderr

Previously, if the host and domain information of a system was wrong, then Facter would output warnings to stderr as a result of executing hostname and dnsdomainname commands. Now Facter suppresses these warnings.


### (#20321) Facter::Util::Resolution::exec should be more descriptive when complaining about shell built-ins

Previously, if Facter output a deprecation warning about shell builtins on Windows, it did not specify which command triggered the problem. Now Facter includes the command that triggered the warning.

Facter 1.7.1
-----

### (#20301) Handle different error in ruby 1.9

The NumberOfLogicalProcessor property of the Win32_Processor WMI class
does not exist in the base win2003 install. Previously, we were trying
to access the property, and then catching the resulting error if the
property did not exist.

In ruby 1.8, it would raise a RuntimeError, but in ruby 1.9, it raises a
StandardError, causing the fact to blow up on ruby 1.9.

This commit checks to see if the process object responds to that method,
and only then does it try to call it.

Facter 1.7.0
-----

### External Facts

It's now possible to create external facts with structured text (e.g. YAML,
JSON, or a Facter-specific plaintext format) or with a script that returns
fact names and values in a specific format (e.g. Ruby or Perl). Please see
the custom facts guide for a detailed explanation and caveats.

### New `on_flush` DSL method

Also new in Facter 1.7 is the on_flush DSL method, usable when defining
new custom facts. This feature is designed for those users who are
implementing their own custom facts.

The on_flush method allows the fact author to register a callback Facter
will invoke whenever a cached fact value is flushed. This is useful to keep
a set of dynamically generated facts in sync without making lots of
expensive system calls to resolve each fact value.

Please see the solaris_zones fact for an example of how the on_flush
method is used to invalidate the cached value of a model shared by
many dynamically generated facts.
