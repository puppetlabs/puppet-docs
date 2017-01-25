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

Also of interest: the [Puppet 4.7 release notes](/puppet/4.7/reference/release_notes.html) and [Puppet 4.6 release notes](/puppet/4.6/reference/release_notes.html).

## Puppet 4.9.0

### New features

#### Puppet lookup and Hiera 5





### Enhancements

#### Ruby API for `String` and `Enum`

The internal Ruby API for `String` and `Enum` types has been slightly modified because the `Enum` type is now used for the inferred result of multiple strings. The change is public API backwards compatible, but issues deprecation warnings. If you are coding in Ruby against the type system, set `strict=warning` to see these deprecations. ([PUP-6921](https://tickets.puppetlabs.com/browse/PUP-6921))

#### HTTP headers

Puppet will now send a useful User-Agent header when making HTTP requests (of the form "User-Agent: Puppet/4.8.2 Ruby/2.1.9-p353 (x86_64-linux)"). Previously it just sent "Ruby" which wasn't very helpful. ([PUP-1476](https://tickets.puppetlabs.com/browse/PUP-1476))

#### Localization

Locale and translation files will be installed to `/opt/puppetlabs/puppet/share/locale` on Unix systems and `C:\Program Files\Puppet Labs\Puppet\puppet\share\locale` on Windows. ([PUP-6934](https://tickets.puppetlabs.com/browse/PUP-6934))

### Deprecations

These deprecations are effective as of Puppet 4.9.0. This means their related features and components are planned for complete removal in a future Puppet release.

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

In Puppet 4.8.0, the stacktrace property was removed from Puppet's HTTP error response API. This was an unintentional backwards-incompatible change, and in Puppet 4.8.2, the stacktrace property was returned to the response object. 

Instead of containing the stack trace message, it now contains a deprecation warning. Users consuming the `stacktrace` property of the Puppet HTTP error response API should instead review the Puppet log for this information. ([PUP-7066](https://tickets.puppetlabs.com/browse/PUP-7066))


### Bug fixes
