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

Read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.8 release notes](/puppet/4.8/reference/release_notes.html) and [Puppet 4.7 release notes](/puppet/4.7/reference/release_notes.html).

## Puppet 4.9.0

Released January 31, 2017.

* [Fixed in Puppet 4.9.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.9.0%27)
* [Introduced in Puppet 4.9.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.9.0%27)

### New features

#### Hiera 5

Hiera 5 is built into Puppet 4.9, and uses the Hiera 3.3 codebase. 

The Hiera 5 implementation is four times as fast as the previous version for both automatic parameter lookup and direct calls to Puppet lookup. It is about 40% faster than direct calls to a classic Hiera instance. There is no noticeable difference between a lookup in the global layer, and in the environment layer. ([PUP-7087](https://tickets.puppetlabs.com/browse/PUP-7087))

In Hiera 5, you can use 'hiera.yaml' to configure data lookups in modules and environments. We have also deprecated older hiera function uses and warn on conflicting configurations. (See [Hiera family functions](#Hiera-family-functions) below.) (PUP-6942)

Calls to Hiera functions now takes environment and module data configurations into account if you have opted in with a Hiera 5 'hiera.yaml' file in an environment. ([PUP-6981](https://tickets.puppetlabs.com/browse/PUP-6981))

Data in HOCON data format can now be used with 'hiera.yaml' versions 3, 4, or 5. ([PUP-6476](https://tickets.puppetlabs.com/browse/PUP-6476))

Any changes to Hiera 5 configurations via interpolation of Puppet variables will be found for each lookup. ([PUP-6973](https://tickets.puppetlabs.com/browse/PUP-6973))

#### Puppet lookup 

It is now possible to specify `lookup_options` using a regular expression for the keys the options apply to. The regular expression must start with a `^` to be recognized as a regular expression. ([PUP-6982](https://tickets.puppetlabs.com/browse/PUP-6982))

It is now possible to have Puppet lookup produce values other than the restricted set of data types. For example, `Sensitive` type values can be returned directly. This is of value when a defined resource type or class has declared that it requires a `Sensitive` type. Earlier it was impossible to deliver such a value via data binding. To return such a value, it must be returned by a function, and it cannot be directly produced with a Hiera compatible YAML or JSON data file. ([PUP-6926](https://tickets.puppetlabs.com/browse/PUP-6926))

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

The use of the experimental lookup features has been deprecated in favor of the finished lookup support in Hiera 5. Switch to using the new 'hiera.yaml' (version 5) format and data providing functions, and then replace the version 4 format 'hiera.yaml' in environments and modules with the new format. The version 4 format will continue to work until the next major release where it will be removed. ([PUP-6514](https://tickets.puppetlabs.com/browse/PUP-6514))


#### Hiera family functions

As a result of [Puppet lookup](./lookup_quick.html) being the preferred way to manage data, the hiera_xxx family of functions now issue deprecation warnings in favor of `lookup()`. ([PUP-6538](https://tickets.puppetlabs.com/browse/PUP-6538))

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

