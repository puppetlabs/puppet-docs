---
layout: default
title: Facter 1.7 Release Notes
description: Facter release notes for all 1.7 versions
nav: facter17.html
---

This page documents the history of the Facter 1.7 series.

Facter 1.7.3
-----

### Windows Executable External Facts (#22077)

Facter on Windows now supports generating external facts from
executables (.exe, .com, .bat, .ps1). Text-based external facts (.txt) have been supported since 1.7.0. See
http://docs.puppetlabs.com/guides/custom_facts.html#executable-facts-----windows
for more information.

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
