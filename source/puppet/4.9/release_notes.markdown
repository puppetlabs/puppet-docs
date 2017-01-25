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

### Enhancements

PUP-6921: The Internal Ruby API for String and Enum types have been slightly modified as the Enum type is now used for inferred result of multiple Strings. The change is public API backwards compatible, but issues deprecation warnings. If you are coding in Ruby against the type system, turn on (at least) strict=warning to see deprecations.

PUP-1476: Puppet will now send a useful User-Agent header when making HTTP requests (of the form User-Agent: Puppet/4.8.2 Ruby/2.1.9-p353 (x86_64-linux). Previously it just sent "Ruby" which wasn't very helpful.

### Known issues



### Deprecations

These deprecations are effective as of Puppet 4.9.0 their related features are likely to be completely removed in a future Puppet release. In many cases, they were made unnecessary or useless by newer features many releases ago.

#### Hiera family functions

PHP-6538: As a result of "lookup" being the preferred way to manage data from now on, the hiera_xxx family of functions now issue deprecation warnings in favor of lookup().

#### `data_binding_terminus` setting

The `data_binding_terminus` settings other than 'hiera' and 'none', under the control of --strict are now deprecated.

* [PUP-6576]()

#### Ruby 2.0 series

As of Puppet 4.9.0, support for the ruby 2.0 series is deprecated.

#### Faces

As of Puppet 4.9.0, the following Puppet faces have been deprecated:

* [](): `status`
* [](): `file`
* [](): `key`
* [](): `ca`
* [](): `certificate_request`
* [](): `certificate_revocation_list`

#### Caching methods

The following methods are no longer used within Puppet and have been deprecated: 

* `Puppet::SSL::CertificateAuthority#list_certificates `
* `Puppet::SSL::CertificateAuthority#certificate_is_alive? `
* `Puppet::SSL::CertificateAuthority#x509_store` (api private) 

* [PUP-3534]()

#### `stacktrace` 

In Puppet 4.8.0, the stacktrace property was removed from Puppet's HTTP error response API. This was an unintentional backwards-incompatible change, and in Puppet 4.8.2, the stacktrace property was returned to the response object, but instead of containing the stack trace message, now contains a deprecation warning. Users consuming the stack trace property of the Puppet HTTP error response API should instead review the Puppet log for this information.

* [PUP-7066]()


### Bug fixes
