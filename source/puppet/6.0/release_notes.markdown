---
layout: default
toc_levels: 1234
title: "Puppet 6.0 release notes"
---

This page lists the changes in Puppet 6.0 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

### If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](../5.1/release_notes.html), [Puppet 5.2](../5.2/release_notes.html), [Puppet 5.3](../5.3/release_notes.html), and [Puppet 5.4](../5.4/release_notes.html) release notes, because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](../4.10/release_notes.html) and [Puppet 4.9 release notes](../4.9/release_notes.html).

## Puppet 6.0.4

Released 1 November 2018.

This is a bug-fix and new feature release.

### Bug fixes

- Puppet 6.0.3 failed with a faulty error message when a legacy function did not comply with the standard rules. In Puppet 6.0.4 the intended error is raised. [PUP-9270](https://tickets.puppetlabs.com/browse/PUP-9270)
- Puppet now only sets the user, group, and mode of log files if Puppet creates them. [PUP-7331](https://tickets.puppetlabs.com/browse/PUP-7331)
- The members property has been fixed to have the same API for `retrieve` and `should` as it did prior to the breaking changes in 5.5.7, while also reporting the right change notification. Providers can now return an array for `getter` and accept an array for `setter`. [PUP-9267](https://tickets.puppetlabs.com/browse/PUP-9267). 

### New feature

- RHEL 8 has DNF as the default package provider. [PUP-9198](https://tickets.puppetlabs.com/browse/PUP-9198)

## Puppet 6.0.3

Released 25 October 2018.

This release contains bug fixes and new features.

### Bug fixes

- Fixed issue where overlapping module paths caused an incorrect illegal location deprecation warning or error. [PUP-9211](https://tickets.puppetlabs.com/browse/PUP-9211)
- Empty or comments only files will no longer emit a deprecation warning or error about illegal top level construct. [PUP-9190](https://tickets.puppetlabs.com/browse/PUP-9190)
- In 6.0, Puppet logged an exception at the error level every time it needed to fall back to encoding a catalog in PSON. This could cause the logs to fill up with errors when nothing was wrong. This has now changed to log at the debug level. [PUP-9185](https://tickets.puppetlabs.com/browse/PUP-9185)
- Puppet will no longer leak sensitive data into the resource file. [PUP-7580](https://tickets.puppetlabs.com/browse/PUP-7580)

### New features and improvements

- Added `puppet ssl clean` command to the `puppet ssl` application. This will remove an agent's private key, public key, certificate or certificate signing request. If the `--localca` option is specified, the action will also remove the agent's copy of the CA certificate(s) and CRL bundle that it previously downloaded from the CA. This way users will not accidentally delete their entire CA directory when trying to clean the agent that's running on the CA host. Note that `puppet ssl clean` is a companion to `puppetserver ca clean`. The former should be run on an agent host to clean that agent's ssl directory. The latter should be run on the CA to manage certificates and requests for *all* agents. [PUP-9156](https://tickets.puppetlabs.com/browse/PUP-9156)
- The `--logdest` argument can be set in the `puppet.conf` file as the `logdest` setting. [PUP-2997](https://tickets.puppetlabs.com/browse/PUP-2997)

## Puppet 6.0.2

Released 4 October 2018

This is a release to address a regression that resulted from Puppet 6.0.1. This issue has been fixed. See the bug fix in the following section for details.

### Bug fixes

- Puppet 6.0.1 contained a regression that made `unless` and `onlyif` of the `exec` resource not respect the specified `cwd`. This has now been fixed. ([PUP-9194](https://tickets.puppetlabs.com/browse/PUP-9194))
- The Windows service provider now returns `enable = false, ensure = stopped` for nonexistent services, and errors when setting `enable = true` or `ensure = running` on nonexistent services. ([PUP-6822](https://tickets.puppetlabs.com/browse/PUP-6822))

### New features

- The `Puppet::Util::Windows::Service` module now supports an `exists?` method, which returns `true` if a given service exists, `false` otherwise. ([PUP-9179](https://tickets.puppetlabs.com/browse/PUP-9179))


## Puppet 6.0.1

Released 2 October 2018

This release contains new features and bug fixes.

### New features and improvements

- The `Puppet::Util::Windows::ADSI::User` class now supports setting and unsetting ADSI userflags. ([PUP-9177](https://tickets.puppetlabs.com/browse/PUP-9177))
- `Puppet::Util::Execution.execute` now supports a `cwd` option to specify the current working directory that the command will run in. This option is only available on the agent. It cannot be used on the master, meaning it cannot be used in, for example, regular functions, Hiera backends, or report processors. ([PUP-6919](https://tickets.puppetlabs.com/browse/PUP-6919))
- We are now doing translations for extracted modules. ([PUP-9053](https://tickets.puppetlabs.com/browse/PUP-9053))

### Bug fixes

- Tests (or Ruby logic in one function calling other functions) that assumed that calling a function with a nested `:undef` would convert it to either `nil` or leave it as `:undef` where no longer true in Puppet 6.0.0. This was changed in PUP-9112 where certain transformations were no longer needed because the language did not need them. Turned out tests, and possibly custom logic in Ruby would benefit from keeping conversions. The fix is that `:undef` in nested array and hash values will be converted to `nil` and this makes a difference when calling 3x functions from Ruby. ([PUP-9180](https://tickets.puppetlabs.com/browse/PUP-9180))
- When using interpolation inside a heredoc, the position and location information for the interpolated expressions were wrong. This could lead to two problems:
  * If using `[]` expressions, a mysterious syntax error would be raised if a 
seemingly arbitrary position after the interpolation contained white-space. 
  * If there were errors in the interpolation, they could be reported for the wrong line and position on the line.

    These are now fixed. ([PUP-9163](https://tickets.puppetlabs.com/browse/PUP-9163))
- Previously, an agent configured to use one or more compiler servers with the `server_list` setting could skip an available server under certain conditions. Now the agent requests status of the "master" service specifically, which accurately reports if the compiler service is available. ([PUP-9159](https://tickets.puppetlabs.com/browse/PUP-9159))
- Previously, the helpful error text from `puppet cert` describing the new command alternatives would only appear when `puppet cert` was called with no arguments. It will now appear with any `puppet cert` invocation. ([PUP-9155](https://tickets.puppetlabs.com/browse/PUP-9155))
- For Bolt: the task object returned by PAL's `ScriptCompiler#task_signature` method has been changed to pass through metadata to enable support for revision 3 of the task specification. ([PUP-9153](https://tickets.puppetlabs.com/browse/PUP-9153))
- 3x functions loaded as a side effect of calling `function_<name>()` in Ruby were again loaded when called from the Puppet Language or when using `call_function` in Ruby from another function. This caused warnings for overwrite of already loaded functions to appear in some circumstances, and it impacted performance when reloading. ([PUP-9137](https://tickets.puppetlabs.com/browse/PUP-9137))
- `puppet apply --catalog` did not resolve `deferred` values when applying the catalog. ([PUP-9121](https://tickets.puppetlabs.com/browse/PUP-9121))
- Restarting services on OS X would frequently fail due to a race condition in Puppet. This is fixed. ([PUP-9111](https://tickets.puppetlabs.com/browse/PUP-9111))
- We have updated the Portage package provider for changes to Gentoo package management. ([PUP-9044](https://tickets.puppetlabs.com/browse/PUP-9044))
- The AIX user provider now handles the `groups` property in a manner that's consistent with other Linux user providers. Specifically, it reads the user's groups from the `/etc/group` file and implements `inclusive/minimum` membership correctly, even when the user's primary group changes. ([PUP-7393](https://tickets.puppetlabs.com/browse/PUP-7393))
- The members property in the group resource has now been fixed to report the right change notifications to Puppet. ([PUP-6542](https://tickets.puppetlabs.com/browse/PUP-6542))
- Previously, the `state.yaml` file could grow unbounded. The new `statettl` setting controls how long entries are cached (default: 32 days). If you use resource schedules, see the `statettl` documentation to see how this setting interacts with the schedule type. ([PUP-3647](https://tickets.puppetlabs.com/browse/PUP-3647))


## Puppet 6.0.0

Released 18 September 2018

This release is a major Puppet release including many new features, improvements, bug fixes, and some deprecations. Read on for more information.


### New features and improvements

- In this release, many types were moved out of the Puppet core codeblock and to modules on the [Puppet Forge](https://forge.puppet.com/). This change enables easier composability and reusability of the Puppet codebase and enables development to proceed more quickly without fear of destabilizing the rest of Puppet. Some types are now in supported modules and are repackaged back into Puppet agent. Some are now in modules that are updated, but are not repackaged into Puppet agent. And some are in modules that are deprecated, not updated, and not repackaged back into Puppet agent.

See the [Resource Type Reference](/puppet/6.0/type.html) page for the full list, and links to the Forge modules for those types that moved.

- Resource API has been added, providing a new, recommended method to create custom types and providers. The Resource API is built on top of Puppet core and is easier, faster, and safer than the old types and providers method. See the [Resource API documentation](/puppet/6.0/create_types_and_providers_resource_api.html) for more information.

- Recently introduced `puppetserver ca` command is the default now, and CA-related subcommands have been removed from Puppet. These are:
    * `cert`
    * `ca`
    * `certificate`
    * `certificate_request`
    * `certificate_revocation_list`
Instead, use `puppetserver ca` and `puppet ssl`. ([PUP-8998](https://tickets.puppetlabs.com/browse/PUP-8998))
- The `puppet cert` command will now error with instructions on alternative commands to use, mostly `puppetserver ca <subcommand>`. A couple of the actions (fingerprint, print) have not been directly replaced because openssl already provides good equivalents. For verifying certs, use `puppet ssl verify`. ([PUP-9022](https://tickets.puppetlabs.com/browse/PUP-9022))
- Puppet no longer has a Ruby CA. All CA actions now rely entirely on the Clojure implementation in Puppet Server. It can be interacted with by means of the CA API and the `puppetserver ca` command, which leverages the API using subcommands like those provided by `puppet cert`. ([PUP-8912](https://tickets.puppetlabs.com/browse/PUP-8912))
- The `puppet node clean` command will now go through Puppet Server's CA API to clean up certs for a given node. This will help avoid issues where multiple entities attempt to revoke certs at once, since all of these updates are now funneled through the API, which handles concurrent requests correctly. See [SERVER-115](https://tickets.puppetlabs.com/browse/SERVER-115) and [PUP-9108](https://tickets.puppetlabs.com/browse/PUP-9108) for more information.
- Puppet agent will now correctly save and load chained SSL certificates and certificate revocation lists when in an environment where its certs are issued by Puppet acting as an intermediate CA. ([PUP-8652](https://tickets.puppetlabs.com/browse/PUP-8652))

- A new feature where the use of the `Deferred` data type in a catalog makes it possible to call functions on the agent before the catalog is applied. It is now possible to call all functions implemented in Ruby on the agent side. (Notably, it is not possible to call functions written in the Puppet language, as they are not available on the agent). ([PUP-9035](https://tickets.puppetlabs.com/browse/PUP-9035))
- There is a new puppet subcommand for working with SSL certificates. "puppet ssl" currently supports the `submit_request`, `download_cert`, and `verify` actions for working with SSL certificates on the agent. ([PUP-9028](https://tickets.puppetlabs.com/browse/PUP-9028))

- When requesting task-details, Puppet master now returns a list of all files from the tasks metadata `files` and `implementations['files']` keys. ([PUP-9081](https://tickets.puppetlabs.com/browse/PUP-9081))
- The Devuan service provider now defaults to the Debian init provider. ([PUP-9048](https://tickets.puppetlabs.com/browse/PUP-9048))
- An `apply` keyword has been added to Puppet's parser when running with tasks enabled. See puppet-specifications for details. ([PUP-8977](https://tickets.puppetlabs.com/browse/PUP-8977))

- The `input_method` property of Tasks now defaults to `undef` rather than the string `both`. This allows more flexibility in defaults and what `input_methods` we choose to support in the future. ([PUP-8898](https://tickets.puppetlabs.com/browse/PUP-8898))
- `convert_to()` function now accepts additional arguments where earlier it only accepted the data type to convert to. ([PUP-8761](https://tickets.puppetlabs.com/browse/PUP-8761))
- A `compare(a,b)` function has been added that returns `-1`, `0`, or `1` depending on if `a` is before `b`, same as `b`, or after `b`. The function works with the comparable types: `String`, `Numeric`, `Semver`, `Timestamp`, and `Timespan`. For `String` comparison it is possible to ignore or take case into account. ([PUP-8693](https://tickets.puppetlabs.com/browse/PUP-8693))
- A new data type `Deferred` has been added. It is used to describe a function call that can be invoked at a later point in time. ([PUP-8635](https://tickets.puppetlabs.com/browse/PUP-8635))
- It is now possible to resolve a `Deferred` value by using the `call` function. It can resolve a `deferred` function call, and a `deferred` variable dereference (with support to `dig` into a structured value). ([PUP-8641](https://tickets.puppetlabs.com/browse/PUP-8641))
- It is now possible to use `operator `+` to concatenate two `Binary` data type values.
([PUP-8605](https://tickets.puppetlabs.com/browse/PUP-8605))
-The `sort()` function has been moved from `stdlib` to Puppet. The function now also accepts a lambda for the purpose of using a custom compare. ([PUP-8622](https://tickets.puppetlabs.com/browse/PUP-8622))
- The functions `upcase()`, `downcase()`, `capitalize()`, `camelcase()`, `lstrip()`, `rstrip()`, `strip()`, `chop()`, `chomp()`, and `size()` have been updated to the modern function API and the new versions are in Puppet and no longer require `stdlib`). The functions are generally backwards compatible. ([PUP-8604](https://tickets.puppetlabs.com/browse/PUP-8604))
- The math functions `ab`s, `ceil`, `floor`, `round`, `min`, and `max` are now available in puppet. The functions are compatible with the functions with the same name in `stdlib` with the added feature in `min/max` if calling them with a single array and being able to use a lambda with a custom compare. These `stdlib` math functions used inconsistent string to numeric conversions that were also unintentionally making the functions compare values in strange ways. The automatic conversions are now deprecated and will issue a warning. ([PUP-8603](https://tickets.puppetlabs.com/browse/PUP-8603))
- The `rich_data` setting is now enabled by default. Catalog requests have two new content-types, `application/vnd.puppet.rich+json` and `application/vnd.puppet.rich+msgpack`, that are used when both master and agent have this enabled (and depending on whether `preferred_serialization_format` is `json` or `msgpack`). ([PUP-8601](https://tickets.puppetlabs.com/browse/PUP-8601))
- Puppet's default `basemodulepath` now includes a vendored modules directory, which enables puppet to load modules that are vendored in the puppet-agent package. To prevent puppet from loading modules from this directory, change the `basemodulepath` back to its previous value, for example, on *nix `$codedir/modules:/opt/puppetlabs/puppet/modules`. On Windows: `$codedir/modules`. ([PUP-8582](https://tickets.puppetlabs.com/browse/PUP-8582))
- The `modulepath` as defined in `environment.conf` can now accept globs in the path name. ([PUP-8556](https://tickets.puppetlabs.com/browse/PUP-8556))
- This change adds a `notdefaultfor` that prevents a provider from being a default for a given set of facts. `notdefaultfor` overrides any `defaultfor` and should be defined more narrowly. ([PUP-8552](https://tickets.puppetlabs.com/browse/PUP-8552))
- Parameters can now be marked sensitive at the class level rather then just the instance level. ([PUP-8514](https://tickets.puppetlabs.com/browse/PUP-8514))
- `SystemD` is now set as the default provider for Ubuntu 17.04 and 17.10. ([PUP-8495](https://tickets.puppetlabs.com/browse/PUP-8495))
- It is now possible to use the same "dot notation" to dig out a value from a structure like in hiera/lookup and elsewhere in puppet. To support this, the `getvar()` function has moved from `stdlib` to Puppet, and we have added a new function `get()`. You can now for example use `getvar('facts.os.family')` starting with the variable name. The `get` function is the general function which takes a value and a dot-notation string. ([PUP-7822](https://tickets.puppetlabs.com/browse/PUP-7822))
- It is no longer required to have a dependency listed in a module's metadata.json on another module (b) in order to use functions or data types from module b. ([PUP-6964](https://tickets.puppetlabs.com/browse/PUP-6964))
- Updated the version of the Addressable Ruby Gem now that Ruby 1.9.3 support has been removed from Puppet. ([PUP-6894](https://tickets.puppetlabs.com/browse/PUP-6894))


### Bug fixes

- With rich-data turned on for a catalog (now the default) a Report could contain rich data in reported events, and that was not good because nothing downstream from the agent is prepared to handle rich data. This is now fixed so that data in reported events are stringified when needed. ([PUP-9093](https://tickets.puppetlabs.com/browse/PUP-9093))
- The deprecation for illegal top level constructs is now an error. ([PUP-9091](https://tickets.puppetlabs.com/browse/PUP-9091))
- Attempt to use the reserved attribute names `__ptype` and `__pvalue` in custom `Object` data types will now raise an error instead of producing bad result when serializing such objects. ([PUP-9079](https://tickets.puppetlabs.com/browse/PUP-9079))
- It was not possible to use a hash key `__pcore_type` in a hash as that would trigger the special handling during serialization. Now in Puppet 6.0.0, the special key has changed to `__ptype` and it is not also possible to use that as a key in a hash and still be able to serialize it (for example use it in a catalog). ([PUP-8976](https://tickets.puppetlabs.com/browse/PUP-8976))
- When the agent is configured with a list of servers (using `server_list`), it will now request server status from the `status` endpoint instead of the "node" endpoint. ([PUP-8967](https://tickets.puppetlabs.com/browse/PUP-8967))
- The selmodule type is now more strict about checking if a module has already been loaded, and should no longer consider modules such as "bar" and "foobar" to be the same module. ([PUP-8943](https://tickets.puppetlabs.com/browse/PUP-8943))
- Puppet now considers resources that have failed to restart when notified from another resource as failed, and will mark them as such in reports. Reports also now include the `failed_to_restart` status for individual resources, instead of only including a total count of `failed_to_restart` resources in the resource metrics section. This also bumps the report format version to 10. ([PUP-8908](https://tickets.puppetlabs.com/browse/PUP-8908))
- Fix an issue running in JRuby where we didn't store autoloaded paths in the same way that the JRuby implementation did, leading to a bug where a type or provider could get loaded more than once. ([PUP-8733](https://tickets.puppetlabs.com/browse/PUP-8733))
- Puppet's autoloader methods now require a non-nil environment. This is a breaking API change, but should not affect any user extensions like 3x functions.
Puppet sometimes used the configured environment instead of the current environment to autoload. This mainly affected agents when loading provider features.
Calling Puppet::Parser::Functions.autoloader.load* methods are deprecated, and will issue a warning if strict mode is set to warning or error. Instead use `Scope#call_function("myfunction")` to call other functions from within a function. ([PUP-8696](https://tickets.puppetlabs.com/browse/PUP-8696))
- When comparing Numeric to Timestamp or Timespan it did not work to compare with the Numeric value first. This is now fixed. ([PUP-8694](https://tickets.puppetlabs.com/browse/PUP-8694))
- The `http_read_timeout` default changed from infinite to 10 minutes. This prevents the agent from hanging if there are network disruptions after the agent has sent an HTTP request and is waiting for a response which might never arrive. Similarly, the `runtimeout` default also changed from infinite to 1 hour. ([PUP-8683](https://tickets.puppetlabs.com/browse/PUP-8683))
- The Tidy resource type now uses the debug log level for its "File does not exist" message, instead of the info level. This means that resources of this type will no longer emit the message by default when the target of the resource has already been cleaned from disk. ([PUP-8667](https://tickets.puppetlabs.com/browse/PUP-8667))
- With this change - if the user has distributed the CRL chain "out of band" - then the agent will successfully load it and use it to verify its connection to other Puppet infrastructure (for example the master). It expects the CRL chain to be one or more PEM encoded CRLs concatenated together (the same format as a cert bundle). This fixes the "Agent-side CRL checking is not possible" caveat on in our [External CA documentation]( https://puppet.com/docs/puppet/5.5/config_ssl_external_ca.html#option-2-puppet-server-functioning-as-an-intermediate-ca). ([PUP-8656](https://tickets.puppetlabs.com/browse/PUP-8656))
- When processing malformed plist files, we used to use /dev/stdout which can cause Ruby to complain. We now use '-' instead which means to use stdout when processing the plist file with plutil. ([PUP-8545](https://tickets.puppetlabs.com/browse/PUP-8545))
- Trusted server facts are always enabled and have been deprecated since 5.0. This removes the setting and conditional logic. ([PUP-8530](https://tickets.puppetlabs.com/browse/PUP-8530))
- The write_only_yaml node terminus was used to "determine the list of
nodes that the master knows about" and predated widespread puppetdb
adoption. The write_only_yaml has been deprecated since 4.10.5, and
this commit removes it. Note this should result in a puppetserver speedup as it no longer will need to serialize node data as YAML to disk during a compile. ([PUP-8528](https://tickets.puppetlabs.com/browse/PUP-8528))
- Puppet 6 now requires ruby 2.3 or greater, and will error when running on older ruby versions. Several code paths relating to old ruby behavior have been removed. ([PUP-8484](https://tickets.puppetlabs.com/browse/PUP-8484))
- Puppet requires ruby 2.3 or greater. ([PUP-8483](https://tickets.puppetlabs.com/browse/PUP-8483))
- EPP comments `<%# Like this %>` always trimmed preceding whitespace. This is different from ERB making it more difficult to migrate ERB templates to EPP. There was also no way of making EPP preserve those spaces. Now, EPP comment does not trim preceding whitespace by default, and a new left trimming tag `<%#-` has been added. This is a backwards incompatibility in that code like, `Before <%# comment %>after` resulted in the string `"Beforeafter"`, whereas now it will be `"Before after"`. ([PUP-8476](https://tickets.puppetlabs.com/browse/PUP-8476))
- The `filter` function did not accept truthy value returned from the block as indication of values to include in the result. Only exactly boolean `true` was earlier accepted. ([PUP-8320](https://tickets.puppetlabs.com/browse/PUP-8320))
- Puppet now uses YAML.safe_load consistently to ensure only known classes are loaded. ([PUP-7834](https://tickets.puppetlabs.com/browse/PUP-7834))
- The LDAP node terminus has been removed. ([PUP-7601](https://tickets.puppetlabs.com/browse/PUP-7601))
- Restructure puppet's Gemfile so that bundler installs puppet's runtime, feature-related, and test dependencies by default. The development and documentation groups can be installed using: bundle install --with development documentation. ([PUP-7433](https://tickets.puppetlabs.com/browse/PUP-7433))
- Puppet now uses the shared gem dependency for semantic_puppet, rather than loading its own vendored version. ([PUP-7157](https://tickets.puppetlabs.com/browse/PUP-7157))
- Puppet now loads semantic_puppet from a shared gem directory, so that Puppet, Puppet agent, and Puppet Server all require and use the same version of the gem. (~>1.0.x) ([PUP-7115](https://tickets.puppetlabs.com/browse/PUP-7115))
- Puppet now requires ruby 2.3 or greater. We removed code paths for older ruby support, e.g. 1.8.7, relaxed our gem dependencies to include gems that require ruby 2 or up, and now test puppet PRs against JRuby 9k. ([PUP-6893](https://tickets.puppetlabs.com/browse/PUP-6893))
- Total time now reports the measured time of the run instead of a sum of other run times. ([PUP-6344](https://tickets.puppetlabs.com/browse/PUP-6344))
- Features defined using a block or a list of libraries now behave the same, so the following are equivalent:

    ``
    Puppet.features.add(:my_feature) do
    require 'mylib'
    end
    ``
    and

    `Puppet.features.add(:my_feature, libs: ['my_lib'])`

    Previously the result of the block was always cached. With this change only true or false return values are cached. To indicate that the state of the feature is unknown and may become available later, the block should return nil. ([PUP-5985](https://tickets.puppetlabs.com/browse/PUP-5985)
- Errors will be reported for module files declarations that have a namespace inconsistent with their directory and file location. ([PUP-4242](https://tickets.puppetlabs.com/browse/PUP-4242))
- Generating graphs of catalogs (such as `puppet apply --graph`) now correctly handles resources with double quotes in the title. ([PUP-2838](https://tickets.puppetlabs.com/browse/PUP-2838))


### Deprecations

- The `computer`, `macauthorization`, and `mcx` types and providers have been moved to a module: https://forge.puppet.com/puppetlabs/macdslocal_core. It is not being repackaged into puppet-agent for 6.0
- The Nagios types no longer ship with Puppet, and are now available as the `puppetlabs/nagios_core` module from the Forge.
- The Cisco network device types no longer ship with Puppet. These types and providers have been deprecated in favor of the `puppetlabs/cisco_ios` module, which is available on the Forge. ([PUP-8575](https://tickets.puppetlabs.com/browse/PUP-8575))

- In versions before Puppet 6.0.0, values from manifests assigned to resource attributes that contained undef values nested in arrays and hashes would use the Ruby symbol :undef to represent those values. When using puppet apply types and providers would see those as :undef or as the string "undef" depending on the implementation of the type. When using a puppet master, the same values were correctly handled. In Puppet 6.0.0 Ruby `nil` is used consistently for this. (Top level undef values are still encoded as empty string for backwards compatibility). ([PUP-9112](https://tickets.puppetlabs.com/browse/PUP-9112))

- To reduce the amount of developer tooling installed on all agents, this version of puppet removes the `puppet module build` command. To continue building module packages for the forge and other repositories, install [Puppet Development Kit (PDK)](https://puppet.com/docs/pdk/1.x/pdk_install.html). <!--- or the community provided [puppet-blacksmith](https://rubygems.org/gems/puppet-blacksmith) on your development systems. [Needs PDK-1100 resolved before the `puppet-blacksmith` part is true.]---> ([PUP-8763](https://tickets.puppetlabs.com/browse/PUP-8763))

- The earlier experimental --rich_data format used the tags __pcore_type__ and __pcore_value__, these are now shortened to __ptype and __pvalue respectively. If you are using this experimental feature and have stored serializations you need to change them or write them again with the updated version. ([PUP-8597](https://tickets.puppetlabs.com/browse/PUP-8597)

- Webrick support (previously deprecated) has been removed. To run Puppet as a server you must use `puppetserver`. ([PUP-8591](https://tickets.puppetlabs.com/browse/PUP-8591))

- The `puppet master` command, and its supported sub commands, have been removed. Instead, use a [`puppet-config`](https://puppet.com/docs/puppet/6.0/man/config.html) command. [PE-24280](https://tickets.puppetlabs.com/browse/PE-24280)

- The --strict flag in `puppet module` has been removed. The default behavior remains intact, but the tool no longer accepts non-strict versioning (such as release candidates, beta versions, etc) ([PUP-8558](https://tickets.puppetlabs.com/browse/PUP-8558))

- The previously deprecated "configtimeout" setting has been removed in favor of the "http_connect_timeout" and "http_read_timeout" settings. ([PUP-8534](https://tickets.puppetlabs.com/browse/PUP-8534))

- The unused `ignorecache` setting has been removed. ([PUP-8533](https://tickets.puppetlabs.com/browse/PUP-8533))

- The previously deprecated `pluginsync` setting has now been removed. The agent's pluginsync behavior is controlled based on whether it is using a cached catalog or not. ([PUP-8532](https://tickets.puppetlabs.com/browse/PUP-8532))

- The deprecated app_management setting has now been removed. Previously, this setting was ignored, and always treated as though it was set to be on. ([PUP-8531](https://tickets.puppetlabs.com/browse/PUP-8531)

- Types and Provider implementations must not mutate the parameter values of a resource. In Puppet 6.0.0 it is more likely that the parameters of a resource will have frozen (that is, immutable) string values and any type or provider that directly mutates a resource parameter may fail. Before Puppet 6.0.0, every resource attribute was copied to not make application break even if they did mutate. Look for use of `gsub!` in your modules and replace logic with non mutating version, or operate on a copy of the value. (All modules authors of modules on the forge having this problem have been notified). ([PUP-7141](https://tickets.puppetlabs.com/browse/PUP-7141))

- The deprecated method `Puppet.newtype` (deprecated since 2011), has now been removed. ([PUP-7078](https://tickets.puppetlabs.com/browse/PUP-7078))

- The deprecated `ordering` setting has been removed, and catalogs now always have the ordering previously provided by the "manifest" value of this setting. ([PUP-6165](https://tickets.puppetlabs.com/browse/PUP-6165))

- We have removed settings related to the rack webserver from Puppet. These are:
* binaddress
* masterhttplog
([PUP-3658](https://tickets.puppetlabs.com/browse/PUP-3658))

- As a part of the larger CA rework, the v1 CA HTTP API is removed (everything under the ca url /v1) ([PUP-3650](https://tickets.puppetlabs.com/browse/PUP-3650))

- The following subcommands were deprecated in Puppet 5.5.6 and slated for removal in Puppet 6.0. While they are still deprecated, they have not yet been removed.


    -   `ca_name`
    -   `cadir`
    -   `cacert`
    -   `cakey`
    -   `capub`
    -   `cacrl`
    -   `caprivatedir`
    -   `csrdir`
    -   `signeddir`
    -   `capass`
    -   `serial`
    -   `autosign`
    -   `allow_duplicate_certs`
    -   `ca_ttl`
    -   `cert_inventory`
