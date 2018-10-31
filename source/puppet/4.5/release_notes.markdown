---
layout: default
toc_levels: 1234
title: "Puppet 4.5 Release Notes"
---


This page lists the changes in Puppet 4.5 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.4 release notes](/puppet/4.4/release_notes.html) and [Puppet 4.3 release notes](/puppet/4.3/release_notes.html).

## Puppet 4.5.3

Released July 20, 2016.

A minor bug fix release in the Puppet 4.5 series.

* [Fixed in Puppet 4.5.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.5.3%27)
* [Introduced in Puppet 4.5.3](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27PUP%204.5.3%27)

### Bug fix

* [PUP-4904](https://tickets.puppetlabs.com/browse/PUP-4904): Previously, the command `puppet describe -s ssh_authorized_key` produced garbage output because of long lines of text. This has been fixed.

## Puppet 4.5.2

Released June 14, 2016.

A bug fix release in the Puppet 4.5 series.

* [Fixed in Puppet 4.5.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.5.2%27)
* [Introduced in Puppet 4.5.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27PUP%204.5.2%27)

### Bug fixes

* [PUP-6279](https://tickets.puppetlabs.com/browse/PUP-6279): It was not possible to call the type() function using postfix notation, for example `1.type()` would not work, but `type(1)` did. Now both work.


* Error handling for attempts to form relationships with undef resources was improved in [PUP-6028](https://tickets.puppetlabs.com/browse/PUP-6028). This led to a problem with code using `create_resources` and the stdlib functions `ensure_resource`, `ensure_resources`, and `ensure_packages`. This combination could feed an undef resource reference into the catalog, and is now always treated as an error.

  The problem manifests itself as the error message:

  ```
  No title provided and "" is not a valid resource reference
  ```

  For more information, see [PUP-6385](https://tickets.puppetlabs.com/browse/PUP-6385).


## Puppet 4.5.1

Released June 1, 2016.

A bug fix release in the Puppet 4.5 series.

* [Fixed in Puppet 4.5.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.5.1%27)
* [Introduced in Puppet 4.5.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27PUP%204.5.1%27)

### Regression warning

A regression was found that caused undef to be equal to a literal undef when running on JRuby. This in turn is caused in what appears to be a discrepancy in the implementations of String and Symbol in MRI vs. JRuby.

Users writing Ruby code should be aware that `String == Symbol` is different than `Symbol == String` and that the safe way to make such comparisons until discrepancies are solved (or before Puppet 5.0.0) should compare symbols using `:undef.equal?(x)` rather than `:undef == x` (which will fail), and `x == :undef` (since that triggers a slower code path on JRuby).

* [PUP-6336](https://tickets.puppetlabs.com/browse/PUP-6336)


### Bug fixes

* [PUP-6354](https://tickets.puppetlabs.com/browse/PUP-6354): The Enum type did not make a unique set of its entries, which could lead to surprises when iterating its content, for example `Enum[a,b,a]` would contain 'a' twice.

* [PUP-6339](https://tickets.puppetlabs.com/browse/PUP-6339): If data in a module using "data in modules" depended on node/fact/compilation specific input it would not get the correct data if environment timeout was set to greater than 0. It would instead produce the value for the node for which a catalog was compiled in that environment's life cycle. Modules having only static data were not affected by this problem.

* [PUP-6321](https://tickets.puppetlabs.com/browse/PUP-6321): A regression from Puppet 4.4 caused types that used autorequire to fail when the referenced set contained undef entries. This could also be the cause of other errors, although none have been reported at this time.

* [PUP-6320](https://tickets.puppetlabs.com/browse/PUP-6320): A bad type mismatch message was produced when size constraint on Array was not met. It now clearly states that it was the size of the array that caused the failure.

* [PUP-6319](https://tickets.puppetlabs.com/browse/PUP-6319): A bad type mismatch message was produced when size constraint on hash was not met. It now clearly states that it was the size of the hash that caused the failure.


## Puppet 4.5.0

Released May 17, 2016.

* [Fixed in Puppet 4.5.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.5.0%27)
* [Introduced in Puppet 4.5.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.5.0%27)

### Known issue

Using `puppet module generate` now creates an examples directory instead of a tests directory.

* [PUP-4096](https://tickets.puppetlabs.com/browse/PUP-4096)

### New features

#### New functions, dig, then, and lest

Accessing data in nested structures could be difficult and required conditional logic to test for missing or optional parts of a structure. Three functions have been added to make such tasks easier; 'dig', 'then' and 'lest', which also combine nicely with the existing 'with' and 'assert_type' functions.

The functionality of the dig function is similar to the `.` notation used to access details in lookups.
* [PUP-6046](https://tickets.puppetlabs.com/browse/PUP-6046)


#### New types: SemVer and SemVerRange

SemVer and SemVerRange have been added to the Puppet Type System. This makes it possible to directly work with version related values in the Puppet language. Given version strings are validated and comparison operators (<, >, <=, =>, ==, !=, =~, !~), as well as the in-operator and case expression option matching works with these objects.

Instances of SemVer and SemVerRange are created with the `new` function support which also supports directly calling the type. As an example a new SemVer can be created like this:

```
SemVer('>=1.0.0 <2.0.0')
```

* [PUP-6221](https://tickets.puppetlabs.com/browse/PUP-6221)

####  Lookup of keys with `.` as sub-lookup

The lookup CLI tool and lookup function now handles lookup of keys with a `.` (dot) as a sub-lookup. Previously dots in keys were used verbatim. After this change it is required to quote the key (or part of the key) to get verbatim lookup of a key containing dots. It is now also possible to have Hiera style interpolation in data - thus making Hiera 3.x data files fully compatible with the new data in environments and modules implementation.

* [PUP-6091](https://tickets.puppetlabs.com/browse/PUP-6091)

#### The `new` function

It is now possible to create new instances of types by calling the function `new` or by directly calling a type (an upper case name) e.g. `MyType.new(<args-by-position>)`, or `MyType({ <args-by-name>})`.

#### New --strict option

With the new `--strict=[warn, error, ignore]` option in Puppet 4.5.0 you get warnings (or errors) when there is an attempt to set the same hash key more than once in the same hash.

Turning on `--strict` also turns on `--strict_variables`.

This enables Puppet to be as picky as possible when parsing, validating and compiling a catalog. Additional strictness may be introduced in minor releases (x.y) but not in maintenance releases (x.y.z).

The --strict option now also raises an error if a class is redefined.
The existing behavior of two classes with the same name silently being merged is now deprecated and will be removed in the next major release. The result of the current (now deprecated) behavior depends on the order the definitions are loaded, and if the class was included before or after the merge.

* [PUP-5937](https://tickets.puppetlabs.com/browse/PUP-5937)
* [PUP-5889](https://tickets.puppetlabs.com/browse/PUP-5889)
* [PUP-2695](https://tickets.puppetlabs.com/browse/PUP-2695)

#### The 4.x Function API

The 4.x Function API for Ruby functions now has a mechanism that allows defining local complex types. This helps avoid long strings and repetition when specifying the data types of function parameters.

* [PUP-5903](https://tickets.puppetlabs.com/browse/PUP-5903)

#### `always_retry_plugins`

A new setting has been added called `always_retry_plugins`. It defaults to true, which is generally the correct behavior for the agent. Puppet Server will set it to false to take advantage of some additional caching for failures during loading of types. Users that are using passenger will want to set this in their config.ru by adding a line such as `Puppet[:always_retry_plugins] = false`.

The `always_retry_plugins` setting also replaces the `always_cache_features` setting, which is now deprecated. If users are setting `always_cache_features` to true, they will want to replace that with `always_retry_plugins=false`.


#### Assign multiple variables at once

It is now possible to assign to multiple variables at once from the corresponding variables in a class scope by using the syntax:

```
[ $var1, $var2 ] = Class['classfoo::params']
```

Which has the same effect as:

```
$var1 = $clasfoo::params::var1
$var2 = $clasfoo::params::var2
```

An error is raised if the referenced variables do not exist as a variable or parameter in the referenced class.

* [PUP-6174](https://tickets.puppetlabs.com/browse/PUP-6174)


### Enhancements

#### References to resource types are now validated against existing types

Previously, all non data types were considered to be a resource type. The introduction of type aliases made it possible to validate all type references. This means that references to undefined types will be caught everywhere during compilation, not just when attempting to create a resource of that type or when forming a relationship.

* [PUP-6028](https://tickets.puppetlabs.com/browse/PUP-6028)

#### Path change of hiera.yaml

The default location of hiera.yaml has changed to the `$confdir`. Puppet now looks for hiera.yaml in `$codedir` first, then `$confdir`.

* [PUP-6178](https://tickets.puppetlabs.com/browse/PUP-6178)

### Misc Enhancements

* [PUP-5844](https://tickets.puppetlabs.com/browse/PUP-5844): In preparation for future features in Puppet, the abstract type `Object` has been added to the type system.

* [PUP-6099](https://tickets.puppetlabs.com/browse/PUP-6099): Previously, mount resources didn't generate automatic dependencies for associated file resources (via autorequires logic). This improvement adds those automatic dependencies.

### Deprecations

* [PUP-6122](https://tickets.puppetlabs.com/browse/PUP-6122): The `resource_types` endpoint has been [deprecated](./deprecated_api.html) in favor of the [`environment_classes` endpoint]({{puppetserver}}/puppet-api/v3/environment_classes.html) in Puppet Server.

### Bug fixes

* [PUP-5802](https://tickets.puppetlabs.com/browse/PUP-5802): Previously, a bug in the yum provider would cause it to incorrectly interpret epoch values of package versions as 0. Now the epoch is properly parsed from the version string.

* [PUP-4760](https://tickets.puppetlabs.com/browse/PUP-4760): Managing service resources will no longer query their status if knowledge of that status is not needed, such as when 'ensure' is not specified in the resource. This provides a small performance improvement.

* [PUP-6251](https://tickets.puppetlabs.com/browse/PUP-6251): Changes to the representation of empty array and hashes led to problems in that it became impossible to state these types. Both `Array[0,0]`, and `Array[T, 0,0]` resulted in errors.

* [PUP-5979](https://tickets.puppetlabs.com/browse/PUP-5979): A regression was detected in the `regsubst` function in that it used to support a hash replacement mapping, but this broke in 4.x. The functionality is now restored.

* [PUP-6142](https://tickets.puppetlabs.com/browse/PUP-6142): Warnings from ModuleLoader regarding unresolved module dependencies are now controlled by the Puppet `--strict` setting. When set to 'off', no warnings or errors are produced for unresolved dependencies, and when set to 'warning' one warning per unresolved module is issued per lifetime of a compile service. When set to error, compilation will stop with an error.

* [PUP-5992](https://tickets.puppetlabs.com/browse/PUP-5992): The Puppet service resource type supports attributes `start`, `stop`, and `status`, that when set, specify commands to start, stop and test the status (running or stopped) of the service. The `status` attribute was not overriding the default behvavior. With this fix it now does.

* [PUP-3740](https://tickets.puppetlabs.com/browse/PUP-3740): Puppet 4 introduced a requirement on Ruby 1.9.3 or greater, however the gemfile didn't properly state that requirement. As of Puppet 4.5.0 it now does.

* [PUP-6059](https://tickets.puppetlabs.com/browse/PUP-6059): A potential race condition verifying file checksums on GlusterFS has been fixed.

* [PUP-6120](https://tickets.puppetlabs.com/browse/PUP-6120): The Pip package provider's `ensure=latest` is now done with pip, so it can be done with custom PyPI repositories.

* [PUP-6050](https://tickets.puppetlabs.com/browse/PUP-6050): The lookup command line tool did not handle the `--unpack-arrays` option correctly and it did not work at all because of this. There were also other minor problems with the documentation that are now fixed.

>**Note**: The `--unpack-arrays` option has strange behavior, even though it now "works" this experimental feature will be removed in the next maintenance release.

* [PUP-6157](https://tickets.puppetlabs.com/browse/PUP-6157): Error messages and other output of data type information could sometimes display a Variant type having only a single variant. While correct, this verbose output is now reduced to that single type.

* [PUP-6230](https://tickets.puppetlabs.com/browse/PUP-6230): A regression was fixed where explicit nil values in Hiera data files used in modules and environments were turned into an empty hash by mistake.

* [PUP-6132](https://tickets.puppetlabs.com/browse/PUP-6132): Puppet 4.4.0 introduced a new library for managing Mac plists, but as a side-effect it degraded formatting when updating those files. Restored prettier formatting.

* [PUP-5968](https://tickets.puppetlabs.com/browse/PUP-5968): Comparing symbols to strings (or other types) in Ruby code is deprecated. This functionality was provided by a monkey patch in a Ruby dependency that Puppet no longer requires.

* [PUP-5616](https://tickets.puppetlabs.com/browse/PUP-5616): With puppet device, one could declare a resource which would never converge. In addition, some underlying errors were caught and not shown to the user. Both are fixed here.

* [PUP-5353](https://tickets.puppetlabs.com/browse/PUP-5353): Previously, the Puppet service resource attempted to enable or disable static services on systemd. This resulted in erroneous change notifications.

  This fix corrects the problem. Changing the `enable` parameter for a static service no longer triggers a change and a `debug` message is logged."

* [PUP-5296](https://tickets.puppetlabs.com/browse/PUP-5296), [PUP-5825](https://tickets.puppetlabs.com/browse/PUP-5825): Previously, SysVinit services running on RedHat systems which use systemd as the default init system were not being properly queried for `enable` status by the systemd provider. The provider has been updated to use a backwards-compatible `systemctl` command to ensure all services can be properly queried.

* [PUP-5025](https://tickets.puppetlabs.com/browse/PUP-5025): Previously, if the ensure property for a yum/dnf package contained an epoch tag, then Puppet would consider the resource to always be out of sync and would try to reinstall the package. Puppet now takes into account the epoch tag when comparing the current and desired versions.

* [PUP-2744](https://tickets.puppetlabs.com/browse/PUP-2744): Previously, SysVinit services running on RedHat systems which use systemd as the default init system were mishandled by Puppet. Instead of using the RedHat service provider and `chkconfig` to query services, Puppet fell back to the parent init provider and omitted the `enable` status. This has been fixed by ensuring the RedHat provider is always used for these services instead.