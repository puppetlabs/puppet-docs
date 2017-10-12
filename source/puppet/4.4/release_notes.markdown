---
layout: default
toc_levels: 1234
title: "Puppet 4.4 Release Notes"
---

[puppet lookup]: ./lookup_quick.html

This page lists the changes in Puppet 4.4 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.3 release notes](/puppet/4.3/release_notes.html) and [Puppet 4.2 release notes](/puppet/4.2/release_notes.html).

## Puppet 4.4.2

Released April 26, 2016.

Puppet 4.4.2 is a bug fix and security release in the Puppet 4.4 series. Users should [see the security announcement](https://puppet.com/security/cve/cve-2016-2785) for risk information.

* [Fixed in Puppet 4.4.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.4.2%27) 
* [Introduced in Puppet 4.4.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.4.2%27)

### Bug fixes

* [PUP-6133](https://tickets.puppetlabs.com/browse/PUP-6133): Using a Struct type as a hash key had undefined result (often resulting in a failed access to the value stored at that key).

* [PUP-6117](https://tickets.puppetlabs.com/browse/PUP-6117): Type aliases that included themselves recursively in a non meaningful way caused the created type to match anything. If you defined something like MyType = Variant[Integer, MyType], it would match anything. Now such constructs are correctly reduced to what they really mean.

* [PUP-6110](https://tickets.puppetlabs.com/browse/PUP-6110): The function assert_type has been improved to point out details about a type mismatch where it earlier in some cases would report nonsense like "Expected Hash, got Hash".

* [PUP-6108](https://tickets.puppetlabs.com/browse/PUP-6108): Before this, mistakes in type aliases could cause endless recursion ending with an out of stack error. This is now gracefully handled with a specific error message.

* [PUP-6090](https://tickets.puppetlabs.com/browse/PUP-6090): If an attempt was made to call a function (for example, `notice`) with the result of a call to a function that produces an Iterator (for example, reverse_each) the operation would fail. Now the iterator is transformed to an array in those cases. 

* [PUP-6089](https://tickets.puppetlabs.com/browse/PUP-6089): The notation for empty Array and Hash were earlier unspecified and the output showed internal details related to the implementation of the Puppet Type System. Empty Array is now displayed as `Array[0, 0]`, and an empty Hash as `Hash[0, 0]`. In conjunction with this change, it is now also illegal to specify an element (or key/value) type when also specifying empty. For instance, `Array[Integer, 0, 0]` is now illegal. 

* [PUP-6074](https://tickets.puppetlabs.com/browse/PUP-6074): The experimental lookup option `--unpack-arrays` had very strange behavior and it was decided that it should be removed. It is not removed from both the lookup command line application and lookup function. 

* [PUP-6064](https://tickets.puppetlabs.com/browse/PUP-6064): A regression in the functions `epp`, and `inline_epp` caused given `undef` values to be treated as missing given arguments. This was a known issue in Puppet 4.4.1, and has now been resolved.

* [PUP-6145](https://tickets.puppetlabs.com/browse/PUP-6145): If self recursive type aliases were compared against each other using `<`, `>`, or `=`, there were cases when this would result in an `Out of Stack` error.

* [PUP-6146](https://tickets.puppetlabs.com/browse/PUP-6146): When comparing Hash vs Struct types, the result could be undef instead of false.

* [PUP-6179](https://tickets.puppetlabs.com/browse/PUP-6179): The Puppet CA face was broken with the release of Puppet 4. You could get help, but all command invocation would fail. It now works.

* [PUP-6149](https://tickets.puppetlabs.com/browse/PUP-6149): The abstract Collection type when created with only a size constraint (Collection[5,5]) would use the resulting integer range as the element type instead of a size constraint, and the constructed type would be unbound in size.

* [PUP-6147](https://tickets.puppetlabs.com/browse/PUP-6147): Comparison of Hash vs. Struct type did not work as expected as the type of the key was ignored. 

* [PUP-6148](https://tickets.puppetlabs.com/browse/PUP-6148): Comparing Callable types could result in an error being raised. 

* [PUP-6049](https://tickets.puppetlabs.com/browse/PUP-6049): Corrected help text for Puppet Lookup's `--knock-out-prefix` option.


## Puppet 4.4.1

Released March 24, 2016.

Puppet 4.4.1 is primarily a bug fix release.

* Fixed in [Puppet 4.4.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.4.1%27)
* Introduced in [Puppet 4.4.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.4.1%27)

### Enhancements

* [PUP-5877](https://tickets.puppetlabs.com/browse/PUP-6050): Hiera data files that provide values at the environment and module levels can now provide values from variables with a `.` in their names, provided that name is properly quoted. For example, this value from `production/data/common.yaml` is now legal: 

  ~~~
  env_production_hardware_platform: "%{'hardware.platform'}"
  ~~~

### Known issues

* [PUP-6064](https://tickets.puppetlabs.com/browse/PUP-6064): A regression in `epp`, and `inline_epp` functions cause given `undef` values to be treated as missing given arguments.


### Bug fixes

* [PUP-6070](https://tickets.puppetlabs.com/browse/PUP-6070): When running on JRuby, a numerical overflow problem could occur when types were compared. The problem manifested itself as an error with the message `bignum too big to convert into long` and typically occurred when type checking moderately to very complex data. This is a problem specific to JRuby. The fix to this problem was to change how internal hash calculations are performed to ensure that they never grow beyond 64 bits.

* [PUP-6067](https://tickets.puppetlabs.com/browse/PUP-6070): Package provider features were not inherited from the `:parent` provider. This adds features provided by Pip as also provided by Pip3.

* [PUP-6050](https://tickets.puppetlabs.com/browse/PUP-6050): The lookup command line tool did not handle the `--unpack-arrays` option the correct way, and did not work at all because of this. There were also other minor problems with the documentation that are now fixed. 

>**Note:** The `--unpack-arrays` option can have strange behavior even if it now "works". This experimental feature will be removed in the next maintenance release.

* [PUP-5233](https://tickets.puppetlabs.com/browse/PUP-5233): In Puppet 3, the catalog cache endpoint changed to JSON, but `puppet inspect` was not updated to take that into account. Fixed `puppet inspect` so it successfully finds the cached catalog. There are still known issues with `inspect` ([PUP-6041](https://tickets.puppetlabs.com/browse/PUP-6041)). 


## Puppet 4.4.0

Released March 16, 2016.

* [Fixed in Puppet 4.4.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.4.0%27)
* [Introduced in Puppet 4.4.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.4.0%27)

### New features

#### Iterable and Iterator Types added

* [PUP-5648](https://tickets.puppetlabs.com/browse/PUP-5648): Two new types were added to the Puppet type system; Iterable[T], a type for values that an iterative function can operate on (i.e. a sequence of type T), and Iterator[T], an abstract Iterable that represents a lazily applied iterative function (that produces a sequence of T). In practice, an Iterable that is also an Iterator describes a value that can not be assigned directly to attributes of resources; to assign the values an Iterator must first be iterated over to construct a concrete value like an Array). 

	Values of type Array, Hash, String, Integer, Iterator, and the types Type[Enum], Type[Integer] are Iterable.

* [PUP-5730](https://tickets.puppetlabs.com/browse/PUP-5730): The iterative function `an_iterable.step(n)` has been added. It yields every *nth* successor from its input iterable when chained into another function. Previously, it was difficult to iterate in steps other than one. This function makes use of the new types Iterable and Iterator, which enable efficient chaining of iterative functions.


#### Type aliases

* [PUP-5742](https://tickets.puppetlabs.com/browse/PUP-5742): It is now possible to define aliases for data types. The aliases are automatically loaded from .pp files under a module's `<root>/types/` and the filename must match the alias name. The alias is defined as in this simple example: 

	`type MyInteger = Integer`

	This is used to create reusable and descriptive types.


### Arrays from Iterator values with splat

* [PUP-5836](https://tickets.puppetlabs.com/browse/PUP-5836): It is possible to produce an Array from Iterator values by using the splat operator. As an example the expression: 

  ~~~
  *[1,2,3].reverse_each 
  # produces [3,2,1] 
  
  ~~~

#### Static catalogs

* [PUP-5694](https://tickets.puppetlabs.com/browse/PUP-5694): `static_catalogs` is a new Puppet setting for controlling if the master should compile a static catalog. It can also be overridden per-environment in `$codedir/environments/<env>/environment.conf`. By default, the property is `true`, but can be set to `false` globally or per-environment. 

  > **Note:** The master will only compile a static catalog if static_catalogs is enabled via this setting, the agent is Puppet 4.4.0 or newer, and the master has a code_id, which identifies the version of Puppet code that was used to generate the catalog.

#### Misc new features and behaviors

* [PUP-5729](https://tickets.puppetlabs.com/browse/PUP-5729): The function `reverse_each` has been added. It works similar to the `each` function but iterates over elements in reverser order. This function in contrast to stdlib's `reverse` does not create a new reversed copy, which makes it ideal for chaining into other Iterable functions. Also see the new Puppet data types Iterable and Iterator.

* [PUP-5695](https://tickets.puppetlabs.com/browse/PUP-5695): Adds the `checksum_value` parameter to the file type. If present, Puppet will use the checksum (existing parameter) and checksum_value (new parameter) to determine if a file resource is insync or not.

* [PUP-1780](https://tickets.puppetlabs.com/browse/PUP-1780): All references to non-existing variables will now generate a warning. Earlier Puppet only warned about non-existing qualified variables with more than one namespace segment. 

  It is possible to disable these warnings by adding `undefined_variables` to the setting `disabled_warnings`. 

  > **Note:** In most cases there is no file/line information available, and this was one reason why only some cases were reported earlier. We expect to correct this in the next major version as it requires API breaking changes.

* [PUP-1985](https://tickets.puppetlabs.com/browse/PUP-1985): It is now allowed to reference earlier parameters in a default expression in a class, define or Puppet language function. This used to be unspecified behavior and would only work by chance under certain circumstances.

* [PUP-1455](https://tickets.puppetlabs.com/browse/PUP-1455): Puppet now uses CFPropertyList to read launchd plists instead of shelling out to plutil, significantly increasing speed for user, group, and service management on OSX.

* [PUP-1376](https://tickets.puppetlabs.com/browse/PUP-1376): This adds a new `skip_tags` setting, as a compliment to the `tags` setting. This new setting allows skipping resources based on tags, and is applied before the `tags` setting is applied.

* [PUP-5608](https://tickets.puppetlabs.com/browse/PUP-5608): This adds initial Ruby 2.3 support. However, note that *using Puppet with 2.3.0 is not yet recommended.*

* [PUP-1072](https://tickets.puppetlabs.com/browse/PUP-1072): This adds support for 'http' and 'https' URLS as source attributes to the file resource. 

	Since the checksum metadata is not available from the URL, applying a file resource with an http/s source will always be detected as a content change. This can be avoided by specifying the `checksum` and `checksum_value` explicitly, or using `mtime` as the checksum.

* [PUP-4748](https://tickets.puppetlabs.com/browse/PUP-4748): It's now possible to purge a resource that has downstream dependents, such as notifying a service to restart. This reinstates behavior that was possible prior to [PUP-1963](https://tickets.puppetlabs.com/browse/PUP-4748).

### Deprecations

#### pluginsync

The `pluginsync` setting is deprecated. By default, Puppet will automatically do a pluginsync when requesting a new catalog, and will not pluginsync when applying a cached catalog.

The value of `pluginsync` will be coerced to be compatible with value of `use_cached_catalog`. 

If `pluginsync` is explicitly set via command-line or `puppet.conf`, then that setting will be honored even when it may result in an inconsistent state between the catalog and the plugins that support it. 

* [PUP-5708](https://tickets.puppetlabs.com/browse/PUP-5708)
* [PUP-5703](https://tickets.puppetlabs.com/browse/PUP-5703)

#### `static_compiler`

* [PUP-5978](https://tickets.puppetlabs.com/browse/PUP-5978): `static_compiler` is now deprecated.


### Enhancements

* [PUP-3149](https://tickets.puppetlabs.com/browse/PUP-3149): Previously, when uninstalling packages on platforms which include the Zypper package manager, Puppet would always fall back to using RPM to try and do the uninstallation. As RPM is incapable of dependency management, uninstallation would fail if the package had any dependencies. This change adds an `uninstall` method to the Zypper provider for versions of Zypper 1.0 and above to properly manage dependencies and remove packages using Zypper itself.

* [PUP-5487](https://tickets.puppetlabs.com/browse/PUP-5487): The output of warnings about expressions that require storeconfigs to be turned on has been irritating users for quite some time. It is valid Puppet code, and almost everyone is running with storeconfigs turned on - except when doing testing. This is now changed so that the warnings are only issued when expressions are evaluated/used.

* [PUP-5964](https://tickets.puppetlabs.com/browse/PUP-5964): The error message generated from the function asssert_type is now of the same high quality as the message produced for automatically type checked parameters.

* [PUP-5845](https://tickets.puppetlabs.com/browse/PUP-5845): The function type (x, inference_type = detailed) has been added. It produces the type of the given argument. This function removes the need to use the standard lib function type_of which does the same thing. The function can produce generalized, reduced or detailed type information. This is useful when producing custom error messages when a type check fails.

* [PUP-5902](https://tickets.puppetlabs.com/browse/PUP-5902): Type mismatches where the type is a type alias are now expanded to make it easier to determine what is wrong.

* [PUP-5901](https://tickets.puppetlabs.com/browse/PUP-5901): Type mismatches where the type is an Enum or multiple Enums are now merged to make it easier to determine what is wrong.

* [PUP-5735](https://tickets.puppetlabs.com/browse/PUP-5735): In an effort to improve Puppet's handling of Unicode user and group names on Windows, much of the code interacting with the Windows API has been rewritten to ensure wide character (UTF-16LE) API variants are called. Previously, Puppet relied on the win32-security gem for some of these interactions, which were implemented as ANSI Windows API calls. As a result, Puppet no longer needs the win32-security gem, and any code based references to the gem have been removed. Any module authors requiring functionality in Win32::Security should be aware that a subsequent release will remove this gem from the MSI package permanently. Though unused by Puppet, the gem currently remains for backward compatibility.

### Bug Fixes

* [PUP-5861](https://tickets.puppetlabs.com/browse/PUP-5861): Previously, a hash without type parameters presented itself in expanded form with details about the default values for key/value types and size. Now it does not.

* [PUP-6020](https://tickets.puppetlabs.com/browse/PUP-6020): A problem was found with the `==` operator when directly comparing one data type against another. The `=~` operator was unaffected. This bug could cause undefined behavior for types used as keys in hashes, and could result in output of wrong type as the expected type in a type mismatch error.

* [PUP-5577](https://tickets.puppetlabs.com/browse/PUP-5577): A Puppet installation in a `chroot` environment on a RedHat `osfamily` might lack `/run/systemd/system` (if /run is not mounted yet) and so Puppet wouldn't consider the systemd provider suitable. This restricts that check to Debian platforms to allow the use of Puppet in such environments.

* [PUP-5995](https://tickets.puppetlabs.com/browse/PUP-5995): A regression was found where UTF-8 multibyte characters in a manifest would cause problems in services extracting selected parts of the source code. Node Classifier would present truncated/misaligned source snippets for default value expressions in the UI, and Puppet String would present garbage in generated documentation, or in worst cases crash.

* [PUP-5925](https://tickets.puppetlabs.com/browse/PUP-5925): A small but annoying problem in data binding has been fixed, where if you defined a data key for a parameter to be nil (`undef`) and did not have a default expression for the parameter that also specified undef (or some other value) an error would be raised. Now, if nil/undef is bound as value in data, and there is no default expression, the value `undef` is assigned to the parameter instead of giving an error).

* [PUP-5923](https://tickets.puppetlabs.com/browse/PUP-5923): Administrative token detection for Windows 2003 and earlier, used internally to guard code paths requiring administrative privileges, was flawed and always thought the current user has administrative privileges. This could lead to Puppet attempting to execute code that the operating system will not allow it to (such as creating symlinks).

* [PUP-5728](https://tickets.puppetlabs.com/browse/PUP-5728): As part of Puppet 4, Puppet declared that UTF-8 was the only valid encoding for manifest files. However, while this behavior was correct on non-Windows systems, because Puppet did not explicitly specify the encoding when reading manifests, the behavior on Windows was incorrect. On Windows, Ruby continued to load files from disk, then convert them to whatever the current local codepage was defined as (often IBM437 or 1252). Depending on whether the Unicode characters in the manifest contained bytes that could be represented in the current codepage or not, this could lead to either a crash while attempting to treat the bytes as characters in the codepage, or more typically, corruption of the intended strings when loading internally. This corruption would result in resources being created that didn't match what was specified in the manifest. In addition to addressing the loading of manifest files, similar changes were made to the loading of resource templates, Ruby based Puppet module code (such as custom functions), `puppet apply`, `puppet lookup`, the epp and parser faces.

* [PUP-5726](https://tickets.puppetlabs.com/browse/PUP-5726): Due to a Ruby bug on Windows, reading and writing environment variables that contain Unicode characters may corrupt the local processes copy when they are accessed through Ruby's ENV class. As a result, prior to this fix, the process environment for Puppet will corrupt environment variables with any Unicode characters that can't be represented in the current local codepage when the internal helper function withenv is used. This affects Windows and PowerShell exec providers, and when arbitrary exec resources are run, can result in the creation of multiple user directories similar to the current username when a Windows user profile directory contains Unicode characters. The Ruby bug around ENV access is filed as [https://bugs.ruby-lang.org/issues/8822](https://bugs.ruby-lang.org/issues/8822) and has not yet been backported to the version of Ruby that Puppet runs on. A related issue is filed at [https://bugs.ruby-lang.org/issues/9715](https://bugs.ruby-lang.org/issues/9715)

* [PUP-5899](https://tickets.puppetlabs.com/browse/PUP-5899): Empty data files could cause lookup to fail completely. Now warnings and/or errors are raised. Note that a completely empty JSON file is invalid JSON, while an empty YAML file is valid (means "nothing"). If an "empty" JSON is needed it needs to have an empty value (`{ }`).

* [PUP-5824](https://tickets.puppetlabs.com/browse/PUP-5824): Empty interpolations in Hiera data such as `%{}`, `%%{}`, `%{::}` and similar variations did not produce the correct result of an empty string when such constructs where found in data processed by the lookup function and command line tool.

* [PUP-5291](https://tickets.puppetlabs.com/browse/PUP-5291): Fixed "stream closed" problem with SSH transport to Cisco devices closing the session with the IO handles still open.

* [PUP-5761](https://tickets.puppetlabs.com/browse/PUP-5761): Illegal use of unqualified keys in Hiera data for lookup data in a module or environment could have the affect of none of the correct keys having values.

* [PUP-5983](https://tickets.puppetlabs.com/browse/PUP-5983): Lookup of Hiera defined data in environments and modules did not to perform interpolation in nested arrays and hashes, instead the strings containing the interpolation instructions were returned as is. This has now been corrected.

* [PUP-5898](https://tickets.puppetlabs.com/browse/PUP-5898): Our old foe `:undef` turned up again due to 3.x calling convention also applying to resource expressions.

* [PUP-5617](https://tickets.puppetlabs.com/browse/PUP-5617): Previously, the agent would stall indefinitely if the network connection to the master were to break unexpectedly for some reason. This change allows the socket with the master to be closed and the agent to terminate cleanly. 

* [PUP-5513](https://tickets.puppetlabs.com/browse/PUP-5513): Previously, new lines in the `ssh_known_hosts` file would cause Puppet to throw errors, as a regex in the type was not properly parsing blank lines. This fix updates the regexes to ensure blank lines do not cause issues.

* [PUP-5289](https://tickets.puppetlabs.com/browse/PUP-5289): Previously, Puppet could only configure network devices in `access` mode, not the default `dynamic desirable`. Also adds support for `dynamic desirable` mode, `negotiate` encapsulation type, and specifying the static access vlan interface.

* [PUP-5734](https://tickets.puppetlabs.com/browse/PUP-5734): Prior to this ticket, when the dependencies field of the metadata for a module was not an array, the user would receive an uninformative error message. Tbe error message for this error case has since been improved.

* [PUP-3077](https://tickets.puppetlabs.com/browse/PUP-3077): `puppet agent` and `puppet apply` will no longer cache its catalog during a noop run. This ensures the next non-noop run won't fall back to using the cached catalog and deploy code that was never meant to be "live". Also, if the agent falls back to using its cached catalog and the catalog was compiled for a different environment than the agent is currently in, then the agent will fail the run. This way, the server remains authoritative about which environment the agent is supposed to be in.

* [PUP-5813](https://tickets.puppetlabs.com/browse/PUP-5813): Puppet now requires less memory under heavy and continuous load, as two hard to detect memory leaks have been found and fixed.

* [PUP-5819](https://tickets.puppetlabs.com/browse/PUP-5819): Puppet will now raise an error if a Puppet language source file starts with a BOM (Byte Order Mark). The error identifies the name of the BOM, and shows the bytes in hex that should be removed. Earlier, such marks caused a `SyntaxError` to be issued and it was hard to understand the cause. Puppet always uses UTF-8, and forbids BOMs to be present in source files.

* [PUP-5682](https://tickets.puppetlabs.com/browse/PUP-5682): Puppet's yumrepo type now recognizes the bare word `false` and the quoted string `"false"` as valid values for its boolean properties, such as gpgcheck. Previously, it only recognized `"False"` which could lead to surprising results.

* [PUP-5452](https://tickets.puppetlabs.com/browse/PUP-5452): Spaces preceding the `=` operator in a crontab file no longer produce an error trying to manage them with the crontab provider.

* [PUP-5341](https://tickets.puppetlabs.com/browse/PUP-5341): Starting from Puppet 4.0, the YAML report output did not match the documentation for our report format. Now it matches.

* [PUP-5835](https://tickets.puppetlabs.com/browse/PUP-5835): The `$enviroment` variable in 4.3.2 ended up as a Ruby symbol instead of being a String. A workaround is to interpolate it: `"$environment"`.

* [PUP-4997](https://tickets.puppetlabs.com/browse/PUP-4997): The correct version of `pip` might not be found on newer EL6 versions because the previous logic assumed that it was always `pip-python` on EL6. This fix changes the logic to check for both `pip` and `pip-python` (in that order) and use the first one it finds.

* [PUP-5646](https://tickets.puppetlabs.com/browse/PUP-5646): The `fqdn_rand` function when used to produce a series of random values for a node in a given range did not produce an even (random) spread over the range. This has now been improved by lengthening the salt that is used to produce the series. 

  As a consequence, those resources (such as cron entries and resources with titles generated containing a random number) may be reported as having changed the first time the version containing this fix is in use. 

* [PUP-5897](https://tickets.puppetlabs.com/browse/PUP-5897): This fix specifies systemd as the default service provider for Ubuntu 16.04. (But note that this release of `puppet-agent` does not yet include packages for 16.04.)

* [PUP-5555](https://tickets.puppetlabs.com/browse/PUP-5555): This fixes a scenario where the yum provider fails if the output of `yum check-update` includes an "Update" notice, as seen with "broken update" notices.

* [PUP-5963](https://tickets.puppetlabs.com/browse/PUP-5963): Tidying recursive directories was broken in 4.3.0 due to [PUP-1963](https://tickets.puppetlabs.com/browse/PUP-1963), this ticket restores the previous behavior.

* [PUP-5015](https://tickets.puppetlabs.com/browse/PUP-5015): User attributes will no longer be down-cased on AIX.

* [PUP-5895](https://tickets.puppetlabs.com/browse/PUP-5895): `puppet parser validate` failed when validating manifests containing functions written in the Puppet language when they were in regular manifests. The functions in autoloaded locations are not validated by `puppet parser validate`.

* [PUP-5970](https://tickets.puppetlabs.com/browse/PUP-5970): Adds a `catalog_format` version field to the catalog identifying its schema. Newly compiled catalogs will have version 1. In the future, the version will be bumped if changes are made to the catalog format. This makes it possible to read a catalog and know what data to expect.

* [PUP-5428](https://tickets.puppetlabs.com/browse/PUP-5428): `POST` messages in the Puppet v3 API will now include the environment as a query parameter, providing uniformity between `GET` and `POST` URLs. Puppet will use `POST` instead of `GET` for large requests, so this ensures load balancers can make decisions based on the environment.

* [PUP-5981](https://tickets.puppetlabs.com/browse/PUP-5981): Puppet will default to the DNF package provider on Fedora 23, which is a new supported platform in Puppet 4.4.0/puppet-agent 1.4.0.
