---
layout: default
title: "Facter 2.0: Release Notes"
description: "Facter release notes for all 2.0 versions"
---

This page documents the history of the Facter 2.0 series.

Facter 2.0.2
-----

Released June 10, 2014.

Facter 2.0.2 is a security release in the Facter 2 series. It has no other bug fixes or new features.

### Security Fixes

[CVE-2014-3248]: http://puppetlabs.com/security/cve/CVE-2014-3248

#### [CVE-2014-3248 (An attacker could convince an administrator to unknowingly execute malicious code on platforms with Ruby 1.9.1 and earlier)][CVE-2014-3248]

When running on Ruby 1.9.1 or earlier, previous versions of Facter would load Ruby source files from the current working directory. This could lead to the execution of arbitrary code.

Facter 2.0.1
-----

Released April 1, 2014. (RC1: February 28; RC2: March 12; RC3: March 25; RC4: March 28.)

Facter 2.0.1 is the first release in the Facter 2 series. (See the [note below](#facter-200) about Facter 2.0.0.)

### More Return Types and Structured Facts

Facts are no longer limited to strings; they can now return any of the following types: Integer, Float, TrueClass, FalseClass, NilClass, String, Array, Hash. The last two are especially significant -- facts can now combine associated pieces of information into a single data structure. Facter 2.0.1 doesn't include any structured facts yet, but you can start writing your own [custom structured facts](fact_overview.html#writing-structured-facts) immediately.

### Aggregate Resolutions

Facter 2 also adds **aggregate resolutions**, which allow you to resolve a fact in multiple steps rather than all in one `setcode` statement. Aggregate resolutions are great for structured facts, but you can also use them to resolve complex flat facts as well. See [Writing Facts With Aggregate Resolutions](fact_overview.html#writing-facts-with-aggregate-resolutions) for more details and examples.

Related issues:

- [FACT-237: Allow fact resolutions to be built up piece-wise](https://tickets.puppetlabs.com/browse/FACT-237)

- [FACT-239: Expose different resolution types in DSL](https://tickets.puppetlabs.com/browse/FACT-239)

### Pluginsync for External Facts

[External facts](./custom_facts.html#external-facts) have been around since Facter 1.7, but there hasn't been a way to effectively include them in modules until now. If you're using Puppet 3.4 or later with Facter 2.0.1, you can now include external facts in `<MODULEPATH>/<MODULE>/facts.d/` and they will be distributed to agent nodes.

- [FACT-194: Merge external facts support to Facter 2](https://tickets.puppetlabs.com/browse/FACT-194)

### Breaking Changes

Removed facts:

- `selinux_mode` has been removed since it was duplicated by `selinux_config_policy`.
- `memorytotal` has been removed since it was duplicated by `memorysize`.

API changes:

- Fact values can now only be accessed using the `Facter.value` method. See [Using other facts](custom_facts.html#using-other-facts) in the Custom Facts Walkthrough for more information and examples. Facts that refer to other facts with the deprecated `Facter.fact_name` notation will have to be updated.
- Previously, Facter would treat the empty string as `nil` (a falsey value). Because Facter 2 allows resolutions to return `nil` directly, the empty string is now treated just like any other string (i.e., truthy). Custom facts that relied on this behavior in the past will need to be updated. The only exception is the string form of the `setcode` method (e.g., `setcode 'lsb_release -a'`), which still treats the empty string (or a non-zero exit code) as `nil`.

### Deprecated Methods

- The `Facter.execution.exec` method is deprecated and can be replaced with `Facter.execution.execute`. ([FACT-409](https://tickets.puppetlabs.com/browse/FACT-409))

### Other Features

[FACT-134: Perform basic sanity checks on Facter output](https://tickets.puppetlabs.com/browse/FACT-134)

Facter now does sanity checking on the output of facts. Facter previously assumed that all facts would be of type String but did not enforce this; Facter now validates that facts are one of (Integer, Float, TrueClass, FalseClass, NilClass, String, Array, Hash).

[FACT-341: Windows operatingsystemrelease support](https://tickets.puppetlabs.com/browse/FACT-341)

On Windows, the `operatingsystemrelease` fact now returns `XP`,`2003`, `2003 R2`, `Vista`, `2008`, `7`, `2008 R2`, `8`, or `2012`, depending on the version reported by WMI.

### Improvements

[FACT-94: Unvendor CFPropertyList](https://tickets.puppetlabs.com/browse/FACT-94)

Removes vendored code for CFPropertyList in favor of treating it as a separate dependency and managing it with Rubygems.

[FACT-163: Fact loading logic is overly complicated](https://tickets.puppetlabs.com/browse/FACT-163)

In Facter 1.x the fact search path would be recursively loaded, but only when using Facter via the command line. In Facter 2.0 only fact files at the top level of the search path will be loaded, which matches the behavior when loading facts with Puppet.

[FACT-266: Backport Facter::Util::Confine improvements to Facter 2](https://tickets.puppetlabs.com/browse/FACT-266)

Adds several improvements to `Facter::Util::Confine`, including the ability to confine a fact to a block.

[FACT-321: Remove deprecated code for 2.0](https://tickets.puppetlabs.com/browse/FACT-321)

Code that had previously been marked deprecated has now been removed.

[FACT-322: Remove special casing of the empty string](https://tickets.puppetlabs.com/browse/FACT-322)

Previous versions of Facter would interpret an empty string (and only an empty string) as `nil`. Now that facts can return more than just strings (i.e., they can directly return `nil`), empty strings no longer have this special case.

[FACT-186: Build Windows-specific gem](https://tickets.puppetlabs.com/browse/FACT-186)

Adds Windows-specific gem dependencies for Facter 2.

[FACT-207: Remove deprecated ldapname](https://tickets.puppetlabs.com/browse/FACT-207)

Removes all instances of `ldapname`, completing its deprecation.

[FACT-242: Remove Fedora 18 from default build targets](https://tickets.puppetlabs.com/browse/FACT-242)

Fedora 18 has reached end-of-life and will no longer be supported. This release removes F18 as a build target.

[FACT-272: Update Facter man page for 2.0](https://tickets.puppetlabs.com/browse/FACT-272)

The man page for Facter 2 now includes the new command line options.

[FACT-342: Add Ubuntu 14.04 (Trusty Tahr) support](https://tickets.puppetlabs.com/browse/FACT-342)

This release adds spec and acceptance tests for Ubuntu 14.04, also known as Trusty Tahr.

[FACT-447: Remove Ruby 1.8.5 support](https://tickets.puppetlabs.com/browse/FACT-447)

Earlier versions of Facter included support for Ruby 1.8.5, which required a number of monkey patches for compatibility. As of Facter 2.0.1 RC4, the minimum supported version of Ruby is 1.8.7.

### Bug Fixes

[FACT-155: operatingsystemrelease in Solaris 10 behaves differently from Solaris 11](https://tickets.puppetlabs.com/browse/FACT-155)

On Solaris 10, the operatingsystemrelease fact would incorrectly be set to the update version. This release corrects the bug.

[FACT-202: Fix undefined path in macaddress.rb](https://tickets.puppetlabs.com/browse/FACT-202)

One of the possible resolutions for the `macaddress` fact would incorrectly return `nil`. This release fixes the bug.

[FACT-351: undefined method 'ipaddress' for Facter:Module](https://tickets.puppetlabs.com/browse/FACT-351)

This bug would cause the netmask fact to fail on Darwin under some circumstances. This release fixes the bug.

[FACT-356: vlan fact returns the empty string when undefined](https://tickets.puppetlabs.com/browse/FACT-356)

[FACT-357: lsb facts return the empty string when undefined](https://tickets.puppetlabs.com/browse/FACT-357)

These two bugs were caused by [FACT-322](https://tickets.puppetlabs.com/browse/FACT-322) (remove special casing of the empty string). Previous versions of facter would ignore facts that returned `""`, and the LSB and VLAN facts depended on this behavior to ensure that they wouldn't appear on systems where they weren't relevant. Once the special casing of the empty string was removed in Facter 2.0.1, facts that returned `""` would show up in facter's output as `""`, rather than not showing up at all. The LSB and VLAN facts have been updated to fix this bug.


Facter 2.0.0
-----

For historical reasons, Facter 2.0.0 was never released. Facter 2.0.1 is the first release in the Facter 2 series.

In May 2012, several release candidates were published for a Facter 2.0.0 release, using code that had diverged from the 1.6 series. After testing it, the Puppet community and developers decided that this code wasn't yet usable and the release was canceled, in favor of continuing work that became the Facter 1.7 series.

Since the 2.0.0rc1 tag in the Facter repo was already occupied by that canceled release, and since issuing a RC5 out of nowhere might have been confusing, we decided to go directly to 2.0.1 instead.
