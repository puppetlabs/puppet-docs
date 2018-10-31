---
layout: default
title: "Hiera 1: Release Notes"
---

{% partial /hiera/_hiera_update.md %}

Hiera 1.3.4
-----

Released June 10, 2014.

Hiera 1.3.4 is a security fix release in the Hiera 1.3 series. It has no other bug fixes or new features.

### Security Fix

#### [CVE-2014-3248 (An attacker could convince an administrator to unknowingly execute malicious code on platforms with Ruby 1.9.1 and earlier)](http://www.puppetlabs.com/security/cve/cve-2014-3248/)

Platforms running Ruby 1.9.1 or earlier would load Ruby source files from the current working directory during a Hiera lookup. This could lead to the execution of arbitrary code.

Hiera 1.3.3
-----

Released May 22, 2014.

Hiera 1.3.3 is a backward-compatible performance and fixes release in the 1.3 series. It provides a substantial speed increase for lookups compared to Hiera 1.3.2. This release also adds support for Ubuntu 14.04 (Trusty Tahr) and discontinues support for Fedora 18 and Ubuntu 13.04 (Raring Ringtail).

### Performance Improvements

* [HI-239](https://tickets.puppetlabs.com/browse/HI-239): Backport speed improvement to 1.3.x codebase, resulting in a substantial speed increase in lookups compared to Hiera 1.3.2.

### Operating System Support

* [HI-149](https://tickets.puppetlabs.com/browse/HI-149): Remove Fedora 18 from default build targets
* [HI-236](https://tickets.puppetlabs.com/browse/HI-236): Remove Raring (Ubuntu 13.04) from build_defaults, it is EOL
* [HI-185](https://tickets.puppetlabs.com/browse/HI-185): Add Trusty (Ubuntu 14.04) support

### Bug Fixes

* [HI-232](https://tickets.puppetlabs.com/browse/HI-232): Hiera should conflict/provide/replace ruby-hiera (from Ubuntu)

Hiera 1.3.2
-----

Released February 26, 2014. (RC1: February 11; RC2: February 20.)

Hiera 1.3.2 is a bug fix release in the 1.3 series. It adds packages for Red Hat Enterprise Linux 7, support for deploying to Solaris and Windows vCloud instances, and fixes a bug on Debian.

### RHEL 7 Support

* [HI-179](https://tickets.puppetlabs.com/browse/HI-179): Add RHEL 7 support for Hiera packaging.

### Bug Fixes

* [HI-176](https://tickets.puppetlabs.com/browse/HI-176): Hiera would fail to find the correct ruby binary on Debian when an alternative version was installed. Hiera now uses `/usr/bin/ruby`, which fixes the issue.
* [HI-178](https://tickets.puppetlabs.com/browse/HI-178): Acceptance tests have been added for Solaris and Windows vCloud machines.
* [HI-115](https://tickets.puppetlabs.com/browse/HI-115): Hiera would show an incorrect `recursive_guard` warning if the same variable was interpolated twice in a hierarchy definition, even if the usage was not recursive.

Hiera 1.3.1
-----

Released January 23, 2014. (RC1: December 12, 2013.)

Hiera 1.3.1 is a bug fix release in the 1.3 series. It fixes one bug:

[HI-65](https://tickets.puppetlabs.com/browse/HI-65): Empty YAML files can raise an exception (backported to stable as [HI-71](https://tickets.puppetlabs.com/browse/HI-71))

Hiera 1.3.0
-----

Released November 21, 2013. (RC1: never published; RC2: November 8, 2013.)

Hiera 1.3.0 contains three new features, including Hiera lookups in interpolation tokens. It also contains bug fixes and packaging improvements.

Most of the features contributed to Hiera 1.3 are intended to provide more power by allowing new kinds of value interpolation.

### Feature: Hiera Sub-Lookups from Within Interpolation Tokens

In addition to interpolating variables into strings, you can now interpolate the value of another Hiera lookup. This uses a new lookup function syntax, which looks like `"%{hiera('lookup_key')}"`. [See the docs on using interpolation tokens for more details.](./variables.html#interpolation-tokens)

* [Feature #21367](http://projects.puppetlabs.com/issues/21367): Add support for a hiera variable syntax which interpolates data by performing a hiera lookup

### Feature: Values Can Now Be Interpolated Into Hash Keys

Hashes within a data source can now use interpolation tokens in their key names. This is mostly useful for advanced `create_resources` tricks. [See the docs on interpolating values into data for more details.](./variables.html#in-data)

* [Feature #20220](http://projects.puppetlabs.com/issues/20220): Interpolate hash keys

### Feature: Pretty-Print Arrays and Hashes on Command Line

This happens automatically and makes CLI results more readable.

* [Feature #20755](http://projects.puppetlabs.com/issues/20755): Add Pretty Print to command line hiera output

### Bug Fixes

Most of these fixes are error handling changes to improve silent or unattributable error messages.

* [Bug #17094](http://projects.puppetlabs.com/issues/17094): hiera can end up in and endless loop with malformed lookup variables
* [Bug #20519](http://projects.puppetlabs.com/issues/20519): small fix in hiera/filecache.rb
* [Bug #20645](http://projects.puppetlabs.com/issues/20645): syntax error cause nil
* [Bug #21669](http://projects.puppetlabs.com/issues/21669): Hiera.yaml will not interpolate variables if datadir is specified as an array
* [Bug #22777](http://projects.puppetlabs.com/issues/22777): YAML and JSON backends swallow errors
* [Feature #21211](http://projects.puppetlabs.com/issues/21211): Hiera crashes with an unfriendly error if it doesn't have permission to read a yaml file

### Build/Packaging Fixes and Improvements

We are now building Hiera packages for Ubuntu Saucy, which previously was
unable to use Puppet because a matching Hiera package couldn't be built.
Fedora 17 is no longer supported, and hardcoded hostnames in build_defaults.yaml
were removed.

* [Bug #22166](http://projects.puppetlabs.com/issues/22166): Remove hardcoded hostname dependencies
* [Bug #22239](http://projects.puppetlabs.com/issues/22239): Remove Fedora 17 from build_defaults.yaml
* [Bug #22905](http://projects.puppetlabs.com/issues/22905): Quilt not needed in debian packaging
* [Bug #22924](http://projects.puppetlabs.com/issues/22924): Update packaging workflow to use install.rb
* [Feature #14520](http://projects.puppetlabs.com/issues/14520): Hiera should have an install.rb


## Hiera 1.2.1

Hiera 1.2.1 contains one bug fix.

* [Issue 20137: Test for Puppet robustly](http://projects.puppetlabs.com/issues/20137)

## Hiera 1.2.0

Hiera 1.2.0 contains new features and bug fixes.

### Features

* Deep-merge feature for hash merge lookups. See [the section of this manual on hash merge lookups](./lookup_types.html#hash-merge) for details.
* [(#16644)](http://projects.puppetlabs.com/issues/16644) New generic file cache. This expands performance improvements in the YAML backend to cover the JSON backend, and is relevant to those who write custom backends. It is implemented in the Hiera::Filecache class.
* [(#18718)](http://projects.puppetlabs.com/issues/18718) New logger to handle fallback. Sometimes a logger has been configured, but is not suitable for being used. An example of this is when the puppet logger has been configured, but Hiera is not being used inside Puppet. This adds a FallbackLogger that will choose among the provided loggers for one that is suitable.

### Bug Fixes

* [(#17434)](http://projects.puppetlabs.com/issues/17434) Detect loops in recursive lookup

  The recursive lookup functionality was vulnerable to infinite recursion
  when the values ended up referring to each other. This keeps track of
  the names that have been seen in order to stop a loop from occurring. The
  behavior for this was extracted to a class so that it didn't clutter the
  logic of variable interpolation. The extracted class also specifically
  pushes and pops on an internal array in order to limit the amount of
  garbage created during these operations. This modification should be
  safe so long a new Hiera::RecursiveLookup is used for every parse that
  is done and it doesn't get shared in any manner.
* [(#17434)](http://projects.puppetlabs.com/issues/17434) Support recursive interpolation

  The original code for interpolation had, hidden somewhere in its depths,
  supported recursive expansion of interpolations. This adds that support
  back in.


