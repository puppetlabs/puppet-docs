---
layout: default
toc_levels: 1234
title: "Puppet 4.9 Release Notes"
---

This page lists the changes in Puppet 4.9 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.8 release notes](/puppet/4.8/release_notes.html) and [Puppet 4.7 release notes](/puppet/4.7/release_notes.html).

## Puppet 4.9.4

Released March 9th, 2017.

This is a bug fix release in the Puppet 4.9 series, with some performance increases.

* [Fixed in Puppet 4.9.4](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.9.4%27)
* [Introduced in Puppet 4.9.4](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.9.4%27)

### Known issues

* [PUP-7336](https://tickets.puppetlabs.com/browse/PUP-7336): Regression from 4.9.3. [Version 5 hiera.yaml](./hiera_config_yaml_5.html) files sometimes ignore circularly-configured hierarchy levels. This only happens for hierarchy levels that:
    * Interpolate a top-scope array or hash variable _whose value was itself set with a Hiera lookup_ (like `$attributes = lookup('attributes')`)...
    * ..._and_ access a member of that variable with key.subkey notation...
    * ..._and_ refer to that variable with the top-scope namespace (`%{::attributes.role}`).

    You can remove the top-scope namespace (`%{attributes.role}`) to avoid this bug until it's fixed. But in general, we recommend against circular logic in your hierarchy. Limit yourself to the `$facts`, `$trusted`, and `$server_facts` variables and have a better time.

### Enhancements

* [PUP-7303](https://tickets.puppetlabs.com/browse/PUP-7303): Changed the Hiera configuration stability check, increasing performance.

* [PUP-7301](https://tickets.puppetlabs.com/browse/PUP-7301): This change decreases the number of type inferences that are performed during normal execution. This increases performance on large Hiera datasets and hierarchies.


### Bug fixes

The following bugs and regressions have been resolved in this version:

* [PUP-7293](https://tickets.puppetlabs.com/browse/PUP-7293): A regression in Hiera 5 caused interpolation of values into 'hiera.yaml' options to stop working and instead be delivered in clear text.

* [PUP-7291](https://tickets.puppetlabs.com/browse/PUP-7291): The (very limited) debug output from Automatic Parameter Lookup (APL) was removed in Puppet 4.9.0 with the intention of replacing it with the full `lookup --explain` output, but the explain output ended up not being enabled for APL. This is now fixed making debugging of APL much easier.

* [PUP-7287](https://tickets.puppetlabs.com/browse/PUP-7287): Unnecessary `--explain` output was generated for some internal checks in Hiera 5. This made explain output confusing in some situations.

* [PUP-7284](https://tickets.puppetlabs.com/browse/PUP-7284): A regression in Hiera version 5 caused the Hiera 3 'hiera.yaml' format's backend option 'extension' to stop working for 'eyaml'. Other backends were unaffected as they did not support this option.

* [PUP-7305](https://tickets.puppetlabs.com/browse/PUP-7305): A regression in Hiera 5 was found where parsed Hiera data files were not cached.

* [PUP-7296](https://tickets.puppetlabs.com/browse/PUP-7296): A regression in Hiera 5's support for eyaml caused interpolation in looked up hash values to stop working. This is now fixed and for looked up hashes both keys and values are now interpolated.

* [PUP-7289](https://tickets.puppetlabs.com/browse/PUP-7289): A regression in the interpretation of a 'hiera.yaml' (all versions) caused interpolation in the datadir option to stop working.

* [PUP-7286](https://tickets.puppetlabs.com/browse/PUP-7286): A regression in Puppet 4.9.0 caused the 'hiera.yaml' configured merge behavior to apply to all `hiera_xxx` functions when it should only apply to the `hiera_hash` function. Calls to `lookup` and Automatic Parameter Lookup were unaffected by this regression.


## Puppet 4.9.3

Released February 27, 2017.

This is a bug fix release in the Puppet 4.9 series.

* [Fixed in Puppet 4.9.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.9.3%27)
* [Introduced in Puppet 4.9.3](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.9.3%27)

### Enhancements

Puppet now integrates eyaml by adding explain support to existing 'hiera.yaml' version 3 use of the `eyaml` backend, and allows eyaml to be used in 'hiera.yaml' version 5 format with an entry on the form `lookup_key: eyaml_lookup_key`. This functionality requires that the eyaml gem is installed separately as it is not bundled with Puppet. ([PUP-7205](https://tickets.puppetlabs.com/browse/PUP-7205))


### Bug fixes

* [PUP-7214](https://tickets.puppetlabs.com/browse/PUP-7214): Fixes a regression (introduced in Puppet 4.9.0) affecting RPM package deinstallation.

* [PUP-7006](https://tickets.puppetlabs.com/browse/PUP-7006): The documentation for the `puppet lookup` CLI stated that it could lookup several keys, one after another when it in reality only did one (the first). Now it can lookup several values in sequence.

* [PUP-7216](https://tickets.puppetlabs.com/browse/PUP-7216): A regression in calls to the hiera_xxx family of functions made them not honor default merge behavior defined in 'hiera.yaml'.

* [PUP-7215](https://tickets.puppetlabs.com/browse/PUP-7215): A regression in Puppet 4.9.0 and Hiera 5 meant that  "Error: Could not run: Hiera type mismatch: expected Hash and got String" could be raised when using eyaml and other Hiera 3 backends using the oldest version of the backend API.

* [PUP-7232](https://tickets.puppetlabs.com/browse/PUP-7232): Deprecation messages for Puppet's own internal use of deprecated SemVer version were annoying because users could do nothing to stop them from being issued. These messages are now surpressed.

* [PUP-7235](https://tickets.puppetlabs.com/browse/PUP-7235): The new Hiera 5 feature supporting path globs in 'hiera.yaml' did not work as expected.


## Puppet 4.9.2

Released February 10, 2017.

This release resolves some regressions introduced in Puppet 4.9.0, and fixes several critical bugs.

* [Fixed in Puppet 4.9.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.9.2%27)
* [Introduced in Puppet 4.9.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.9.2%27)


### Bug fixes

The following have been resolved in this release:

* [PUP-7164](https://tickets.puppetlabs.com/browse/PUP-7164): Hiera 5 introduced a regression that when a YAML data file was read, and it was empty this would lead to an error "Expected Hash, got Boolean".

* [PUP-7178](https://tickets.puppetlabs.com/browse/PUP-7178): A regression was introduced by Hiera 5 where an interpolation using the functions `hiera`, `lookup`, or `alias` would only be able to find keys from the same kind of backend. This affected users with a mix of YAML, JSON and/or eyaml entries in their hierarchies.

* [PUP-7179](https://tickets.puppetlabs.com/browse/PUP-7179): A loader delegation problem has been fixed that caused problems when a data type depended indirectly on data types not directly visible to the module, but being visible to the module of an intermediate type.

* [PUP-7167](https://tickets.puppetlabs.com/browse/PUP-7167): The hiera 5 implementation in Puppet 4.9.0 introduced a regression that caused interpolation of keys in nested hashes to result in no interpolation taking place.

* [PUP-7176](https://tickets.puppetlabs.com/browse/PUP-7176): A regression was introduced in Hiera 5 which caused problems when the default merge was specified in a hiera.yaml. The regression was that the merge logic refused to merge mismatched types, or non array and hash values. Now the behavior of hiera 3 is also the behavior of hiera 5 such that a merge of non mergeable values uses priority based selection.

* [PUP-7165](https://tickets.puppetlabs.com/browse/PUP-7165): Having a hiera.yaml (version 3) in the root of an environment led to a hard error, because Hiera 5 requires that such the has format 5 for it to be used with the new features in Hiera. This has been changed so that a version 3 file is ignored and a warning is issued if `--strict=warning`, and an error is raised only if `--strict==error`.

* [PUP-6588](https://tickets.puppetlabs.com/browse/PUP-6588): The path of a URL used in module install's `--module_repository` option is no longer ignored, and will be used when connecting to the repository.

* [PUP-7169](https://tickets.puppetlabs.com/browse/PUP-7169): A regression in the handling of Hiera 3 custom backends led to error "Unrecognized value for request 'merge' parameter: 'unconstrained_deep'" for some users when using the eyaml Hiera 3 backend. The `unconstrained_deep` is a backend internal concern that was initially missing in the Hiera 5 implementation.

* [PUP-7171](https://tickets.puppetlabs.com/browse/PUP-7171): A regression was introduced in the Hiera 5 implementation where an error such as "trusted.certname" is an undefined variable would be the outcome. This was caused by a bug in cache optimization logic and would occur the second time a lookup was performed.

## Puppet 4.9.1

Released February 3, 2017.

This is a gem-only release of Puppet, to fix a packaging issue. You can read more about the details in [PUP-7156](https://tickets.puppetlabs.com/browse/PUP-7156).

## Puppet 4.9.0

Released February 1, 2017.

* [Fixed in Puppet 4.9.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.9.0%27)
* [Introduced in Puppet 4.9.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.9.0%27)

### Known issues

In 4.9.0, Puppet fails with an error if there's a "classic" hiera.yaml file in the root of an environment. Although Puppet never used to _use_ an environment's Hiera v3 config, a number of people stored it in their control repo just to keep it near their code and data, and now that breaks Puppet.

We plan to fix this in 4.9.1 --- a v3 hiera.yaml will cause a warning, not an error. In the meantime, you can avoid the error by moving hiera.yaml into a subdirectory where it will be ignored.

### New features

#### Hiera 5

Hiera 5 is a backwards-compatible evolution of Hiera, incorporating everything we learned from the experimental "Puppet lookup" feature. Its features include:

* True environment and module data! Any environment or module can include its own hiera.yaml file and its own data sources.
* A new, simplified custom backend system, so it's easier than ever to integrate custom data sources with Puppet.
* 40% faster than classic Hiera.
* Easier debugging than ever before, with detailed debug messages and the `puppet lookup --explain` flag.
* A new HOCON-based data backend, to accompany the existing YAML and JSON backends.

If you're already a Hiera user, see [Migrating existing data to Hiera 5](./hiera_migrate.html) to learn how to start using these new features.

Hiera 5 is now a part of Puppet's core code, although it uses the Hiera 3.3 codebase for some backwards-compatibility features.

Associated tickets:

The Hiera 5 implementation is four times as fast as the previous version for both automatic parameter lookup and direct calls to the `lookup` function. It is about 40% faster than direct calls to a classic Hiera instance. There is no noticeable difference between a lookup in the global layer, and in the environment layer. ([PUP-7087](https://tickets.puppetlabs.com/browse/PUP-7087))

In Hiera 5, you can use 'hiera.yaml' to configure data lookups in modules and environments. We have also deprecated older hiera function uses and warn on conflicting configurations. (See [Hiera family functions](#Hiera-family-functions) below.) (PUP-6942)

Calls to Hiera functions now takes environment and module data configurations into account if you have opted in with a Hiera 5 'hiera.yaml' file in an environment. ([PUP-6981](https://tickets.puppetlabs.com/browse/PUP-6981))

Data in HOCON data format can now be used with 'hiera.yaml' versions 3, 4, or 5. ([PUP-6476](https://tickets.puppetlabs.com/browse/PUP-6476))

Any changes to Hiera 5 configurations via interpolation of Puppet variables will be found for each lookup. ([PUP-6973](https://tickets.puppetlabs.com/browse/PUP-6973))

It is now possible to specify `lookup_options` using a regular expression for the keys the options apply to. The regular expression must start with a `^` to be recognized as a regular expression. ([PUP-6982](https://tickets.puppetlabs.com/browse/PUP-6982))

It is now possible to have Hiera produce values other than the restricted set of data types. For example, `Sensitive` type values can be returned directly. This is of value when a defined resource type or class has declared that it requires a `Sensitive` type. Earlier it was impossible to deliver such a value via Hiera. To return such a value, it must be returned by a function, and it cannot be directly produced with a Hiera compatible YAML or JSON data file. ([PUP-6926](https://tickets.puppetlabs.com/browse/PUP-6926))

#### CSR warnings from Puppet agent

The Puppet agent now emits a warning if it had previously submitted a CSR to a master, does not have a signed CSR, and the local CSR does not match what was previously submitted to the master. ([PUP-6918](https://tickets.puppetlabs.com/browse/PUP-6918))

#### Localization

Puppet now ships with the `gettext-setup` gem. This provides a useful interface for Ruby's gettext tooling, which allows extraction of strings for translation and runtime insertion of translated strings based on the user's locale. (PUP-6474)

Locale and translation files will be installed to `/opt/puppetlabs/puppet/share/locale` on Unix systems and `C:\Program Files\Puppet Labs\Puppet\puppet\share\locale` on Windows. ([PUP-6934](https://tickets.puppetlabs.com/browse/PUP-6934))

#### Default entries

Duplicate literal default entries in `case` and `selector` expressions are now validated under the control of the `--strict` option (defaults to warning). ([PUP-978](https://tickets.puppetlabs.com/browse/PUP-978))


### Enhancements

#### Ruby API for `String` and `Enum`

The internal Ruby API for `String` and `Enum` types has been slightly modified because the `Enum` type is now used for the inferred result of multiple strings. The change is public API backwards compatible, but issues deprecation warnings. If you are coding in Ruby against the type system, set `strict=warning` to see these deprecations. ([PUP-6921](https://tickets.puppetlabs.com/browse/PUP-6921))

#### HTTP headers

Puppet will now send a useful User-Agent header when making HTTP requests (of the form "User-Agent: Puppet/4.8.2 Ruby/2.1.9-p353 (x86_64-linux)"). Previously it just sent "Ruby" which wasn't very helpful. ([PUP-1476](https://tickets.puppetlabs.com/browse/PUP-1476))


### Deprecations

These deprecations are effective as of Puppet 4.9.0. This means their related features and components are planned for complete removal in a future Puppet release.

#### Experimental Puppet lookup features

The use of the experimental lookup features has been deprecated in favor of the finished lookup support in Hiera 5. Switch to using the new 'hiera.yaml' (version 5) format and data providing functions, and then replace the version 4 format 'hiera.yaml' in environments and modules with the new format. The version 4 format will continue to work until the next major release where it will be removed.

For more information, see [What's the deal with Hiera 5](./hiera_intro.html#whats-the-deal-with-hiera-5).

([PUP-6514](https://tickets.puppetlabs.com/browse/PUP-6514))


#### Hiera family functions

As a result of [the `lookup` function](./hiera_use_function.html) being the preferred way to manage data, [the hiera_xxx family](./hiera_use_hiera_functions.html) of functions now issue deprecation warnings in favor of `lookup()`. ([PUP-6538](https://tickets.puppetlabs.com/browse/PUP-6538))

#### `data_binding_terminus` settings

All `data_binding_terminus` settings except 'hiera' and 'none' under the control of `--strict` are now deprecated.

* [PUP-6576](https://tickets.puppetlabs.com/browse/PUP-6576)

#### Ruby 2.0 series

As of Puppet 4.9.0, support for the Ruby 2.0 series is deprecated. ([PUP-7038](https://tickets.puppetlabs.com/browse/PUP-7038))

#### Faces

As of Puppet 4.9.0, the following Puppet faces have been deprecated:

* `status` ([PUP-873](https://tickets.puppetlabs.com/browse/PUP-873))
* `file` ([PUP-869](https://tickets.puppetlabs.com/browse/PUP-869))
* `key` ([PUP-871](https://tickets.puppetlabs.com/browse/PUP-871))
* `ca` ([PUP-868](https://tickets.puppetlabs.com/browse/PUP-868))
* `certificate_request` ([PUP-868](https://tickets.puppetlabs.com/browse/PUP-868))
* `certificate_revocation_list` ([PUP-868](https://tickets.puppetlabs.com/browse/PUP-868))

#### Caching methods

The following methods are no longer used within Puppet and have been deprecated:

* `Puppet::SSL::CertificateAuthority#list_certificates `
* `Puppet::SSL::CertificateAuthority#certificate_is_alive? `
* `Puppet::SSL::CertificateAuthority#x509_store` (api private)

* [PUP-3534](https://tickets.puppetlabs.com/browse/PUP-3534)

#### `stacktrace`

In Puppet 4.8.0, the `stacktrace` property was removed from Puppet's HTTP error response API. This was an unintentional backwards-incompatible change, and in Puppet 4.8.2, the `stacktrace` property was returned to the response object.

Instead of containing the `stacktrace` message, it now contains a deprecation warning. Users consuming the `stacktrace` property of the Puppet HTTP error response API should instead review the Puppet log for this information. ([PUP-7066](https://tickets.puppetlabs.com/browse/PUP-7066))


### Bug fixes

The following bugs have been addressed and resolved:

* [PUP-6759](https://tickets.puppetlabs.com/browse/PUP-6759): The systemd provider now considers services with the `indirect` enabled state to be disabled.

* [PUP-6992](https://tickets.puppetlabs.com/browse/PUP-6992): The feature that allows functions to be defined in an environment in the `environment::` namespace has been modified because the implementation was inconsistent between Ruby and Puppet based functions in this respect. Now, a file containing the definition of a function in an environment is always under a directory reflecting the namespace.

* [PUP-7061](https://tickets.puppetlabs.com/browse/PUP-7061): A regression introduced in Puppet 4.8.0 caused attempts to lookup a string containing more than one interpolation that in turn used interpolation function Hiera (for example, `%{hiera('some_key')}`) to fail when running with trace level set to `debug`. This regression is now fixed.

* [PUP-7030](https://tickets.puppetlabs.com/browse/PUP-7030): Previously a string with two adjacent unicode characters did not result in two unicode characters being placed in the string. Instead only the first was recognized as being a unicode character, and the second was taken as verbatim text.

* [PUP-7029](https://tickets.puppetlabs.com/browse/PUP-7029): The dnf provider now works on Fedora 25.

* [PUP-7013](https://tickets.puppetlabs.com/browse/PUP-7013): If a Puppet lookup versioned 'hiera.yaml' was referenced as the global 'hiera.yaml', the system would silently fall back to the factory-default 'hiera.yaml'. Now it instead results in an error.

* [PUP-7012](https://tickets.puppetlabs.com/browse/PUP-7012): When a type mismatch occurred when performing automatic parameter type checking, it could end up being reported for the wrong parameter.

* [PUP-7003](https://tickets.puppetlabs.com/browse/PUP-7003): It was previously impossible to interpolate a variable if that variable name was the same as the key being looked up.

* [PUP-6963](https://tickets.puppetlabs.com/browse/PUP-6963): Previously, the systemd service provider did not specify itself as the default for CoreOS systems. Since systemd is the default service manager in CoreOS, this change updates the provider to add the CoreOS family to its defaults.

* [PUP-6797](https://tickets.puppetlabs.com/browse/PUP-6797): Prior to Puppet 4.9.0, when managing services on Solaris with the smf provider, the status of non-existent services was returned as "stopped". In Puppet 4.9.0 and later, non-existent services are considered "absent".

* [PUP-6834](https://tickets.puppetlabs.com/browse/PUP-6834): The Puppet lookup `--explain` option would sometimes not correctly show looked up values when doing deep merges.

* [PUP-6741](https://tickets.puppetlabs.com/browse/PUP-6741): Prior to Puppet 4.9.0, if a resource had a subscribing relationship with a recursive file resource, and Puppet was run with `--tags` such that these resources were evaluated, the subscribing resource would not be triggered.

* [PUP-7031](https://tickets.puppetlabs.com/browse/PUP-7031): Prior to Puppet 4.9.0, if a Puppet agent was run in a non-UTF-8 locale, Puppet would fail to apply a change to a user comment on Linux and Windows if the change included UTF-8 comments.

* [PUP-4742](https://tickets.puppetlabs.com/browse/PUP-4742): A dependency is added on the `semantic_puppet` gem >= 0.1.3', '< 2' because this is required for issues with semantic version comparison functions and types.

* [PUP-6758](https://tickets.puppetlabs.com/browse/PUP-6758): Puppet now gracefully fails if the `pkg` fails to enumerate installed packages.

* [PUP-6856](https://tickets.puppetlabs.com/browse/PUP-6856): When using certain types of Puppet variables, data in modules could fail to lookup values interpolated from these variables silently.

* [PUP-6864](https://tickets.puppetlabs.com/browse/PUP-6864): A node group configured to use an environment which didn't exist would sometimes fail with error "NoMethodError: undefined method `environment_data_provider` for nil:NilClass". The bug was caused by code in Puppet lookup (Hiera version 4), and was fixed as a part of the rewrite to version 5.

* [PUP-6821](https://tickets.puppetlabs.com/browse/PUP-6821): The `binary_file` built-in function previously had an unclear error message when a specified file was not found.

* [PUP-6663](https://tickets.puppetlabs.com/browse/PUP-6663): Previously, Puppet did not appropriately quote the RPM query string when determining package state with the RPM provider. This caused stale locks to be left on the RPM database when large volumes of RPM queries were run. This change adds the necessary quotes to the query to prevent this from happening.

* [PUP-6882](https://tickets.puppetlabs.com/browse/PUP-6882): It was not possible to escape a unicode character. The result of `"\\uFFFF"`
Ended up being a literal backslash followed by the uFFFF character.

* [PUP-6448](https://tickets.puppetlabs.com/browse/PUP-6448): When using the file type to specify a source with a `puppet:///` style URI, errors could previously be generated if the source included non-ASCII characters. The `puppet:///` style URI should now completely support the usage of UTF-8 characters in paths to files.

* [PUP-6792](https://tickets.puppetlabs.com/browse/PUP-6792): On Solaris using the smf service provider, managed services would not enable their dependencies by default. Services now enable services they depend on by default.

* [PUP-6793](https://tickets.puppetlabs.com/browse/PUP-6793): The pkg package provider was default for Solaris 11, but not 12. It is now the default for both.

* [PUP-6917](https://tickets.puppetlabs.com/browse/PUP-6917): It was not possible to use the name `$site` as the name of a parameter for a user defined type or class as this made it impossible to set that value when `application_management` setting was true.

* [PUP-6795](https://tickets.puppetlabs.com/browse/PUP-6795): Puppet's 'install.rb' would gzip man pages on Solaris, which does not support them. Now man pages are no longer gzipped on Solaris.

