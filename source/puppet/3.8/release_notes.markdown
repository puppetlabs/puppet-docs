---
layout: default
title: "Puppet 3.8 Release Notes"
description: "Puppet release notes for version 3.8"
canonical: "/puppet/latest/reference/release_notes.html"
---

[upgrade]: ./upgrading.html
[puppet_3]: /puppet/3/reference/release_notes.html

[puppet.conf]: ./config_file_main.html
[main manifest]: ./dirs_manifest.html
[env_api]: /puppet/3.7/reference/developer/file.http_environments.html
[file_system_redirect]: ./lang_windows_file_paths.html#file-system-redirection-when-running-32-bit-puppet-on-64-bit-windows
[environment.conf]: ./config_file_environment.html
[default_manifest]: /puppet/3.7/reference/configuration.html#defaultmanifest
[disable_per_environment_manifest]: /puppet/3.7/reference/configuration.html#disableperenvironmentmanifest
[directory environments]: ./environments.html
[future]: ./experiments_future.html

This page tells the history of the Puppet 3.8 series.

Elsewhere: release notes for:

* [Puppet 3.7](/puppet/3.7/reference/release_notes.html)
* [Puppet 3.6](/puppet/3.6/reference/release_notes.html)
* [Puppet 3.5](/puppet/3.5/reference/release_notes.html)
* [Puppet 3.0 -- 3.4][puppet_3]

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

Before upgrading, **look at the table of contents above and see if there are any "UPGRADE WARNING" or "Upgrade Note" items for the new version.** Although it's usually safe to upgrade from any 3.x version to any later 3.x version, there are sometimes special conditions that can cause trouble.

We always recommend that you **upgrade your Puppet master servers before upgrading the agents they serve.**

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.

## Puppet 3.8.7

Released April 26, 2016.

This is a bug release in the Puppet 3.8 series.

* [All fixes for Puppet 3.8.7](https://tickets.puppetlabs.com/issues/?filter=19117)
* [Introduced in puppet 3.8.7](https://tickets.puppetlabs.com/issues/?filter=19118)

### Bug Fixes

* [PUP-4818](https://tickets.puppetlabs.com/browse/PUP-4818): One part of the `relative namespacing` feature was not removed when using the future parser. When a class was declared with a resource like expression the references to classes were still interpreted as being relative. This is now fixed, and should help with migration to 4.x as the 3.x future parser will now also use absolute naming in these cases.

* [PUP-6113](https://tickets.puppetlabs.com/browse/PUP-6113): Puppet will no longer attempt to retrieve the nonexistent `password_min_age` property from LDAP users on Solaris.

* [PUP-6073](https://tickets.puppetlabs.com/browse/PUP-6073): launchd plists with line continuations no longer cause the launchd service provider to return `Error: Could not prefetch service provider 'launchd': undefined method to_ruby for nil:NilClass`.

* [PUP-5898](https://tickets.puppetlabs.com/browse/PUP-5898): `:undef` caused unexpected behaviors with hashes due to the 3.x calling convention also applying to resource expressions.

* [PUP-5637](https://tickets.puppetlabs.com/browse/PUP-5637): Puppet systemd packages now include an `ExecReload` command in the puppet.service files in order to facilitate graceful restart on systemd systems.

* [PUP-5356](https://tickets.puppetlabs.com/browse/PUP-5356): Fixed the Puppet Nagios extension with Ruby 1.9.3+.

* [PUP-4545](https://tickets.puppetlabs.com/browse/PUP-4545): Removed a script that restarts Puppet in response to network changes on EL based systems. It was causing pain in containers and other systems where network restarts are common and frequent. 

If users have frequent system reboots combined with slow DHCP responses, they may want to add the script back to ensure that their agent is able to connect with their Puppet master.


## Puppet 3.8.6

Released February 3, 2016.

This is a security only release for Windows, that contains an updated version of OpenSSL that addresses a vulnerability announced by OpenSSL on January 28, 2016.

* [Puppet Labs CVE announcement](https://puppetlabs.com/security/cve/openssl-jan-2016-security-fixes)
* [OpenSSL security announcement](http://openssl.org/news/secadv/20160128.txt)

## Puppet 3.8.5

Released January 21, 2016.

Puppet 3.8.5 is a maintenance release in the Puppet 3.8 series that fixes several bugs.

* [All fixes for Puppet 3.8.5](https://tickets.puppetlabs.com/issues/?filter=17212)
* [Introduced in Puppet 3.8.5](https://tickets.puppetlabs.com/issues/?filter=17213)

### Improvements: Speed!

#### Faster service queries on OS X

Puppet 3.8.5 queries service enablement status on OS X several times faster than previous versions of Puppet.

* [PUP-5505](https://tickets.puppetlabs.com/browse/PUP-5505)

#### Faster compilation when `environment_timeout = 0`

In previous versions of Puppet, an environment with an `environment_timeout` set to 0 that used many automatically bound default values would perform poorly, as each lookup caused the environment cache to be evicted and recreated. Puppet 3.8.5 greatly reduces the number of times it evicts the environment and significantly improves compilation performance.

* [PUP-5547: Environment is evicted many times during compilation](https://tickets.puppetlabs.com/browse/PUP-5547)

### New Feature: Set HTTP proxy host and port for the `pip` provider

In previous versions of Puppet, the [`pip` package provider](/references/latest/type.html#package-provider-pip) could fail if used behind an HTTP proxy. This version adds the `http_proxy_host` and `http_proxy_port` settings to the provider.

* [PUP-5212](https://tickets.puppetlabs.com/browse/PUP-5212)

### Security update: Ruby on Windows

Puppet 3.8.5 for Windows includes new versions of Ruby that fix [CVE-2015-7551](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/).

* [PUP-5716](https://tickets.puppetlabs.com/browse/PUP-5716)

### Bug fix: Fix group resources on Windows `--noop` runs when the `members` parameter is an array

In previous version of Puppet 3 for Windows, no-op Puppet runs (such as running `puppet agent` or `puppet apply` with the `--noop` flag) would fail if the `members` parameter of a [group resource](/references/3.8.latest/type.html#group) contained an array. Puppet 3.8.5 resolves this issue.

* [PUP-4426: Group resource doesn't work on Windows when members is an array and noop is used](https://tickets.puppetlabs.com/browse/PUP-4426)

### Bug fixes: Puppet language

* [PUP-5590: No error on duplicate parameters in classes and resources](https://tickets.puppetlabs.com/browse/PUP-5590): In previous versions of Puppet, you could use the same parameter multiple times in a single class or resource without invoking an error. Instead, Puppet would use the second invocation's value only. Puppet 3.8.5 produces an error message when parsing a manifest in which a class or resource assigns the same parameter multiple times.
* [PUP-5658: Disallow numeric ranges where from > to](https://tickets.puppetlabs.com/browse/PUP-5658): Previous versions of Puppet allowed you to create range sub-type declarations (such as `Integer[first,second]`) for integer and and float types where the maximum limit was set first and the minimum limit was set second. Now for such declarations, the first value must not be greater than the second.

### Bug Fixes: Miscellaneous

* [PUP-4426](https://tickets.puppetlabs.com/browse/PUP-4426)
* [PUP-1293](https://tickets.puppetlabs.com/browse/PUP-1293)
* [PUP-5480: Puppet does not apply inheritable SYSTEM permissions to directories it manages on Windows under certain circumstances](https://tickets.puppetlabs.com/browse/PUP-5480)
* [PUP-5522: Puppet::Node attributes not kept consistent with its parameters](https://tickets.puppetlabs.com/browse/PUP-5522): In some Puppet-related applications, or in certain cases when using Puppet from Ruby, a Node object could use one environment but report that it was in another, resulting in the node having the wrong set of parameters. This doesn't affect regular catalog compilation, and is resolved in Puppet 3.8.5.
* [PUP-4516: Agent does not stop with Ctrl-C](https://tickets.puppetlabs.com/browse/PUP-4516): In previous versions of Puppet 3, if the agent process was idle, it could take up to 5 seconds to stop the process in response to SIGINT and SIGTERM signals, such as when pressing **Ctrl-C**. If the Puppet agent was performing a run, it could not be interrupted until after the run completed. Puppet 3.8.5 agents and WEBrick masters immediately exit.
* [PUP-4386: Windows Group resource reports errors incorrectly when specifying an invalid group member](https://tickets.puppetlabs.com/browse/PUP-4386): Previous versions of Puppet on Windows would produce extraneous messages if you specify an invalid group member in a manifest. Puppet 3.8.5 produces accurate error messages.

## Puppet 3.8.4

Released November 3, 2015.

Puppet 3.8.4 is a maintenance release in the Puppet 3.8 series. It includes a security update for Windows OpenSSL, and fixes a few miscellaneous bugs.


* [All fixes for Puppet 3.8.4](https://tickets.puppetlabs.com/issues/?filter=15901)
* [Introduced in Puppet 3.8.4](https://tickets.puppetlabs.com/issues/?filter=15900)


### Security Fix: CA private key now created privately

Previously, Puppet generated a CA private key (Puppet[:cacert]) that was initially world readable, which would create a security vulnerability. Restarting the Puppet master (via webrick, passenger, puppetserver or executing the `puppet cert generate` command) would automatically resolve the issue, so the vulnerability was limited to the time between when Puppet was installed/started and when it was restarted.

This change ensures Puppet creates the CA private key with mode 640 initially.

The private host key (Puppet[:hostprivkey]) had the same issue, but the parent directory was not world executable/traversable, so it wasn't a security issue. This change also fixes the host private key in the same manner as the CA private key.

### Security Fix: Windows OpenSSL

[Update Windows OpenSSL version to 1.0.2d from 1.0.0s](https://tickets.puppetlabs.com/browse/PUP-5273)

### Bug Fix: Windows Password Management

* [PUP-5271: Windows user resource should not manage password unless specified](https://tickets.puppetlabs.com/browse/PUP-5271)

Previously, if you were attempting to create users without specifying the password and you had the Windows Password Policy for `Password must meet complexity requirements` set to Enabled, it Puppet would fail to create the user. Now it works appropriately.

**NOTE:** When the Windows Password Policy `Minimum password length` is greater than 0, the password must always be specified. This is due to Windows validation for new user creation requiring a password for all new accounts, so it is not possible to leave password unspecified once the policy is set.

It is also important to note that when a user is specified with `managehome => true`, the password must always be specified if it is not an already existing user on the system.


### Bug Fixes: Misc

* [PUP-5398: Fix regression that reintroduced file watching for directory environmnents](https://tickets.puppetlabs.com/browse/PUP-5398) A regression introduced in 3.7.5 would cause a directory based environment to reload if a file was changed, or cause a premature cache timeout if the `filetimeout` setting had a shorter time than the environment cache.
The regression could also cause performance degradation in general due to many calls to get status of files.
* [PUP-5380: Slow catalog run after updating to Puppet 3.7.5](https://tickets.puppetlabs.com/browse/PUP-5380)
* [PUP-5350: Puppet filter function does not behave consistently across all supported argument types.](https://tickets.puppetlabs.com/browse/PUP-5350) The `filter()` function did not behave according to specification when filtering a hash, as it did not enforce that only boolean true as a return from the lambda would include the element in the result. Instead, any "truthy" value was accepted. Now, only boolean true will include an element in the result.
* [PUP-5271: Windows user resource should not manage password unless specified](https://tickets.puppetlabs.com/browse/PUP-5271)
* [PUP-4495: Puppet 3.5.0 introduced a regression in tag filtering for catalog runs](https://tickets.puppetlabs.com/browse/PUP-4495) When filtering on the agent with a qualified tag having multiple name segments using commandline with --tag option, the given was processed by breaking the name a part as if multiple tags had been specified. This could lead to surprising results. Now, this regression is fixed, and the entire given tag is used as is when searching.



## Puppet 3.8.3

Released September 21, 2015.

Puppet 3.8.3 is a bug fix release in the Puppet 3.8 series. It fixes one significant regression and several miscellaneous bugs.

* [All fixes for Puppet 3.8.3](https://tickets.puppetlabs.com/issues/?filter=15509)
* [Introduced in Puppet 3.8.3](https://tickets.puppetlabs.com/issues/?filter=15510)

### Regression Fix: Warnings (Not Errors) for New Reserved Words

In Puppet 3.8.2, we reserved the new keywords `application`, `consumes`, and `produces` ([PUP-4941](https://tickets.puppetlabs.com/browse/PUP-4941)). For this version of Puppet, using these words as class names or unquoted strings was supposed to log a warning, but due to a bug, Puppet would raise an error and fail compilation instead.

This is now fixed, and the new keywords log warnings as intended.

* [PUP-5036: `--parser future` breaks `class application {}`](https://tickets.puppetlabs.com/browse/PUP-5036)

### Bug Fixes: Misc

* [PUP-3045: exec resource with timeout doesn't kill executed command that times out](https://tickets.puppetlabs.com/browse/PUP-3045) --- On POSIX systems, `exec` resources with a `timeout` value will now send a TERM signal if their command runs too long.
* [PUP-4639: Refreshing a LaunchDaemon leaves it disabled](https://tickets.puppetlabs.com/browse/PUP-4639) --- When refreshing a service on Mac OS X that was already running (via `notify`, `subscribe`, or `~>`), Puppet would stop the service and fail to start it.
* [PUP-5044: launchd enable/disable on OS X 10.10](https://tickets.puppetlabs.com/browse/PUP-5044) --- Enable/disable of services on El Capitan (10.10) wasn't working because the overrides plist moved. Puppet now knows where to find that plist on 10.10+.
* [PUP-5013: resource evaluation metrics are missing when not using an ENC](https://tickets.puppetlabs.com/browse/PUP-5013) --- Puppet Server's metrics for resource evaluation were very incomplete, because we were only tracking one of the several code paths that can evaluate resources. The metrics should be more complete now.
* [PUP-735: Status unchanged when "Could not apply complete catalog"](https://tickets.puppetlabs.com/browse/PUP-735) --- Previously, if a catalog had a dependency cycle (resource A depended on B which depended on A), then the run would fail with a cryptic error "Could not apply complete catalog", Puppet would exit with 0, and the report would omit metrics information about the failure. With this change, Puppet logs that a cycle was detected, exits with 1, and includes correct information about the failure in the report.

## Puppet 3.8.2

Released August 6, 2015.

Puppet 3.8.2 is a maintenance (bug fix) release to improve forward compatibility for users upgrading to the Puppet 4.x series.

* [All fixes for Puppet 3.8.2](https://tickets.puppetlabs.com/issues/?filter=15207)
* [Introduced in Puppet 3.8.2](https://tickets.puppetlabs.com/issues/?filter=15208)

### Deprecation: New Reserved Words

To prepare for new features in the 4.x series, the bare words 'application', 'consumes', and 'produces' have been made into reserved words when using the future parser. A warning is issued when they are used. These words should now be quoted if a string is wanted.

* [PUP-4941: Reserve keywords 'application', 'consumes', and 'produces'](https://tickets.puppetlabs.com/browse/PUP-4941)

### Security Update: Windows

We updated the version of OpenSSL in Windows packages to 1.0.0s to address recent CVEs.

* [PUP-5007: Put openssl 1.0.0s into Windows FOSS release (3.x)](https://tickets.puppetlabs.com/browse/PUP-5007)

### Performance Improvements

Optimized the future_parser checks by reducing the number of calls from once per copied resource attribute, to once per resource. This improvement affects all users irrespective of if running with parser = future or not.

* [PUP-4703: Optimize future_parser? checks for faster catalog production](https://tickets.puppetlabs.com/browse/PUP-4703)

When puppet forks (e.g. for a daemonized agent) it could leak file descriptors (with an fd > 255). It could also be slow. Both of those are addressed by this change.

* [PUP-4751: Optimize & Secure safe_posix_fork](https://tickets.puppetlabs.com/browse/PUP-4751)

### Bug Fixes: Future Parser

Along with performance improvements, this release addresses several bug fixes in the future parser.

* [PUP-4648: Problem of indentation with epp()](https://tickets.puppetlabs.com/browse/PUP-4648) - Trimming too much white space caused loss of expected indentations.
* [PUP-4662: EPP template can't explicitly access top scope variables if there's no node definition in the scope chain](https://tickets.puppetlabs.com/browse/PUP-4662)
* [PUP-4753: cannot call 4.x functions from 3.x function ERB templates](https://tickets.puppetlabs.com/browse/PUP-4753) - By adding a method to the scope named `call_function`, a user can agnostically call a 3.x or 4.x function. Arguments are given in an Array, and it accepts a ruby block (to enable calling 4.x iterative functions).
* [PUP-4789: hiera_include does not have access to variables from node scope when future parser is enabled](https://tickets.puppetlabs.com/browse/PUP-4789) - Instead of hiera_include, use include hiera_array('classes') as the problem is with the 'include' functionality inside of hiera_include.
* [PUP-4752: Uppercase letters in parameter variable names](https://tickets.puppetlabs.com/browse/PUP-4752) - More strict name verification of parameters, similar to Puppet 4.x.
* [PUP-4826: meaning of Integer[0] different in a ruby function](https://tickets.puppetlabs.com/browse/PUP-4826)
* [PUP-4848: Global parser = future with environment.conf parser = current gives an error](https://tickets.puppetlabs.com/browse/PUP-4848)
* [PUP-4668: cannot create a define named something that starts with 'class'](https://tickets.puppetlabs.com/browse/PUP-4668) - This can be worked around by giving the reference as a string instead of as a type.

### Bug Fixes: Resource Types and Providers

Since the password provider is only intended for use on BSD operating systems, it should use confine to prevent accidental activation on non-BSD systems. Linux was particularly susceptible to this, as there are no default providers declared for that platform.

* [PUP-4693: The pw provider for users and groups should be confined to freeBSD](https://tickets.puppetlabs.com/browse/PUP-4693)
* [PUP-3166: Debian service provider on docker with insserv (dep boot sequencing)](https://tickets.puppetlabs.com/browse/PUP-3166)

### Bug Fixes: Misc

* [PUP-4196: agent command line options ignored running under systemd](https://tickets.puppetlabs.com/browse/PUP-4196)

Having `{}` around variables in a systemd service file makes systemd treat it as a single argument, which breaks when used for something like `PUPPET_EXTRA_OPS` in the puppet agent and server systemd files. When passing more than one argument in using that variable, systemd would treat it as a single variable, which Puppet would ignore as invalid. Removing the `{}` from the variable addresses this issue. This was fixed in Puppet 4, and this ticket backported the fix to 3.x.

* [PUP-3088: Debug logging messages can't be used by providers with a "path" method](https://tickets.puppetlabs.com/browse/PUP-3088)
* [PUP-4665: Puppet::Parser::Scope has no inspect method which is causing an extremely large string to be produced](https://tickets.puppetlabs.com/browse/PUP-4665)
* [PUP-4810: Puppet caches parse results when environment_timeout is set to 0](https://tickets.puppetlabs.com/browse/PUP-4810)
* [PUP-4854: PMT fails to install modules on Windows that have long paths](https://tickets.puppetlabs.com/browse/PUP-4854)

PMT fails on long Windows paths - For modules that install on Windows and use a long hierarchical directory structure, the default TEMP path where PMT extracts the modules tarball can be problematic. Windows has a default maximum path length of 260 characters (MAX_PATH).

By default, the extracted temp location looks like:

~~~
C:\ProgramData\PuppetLabs\puppet\cache\puppet-module\cache\tmp-unpackerYYYYMMDD-XXXX-xxxxxxx
~~~

The default install location of a puppet 4.0+ module is:

~~~
C:\ProgramData\PuppetLabs\code\environments\production\modules
~~~

In using the Temp directory instead we allow for longer path names in the modules. Instead of using over 90 characters before the module path, we only use around 60, allowing for longer module paths during unpacking.


### Bug Fixes: HTTP API

* [PUP-4747: resource_types response has AST for parameters' default values](https://tickets.puppetlabs.com/browse/PUP-4747)


## Puppet 3.8.1

Released May 26, 2015.

Puppet 3.8.1 is a bug fix release (with future parser changes) in the Puppet 3.8 series. It's the first official open source release in the 3.8 series.

The main focus of this release is to make sure the 3.8 future parser is forward-compatible with the Puppet language as of Puppet 4.1. It also fixes several bugs.

### Bug Fixes: Major

The initial 3.8.0 release partially broke the per-environment `parser` setting added in 3.7.5, requiring some contortions to make per-environment parser changes work. This is now fixed.

* [PUP-4636: Manifest with future parser code fails in a non-production environment with environment.conf parser=future setting](https://tickets.puppetlabs.com/browse/PUP-4636)

### Improvements: Future Parser

This release improves the Puppet language with a new `\u{xxxxxx}` escape sequence for Unicode characters and a new NotUndef data type. It also adds a feature to the 4.x function API.

* [PUP-4438: Add required_repeated_param to 4.x function API](https://tickets.puppetlabs.com/browse/PUP-4438)
* [PUP-4483: Add NotUndef type to the set of Puppet types](https://tickets.puppetlabs.com/browse/PUP-4483)
* [PUP-4385: Can't write WOMANS HAT emoji with \uXXXX unicode escapes](https://tickets.puppetlabs.com/browse/PUP-4385)


### Bug Fixes: Future Parser

This release fixes several bugs with the Puppet language that were also fixed in Puppet 4.1.0.

* [PUP-4178: defined() function returns true for undef and empty string, and false for "main"](https://tickets.puppetlabs.com/browse/PUP-4178)
* [PUP-4374: Splatting attributes into an amended attribute block isn't supported](https://tickets.puppetlabs.com/browse/PUP-4374)
* [PUP-4398: Splat unfolding not supported in method call syntax](https://tickets.puppetlabs.com/browse/PUP-4398)
* [PUP-4428: The 'err' logging function cannot be called as a statement](https://tickets.puppetlabs.com/browse/PUP-4428)
* [PUP-4462: Single backslash before $ blocks interpolation in heredoc with no escapes enabled](https://tickets.puppetlabs.com/browse/PUP-4462)
* [PUP-4520: Future parser is not correctly handling the default case of a case statement](https://tickets.puppetlabs.com/browse/PUP-4520)


### Bug Fixes: Resource Types and Providers

* [PUP-3829: pip package provider is broken on EL (where osfamily is RedHat)](https://tickets.puppetlabs.com/browse/PUP-3829)
* [PUP-4604: Port fix for pip provider on more recent RedHat operating systems.](https://tickets.puppetlabs.com/browse/PUP-4604)

### Bug Fixes: Misc

* [PUP-4461: manifest changes are ignored when using hiera_include](https://tickets.puppetlabs.com/browse/PUP-4461)
* [PUP-4437: Update the "puppet-agent" Repo for 4.0.1 to Incorporate Fix for PUP-4390](https://tickets.puppetlabs.com/browse/PUP-4437)


## Puppet 3.8.0

Released April 28, 2015, as part of Puppet Enterprise 3.8.0. The first official open source release in the 3.8 series will be 3.8.1.

Puppet 3.8.0 is a backward-compatible features and fixes release in the Puppet 3 series.

### New Feature: Back-end Support for Upgrade Previews

This version includes several backend changes to support the PE-only compilation preview module.

* [PUP-4113: Migrate and Preview 3.8 Language to 4.0](https://tickets.puppetlabs.com/browse/PUP-4113)

### New Feature: Logging as JSON

In any of the Puppet subcommands that take the `--logdest` command line option, you can now specify a path to a JSON file and Puppet will log a (partial) JSON array of message objects to that file.

* [PUP-4201: Add support for structured logging](https://tickets.puppetlabs.com/browse/PUP-4201)
* [PUP-4336](https://tickets.puppetlabs.com/browse/PUP-4336) and [PUP-4341](https://tickets.puppetlabs.com/browse/PUP-4341) cover bugs in this feature that were fixed before release.


### Improvements: Resource Types and Providers

* [PUP-1628: Add mount provider for AIX](https://tickets.puppetlabs.com/browse/PUP-1628)
* [PUP-1291: scheduled_task : add support for "every X minutes or hours" mode](https://tickets.puppetlabs.com/browse/PUP-1291)


### Bug Fixes: Resource Types and Providers

#### Windows

* On Windows, the `group` resource type would ignore the `auth_membership` attribute and always treat the list of members as a complete list, removing any users not listed in that `group` resource. This was also fixed in Puppet 4.0.0. [PUP-4185: Backport ability to add a member to group to Puppet 3.8](https://tickets.puppetlabs.com/browse/PUP-4185)
* [PUP-1279: Windows Group and User fail during deletion even though it is successful](https://tickets.puppetlabs.com/browse/PUP-1279)
* [PUP-3653: Unable to create/force empty Windows groups](https://tickets.puppetlabs.com/browse/PUP-3653)
* [PUP-3804: User resource cannot add DOMAIN\User style accounts (through Active Directory) and should emit error message](https://tickets.puppetlabs.com/browse/PUP-3804)
* [PUP-4390: Regression: Windows service provider fails to retrieve current state on 2003](https://tickets.puppetlabs.com/browse/PUP-4390)
* Weekly `scheduled_task` resources were logging incorrect change notifications. This was also fixed in Puppet 4.0.0. [PUP-4186: Backport Weekly tasks always notify 'trigger changed' to Puppet 3.8](https://tickets.puppetlabs.com/browse/PUP-4186)

#### Other Operating Systems

* [PUP-4345: Port PUP-3388 "Issue Creating Multiple Mirrors in Zpool Resource" to PUP 3.8](https://tickets.puppetlabs.com/browse/PUP-4345)
* [PUP-4090: Zypper provider doesn't work correctly on SLES 10.4 with install_options set](https://tickets.puppetlabs.com/browse/PUP-4090)

### Improvements: Future Language

* [PUP-4277: Case and Selector match should be deep](https://tickets.puppetlabs.com/browse/PUP-4277)

### Bug Fixes: Future Language

* [PUP-4379: Future parser interpolation with [] after variable prefixed with underscore](https://tickets.puppetlabs.com/browse/PUP-4379)
* [PUP-4278: unless with else when then part is empty produces nil result (future parser)](https://tickets.puppetlabs.com/browse/PUP-4278)

### Bug Fixes: General

* [PUP-927: puppet apply on Windows always uses *nix style newlines from templates](https://tickets.puppetlabs.com/browse/PUP-927)
* [PUP-3863: hiera('some::key', undef) returns empty string](https://tickets.puppetlabs.com/browse/PUP-3863)
* [PUP-4334: hiera_include stopped working](https://tickets.puppetlabs.com/browse/PUP-4334)
* [PUP-4190: CLONE - Puppet device displays credentials in plain text when run manually](https://tickets.puppetlabs.com/browse/PUP-4190)
* [PUP-4187: Backport Puppet should execute ruby.exe not cmd.exe when running as a Windows to Puppet 3.8](https://tickets.puppetlabs.com/browse/PUP-4187)



