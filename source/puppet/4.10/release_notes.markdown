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

## Puppet 4.10.0

Released April 4, 2017.

* [Fixed in Puppet 4.10.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.0%27)
* [Introduced in Puppet 4.10.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.0%27)


### New Features

* The 4.x function API for Ruby has been extended to accept the definition of `argument_mismatch` dispatchers. These can now be used to provide better custom error messages when a type mismatch occurs in a function call. ([PUP-7368](https://tickets.puppetlabs.com/browse/PUP-7368))

* Puppet now integrates eyaml by adding `explain` support to existing `hiera.yaml` version 3 use of the `eyaml` backend, and allows eyaml to be used in `hiera.yaml` version 5 format with an entry on the form `lookup_key: eyaml_lookup_key`. This provided that the eyaml gem is installed separately, as it is not bundled with Puppet. ([PUP-7100](https://tickets.puppetlabs.com/browse/PUP-7100))

* It is now possible to expand a fact being a collection (array or hash) of values in a `hiera.yaml` to produce an array of paths for a given hierarchical level by using `mapped_paths`. This was not possible in earlier versions of Hiera. ([PUP-7204](https://tickets.puppetlabs.com/browse/PUP-7204))

* Added support for `Sensitive` commands in the Exec resource type: 
command parameters that are specified as `Sensitive.new(...)` are now 
properly redacted when the command fails. This supports using data from Puppet lookup and Hiera. ([PUP-6494](https://tickets.puppetlabs.com/browse/PUP-6494))

* It is now possible to set `options` under `defaults` in a `hiera.yaml` version 5 configuration. Those options apply to all entries in the `hiera.yaml` configuration that does not have an `options` entry. This reduces the amount of copies of the same set of options when a configuration in majority consists of the same type of data provider with the same options. Earlier, an attempt to set `options` under `defaults` would result in an error. ([PUP-7281](https://tickets.puppetlabs.com/browse/PUP-7281))

* Hiera 5 now supports a `default_hierarchy` in modules' `hiera.yaml`. It works exactly like the normal hierarchy, but the values it binds to keys are used only if the regular `hierarchy` (across all layers) does not result in a value. Merge options for keys in the default hierarchy can be specified only in the default hierarchy's data. ([PUP-7334](https://tickets.puppetlabs.com/browse/PUP-7334))

### Enhancements

* Hiera 5 now accepts a `mapped_path` key that expands an array or hash of values to an array of paths for a given hierarchical level. See Hiera 5 [configuration docs](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends) for more information. ([PUP-7204](https://tickets.puppetlabs.com/browse/PUP-7204))

* In Hiera 5, you can now set `options` under the `defaults` key in `hiera.yaml` configuration. Options apply to all entries in the `hiera.yaml` configuration that do not have their own `options` entry. This means you no longer have to copy the same options in a configuration where the options are largely consistent. Prior to Puppet 4.10, an attempt to set `options` under `defaults` caused an error. ([PUP-7281](https://tickets.puppetlabs.com/browse/PUP-7281))

* Error messages from Hiera 5 have been improved to better explain issues and to enable locating the source of the problem. ([PUP-7182](https://tickets.puppetlabs.com/browse/PUP-7182))


### Deprecation

The `puppet inspect` command is deprecated in Puppet 4.10, along with the related `audit` resource metaparameter. The command will be removed and the `audit` parameter will be ignored in manifests in a future release (planned for Puppet 5). ([PUP-893](https://tickets.puppetlabs.com/browse/PUP-893))

### Known Issue

This is a regression from Puppet 4.9.3. 

In some very rare cases, a v5 `hiera.yaml` file can ignore certain hierarchy levels. This only happens for hierarchy levels that interpolate a top-scope variable whose value was set after the _first_ Hiera lookup. Even then, it only occurs if the variable is an array or hash, the hierarchy level accesses one of its members with key.subkey notation, _and_ the variable is referenced with the top-scope namespace (`::attributes.role`). 

If this affects you, you can remove the top-scope namespace (`attributes.role`) to work around it until this bug is fixed. However, we strongly recommend against making your hierarchy self-configuring like this. You should only interpolate the `$facts`, `$trusted`, and `$server_facts` variables in your hierarchy. 

(Dirty details: In the lookup that initially sets the offending variable, that variable doesn't exist yet. Hiera remembers that it doesn't exist, so in subsequent lookups it won't use the new value. This is part of an optimization for top-scope variables that don't change, which is why removing the top namespace works around it.) ([PUP-7336](https://tickets.puppetlabs.com/browse/PUP-7336))

### Bug Fixes

* [PUP-7359](https://tickets.puppetlabs.com/browse/PUP-7359) The Hiera 5 `eyaml_lookup_key` function did not evaluate interpolation expressions that were embedded in encrypted data. Now it does.

* [PUP-7330](https://tickets.puppetlabs.com/browse/PUP-7330) The data types `Puppet::LookupKey` and `Puppet::LookupValue` used to describe the values allowed as keys and values in Hiera 5 were not reachable from the Puppet language. This is now fixed.

* [PUP-7273](https://tickets.puppetlabs.com/browse/PUP-7273) Hiera 5 threw a correct but confusing error message if `hiera.yaml` contained a `data_hash` function where no options resulting in a path were defined. The error message has been made more informative and now points out the actual problem.

