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

[puppet.conf]: ./config_file_main.html
[main manifest]: ./dirs_manifest.html
[env_api]: /references/3.7.latest/developer/file.http_environments.html
[file_system_redirect]: ./lang_windows_file_paths.html#file-system-redirection-when-running-32-bit-puppet-on-64-bit-windows
[environment.conf]: ./config_file_environment.html
[default_manifest]: /references/3.7.latest/configuration.html#defaultmanifest
[disable_per_environment_manifest]: /references/3.7.latest/configuration.html#disableperenvironmentmanifest

This page tells the history of the Puppet 3.7 series. (Elsewhere: release notes for [Puppet 3.0 -- 3.4][puppet_3], [Puppet 3.5][puppet_35], and [Puppet 3.6][puppet_36].)

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

Before upgrading, **look at the table of contents above and see if there are any "UPGRADE WARNING" or "Upgrade Note" items for the new version.** Although it's usually safe to upgrade from any 3.x version to any later 3.x version, there are sometimes special conditions that can cause trouble.

We always recommend that you **upgrade your puppet master servers before upgrading the agents they serve.**

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.

Puppet 3.7.0
-----

Released September 4, 2014.

Puppet 3.7.0 is a backward-compatible features and fixes release in the Puppet 3 series. The biggest things in this release are:

* A nearly-final implementation of the Puppet 4 language
* Preview support for a new, fast, natively compiled Facter
* 64-bit Puppet packages for Windows
* Lots of deprecations to prepare for Puppet 4.0

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

We now ship both 32- and 64-bit Puppet installers for Windows! When installing Puppet, you should download the package that matches your systems' version of Windows. If you installed Puppet into a custom directory, or if you need to downgrade, be sure to see the new notes in [the Windows installation page.](/guides/install_puppet/install_windows.html)

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
* [PUP-1884: Move puppet dependencies on windows into the puppet repo](https://tickets.puppetlabs.com/browse/PUP-1884)

### Feature: Early Support For New Compiled Facter Implementation

Puppet agent can now use preview builds of [the new, faster, natively compiled Facter,][cfacter] by setting `cfacter = true` in [puppet.conf][] or including `--cfacter` on the command line.

This is a very early version of this feature, and it's not for the faint of heart: since we don't provide builds of the compiled Facter project yet, you'll need to compile and package it yourself. To get started, [see the build and installation instructions in the cfacter repository.][cfacter]

[cfacter]: https://github.com/puppetlabs/cfacter

* [PUP-2104: Make puppet able to configure a facter implementation to use](https://tickets.puppetlabs.com/browse/PUP-2104)

### Feature: Agent-Side Pre-Run Resource Validation

Custom resource types now have a way to perform pre-run checks on an agent, and abort the catalog application before it starts if they detect something horribly wrong. Your resource types can do this by defining a `pre_run_check` method, which will run for every resource of that type and which should raise a `Puppet::Error` if the run should be aborted.

For details, see [the section on pre-run validation in the custom resource types guide][prerun].

[prerun]: /guides/custom_types.html#agent-side-pre-run-resource-validation-puppet-37-and-later

* [PUP-2298: PR (#2549) Enable pre-run validation of catalogs](https://tickets.puppetlabs.com/browse/PUP-2298)

### Feature: Improved HTTP Debugging

Puppet has a new [`http_debug` setting](/references/3.7.latest/configuration.html#httpdebug) for troubleshooting Puppet's HTTPS connections. When set to `true` on an agent node, Puppet will log all HTTP requests and responses to stderr.

Use this only for temporary debugging (e.g. `puppet agent --test --http_debug`). It should never be enabled in production, because it can leak sensitive data to stderr. (Also because it's extremely noisy.)

### Feature: Recursive Manifest Directory Loading Under Future Parser

When `parser = future` is set in [puppet.conf][], Puppet will recursively load any subdirectories in the [main manifest][]. This will be the default behavior in Puppet 4.

* [PUP-2711: The manifests directory should be recursively loaded when using directory environments](https://tickets.puppetlabs.com/browse/PUP-2711)

### Feature: Authenticated Proxy Servers

Puppet can now use proxy servers that require a username and password. You'll need to provide the authentication in the new [`http_proxy_user`](/references/3.7.latest/configuration.html#httpproxyuser) and [`http_proxy_password`](/references/3.7.latest/configuration.html#httpproxypassword) settings. (Note that passwords must be valid as part of a URL, and any reserved characters must be URL-encoded.)

* [PUP-2869: Puppet should be able to use authenticated proxies](https://tickets.puppetlabs.com/browse/PUP-2869)

### Feature: New `digest` Function

The [`md5` function](/references/3.7.latest/function.html#md5) is hardcoded to the (old, low-quality) MD5 hash algorithm, which is no good at sites that are prohibited from using MD5.

To help those users, Puppet now has a [`digest` function](/references/3.7.latest/function.html#digest), which uses whichever hash algorithm is specified in the Puppet master's [`digest_algorithm` setting.](/references/3.7.latest/configuration.html#digestalgorithm)

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

#### Persistent Connections

The biggest performance win this time comes from using longer-lived persistent HTTPS connections for agent/master interactions. Depending on how many plugins you have and how many files you manage, Puppet agent can make 50-100 separate HTTPS per run, and the SSL handshakes can put stress on the master. By re-using connections, nearly all users should see a speed boost and improved capacity on the Puppet master.

You don't need to do anything to enable this; Puppet will re-use connections whenever it's acting as an HTTP client. You can configure the keepalive timeout on agent nodes with [the `http_keepalive_timeout` setting.](/references/3.7.latest/configuration.html#httpkeepalivetimeout)

#### Feature Caching on Puppet Masters

All users should now set `always_cache_features = true` in the `[master]` section of [puppet.conf][], which should get you a slight Puppet master performance win.

On agents, leaving this setting on `false` allows Puppet to use custom providers immediately after installing gems they require. ([Added in Puppet 3.6](/puppet/3.6/reference/release_notes.html#feature-installing-gems-for-a-custom-provider-during-puppet-runs)) On masters, the installed software doesn't change while a catalog is being compiled, so Puppet can skip the extra feature checks.

We've added this setting to our [list of recommended settings for Puppet master servers.](./config_important_settings.html#settings-for-puppet-master-servers)

#### Other

In other performance news: Puppet no longer searches the disk in a situation where it didn't have to, `puppet apply` is slightly faster when using the future parser, and filebucket operations use less memory.

* [PUP-744: Persistent HTTP(S) connections](https://tickets.puppetlabs.com/browse/PUP-744)
* [PUP-2924: Puppet searches disk for whit classes](https://tickets.puppetlabs.com/browse/PUP-2924)
* [PUP-2860: Optimize startup of puppet apply (future parser)](https://tickets.puppetlabs.com/browse/PUP-2860)
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

* [PUP-2214: Many puppet commands fail when using a configured or requested directory environment that doesn't exist.](https://tickets.puppetlabs.com/browse/PUP-2214)
* [PUP-2426: Puppet's v2 environment listing does not display config_version and environment_timeout as well.](https://tickets.puppetlabs.com/browse/PUP-2426)
* [PUP-2519: Settings catalog should create the default environment if environmentpath set.](https://tickets.puppetlabs.com/browse/PUP-2519)
* [PUP-2631: Running the puppet agent against a nonexistent environment produces an overly verbose error message.](https://tickets.puppetlabs.com/browse/PUP-2631)


### Miscellaneous Bug Fixes

The `puppet` command now exits 1 when given an invalid subcommand, instead of exiting 0 as if everything were fine. We fixed some wrong or confusing error messages. The `puppet parser validate` command now handles exported resources just fine even if storeconfigs isn't configured (but only in the future parser). We fixed a bogus error message involving the `Uniquefile` API. And we fixed a regression from Puppet 3.4 that broke plugins using the `hiera` indirector terminus.

* [PUP-1100: create_resources auto importing a manifest with a syntax error produce a bad error message](https://tickets.puppetlabs.com/browse/PUP-1100)
* [PUP-2303: ArgumentErrors in file_server config parser are swallowed by raising the error wrong](https://tickets.puppetlabs.com/browse/PUP-2303)
* [PUP-2506: Error when evaluating #type in Puppet::Error message interpolation for Puppet::Resource::Ral](https://tickets.puppetlabs.com/browse/PUP-2506)
* [PUP-2622: Exit code 0 on wrong command](https://tickets.puppetlabs.com/browse/PUP-2622)
* [PUP-2831: Puppet does not work with RGen 0.7.0](https://tickets.puppetlabs.com/browse/PUP-2831)
* [PUP-2994: puppet parser validate shouldn't puke on exported resources](https://tickets.puppetlabs.com/browse/PUP-2994)
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

### Community Thank-Yous

Big thanks to our community members, who helped make this release what it is. In particular, we'd like to thank:

* [Daniel Berger](https://github.com/djberg96), whose Ruby modules have helped make Puppet on Windows a reality.
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
