---
layout: default
toc_levels: 1234
title: "Puppet 4.10 Release Notes"
---

This page lists the changes in Puppet 4.9 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), because they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.9 release notes](/puppet/4.9/release_notes.html) and [Puppet 4.8 release notes](/puppet/4.8/release_notes.html).

## Puppet 4.10

Released April 4, 2017.

* Fixed in Puppet 4.10
* Introduced in Puppet 4.10


### New Features


### Enhancements

* Hiera 5 now accepts a `mapped_path` key that expands an array or hash of values to an array of paths for a given hierarchical level. See Hiera 5 [configuration docs](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends) for more information. ([PUP-7204](https://tickets.puppetlabs.com/browse/PUP-7204))

* In Hiera 5, you can now set `options` under the `defaults` key in `hiera.yaml` configuration. Options apply to all entries in the `hiera.yaml` configuration that do not have their own `options` entry. This means you no longer have to copy the same options in a configuration where the options are largely consistent. Prior to Puppet 4.10, an attempt to set `options` under `defaults` caused an error. ([PUP-7281](https://tickets.puppetlabs.com/browse/PUP-7281))

* Hiera 5 now supports a `default_hierarchy` in modules' `hiera.yaml`. It works exactly like the normal hierarchy, but the values it binds to keys are used only if the regular `hierarchy` (across all layers) does not result in a value. Merge options for keys in the default hierarchy can be specified only in the default hierarchy's data. [PUP-7334](https://tickets.puppetlabs.com/browse/PUP-7334)

* Error messages from Hiera 5 have been improved to better explain issues and to enable locating the source of the problem. ([PUP-7182](https://tickets.puppetlabs.com/browse/PUP-7182))


### Deprecation


### Known Issues


### Bug Fixes

* [PUP-7359](https://tickets.puppetlabs.com/browse/PUP-7359) The Hiera 5 `eyaml_lookup_key` function did not evaluate interpolation expressions that were embedded in encrypted data. Now it does.

* [PUP-7330](https://tickets.puppetlabs.com/browse/PUP-7330) The data types `Puppet::LookupKey` and `Puppet::LookupValue` used to describe the values allowed as keys and values in Hiera 5 were not reachable from the Puppet language. This is now fixed.

* [PUP-7273](https://tickets.puppetlabs.com/browse/PUP-7273) Hiera 5 threw a correct but confusing error message if `hiera.yaml` contained a `data_hash` function where no options resulting in a path were defined. The error message has been made more informative and now points out the actual problem.

