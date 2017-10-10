---
layout: default
toc_levels: 1234
title: "Puppet 4.6 Release Notes"
---


This page lists the changes in Puppet 4.6 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.5 release notes](/puppet/4.5/release_notes.html) and [Puppet 4.4 release notes](/puppet/4.4/release_notes.html).

## Puppet 4.6.2

Released September 1, 2016.

This release fixes a few more regressions relative to Puppet 4.5, as well as bugs in features introduced in 4.6.

* [Fixed in Puppet 4.6.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.6.2%27)
* [Introduced in Puppet 4.6.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.6.2%27)

### Bug fixes

#### Regressions

* [PUP-6629](https://tickets.puppetlabs.com/browse/PUP-6629): Puppet 4.6 was causing hard failures in Puppet runs that worked fine in 4.5. These failures happened whenever certain resource types were used, most notably the `acl` type from the `puppetlabs-acl` module.

    This was a side effect of corrective change reporting: if a resource type didn't handle deserialization well, Puppet couldn't cope with the error and the run would fail. With this fix, Puppet will still finish the run gracefully if it can't identify corrective changes for one resource type.

    We plan to fix the ACL module's serialization handling in [MODULES-3766](https://tickets.puppetlabs.com/browse/MODULES-3766).

* [PUP-6650](https://tickets.puppetlabs.com/browse/PUP-6650): The fix for [PUP-6608](https://tickets.puppetlabs.com/browse/PUP-6608) in Puppet 4.6.1 could disrupt regular (node) catalog compilation if the `hiera_include` function was in use. This is now fixed.

#### Fixes for older bugs

* [PUP-6647](https://tickets.puppetlabs.com/browse/PUP-6647): Functions that use the modern Ruby function API (`Puppet::Functions` or "4x functions") can do different things depending on how many arguments they're called with. Unfortunately, functions that can be called with _zero_ arguments would _always_ use their zero-argument behavior, regardless of how they were actually called. This is now fixed, and zero-argument dispatches are only be used when no arguments are provided.


#### Bugs with new features

* [PUP-6662](https://tickets.puppetlabs.com/browse/PUP-6662): Classes and defined types can specify a Sensitive data type for any of their parameters. But prior to this change, it was impossible to pass Sensitive values when declaring them: they would get erroneously transformed to plain strings.

* [PUP-6653](https://tickets.puppetlabs.com/browse/PUP-6653): [Environment isolation](./environment_isolation.html) for resource types wasn't working properly --- even if PCore resource type data was found, Puppet would load the Ruby implementation anyway. This is now fixed, and the presence of a PCore resource type will prevent the Ruby version from loading.

## Puppet 4.6.1

Released August 23, 2016.

A critical bug was reported affecting a significant number of users in the Puppet 4.6.0 release.

A regression in evaluation of resource-like class inclusion caused evaluation of the class to be lazy as opposed to the correct immediate evaluation. This led to problems with missing variables, which could lead to further problems. The order of evaluation is now restored. ([PUP-6608](https://tickets.puppetlabs.com/browse/PUP-6608))

Other bug fixes and a new function are also included in this release in the Puppet 4.6 series.

* [Fixed in Puppet 4.6.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.6.1%27)
* [Introduced in Puppet 4.6.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.6.1%27)

### New function

The function `unwrap` was added that allows `Sensitive` data to be obtained in clear text in a controlled way. Learn more about the `Sensitive` type in the [4.6.0 release notes](#sensitive-type-added).

### Bug fixes

* [PUP-6627](https://tickets.puppetlabs.com/browse/PUP-6627): Prior to this change, `--show_diff` for `puppet agent` and `puppet apply` could problematically show redacted data when a resource contained a Senstive data type.

* [PUP-6597](https://tickets.puppetlabs.com/browse/PUP-6597): When the 'generate type' command reported that it generated output to a path the path was always wrong. This had no other consequences than misinforming the user watching the generate commands output.

* [PUP-6621](https://tickets.puppetlabs.com/browse/PUP-6621): Corrective change would incorrectly fail a catalog application when a type or property was incompatible with it. It now logs this information at info level.

* [PUP-6613](https://tickets.puppetlabs.com/browse/PUP-6613): A regression made it impossible to give an attribute as undef when there is no default value expression for a resource parameter and using `create_resources` to create the resource. There was no regression when doing the same from a manifest directly.

* [PUP-6622](https://tickets.puppetlabs.com/browse/PUP-6622): Function loading and calling was hit by a performance regression that caused a 300% degradation in performance as observed by benchmarks. This is now fixed.

* [PUP-6628](https://tickets.puppetlabs.com/browse/PUP-6628): Corrective change calculation is now more robust when properties have complex munge and validate methods.

* [PUP-6574](https://tickets.puppetlabs.com/browse/PUP-6574): Camel-cased class names such as `myType` were allowed but could not be included in the catalog. Now they can.

* [PUP-6397](https://tickets.puppetlabs.com/browse/PUP-6397): Overly aggressive auto relationships between mount and file types have been scaled back.

* [PUP-6582](https://tickets.puppetlabs.com/browse/PUP-6582): Under certain circumstances, when `environment_timeout` was set to a value greater than 0 the top scope of the first used compilation request would become sticky and lookups of variables made by functions would get values from the first compilation in that environment. This also caused memory to leak and could in some situations lead to an `Out of Memory` error.

* [PUP-2018](https://tickets.puppetlabs.com/browse/PUP-2018): This fixes a bug in the `puppet certificate generate` command where it attempted to generate a CSR for the FQDN for the host when the same FQDN was provided as the remote.


## Puppet 4.6.0

Released August 10, 2016.

A feature and bug fix release for Puppet.


* [Fixed in Puppet 4.6.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.5.3%27)
* [Introduced in Puppet 4.6.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.6.0%27)

### New features

#### Identify manual change corrected by Puppet

This release adds a new report event field called `corrective_change` that is designed to detect manual change that has been corrected by a Puppet run.

This feature should help users to detect when an unexpected change occurred outside of Puppet, allowing better auditing and understanding around changes.

This feature achieves this by storing the last best known value for each property that is applied by Puppet, and comparing that against the values in the next Puppet run.

As part of the requirement to store values, this feature also introduces a new local storage mechanism, and introduces a new configuration option `transactionstorefile` which points at the YAML file used. This storage is queried for each run for old values during comparison, and persists the new values for next transaction to do its calculation.

While we’ve done our best to ensure this feature works well, this entire process is still in development and is quite new, and has some known points of interest:

* For noop events in particular, these are treated especially. We will continue to return a positive `corrective_change` flag if there will be a corrective_change, if Puppet was to be ran in enforcement mode.

* Today, idempotency issues are raised as a `corrective_change` because Puppet can’t tell the difference. An idempotency issue is when either a provider has a bug applying a change twice consistently, or when Puppet DSL code (or external dependences) is used that has idempotency issues (common in service, and exec resources for example). For properties that have known idempotency issues, we have introduced an `idempotent` flag for declaring that corrective_change calculation can be skipped. An example can be found in the notify type, as the message property on notify has been a long-standing and well known non-idempotent property: [notify type source code](https://github.com/puppetlabs/puppet/blob/4.6.0/lib/puppet/type/notify.rb#L9).

* The API for comparison in Puppet for older arbitrary values is brittle, and some custom Puppet types may show the incorrect value for corrective_change as a consequence. We ask users to raise bugs when these cases are discovered.

* For now, if there is any exception during value comparison Puppet still runs, but returns an error to the user so it can be debugged. Also, Puppet returns a `corrective_change` as nil instead, indicating an unknown state. Any cases where this occurs should be raised as bugs to the appropriate project.

* Comparison of secret values is currently out of scope. For us to ensure we could compare these values, we would have to store them in doing so leak secret information. We’ve decided we would step back from this problem, and for now secret properties are not supported for being flagged as corrective.

Along with flagging each event with the `corrective_change` field, we also flag a resource that has such events, and the entire report. Metrics have been included to allow report consumers to see a count of events that are marked as `corrective_change` also.

*[PUP-6295](https://tickets.puppetlabs.com/browse/PUP-6295)

#### Sensitive type added

A new type `Sensitive[T]` has been added to the Puppet type system. New sensitive instances can be created with `Sensitive.new(value)`. Such an instance signals to the running system that the information contained in the Sensitive object should not be leaked in clear text.

* [PUP-6434](https://tickets.puppetlabs.com/browse/PUP-6434)

#### Specify multiple masters with `server_list` option

This change adds master failover functionality to the puppet agent. Using the new `server_list` option to specify multiple masters, an agent will now attempt to fall back to a functional master should a failure to download a catalog occur. The `server_list` setting can be either provided on the command line or configured in `puppet.conf`, and has the format `server_list = master1_hostname:port,master2_hostname:port,master3_hostname:port`.

The old `server` option can still be used to specify a single master, in which case failover will not be attempted and Puppet will behave as it always has. Specifying a single server with the `server_list` option has the same effect.

* [PUP-6376](https://tickets.puppetlabs.com/browse/PUP-6376)

### Enhancements

* [PUP-6391](https://tickets.puppetlabs.com/browse/PUP-6391): The default service provider for ubuntu 16.10 is now systemd.

* [PUP-5604](https://tickets.puppetlabs.com/browse/PUP-5604): The systemd service provider now asks journalctl why something failed and reports it back to the user for aid in debugging.

* [PUP-6042](https://tickets.puppetlabs.com/browse/PUP-6042): Now using the `--test` option with puppet agent overrides the `--use_cached_catalog` setting. Declaring these options in combination does not result in the use of a cached catalog.

* [PUP-6378](https://tickets.puppetlabs.com/browse/PUP-6378): This adds a field to the report indicating which master was contacted during the run.

* [PUP-2802](https://tickets.puppetlabs.com/browse/PUP-2802): Gentoo supports 'slotting' packages which allows multiple different versions of the same package to live alongside one another. The portage package provider now understands and supports these slots.

* [PUP-4617](https://tickets.puppetlabs.com/browse/PUP-4617): `puppet cert print` now displays long names for extensions.

### Deprecations

* [PUP-6083](https://tickets.puppetlabs.com/browse/PUP-6083): The notation Class[Foo] where the name of the class is given with an upper case letter has been deprecated and will result in an error in the next major release of puppet. The deprecation warning (or optionally an error) is controlled by the `--strict`flag.

### Bug fixes

#### Language

* [PUP-6530](https://tickets.puppetlabs.com/browse/PUP-6530): When creating resources using the `create_resources` function there were no file and line information included in the resulting catalog for the resources created by the function. This is now fixed and this will improve downstream tooling that requires such information.

* [PUP-5849](https://tickets.puppetlabs.com/browse/PUP-5849): When starting a new line with a `(` this would be interpreted as an attempt to continue the last expression on the preceding line as if it was the name of a function to call. This is now changed so that for a `(` to be recognized as a parenthesis opening an argument list it must be placed on the same line as the name of the function. Otherwise it will be taken as the end of the previous expression and starting a new parenthesized/grouping expression.

* [PUP-6361](https://tickets.puppetlabs.com/browse/PUP-6361): Naming a class or a define with a leading :: (making the name absolute) lead to not being able to use that class/define. Now, such names are treated as illegal.


#### Types and Providers

* [PUP-5926](https://tickets.puppetlabs.com/browse/PUP-5926): Previously, the launchd service provider did not support overriding `status` with `hasstatus => false`. This change adds that capability.

* [PUP-1134](https://tickets.puppetlabs.com/browse/PUP-1134): This fixes the init service provider to use the correct path for init scripts on AIX.

* [PUP-2316](https://tickets.puppetlabs.com/browse/PUP-2316): This fixes allows the `attributes` parameter for the `user` resource to accept an array with a single value in AIX. Prior to this fix, an error would be thrown in the if the array only contained one value.

* [PUP-6159](https://tickets.puppetlabs.com/browse/PUP-6159): The directoryservice user provider was failing to set a password and salt under certain circumstances on OSX. This has been fixed.

* [PUP-6323](https://tickets.puppetlabs.com/browse/PUP-6323): Photon OS uses TDNF (a DNF variant) for its package manager. This bug fix adds Puppet package provider support for Photon OS.

* [PUP-6415](https://tickets.puppetlabs.com/browse/PUP-6415): This change fixes an issue in the (now deprecated) static compiler where symlinks in recursed directories did not end up with `target` attributes, causing Puppet to fail to manage them. Note that this only affects the static compiler, and *not* the newer static catalog functionality which was added as part of the direct puppet workflow.

* [PUP-6461](https://tickets.puppetlabs.com/browse/PUP-6461): This removes false package version update notices when using the pip provider and no actual change occurred.

* [PUP-6370](https://tickets.puppetlabs.com/browse/PUP-6370): Previously, when checking whether a service was enabled, the systemd provider used hardcoded strings to compare to the output of `systemctl`. Now, Puppet uses the exit code from `systemctl`, which ensures that the provider's view of a service is in line with that of the system.

* [PUP-6437](https://tickets.puppetlabs.com/browse/PUP-6437): This change fixes an issue with the directoryservice user provider in OSX, where Puppet would crash in certain circumstances while fetching bad ShadowHashData from the system. Puppet now handles this gracefully.


#### Windows

* [PUP-6115](https://tickets.puppetlabs.com/browse/PUP-6115): Fixed an erroneous command in instructions generated by Puppet to clean certs on Windows.

* [PUP-6459](https://tickets.puppetlabs.com/browse/PUP-6459): `puppet resource service` could fail on Windows when there were certain types of delayed auto start services. In particular, it would always fail on Windows 10 due to the `pvhdparser` service.

* [PUP-6499](https://tickets.puppetlabs.com/browse/PUP-6499): `puppet resource group` or `puppet resource user` could previously fail on non-English editions of Windows when there were users or groups present containing Unicode characters. This commonly occurred on the French localized edition of Windows where the "Guest" account is localized as "Invité".

* [PUP-5938](https://tickets.puppetlabs.com/browse/PUP-5938): Fixed a minor performance issue when querying for Windows groups present on the host system.


#### Puppet Server

* [PUP-3827](https://tickets.puppetlabs.com/browse/PUP-3827): In Puppet 4.0 many errors returned by our API were moved to follow best practices with regards to HTTP error codes and a JSON format that follows our documented JSON schema. However one major subsystem of Puppet (the indirector) was not converted to follow this pattern. As of this release, API endpoints that hit this subsystem will return proper HTTP error codes and message bodies that conform to our documented JSON standard. The previous behavior was to return a 400 Server Error for all issues with this subsystem.

#### Misc bug fixes

* [PUP-6413](https://tickets.puppetlabs.com/browse/PUP-6413): Puppet now correctly connects to Pypi when managing packages with pip.

* [PUP-4904](https://tickets.puppetlabs.com/browse/PUP-4904): Running `puppet describe -s ssh_authorized_key` produced garbage output because of long lines of text.

* [PUP-6125](https://tickets.puppetlabs.com/browse/PUP-6125): Running `puppet agent --verbose` used to generate log output to both console and syslog (or eventlog on Windows). When adding `--logdest syslog` option, log output was still sent to both the console and syslog (eventlog). Now adding `--logdest syslog` causes logging to be delivered only to syslog (eventlog) and not to the console.

* [PUP-5887](https://tickets.puppetlabs.com/browse/PUP-5887): This fixes a lexer error that prevented nesting string interpolation not to be properly interpolated.

* [PUP-6094](https://tickets.puppetlabs.com/browse/PUP-6094): Fixed slight differences between the output of `puppet --help` and `puppet help`.

* [PUP-6341](https://tickets.puppetlabs.com/browse/PUP-6341): Semantic Puppet (support for semver) gem was updated with fixes for problems on Ruby >= 2.3.0.

* [PUP-1796](https://tickets.puppetlabs.com/browse/PUP-1796): Puppet can now manage the root directory on unix-like systems.

* [PUP-1512](https://tickets.puppetlabs.com/browse/PUP-1512): Fixed a problem where `puppet help` face-based application could silently fail when trying to display help for each installed application.

* [PUP-5463](https://tickets.puppetlabs.com/browse/PUP-5463): Using `undef` in a collector previously lead to an error. Literal `undef` can now be used in collector queries.

* [PUP-6233](https://tickets.puppetlabs.com/browse/PUP-6233): Solaris 11.2+ SMF service restarts were returning prior to the service restarting. They will now be synchronous

* [PUP-6425](https://tickets.puppetlabs.com/browse/PUP-6425): Fixed a regression which modified Puppet to not swallow errors silently, but it caused another regression when a puppet sub-application raises an error.

* [PUP-5948](https://tickets.puppetlabs.com/browse/PUP-5948): The feature in this ticket is part of a larger feature ([environment isolation](./environmental_isolation.html)). However - the work on this changes `create_resources` slightly in that the created resources are not immediately evaluated - instead they follow the same rules as if the same resource had been created in the manifest at the point where the call to `create_resources` is made. This changes the order of evaluation between the created resources and what follows after the call to `create_resources` as the created resources are now lazily evaluated just like all other resources. Logic that depends on the order of evaluation between resources created in one call to `create_resources` and a manifest created resource created directly thereafter may need to be changed.


