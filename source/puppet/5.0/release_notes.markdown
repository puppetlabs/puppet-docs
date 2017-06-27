---
layout: default
toc_levels: 1234
title: "Puppet 5.0 Release Notes"
---

This page lists the changes in Puppet 5.0 and its patch releases. You can also view [current known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality or significant bug fixes
* Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0 release notes](/puppet/5.0/release_notes.html), because they cover breaking changes since Puppet 4.10.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.0.0

This version of Puppet has not been released yet, and these docs are an unfinished draft until their release.

Released June 26, 2017.

This release of Puppet is included in Puppet agent 5.0.0. Many features that were deprecated in Puppet 4 have been removed.

### New features

### Enhancements

### Deprecations

* The `external_facts` feature is deprecated as the version of Facter Puppet depends on now always includes this functionality.

* The experimental "data in environments and modules" support implementation has been deprecated in favor of Hiera version 5. Implementors of custom experimental data providers using the experimental "version 4" should migrate their implementations as soon as possible because there is no guarantee that the experimental APIs will continue to work. Users of the hiera.yaml version 4 format, and the built in data providers for JSON and YAML, as well as the `data()` function can migrate at their own pace as those features are deprecated but still supported.

* The keywords `site`, `application`, `consumes` and `produces` that were earlier opt-in via the `app_management` setting are now always keywords. The `app_management` setting is now also deprecated, but will remain as a setting without any effect until a future Puppet release. This means that Puppet will always be enabled for application management without the earlier required opt-in.

### Removals

* The `inspect` command and its associated fields in the report have been removed, most notably the `kind` field, which used to distinguish between `apply` and `inspect` runs.

* The Puppet face, 'file' (deprecated in Puppet 4.x) has been removed.

* Allow and deny directives have been removed from `fileserver.conf`. You should set these in the legacy `auth.conf` or in trapperkeeper's `tk-auth`.

* Outdated extension files with macros and configurations for the Puppet language syntax for emacs and vim have been removed.

* The previously deprecated setting `always_cache_features` has been removed. It was replaced with a related setting that flips the logic: `always_retry_plugins`.

* Previously, the `stacktrace` property in HTTP error responses was always empty for security reasons. In Puppet 5, we've removed the `stacktrace` property as it serves no purpose.

* The monkey patch of `Range#intersection` to handle SemVer range matches have now been removed. This only affects those that have written version compare logic in Ruby.

* If you have Ruby code that directly makes use of the deprecated `String` formatting methods in the `TypeCalculator` class (see [PUP-5902](https://tickets.puppetlabs.com/browse/PUP-5902)) you need to change your logic to use the replacement `TypeFormatter` as the string formatting methods in the `TypeCalculator` now have been removed.

* Previously, if a class was defined more than once their bodies would be merged. The output of a warning or error was under the control of the `--strict` flag. Now, this is always an error except for the top scope class named '' (also known as 'main').

* Puppet previously shipped and depended on the `win32-eventlog` gem for its interface to the windows in `eventlog`. In Puppet 5, this dependency has been removed and Puppet interfaces with eventlog directly.

* The static compiler functionality was superseded by static catalogs introduced in Puppet 4.4. As a result, the static compiler was deprecated in 4.x and it is now removed.

* The HTTP `resource_type` and `resource_types` endpoints and the `resource_type` Puppet command line face have been removed. The `environment_classes` HTTP endpoint in Puppet Server replaces a subset of the `resource_type` functionality, including name and parameter metadata for classes.

* The ability to use a capital name in a `Class[MyClass]` reference has been removed and results in an error. Such references must now be written with a lower cased name, `Class[myclass]`

* By default, Puppet no longer writes node yaml files to its cache as of Puppet 5.0. This cache was once used in workflows with external tooling needing a list of nodes, but with the advent of PuppetDB that is now the correct way to retrieve information about nodes. If you wish to retain the 4.x behavior, add the setting `node_cache_terminus = write_only_yaml`. Note that `write_only_yaml` is deprecated, you should migrate to PuppetDB based workflows for retrieving node information.

* The `strip_internal` method from the `Puppet::Node::Facts` class has been removed. This method has been deprecated since Puppet 4.0.0.

* The old cfacter feature, which has been obsolete since the Puppet 4.x series has been removed.

#### Generated Pcore metadata replaces RGen AST model

In all versions before Puppet 5.0.0, the Puppet Language AST classes (about 100) were implemented using the RGen meta modeling gem. From Puppet 5.0.0 and forward, Puppet includes its own modeling system named Pcore - based on the Puppet type system. 

In older versions, the AST runtime classes were dynamically created by RGen at runtime. Now they are instead statically generated from Pcore metadata at buildtime. This speeds up loading of the AST. 

The earlier vendored (included) RGen meta-modeling gem has also been removed from Puppet since this replacement. If you required RGen in experimental code and counted on puppet to install it, you must now install it yourself. If you relied on non-Puppet API methods brought in by RGen monkey patching you must revise your code. This should not affect any normal user code in Ruby or Puppet. 

Since RGen included monkey patching of some common Ruby classes, the removal of RGen also contributes to better performance in general. All users should see some reduction in memory use and a faster startup time for a Puppet compilation as the result of this removal.

### Known issues

We've added a dedicated known issues page to the open source Puppet documentation so that you don't need to read through every version of the release notes to try and determine whether or not a known issue is still relevant. 

### Bug fixes

* [PUP-7594](https://tickets.puppetlabs.com/browse/PUP-7594): In Puppet 4.9 and greater, a regression converted integer or float keys in Hiera data to strings. The intended behavior was to filter out Ruby Symbol keys. Integer and Float keys in hashes now work as they should.

* [PUP-7608](https://tickets.puppetlabs.com/browse/PUP-7608) In Hiera, when performing a lookup with merge strategy `unique` on an array value, the array could contain duplicates if it was never merged with another array during the lookup. Now this is fixed so that a lookup with `unique` merge always results in a unique set of values.