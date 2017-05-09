---
layout: default
toc_levels: 1234
title: "Puppet 4.10 Release Notes"
---

This page lists the changes in Puppet 4.10 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If you're upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), because they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.9 release notes](/puppet/4.9/release_notes.html) and [Puppet 4.8 release notes](/puppet/4.8/release_notes.html).

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

### Deprecation

The `puppet inspect` command is deprecated in Puppet 4.10, along with the related `audit` resource metaparameter. The command will be removed and the `audit` parameter will be ignored in manifests in a future release (planned for Puppet 5). ([PUP-893](https://tickets.puppetlabs.com/browse/PUP-893))

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