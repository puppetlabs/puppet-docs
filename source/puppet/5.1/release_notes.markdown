---
layout: default
toc_levels: 1234
title: "Puppet 5.1 Release Notes"
---

This page lists the changes in Puppet 5.1 and its patch releases. You can also view [current known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality or significant bug fixes
* Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.1.0

Released August 17, 2017.

This is a feature and improvement release in the Puppet 5 series that also includes several bug fixes.

* [All issues resolved in Puppet 5.1.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.1.0%27)

### New platforms

Packages have been added in this release for:

* Debian 9 "Stretch"

### New features

#### Module localization

Puppet now supports module localization! You may have noticed some modules now have translated READMEs and `metadata.json` fields. The next step is translating certain log messages. This change modifies Puppet so that it is capable of consuming and displaying these log translations as they become available across modules.

#### New data type `Init`

The data type `Init[T]` has been added to the type system. This type matches a value that is a valid argument to `T.new`. The addition of this type is an enabler for features such as automatic data type conversion.

#### New function `tree_each`

The function `tree_each` has been added to allow convenient iteration, filtering, mapping, and reduction over complex structures. This function iterates recursively in a way that flattens a structure into a sequence, but that sequence retains information about the structure, making it possible to put it back together with possibly altered values. This was a difficult operation to do in Puppet language earlier and required a user to write a custom recursive function to achieve the same result.

#### New functions `any` and `all`

The functions `any` and `all` have been added to Puppet. They iterate over something iterable and can test if there is at least one element for which a lambda returns a truthy value (`any`) or if the lambda returns a truthy value for all elements (`all`).

### Improvements

The `puppet master` command now listens on both IPv4 and IPv6.

>NOTE: On macOS, the `puppet master` command may not work correctly. This can be fixed by setting `bindaddress` to `"0.0.0.0"` or `"::"`, depending on if you want to listen on IPv4 or IPv6.

* The `Timestamp` data type could not correctly parse a string where date and time were separated by space. A new default format that allows this was added.

### Bug fixes

* A regression introduced with Hiera 5 caused the setting of `data_binding_terminus=none` to turn off the `hiera_xxx` functions in addition to the expected disablement of Automatic Parameter Lookup (APL) from the global layer. This is now changed so that the `hiera_xxx` calls continue to work. The `lookup` function continues to return the same result as APL (if the terminus is disabled, then global hiera is also turned off for lookup, while APL and lookup from environment and module layers is still enabled). The `data_binding_terminus` setting is planned to be deprecated and removed along with the Hiera 3 support in a future release. With the speedups and new features in Hiera 5, there should be no reason to turn off the `data_binding_terminus`.

* If a `Timestamp` was created from a string with trailing unrecognized characters, there would be no error and the produced `Timestamp` would be based on only the recognized part. This now instead raises an error.

* Dots in package names would cause Puppet to incorrectly parse the version and architecture of a package.

* The `pip` command is now fully qualified on Windows to disambiguate between implementations.

* An issue where some commands run via `exec` or in providers would be prevented from running by selinux - because Puppet would redirect their output to a file in `/tmp`. Puppet now uses a pipe to get stdout from the executed process. This has one known side effect: on Windows if a Puppet agent run is killed, a new agent run will be prevented from starting by Puppet's lockfile until any subprocesses started by the previous agent run have completed.

* Puppet now provides a more accurate error message when a service resource lookup finds multiple versions of the resource.

* The Pip package provider's `ensure=latest` is now done with pip, so it can be done with custom PyPI repositories.

* Puppet could in some circumstances end the application of a catalog with the error `Cannot convert Puppet::Util::Log to integer` - this problem masked the real problem that Puppet tried to log information about.

* Overriding attributes of user defined resources after the resources have been evaluated leads to an inconsistent catalog in that the parameters shown are not the actual values used to produce the content of the resource. Now, the `--strict` flag helps find and correct these issues in manifests. A setting of `--strict=off` continues to behave as it did, a `--strict=warning` issues a warning for each override, and `--strict=error` causes the compilation to fail.

* The gem provider now passes along the `HOME` environment variable.
