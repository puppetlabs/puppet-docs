---
layout: default
title: "Puppet 3.5 Release Notes"
description: "Puppet release notes for version 3.5"
canonical: "/puppet/latest/reference/release_notes.html"
---

[environments_simple]: ./environments.html
[dirs_modulepath_simple_envs]: ./dirs_modulepath.html
[upgrade]: /puppet/3.8/reference/upgrading.html
[vars_trusted_hash]: ./lang_facts_and_builtin_vars.html#trusted-facts
[v2_api_yard]: ./yard/file.http_api_index.html
[puppet_3]: /puppet/3/reference/release_notes.html
[dynamic environments]: ./environments_classic.html#dynamic-environments
[blog_environments]: http://puppetlabs.com/blog/git-workflow-and-puppet-environments
[node definitions]: ./lang_node_definitions.html
[dirs_manifest]: ./dirs_manifest.html
[config_set]: ./config_set.html
[trusted_on]: ./config_important_settings.html#getting-new-features-early
[facts]: ./lang_facts_and_builtin_vars.html
[structured_facts_on]: ./config_important_settings.html#getting-new-features-early
[core_facts]: /facter/latest/core_facts.html
[future_parser]: ./experiments_future.html
[puppet_users]: https://groups.google.com/forum/#!forum/puppet-users
[external_facts]: /facter/latest/custom_facts.html#external-facts
[auto_import]: ./dirs_manifest.html


[future_heredoc]: http://puppet-on-the-edge.blogspot.se/2014/03/heredoc-is-here.html
[future_puppet_templates]: http://puppet-on-the-edge.blogspot.se/2014/03/templating-with-embedded-puppet.html


This page tells the history of the Puppet 3.5 series. (Elsewhere: [release notes for Puppet 3.0 -- 3.4][puppet_3])

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

If you're upgrading from a 3.x version of Puppet, you can usually just go for it. Upgrade your puppet master servers before upgrading the agents they serve. (But do look at the table of contents above and see if there are any "Upgrade Warning" notes for the new version.)

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.


Puppet 3.5.1
-----

Released April 16, 2014. (RC1: April 10.)

3.5.1 is a backward-compatible features and fixes release in the Puppet 3 series. It fixes the problems that 3.5.0 caused with dynamic environments and the yumrepo provider, as well as a couple of smaller bugs.

### Dynamic Environment Fixes

Puppet 3.5.0 introduced [directory environments][environments_simple], which provide a simpler alternative to the very powerful [dynamic environments][blog_environments] pattern. Unfortunately, the added functionality conflicted pretty badly with old-style dynamic environments.

This release changes the behavior of directory environments so that they have to be enabled by a feature flag (the `environmentpath` setting) before they can be used. To enable directory environments, you can set `environmentpath = $confdir/environments` in the `[main]` section of puppet.conf.

See the reference page for [directory environments][environments_simple] for more details.

Related issue:

* [PUP-2158: Directory Environments breaks many classic Config File Environments](https://tickets.puppetlabs.com/browse/PUP-2158)

### Yumrepo Fixes

Puppet 3.5.0 included some changes to the [yumrepo resource type][yumrepo] that inadvertently broke existing configurations. This release fixes the following issues:

* [PUP-2150: yumrepo removable URL properties cannot be set to 'absent' in Puppet 3.5.0](https://tickets.puppetlabs.com/browse/PUP-2150)
* [PUP-2162: yumrepo gpgkey and baseurl with multiple URLs broken in 3.5.0](https://tickets.puppetlabs.com/browse/PUP-2162)
* [PUP-2163: yumrepo resource completely broken with 3.5 release](https://tickets.puppetlabs.com/browse/PUP-2163)
* [PUP-2178: yumrepo 'descr' property doesn't map to the 'name' INI property](https://tickets.puppetlabs.com/browse/PUP-2178)
* [PUP-2179: Ensuring absent on a yumrepo removes all repos in the same file](https://tickets.puppetlabs.com/browse/PUP-2179)
* [PUP-2181: Setting yumrepo string properties to absent assigns the literal 'absent' string](https://tickets.puppetlabs.com/browse/PUP-2181)

### Other Fixes

* [PUP-1991: Usernames > 13 characters may not resolve properly from their SID on Windows](https://tickets.puppetlabs.com/browse/PUP-1991)
* [PUP-2129: Evaluation error while evaluating a Virtual Query (future parser)](https://tickets.puppetlabs.com/browse/PUP-2129)

Puppet 3.5.0
-----

Released April 3, 2014. (RC1: March 14. RC2: March 24. RC3: March 31.)

3.5.0 is a backward-compatible features and fixes release in the Puppet 3 series. The biggest things in this release are:

* A new way to set up environments, which replaces the popular "dynamic environments" pattern
* A cleaner replacement for the classic `import nodes/*.pp` pattern
* Scriptable configuration with a new `puppet config set` command
* A new global `$facts` hash
* Early support for hashes and arrays in fact values
* Improvements to the future parser
* Support for RHEL 7, Ruby 2.1, and Facter 2.0

...along with many smaller improvements and bug fixes.

### RECALLED on April 4, 2014

When 3.5.0 went final, users found breaking issues with the `yumrepo` resource type and with dynamic environments which hadn't been uncovered in the release candidate period. (See the "UPGRADE WARNING" headers below.)

We decided these issues were annoying enough to cause a bad user experience, so:

* We have pulled 3.5.0 from public repositories.
* We recommend that users who _have_ upgraded revert to Puppet 3.4.3 until we can address these issues.

Sorry about the inconvenience, and we'll be issuing a 3.5.1 bugfix release very soon.

### UPGRADE WARNING: Bugs With Old-Style Dynamic Environments

If you use [dynamic environments][] --- that is, if your puppet.conf file references the `$environment` variable --- either wait for 3.5.1 or temporarily set the following in the `[main]` or `[master]` section of your puppet master's puppet.conf:

    environmentpath = $confdir/no_environments_here

If you just upgrade without doing that, your setup might break.

In more detail:

Most people who use dynamic environments put their environment data in `$confdir/environments`. This also happens to be the default home for the new-style [directory environments][environments_simple], and Puppet will attempt to use your existing environments with the new conventions.

Unfortunately, there are some problems if your dynamic environments don't work exactly like directory environments. [PUP-2158](https://tickets.puppetlabs.com/browse/PUP-2158) is the master ticket for working on these. A few of the more frustrating ones:

- If your environments only include a `modules` directory and don't reliably include a [main mainfest][dirs_manifest], Puppet won't fall back to your global main manifest; it'll act like the main manifest is empty.
- If your modulepath includes any directories other than `$confdir/modules` and `$confdir/environments/$environment/modules`, they won't get used.

We want dynamic environment users to be able to transition smoothly, so we consider these to be bugs. We're working on fixing them for 3.5.1. In the meantime, you have two options if you use dynamic environments and want to run 3.5.0:

- Tell Puppet not to treat your dynamic environments like directory environments, by pointing [the `environmentpath` setting][env_path] at a dummy directory. Things will now work like they always did. (At some point you'll want to reverse that, so make a note to yourself in the config file comments.)
- Switch over to directory environments completely. You'll need to add a `manifests` directory to each environment, and you may want to set the `basemodulepath` setting. See [the page on directory environments][environments_simple] for more details.

[env_path]: ./environments.html#the-environmentpath

### UPGRADE WARNING: Bad Yumrepo Bugs

If you use the `yumrepo` type, don't upgrade quite yet; wait for 3.5.1. If you already upgraded, you may need to downgrade to the latest 3.4 release.

We refactored the [yumrepo resource type][yumrepo] as part of this release, in order to improve the code quality, fix a few minor issues, and make it easier to fix future issues.

Unfortunately, this introduced new bugs, which break existing configurations. Our users discovered these after 3.5.0 went final:

* [PUP-2162](https://tickets.puppetlabs.com/browse/PUP-2162) --- If `baseurl` or `gpgkey` use multiple URLs, the resource will fail.
* [PUP-2150](https://tickets.puppetlabs.com/browse/PUP-2150) --- Setting attributes like `baseurl => absent` to suppress settings in the generated repo file is broken.

Sorry for the annoyance! We have fixes that will go into Puppet 3.5.1.

[yumrepo]: ./type.html#yumrepo

### Directory Environments

Lots of people have been using dynamic environments based on VCS checkouts to test and roll out their Puppet code, [as described in this classic blog post][blog_environments]. That pattern is great, but it's complicated to set up and it pretty much works by accident, so we wanted a better way to support it.

Now we have one! The new feature is called **directory environments,** to distinguish them from the older environments that had to be set in the config file.

The short version is:

* Create a `$confdir/environments` directory on your puppet master.
* Each new environment is a subdirectory of that directory. The name of the directory will become the name of the environment.
* Each environment dir contains a `modules` directory and a `manifests` directory.
    * The `modules` directory will become the first directory in the modulepath (with the new `basemodulepath` setting providing a global list of other directories to use).
    * The `manifests` directory will be used as the `manifest` setting (see "Auto-Import" below).
* No other configuration is needed. Puppet will automatically discover new environments.

The upshot is that you can do a `git clone` or `git-new-workdir` in your `environments` directory, and nodes can immediately start requesting catalogs in that environment.

This feature isn't _quite_ finished yet: it's missing the ability to do complex edits to the `modulepath` or set the `config_version` setting per-environment, which didn't make the release deadline. However, it should already be good enough for most users.

For full details, see:

* [The reference page about directory environments][environments_simple]
* [The reference page about the modulepath][dirs_modulepath_simple_envs]

Related issues:

- [PUP-1574: Using new directory environments with puppet apply prevents evaluation of the manifest requested on the commandline.](https://tickets.puppetlabs.com/browse/PUP-1574)
- [PUP-1584: Puppet module tool should work with new directory environments](https://tickets.puppetlabs.com/browse/PUP-1584)
- [PUP-536: Create endpoint for enumerating environments](https://tickets.puppetlabs.com/browse/PUP-536)
- [PUP-1551: Change from "environmentdir" to "environmentpath"](https://tickets.puppetlabs.com/browse/PUP-1551)
- [PUP-1118: Support an $environmentsdir setting](https://tickets.puppetlabs.com/browse/PUP-1118)
- [PUP-1151: List information for known environments via REST](https://tickets.puppetlabs.com/browse/PUP-1151)
- [PUP-1676: Puppet config print respects legacy but not directory environments](https://tickets.puppetlabs.com/browse/PUP-1676)
- [PUP-1678: Environment Endpoint should show configuration and not all modules](https://tickets.puppetlabs.com/browse/PUP-1678)
- [PUP-1735: Puppet::Node::Environment.current should reroute with deprecation warning](https://tickets.puppetlabs.com/browse/PUP-1735)


### Auto-Import (Use a Directory as Main Manifest)

You can now set the `manifest` setting to a **directory** instead of a single file. (E.g. `manifest = $confdir/manifests`) If you do, the puppet master will parse every `.pp` file in that directory in alphabetical order (without descending into subdirectories) and use the whole set as the site manifest. Similarly, you can give puppet apply a directory as its argument, and it'll do the same thing.

We did this because:

* `import` is horrible...
* ...but the `import nodes/*.pp` pattern is good.

Lots of people like to use [node definitions][] and keep every node in a separate file. In Puppet 3.4 and earlier, this meant putting an `import` statement in puppet.conf and storing the node files in another directory. Now, you can just put all your nodes in the main manifest dir and point the `manifest` setting at it.

And since this was the last real reason to use `import`, we can deprecate it now! (See "Deprecations and Removals" below.)

[See the page about the manifest directory for more details.][dirs_manifest]

Related issues:

- [PUP-865: Provide a manifest directory where all manifests are automatically parsed.](https://tickets.puppetlabs.com/browse/PUP-865)

### Scriptable Configuration (`puppet config set`)

You can now change Puppet's settings without parsing the config file, using the `puppet config set` command. This is mostly useful for configuring Puppet as part of your provisioning process, but can be convenient for one-off changes as well. For details, [see the page about changing settings on the command line.][config_set]

Related issues:

- [PUP-663: Set an entry in puppet.conf](https://tickets.puppetlabs.com/browse/PUP-663)
- [PUP-665: Select a section](https://tickets.puppetlabs.com/browse/PUP-665)

### Global `$facts` Hash

You have to manually enable this (along with the `$trusted` hash) by [setting `trusted_node_data = true` in puppet.conf][trusted_on] on your puppet master(s). It'll be on by default in Puppet 4.

In addition to using `$fact_name`, you can now use `$facts[fact_name]` to get a [fact][facts] value. The `$facts` hash is protected and can't be overridden locally, so you won't need the `$::` idiom when using this.

Our hope is that this will visibly distinguish facts from normal variables, make Puppet code more readable, and eventually clean up the global variable namespace. (That'll take a while, though --- we probably won't be able to disable `$fact_name` until, like, Puppet 5.)

Related issues:

- [PUP-542: Provide access to all facts in a single structure](https://tickets.puppetlabs.com/browse/PUP-542)

### Structured Facts (Early Version)

You have to manually enable this by [setting `stringify_facts = false` in puppet.conf][structured_facts_on] on your puppet agents. It'll be enabled by default in Puppet 4.

In Facter 2.0 and later, fact values can be any data type, including hashes, arrays, and booleans. (This is a change from Facter 1.7, where facts could only be strings.) If you enable structured facts in Puppet, you can do more cool stuff in your manifests and templates with any facts that use this new feature.

These are the early days of structured facts support --- they work in Puppet and Facter now, but none of the [built-in facts][core_facts] use data structures yet, and external systems like PuppetDB haven't yet been updated to take advantage of them. (Any structured facts will still get smooshed into strings when they're sent to PuppetDB.) But if you have a use for hashes or arrays in your custom facts, turn this on and give it a try.


### Future Parser is Faster and Better

We think [the future parser][future_parser] is fast enough to use in a large environment now --- we haven't done extensive benchmarking with real-life manifests, but the testing we've done suggests it's about on par with the default parser. So if you've been waiting to try it out, give it a spin and [let us know how it goes][puppet_users].

It also has some new tricks in this release:

* HEREDOCs are now allowed! This is a much more convenient way to handle large strings. [See here for details.][future_heredoc]
* A new template language was added, based on the Puppet language instead of on Ruby. [See here for details.][future_puppet_templates]
* There's a new "future" evaluator that goes along with the future parser.

Related issues:

- [PUP-490: Remove partially implemented support for 'import'](https://tickets.puppetlabs.com/browse/PUP-490)
- [PUP-527: Validate collect expressions (future parser)](https://tickets.puppetlabs.com/browse/PUP-527)
- [PUP-798: New Evaluator does not cache parse results](https://tickets.puppetlabs.com/browse/PUP-798)
- [PUP-800: Complete implementation of Location handling](https://tickets.puppetlabs.com/browse/PUP-800)
- [PUP-939: add support for enumerable type(s) in all iterative functions](https://tickets.puppetlabs.com/browse/PUP-939)
- [PUP-954: Correct Type System Flaws](https://tickets.puppetlabs.com/browse/PUP-954)
- [PUP-992: Relationship expression artificially denies arrays as operands](https://tickets.puppetlabs.com/browse/PUP-992)
- [PUP-994: Future evaluator should unique relationship operands](https://tickets.puppetlabs.com/browse/PUP-994)
- [PUP-1029: filter function should accept two parameters](https://tickets.puppetlabs.com/browse/PUP-1029)
- [PUP-1176: Add feature switch for evaluator](https://tickets.puppetlabs.com/browse/PUP-1176)
- [PUP-1212: runtime errors in future evaluator has uninformative backtrace](https://tickets.puppetlabs.com/browse/PUP-1212)
- [PUP-1234: each function broken after upgrading to 3.4](https://tickets.puppetlabs.com/browse/PUP-1234)
- [PUP-1247: Enabling --parser future causes classes to be not found and other errors](https://tickets.puppetlabs.com/browse/PUP-1247)
- [PUP-1579: Rename Literal Type to Scalar](https://tickets.puppetlabs.com/browse/PUP-1579)
- [PUP-486: Add subtype of String](https://tickets.puppetlabs.com/browse/PUP-486)
- [PUP-491: Implement a 4x validator](https://tickets.puppetlabs.com/browse/PUP-491)
- [PUP-502: Implement evaluation of 'definitions'](https://tickets.puppetlabs.com/browse/PUP-502)
- [PUP-792: Merge Feature Branch New Evaluator](https://tickets.puppetlabs.com/browse/PUP-792)
- [PUP-1619: Add Tuple and Struct types to the type system](https://tickets.puppetlabs.com/browse/PUP-1619)
- [PUP-644: PR (2020): (#21873) Make `name[x]` different from `name [x]` - hlindberg](https://tickets.puppetlabs.com/browse/PUP-644)
- [PUP-910: 3x functions do not know how to handle new data types](https://tickets.puppetlabs.com/browse/PUP-910)
- [PUP-979: future parser fails to recognize hash as parameter in un-parenthesized calls](https://tickets.puppetlabs.com/browse/PUP-979)
- [PUP-1220: dynamic variable lookup works in templates](https://tickets.puppetlabs.com/browse/PUP-1220)
- [PUP-1576: New Parser does not handle hyphenated barewords](https://tickets.puppetlabs.com/browse/PUP-1576)
- [PUP-1814: Double backslashes in single quote strings should be interpreted as single](https://tickets.puppetlabs.com/browse/PUP-1814)
- [PUP-1897: EPP ignores code after parameter declaration](https://tickets.puppetlabs.com/browse/PUP-1897)
- [PUP-1898: EPP - Error when trying to report argument error in inline_epp](https://tickets.puppetlabs.com/browse/PUP-1898)
- [PUP-28: Add heredoc support in future parser](https://tickets.puppetlabs.com/browse/PUP-28)
- [PUP-30: Support Puppet Templates](https://tickets.puppetlabs.com/browse/PUP-30)
- [PUP-473: Add support for \u for unicode chars in strings](https://tickets.puppetlabs.com/browse/PUP-473)
- [PUP-479: Handle types other than string as hash key](https://tickets.puppetlabs.com/browse/PUP-479)
- [PUP-482: Handle Comparisons / Equality a consistent way](https://tickets.puppetlabs.com/browse/PUP-482)
- [PUP-483: Handle Match in useful and consistent way](https://tickets.puppetlabs.com/browse/PUP-483)
- [PUP-487: Decide on 'in' operator vs. '=='](https://tickets.puppetlabs.com/browse/PUP-487)
- [PUP-489: Handle += / -= with consistent semantics](https://tickets.puppetlabs.com/browse/PUP-489)
- [PUP-525: Support Regular Expression as data type (an issue of encoding)](https://tickets.puppetlabs.com/browse/PUP-525)
- [PUP-1895: EPP - Define parameters with `<% |$x| %>` instead of `<% ($x) %>`](https://tickets.puppetlabs.com/browse/PUP-1895)

### Platform Support Updates

Newly supported:

* Puppet now supports RHEL 7, with packages and acceptance testing. This mostly involved cleaning up resource providers to handle things like systemd more cleanly.
* We're running acceptance tests on Fedora 19 and 20, now, too.
* Facter 2.0.1 works with Puppet 3.5, including its new structured facts support (see above).
* We have _early_ support for Ruby 2.1. We're running spec tests on it, so we think it works fine! But since none of our testing platforms ship with it, we aren't running acceptance tests on it, which means there might be problems we don't know about yet.

Newly abandoned:

* Support for Fedora 18 is done, since it EOL-ed in January; no more acceptance tests or packages.
* Facter 1.6 is no longer supported with Puppet 3.5.

Related issues:

- [PUP-576: Add a fedora19 host to the platforms we are testing in ci.](https://tickets.puppetlabs.com/browse/PUP-576)
- [PUP-876: upstart service operating system confine should include redhat and centos](https://tickets.puppetlabs.com/browse/PUP-876)
- [PUP-923: Add Fedora 20 to acceptance](https://tickets.puppetlabs.com/browse/PUP-923)
- [PUP-1694: Provide packages for Rhel7](https://tickets.puppetlabs.com/browse/PUP-1694)
- [PUP-1825: Allow use of Facter 2](https://tickets.puppetlabs.com/browse/PUP-1825)
- [PUP-1463: Ensure services that were previously enabled get enabled after systemd service unit name change](https://tickets.puppetlabs.com/browse/PUP-1463)
- [PUP-1491: (packaging)Remove Fedora 18 from default mocks](https://tickets.puppetlabs.com/browse/PUP-1491)
- [PUP-1821: Bump facter dependency to 1.7 or greater](https://tickets.puppetlabs.com/browse/PUP-1821)
- [PUP-1732: 'puppet resource service' with systemd provider shows lots of non-services](https://tickets.puppetlabs.com/browse/PUP-1732)
- [PUP-1766: Make systemd the default provider for RHEL7](https://tickets.puppetlabs.com/browse/PUP-1766)

### Smaller New Features

In addition to the big-ticket improvements above, we added a lot of smaller features.

Misc features:

* You can now put [external facts][external_facts] in modules, and they will be synced to all agent nodes. This requires Facter 2.0.1 or later. To use this feature, put your external facts in a `facts.d` directory, which should exist at the top level of the module.
* Certificate extensions will now appear in [the `$trusted` hash.][vars_trusted_hash]
* There's a new `strict_variables` setting; if set to true, it will throw parse errors when accessing undeclared variables. Right now, this will wreak havoc; eventually, it will make Puppet code easier to debug.
* Related to the last: The `defined` function can now test whether a variable is defined. Note that you have to _single-quote_ the variable name, like this: `defined('$my_var')` --- otherwise, the function will receive the _value_ of the variable instead of its _name._ Anyway, going forward, this will be a more accurate way to distinguish between `false`, `undef`, and uninitialized variables, especially if you're using `strict_variables = true`.
* The `http` report processor can use basic auth now when forwarding reports.
* Puppet apply now has a `--test` option that acts much like puppet agent's `--test`.
* On Windows, the puppet agent service will now log activity using the Windows Event Log instead of a logfile.
* Environment and transaction UUID information is now included when submitting facts to PuppetDB. (This will be used in a future version of PuppetDB.)

Type and provider features:

* The `ssh_authorized_key` type can use ssh-ed25519 keys now.
* When `service` resources fail to start or restart, they'll log the exit code, stdin, and stderr text as Puppet errors to help with debugging.
* The `rpm` package provider now accepts virtual packages.
* The `rpm` package provider now supports `uninstall_options`.
* The `package` type has a new `package_settings` attribute. This is a property that can be implemented differently per-provider; currently nothing uses it, but there are plans to make the FreeBSD provider use it for port options.
* The `user` type now validates the `shell` attribute, to make sure it actually exists and is executable.
* You can now use msgpack as the on-disk cache format for some of Puppet's generated data types.
* The `file` type has a new `validate_cmd` attribute that can help protect against accidentally writing broken config files.
* The `resources` type has a new `unless_uid` attribute that acts like an improved version of the `unless_system_user` attribute --- it lets you protect multiple UIDs and ranges of UIDs from deletion when purging `user` resources.
* You can now purge unmanaged `cron` resources with the `resources` type.

Features for extension writers:

* The Puppet::Util::Profiler#profile API is now public, and can be used by extensions like indirector termini and report handlers.
* There's a new v2.0 HTTP API, which doesn't have to abide by the (sometimes inconsistent and weird) semantics of the main API. Right now, the only v2.0 endpoint is for getting information about environments via the API. See [the developer documentation][v2_api_yard] for details.


Related issues:

- [PUP-1975: Environment & transaction_uuid is not passed to facts indirector during compilation](https://tickets.puppetlabs.com/browse/PUP-1975)
- [PUP-1068: Puppet master can't submit reports to an HTTP server using basic auth](https://tickets.puppetlabs.com/browse/PUP-1068)
- [PUP-1218: Improve ssh-ed25519 integration](https://tickets.puppetlabs.com/browse/PUP-1218)
- [PUP-1219: PR (2182): Improve ssh-ed25519 integration - jasperla](https://tickets.puppetlabs.com/browse/PUP-1219)
- [PUP-950: PR (2132): (#23376) Add support for ssh-ed25519 keys to ssh_authorized_key type - jasperla](https://tickets.puppetlabs.com/browse/PUP-950)
- [PUP-1318: Provide a logoutput for service like exec](https://tickets.puppetlabs.com/browse/PUP-1318)
- [PUP-897: package type should accept virtual package for rpm](https://tickets.puppetlabs.com/browse/PUP-897)
- [PUP-1369: Package options property for package](https://tickets.puppetlabs.com/browse/PUP-1369)
- [PUP-1448: User's type 'shell' parameter should be validated](https://tickets.puppetlabs.com/browse/PUP-1448)
- [PUP-1327: PR (2060) owner of files created by nagios resource types](https://tickets.puppetlabs.com/browse/PUP-1327)
- [PUP-1589: PR (2328): Msgpack terminii - dalen](https://tickets.puppetlabs.com/browse/PUP-1589)
- [PUP-1670: PR (2347): A way to validate file content syntax before replacing files](https://tickets.puppetlabs.com/browse/PUP-1670)
- [PUP-1447: Allow specified UIDs to be excluded from purge](https://tickets.puppetlabs.com/browse/PUP-1447)
- [PUP-1490: Support --test option for puppet apply](https://tickets.puppetlabs.com/browse/PUP-1490)
- [PUP-1564: PR (2319) package rpm provider should support :uninstall_options feature](https://tickets.puppetlabs.com/browse/PUP-1564)
- [PUP-649: PR (2024): (#3220) crontab: allow purging unmanaged resources - ffrank](https://tickets.puppetlabs.com/browse/PUP-649)
- [PUP-1772: Proposal to make Puppet::Util::Profiler#profile api public](https://tickets.puppetlabs.com/browse/PUP-1772)
- [PUP-672: Informational certificate extensions should be exposed inside the Puppet DSL](https://tickets.puppetlabs.com/browse/PUP-672)
- [PUP-1048: PR (2161): (#21641) Windows puppet service should log to the eventlog - glennsarti](https://tickets.puppetlabs.com/browse/PUP-1048)
- [PUP-1505: Puppet should use new Facter.search_external for external facts pluginsync](https://tickets.puppetlabs.com/browse/PUP-1505)
- [PUP-1432: Implement v2.0 API error responses](https://tickets.puppetlabs.com/browse/PUP-1432)
- [PUP-1549: V2.0 API shows the message body in the Reason-Phrase](https://tickets.puppetlabs.com/browse/PUP-1549)
- [PUP-1166: Add better error message for strict variables (current parser)](https://tickets.puppetlabs.com/browse/PUP-1166)
- [PUP-1372: with strict variable lookup option there is no way to check if var is defined](https://tickets.puppetlabs.com/browse/PUP-1372)

### Deprecations and Removals

As we start to get ready for Puppet 4, we're deprecating some features we're hoping to remove or replace. (Be ready for more of these in Puppet 3.6, too.) Using deprecated features will cause warnings to be logged on the puppet master; these features will be removed in Puppet 4.

Deprecations in the Puppet language:

* The `import` keyword is deprecated. Instead of importing, you should [set your `manifest` setting to a directory of .pp files][auto_import].
* Modifying arrays and hashes in Puppet code or templates is deprecated. (This actually should never have been possible, but we can't kill it in a minor version because it might break something.)

Deprecations in the type and provider API:

* Using the `:parent` option when creating a type is deprecated. This actually hasn't worked for a long while, but now it will warn you that it won't do anything.

Removals:

* The experimental bindings-based Hiera2/data-in-modules code has been removed. We're back to the drawing board on this.

Related issues:

- [PUP-899: Deprecate parent parameter for type](https://tickets.puppetlabs.com/browse/PUP-899)
- [PUP-864: Deprecate Data Structure Mutation](https://tickets.puppetlabs.com/browse/PUP-864)
- [PUP-866: Deprecate "import"](https://tickets.puppetlabs.com/browse/PUP-866)
- [PUP-546: Remove Hiera2 and bindings-based data in modules code](https://tickets.puppetlabs.com/browse/PUP-546)

### Performance Improvements

3.5 is faster! We found a situation where defined types were a lot slower than they needed to be, some slow cases in `puppet cert list` and the module tool, and a few other performance wins.

Related issues:

- [PUP-716: Puppet::FileSystem::File creates many short-lived objects](https://tickets.puppetlabs.com/browse/PUP-716)
- [PUP-751: Performance regression due to excessive file watching](https://tickets.puppetlabs.com/browse/PUP-751)
- [PUP-753: Create a reasonable "benchmark" manifest](https://tickets.puppetlabs.com/browse/PUP-753)
- [PUP-1059: PR (2162): (#16570) Don't load the node object again in configurer - dalen](https://tickets.puppetlabs.com/browse/PUP-1059)
- [PUP-1592: Puppet excessively stats the filesystem when looking for defined types](https://tickets.puppetlabs.com/browse/PUP-1592)
- [PUP-1563: PR (2322) Module tool rechecks for conflicts for each installed module](https://tickets.puppetlabs.com/browse/PUP-1563)
- [PUP-1665: PR - Puppet cert list behavior is suboptimal](https://tickets.puppetlabs.com/browse/PUP-1665)
- [PUP-1058: puppet apply loading facts twice](https://tickets.puppetlabs.com/browse/PUP-1058)

### Bug Fixes and Clean-Ups

We fixed a bunch of bugs in types and providers (including a big cleanup of the [yumrepo type][yumrepo]), improved standards-compliance in our use of certificates, fixed a bunch of Windows-specific problems, cleaned up some inconsistencies, and fixed some bugs that don't fit in any particular bucket.

Type and provider bugs:

- [PUP-1210: authentication_authority key is not set when managing root's password using the puppet user provider](https://tickets.puppetlabs.com/browse/PUP-1210) (An OS X bug, most visible when managing the root user.)
- [PUP-1051: gem package provider is confused by platform components in version strings](https://tickets.puppetlabs.com/browse/PUP-1051)
- [PUP-1158: Augeas provider warns on parse errors in other files handled by same lens](https://tickets.puppetlabs.com/browse/PUP-1158)
- [PUP-1421: appdmg prematurely filters for sources ending in .dmg](https://tickets.puppetlabs.com/browse/PUP-1421)
- [PUP-1450: [Windows] Copying file resources from non-NTFS volumes causes Invalid DACL errors](https://tickets.puppetlabs.com/browse/PUP-1450)
- [PUP-1559: Windows - Specifying well-known SIDs as a group / user in manifests causes errors](https://tickets.puppetlabs.com/browse/PUP-1559)
- [PUP-730: PR (2140): (#23141) Add OpenBSD to the exclusion list for 'remounts' in mount type - jasperla](https://tickets.puppetlabs.com/browse/PUP-730)
- [PUP-1192: PR (2176): (maint) Windows file provider :links => :follow - Iristyle](https://tickets.puppetlabs.com/browse/PUP-1192)
- [PUP-1561: puppet resource cron does not list crontab entries](https://tickets.puppetlabs.com/browse/PUP-1561)
- [PUP-713: PR (2050): (#4820) cron type should not allow specification of special parameter and normal hour/minute/day/etc parameters. - ffrank](https://tickets.puppetlabs.com/browse/PUP-713)
- [PUP-1085: Pacman provider constantly reinstalls package groups on arch linux](https://tickets.puppetlabs.com/browse/PUP-1085)
- [PUP-648: PR (2023): Add upgradeable and versionable features to pkgin provider - javiplx](https://tickets.puppetlabs.com/browse/PUP-648)
- [PUP-1510: ensure => absent on user resource with forcelocal => true does not work as expected.](https://tickets.puppetlabs.com/browse/PUP-1510)
- [PUP-1338: yumrepo module is too picky about white space](https://tickets.puppetlabs.com/browse/PUP-1338)
- [PUP-789: Yumrepo should be refactored to use a provider](https://tickets.puppetlabs.com/browse/PUP-789)
- [PUP-1722: Yumrepo doesn't permit HTTPS URLs](https://tickets.puppetlabs.com/browse/PUP-1722)
- [PUP-778: PR (2086): Initial refactoring of yumrepo. - apenney](https://tickets.puppetlabs.com/browse/PUP-778)
- [PUP-1066: yum repos should be ensurable.](https://tickets.puppetlabs.com/browse/PUP-1066)
- [PUP-652: PR (2026): #19422: Deal with invalid arguments to nagios types - yath](https://tickets.puppetlabs.com/browse/PUP-652)
- [PUP-714: PR (2051): Suppress misleading warn. in openbsd provider - ptomulik](https://tickets.puppetlabs.com/browse/PUP-714)
- [PUP-1846: PR (2410): File content diffing should respect loglevel - wfarr](https://tickets.puppetlabs.com/browse/PUP-1846)
- [PUP-1473: user resource fails on UTF-8 comment](https://tickets.puppetlabs.com/browse/PUP-1473)

Windows-related bugs:

- [PUP-1368: Puppet on Windows segfaulting](https://tickets.puppetlabs.com/browse/PUP-1368)
- [PUP-1494: Windows colors.rb may be subject to Ruby corruption bug with wide strings](https://tickets.puppetlabs.com/browse/PUP-1494)
- [PUP-1681: Windows stat doesn't expose the correct mode](https://tickets.puppetlabs.com/browse/PUP-1681)
- [PUP-1275: Windows agent only runs when --onetime is specified](https://tickets.puppetlabs.com/browse/PUP-1275)
- [PUP-1278: PR: Windows Puppet Agent Service gracefully terminates after succesfully being put into a Paused state](https://tickets.puppetlabs.com/browse/PUP-1278)
- [PUP-1284: win32-security gem doesn't handle 'Authenticated Users' correctly](https://tickets.puppetlabs.com/browse/PUP-1284)
- [PUP-797: PR (2094): (#23219) - Fix support of extra arguments in windows service - luisfdez](https://tickets.puppetlabs.com/browse/PUP-797)

Standards compliance improvements:

- [PUP-1407: puppet CA generates CRL that does not conform to RFC5280](https://tickets.puppetlabs.com/browse/PUP-1407)
- [PUP-1409: add an authorityKeyIdentifier extension to node certificates](https://tickets.puppetlabs.com/browse/PUP-1409)

Clean-ups:

- [PUP-1120: Change default private key permissions to permit group read](https://tickets.puppetlabs.com/browse/PUP-1120)
- [PUP-1451: PR (2257) Make public SSL files publicly readable](https://tickets.puppetlabs.com/browse/PUP-1451)
- [PUP-1262: PR (2196): (maint) cron: Make the munge method for the command property more readable - ffrank](https://tickets.puppetlabs.com/browse/PUP-1262)

General bugs:

- [PUP-1064: Puppet master fails with 'stack level too deep' error when storeconfigs = true with rails stack 3.1.0](https://tickets.puppetlabs.com/browse/PUP-1064)
- [PUP-1136: When applying the settings catalog, a failed transaction may not properly surface information about the event that caused it to fail](https://tickets.puppetlabs.com/browse/PUP-1136)
- [PUP-1150: Race condition in Puppet::Util::Lockfile](https://tickets.puppetlabs.com/browse/PUP-1150)
- [PUP-1246: Hiding error details in fileserver.conf parser when this config is wrong](https://tickets.puppetlabs.com/browse/PUP-1246)
- [PUP-1470: mk_resource_methods getters can't deal with false](https://tickets.puppetlabs.com/browse/PUP-1470)
- [PUP-1484: msgpack serialization of TagSet broken](https://tickets.puppetlabs.com/browse/PUP-1484)
- [PUP-1578: puppetlabs/reboot: Ruby on windows can get into an infinite loop when exiting](https://tickets.puppetlabs.com/browse/PUP-1578)
- [PUP-1101: Static compiler does not filter exported resources from the catalog](https://tickets.puppetlabs.com/browse/PUP-1101)
- [PUP-721: PR (2056): (#7659)(#20122) Fix comment stack when parsing hashes - hlindberg](https://tickets.puppetlabs.com/browse/PUP-721)
- [PUP-786: PR (2090): (#21869) Fix recursion in cert expiration check - Sharpie](https://tickets.puppetlabs.com/browse/PUP-786)
- [PUP-804: PR (2097): (maint) Handle empty or malformed JSON lockfiles - adrienthebo](https://tickets.puppetlabs.com/browse/PUP-804)
- [PUP-906: PR (2118): (#22330) add btrfs to SELinux filesystem whitelist - qralston](https://tickets.puppetlabs.com/browse/PUP-906)
- [PUP-1243: PR (2184): (maint) Fix can't modify frozen Symbol error on Ruby 2.1.0 - jeffmccune](https://tickets.puppetlabs.com/browse/PUP-1243)
- [PUP-1282: puppet gem does not include platform specific gem dependencies](https://tickets.puppetlabs.com/browse/PUP-1282)
- [PUP-1350: PR (2215): Don't replace original stacktrace when error happens parsing inline template - carlossg](https://tickets.puppetlabs.com/browse/PUP-1350)
- [PUP-1502: PR (2293): (maint) Puppet fails to properly surface backtraces - Iristyle](https://tickets.puppetlabs.com/browse/PUP-1502)
- [PUP-1420: PR (2248): move StateMachine out of the global scope - crankharder](https://tickets.puppetlabs.com/browse/PUP-1420)
- [PUP-1707: Faces help sometimes blows up when descriptions are absent](https://tickets.puppetlabs.com/browse/PUP-1707)
- [PUP-1387: CA generates subjectKeyIdentifier from issuer cert instead of cert itself](https://tickets.puppetlabs.com/browse/PUP-1387)
- [PUP-1568: Error reporting within augeas provider fails](https://tickets.puppetlabs.com/browse/PUP-1568)
- [PUP-1839: Puppet device results in SSL stack too deep error](https://tickets.puppetlabs.com/browse/PUP-1839)
- [PUP-1885: File type ignore can't convert Fixnum into String](https://tickets.puppetlabs.com/browse/PUP-1885) (This one was a regression from 3.3.0.)
- [PUP-1404: PR (2234): ensure Puppet::Util::Execution.execpipe always run the command with LANG... - doc75](https://tickets.puppetlabs.com/browse/PUP-1404)

Bugs introduced in 3.5 and fixed during the release candidate period:

Fixed in RC3:

- [PUP-2039: rpm provider broken for architecture specifications in 3.5.0-RC2 due to whatprovides functionality change](https://tickets.puppetlabs.com/browse/PUP-2039)

Fixed in RC2:

- [PUP-1944: Error when manifest is a directory but not the same as manifestdir](https://tickets.puppetlabs.com/browse/PUP-1944)
- [PUP-2009: Dynamic environments not working with manifestdir setting](https://tickets.puppetlabs.com/browse/PUP-2009)
- [PUP-1962: Relationships with Classes in future parser broken](https://tickets.puppetlabs.com/browse/PUP-1962)
- [PUP-1973: future parser doesn't bind variables from inherited scope](https://tickets.puppetlabs.com/browse/PUP-1973)
- [PUP-1978: future parser doesn't accept empty array as title](https://tickets.puppetlabs.com/browse/PUP-1978)
- [PUP-1979: future parser Class reference with leading :: doesn't work](https://tickets.puppetlabs.com/browse/PUP-1979)
- [PUP-2017: TupleType applies size constraint to last element only](https://tickets.puppetlabs.com/browse/PUP-2017)


### All Resolved Issues for 3.5.0

Our ticket tracker has the list of [all issues resolved in Puppet 3.5.0.](https://tickets.puppetlabs.com/browse/PUP/fixforversion/11009)
