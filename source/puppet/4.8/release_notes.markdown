---
layout: default
toc_levels: 1234
title: "Puppet 4.8 Release Notes"
---

This page lists the changes in Puppet 4.8 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.7 release notes](/puppet/4.7/release_notes.html) and [Puppet 4.6 release notes](/puppet/4.6/release_notes.html).

## Puppet 4.8.2

Released January 19, 2017.

* [Fixed in Puppet 4.8.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.8.2%27)
* [Issues Introduced in 4.8.2]()

This is a bug fix release in the Puppet 4.8 series.

### Deprecation

In Puppet 4.8.0, the stacktrace property was removed from Puppet's HTTP error response API. This was an unintentional backwards-incompatible change, and in Puppet 4.8.2, the stacktrace property has been returned to the response object, but instead of containing the stack trace message, it now contains a deprecation warning. Users consuming the stack trace property of the Puppet HTTP error response API should instead review the Puppet log for this information.


### Bug fixes

Previously, it was not possible to interpolate a Boolean `false` value in a hiera configuration because it ended up being a blank string. Now the value interpolates to the string `"false"`. ([PUP-6974](https://tickets.puppetlabs.com/browse/PUP-6974))

#### Regression fix

A regression introduced in Puppet 4.8.0 caused an attempt to lookup a string containing more than one interpolation that iself used interpolation function Hiera (for example, `%{hiera('some_key')}`) to fail when running with trace level set to debug. This regression ([PUP-7061](https://tickets.puppetlabs.com/browse/PUP-7061)) is now fixed. 



## Puppet 4.8.1

Released November 22, 2016.

* [Fixed in Puppet 4.8.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.8.1%27)
* [Issues Introduced in Puppet 4.8.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.8.1%27)

This is a minor maintenance and bug fix release.

### Bug fixes

* [PUP-6876](https://tickets.puppetlabs.com/browse/PUP-6876): `puppet config set` and `puppet config print` now behave properly when using UTF-8 characters in the puppet.conf INI file.

* [PUP-6861](https://tickets.puppetlabs.com/browse/PUP-6861): In Puppet 4.8.0, a new functionality was added to the mount provider intended to detect if a mounted filesystem did not match /etc/fstab. Unfortunately, there is not a reliable mechanism for doing this and the detection did not work as intended. It has been removed.

## Puppet 4.8.0

Released November 1, 2016.

* [Fixed in Puppet 4.8.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.8.0%27)
* [Issues Introduced in Puppet 4.8.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.8.0%27)


### New features

#### New types

The type system has been extended with two types that help working with time related values. The Timestamp type is a point in time, and the Timespan is a duration. Both support nano second resolution if available on your platform. Values can be created with the new function and multiple time formats are supported. Arithmetic and comparison operations can be performed on time values.

* [PUP-5871](https://tickets.puppetlabs.com/browse/PUP-5871)

#### New functions `break`, `next`, and `return`

The functions `break()`, `next()` and `return()` have been added to make it possible to do an "early exit" from a block of code. In summary `break()` will break the innermost iteration, `next()` will return from a lambda/block/class or resource body and `return()` will return from a function or class or resource body. See the respective function for more details.

* [PUP-4643](https://tickets.puppetlabs.com/browse/PUP-4643)

#### Absolute support

It is now possible to specify that an absolute (positive) value is wanted when creating a new Integer, Float, or abstractly via Numeric by passing a second optional Boolean argument to the `new` function where `true` means that an absolute value is wanted. For example `Numeric.new($str, true)` which converts the numerical value in string form (with a possible leading minus) to an absolute value.

* [PUP-6291](https://tickets.puppetlabs.com/browse/PUP-6291)

#### Access to stacktrace

The 4.x Function API now has a mechanism for getting the source file and line location for calls from a manifest. You can read more about this in the [language specification](https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#access-to-stacktrace).

### Enhancements

* [PUP-6669](https://tickets.puppetlabs.com/browse/PUP-6669): The error message shown when there is a type mismatch between and Enum data type and a String has been improved to show the value of the string.

* [PUP-6502](https://tickets.puppetlabs.com/browse/PUP-6502): Performance enhancements for managing users on OSX.

* [PUP-6513](https://tickets.puppetlabs.com/browse/PUP-6513): The amount of debug logging from the `lookup` function and CLI has been increased to help troubleshooting. Now, when the log level is `debug`, the output as produced by the lookup CLI `--explain` will be logged.

* [PUP-6508](https://tickets.puppetlabs.com/browse/PUP-6513): Multiple tidy resources can now manage the same directory.

* [PUP-5831](https://tickets.puppetlabs.com/browse/PUP-5831): The type system and runtime now support binary data by using the Binary type. It allows binary content to be created from plain text and base 64 encoded text.

* [PUP-5623](https://tickets.puppetlabs.com/browse/PUP-5623): It is now possible to specify the return type of functions and lambdas to get an automatic assertion that the function returned a value of the expected type. This helps reduce the amount of checking done at the calling end. 

  As an example, `function min(Integer $x, $y) >> Integer` defines that the function `min` returns an `Integer`.

* [PUP-5623](https://tickets.puppetlabs.com/browse/PUP-5623): Compiler profiling is now output at log level `info`, which removes the need to bump the log level to `debug`. This makes it convenient to get only the profiling information without having to restart the Puppet server.

* [PUP-6789](https://tickets.puppetlabs.com/browse/PUP-6789): This allows application components to consume capabilities from other environments. If multiple capabilities are found the capability from the current environment will be preferred.

### Bug fixes

* [PUP-6803](https://tickets.puppetlabs.com/browse/PUP-6803): Some puppet types (notably `file` and `user`) are capable of generating resources. For example, a managed directory file resource with `recurse => true` generates resources of any subdirectories/files in that directory so that Puppet can apply management to them. 

  Prior to this bug fix, if for some reason Puppet encountered an exception or issue while generating these resources (for example, if an unmanageable file such as a socket exists in a managed directory with `recurse => true`), this failure would be logged in the run report, but run report's overall status would still be considered successful (for example, a status of either `changed` or `unchanged`). 

  In Puppet 4.8.0 and later, if Puppet fails to generate resources for any managed resource, this results in a report status of `failed`.

* [PUP-6798](https://tickets.puppetlabs.com/browse/PUP-6798): Fixed an issue where ensuring latest did not use the upgrade command in DNF.

* [PUP-6753](https://tickets.puppetlabs.com/browse/PUP-6753): All of the logging functions (like `notice`, `debug`) leaked a Puppet internal value to the Puppet Language. Under rare circumstances the returned value could be used to produce a string value. This is now fixed so that logging functions always return `undef` as intended.

* [PUP-6752](https://tickets.puppetlabs.com/browse/PUP-6752): A regression was found when `app_management` was turned on regarding testing if a file resource was defined or not and ending (or not ending) with a slash. The regression caused compilation with `app_management` to behave differently than when it was turned off. Now it behaves the same way.

* [PUP-6765](https://tickets.puppetlabs.com/browse/PUP-6765): Previously, using produce/consume statements with `puppet generate` could result in 'Attempt to redefine entity' errors, but this has been resolved.

* [PUP-6417](https://tickets.puppetlabs.com/browse/PUP-6417): Previously, the `ssh_authorized_key` resource type would not match entries which had multiple spaces between fields - this is now fixed.

* [PUP-6807](https://tickets.puppetlabs.com/browse/PUP-6807): Puppet extensions with Ruby errors (specifically noted in custom functions that referenced undefined local variables) caused Puppet to create an error message that contained most of the Ruby object space. This message could be gigabytes in size and under load would cause the Puppet Server process to die with an `OutOfMemoryError`. Now failure to load a Puppet extension will create a reasonably short error string that will *not* use excessive memory.

* [PUP-6693](https://tickets.puppetlabs.com/browse/PUP-6693): If an assignment was made to `$server_facts` and `--trusted_server_facts` was not in effect there was no warning. Now this is controlled by the `--strict` option. This makes it easier to prepare for a later update when `--trusted_server_facts` is on by default.

* [PUP-6714](https://tickets.puppetlabs.com/browse/PUP-6714): The opt-in feature `puppet generate types` did not generate the correct information for capability resources used in application orchestration which caused environment catalog compilation for orchestration to fail.


* [PUP-6682](https://tickets.puppetlabs.com/browse/PUP-6682): A problem was fixed regarding values set in variables in the `settings` namespace where settings that internally used Ruby Symbols leaked those into the Puppet language, making it impossible to compare them with String values. Now, those settings (as well as all others not having a Puppet language representation) are turned into values that can be used.

* [PUP-6568](https://tickets.puppetlabs.com/browse/PUP-6568): Puppet now provides a reasonable error message if it finds unexpected binary files when processing launchd service entries.

* [PUP-6563](https://tickets.puppetlabs.com/browse/PUP-6563): Pessimistic version constraints (the "twiddle-wakka" `~>`) now work in the Gem provider on Windows.

* [PUP-6135](https://tickets.puppetlabs.com/browse/PUP-6135): The messages about type mismatch errors have been modified to use more consistent wording for different kinds of mismatches.

* [PUP-3182](https://tickets.puppetlabs.com/browse/PUP-3182): This fixes a long standing issue in faces that implement the `save` command. This corrects the underlying call to the `Indirection#save` method with arguments in the correct positions. Previously, calls to faces utilizing the save facility would throw an error. One example of this was `puppet catalog download`.

* [PUP-6414](https://tickets.puppetlabs.com/browse/PUP-6414): Updated the puppet module tool to use "forgeapi.puppet.com" (instead of "forgeapi.puppetlabs.com").

