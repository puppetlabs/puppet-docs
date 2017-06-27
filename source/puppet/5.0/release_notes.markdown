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

Released June 26, 2017.

This release of Puppet is included in Puppet agent 5.0.0. This release is removal heavy --- many features that were deprecated in Puppet 4 have been removed. Although they've had a long deprecation period, some of these could still be in use and introduce breaking changes for your Puppet installation. Read through the list of removals to check for updates you may need to make.

* [All issues fixed in Puppet 5.0.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+5.0.0%27)

### New features

#### Switched from PSON to JSON as default

In Puppet 5, agents download node information, catalogs, and file metadata in JSON (instead of PSON) by default. By moving to JSON, we ensure maximum interoperability with other languages and tools, and you will see better performance, especially when the master is parsing JSON facts and reports from agents. The Puppet master can now also accept JSON encoded facts.

Puppet 5 agents and servers include a charset encoding when using JSON or other text-based content-types, similar to `Content-Type: application/json; charset=utf-8`. This is necessary so that the receiving side understands what encoding was used.

If the server compiles a catalog, and it contains binary data, typically as a result of inlining a file into the catalog using `content => file("/path/to/file")`, then the server transfers the catalog as PSON instead of JSON.

* [More information about our PSON to JSON transition](./pson_to_json.html)

#### Added function: `call`

The function `call(name, args...)` has been added to allow calling a function by name.

#### Added functin: `unique`

The function `unique` is now available directly in Puppet and no longer requires the `stdlib` module to be included. The new version of the function also handles `Hash` and `Iterable` data types. It is now also possible to give a code block that determines if the uniqueness is computed.

#### Puppet Server request metrics available

Puppet Server 5 includes an http-client metric `puppetlabs.<localhost>.http-client.experimental.with-metric-id.puppet.report.http.full-response` that tracks how long requests from Puppet Server to a configured HTTP report processor take (during handling of /puppet/v3/reports requests, if the HTTP report processor is configured).

### Enhancements

#### Ruby 2.4

Puppet now uses Ruby 2.4, which ships in the `puppet-agent` package. Reinstallation of user-installed Puppet agent gems is required after upgrade to Puppet agent 5.0.
	* Due to Ruby API changes between Ruby 2.1 and 2.4, any user-installed Puppet agent gems (Ruby gems installed using Puppet agent's gem binary) require re-installation following upgrade to Puppet agent 5.0.
	* Some gems may also require upgrade to versions that are compatible with Ruby 2.4.

#### HOCON gem is now a dependency

The HOCON gem, which has previously shipped in `puppet-agent` packages, is also now a dependency of the Puppet gem.

#### You can silence warnings from metadata.json

Warnings from faulty metadata.json can now be turned off by setting `--strict=off`.

#### You can use Portage with Puppet

The Portage package manager is now installable and uninstallable.

#### Updated Puppet Module Tool's dependencies

Puppet Module Tool’s gem dependencies are updated to use `puppetlabs_spec_helper` 1.2.0 or later (which runs `metadata-json-lint` as part of the `validate` rake task).

#### `puppet device`

Notify resources can now be used with `puppet device`.

#### Variables in `$settings` available as a Hash

All individual variables in the `$settings` namespace are now available as a Hash of `<SETTING_NAME> => <SETTING_VALUE>` in the variable `$settings::all_local`. This makes it easy to lookup a setting that may be missing when `--strict_variables` is in effect.

#### Hiera 5 default file

Hiera 5 compliant default files go in your `confdir` and `env-directory`.

* New installs: Pupppet creates appropriate v5 hiera.yaml in $confdir and $environment
* On upgrade: If Puppet detects a hiera.yaml in either $confdir or $environment, it won't install a new file in either location, or remove `$hieradata`. 

#### Added command line option to pass job-id to agent

Puppet now accepts an arbitrary string as a job identifier via `--job-id` that is used in catalog requests and reports. A job id field has been added to the report.

#### Added --strict-semver

The `--strict-semver` option was added to the Puppet module commands install, list, uninstall, and upgrade. When used, module dependencies are resolved using the strict semver-range behavior specified by node semver.

#### Added support for `Sensitive` commands in the Exec resource type

Command parameters that are specified as `Sensitive.new(...)` are now properly redacted when the command fails. This supports using data from Puppet lookup and Hiera.

#### Changed behavior for relationship chains with empty sets 

<!-- This needs updating in the docs page for relationships too -->

Previously, if a relationship was formed with an empty set of references, then no relationships were created. In practice, this was a problem when an intermediate set is empty:

~~~puppet
File[a] -> [] -> File[b] 
~~~

Which results in the same as: 

~~~puppet
File[a] -> [] 
[] -> File[b] 
~~~

The same problem occurred when an intermediate set produced via collection was empty. 

~~~puppet 
File[a] -> File <| tag = 'nowhere' |> -> File[b] 
~~~

The old behavior silently ignored the empty sets. This was surprising and hard to work around. The intention with such a construct is clearly that "b" should come after "a", and optionally if there was something in the middle, then it would be between "a" and "b". 

**The new behavior:**

* If an empty intermediate set is found (denoted by `Ø`), the gap is closed as if this part did not exists in the logic. This is done silently. For example `A -> Ø -> B` is the same as `A ~> B`
* The gap is closed with the operator for the non empty right hand side. `A -> Ø ~> B` is the same as `A ~> B`
* Reverse operators work the same way `A -> Ø <~ B` is the same as `B ~> A` - this construct should in general be avoided and be expressed as `A -> Ø; B~>Ø` if it is not wanted that B is before A if the optional set is empty.


### Deprecations

* The `external_facts` feature is deprecated as the version of Facter Puppet depends on now always includes this functionality.

* The experimental "data in environments and modules" support implementation has been deprecated in favor of Hiera version 5. Implementors of custom experimental data providers using the experimental "version 4" should migrate their implementations as soon as possible because there is no guarantee that the experimental APIs will continue to work. Users of the hiera.yaml version 4 format, and the built in data providers for JSON and YAML, as well as the `data()` function can migrate at their own pace as those features are deprecated but still supported.

* The keywords `site`, `application`, `consumes` and `produces` that were earlier opt-in via the `app_management` setting are now always keywords. The `app_management` setting is now also deprecated, but will remain as a setting without any effect until a future Puppet release. This means that Puppet will always be enabled for application management without the earlier required opt-in.

* The system now behaves as if the setting `--trusted_server_facts` is always set to true, and the setting itself is deprecated but is still present; this is to avoid errors if you already had set it to true (which is now the default). The setting will be removed in a future major version update, and before then any use of the setting `trusted_server_facts` should have been removed.

### Removals

In most cases, these features have been deprecated for several versions of Puppet and often are replaced by new features, so their removal shouldn't affect most users.

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

* The SemVer class, which has been deprecated since Puppet 4.9.0, was removed from the Puppet code-base.

#### Generated Pcore metadata replaces RGen AST model

In all versions before Puppet 5.0.0, the Puppet Language AST classes (about 100) were implemented using the RGen meta modeling gem. From Puppet 5.0.0 and forward, Puppet includes its own modeling system named Pcore - based on the Puppet type system. 

In older versions, the AST runtime classes were dynamically created by RGen at runtime. Now they are instead statically generated from Pcore metadata at buildtime. This speeds up loading of the AST. 

The earlier vendored (included) RGen meta-modeling gem has also been removed from Puppet since this replacement. If you required RGen in experimental code and counted on puppet to install it, you must now install it yourself. If you relied on non-Puppet API methods brought in by RGen monkey patching you must revise your code. This should not affect any normal user code in Ruby or Puppet. 

Since RGen included monkey patching of some common Ruby classes, the removal of RGen also contributes to better performance in general. All users should see some reduction in memory use and a faster startup time for a Puppet compilation as the result of this removal.

### Known issues

We've added a dedicated known issues page to the open source Puppet documentation so that you don't need to read through every version of the release notes to try and determine whether or not a known issue is still relevant. 

* [Known issues in Puppet 5](./known_issues.html)
* [Issues introduced in Puppet 5.0.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+5.0.0%27)

### Bug fixes

These issues were resolved in Puppet 5.0.0.

* [PUP-7594](https://tickets.puppetlabs.com/browse/PUP-7594): In Puppet 4.9 and greater, a regression converted integer or float keys in Hiera data to strings. The intended behavior was to filter out Ruby Symbol keys. Integer and Float keys in hashes now work as they should.

* [PUP-7608](https://tickets.puppetlabs.com/browse/PUP-7608): In Hiera, when performing a lookup with merge strategy `unique` on an array value, the array could contain duplicates if it was never merged with another array during the lookup. Now this is fixed so that a lookup with `unique` merge always results in a unique set of values.

* [PUP-6182](https://tickets.puppetlabs.com/browse/PUP-6182):

* [PUP-3552](https://tickets.puppetlabs.com/browse/PUP-3552):

* [PUP-3478](https://tickets.puppetlabs.com/browse/PUP-3478):

* [PUP-3170](https://tickets.puppetlabs.com/browse/PUP-3170):

* [PUP-3042](https://tickets.puppetlabs.com/browse/PUP-3042):

* [PUP-2280](https://tickets.puppetlabs.com/browse/PUP-2280):

* [PUP-1723](https://tickets.puppetlabs.com/browse/PUP-1723):

* [PUP-1890](https://tickets.puppetlabs.com/browse/PUP-1890):

* [PUP-1441](https://tickets.puppetlabs.com/browse/PUP-1441):

* [PUP-25](https://tickets.puppetlabs.com/browse/PUP-25):

* [PUP-7554](https://tickets.puppetlabs.com/browse/PUP-7554):
 
* [PUP-7478](https://tickets.puppetlabs.com/browse/PUP-7478):
 
* [PUP-7485](https://tickets.puppetlabs.com/browse/PUP-7485):
 
* [PUP-7529](https://tickets.puppetlabs.com/browse/PUP-7529):
 
* [PUP-7475](https://tickets.puppetlabs.com/browse/PUP-7475):
 
* [PUP-7492](https://tickets.puppetlabs.com/browse/PUP-7492):
 
* [PUP-7464](https://tickets.puppetlabs.com/browse/PUP-7464):
 
* [PUP-7514](https://tickets.puppetlabs.com/browse/PUP-7514):
 
* [PUP-7465](https://tickets.puppetlabs.com/browse/PUP-7465):
 
* [PUP-7660](https://tickets.puppetlabs.com/browse/PUP-7660):
 
* [PUP-7650](https://tickets.puppetlabs.com/browse/PUP-7650):
 
* [PUP-7627](https://tickets.puppetlabs.com/browse/PUP-7627):
 
* [PUP-7625](https://tickets.puppetlabs.com/browse/PUP-7625):
 
* [PUP-7616](https://tickets.puppetlabs.com/browse/PUP-7616):
 
* [PUP-7436](https://tickets.puppetlabs.com/browse/PUP-7436):
 
* [PUP-7402](https://tickets.puppetlabs.com/browse/PUP-7402):
 
* [PUP-7382](https://tickets.puppetlabs.com/browse/PUP-7382):
 
* [PUP-7381](https://tickets.puppetlabs.com/browse/PUP-7381):
 
* [PUP-7437](https://tickets.puppetlabs.com/browse/PUP-7437):
 
* [PUP-7431](https://tickets.puppetlabs.com/browse/PUP-7431):
 
* [PUP-7329](https://tickets.puppetlabs.com/browse/PUP-7329):
 
* [PUP-7258](https://tickets.puppetlabs.com/browse/PUP-7258):
 
* [PUP-7256](https://tickets.puppetlabs.com/browse/PUP-7256):
 
* [PUP-7198](https://tickets.puppetlabs.com/browse/PUP-7198):
 
* [PUP-7110](https://tickets.puppetlabs.com/browse/PUP-7110):
 
* [PUP-7130](https://tickets.puppetlabs.com/browse/PUP-7130):
 
* [PUP-7155](https://tickets.puppetlabs.com/browse/PUP-7155):
 
* [PUP-7073](https://tickets.puppetlabs.com/browse/PUP-7073):
 
* [PUP-6984](https://tickets.puppetlabs.com/browse/PUP-6984):
 
* [PUP-7063](https://tickets.puppetlabs.com/browse/PUP-7063):
 
* [PUP-6930](https://tickets.puppetlabs.com/browse/PUP-6930):
 
* [PUP-5973](https://tickets.puppetlabs.com/browse/PUP-5973):
 
* [PUP-6660](https://tickets.puppetlabs.com/browse/PUP-6660):
 
* [PUP-5659](https://tickets.puppetlabs.com/browse/PUP-5659):
 
* [PUP-5635](https://tickets.puppetlabs.com/browse/PUP-5635):
 
* [PUP-5479](https://tickets.puppetlabs.com/browse/PUP-5479):
 
* [PUP-4283](https://tickets.puppetlabs.com/browse/PUP-4283):
 
* [PUP-3940](https://tickets.puppetlabs.com/browse/PUP-3940):
 
* [PUP-7674](https://tickets.puppetlabs.com/browse/PUP-7674):
 
* [PUP-7671](https://tickets.puppetlabs.com/browse/PUP-7671):
 
* [PUP-7611](https://tickets.puppetlabs.com/browse/PUP-7611):
 
* [PUP-7587](https://tickets.puppetlabs.com/browse/PUP-7587):
 
* [PUP-7579](https://tickets.puppetlabs.com/browse/PUP-7579):
 
* [PUP-6596](https://tickets.puppetlabs.com/browse/PUP-6596):
 
* [PUP-6517](https://tickets.puppetlabs.com/browse/PUP-6517):
 
* [PUP-6264](https://tickets.puppetlabs.com/browse/PUP-6264):
 
* [PUP-6368](https://tickets.puppetlabs.com/browse/PUP-6368):
 
* [PUP-6367](https://tickets.puppetlabs.com/browse/PUP-6367):
