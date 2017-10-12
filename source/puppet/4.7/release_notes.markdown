---
layout: default
toc_levels: 1234
title: "Puppet 4.7 Release Notes"
---

[Puppet Enterprise 2016.4]: /pe/2016.4



This page lists the changes in Puppet 4.7 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.6 release notes](/puppet/4.6/release_notes.html) and [Puppet 4.5 release notes](/puppet/4.5/release_notes.html).


>**Note**: This version of Puppet is included in the Long Term Support release [Puppet Enterprise 2016.4][], so while there may be [newer versions of Puppet](/puppet/latest) available (and sometimes referenced in these release notes), we will continue updating this version until Puppet Enterprise 2016.4 reaches end of life.

## Puppet 4.7.1

Released January 17, 2017.

Shipped with [`puppet-agent` 1.7.2](/puppet/4.7/release_notes_agent.html).

* [Fixed in Puppet 4.7.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.7.1%27)
* [Introduced in Puppet 4.7.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.7.1%27)

### Deprecation

In Puppet 4.8.0, the stacktrace property was removed from Puppet's HTTP error response API. This was an unintentional backwards-incompatible change, and in Puppet 4.8.2, the stacktrace property was returned to the response object, but instead of containing the stack trace message, now contains a deprecation warning. Users consuming the stack trace property of the Puppet HTTP error response API should instead review the Puppet log for this information.

* [PUP-7066](https://tickets.puppetlabs.com/browse/PUP-7066)

### Bug fix

#### Puppet tag validation

Tags containing new lines caused problems in PuppetDB because they were silently accepted when compiling a catalog. Now an error will be raised when compiling.

* [PUP-6670](https://tickets.puppetlabs.com/browse/PUP-6670)

## Puppet 4.7.0

Released September 22, 2016.

This release addresses a single bug fix.

### Critical bug fix

Previously, the `/environment/:env` route wasn't properly anchored to the start of the path, so routes with other prefixes would also match. Because auth is performed separately based on the path, this allowed requests like `/status/environment/production` to bypass auth checks and retrieve environment catalogs. This also meant that other valid requests ending in `/environment/:foo`, such as for files, would be handled incorrectly.

The `/environment/:env` regular expression is now properly anchored to the beginning of the path, so only explicit environment requests will match.
