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

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.0.1

Released July 19, 2017.

This is a minor bug fix release following the major 5.0 release.

* [All issues fixed in Puppet 5.0.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+5.0.1%27)

### Bug fixes

The Hiera option `sort_merged_arrays` which is used to get sorted arrays when merging was silently ignored (no sorting took place).

Previously, Puppet's vendored `semantic_puppet` implementation would reject pre-release module versions containing leading zeros with hex digits, for example, `00abc`. This has been updated so that the vendored `semantic_puppet` accepts them, and is the same fix as was applied to the external `semantic_puppet` gem. (Related: [MODULES-5159](https://tickets.puppetlabs.com/browse/MODULES-5159))

The `Timestamp` data type could not correctly parse a string where date and time were separated by a space. To resolve this, a new default format that allows this has been added.

### Regression fixes

A regression in Puppet 4.7.0 made the command `epp render` fail loading 4.x functions when evaluating a template. The same template would work fine when used in a manifest.

These regressions introduced in 5.0.0 have been resolved in Puppet 5.0.1:

If a provider called `execpipe` the external command failed. Puppet now correctly processes the execution failure.

When running `puppet module install` via bundler an issue occurred only if the Gemfile directly or indirectly expressed a dependency on the `semantic_puppet` gem. A common way for this to happen was if the module's Gemfile relied on the `metadata-json-lint` gem, which depends on `semantic_puppet`. This fix ensures Puppet works correctly when using either the external `semantic_puppet` gem or the vendored version in Puppet.

On Centos 7, Puppet could not create a user and set the owner of a file to that user in the same run.

In Puppet 5.0.0, `puppet resource` could not load custom types from modules when an explicit `modulepath` was specified.


## Puppet 5.0.0

Released June 26, 2017.

This release of Puppet is included in Puppet agent 5.0.0. This release is removal heavy --- many features that were deprecated in Puppet 4 have been removed. Although they've had a long deprecation period, some of these could still be in use and introduce breaking changes for your Puppet installation. Read through the list of removals to check for updates you may need to make.

* [All issues fixed in Puppet 5.0.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+5.0.0%27)

### New features

#### Added function: `call`

The function `call(name, args...)` has been added to allow calling a function by name.

#### Added function: `unique`

The function `unique` is now available directly in Puppet and no longer requires the `stdlib` module to be included. The new version of the function also handles `Hash` and `Iterable` data types. It is now also possible to give a code block that determines if the uniqueness is computed.

#### Puppet Server request metrics available

Puppet Server 5 includes an http-client metric `puppetlabs.<localhost>.http-client.experimental.with-metric-id.puppet.report.http.full-response` that tracks how long requests from Puppet Server to a configured HTTP report processor take (during handling of /puppet/v3/reports requests, if the HTTP report processor is configured).

### Enhancements

#### Switched from PSON to JSON as default

In Puppet 5, agents download node information, catalogs, and file metadata in JSON (instead of PSON) by default. By moving to JSON, we ensure maximum interoperability with other languages and tools, and you will see better performance, especially when the master is parsing JSON facts and reports from agents. The Puppet master can now also accept JSON encoded facts.

Puppet 5 agents and servers include a charset encoding when using JSON or other text-based content-types, similar to `Content-Type: application/json; charset=utf-8`. This is necessary so that the receiving side understands what encoding was used.

If the server compiles a catalog, and it contains binary data, typically as a result of inlining a file into the catalog using `content => file("/path/to/file")`, then the server transfers the catalog as PSON instead of JSON.


#### Ruby 2.4

Puppet now uses Ruby 2.4, which ships in the `puppet-agent` package. Reinstallation of user-installed Puppet agent gems is required after upgrade to Puppet agent 5.0.

* Due to Ruby API changes between Ruby 2.1 and 2.4, any user-installed Puppet agent gems (Ruby gems installed using Puppet agent's gem binary) require re-installation following upgrade to Puppet agent 5.0.

* Some gems may also require upgrades to versions that are compatible with Ruby 2.4.

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

All individual variables in the `$settings` namespace are now available as a Hash of `<SETTING_NAME> => <SETTING_VALUE>` in the variable `$settings::all_local`. This helps you reference settings that might be missing, because a direct reference to such a missing setting raises an error when `--strict_variables` is enabled.

#### Hiera 5 default file

Hiera 5 compliant default files go in your `confdir` and `env-directory`.

* New installs: Pupppet creates appropriate v5 hiera.yaml in $confdir and $environment
* On upgrade: If Puppet detects a hiera.yaml in either `$confdir` or `$environment`, it won't install a new file in either location, or remove `$hieradata`.

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

* The `external_facts` feature is deprecated, the version of Facter Puppet depends on now always includes this functionality.

* The experimental "data in environments and modules" support implementation has been deprecated in favor of Hiera version 5. Implementors of custom experimental data providers using the experimental "version 4" should migrate their implementations as soon as possible because there is no guarantee that the experimental APIs will continue to work. Users of the hiera.yaml version 4 format, and the built in data providers for JSON and YAML, as well as the `data()` function can migrate at their own pace as those features are deprecated but still supported.

* The keywords `site`, `application`, `consumes` and `produces` that were earlier opt-in via the `app_management` setting are now always keywords. The `app_management` setting is now also deprecated, but will remain as a setting without any effect until a future Puppet release. This means that Puppet will always be enabled for application management without the earlier required opt-in.

* The system now behaves as if the setting `--trusted_server_facts` is always set to true, and the setting itself is deprecated but is still present; this is to avoid errors if you already had set it to true (which is now the default). The setting will be removed in a future major version update, and before then any use of the setting `trusted_server_facts` should have been removed.

### Removals

In most cases, these features have been deprecated for several versions of Puppet and often are replaced by new features, so their removal shouldn't affect most users.

* Running 32-bit Puppet agent on a 64-bit Windows system was deprecated as of December 31, 2016. Now, the installer will prevent you from installing a version of Puppet that doesn't match your Windows architecture.

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

* [PUP-6182](https://tickets.puppetlabs.com/browse/PUP-6182): Environment catalog compilation now gives more helpful error messages when components are incorrectly mapped to nodes, or not mapped to nodes at all.

* [PUP-3552](https://tickets.puppetlabs.com/browse/PUP-3552): The server replies with [descriptive errors](./http_api_json_switch.html#server-error-responses) if the agent uses the HTTP `Content-Type` header incorrectly, or if serialization fails.

* [PUP-3478](https://tickets.puppetlabs.com/browse/PUP-3478): Removed the `extlookup2hiera` binary, which did not work since the `extlookup` function it depended on had already been removed in Puppet 4.x.

* [PUP-3170](https://tickets.puppetlabs.com/browse/PUP-3170): Puppet now raises errors when converting integer values out of 64-bit range, or `BigDecimal` values out of range for `Float`.

* [PUP-3042](https://tickets.puppetlabs.com/browse/PUP-3042): When a catalog contained a circular dependency error (or other similar general errors), a report from the agent would not show up as being in error. This is now changed so that any logged errors during the application of a catalog that are also included in the report log now sets the report's status to 'failed'.

* [PUP-2280](https://tickets.puppetlabs.com/browse/PUP-2280): Puppet now reports runs as failed when an exec resource fails to refresh. In the past, failures to restart would not flag the run as failed.

* [PUP-1723](https://tickets.puppetlabs.com/browse/PUP-1723): The yumrepo provider will includes context information when changing the mode of a repo file, `Info: Yumrepo[IUS](provider=inifile): changing mode of /etc/yum.repos.d/puppet-agent.repo from 600 to 644`


* [PUP-1890](https://tickets.puppetlabs.com/browse/PUP-1890): In some scenarios Puppet could fail to manage file resources with UTF-8 file names because of incorrect character encoding and escaping when transforming requests into URI-compatible text.

* [PUP-1441](https://tickets.puppetlabs.com/browse/PUP-1441), [PUP-7063](https://tickets.puppetlabs.com/browse/PUP-7063): Prior to Puppet 5.0.0, when printing values to the console that were in a character encoding incompatible with UTF-8 or contained invalid byte sequences, Puppet would fail, usually with an `incompatible encodings` error. In Puppet 5.0.0 and later, Puppet logs in UTF-8, and issues a warning upon encountering invalid strings with their content and the backtrace leading up to the log event.

* [PUP-25](https://tickets.puppetlabs.com/browse/PUP-25): Puppet has always evaluated collections before applying default values defined via resource type defaults, making it impossible to use such values when performing collection. This is now changed and an example like this now works as expected:


	   File { tag => 'sc_test' }
	   File { '/tmp/test': ensure => present }
	   File <<| tag == 'sc_test' |>>


   >*Note:* This change affects existing logic where it was assumed that default values were set via resource type defaults were *not* present at the time of collection.

* [PUP-7554](https://tickets.puppetlabs.com/browse/PUP-7554): With the introduction of Hiera 5 there were errors if a module or environment root contained a hiera.yaml in the Hiera 3 format. These files were never used earlier, but now they are part of the Hiera 5 configuration. The issue is fixed by ignoring the files if they are version 3 and by logging a warning when encountered. You should migrate to Hiera 5, or move those files to another location.

* [PUP-7478](https://tickets.puppetlabs.com/browse/PUP-7478): Puppet provides additional information when a feature is not suitable on a given platform.

* [PUP-7485](https://tickets.puppetlabs.com/browse/PUP-7485): It was not possible to call a function defined in the main manifest from logic in a module. This now works for those special occasions when it is actually needed, but the best practice is to autoload functions.

* [PUP-7529](https://tickets.puppetlabs.com/browse/PUP-7529): This fixes a bug in the rpm package provider that didn't properly sort packages containing tildes that did not occur as the first character.

* [PUP-7475](https://tickets.puppetlabs.com/browse/PUP-7475): A literal regex for matching a backslash previously caused a lexer error.

* [PUP-7492](https://tickets.puppetlabs.com/browse/PUP-7492): Previously in Hiera data, if aliasing a key and the value for that key contained escaped interpolations those escaped interpolations would be taken as interpolations instead of keeping the aliased value intact.

* [PUP-7464](https://tickets.puppetlabs.com/browse/PUP-7464): A regression caused resource parameter values containing Array or Hash values with embedded `undef` values to report a warning `... will be converted to string` and the parameter value would end up being a String in the serialization of a catalog. This has changed so that `undef` values are serialized as a JSON compliant `nil` value.

* [PUP-7514](https://tickets.puppetlabs.com/browse/PUP-7514): It was not possible to call the `break()` function to end the iteration in a `reduce` code block.

* [PUP-7465](https://tickets.puppetlabs.com/browse/PUP-7465): When using `puppet generate types` for environment isolation, a type with a multipart namevar title previously lead to an error of "Error: undefined method `call' for :top_level:Symbol".

* [PUP-7660](https://tickets.puppetlabs.com/browse/PUP-7660): Virtual resources with relationship metaparameters containing a reference to a non existing resource was validated even if the resource was not realized.

* [PUP-7650](https://tickets.puppetlabs.com/browse/PUP-7650): Intermittently, Puppet would report errors on the form "Attempt to redefine entity" when `puppet generate types` was being used. This was caused by internal Puppet logic not being consistent about names in upper and lowercase.

* [PUP-7627](https://tickets.puppetlabs.com/browse/PUP-7627): Puppet's interface with the `CreateSymbolicLinkW` Windows API function previously defined an incorrect return type which could cause unexpected results in the case of an error.

* [PUP-7625](https://tickets.puppetlabs.com/browse/PUP-7625): Updated the logcheck rule to match when the master compiles a catalog for a node in a given environment.

* [PUP-7616](https://tickets.puppetlabs.com/browse/PUP-7616): Change reports describing a change in a resource property "from" - "to" would output structured data for "from" but not for "to"; which was always shrinkwrapped into an awkward string representation. Now the "to" in a property change report is formatted in the same structured was as the "from".

* [PUP-7436](https://tickets.puppetlabs.com/browse/PUP-7436): A default value expression for an EPP parameter of `undef` previously did not take effect and the parameter was instead resolved against an outer scope.

* [PUP-7402](https://tickets.puppetlabs.com/browse/PUP-7402): Certain combinations of references to `File` resources where title and reference were not the same with respect to use of a trailing `/` could cause a reference to not be resolved and resulting in an error. This is now fixed.

* [PUP-7382](https://tickets.puppetlabs.com/browse/PUP-7382): Values in reports that were earlier serialized using Ruby specific YAML tags are now serialized as hashes with a special key stating the data type - making them valid general YAML.

* [PUP-7381](https://tickets.puppetlabs.com/browse/PUP-7381): YAML produced from Puppet could sometimes not be read by the consumer due to different Ruby versions in the producer and consumer. This fix ensures that the YAML format is consistent regardless of Ruby version.

* [PUP-7437](https://tickets.puppetlabs.com/browse/PUP-7437): Changed DragonFly BSD to use the `pkgng` package provider by default.

* [PUP-7431](https://tickets.puppetlabs.com/browse/PUP-7431): The vendored `semantic_puppet` gem was upgraded to version 1.0.0, which resolved multiple bugs.

* [PUP-7329](https://tickets.puppetlabs.com/browse/PUP-7329): Running `puppet describe <type>` generated malformed output if the description was too long.

* [PUP-7258](https://tickets.puppetlabs.com/browse/PUP-7258): We removed Puppet's gem dependency on `pure_json`, and instead we rely on the native `json` implementation in Ruby 1.9.3 and up.

* [PUP-7256](https://tickets.puppetlabs.com/browse/PUP-7256): Internally we're changing from PSON to JSON when pretty printing console output, for example, `puppet facts find`, but there shouldn't be any visible user changes.

* [PUP-7110](https://tickets.puppetlabs.com/browse/PUP-7110): A Puppet resource is now able to halt the Puppet service without terminating an agent run started by that service.

* [PUP-7130](https://tickets.puppetlabs.com/browse/PUP-7130): Ruby 2.4 previously could not be used with Puppet because in Ruby 2.4 the `Fixnum` and `Bignum` classes have been merged into `Integer`, and Puppet explicitly uses `Fixnum` as `Bignum` (roughly: Integers larger than 64 bits) is not supported by Puppet other than as an intermediate result in arithmetic.

* [PUP-7155](https://tickets.puppetlabs.com/browse/PUP-7155):The command `puppet resource` could output information about resources that could not be directly used in a Puppet manifest because of errors related to quoting and escaped characters.

* [PUP-7073](https://tickets.puppetlabs.com/browse/PUP-7073): Puppet now attempts to translate selinux contexts itself, instead of relying on mcstransd. This is to work around instabilities in that service. This means that Puppet now requires a `setrans.conf` file to exist for the active selinux policy when it is managing selinux attributes.

* [PUP-6984](https://tickets.puppetlabs.com/browse/PUP-6984): It was not possible to always use a resource alias when forming a resource relationship. If the relationship was formed with a relationship operator ( like `->` or `~>`), the compilation would fail. If a metaparameter was used to form the relationship further problems would be triggered. Both issues are now fixed.

* [PUP-6930](https://tickets.puppetlabs.com/browse/PUP-6930): Duplicate literal default entries in case and selector expressions now always error. Earlier this was under the control of the `--strict` option.

* [PUP-5973](https://tickets.puppetlabs.com/browse/PUP-5973): Previously Puppet monkey patched the `Symbol` class so that it was comparable to String, so for example, `:foo == "foo"` would evaluate to true. This ticket removes the monkey patch. It should not affect users unless they are using Puppet as a library and are unintentionally relying on this behavior (we've been emitting deprecation warnings about this since 4.x).

* [PUP-6660](https://tickets.puppetlabs.com/browse/PUP-6660): When you run `puppet agent --test`, Puppet uses the cached catalog (if `use_cached_catalog = true` in settings or enabled via command-line flag). Puppet now behaves like it did pre-4.6.0 with respect to cached catalogs.

* [PUP-5659](https://tickets.puppetlabs.com/browse/PUP-5659): Relationships formed via metaparameters (like `require`) are now validated when everything in a catalog has been evaluated, and if there is a reference to a resource that is not in the catalog an error is raised. In earlier versions, an error was raised when the catalog was applied on an agent. Now an error is raised when validating the compilation result. In earlier versions this was only done when a relationship was formed using the arrow operators. The behavior could be controlled with the `strict` setting but it would then issue warnings or error for relationships formed with aliases. Both problems are now fixed.

* [PUP-5635](https://tickets.puppetlabs.com/browse/PUP-5635): Instead of an error/undef when referencing a non existing variable, Puppet could end up resolving the last part of a qualified name against top scope such that a request for `$::somemodule::x` would be satisfied by the existence of a topscope `$::x` variable.

* [PUP-5479](https://tickets.puppetlabs.com/browse/PUP-5479): Incorrectly prepared augeas resources crashed Puppet agent with a segfault and caused it to hang. The augeas component was updated from 1.4.0 to 1.8.0 to resolve this issue.

* [PUP-4283](https://tickets.puppetlabs.com/browse/PUP-4283): The Puppet Module Tool (PMT) used both the vendored Semantic library and the Puppet::SemVer module to check version numbers for modules. Now PMT only uses the vendored Semantic library. This removes inconsistencies between the various places semantic versions were compared as well as fixes issues with certain types of version compares, because the Semantic library is now updated.

* [PUP-3940](https://tickets.puppetlabs.com/browse/PUP-3940): Puppet now sends proper MIME content types, like `application/json`, instead of format names, `json`, in its `Accept` header when making HTTP requests.

* [PUP-7674](https://tickets.puppetlabs.com/browse/PUP-7674): A problem was found with the environment isolation solution (`generate types`) where a collection of a type would cause it to be loaded as a Ruby implementation instead of the generated metadata. This in turn could cause isolation problems if different environments had different versions of this type.
This is now fixed so collectors also load the generated metadata form if present.

* [PUP-7671](https://tickets.puppetlabs.com/browse/PUP-7671): Puppet 4.10.3 contained a regression where resources created using the syntax `Resource[xx::yy]` would cause an error because Puppet would not find an existing `xx::yy` user defined resource type. This was caused by fixing another problem with inconsistent use of upper and lowercase in references.

* [PUP-7611](https://tickets.puppetlabs.com/browse/PUP-7611): Some deprecation warnings were issued even when using `--disable_warnings deprecations`.

* [PUP-7587](https://tickets.puppetlabs.com/browse/PUP-7587): A regression was found that from Puppet >= 4.9 Hiera data containing `Integer` or `Float` keys ended up having those keys converted to `String`. The intention was to only filter out Ruby `Symbol` keys. `Integer` and `Float` keys in hashes now work as they should.

* [PUP-7579](https://tickets.puppetlabs.com/browse/PUP-7579): Puppet now accepts unicode tags, which is useful if you want to run a subset of resources in a catalog using a tag name that isn't US-ASCII. This also allows the `concat::fragment` defines from the concat module to write to file paths that are not US-ASCII. This is considered a bug fix, because Puppet accepts unicode for other inputs like resource names and titles, but not tags.

<!-- We'll also need to update the public docs that specify the valid tag regex. (There might already be a PR for this from Ethan??) -->

* [PUP-6596](https://tickets.puppetlabs.com/browse/PUP-6596): Upgraded to CFPropertyList 2.3.5, which adds support for Ruby 2.4 and fixes an issue with parsing large blocks of XML content.

* [PUP-6517](https://tickets.puppetlabs.com/browse/PUP-6517): If the rpm provider failed to query a package source, it would generate a different error unrelated to the original problem. This fix ensures the original error is preserved and reported.

* [PUP-6264](https://tickets.puppetlabs.com/browse/PUP-6264): A version range declared as `>=x.y.z` would incorrectly include pre-releases of version x.y.z. That is now corrected so that pre-releases are always considered to be semantically less than the actual release.

* [PUP-6368](https://tickets.puppetlabs.com/browse/PUP-6368): When converting version ranges back to their string representation, the string would often be different and sometimes even invalid. The original string representation is now properly retained.

* [PUP-6367](https://tickets.puppetlabs.com/browse/PUP-6367): A `VersionRange` data type created from the string `'1.2.3'` resulted in the range `1.2.3...1.2.4`, which was incorrect even if 3 dots means "exclude end", because that range included all prebuild releases between 1.2.4-nnn to the final release 1.2.4. The correct exact range is now `1.2.3..1.2.3` that is, a range that has the same begin and end, and that doesn't exclude end.
