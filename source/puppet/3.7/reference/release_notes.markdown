---
layout: default
title: "Puppet 3.7 Release Notes"
description: "Puppet release notes for version 3.7"
canonical: "/puppet/latest/reference/release_notes.html"
---

[upgrade]: /guides/install_puppet/upgrading.html
[puppet_3]: /puppet/3/reference/release_notes.html
[puppet_35]: /puppet/3.5/reference/release_notes.html
[puppet_36]: /puppet/3.6/reference/release_notes.html

This page tells the history of the Puppet 3.7 series. (Elsewhere: release notes for [Puppet 3.0 -- 3.4][puppet_3], [Puppet 3.5][puppet_35], and [Puppet 3.6][puppet_36].)

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

If you're upgrading from a 3.x version of Puppet, you can usually just go for it. Upgrade your puppet master servers before upgrading the agents they serve. (But do look at the table of contents above and see if there are any "Upgrade Warning" notes for the new version.)

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.

Puppet 3.7.0
-----

Released September 2, 2014.

Puppet 3.7.0 is a backward-compatible features and fixes release in the Puppet 3 series. The biggest things in this release are:

TODO

### TODO Future Language Improvements

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


### TODO Future Language Removals

* [PUP-1057: Remove 'collect' and 'select' iterative function stubs](https://tickets.puppetlabs.com/browse/PUP-1057)
* [PUP-2858: remove --evaluator current switch for future parser](https://tickets.puppetlabs.com/browse/PUP-2858)

### TODO Type And Provider Apis

* [PUP-2458: Tests for providers inheriting from providers of another type](https://tickets.puppetlabs.com/browse/PUP-2458)
* [PUP-2298: PR (#2549) Enable pre-run validation of catalogs](https://tickets.puppetlabs.com/browse/PUP-2298)

### TODO Support For New C-Based Facter Implementation

cfacter blurb

* [PUP-2104: Make puppet able to configure a facter implementation to use](https://tickets.puppetlabs.com/browse/PUP-2104)


### Language Bug Fixes

We fixed a bug where the `contain` function misbehaved when given classes that start with a `::` prefix. We also made [resource collectors](./lang_collectors.html) give more informative errors if you try to collect classes (which isn't allowed).

* [PUP-1597: "contain" cannot contain a fully qualified class](https://tickets.puppetlabs.com/browse/PUP-1597)
* [PUP-2902: collection of classes should raise a meaningful error](https://tickets.puppetlabs.com/browse/PUP-2902)


### Feature: 64-Bit Support and Ruby 2.0 on Windows

We now ship both 32- and 64-bit Puppet installers for Windows! You should download the version that fits your systems' version of Windows.

> **Note:** Windows Server 2003 can't use our 64-bit installer, and must continue to use the 32-bit installer for all architectures. This is because 64-bit Ruby relies on OS features that weren't added until after Windows 2003.

Prior to this release, we only shipped 32-bit packages. Although these ran fine on 64-bit versions of Windows, they were subject to [file system redirection](/puppet/3.6/reference/lang_windows_file_paths.html), which could be surprising.

As part of this expanded Windows support, Puppet on Windows now uses Ruby 2.0.

* [PUP-389: Support ruby 2.0 x64 on windows](https://tickets.puppetlabs.com/browse/PUP-389)
* [PUP-2396: Support ruby 2.0 x64 on windows](https://tickets.puppetlabs.com/browse/PUP-2396)
* [PUP-2777: Support Bundler workflow on x64](https://tickets.puppetlabs.com/browse/PUP-2777)
* [PUP-3008: Already initialized constant warning when running puppet](https://tickets.puppetlabs.com/browse/PUP-3008)
* [PUP-3056: Restore constants / deprecated call sites changed during x64 upgrade that impact ACL module](https://tickets.puppetlabs.com/browse/PUP-3056)
* [PUP-2913: Remove RGen Gem in Puppet-Win32-Ruby libraries](https://tickets.puppetlabs.com/browse/PUP-2913)
* [PUP-390: Modify build process to generate x86 and x64 versions of ruby](https://tickets.puppetlabs.com/browse/PUP-390)
* [PUP-3006: Do not allow x64 to install on Windows Server 2003](https://tickets.puppetlabs.com/browse/PUP-3006)

### Packaging Bugs

We fixed a problem where a man page was being marked as a conflict.

* [PUP-2878: puppet-kick.8.gz conflict upgrading from 2.7.26 to 3.6.2](https://tickets.puppetlabs.com/browse/PUP-2878)


### TODO Deprecations

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




### Feature: Improved HTTP Debugging

Puppet has a new [`http_debug` setting](/references/3.7.latest/configuration.html#httpdebug) for troubleshooting Puppet's HTTPS connections. When set to `true` on an agent node, Puppet will log all HTTP requests and responses to stderr.

Use this only for temporary debugging (e.g. `puppet agent --test --http_debug`). It should never be enabled in production, because it can leak sensitive data to stderr. (Also because it's extremely noisy.)

### TODO Resource Type and Provider Improvements


#### Package

* [PUP-398: Backslashify windows paths when appropriate](https://tickets.puppetlabs.com/browse/PUP-398)
* [PUP-2014: Make gem provider match on a single gem name](https://tickets.puppetlabs.com/browse/PUP-2014)
* [PUP-2311: OpenBSD uninstall broken when multiple uninstall_options given](https://tickets.puppetlabs.com/browse/PUP-2311)
* [PUP-2944: yum provider should use osfamily instead of operatingsystem fact](https://tickets.puppetlabs.com/browse/PUP-2944)
* [PUP-2971: install_options are not passed to yum when listing packages](https://tickets.puppetlabs.com/browse/PUP-2971)
* [PUP-1069: Implement feature :upgradeable for OpenBSD package provider](https://tickets.puppetlabs.com/browse/PUP-1069)
* [PUP-2871: Add :install_options and :uninstall_options to the pacman provider](https://tickets.puppetlabs.com/browse/PUP-2871)

#### File

* [PUP-2583: mode attribute of file type doesn't behave like chmod when given X](https://tickets.puppetlabs.com/browse/PUP-2583)
* [PUP-2710: Audit of mtime/ctime for files on ext4 reports spurious changes (only ruby 1.9+)](https://tickets.puppetlabs.com/browse/PUP-2710)
* [PUP-2700: Puppet 3.6.1 File recurse improperly handles spaces in filenames](https://tickets.puppetlabs.com/browse/PUP-2700)
* [PUP-2946: FileUtils implementation broke compare_stream](https://tickets.puppetlabs.com/browse/PUP-2946)

#### Service

* [PUP-2879: `puppet resource service` not working for `cryptdisks-udev`](https://tickets.puppetlabs.com/browse/PUP-2879)
* [PUP-2578: Adjustments for new OpenBSD service provider](https://tickets.puppetlabs.com/browse/PUP-2578)

#### User

* [PUP-229: User provider password_max_age attribute is flawed under Solaris](https://tickets.puppetlabs.com/browse/PUP-229)
* [PUP-2737: user purge_ssh_keys cannot remove keys with spaces in the comment](https://tickets.puppetlabs.com/browse/PUP-2737)

#### SSHKey

* [PUP-1177: sshkey creates /etc/ssh/ssh_known_hosts with mode 600](https://tickets.puppetlabs.com/browse/PUP-1177)

#### Cron

* [PUP-1381: cron type and provider only return resources for ENV["USER"] or "root", not all users](https://tickets.puppetlabs.com/browse/PUP-1381)

#### Nagios

* [PUP-1527: After upgrade from 3.3.2-1 to 3.4.2-1 naginator fails to create config from exported resources taken from hiera](https://tickets.puppetlabs.com/browse/PUP-1527)

#### Resources

* [PUP-2031: unless_uid on user is completely broken wrt ranges](https://tickets.puppetlabs.com/browse/PUP-2031)
* [PUP-2866: Read UID_MIN from /etc/login.defs (if available) instead of hardcoding minimum.](https://tickets.puppetlabs.com/browse/PUP-2866)
* [PUP-2454: User ID's below 1000, not 500, are generally considered system users on OpenBSD](https://tickets.puppetlabs.com/browse/PUP-2454)

#### Yumrepo

* [PUP-2271: yumrepo attributes cannot be set to '_none_'](https://tickets.puppetlabs.com/browse/PUP-2271)
* [PUP-2360: Yumrepo type allows invalid values](https://tickets.puppetlabs.com/browse/PUP-2360)
* [PUP-2356: (PR 2577) Add yumrepo extra options](https://tickets.puppetlabs.com/browse/PUP-2356)

#### Mac OS X Group and Computer Providers

* [PUP-2577: Mac OS X version comparison fails spuriously](https://tickets.puppetlabs.com/browse/PUP-2577)

#### SSH Authorized Key

* [PUP-2579: ssh_authorized_key does not handle options with escaped double quotes](https://tickets.puppetlabs.com/browse/PUP-2579)

#### Zone

* [PUP-2817: Solaris Zone properties ip, dataset and inherit are not set upon zone creation](https://tickets.puppetlabs.com/browse/PUP-2817)

#### Scheduled Task

* [PUP-2818: Win32-taskscheduler gem 0.2.2 (patched in vendored repo) crashes when task scheduler is disabled](https://tickets.puppetlabs.com/browse/PUP-2818)



### Puppet Agent Bug Fixes

We fixed several issues with the Puppet agent application, including unwanted timeouts, some service bugs on Windows, some needlessly noisy log messages, and a bug involving the lockfile.

* [PUP-1070: puppetd doesn't always cleanup lockfile properly](https://tickets.puppetlabs.com/browse/PUP-1070)
* [PUP-1471: Puppet Agent windows services accidentally comes of out Paused state](https://tickets.puppetlabs.com/browse/PUP-1471)
* [PUP-2885: Periodic timeouts when reading from master](https://tickets.puppetlabs.com/browse/PUP-2885)
* [PUP-2907: Regression when pluginsyncing external facts on Windows](https://tickets.puppetlabs.com/browse/PUP-2907)
* [PUP-2952: Puppet should only log facts in debug mode](https://tickets.puppetlabs.com/browse/PUP-2952)
* [PUP-2987: Puppet service hangs when attempting to stop on Windows](https://tickets.puppetlabs.com/browse/PUP-2987)

### Puppet Master Bug Fixes

When running `puppet master --compile`, Puppet master used to ignore its `--logdest` option. Now it will log where you ask it to.

* [PUP-2873: puppet master --compile right now unconditionally spews logs to standard output](https://tickets.puppetlabs.com/browse/PUP-2873)


### TODO Puppet Module Command Improvements

The bug affecting module builds is resolved; no more workaround is required. You can now exclude files from your module build using either .gitignore or .pmtignore files. You can also use `--ignorechanges` flag to ignore any changes made to a module's metadata.json file when upgrading or uninstalling the module. And, finally, symlinks are no longer allowed in modules. The module build command will error on a module with symlinks.

* [PUP-1186: puppet module tool on windows will (sometimes) create a PaxHeader directory](https://tickets.puppetlabs.com/browse/PUP-1186)
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

#### Persistant Connections

The biggest performance win this time comes from using longer-lived persistent HTTPS connections for agent/master interactions. Depending on how many plugins you have and how many files you manage, Puppet agent can make 50-100 separate HTTPS per run, and the SSL handshakes can put stress on the master. By re-using connections, nearly all users should see a speed boost and improved capacity on the Puppet master.

You don't need to do anything to enable this; Puppet will re-use connections whenever it's acting as an HTTP client. You can configure the keepalive timeout on agent nodes with [the `http_keepalive_timeout` setting.](/references/3.7.latest/configuration.html#httpkeepalivetimeout)

#### Feature Caching on Puppet Masters

All users should now set `always_cache_features = true` in the `[master]` section of [puppet.conf][], which should get you a slight Puppet master performance win.

On agents, leaving this setting on `false` allows Puppet to use custom providers immediately after installing gems they require. ([Added in Puppet 3.6](/puppet/3.6/reference/release_notes.html#feature-installing-gems-for-a-custom-provider-during-puppet-runs)) On masters, the installed software doesn't change while a catalog is being compiled, so Puppet can skip the extra feature checks.

We've added this setting to our [list of recommended settings for Puppet master servers.](./config_important_settings.html#settings-for-puppet-master-servers)

#### Other

In other performance news, we made Puppet stop searching the disk in a situation where it didn't have to, made Puppet apply slightly faster when using the future parser, and made filebucket operations use less memory.

* [PUP-744: Persistent HTTP(S) connections](https://tickets.puppetlabs.com/browse/PUP-744)
* [PUP-2924: Puppet searches disk for whit classes](https://tickets.puppetlabs.com/browse/PUP-2924)
* [PUP-2860: Optimize startup of puppet apply (future parser)](https://tickets.puppetlabs.com/browse/PUP-2860)
* [PUP-3032: Setting to cache `load_library` failures](https://tickets.puppetlabs.com/browse/PUP-3032)
* [PUP-1044: FileBucket should not keep files in memory](https://tickets.puppetlabs.com/browse/PUP-1044)


### TODO Improvements to Directory Environments

* [PUP-2426: Puppet's v2 environment listing does not display config_version and environment_timeout as well.](https://tickets.puppetlabs.com/browse/PUP-2426)

* [PUP-2214: Many puppet commands fail when using a configured or requested directory environment that doesn't exist.](https://tickets.puppetlabs.com/browse/PUP-2214)
* [PUP-2519: Settings catalog should create the default environment if environmentpath set.](https://tickets.puppetlabs.com/browse/PUP-2519)
* [PUP-2631: Running the puppet agent against a nonexistent environment produces an overly verbose error message.](https://tickets.puppetlabs.com/browse/PUP-2631)
* [PUP-2711: The manifests directory should be recursively loaded when using directory environments](https://tickets.puppetlabs.com/browse/PUP-2711)
* [PUP-3069: Use a manifest setting in [master] as global manifests](https://tickets.puppetlabs.com/browse/PUP-3069)


### TODO Miscellaneous Bug Fixes

* [PUP-1100: create_resources auto importing a manifest with a syntax error produce a bad error message](https://tickets.puppetlabs.com/browse/PUP-1100)
* [PUP-2303: ArgumentErrors in file_server config parser are swallowed by raising the error wrong](https://tickets.puppetlabs.com/browse/PUP-2303)
* [PUP-2506: Error when evaluating #type in Puppet::Error message interpolation for Puppet::Resource::Ral](https://tickets.puppetlabs.com/browse/PUP-2506)
* [PUP-2622: Exit code 0 on wrong command](https://tickets.puppetlabs.com/browse/PUP-2622)
* [PUP-2831: Puppet does not work with RGen 0.7.0](https://tickets.puppetlabs.com/browse/PUP-2831)
* [PUP-2994: puppet parser validate shouldn't puke on exported resources](https://tickets.puppetlabs.com/browse/PUP-2994)
* [PUP-1843: 3.4.0 broke compatibility with plugins using the hiera indirector terminus](https://tickets.puppetlabs.com/browse/PUP-1843)

### TODO Miscellaneous Improvements

I don't know what the two profiling tickets do.

* [PUP-1736: Add encoding information to debug output](https://tickets.puppetlabs.com/browse/PUP-1736)
* [PUP-2626: Accept module paths in Puppet::Parser::Functions.file()](https://tickets.puppetlabs.com/browse/PUP-2626)
* [PUP-2511: Add parser function digest: uses digest_algorithm to hash, not strictly md5](https://tickets.puppetlabs.com/browse/PUP-2511)
* [PUP-2747: support multiple profilers](https://tickets.puppetlabs.com/browse/PUP-2747)
* [PUP-2750: expand profiler signature to support hierarchical profiling data](https://tickets.puppetlabs.com/browse/PUP-2750)

### TODO Security



* [PUP-2177: PR (2494) Insecure shipped Cipher settings in Passenger example config](https://tickets.puppetlabs.com/browse/PUP-2177)
* [PUP-2569: "puppet cert revoke <name>" doesn't always revoke what you expect](https://tickets.puppetlabs.com/browse/PUP-2569)
* [PUP-2869: Puppet should be able to use authenticated proxies](https://tickets.puppetlabs.com/browse/PUP-2869)
* [PUP-2511: Add parser function digest: uses digest_algorithm to hash, not strictly md5](https://tickets.puppetlabs.com/browse/PUP-2511)

### Improvements for Running Puppet From Source

Running Puppet with Bundler should now work more smoothly on platforms where `ruby-prof` isn't usable.

* [PUP-2842: Limit platforms on which Gemfile tries to install ruby-prof](https://tickets.puppetlabs.com/browse/PUP-2842)


### All Resolved Issues for 3.7.0

Our ticket tracker has the list of [all issues resolved in Puppet 3.7.0.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=11660)
