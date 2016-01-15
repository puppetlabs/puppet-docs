---
layout: default
title: "Puppet 3.7 Release Notes"
description: "Puppet release notes for version 3.7"
canonical: "/puppet/latest/reference/release_notes.html"
---

[upgrade]: /puppet/3.8/reference/upgrading.html
[puppet_3]: /puppet/3/reference/release_notes.html
[puppet_35]: /puppet/3.5/reference/release_notes.html
[puppet_36]: /puppet/3.6/reference/release_notes.html

[puppet.conf]: ./config_file_main.html
[main manifest]: ./dirs_manifest.html
[env_api]: ./yard/file.http_environments.html
[file_system_redirect]: ./lang_windows_file_paths.html#file-system-redirection-when-running-32-bit-puppet-on-64-bit-windows
[environment.conf]: ./config_file_environment.html
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[directory environments]: ./environments.html
[future]: ./experiments_future.html

This page tells the history of the Puppet 3.7 series. (Elsewhere: release notes for [Puppet 3.0 -- 3.4][puppet_3], [Puppet 3.5][puppet_35], and [Puppet 3.6][puppet_36].)

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

Before upgrading, **look at the table of contents above and see if there are any "UPGRADE WARNING" or "Upgrade Note" items for the new version.** Although it's usually safe to upgrade from any 3.x version to any later 3.x version, there are sometimes special conditions that can cause trouble.

We always recommend that you **upgrade your Puppet master servers before upgrading the agents they serve.**

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.


## Puppet 3.7.5

Released March 26, 2015.

Puppet 3.7.5 is a bug fix release (with two urgent behavior changes) in the Puppet 3.7 series. In addition to fixing a handful of bugs, it includes some final changes to the future parser to prepare for Puppet 4.0.

### UPGRADE NOTE: One Changed Setting Default, One New Feature

This release breaks semantic versioning slightly, as it includes two changes we'd normally save for a .Y release: a new setting available in `environment.conf`, and a changed default value for the global `environment_timeout` setting. We included the former because it's time-sensitive and relevant to peoples' upcoming Puppet 4 migrations, and the latter because the existing default value basically constituted a bug.

See the two sections below for more details.

### New Default Value: `environment_timeout = 0`

When we first introduced [environment][directory environments] caching, we set a three minute default, because we wanted to give everyone at least some performance benefit. This turned out to be the wrong choice, mostly because cache invalidation is difficult. There were two main problems:

1. The default delay wasn't intuitive, and users got confused and frustrated when they deployed new Puppet code and the Puppet master refused to notice it.
2. Because most Puppet master servers use multiple Ruby interpreters (all of which initialize their caches at different times), using a simple timer for cache invalidation doesn't actually work in the first place --- depending on how the server manages its interpreters, there's a chance of serving contradictory catalogs for the duration the cache timeout, which is really bad.

These caused enough trouble that changing the behavior in a bug fix release was worth it. The new situation is:

* The default timeout is `0` --- no performance boost, but also won't surprise anyone.
* For better performance, set `environment_timeout = unlimited` and make refreshing the Puppet master a part of your standard code deployment process. See [the timeout section of the Configuring Environments page][configuring_timeout] for more details.
* Don't bother with any timeout value other than `0` or `unlimited`. You would need to refresh the master anyway to avoid inconsistent catalogs.

Also, we recommend treating `environment_timeout` as server-wide configuration. Avoid setting it in [environment.conf][] unless you have some specific reason. (For example, if you have one environment where you habitually edit code live on the server.)

[configuring_timeout]: ./environments_configuring.html#environmenttimeout

* [PUP-4094: Default environment_timeout should be 0, not infinity.](https://tickets.puppetlabs.com/browse/PUP-4094)

### New Feature: `parser` Setting in `environment.conf`

As Puppet 4 gets closer, we're trying to reduce barriers to testing your code with [the new version of the Puppet language.][future]

To that end, you can now set the `parser` setting per-environment in [environment.conf][]. This should hopefully make compatibility tests much less disruptive.

* [PUP-4017: Make "parser" an environment specific setting](https://tickets.puppetlabs.com/browse/PUP-4017)

### High-Profile Bug Fixes

When certain modules containing custom resource types (most notably `vcsrepo`) were available in some environments but not `production`, many users were running into a mysterious `invalid parameter provider` error if they specified a value for that resource type's `provider` attribute. (A non-ideal workaround was to add the affected module to the `production` environment.)

The problem was that the Puppet master was loading types from the agent's environment to validate resources, but it was only loading providers from its _own_ environment. This is now fixed.

* [PUP-1515: When compiling a catalog, providers should be loaded from specified environment](https://tickets.puppetlabs.com/browse/PUP-1515)

### Future Parser Fixes and Updates

As of this version, the [future parser][future] should be almost exactly compatible with the Puppet language in the most recent 4.0.0 release candidates.

* [PUP-1806: Varargs support for the new function API](https://tickets.puppetlabs.com/browse/PUP-1806)
* [PUP-3548: 4x function API's call_function cannot call a 3x function](https://tickets.puppetlabs.com/browse/PUP-3548)
* [PUP-3923: Puppet 4 lexer misinterprets multiple '/' tokens as a regex following a variable.](https://tickets.puppetlabs.com/browse/PUP-3923)
* [PUP-3936: Injected parameter results in omission of block parameter](https://tickets.puppetlabs.com/browse/PUP-3936)
* [PUP-3947: Type validation fails when validating hashes using a struct type.](https://tickets.puppetlabs.com/browse/PUP-3947)
* [PUP-3978: Change how block is passed to avoid confusion with missing optional parameters](https://tickets.puppetlabs.com/browse/PUP-3978)
* [PUP-3987: Change Closure.call to not take scope](https://tickets.puppetlabs.com/browse/PUP-3987)
* [PUP-3991: scanf only implemented for future parser](https://tickets.puppetlabs.com/browse/PUP-3991)
* [PUP-3998: continued shorthand interpolation of numeric variable fails (future parser)](https://tickets.puppetlabs.com/browse/PUP-3998)
* [PUP-4000: Struct with optional values is not assignable from Hash where key is missing](https://tickets.puppetlabs.com/browse/PUP-4000)
* [PUP-4008: Inferred type of empty hash not assignable to Hash<String,String>](https://tickets.puppetlabs.com/browse/PUP-4008)
* [PUP-4047: change wording of 'non productive expression' errors](https://tickets.puppetlabs.com/browse/PUP-4047)
* [PUP-4064: Internal error from TypeCalculator when function called with incorrect args](https://tickets.puppetlabs.com/browse/PUP-4064)
* [PUP-4082: unfold of undef should mean unfold nothing](https://tickets.puppetlabs.com/browse/PUP-4082)
* [PUP-4086: File and line numbers often missing from errors](https://tickets.puppetlabs.com/browse/PUP-4086)
* [PUP-4133: Future parser error when interpolating name segment starting with underscore](https://tickets.puppetlabs.com/browse/PUP-4133)
* [PUP-4205: Puppet 4 lexer fails to parse multiple heredocs on the same line](https://tickets.puppetlabs.com/browse/PUP-4205)


### Other Language Fixes

Two issues related to variables: [the `defined` function](./function.html#defined) wasn't properly handling variable names like `$::global_var`, and module testing could run into problems when the `strict_variables` setting was enabled. (To fix the latter, we now make sure that the [`$module_name` and `$caller_module_name` variables](./lang_facts_and_builtin_vars.html#parser-variables) are always defined, but they're set to `undef` when they don't have another value.)

* [PUP-4072: defined() function returns wrong value for global variable check](https://tickets.puppetlabs.com/browse/PUP-4072)
* [PUP-4066: With strict variables turned on, it is difficult to use built in variables when testing module](https://tickets.puppetlabs.com/browse/PUP-4066)

### Resource Type and Provider Fixes

Since the default value of the `package` type's `allow_virtual` attribute will be changing in Puppet 4, we had added a deprecation warning about it, but this turned out to be too noisy to be useful. We're removing the warning... so be sure to read the release notes before you upgrade to Puppet 4! (Also, hi, thanks for reading the release notes.)

We also improved provider detection for Fedora systems that use systemd.

* [PUP-3927: (Regression) Redhat service provider is being used on systemd-based Fedora systems](https://tickets.puppetlabs.com/browse/PUP-3927)
* [PUP-4076: Remove the 'allow_virtual' warning in the 3.x series](https://tickets.puppetlabs.com/browse/PUP-4076)

### Miscellaneous Fixes

This release fixes some inaccuracies in [dot graphs](./configuration.html#graph), a problem where catalog runs could fail with `current thread not owner` if Puppet agent received a `USR1` signal, a problem where Puppet agent couldn't upgrade Puppet on systems that use Yum and systemd (like CentOS 7), and misleading line numbers in error messages when using the `create_resources` function.

* [PUP-914: expanded_relationship.dot should not have both containment and relationship edges](https://tickets.puppetlabs.com/browse/PUP-914)
* [PUP-1635: "current thread not owner" after Puppet Agent receives USR1 signal](https://tickets.puppetlabs.com/browse/PUP-1635)
* [PUP-3931: Upgrading Puppet package within Puppet agent run on EL7 results in bad package state](https://tickets.puppetlabs.com/browse/PUP-3931)
* [PUP-4054: create_resources() error messages are less useful in 3.x then they were in 2.x](https://tickets.puppetlabs.com/browse/PUP-4054)

### Internal Fixes

No user-facing code ever tripped this bug, but we ran into it in testing and cleaned it up.

* [PUP-3934: Environment used before set in Resource.initialize when this needs access to its type](https://tickets.puppetlabs.com/browse/PUP-3934)

### All Resolved Issues for 3.7.5

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.5.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=12507)



## Puppet 3.7.4

Released January 27, 2015.

Puppet 3.7.4 is a bug fix release in the Puppet 3.7 series. In addition to fixing a handful of bugs, it includes some final changes to the future parser to prepare for Puppet 4.0.


### Future Parser

This release contains several bug fixes and adjustments in the future parser, in preparation for Puppet 4.0.

#### Language Changes

* When specifying allowed data types for class or defined type parameters, the shorthand for a hash with specific contents has changed.

    Previously, you could provide one argument (`Hash[String]`) to say a hash's _values_ must be a specific type, without saying anything about the keys. Now, you must specify the type of _both the keys and the values_ (`Hash[String,String]`).

    We changed this to be more consistent. The Hash type also has a four-argument form, and the type for values is the _second_ argument; moving that into the first position when you shortened the argument list was too confusing.

    [PUP-3680: The parameter order on the hash type is inconsistent](https://tickets.puppetlabs.com/browse/PUP-3680)

* Quoted numbers are now always strings, and never numbers. [PUP-3615: Remove automatic string to number conversion](https://tickets.puppetlabs.com/browse/PUP-3615)

#### New `scanf` Function

Since the future parser handles numbers more strictly now, we added [a new `scanf` function](./function.html#scanf) that can extract real numbers from strings. If you need to deal with quoted numbers, this is the new right way to handle them.

[PUP-3635: Add a scanf function for string to numeric conversion (and more)](https://tickets.puppetlabs.com/browse/PUP-3635)

#### Bug Fixes

* Heredoc strings can be indented, with the indent removed from the final string. They can also include cosmetic line breaks that don't appear in the final string, if a line ends with a backslash. If you combined those two features, you'd get bogus space characters left over from the indentation. This is now fixed. [PUP-3091: heredoc should trim left margin before joining lines](https://tickets.puppetlabs.com/browse/PUP-3091)

* Add-ons that use information from the parser (like `puppet strings`) were getting slightly wrong metadata about the position of empty items in a file. [PUP-3786: Empty LiteralHash and LiteralList parameters get parsed with positioning information that excludes their closing delimiter](https://tickets.puppetlabs.com/browse/PUP-3786)

* Exported resource collectors are supposed to combine results from PuppetDB and from the current catalog, and empty queries (which should catch every resource of that type) weren't catching anything from the catalog. [PUP-3701: Issue with empty export resources expression in the Puppet future parser](https://tickets.puppetlabs.com/browse/PUP-3701)

* You can specify allowed data types for block parameters, but they weren't working the same way as class and defined type parameters. Now they do. [PUP-3461: Blocks validate parameters incorrectly](https://tickets.puppetlabs.com/browse/PUP-3461)

#### Backstage Work

We re-implemented the code that handles resource collectors. This was one of the last areas of shared code we needed to replace before we could remove the "current" parser in Puppet 4. The new code should work the same way as the old code, so it should cause no observable changes.

* [PUP-2906: Reimplement Collection without 3x AST](https://tickets.puppetlabs.com/browse/PUP-2906)

The following bugs weren't ever released; we fixed them while making sure the re-implemented resource collector code worked correctly.

* [PUP-3665: future parser collector override with Resource reference does not work](https://tickets.puppetlabs.com/browse/PUP-3665)
* [PUP-3806: Issue with Collectors and the Future Parser](https://tickets.puppetlabs.com/browse/PUP-3806)


### Resource Type and Provider Bugs

This release fixes an issue with the service provider in RHEL, where `enabled` services might stop in the wrong order during system shutdown. An issue where the cron type was decrementing the month when a month name was provided (e.g., treating `December` as month 11) is also fixed.

* [PUP-1343: Service provider in RedHat will not create K?? stop scripts](https://tickets.puppetlabs.com/browse/PUP-1343)
* [PUP-3728: Cron type uses incorrect month when month name is provided](https://tickets.puppetlabs.com/browse/PUP-3728)


### Performance

This release greatly improves application startup time if a lot of directory environments (500+) are present. This release also fixes an issue where, in certain cases, environments weren't being cached.

* [PUP-3389: Significant delay in puppet runs with growing numbers of directory environments](https://tickets.puppetlabs.com/browse/PUP-3389)
* [PUP-3621: Environments::Cached#get! bypasses the environment cache.](https://tickets.puppetlabs.com/browse/PUP-3621)

### Miscellaneous Bugs

This release fixes a bug where, if the default environment was somehow broken, Puppet agent runs in other environments would also fail. We've also fixed an issue where agents with ENC-specified environments received plugins from the wrong environment.

Prior to this release, RHEL 6 with Ruby 1.8.7 wasn't handling HTTP keepalive properly, so we've disabled keepalive completely for 1.8.7. Note that this is a short-term fix and that Puppet 4 will not support Ruby 1.8.7.

This release also fixes a Puppet gem packaging problem for Windows.

* [PUP-3591: Puppet does not plugin sync with the proper environment after agent attempts to resolve environment](https://tickets.puppetlabs.com/browse/PUP-3591)
* [PUP-3755: Catalogs are transformed to resources outside of node environments](https://tickets.puppetlabs.com/browse/PUP-3755)
* [PUP-3682: RHEL6 with ruby 1.8.7 and webrick sometimes does not handle HTTP keepalive correctly.](https://tickets.puppetlabs.com/browse/PUP-3682)
* [PUP-3737: Can't Install Puppet Gem on Windows64 Bit Ruby 1.9.3 and 2.0](https://tickets.puppetlabs.com/browse/PUP-3737)


## Puppet 3.7.3

Released November 4, 2014.

Puppet 3.7.3 is a bug fix release in the Puppet 3.7 series. It gives Windows users the useful new `$system32` fact (due to packages now pulling in Facter 2.3), and fixes some bugs with directory environments, the `PATH` variable on Windows, and the future parser. It also lays groundwork for some future Puppet Server improvements.

### New `$system32` Fact on Windows --- No More Fussing With `sysnative`

The Puppet installer for Windows now includes [Facter 2.3.0](/facter/2.3/release_notes.html), which introduced two new facts to improve life on Windows:

* [`$system32`](/facter/latest/core_facts.html#system32) is the path to the **native** system32 directory, regardless of Ruby and system architecture.
* [`$rubyplatform`](/facter/latest/core_facts.html#rubyplatform) reports the value of Ruby's `RUBY_PLATFORM` constant.

The `$system32` fact makes it much easier to write cross-architecture Puppet code for Windows. Previously, you couldn't write Puppet code to reliably manage system files on all three possible architecture mixtures (64-bit Windows with the 64-bit Puppet installer, 64-bit Win and 32-bit Puppet, and 32-bit/32-bit), so you had to know which Puppet installer your nodes were using and write architecture-specific resources. But now you can do something like:

~~~ ruby
file { "$system32/myfile.txt":
  ensure => file
}
~~~

This will resolve to `c:/windows/system32/myfile.txt` on 64-bit/64-bit and 32-bit/32-bit, and to `c:/windows/sysnative/myfile.txt` on 64-bit/32-bit.

The `$rubyplatform` fact is meant for working around more complicated architecture issues. For most users, the `$system32` fact should be enough, but if you're doing anything strange you can fall back on `$rubyplatform` for full control.

* [PUP-3601: Bump facter dependency to 2.3.0](https://tickets.puppetlabs.com/browse/PUP-3601)

### Fix for Expanding Environment Variables in Windows `PATH` Variable

This bug was introduced in Puppet 3.7.0.

The value of the Windows `PATH` variable can usually only include static directory paths, like `C:\Windows\system32`. However, if you manually change the PATH variable's type to `REG_EXPAND_SZ` (<a href="http://msdn.microsoft.com/en-us/library/ms724884%28v=vs.85%29.aspx">relevant Windows docs</a>), you can make Windows allow environment variables like `%systemroot%` in the `PATH`. (Installing certain software can also do this.)

If you had done this and added environment variables to your `PATH`, the 32-bit Windows Puppet installer would expand those variables and rewrite your `PATH` with static directory paths instead. We've fixed it so it won't do that anymore.

If you were using environment variables in your `PATH` and have run an earlier Puppet 3.7.x release, you may need to re-set your `PATH` after upgrading to 3.7.3. Most Windows users shouldn't be affected by this, though.

* [PUP-3471: Windows Puppet x86 Installer Expands Environment Variables in Path](https://tickets.puppetlabs.com/browse/PUP-3471)

### Directory Environment Fixes

This release fixes a gnarly bug where using certain settings (including `certname`) could interfere with the use of directory environments. Plus another bug where using `puppet resource file <PATH> source=<PUPPET URL>` to interactively overwrite a file would fail if directory environments were enabled.

* [PUP-3302: Puppet resource broken when directory environments enabled](https://tickets.puppetlabs.com/browse/PUP-3302)
* [PUP-3500: Adding a setting to puppet.conf that has a :hook handled on define preloads incorrect directory environment settings.](https://tickets.puppetlabs.com/browse/PUP-3500)

### Future Language Fixes

This release fixes a bug with parameters whose names match the name of a top-scope variable, some uninformative error messages, a bug with multi-byte characters, and a bug where MD5 sums might get compared as floating point numbers.

* [PUP-3505: Future parser handling undef's incorrectly](https://tickets.puppetlabs.com/browse/PUP-3505)
* [PUP-3514: Future parser not showing line/column for error](https://tickets.puppetlabs.com/browse/PUP-3514)
* [PUP-3558: Future parser, square brackets in references cause syntax errors related to non-ASCII characters](https://tickets.puppetlabs.com/browse/PUP-3558)
* [PUP-3602: Do not convert strings that are on the form "0e<digits>" to floating point](https://tickets.puppetlabs.com/browse/PUP-3602)

### Groundwork for Future Puppet Server Improvements

If you're running [Puppet Server](https://github.com/puppetlabs/puppet-server) and have environments with long [`environment_timeout`](./environments_configuring.html#environmenttimeout) values, there's a period of potential inconsistency every time you change code in those environments, since each of Puppet Server's JRuby interpreters started their timeout counters at different times. To make changes take effect immediately, you must restart the whole Puppet Server process. (And since Puppet Server takes longer to start than a Rack-based Puppet master, this can result in a short period of failed requests.)

We're not fixing that in this release, because it's complicated. But we did lay some mandatory groundwork for the real fix.

You can track the related work at [SERVER-92](https://tickets.puppetlabs.com/browse/SERVER-92).

* [PUP-3555: introduce override-able factory pattern for constructing environment cache entries](https://tickets.puppetlabs.com/browse/PUP-3555)

### All Resolved Issues for 3.7.3

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.3.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=12001)


Puppet 3.7.2
-----

Released October 22, 2014.

[rack_master]: ./services_master_rack.html
[resource_like]: ./lang_classes.html#include-like-vs-resource-like
[include_like]: ./lang_classes.html#include-like-vs-resource-like
[enc]: /guides/external_nodes.html
[env_setting]: ./configuration.html#environment

Puppet 3.7.2 is a bug fix release in the Puppet 3.7 series. It plugs a significant memory leak in the Puppet master application, improves Puppet's resistance to POODLE attacks (but you still need to check your Apache configs), and fixes a variety of other bugs.


### Security Fixes (POODLE)

There's a new SSL vulnerability in town (named "POODLE"), and it pretty much marks the end for SSLv3.

You've probably already done this, but **please check your web server configs and make sure SSLv3 is disabled.** The Puppet master application usually [runs as a Rack application][rack_master] behind a web server that terminates SSL, and you'll need to look at that web server's configuration to make sure it rejects SSLv3 connections.

In general, Puppet's exposure to POODLE is quite low (see [our blog post about POODLE](http://puppetlabs.com/blog/impact-assessment-sslv3-vulnerability-poodle-attack) for more info), but it's best to be safe anyway.

**In this release,** we've disabled SSLv3 for WEBrick Puppet master processes. (A while back, we already disabled SSLv3 in the virtual host config we ship with the `puppetmaster-passenger` packages, as well as the example vhosts in our docs and the Puppet source.)

* [PUP-3467: Reject SSLv3 connections in Puppet](https://tickets.puppetlabs.com/browse/PUP-3467)


### Performance Fixes

A regression in 3.7.0 caused Puppet master's memory footprint to grow continuously until the process was killed. This affected masters running under Rack, WEBrick, and Puppet Server.

* [PUP-3345: Puppet Master Memory Leak](https://tickets.puppetlabs.com/browse/PUP-3345)


### Resource Type and Provider Fixes

This release fixes several bugs with the Windows `scheduled_task` resource type, a bug with purging a user's SSH authorized keys, and a bug with the Solaris package provider.

* [PUP-643: Solaris pkg package provider does not handle expiring certificates](https://tickets.puppetlabs.com/browse/PUP-643)
* [PUP-1165: Spurious 'trigger changed' messages generated by scheduled task provider](https://tickets.puppetlabs.com/browse/PUP-1165)
* [PUP-3203: scheduled_task triggers cannot be updated](https://tickets.puppetlabs.com/browse/PUP-3203)
* [PUP-3357: Unexpected error with multiple SSH keys without comments](https://tickets.puppetlabs.com/browse/PUP-3357)

### External Node Classifier (ENC) Fixes

When an ENC assigns a class, it can set class parameters or choose not to. If it _does_ assign class parameters, Puppet will evaluate the class with [resource-like behavior][resource_like]; otherwise, Puppet will use [include-like behavior][include_like] for that class.

Prior to this release, Puppet was evaluating all of the ENC classes _without_ parameters first, which increased the chances of a "duplicate declaration" error. We've now changed the ENC behavior so that classes _with_ parameters are evaluated first.

This release also fixes a regression from 3.7.0 that made `puppet apply` malfunction when used with an ENC.

* [PUP-3351: Puppet evaluates classes declared with parameters before classes declared without parameters](https://tickets.puppetlabs.com/browse/PUP-3351)
* [PUP-3258: puppet apply + ENC + 3.7.x: does not read the .pp file](https://tickets.puppetlabs.com/browse/PUP-3258)



### Directory Environment Fixes

Prior to this release, if directory environments were enabled and an [external node classifier (ENC)][enc] specified a nonexistent environment for a node, that node would use the value of its [`environment` setting][env_setting] to request its catalog instead of using the ENC-specified environment and failing as expected. Now, the ENC-specified environment is authoritative even if it doesn't exist, and nodes will fail predictably instead of landing in unexpected environments.

This release also makes Puppet reload `environment.conf` at the same time it reloads the other files from an environment.

* [PUP-3244: ENC returned environment ignored when using directory environments](https://tickets.puppetlabs.com/browse/PUP-3244)
* [PUP-3334: Changes to environment.conf are not being picked up, even when environment timeout is set to 0.](https://tickets.puppetlabs.com/browse/PUP-3334)

### Future Parser Fixes And Improvements

This release makes several improvements to consistency and predictability in the future parser.

* [PUP-3363: future parser give weird error in trailing comma after assignment](https://tickets.puppetlabs.com/browse/PUP-3363)
* [PUP-3366: type system does not handle Enum/String compare correctly](https://tickets.puppetlabs.com/browse/PUP-3366)
* [PUP-3401: Type system does not handle Pattern correctly](https://tickets.puppetlabs.com/browse/PUP-3401)
* [PUP-3365: consider not doing deep undef to empty string map in 3x function API](https://tickets.puppetlabs.com/browse/PUP-3365)
* [PUP-3364: Attempt to use Numeric as title in a Resource type causes internal error](https://tickets.puppetlabs.com/browse/PUP-3364)
* [PUP-3201: Validation thinks that an Undef instance is of type Runtime](https://tickets.puppetlabs.com/browse/PUP-3201)



### Packaging Improvements

This release clarifies some text in the Windows installer and fixes an upgrade conflict on Debian and Ubuntu.

* [PUP-3315: Windows agent installer should specify that FQDN is expected](https://tickets.puppetlabs.com/browse/PUP-3315)
* [PUP-3227: Upgrade conflict: puppetmaster-common and puppet-common](https://tickets.puppetlabs.com/browse/PUP-3227)


### All Resolved Issues for 3.7.2

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.2.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=11925)


Puppet 3.7.1
-----

Released September 15, 2014.

Puppet 3.7.1 is a bug fix release in the Puppet 3.7 series. It fixes regressions introduced by Puppet 3.7.0, some issues with directory environments, and a few other bugs.

### Regressions from 3.7.0

Puppet 3.7.0 broke error handling when trying to manage nonexistent services on Windows, replacing a descriptive message with "`Could not evaluate: uninitialized constant Win32::Service::Error`". It also broke certain functions in the future parser, and caused the `puppet module` command to change its behavior around symlinks.

This release fixes those regressions.

- [PUP-3222: Windows service provider references a non-existent class](https://tickets.puppetlabs.com/browse/PUP-3222)
- [PUP-3190: "each" no longer supported in Puppet 3.7.0](https://tickets.puppetlabs.com/browse/PUP-3190)
- [PUP-3191: Symlinks to missing targets cause a File Not Found error instead of a warning](https://tickets.puppetlabs.com/browse/PUP-3191)

### Miscellaneous Bugs

Puppet logs an error message if it tries to manage a resource whose provider isn't suitable for the target system. But it could also log that error if it _wasn't_ managing such a resource, as long as that resource was skipped with [the `tags` setting](./configuration.html#tags) (or the `--tags` option). This release fixes that, so the error only appears if Puppet _actually_ attempts to manage an unsuitable resource.

This release also fixes a potential race condition for the validity of the CA's certificate revocation list (CRL), and a case where agents using Ruby 2.x could hit HTTP errors.

- [PUP-3231: Specifying --tags doesn't cause suitability check to be skipped for skipped resources](https://tickets.puppetlabs.com/browse/PUP-3231)
- [PUP-894: Too easy to hit "CRL not yet valid for `<host>`" (and not very informative)](https://tickets.puppetlabs.com/browse/PUP-894)
- [PUP-1680: "incorrect header check" using Ruby 2](https://tickets.puppetlabs.com/browse/PUP-1680)

### Resource Type and Provider Bugs

Resources whose titles ended with a square bracket would unexpectedly fail with an "invalid tag" error. This was because Puppet was accidentally applying the behavior of the (secret, internal) `component` resource type to all resource types.

- [PUP-3177: Resource titles ending with square brackets fail](https://tickets.puppetlabs.com/browse/PUP-3177)

### Directory Environment Improvements

This release tightens up the rules about interpolating `$environment` when [directory environments][] are enabled: the only setting where `$environment` is allowed is `config_version`, in [environment.conf][].

If you try to interpolate `$environment` into any other setting, Puppet will log a warning and leave the setting with a literal `$environment` in its value. This helps prevent directory environments from getting too dynamic and behaving unpredictably.

This release also fixes errors when the directory specified by the deprecated `manifestdir` setting doesn't exist, and allows use of symlinks in the `environmentpath`.

- [PUP-3174: After enabling directory environments the manifestdir setting is still required to be valid](https://tickets.puppetlabs.com/browse/PUP-3174)
- [PUP-3162: Block $environment in directory based environment configuration settings](https://tickets.puppetlabs.com/browse/PUP-3162)
- [PUP-3186: Puppetmaster removes /etc/puppet/environments/production if it's a link rather than a directory](https://tickets.puppetlabs.com/browse/PUP-3186)

### All Resolved Issues for 3.7.1

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.1.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=11854)

There's also a list of [new issues introduced in Puppet 3.7.1,](https://tickets.puppetlabs.com/issues/?filter=12673) for tracking late-breaking regressions.

Puppet 3.7.0
-----

Released September 4, 2014.

Puppet 3.7.0 is a backward-compatible features and fixes release in the Puppet 3 series. The biggest things in this release are:

* A nearly-final implementation of the Puppet 4 language
* Preview support for a new, fast, natively compiled Facter
* 64-bit Puppet packages for Windows
* Lots of deprecations to prepare for Puppet 4.0

### UPGRADE WARNING (Rack Server Config)

Please check the configuration of your Rack web server and make sure the **keepalive timeout** is configured to be **five seconds or higher.**

If you are using the Apache+Passenger stack, this will be the `KeepAliveTimeout` setting. The default value is `5`, but your global Apache config may have set a different value, in which case you'll need to change it.

Puppet 3.7 introduces [persistent HTTPS connections](#persistent-connections), which gives a major performance boost. But if your server's keepalive timeout is less than the agent's [`http_keepalive_timeout` setting](./configuration.html#httpkeepalivetimeout) (default: four seconds), agents will sometimes fail with an **"Error: Could not retrieve catalog from remote server: end of file reached"** message.

### UPGRADE WARNING (for Windows Users)

Starting with Puppet 3.7, [we provide 64-bit packages for Windows systems.][inpage_win64] When upgrading, Windows users with 64-bit OS versions must decide whether to install the 32-bit package or the 64-bit package.

With this release:

* **We think** the 32-bit package should be backwards-compatible for **most** users, even though we made some changes to private APIs.
* **The 64-bit package may cause unexpected breakages.**

We think most users should use the architecture-appropriate package, but make sure you consider the following before deciding:

* **64-bit Puppet uses Ruby 2.0.** The 32-bit Puppet package still uses Ruby 1.9.3, to maintain compatibility with previous versions. This is a major version jump, and it's possible that some of your plugins will stop working and will need to be updated.
* **If your code uses the `sysnative` alias, it may break.** The `sysnative` alias, used to get around file system redirection, can only be accessed by a 32-bit process running on a 64-bit version of Windows. Once you upgrade to 64-bit Puppet, it will disappear. [See our docs about file system redirection for more details.][file_system_redirect]
* **If your code uses the `ProgramFiles` environment variable, it has a different value in 64-bit Puppet.** In a default Windows installation, the `ProgramFiles` environment variable resolves to `C:\Program Files\` in a 64-bit native application, and `C:\Program Files (x86)\` in a 32-bit process running on a 64-bit version of Windows.

Also, there are some changes that may affect users of 32-bit Puppet as well:

* **There are a few breaking changes to private APIs.** If you use any resource types and providers (or other custom plugins) that access Puppet's internal APIs, they may break in the upgrade. For details, [see the page about private Windows API changes in Puppet 3.7](./deprecated_windows_api.html) and [the puppet-dev thread about these API changes.](https://groups.google.com/forum/#!msg/puppet-dev/IWQyxDH0WcQ/9-5hQCfla-cJ)
* **You may need to upgrade your modules.** If you use any of the following modules from [the Puppet Forge](https://forge.puppetlabs.com), you should upgrade them to the latest versions, since they may have been updated for compatibility with Puppet 3.7:
    * [`puppetlabs/puppetlabs-acl`](https://forge.puppetlabs.com/puppetlabs/puppetlabs-acl)
    * [`puppetlabs/puppetlabs-dism`](https://forge.puppetlabs.com/puppetlabs/puppetlabs-dism)
    * [`puppetlabs/puppetlabs-registry`](https://forge.puppetlabs.com/puppetlabs/puppetlabs-registry)
    * [`puppetlabs/puppetlabs-reboot`](https://forge.puppetlabs.com/puppetlabs/puppetlabs-reboot)
    * [`puppetlabs/puppetlabs-powershell`](https://forge.puppetlabs.com/puppetlabs/puppetlabs-powershell)
    * [`badgerious/npackd`](https://forge.puppetlabs.com/badgerious/npackd)
    * [`badgerious/windows_env`](https://forge.puppetlabs.com/badgerious/windows_env)
    * [`basti1302/windows_path`](https://forge.puppetlabs.com/basti1302/windows_path)
    * [`ptierno/windowspagefile`](https://forge.puppetlabs.com/ptierno/windowspagefile)

In short: Windows users should **test thoroughly before upgrading to Puppet 3.7.**

Check to make sure nothing breaks when upgrading to the 64-bit version. You can always fall back to the 32-bit version, which should work the same as it has before, but **test that too** before upgrading your whole fleet.


### Feature: Nearly Final Implementation of the Puppet 4 Language

For several versions now, Puppet has shipped with a preview of a revised version of the Puppet language, which can be enabled by setting `parser = future` in [puppet.conf][]. This revision, which will become the main implementation of the Puppet language in Puppet 4.0, is now in essentially its final state.

We plan to post complete docs for the Puppet 4 language soon.

Since Puppet 3.7 includes the Puppet 4 version of the language, getting ready to upgrade should be a lot easier than it was for the 2.7 to 3.0 jump. If you want to start preparing now, try setting `parser = future` on a test Puppet master to make sure your existing code still works well.

* [PUP-514: Add optional type to parameters](https://tickets.puppetlabs.com/browse/PUP-514)
* [PUP-121: Remove relative namespacing](https://tickets.puppetlabs.com/browse/PUP-121)
* [PUP-957: Case and Selector expressions using Regexp type does not set match vars](https://tickets.puppetlabs.com/browse/PUP-957)
* [PUP-2314: assert_type function should handle lambda](https://tickets.puppetlabs.com/browse/PUP-2314)
* [PUP-2357: Validation missing for meaningless sequences](https://tickets.puppetlabs.com/browse/PUP-2357)
* [PUP-2514: Remove support to search for Type in String](https://tickets.puppetlabs.com/browse/PUP-2514)
* [PUP-2532: parameter lookup produces screwy result for default values](https://tickets.puppetlabs.com/browse/PUP-2532)
* [PUP-2642: selector expression default should be matched last](https://tickets.puppetlabs.com/browse/PUP-2642)
* [PUP-2682: Trailing commas should be allowed in node definitions](https://tickets.puppetlabs.com/browse/PUP-2682)
* [PUP-2703: tag should be a statement function in future parser](https://tickets.puppetlabs.com/browse/PUP-2703)
* [PUP-2791: Incorrect EPP syntax in epp() function documentation](https://tickets.puppetlabs.com/browse/PUP-2791)
* [PUP-2824: Make $title and $name Reserved Words](https://tickets.puppetlabs.com/browse/PUP-2824)
* [PUP-2839: Puppet 3.6.x future parser introduces dependency cycles](https://tickets.puppetlabs.com/browse/PUP-2839)
* [PUP-2883: epp does not handle empty template](https://tickets.puppetlabs.com/browse/PUP-2883)
* [PUP-2891: creating a resource override for a Class fails (future parser)](https://tickets.puppetlabs.com/browse/PUP-2891)
* [PUP-2898: Long form Resource Type reference fools "future parser" this is an override](https://tickets.puppetlabs.com/browse/PUP-2898)
* [PUP-2886: future parser should validate class/resource names that are types](https://tickets.puppetlabs.com/browse/PUP-2886)
* [PUP-2972: Implementation of +=/-= is potentially confusing](https://tickets.puppetlabs.com/browse/PUP-2972)
* [PUP-3054: Class inheritance behaving incorrectly in the future parser](https://tickets.puppetlabs.com/browse/PUP-3054)
* [PUP-511: Specify Resource Expression Evaluation](https://tickets.puppetlabs.com/browse/PUP-511)
* [PUP-1782: Deprecation warning when attempt to match a number with a regexp in 3.x](https://tickets.puppetlabs.com/browse/PUP-1782)
* [PUP-1807: Empty string should not equal undef](https://tickets.puppetlabs.com/browse/PUP-1807)
* [PUP-1811: "in" with regexps should set match variables](https://tickets.puppetlabs.com/browse/PUP-1811)
* [PUP-2288: access operation vs. liststart causes confusing errors...](https://tickets.puppetlabs.com/browse/PUP-2288)
* [PUP-2794: Specify signatures for blocks of block-accepting methods](https://tickets.puppetlabs.com/browse/PUP-2794)
* [PUP-2825: Change "Ruby" type to "Runtime"](https://tickets.puppetlabs.com/browse/PUP-2825)
* [PUP-2832: Rename the Ruby type to Runtime['ruby']](https://tickets.puppetlabs.com/browse/PUP-2832)
* [PUP-2857: Add a Default type](https://tickets.puppetlabs.com/browse/PUP-2857)
* [PUP-2240: support unfold/splat of array](https://tickets.puppetlabs.com/browse/PUP-2240)
* [PUP-2663: Allow string to numeric conversion to start with + or -](https://tickets.puppetlabs.com/browse/PUP-2663)
* [PUP-1808: Deprecate variables with an initial capital letter](https://tickets.puppetlabs.com/browse/PUP-1808)
* [PUP-2034: Add depreciation warning for hyphenated class names](https://tickets.puppetlabs.com/browse/PUP-2034)
* [PUP-2349: Deprecate non-string modes on file type](https://tickets.puppetlabs.com/browse/PUP-2349)
* [PUP-2557: Deprecate and remove node inheritance](https://tickets.puppetlabs.com/browse/PUP-2557)
* [PUP-2787: Rename Object to Any](https://tickets.puppetlabs.com/browse/PUP-2787)
* [PUP-2914: Vendor RGen 0.7.0](https://tickets.puppetlabs.com/browse/PUP-2914)
* [PUP-3117: Resource Expression Enhancements](https://tickets.puppetlabs.com/browse/PUP-3117)
* [PUP-1057: Remove 'collect' and 'select' iterative function stubs](https://tickets.puppetlabs.com/browse/PUP-1057)
* [PUP-2858: remove --evaluator current switch for future parser](https://tickets.puppetlabs.com/browse/PUP-2858)

### Feature: 64-Bit Support, Ruby 2.0, and FFI on Windows

[inpage_win64]: #feature-64-bit-support-ruby-20-and-ffi-on-windows

We now ship both 32- and 64-bit Puppet installers for Windows! When installing Puppet, you should download the package that matches your systems' version of Windows. If you installed Puppet into a custom directory, or if you need to downgrade, be sure to see the new notes in [the Windows installation page.](/puppet/3.8/reference/install_windows.html)

> **Note:** Windows Server 2003 can't use our 64-bit installer, and must continue to use the 32-bit installer for all architectures. This is because 64-bit Ruby relies on OS features that weren't added until after Windows 2003.

Prior to this release, we only shipped 32-bit packages. Although these ran fine on 64-bit versions of Windows, they were subject to [file system redirection](/puppet/3.6/reference/lang_windows_file_paths.html), which could be surprising.

As part of this expanded Windows support, Puppet on Windows now uses Ruby 2.0. We've also updated a lot of our Windows code to work more reliably and consistently.

* [PUP-389: Support ruby 2.0 x64 on windows](https://tickets.puppetlabs.com/browse/PUP-389)
* [PUP-2396: Support ruby 2.0 x64 on windows](https://tickets.puppetlabs.com/browse/PUP-2396)
* [PUP-2777: Support Bundler workflow on x64](https://tickets.puppetlabs.com/browse/PUP-2777)
* [PUP-3008: Already initialized constant warning when running puppet](https://tickets.puppetlabs.com/browse/PUP-3008)
* [PUP-3056: Restore constants / deprecated call sites changed during x64 upgrade that impact ACL module](https://tickets.puppetlabs.com/browse/PUP-3056)
* [PUP-2913: Remove RGen Gem in Puppet-Win32-Ruby libraries](https://tickets.puppetlabs.com/browse/PUP-2913)
* [PUP-390: Modify build process to generate x86 and x64 versions of ruby](https://tickets.puppetlabs.com/browse/PUP-390)
* [PUP-3006: Do not allow x64 to install on Windows Server 2003](https://tickets.puppetlabs.com/browse/PUP-3006)
* [PUP-836: FFI Puppet::Util::Windows::User module](https://tickets.puppetlabs.com/browse/PUP-836)
* [PUP-837: FFI Puppet::Util::Windows::SID module](https://tickets.puppetlabs.com/browse/PUP-837)
* [PUP-838: FFI Puppet::Util::Windows::Process module](https://tickets.puppetlabs.com/browse/PUP-838)
* [PUP-839: FFI Puppet::Util::Windows::Security module](https://tickets.puppetlabs.com/browse/PUP-839)
* [PUP-840: FFI Puppet::Util::Colors module](https://tickets.puppetlabs.com/browse/PUP-840)
* [PUP-1281: Remove win32console gem in ruby 2.0 on windows](https://tickets.puppetlabs.com/browse/PUP-1281)
* [PUP-1283: Update win32-service gem](https://tickets.puppetlabs.com/browse/PUP-1283)
* [PUP-1760: Update win32-security gem to latest (after string_to_sid fix)](https://tickets.puppetlabs.com/browse/PUP-1760)
* [PUP-2382: Standardize existing FFI code and refactor where necessary](https://tickets.puppetlabs.com/browse/PUP-2382)
* [PUP-2385: FFI Puppet::Util::Windows::File module](https://tickets.puppetlabs.com/browse/PUP-2385)
* [PUP-2521: Remove windows-pr gem as a Windows dependency](https://tickets.puppetlabs.com/browse/PUP-2521)
* [PUP-2554: FFI Puppet::Util::ADSI module](https://tickets.puppetlabs.com/browse/PUP-2554)
* [PUP-2656: FFI Puppet::Util::Windows::Registry](https://tickets.puppetlabs.com/browse/PUP-2656)
* [PUP-2657: FFI Puppet::Util::Windows::Error](https://tickets.puppetlabs.com/browse/PUP-2657)
* [PUP-2738: Investigate FFI Memory Pressure / Deterministically Release FFI MemoryPointer](https://tickets.puppetlabs.com/browse/PUP-2738)
* [PUP-2881: Upgrade win32-taskscheduler (or replace)](https://tickets.puppetlabs.com/browse/PUP-2881)
* [PUP-2889: Upgrade win32-eventlog](https://tickets.puppetlabs.com/browse/PUP-2889)
* [PUP-3060: Remove Warning on Ruby 2.0 / Windows about "DL is deprecated, please use Fiddle"](https://tickets.puppetlabs.com/browse/PUP-3060)
* [PUP-1884: Move Puppet dependencies on windows into the Puppet repo](https://tickets.puppetlabs.com/browse/PUP-1884)

### Feature: Early Support For New Compiled Facter Implementation

Puppet agent can now use preview builds of [the new, faster, natively compiled Facter,][cfacter] by setting `cfacter = true` in [puppet.conf][] or including `--cfacter` on the command line.

* For more details, [see the experimental feature page on native Facter.](./experiments_cfacter.html)

This is a very early version of this feature, and it's not for the faint of heart: since we don't provide builds of the compiled Facter project yet, you'll need to compile and package it yourself. To get started, [see the build and installation instructions in the cfacter repository.][cfacter]

Currently, the natively compiled Facter only supports Linux and OS X.

[cfacter]: https://github.com/puppetlabs/cfacter

* [PUP-2104: Make Puppet able to configure a facter implementation to use](https://tickets.puppetlabs.com/browse/PUP-2104)

### Feature: Agent-Side Pre-Run Resource Validation

Custom resource types now have a way to perform pre-run checks on an agent, and abort the catalog application before it starts if they detect something horribly wrong. Your resource types can do this by defining a `pre_run_check` method, which will run for every resource of that type and which should raise a `Puppet::Error` if the run should be aborted.

For details, see [the section on pre-run validation in the custom resource types guide][prerun].

[prerun]: /guides/custom_types.html#agent-side-pre-run-resource-validation-puppet-37-and-later

* [PUP-2298: PR (#2549) Enable pre-run validation of catalogs](https://tickets.puppetlabs.com/browse/PUP-2298)

### Feature: Improved HTTP Debugging

Puppet has a new [`http_debug` setting](./configuration.html#httpdebug) for troubleshooting Puppet's HTTPS connections. When set to `true` on an agent node, Puppet will log all HTTP requests and responses to stderr.

Use this only for temporary debugging (e.g. `puppet agent --test --http_debug`). It should never be enabled in production, because it can leak sensitive data to stderr. (Also because it's extremely noisy.)

### Feature: Recursive Manifest Directory Loading Under Future Parser

When `parser = future` is set in [puppet.conf][], Puppet will recursively load any subdirectories in the [main manifest][]. This will be the default behavior in Puppet 4.

* [PUP-2711: The manifests directory should be recursively loaded when using directory environments](https://tickets.puppetlabs.com/browse/PUP-2711)

### Feature: Authenticated Proxy Servers

Puppet can now use proxy servers that require a username and password. You'll need to provide the authentication in the new [`http_proxy_user`](./configuration.html#httpproxyuser) and [`http_proxy_password`](./configuration.html#httpproxypassword) settings. (Note that passwords must be valid as part of a URL, and any reserved characters must be URL-encoded.)

* [PUP-2869: Puppet should be able to use authenticated proxies](https://tickets.puppetlabs.com/browse/PUP-2869)

### Feature: New `digest` Function

The [`md5` function](./function.html#md5) is hardcoded to the (old, low-quality) MD5 hash algorithm, which is no good at sites that are prohibited from using MD5.

To help those users, Puppet now has a [`digest` function](./function.html#digest), which uses whichever hash algorithm is specified in the Puppet master's [`digest_algorithm` setting.](./configuration.html#digestalgorithm)

* [PUP-2511: Add parser function digest: uses digest_algorithm to hash, not strictly md5](https://tickets.puppetlabs.com/browse/PUP-2511)

### Feature (Retroactively): Providers Can Inherit From Providers of Another Resource Type

This has actually been possible forever, but it wasn't called out as a legitimate feature. We've added tests to demonstrate that it's supported and to keep it from breaking in the future. For details, [see the relevant section in the provider development guide.](/guides/provider_development.html#a-provider-of-any-resource-type)

* [PUP-2458: Tests for providers inheriting from providers of another type](https://tickets.puppetlabs.com/browse/PUP-2458)



### DEPRECATIONS in Preparation for Puppet 4.0

Puppet 3.7 may well be the final Puppet 3.x release, and we've deprecated a lot of old and crusty features in preparation for Puppet 4.0.

**After upgrading to Puppet 3.7, every Puppet user** should budget some time to read through the following docs pages and investigate the state of Puppet code and custom integrations at their site. We've tried to make it super easy to identify and check off each deprecated feature, so your next upgrade can go as smoothly as possible.


* [About Deprecations in This Version](./deprecated_summary.html)
* [Language Features](./deprecated_language.html)
* [Resource Type Features](./deprecated_resource.html)
* [Extension Points and APIs](./deprecated_api.html)
* [Command Line Features](./deprecated_command.html)
* [Settings](./deprecated_settings.html)
* [Other Features](./deprecated_misc.html)

Relevant tickets:

* [PUP-850: Puppet 3.x Deprecations in Preparation for Puppet 4](https://tickets.puppetlabs.com/browse/PUP-850)
* [PUP-1381: cron type and provider only return resources for ENV["USER"] or "root", not all users](https://tickets.puppetlabs.com/browse/PUP-1381)
* [PUP-1299: Deprecate and eliminate magic parameter array handling](https://tickets.puppetlabs.com/browse/PUP-1299)
* [PUP-2691: Real-world module skeletons still use the 'description' metadata property](https://tickets.puppetlabs.com/browse/PUP-2691)
* [PUP-2711: The manifests directory should be recursively loaded when using directory environments](https://tickets.puppetlabs.com/browse/PUP-2711)
* [PUP-1027: Add warning for use of bare words that clash with new keywords](https://tickets.puppetlabs.com/browse/PUP-1027)
* [PUP-480: Complete handling of undef/nil](https://tickets.puppetlabs.com/browse/PUP-480)
* [PUP-2798: Stop issuing deprecation warnings for reserved words](https://tickets.puppetlabs.com/browse/PUP-2798)
* [PUP-121: Remove relative namespacing](https://tickets.puppetlabs.com/browse/PUP-121)
* [PUP-1874: Deprecate the inventory service on master](https://tickets.puppetlabs.com/browse/PUP-1874)
* [PUP-2379: Deprecate `recurse => inf` for file type](https://tickets.puppetlabs.com/browse/PUP-2379)
* [PUP-406: Deprecate stringify_fact = true](https://tickets.puppetlabs.com/browse/PUP-406)
* [PUP-1782: Deprecation warning when attempt to match a number with a regexp in 3.x](https://tickets.puppetlabs.com/browse/PUP-1782)
* [PUP-1852: deprecate the 'search' function](https://tickets.puppetlabs.com/browse/PUP-1852)
* [PUP-3031: simplify/move warn_if_near_expiration](https://tickets.puppetlabs.com/browse/PUP-3031)
* [PUP-586: Deprecate Instrumentation system](https://tickets.puppetlabs.com/browse/PUP-586)
* [PUP-796: Deprecate couchdb facts terminus and associated settings](https://tickets.puppetlabs.com/browse/PUP-796)
* [PUP-1808: Deprecate variables with an initial capital letter](https://tickets.puppetlabs.com/browse/PUP-1808)
* [PUP-2034: Add depreciation warning for hyphenated class names](https://tickets.puppetlabs.com/browse/PUP-2034)
* [PUP-2349: Deprecate non-string modes on file type](https://tickets.puppetlabs.com/browse/PUP-2349)
* [PUP-2424: Deprecate Puppet::Plugins](https://tickets.puppetlabs.com/browse/PUP-2424)
* [PUP-2557: Deprecate and remove node inheritance](https://tickets.puppetlabs.com/browse/PUP-2557)
* [PUP-2614: Deprecate default source_permissions :use on all platforms](https://tickets.puppetlabs.com/browse/PUP-2614)
* [PUP-3129: Deprecate hidden _timestamp fact](https://tickets.puppetlabs.com/browse/PUP-3129)
* [PUP-877: Deprecate "masterlog" Setting](https://tickets.puppetlabs.com/browse/PUP-877)


### Language Bug Fixes

We fixed a bug where the `contain` function misbehaved when given classes that start with a `::` prefix. We also made [resource collectors](./lang_collectors.html) give more informative errors if you try to collect classes (which isn't allowed).

* [PUP-1597: "contain" cannot contain a fully qualified class](https://tickets.puppetlabs.com/browse/PUP-1597)
* [PUP-2902: collection of classes should raise a meaningful error](https://tickets.puppetlabs.com/browse/PUP-2902)


### Packaging Bugs

We fixed a problem where a man page was being marked as a conflict. We also fixed some issues with directory creation and permissions.

* [PUP-2878: puppet-kick.8.gz conflict upgrading from 2.7.26 to 3.6.2](https://tickets.puppetlabs.com/browse/PUP-2878)
* [PUP-3035: Debian package does not create /var/run/puppet dir during install](https://tickets.puppetlabs.com/browse/PUP-3035)
* [PUP-3156: Fix /var/lib/puppet/state permissions on redhat](https://tickets.puppetlabs.com/browse/PUP-3156)
* [PUP-3163: Fix /var/lib/puppet/reports permissions on debian/redhat](https://tickets.puppetlabs.com/browse/PUP-3163)


### Resource Type and Provider Improvements


#### Package

This release adds `install_options` and `uninstall_options` to the `pacman` provider, makes the `windows` provider accept backslashes in `source` paths, enables `ensure => latest` on OpenBSD, and fixes a few bugs with other providers.

* [PUP-398: Backslashify windows paths when appropriate](https://tickets.puppetlabs.com/browse/PUP-398)
* [PUP-2014: Make gem provider match on a single gem name](https://tickets.puppetlabs.com/browse/PUP-2014)
* [PUP-2311: OpenBSD uninstall broken when multiple uninstall_options given](https://tickets.puppetlabs.com/browse/PUP-2311)
* [PUP-2944: yum provider should use osfamily instead of operatingsystem fact](https://tickets.puppetlabs.com/browse/PUP-2944)
* [PUP-2971: install_options are not passed to yum when listing packages](https://tickets.puppetlabs.com/browse/PUP-2971)
* [PUP-1069: Implement feature :upgradeable for OpenBSD package provider](https://tickets.puppetlabs.com/browse/PUP-1069)
* [PUP-2871: Add :install_options and :uninstall_options to the pacman provider](https://tickets.puppetlabs.com/browse/PUP-2871)

#### File

The `file` type got a handful of bug fixes and no new features.

* [PUP-2583: mode attribute of file type doesn't behave like chmod when given X](https://tickets.puppetlabs.com/browse/PUP-2583)
* [PUP-2710: Audit of mtime/ctime for files on ext4 reports spurious changes (only ruby 1.9+)](https://tickets.puppetlabs.com/browse/PUP-2710)
* [PUP-2700: Puppet 3.6.1 File recurse improperly handles spaces in filenames](https://tickets.puppetlabs.com/browse/PUP-2700)
* [PUP-2946: FileUtils implementation broke compare_stream](https://tickets.puppetlabs.com/browse/PUP-2946)

#### Service

Puppet had a problem with the `cryptdisks-udev` service, and we worked around that by no longer trying to manage it. (This is actually part of [a bigger issue](https://tickets.puppetlabs.com/browse/PUP-3040) with services that can have multiple instances; they don't fit Puppet's model of what services are.)

This release also has some bug fixes for the `openbsd` service provider.

* [PUP-2879: `puppet resource service` not working for `cryptdisks-udev`](https://tickets.puppetlabs.com/browse/PUP-2879)
* [PUP-2578: Adjustments for new OpenBSD service provider](https://tickets.puppetlabs.com/browse/PUP-2578)

#### User

The `user` type got two bug fixes and no new features.

* [PUP-229: User provider password_max_age attribute is flawed under Solaris](https://tickets.puppetlabs.com/browse/PUP-229)
* [PUP-2737: user purge_ssh_keys cannot remove keys with spaces in the comment](https://tickets.puppetlabs.com/browse/PUP-2737)

#### SSHKey

The `sshkey` type was using an overly strict permissions mode for the `/etc/ssh/ssh_known_hosts` file. This release loosens it up a bit.

* [PUP-1177: sshkey creates /etc/ssh/ssh_known_hosts with mode 600](https://tickets.puppetlabs.com/browse/PUP-1177)

#### Cron

When purging `cron` resources (with `resources { cron: purge => true }`), Puppet will only purge cron jobs owned by the user it's running as, usually `root`. This doesn't match expectations, and we want to change Puppet to purge all cron jobs instead.

But we can't do that until 4.0, because it's a big change in behavior and would surprise a lot of users. So in 3.7, Puppet will issue a warning when you purge cron jobs, notifying you of the change coming in 4.0.

* [PUP-1381: cron type and provider only return resources for ENV["USER"] or "root", not all users](https://tickets.puppetlabs.com/browse/PUP-1381)

#### Nagios

The Nagios types were not properly munging non-string values for their attributes. Among other things, this was causing problems when using them with the `create_resources` function. This release fixes that bug.

* [PUP-1527: After upgrade from 3.3.2-1 to 3.4.2-1 naginator fails to create config from exported resources taken from hiera](https://tickets.puppetlabs.com/browse/PUP-1527)

#### Resources

When using `unless_system_user` to limit which `user` resources get purged, Puppet was using the wrong system user cutoff on OpenBSD. This release fixes that.

Also, the `unless_uid` attribute was intended to accept ranges of UIDs, but that turned out to not work.

We decided the best option was to remove the special range support in this type and rely on more general range support. In Puppet 4 and in the future parser, you can use the language's built-in range support, like `unless_uid => Integer[600, 650]`. In the current parser, you can use the `range` function from [the stdlib module](https://forge.puppetlabs.com/puppetlabs/stdlib), like `unless_uid => range(600, 650)`.

* [PUP-2031: unless_uid on user is completely broken wrt ranges](https://tickets.puppetlabs.com/browse/PUP-2031)
* [PUP-2866: Read UID_MIN from /etc/login.defs (if available) instead of hardcoding minimum.](https://tickets.puppetlabs.com/browse/PUP-2866)
* [PUP-2454: User ID's below 1000, not 500, are generally considered system users on OpenBSD](https://tickets.puppetlabs.com/browse/PUP-2454)

#### Yumrepo

The `proxy` attribute now supports the special value `'_none_'`, which lets a repo bypass Yum's global proxy settings. This release also adds stricter checking of values for several attributes, and adds the following new Yum repo options:

* `mirrorlist_expire`
* `gpgcakey`
* `retries`
* `throttle`
* `bandwidth`

Relevant tickets:

* [PUP-2271: yumrepo attributes cannot be set to '_none_'](https://tickets.puppetlabs.com/browse/PUP-2271)
* [PUP-2360: Yumrepo type allows invalid values](https://tickets.puppetlabs.com/browse/PUP-2360)
* [PUP-2356: (PR 2577) Add yumrepo extra options](https://tickets.puppetlabs.com/browse/PUP-2356)

#### Mac OS X Group and Computer Providers

This release fixes a bug that prevented some resource types from working on Yosemite.

* [PUP-2577: Mac OS X version comparison fails spuriously](https://tickets.puppetlabs.com/browse/PUP-2577)

#### SSH Authorized Key

This release fixes a bug where escaped double quotes weren't allowed in the `options` attribute.

* [PUP-2579: ssh_authorized_key does not handle options with escaped double quotes](https://tickets.puppetlabs.com/browse/PUP-2579)

#### Zone

This release fixes a bug that made it impossible to set the `ip`, `dataset`, and `inherit` attributes when creating a zone. (Among other things, this meant sparse zone creation on Solaris 10 was broken.)

* [PUP-2817: Solaris Zone properties ip, dataset and inherit are not set upon zone creation](https://tickets.puppetlabs.com/browse/PUP-2817)

#### Scheduled Task

Thanks to an update in an upstream library, Puppet gives better errors when the Windows task scheduler is disabled.

* [PUP-2818: Win32-taskscheduler gem 0.2.2 (patched in vendored repo) crashes when task scheduler is disabled](https://tickets.puppetlabs.com/browse/PUP-2818)



### Puppet Agent Bug Fixes

This release fixes several issues with the Puppet agent application, including unwanted timeouts, a bug on Windows where the service would hang, some needlessly noisy log messages, and a bug involving the lockfile.

* [PUP-1070: puppetd doesn't always cleanup lockfile properly](https://tickets.puppetlabs.com/browse/PUP-1070)
* [PUP-1471: Puppet Agent windows services accidentally comes of out Paused state](https://tickets.puppetlabs.com/browse/PUP-1471)
* [PUP-2885: Periodic timeouts when reading from master](https://tickets.puppetlabs.com/browse/PUP-2885)
* [PUP-2907: Regression when pluginsyncing external facts on Windows](https://tickets.puppetlabs.com/browse/PUP-2907)
* [PUP-2952: Puppet should only log facts in debug mode](https://tickets.puppetlabs.com/browse/PUP-2952)
* [PUP-2987: Puppet service hangs when attempting to stop on Windows](https://tickets.puppetlabs.com/browse/PUP-2987)

### Puppet Master Bug Fixes

When running `puppet master --compile`, Puppet master used to ignore its `--logdest` option. Now it will log where you ask it to.

* [PUP-2873: puppet master --compile right now unconditionally spews logs to standard output](https://tickets.puppetlabs.com/browse/PUP-2873)


### Puppet Module Command Improvements

The bug affecting module builds is resolved; no more workaround is required. You can now exclude files from your module build using either `.gitignore` or `.pmtignore` files. You can also use `--ignorechanges` flag to ignore any changes made to a module's metadata.json file when upgrading or uninstalling the module. And, finally, symlinks are no longer allowed in modules. The module build command will error on a module with symlinks.

* [PUP-1186: Puppet module tool on windows will (sometimes) create a PaxHeader directory](https://tickets.puppetlabs.com/browse/PUP-1186)
* [PUP-2078: Puppet module install --force does not re-install dependencies](https://tickets.puppetlabs.com/browse/PUP-2078)
* [PUP-2079: puppet module generate can't copy template files without parsing/renaming them](https://tickets.puppetlabs.com/browse/PUP-2079)
* [PUP-2691: Real-world module skeletons still use the 'description' metadata property](https://tickets.puppetlabs.com/browse/PUP-2691)
* [PUP-2745: Puppet 3.6.1 issue with Forge API v3](https://tickets.puppetlabs.com/browse/PUP-2745)
* [PUP-2752: Module tool fails to install new modules if some existing modules version is not Major.Minor.Patch format](https://tickets.puppetlabs.com/browse/PUP-2752)
* [PUP-2781: 'puppet module generate' create not compatible metadata.json with forge](https://tickets.puppetlabs.com/browse/PUP-2781)
* [PUP-2882: PMT upgrade command returns an error when trying to upgrade a module with only one release](https://tickets.puppetlabs.com/browse/PUP-2882)
* [PUP-2040: Allow excluding content from Puppet module tool built packages](https://tickets.puppetlabs.com/browse/PUP-2040)
* [PUP-2918: "puppet module build" gives unhelpful error message](https://tickets.puppetlabs.com/browse/PUP-2918)
* [PUP-2943: Add --ignore-changes to PMT for upgrade and uninstall](https://tickets.puppetlabs.com/browse/PUP-2943)
* [PUP-3009: PMT download treats error responses as modules](https://tickets.puppetlabs.com/browse/PUP-3009)

### Performance Improvements

#### Persistent Connections

The biggest performance win this time comes from using longer-lived persistent HTTPS connections for agent/master interactions. Depending on how many plugins you have and how many files you manage, Puppet agent can make 50-100 separate HTTPS per run, and the SSL handshakes can put stress on the master. By re-using connections, nearly all users should see a speed boost and improved capacity on the Puppet master.

You don't need to do anything to enable this; Puppet will re-use connections whenever it's acting as an HTTP client. You can configure the keepalive timeout on agent nodes with [the `http_keepalive_timeout` setting.](./configuration.html#httpkeepalivetimeout)

#### Feature Caching on Puppet Masters

All users should now set `always_cache_features = true` in the `[master]` section of [puppet.conf][], which should get you a slight Puppet master performance win.

On agents, leaving this setting on `false` allows Puppet to use custom providers immediately after installing gems they require. ([Added in Puppet 3.6](/puppet/3.6/reference/release_notes.html#feature-installing-gems-for-a-custom-provider-during-puppet-runs)) On masters, the installed software doesn't change while a catalog is being compiled, so Puppet can skip the extra feature checks.

We've added this setting to our [list of recommended settings for Puppet master servers.](./config_important_settings.html#settings-for-puppet-master-servers)

#### Other

In other performance news: Puppet no longer searches the disk in a situation where it didn't have to, `puppet apply` is slightly faster when using the future parser, and filebucket operations use less memory.

* [PUP-744: Persistent HTTP(S) connections](https://tickets.puppetlabs.com/browse/PUP-744)
* [PUP-2924: Puppet searches disk for whit classes](https://tickets.puppetlabs.com/browse/PUP-2924)
* [PUP-2860: Optimize startup of Puppet apply (future parser)](https://tickets.puppetlabs.com/browse/PUP-2860)
* [PUP-3032: Setting to cache `load_library` failures](https://tickets.puppetlabs.com/browse/PUP-3032)
* [PUP-1044: FileBucket should not keep files in memory](https://tickets.puppetlabs.com/browse/PUP-1044)


### Improvements to Directory Environments


#### Configurable and Lockable Default Manifest

In previous versions, the default main manifest for any environment that didn't specify a `manifest` setting in [environment.conf][] was hardcoded to that environment's `manifests` directory.

Now, you can use the global [`default_manifest` setting][default_manifest] to choose the manifest that environments without a preference will use.

You can also use [the `disable_per_environment_manifest` setting][disable_per_environment_manifest] to lock all environments to a single global main manifest.

For more details, see:

* The descriptions of the [`default_manifest`][default_manifest] and [`disable_per_environment_manifest`][disable_per_environment_manifest] settings
* The pages on [configuring](./environments_configuring.html) and [creating](./environment_creating.html) directory environments
* The page on [the main manifest](./dirs_manifest.html)

Relevant tickets:

* [PUP-3069: Use a manifest setting in [master] as global manifests](https://tickets.puppetlabs.com/browse/PUP-3069)

#### Other Fixes

We've improved Puppet's behavior and error messages when trying to use an environment that doesn't exist. Also, the [`v2.0/environments` API endpoint][env_api] now includes the `config_version` and `environment_timeout` settings.

* [PUP-2214: Many Puppet commands fail when using a configured or requested directory environment that doesn't exist.](https://tickets.puppetlabs.com/browse/PUP-2214)
* [PUP-2426: Puppet's v2 environment listing does not display config_version and environment_timeout as well.](https://tickets.puppetlabs.com/browse/PUP-2426)
* [PUP-2519: Settings catalog should create the default environment if environmentpath set.](https://tickets.puppetlabs.com/browse/PUP-2519)
* [PUP-2631: Running the Puppet agent against a nonexistent environment produces an overly verbose error message.](https://tickets.puppetlabs.com/browse/PUP-2631)


### Miscellaneous Bug Fixes

The `puppet` command now exits 1 when given an invalid subcommand, instead of exiting 0 as if everything were fine. We fixed some wrong or confusing error messages. The `puppet parser validate` command now handles exported resources just fine even if storeconfigs isn't configured (but only in the future parser). We fixed a bogus error message involving the `Uniquefile` API. And we fixed a regression from Puppet 3.4 that broke plugins using the `hiera` indirector terminus.

* [PUP-1100: create_resources auto importing a manifest with a syntax error produce a bad error message](https://tickets.puppetlabs.com/browse/PUP-1100)
* [PUP-2303: ArgumentErrors in file_server config parser are swallowed by raising the error wrong](https://tickets.puppetlabs.com/browse/PUP-2303)
* [PUP-2506: Error when evaluating #type in Puppet::Error message interpolation for Puppet::Resource::Ral](https://tickets.puppetlabs.com/browse/PUP-2506)
* [PUP-2622: Exit code 0 on wrong command](https://tickets.puppetlabs.com/browse/PUP-2622)
* [PUP-2831: Puppet does not work with RGen 0.7.0](https://tickets.puppetlabs.com/browse/PUP-2831)
* [PUP-2994: Puppet parser validate shouldn't puke on exported resources](https://tickets.puppetlabs.com/browse/PUP-2994)
* [PUP-1843: 3.4.0 broke compatibility with plugins using the hiera indirector terminus](https://tickets.puppetlabs.com/browse/PUP-1843)
* [PUP-3153: Need to guard against `nil` when calling `Uniquefile#close!` in `ensure` blocks](https://tickets.puppetlabs.com/browse/PUP-3153)

### Miscellaneous Improvements

#### More Useful Info at Start of Debug Output

Puppet's `--debug` output now begins with a line containing the following information:

- `puppet_version`
- `ruby_version`
- `run_mode`
- `default_encoding` (on Ruby 1.9.3 or later only)

Relevant tickets:

* [PUP-1736: Add encoding information to debug output](https://tickets.puppetlabs.com/browse/PUP-1736)

#### Improved `file()` Function

The [`file()` function](/reference/3.7.latest/function.html#file) will now accept [template](/reference/3.7.latest/function.html#template)-style module paths, rather than only absolute paths. For example, `file('example/file.txt')` is now equivalent to `file('<MODULE PATH>/example/files/file.txt')`.

* [PUP-2626: Accept module paths in Puppet::Parser::Functions.file()](https://tickets.puppetlabs.com/browse/PUP-2626)


#### Profiling API Improvements

This release also includes some significant backward-compatible improvements to Puppet's built-in profiling API. Specifically:

* The new `Puppet::Util::Profiler.add_profiler` method is an alternative to setting `Puppet::Util::Profiler.current` that allows **multiple profilers** to be active at the same time.
* The `Puppet::Util::Profiler.profile` method now accepts a new optional second argument: an array of strings or symbols that will be used to group profiling data. For example, if you pass `[:functions, name]` as the second argument, then the profiling data will be grouped with other blocks labeled `:functions`, but under its own `name`.

Relevant tickets:

* [PUP-2747: support multiple profilers](https://tickets.puppetlabs.com/browse/PUP-2747)
* [PUP-2750: expand profiler signature to support hierarchical profiling data](https://tickets.puppetlabs.com/browse/PUP-2750)

### Security Improvements

#### Fixed a `puppet cert` Bug

When using `puppet cert revoke` on a certificate that isn't available on disk anymore, Puppet could revoke the wrong cert if _another_ certificate of the same name used to exist. This is now fixed, and `puppet cert revoke <NAME>` will now revoke all certificates by that name.

* [PUP-2569: "puppet cert revoke <name>" doesn't always revoke what you expect](https://tickets.puppetlabs.com/browse/PUP-2569)

#### Better Cipher Settings in Example Virtual Host

We've improved the Apache SSL cipher settings we use in the example Passenger vhost we ship with Puppet.

* [PUP-2177: PR (2494) Insecure shipped Cipher settings in Passenger example config](https://tickets.puppetlabs.com/browse/PUP-2177)

### Improvements for Running Puppet From Source

Running Puppet with Bundler should now work more smoothly on platforms where `ruby-prof` isn't usable.

* [PUP-2842: Limit platforms on which Gemfile tries to install ruby-prof](https://tickets.puppetlabs.com/browse/PUP-2842)


### All Resolved Issues for 3.7.0

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.0.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=11660)

There's also a list of [new issues introduced in Puppet 3.7.0,](https://tickets.puppetlabs.com/issues/?filter=12641) for tracking late-breaking regressions.

### Community Thank-Yous

Big thanks to our community members, who helped make this release what it is. In particular, we'd like to thank:

* [Daniel Berger](https://github.com/djberg96) and Park Heesob, whose Ruby modules have helped make Puppet on Windows a reality.
* All of our community contributors who committed code for this release (listed by the name in their commit messages):
    * Aaron Zauner
    * Alexandros Kosiaris
    * Anthony Weems
    * Brice Figureau
    * Carlos Salazar
    * Daniel Thornton
    * Daniele Sluijters
    * David Caro
    * Dominic Cleal
    * Jeff '2 bits' Bachtel
    * Erik Dalén
    * Ewoud Kohl van Wijngaarden
    * Felix Frank
    * Garrett Honeycutt
    * Graham Taylor
    * glenn.sarti
    * Henrique Rodrigues
    * Jared Jennings
    * Jasper Lievisse Adriaanse
    * Johan Haals
    * Julien Pivotto
    * Maksym Melnychok
    * Martijn Heemels
    * Paul Beltrani
    * Peter Meier
    * renanvicente
    * René Föhring
    * Richard Clark
    * Romain LE DISEZ
    * rvalente
    * Stefan
    * Ville Skyttä
    * William Van Hevelingen
