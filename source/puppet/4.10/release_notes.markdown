---
layout: default
toc_levels: 1234
title: "Puppet 4.10 Release Notes"
---

This page lists the changes in Puppet 4.10 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backwards-incompatible changes
-   Y can increase for backwards-compatible new functionality
-   Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), because they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.9 release notes](/puppet/4.9/release_notes.html) and [Puppet 4.8 release notes](/puppet/4.8/release_notes.html).

## Puppet 4.10.12

Released June 7, 2018.

This is a bug-fix and security release of Puppet.

-   [All issues resolved in Puppet 4.10.12](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.10.12%27)

### Bug fixes

-   When running Puppet on Ruby 2.0 or newer, Puppet would close and reopen HTTP connections that were idle for more than 2 seconds, causing increased load on Puppet masters. Puppet 4.10.12 ensures that the agent always uses the `http_keepalive_timeout` setting when determining when to close idle connections. ([PUP-8663](https://tickets.puppetlabs.com/browse/PUP-8663))

### Security fixes

-   On Windows, Puppet no longer includes `/opt/puppetlabs/puppet/modules` in its default basemodulepath, because unprivileged users could create a `C:\opt` directory and escalate privileges. ([PUP-8707](https://tickets.puppetlabs.com/browse/PUP-8707))

## Puppet 4.10.11

Released April 17, 2018.

This is a bug-fix and feature release of Puppet.

-   [All issues resolved in Puppet 4.10.11](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.10.11%27)

### Bug fixes

-   Previous versions of Puppet would fail to clean a certificate signing request when running `puppet cert clean` because it would try to revoke the certificate. In Puppet 4.10.11, `puppet cert clean` correctly cleans certificate signing requests. ([PUP-1916](https://tickets.puppetlabs.com/browse/PUP-1916))

-   Fedora 26-30 now use `dnf` as the default packaging system. ([PUP-7326](https://tickets.puppetlabs.com/browse/PUP-7326))

-   Previous versions of Puppet produced warnings or errors when managing Windows local groups that contained unresolvable SIDs from previously valid domain members that had since been deleted. Puppet 4.10.11 safely handles these unresolvable SIDs inside of groups. ([PUP-7349](https://tickets.puppetlabs.com/browse/PUP-7349))

-   If `noop` is set to true directly on a `tidy` resource, Puppet 4.10.11 will not purge its children. ([PUP-8231](https://tickets.puppetlabs.com/browse/PUP-8231))

-   While previous versions of Puppet could create new Windows groups containing virtual accounts, it couldn't manage groups that contained at least one virtual account. Puppet might also have been unable to correctly manage groups with account names that appeared in both the local computer and a domain, due to a failure to properly disambiguate the accounts. Puppet 4.10.11 resolves both problems. ([PUP-8258](https://tickets.puppetlabs.com/browse/PUP-8258))

-   Puppet 4.10.11 lets you use cached catalogs in `puppet apply` and `puppet agent` runs with the `--noop` flag. The cached catalog isn't updated if one already exists, and isn't created if there's no previously cached catalog. ([PUP-8337](https://tickets.puppetlabs.com/browse/PUP-8337))

-   With the Windows Data Deduplication feature turned on, the Puppet `file` and `package` resources might have presented errors in previous versions of Puppet. Puppet 4.10.11 resolves this issue by no longer treating deduplication reparse points as symbolic links. ([PUP-8411](https://tickets.puppetlabs.com/browse/PUP-8411))

-   When using `puppet types generate` for environment isolation, and a resource type had customized title patterns, previous versions of Puppet would not use those. Puppet 4.10.11 resolves this issue. ([PUP-8448](https://tickets.puppetlabs.com/browse/PUP-8448))

-   In Puppet 4.10.11, the `puppet cert clean` command can clean certificates even if none of the certificates in the provided list have already been signed. ([PUP-8467](https://tickets.puppetlabs.com/browse/PUP-8467))

-   Puppet 4.10.11 should no longer log warnings resulting from inadvisable coding practices, such as using ambiguous arguments, to the process's `stderr`. This resolves an issue in previous versions of Puppet where log managers could cause a broken pipe. ([PUP-8502](https://tickets.puppetlabs.com/browse/PUP-8502))

### New features

-   SystemD is now set as the default provider for Ubuntu 17.04 and 17.10. ([PUP-8538](https://tickets.puppetlabs.com/browse/PUP-8538))

-   The `puppet lookup` command-line tool called the external node classifier (node terminus) even if the `--compile` flag was not enabled. This could cause errors, because Puppet would load classes indicated by the ENC without a complete and proper setup, or if loaded code was had parse errors. In Puppet 4.10.11, the configured ENC is used only if the `--compile` flag is enabled. ([PUP-7046](https://tickets.puppetlabs.com/browse/PUP-7046))

-   On AIX, Puppet 4.10.11 correctly manages users on the latest AIX service packs. ([PUP-8495](https://tickets.puppetlabs.com/browse/PUP-8495))

## Puppet 4.10.10

Released February 5, 2018.

This is a bug-fix and feature release of Puppet.

-   [All issues resolved in Puppet 4.10.10](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.10.10%27)

### Bug fixes

-   The deprecated WEBrick Puppet master did not work in previous versions of Puppet when running Ruby 2.3.6, or 2.4.3 and later. Puppet 4.10.10 resolves this issue, but WEBrick users should move to Puppet Server.

-   In Puppet 4.10.9, non-existent Solaris SMF services reported a state of `:absent` instead of `:stopped`, which could break some workflows. Puppet 4.10.10 reverts this behavior and reports non-existent Solaris SMF services as `:stopped`.

-   The `audit` resource metaparameter is no longer deprecated, and we've removed warning messages suggesting that it has been deprecated.

-   Exceptions in prefetch were not marked as failed in the report under previous versions of Puppet, leading to reports incorrectly suggesting that an agent run with errors was fully successful. Puppet 4.10.10 marks only transactions that finish processing as successful.

-   The validation of `uris` in a Hiera 5 `hiera.yaml` file by previous versions of Puppet did not allow reference or partial URIs, such as those containing only a path, despite the documentation stating that Hiera doesn't ensure that URIs are resolvable. Puppet 4.10.10 relaxes the implemented URI checking to remove these constraints.

-   The `break()` function did not break the iteration over a hash, and instead would break the container in which a lambda called `break()`. This resulted in an error about a break from an illegal context if the container was something other than a function, and would lead to early exit when invoked from a function. Puppet 4.10.10 resolves this by having the function behave like a break in an array iteration.

-   Previous versions of Puppet required that `--user=root` be passed to `puppet device` when creating certificates, even if the command was being executed by root. Puppet 4.10.10 no longer requires the flag.

-   When providing facts with the `--facts` command line option of the `puppet lookup` command in previous versions of Puppet, those facts would not appear in the `$facts` variable. Puppet 4.10.10 resolves this issue.

### New features

-   Systemd is the default service provider in Amazon Linux 2.

-   Puppet 4.10.10 adds the `sourceaddress` setting, which specifies the interface that the agent should use for outbound HTTP requests. This setting might be necessary for agents on systems with multiple network interfaces.

-   Puppet 4.10.10 adds the `runtimeout` setting, which can cancel agent runs after the specified period. The setting defaults to 0, which preserves the behavior in previous version of Puppet of allowing an unlimited amount of time for agent runs to complete.

-   A type alias to an iterable type did not allow the alias to be iterated in previous versions of Puppet. Puppet 4.10.10 resolves this issue.

-   Previous versions of Puppet did not support using named format arguments for `sprintf`. Puppet 4.10.10 lets you use a hash with string values as the `sprintf` format argument.

    For example, `notice sprintf("%<x>s : %<y>d", { 'x' => 'value is', 'y' => 42 })` would produce a notice of `value is : 42`.

### Improvements

-   Puppet 4.10.10 can retrieve file sources from web servers when the associated MIME type is not "binary". This particularly affects IIS webservers.

-   Certain Puppet subcommands, such as `puppet help` and `puppet config`, no longer require a local environment to exist in Puppet 4.10.10. They now can fall back to assuming the defined environment exists on the master filesystem after checking for the local environment.

-   If `environment.conf` contains unknown settings, Puppet 4.10.10 warns only once per unknown setting.

-   Error messages from `Puppet::Face` objects now include the face's name and version number.

-   To specify an environment when running Puppet from the command line, Puppet 4.10.10 lets you use the short flag `-E` in addition to the long flag `--environment`.

## Puppet 4.10.9

Released November 6, 2017.

This is a bug-fix release in the Puppet 4.10 series.

-   [All issues fixed in Puppet 4.10.9](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.9%27)

### Bug fixes

This release resolves issues with tag propagation, internationalization features and Unicode support, filebuckets, Windows reparse point path resolution, and ZFS volume creation.

-   Previous versions of Puppet failed to propagate tags with included classes, which could break class notifications when running Puppet with tags enabled. Puppet 4.10.9 resolves this issue; refresh events are now correctly propagated to all tagged resources when running with tags, and some confusing debug and warning messages have been eliminated.

-   Previous versions of Puppet that failed to initialize its internationalization functionality, typically due to a missing `gettext` gem, would log a warning each time each module on the system was loaded. This overwhelmed logs with redundant error messages. Puppet 4.10.9 resolves this issue by logging that warning only once.

-   Previous versions of Puppet could fail to install modules from the Puppet Forge that had many available versions. Puppet 4.10.9 resolves this issue by improving URL encoding in paginated Forge results.

-   The `service` provider could fail with a stacktrace in previous versions of Puppet if the process line for any given service contained UTF-8 characters and Puppet was not running in UTF-8. Puppet 4.10.9 avoids this error by more gracefully handling these characters in order to match running services to the managed service name.

-   In previous versions of Puppet, backing up the same file content to a filebucket more than once could result in a mistaken error warning suggesting that the files had the same checksum value but different contents, which indicated a potential (but false) hash collision. Puppet 4.10.9 correctly handles duplicate files in a filebucket.

-   Previous versions of Puppet did not correctly resolve the path to Windows reparse points that are mount points, rather than symbolic links. This could prevent access to paths on DFS shares.

-   The `service` provider could fail with a stacktrace in previous versions of Puppet if the process line for any given service contained UTF-8 characters and Puppet was not running in UTF-8. Puppet 4.10.9 avoids this error by more gracefully handling these characters in order to match running services to the managed service name.

-   To set the `volsize` property when creating a ZFS volume, Puppet 4.10.9 correctly uses the `-V` flag for the `zfs create` command, instead of the `-o` flag used in previous versions.

-   Puppet 4.10.9 can parse Nagios files containing Unicode content more consistently than previous versions of Puppet.

## Puppet 4.10.8

Released September 14, 2017.

This is a small bug-fix release in the Puppet 4.10 series.

* [All issues fixed in Puppet 4.10.8](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.8%27)

### Bug fixes

If illegal variables (with many or long name segments) had a segment with an initial uppercase letter in previous versions of Puppet 4, the parser could take an extremely long time to match the input. This caused very long compilation times and excessive CPU load. Puppet 4.10.8 resolves this issue by changing the relevant regular expression to avoid excessive backtracking to match the regular expression for variables.

* [PUP-7848](https://tickets.puppetlabs.com/browse/PUP-7848)

## Puppet 4.10.7

Released September 6, 2017.

This is a small bug-fix release in the Puppet 4.10 series.

* [All issues fixed in Puppet 4.10.7](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.7%27)

### Bug fixes

Previous versions of Puppet 4.10 on Windows could crash if a corrupt environment variable was set. Puppet 4.10.7 resolves this issue.

* [PUP-7821](https://tickets.puppetlabs.com/browse/PUP-7821)

## Puppet 4.10.6

Released August 9, 2017.

This is a small bug fix release in the Puppet 4.10 series.

* [All issues fixed in Puppet 4.10.6](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.10.6%27)

### Bug fixes

A regression introduced with Hiera 5 caused the setting of `data_binding_terminus=none` to turn off the `hiera_xxx` functions in addition to the expected disablement of Automatic Parameter Lookup (APL) from the global layer. This has been changed so that the `hiera_xxx` calls will continue to work. The `lookup` function will continue to return the same result as APL (if the terminus is disabled, then global Hiera is also turned off for lookup, while APL and lookup from environment and module layers is still enabled). The `data_binding_terminus` setting will eventually be deprecated and removed along with the Hiera 3 support. With the speedups and new features in Hiera 5, there should be no reason to turn off the `data_binding_terminus`.

## Puppet 4.10.5

Released July 26, 2017.

This is a bug fix release for Puppet that includes new capabilities for string localization. It shipped with Puppet agent 1.10.5.

* [All issues fixed in Puppet 4.10.5](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%204.10.5%27)


### Module localization

Puppet now supports module localization! You may have noticed some modules now have translated READMEs and metadata.json fields. The next step is translating certain log messages. This release modifies Puppet so it is capable of consuming and displaying these log translations as they become available across modules.

### Bug fixes

These issues have been resolved in Puppet 4.10.5:

* A problem was found with the environment isolation solution `generate types` where a collection of a type would cause it to be loaded as a Ruby implementation instead of the generated metadata. This in turn could cause isolation problems if different environments had different versions of this type. This is now fixed so collectors also load the generated metadata form if present.

* Puppet 4.10.2 and 5.0.0 introduced a regression if a provider called `execpipe` and the external command failed. It now correctly processes the execution failure.

* A regression in Puppet 4.7.0 made the command `epp render` fail loading 4.x functions when evaluating a template. The same template would work fine when used in a manifest.

* On CentOS 7, Puppet could not create a user and set the owner of a file to that user in the same run. This was a regression introduced in 4.10.2 and 5.0.0.

* The Hiera option `sort_merged_arrays` which is used to get sorted arrays when merging was previously silently ignored (meaning no sorting took place).


## Puppet 4.10.4

Released June 19, 2017.

This is a single issue release to resolve a regression introduced in Puppet 4.10.3. Resources created using the syntax `Resource[xx::yy]` would cause an error because Puppet would not find an existing `xx::yy` user defined resource type. This was caused by fixing another problem with inconsistent use of upper and lowercase in references. ([PUP-7671](https://tickets.puppetlabs.com/browse/PUP-7671))

* [Fixed in Puppet 4.10.4](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.4%27)
* [Introduced in Puppet 4.10.4](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.4%27)

## Puppet 4.10.3

Released June 15, 2017.

This is a minor bug fix release. Using ampersands (&) in custom facts was causing Puppet runs to fail in Puppet 4.10.2. This release resolves that issue. ([PUP-7658](https://tickets.puppetlabs.com/browse/PUP-7658))

* [Fixed in Puppet 4.10.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.3%27)
* [Introduced in Puppet 4.10.3](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.3%27)


## Puppet 4.10.2

Released June 13, 2017.

* [Fixed in Puppet 4.10.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.2%27)
* [Introduced in Puppet 4.10.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.2%27)

This is a bug fix release included in Puppet agent 1.10.2, that also includes two new deprecations for Puppet.

>Note: There is a known issue with this release when using ampersands in custom facts. You can revert back to 4.10.1, or upgrade to 4.10.4.

### Deprecations

#### Automatic string to numeric conversions deprecated

Puppet's automatic string to numeric coercion now outputs a warning if `--strict` is set to `warning` or `error` whenever an automatic conversion is triggered directly by logic in a manifest, such as conversions performed by functions, or the runtime in general does not generate warnings. If you get a warning for something like `$numstr + 0` change your logic to any numeric, an integer, or a float (`Numeric($numstr), Integer($numstr), Float($numstr)`) depending on the expectations of the produced value. ([PUP-1795](https://tickets.puppetlabs.com/browse/PUP-1795))

#### Virtual classes trigger warnings or errors

Attempts to use `@class` or `@@class` to create virtual or exported classes were previously silently ignored. The attempted use now triggers either a warning or an error depending on the level you have set for `--strict`. ([PUP-1606](https://tickets.puppetlabs.com/browse/PUP-1606))

### Bug fixes

These issues have been resolved in Puppet 4.10.2:

* [PUP-7436](https://tickets.puppetlabs.com/browse/PUP-7436): A default value expression for an EPP parameter of `undef` previously would not take effect, and the parameter was instead resolved against an outer scope.

* [PUP-7383](https://tickets.puppetlabs.com/browse/PUP-7383): All Puppet commands would fail when running Puppet as a gem or from source with system Ruby 2.4+ and OpenSSL 1.1.0+.

* [PUP-7523](https://tickets.puppetlabs.com/browse/PUP-7523): In Puppet 4.10.1 a change was made that may prevent the Puppet gem (or Puppet run from source) from being able to load and run on Ruby 1.9.3 due to a bug in Bundler. This issue did not impact Puppet installed from packages.

* [PUP-7485](https://tickets.puppetlabs.com/browse/PUP-7485): It was not possible to call a function defined in the main manifest from logic in a module. This now works for special occasions when it is actually needed, but the best practice is to autoload functions.

* [PUP-7465](https://tickets.puppetlabs.com/browse/PUP-7465): When using `puppet generate types` for environment isolation, a type with a multipart namevar title would previously lead to an error of "Error: undefined method `call' for :top_level:Symbol".

* [PUP-6656](https://tickets.puppetlabs.com/browse/PUP-6656): Puppet's yum package provider did not work for some versions of yum when both `enablerepo` and `disablerepo` options were specified, for example, to enable specific repos, and disable all others.

* [PUP-6698](https://tickets.puppetlabs.com/browse/PUP-6698): The `create_resources` function did not understand that a leading `@@` in the resource name should be interpreted as "exported".

* [PUP-3597](https://tickets.puppetlabs.com/browse/PUP-3597): Documentation for Ruby method `Scope#lookupvar` was updated to show that the symbol `:undefined_variable` is thrown if `strict_variables` is in effect and a variable is not found.

* [PUP-7612](https://tickets.puppetlabs.com/browse/PUP-7612): It is now possible to dig into hashes with integer keys when using dot notation. For example, looking up "port.80.detail" in this hash: `{ port => { 80 => { detail => 'wanted value'}}}` failed earlier because an Integer key only worked when digging into Array values.

* [PUP-7464](https://tickets.puppetlabs.com/browse/PUP-7464): A regression caused resource parameter values containing Array or Hash values with embedded `undef` values to report a warning "... will be converted to string" and the parameter value would end up being a String in the serialization of a catalog. This has changed so that `undef` values are serialized as a JSON compliant `nil` value.

* [PUP-7475](https://tickets.puppetlabs.com/browse/PUP-7475): A literal regex for matching a backslash would previously cause a lexer error.

#### Hiera

* [PUP-7492](https://tickets.puppetlabs.com/browse/PUP-7492): In Hiera data, if you were aliasing a key and the value for that key contained escaped interpolations, those escaped interpolations would be taken as interpolations instead of keeping the aliased value intact.

* [PUP-7594](https://tickets.puppetlabs.com/browse/PUP-7594): In Puppet 4.9 and greater, a regression converted integer or float keys in Hiera data to strings. The intended behavior was to filter out Ruby Symbol keys. Integer and Float keys in hashes now work as they should.

* [PUP-7543](https://tickets.puppetlabs.com/browse/PUP-7543): When using eyaml and Hiera 5 and having multiple entries with different sets of options for eyaml, those options could previously override each other in an unpredictable way.

* [PUP-7554](https://tickets.puppetlabs.com/browse/PUP-7554): With the introduction of Hiera 5 there were errors if a module or environment root contained a hiera.yaml in the Hiera 3 format. These files were never used earlier, but now they are part of the Hiera 5 configuration. The issue is fixed by ignoring the files if they are version 3 and by logging a warning when encountered. Best practice is to migrate to Hiera 5, and otherwise to move those files out of the way.

#### Windows

* [PUP-7627](https://tickets.puppetlabs.com/browse/PUP-7627): Puppet's interface with the `CreateSymbolicLinkW` Windows API function previously defined an incorrect return type which could cause unexpected results in the case of an error.

#### UTF-8

* [PUP-1890](https://tickets.puppetlabs.com/browse/PUP-1890): In some scenarios Puppet could fail to manage file resources with UTF-8 file names because of incorrect character encoding and escaping when transforming requests into URI-compatible text.

* [PUP-7498](https://tickets.puppetlabs.com/browse/PUP-7498): Prior to Puppet 4.10.2, if a user with non-ascii characters existed on the system in a non-UTF-8 encoding, and Puppet managed the same user in a UTF-8 encoding, `puppet resource user` would ignore one of the users and not present it as being on the system. Now `puppet resource user` correctly lists both users, separately, as existing on the system.


## Puppet 4.10.1

Released May 11, 2017.

* [Fixed in Puppet 4.10.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.1%27)
* [Introduced in Puppet 4.10.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.1%27)

This is a critical security release that also includes several bug fixes. An authenticated agent could make a catalog request with facts encoded in YAML. The Puppet master did not properly validate and reject the request, resulting in the server loading arbitrary objects, which could lead to remote code execution. ([PUP-7483](https://tickets.puppetlabs.com/browse/PUP-7483))

### Bug fixes

These bug fixes have been resolved in this release.

* [PUP-7418](https://tickets.puppetlabs.com/browse/PUP-7418): The combination of a deep merge lookup and the use of an interpolation function in Hiera data (`alias`, `lookup`, or `hiera`) could cause the deep merge to end without having performed a full search and silently produce a result where some values would be missing.

* [PUP-7420](https://tickets.puppetlabs.com/browse/PUP-7420): Logging of Hiera lookups in debug mode would log every Automatic Parameter Lookup (APL) twice, once as a "regular lookup" and once as an APL.

* [PUP-7429](https://tickets.puppetlabs.com/browse/PUP-7429): Fixed the default string format (the `%s` format) so that a formatted regular expression results in a string that isn't delimited with slashes.
  The reason for the change is that those slashes are language specific, and should be produced using the `%p` format (which they already are). The `%s` format should produce a language agnostic representation that is suitable to pass to the `Regexp` constructor.

* [PUP-7390](https://tickets.puppetlabs.com/browse/PUP-7390): Puppet on all platforms now prefers the minitar gem. By default, the gem is only shipped on Windows, so there shouldn't be any functional change, but it enables us to move all platforms to using minitar in the future.

## Puppet 4.10.0

Released April 5, 2017.

* [Fixed in Puppet 4.10.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.10.0%27)
* [Introduced in Puppet 4.10.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.10.0%27)


### New Features

* The 4.x function API for Ruby has been extended to accept the definition of `argument_mismatch` dispatchers. These can now be used to provide better custom error messages when a type mismatch occurs in a function call. ([PUP-7368](https://tickets.puppetlabs.com/browse/PUP-7368))

* Puppet now integrates eyaml by adding `explain` support to existing `hiera.yaml` version 3 use of the `eyaml` backend, and allows eyaml to be used in `hiera.yaml` version 5 format with an entry on the form `lookup_key: eyaml_lookup_key`. This provided that the eyaml gem is installed separately, as it is not bundled with Puppet. ([PUP-7100](https://tickets.puppetlabs.com/browse/PUP-7100))

* It is now possible to expand a fact being a collection (array or hash) of values in a `hiera.yaml` to produce an array of paths for a given hierarchical level by using `mapped_paths`. This was not possible in earlier versions of Hiera. ([PUP-7204](https://tickets.puppetlabs.com/browse/PUP-7204))

* Added support for `Sensitive` commands in the Exec resource type:
command parameters that are specified as `Sensitive.new(...)` are now
properly redacted when the command fails. This supports using data from Puppet lookup and Hiera. ([PUP-6494](https://tickets.puppetlabs.com/browse/PUP-6494))

* It is now possible to set `options` under `defaults` in a `hiera.yaml` version 5 configuration. Those options apply to all entries in the `hiera.yaml` configuration that does not have an `options` entry. This reduces the amount of copies of the same set of options when a configuration in majority consists of the same type of data provider with the same options. Earlier, an attempt to set `options` under `defaults` would result in an error. ([PUP-7281](https://tickets.puppetlabs.com/browse/PUP-7281))

* Hiera 5 now supports a `default_hierarchy` in modules' `hiera.yaml`. It works exactly like the normal hierarchy, but the values it binds to keys are used only if the regular `hierarchy` (across all layers) does not result in a value. Merge options for keys in the default hierarchy can be specified only in the default hierarchy's data. ([PUP-7334](https://tickets.puppetlabs.com/browse/PUP-7334))

### Enhancements

* Hiera 5 now accepts a `mapped_path` key that expands an array or hash of values to an array of paths for a given hierarchical level. See Hiera 5 [configuration docs](https://docs.puppet.com/puppet/latest/hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends) for more information. ([PUP-7204](https://tickets.puppetlabs.com/browse/PUP-7204))

* In Hiera 5, you can now set `options` under the `defaults` key in `hiera.yaml` configuration. Options apply to all entries in the `hiera.yaml` configuration that do not have their own `options` entry. This means you no longer have to copy the same options in a configuration where the options are largely consistent. Prior to Puppet 4.10, an attempt to set `options` under `defaults` caused an error. ([PUP-7281](https://tickets.puppetlabs.com/browse/PUP-7281))

* Error messages from Hiera 5 have been improved to better explain issues and to enable locating the source of the problem. ([PUP-7182](https://tickets.puppetlabs.com/browse/PUP-7182))

* A small performance optimization was made in the time it takes to initialize the compiler. While there is a noticeable speedup in initializing the compiler itself - the user observable actions of `puppet apply` have so many other things going on that this is dwarfed and is therefore almost unnoticeable (in the 1-2% range), it does make a difference in benchmarks (finding the real code to optimize), and has a positive effect on running tests involving the compiler. ([PUP-7313](https://tickets.puppetlabs.com/browse/PUP-7313))

### Bug Fixes

* [PUP-7336](https://tickets.puppetlabs.com/browse/PUP-7336): This was a regression in 4.9.4 from 4.9.3 that in some very rare cases could cause a version 5 `hiera.yaml` file to ignore certain hierarchy levels. This only happened for hierarchy levels that interpolated a top-scope variable whose value was set after the _first_ Hiera lookup. Even then, it only occurred if the variable was an array or hash, the hierarchy level accessed one of its members with key.subkey notation, _and_ the variable was referenced with the top-scope namespace (`::attributes.role`).

  This problem is now fixed. However, do not make your hierarchy self-configuring like this. You should only interpolate the `$facts`, `$trusted`, and `$server_facts` variables in your hierarchy.

* [PUP-7359](https://tickets.puppetlabs.com/browse/PUP-7359): The Hiera 5 `eyaml_lookup_key` function did not evaluate interpolation expressions that were embedded in encrypted data. Now it does.

* [PUP-7330](https://tickets.puppetlabs.com/browse/PUP-7330): The data types `Puppet::LookupKey` and `Puppet::LookupValue` used to describe the values allowed as keys and values in Hiera 5 were not reachable from the Puppet language. This is now fixed.

* [PUP-7273](https://tickets.puppetlabs.com/browse/PUP-7273): Hiera 5 threw a correct but confusing error message if `hiera.yaml` contained a `data_hash` function where no options resulting in a path were defined. The error message has been made more informative and now points out the actual problem.

* [PUP-7391](https://tickets.puppetlabs.com/browse/PUP-7391): An error, "Attempt to redefine entity" could occur in some cases when a type alias was resolved. This occurred if a module's `init.pp` would also reference and resolve the same type and if that `init.pp` needed to be loaded to resolve the type in the first place. This problem is now fixed.

* [PUP-7372](https://tickets.puppetlabs.com/browse/PUP-7372): When a data file was reached using a version 3 `hiera.yaml` and that in turn contained interpolation expressions that used the `hiera` or `lookup` function it could result in an error if there was a `hiera.yaml` in the environment or in the related modules. Interpolation from a version 3 data file now works as it should.

* [PUP-7371](https://tickets.puppetlabs.com/browse/PUP-7371): The type mismatch describer that outputs an error message explaining the difference between the data types of given arguments and the expected data types could in some situations miss to include `Undef` in the generated description. Now `Undef` is included if it should.

* [PUP-7366](https://tickets.puppetlabs.com/browse/PUP-7366): A regression in Hiera 5 caused an error to not be issued when calls to any of the `hiera_*` functions contained an unescaped period `.` in the requested key. There is no such restriction when the `lookup` function is used. The regression caused silent undefined behavior. This is now fixed and the earlier behavior of the `hiera_*` functions have been restored.

* [PUP-7077](https://tickets.puppetlabs.com/browse/PUP-7077): Puppet can now manage files on UNC shares when the user has permission to create or modify the file, but the share permissions are not Full Control.

* [PUP-7191](https://tickets.puppetlabs.com/browse/PUP-7191): Prior to Puppet 4.10.0, Puppet would report an error when ensuring a non-existent was not running on AIX. In Puppet 4.10.0, Puppet now considers this a no-op, in line with behavior on other *nix operating systems.

* [PUP-6006](https://tickets.puppetlabs.com/browse/PUP-6006): The error message when the language validation finds multiple problems was hard to understand in terms of what the underlying cause could be. Now it points out it is language validation and states that more info is in the logs. It also suggests that `--max_errors=1` can be useful in this situation.

* [PUP-7306](https://tickets.puppetlabs.com/browse/PUP-7306): Complex regular expressions output by Puppet generated types could be too complex for the Puppet language lexer. The lexer would then not recognize the token as a regular expression and would cause a syntax error on the opening `/`. This was caused by the Puppet language lexer not allowing new lines in the regular expression. They are now allowed.

* [PUP-7328](https://tickets.puppetlabs.com/browse/PUP-7328): If `environment_timeout` was set to a value other than `0`, there would be a warning logged, "Puppet Class 'settings' is already defined" for all subsequent compilations in that environment. The `settings` class is now only created once for the lifetime of an environment.

* [PUP-7327](https://tickets.puppetlabs.com/browse/PUP-7327): A regression from Puppet 4.8 was caused by the Hiera 5 implementation in Puppet 4.9.0 that resulted in the support for `hiera3_backends` using a feature to take over resolution of "dotted keys" stopped working. This behavior is now restored.

* [PUP-7341](https://tickets.puppetlabs.com/browse/PUP-7341): If all keys specifying `lookup_options` in Hiera data files were based on regular expression patterns, Puppet would crash. This is now fixed. If you're not upgrading, a work around while waiting for the fix is to add a lookup options for a dummy fixed key.

* [PUP-7360](https://tickets.puppetlabs.com/browse/PUP-7360): Hiera deprecation messages contained a URL to our documentation site that produced a 404 (not found). This was because the linked URL contained the ".z" version of Puppet, and it should only contain "x.y" part of version. This is now fixed.

* [PUP-5027](https://tickets.puppetlabs.com/browse/PUP-5027): The `metadata.json` in each module was parsed multiple times and the logic involved an extra check for existance of the `metadata.json` file. This is now changed. This has a small positive impact on performance in large environments with many modules and in virtual environments because it reduces the number of calls to `stat`.

* [PUP-1334](https://tickets.puppetlabs.com/browse/PUP-1334): Prior to Puppet 4.10.0, if Puppet failed to fully write a filebucket backup, resulting in a corrupt or empty backup file, subsequent attempts to back up the same file could result in a failure with the message, "Got passed new contents for sum (a check sum value)". The only way to correct this issue was to search for and delete the offending partial backup inside the filebucket backup directory.

  This was due to a false positive detection of a hash collision in the filebucket. Puppet would detect a duplicate backup file, and subsequently detect that its checksum value did not match the incoming backup, but would not verify that the existing backup matched the *expected* checksum value.

  As of 4.10.0, if Puppet detects a possible hash collision between an existing and incoming filebucket backup, it will first check if the existing backup has been corrupted (as in, if it does not match its expected contents or checksum value). If so, Puppet will issue a warning and overwrite the corrupted existing backup rather than failing with the previous error message.

  The previous error message: "Got passed new contents for sum (checksum value)" has also been revised to:

  (On a locally logged error message on the filebucket server):

  "Unable to verify existing FileBucket backup at (path to file)"

  (The raised exception):

  "Existing backup and new file have different content but same checksum, (checksum value). Verify existing backup and remove if incorrect."

* [PUP-7021](https://tickets.puppetlabs.com/browse/PUP-7021): Prior to Puppet 4.10.0, Puppet user management on some *nix platforms could experience various errors related to the handling of UTF-8 characters read in by the ruby `etc`module (which parses `/etc/passwd` and `/etc/group` for user and group information among other things). As of Puppet 4.10.0 and later, Puppet will attempt to convert values read in by the ruby `etc` module to UTF-8 if they are not already UTF-8. If the values cannot be cleanly converted to UTF-8, they are left as-is. These unconvertible values can still cause issues later during the lifecycle of a run, so it is important for Puppet to be run in UTF-8 environments.
