---
layout: default
title: "Puppet 3.6 Release Notes"
description: "Puppet release notes for version 3.6"
canonical: "/puppet/latest/reference/release_notes.html"
---

[upgrade]: /puppet/3.8/reference/upgrading.html
[puppet_3]: /puppet/3/reference/release_notes.html
[puppet_35]: /puppet/3.5/reference/release_notes.html
[directory environments]: ./environments.html

This page tells the history of the Puppet 3.6 series. (Elsewhere: release notes for [Puppet 3.0 -- 3.4][puppet_3] and [Puppet 3.5][puppet_35].)

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

How to Upgrade
-----

If you're upgrading from a 3.x version of Puppet, you can usually just go for it. Upgrade your puppet master servers before upgrading the agents they serve. (But do look at the table of contents above and see if there are any "Upgrade Warning" notes for the new version.)

If you're upgrading from Puppet 2.x, please [learn about major upgrades of Puppet first!][upgrade] We have important advice about upgrade plans and package management practices. The short version is: test first, roll out in stages, give yourself plenty of time to work with. Also, read the [release notes for Puppet 3][puppet_3] for a list of all the breaking changes made between the 2.x and 3.x series.

Puppet 3.6.2
-----

[deprecated config-file environments]: #deprecation-config-file-environments-and-the-global-manifestmodulepathconfigversion-settings
[CVE-2014-3248]: http://puppetlabs.com/security/cve/cve-2014-3248
[CVE-2014-3250]: http://puppetlabs.com/security/cve/cve-2014-3250

Released June 10, 2014.

Puppet 3.6.2 is a security and bug fix release in the Puppet 3.6 series. It addresses two security vulnerabilities and includes fixes for a number of fairly recent bugs. It also introduces a new `disable_warnings` setting to squelch deprecation messages.

### Security Fixes

#### [CVE-2014-3248 (An attacker could convince an administrator to unknowingly execute malicious code on platforms with Ruby 1.9.1 and earlier)][CVE-2014-3248]

On platforms running Ruby 1.9.1 and earlier, previous code would load Ruby source files from the current working directory. This could lead to the execution of arbitrary code during puppet runs.

#### [CVE-2014-3250 (Information Leakage Vulnerability)][CVE-2014-3250]

Apache 2.4+ uses the `SSLCARevocationCheck` setting to determine how to check the certificate revocation list (CRL) when establishing a connection. Unfortunately, the default setting is `none`, so a puppet master running Apache 2.4+ and Passenger will ignore the CRL by default. This release updates the Apache vhost settings to enable CRL checking.

### Feature: Disabling Deprecation Warnings

Puppet 3.6.0 [deprecated config-file environments][], leading to warnings during every puppet run for people who haven't yet switched to the new and improved [directory environments](environments.html). The high volume of duplicate deprecation warnings was deemed annoying enough that we've added a new feature to allow people to disable them.

You can now use the new (optional) [`disable_warnings` setting](./configuration.html#disablewarnings) in puppet.conf or on the command line to suppress certain types of warnings. For now, `disable_warnings` can only be set to `deprecations`, but other warning types may be added in future versions. All warnings are still enabled by default.

Related issue:

- [PUP-2650: 3.6.1 issues "warning" message for deprecation](https://tickets.puppetlabs.com/browse/PUP-2650)

### Fix for Directory Environments Under Webrick

Puppet 3.6.1 introduced a bug that prevented directory environments from functioning correctly under Webrick, causing this error: "Attempted to pop, but already at root of the context stack." This release fixes the bug.

Related issue:

- [PUP-2659: Puppet stops working with error 'Attempted to pop, but already at root of the context stack.'](https://tickets.puppetlabs.com/browse/PUP-2659)

### Fixes to `purge_ssh_keys`

Two bugs were discovered with the new (as of 3.6.0) `purge_ssh_keys` attribute for the [user type](./type.html#user). These bugs could prevent SSH keys from being purged under certain circumstances, and have been fixed.

Related issues:

- [PUP-2635: user purge_ssh_keys not purged](https://tickets.puppetlabs.com/browse/PUP-2635)
- [PUP-2660: purging ssh_authorized_key fails because of missing user value](https://tickets.puppetlabs.com/browse/PUP-2660)

### Default `environment_timeout` increased

The previous default value for [`environment_timeout`](./configuration.html#environmenttimeout) was 5s, which turns out to be way too short for a typical production environment. This release changes the default `environment_timeout` to 3m.

Related issue:

- [PUP-2639: Increase environment_timeout default.](https://tickets.puppetlabs.com/browse/PUP-2639)

### General Bug Fixes

- [PUP-2689: A node can't always collect its own exported resources](https://tickets.puppetlabs.com/browse/PUP-2689)
- [PUP-2692: Puppet master passenger processes keep growing](https://tickets.puppetlabs.com/browse/PUP-2692)
- [PUP-2705: Regression with external facts pluginsync not preserving executable bit](https://tickets.puppetlabs.com/browse/PUP-2705)

Puppet 3.6.1
-----

[node termini]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc]: /guides/external_nodes.html
[allow_virtual]: ./type.html#package-attribute-allow_virtual
[the main manifest]: ./dirs_manifest.html
[multi_source]: ./type.html#file-attribute-source

Released May 22, 2014.

Puppet 3.6.1 is a bug fix release in the Puppet 3.6 series. It also makes the `transaction_uuid` more reliably available to extensions.

### Changes to RPM Behavior With Virtual Packages

In Puppet 3.5, the RPM package provider gained support for virtual packages. (That is, Puppet would handle package names the same way Yum does.) In this release, we added a new [`allow_virtual` attribute][allow_virtual] for `package`, which defaults to `false`. You'll have to set it to `true` to manage virtual packages.

We did this because there are a few cases where a virtual package name can conflict with a non-virtual package name, and Puppet will manage the wrong thing. (Again, just like Yum would.) For example, if you set `ensure => absent` on the `inetd` package, Puppet might uninstall the `xinetd` package, since it provides the `inetd` virtual package.

We had to treat that change as a regression, so we're currently defaulting `allow_virtual => false` to preserve compatibility in the Puppet 3 series. The default will change to `true` for Puppet 4. If you manage any packages with virtual/non-virtual name conflicts, you should set `allow_virtual => false` on a per-resource basis.

If you don't have any resources with ambiguous virtual/non-virtual package names, you can enable the Puppet 4 behavior today by setting a resource default in [the main manifest][]:

~~~ ruby
    Package {
      allow_virtual => true,
    }
~~~

- [PUP-2182: Package resource not working as expected in 3.5.0](https://tickets.puppetlabs.com/browse/PUP-2182)

### Improvements to `transaction_uuid` in Reports and Node Termini

Each catalog request from an agent node has a unique identifier, which persists through the entire run and ends up in the report. However, it was being omitted from reports when the catalog run failed, and [node termini][] had no access to it. This release adds it to failed reports and node object requests.

(Note that `transaction_uuid` isn't available in the standard [ENC][] interface, but it is available to custom node termini.)

- [PUP-2522: The transaction_uuid should be available to a node terminus](https://tickets.puppetlabs.com/browse/PUP-2522)
- [PUP-2508: Failed compilation does not populate environment, transaction_uuid in report](https://tickets.puppetlabs.com/browse/PUP-2508)

### Windows Start Menu Fixes

If your Windows machine only had .NET 4.0 or higher, the "Run Facter" and "Run Puppet Agent" start menu items wouldn't work, stating that they needed an older version of .NET installed. This is now fixed.

- [PUP-1951: Unable to "Run Facter" or "Run Puppet Agent" from Start Menu on Windows 8/2012 - Requires .NET Framework 3.5 installed](https://tickets.puppetlabs.com/browse/PUP-1951)

### Improved Passenger Packages on Debian/Ubuntu

The Apache vhost config we ship in the Debian/Ubuntu `puppetmaster-passenger` package had some non-optimal TLS settings. This has been improved.

- [PUP-2582: Enable TLSv1.2 in apache vhost config](https://tickets.puppetlabs.com/browse/PUP-2582)


### HTTP API Fixes

A regression in Puppet 3.5 broke `DELETE` requests to Puppet's HTTP API. Also, a change in 3.6.0 made puppet agent log spurious warnings when using [multiple values for the `source` attribute][multi_source]. These bugs are both fixed.

- [PUP-2505: REST API regression in DELETE request handling](https://tickets.puppetlabs.com/browse/PUP-2505)
- [PUP-2584: Spurious warnings when using multiple file sources](https://tickets.puppetlabs.com/browse/PUP-2584) (regression in 3.6.0)


### Directory Environment Fixes

If puppet master was running under Rack (e.g. with Passenger) and the [environmentpath](./environments.html#about-environmentpath) was configured in the `[master]` section of puppet.conf (instead of in `[main]`), Puppet would use the wrong set of environments. This has been fixed.

- [PUP-2607: environmentpath does not work in master section of config](https://tickets.puppetlabs.com/browse/PUP-2607)
- [PUP-2610: Rack masters lose track of environment loaders](https://tickets.puppetlabs.com/browse/PUP-2610)


### Future Parser Improvements

This release fixes two compatibility bugs where the future parser conflicted with the 3.x parser. It also fixes a bug with the new EPP templating language.

- [PUP-1894: Cannot render EPP templates from a module](https://tickets.puppetlabs.com/browse/PUP-1894)
- [PUP-2568: Cannot use class references with upper cased strings](https://tickets.puppetlabs.com/browse/PUP-2568)
- [PUP-2581: Interpolated variables with leading underscore regression](https://tickets.puppetlabs.com/browse/PUP-2581) (regression in 3.5.1)



Puppet 3.6.0
-----

Released May 15, 2014. (RC1: May 6.)

Puppet 3.6.0 is a backward-compatible features and fixes release in the Puppet 3 series. The biggest things in this release are:

* Improvements to [directory environments][], and the deprecation of config file environments
* Support for purging unmanaged `ssh_authorized_key` resources
* Support for installing gems for a custom provider as part of a Puppet run
* A configurable global logging level
* A configurable hashing algorithm (for FIPS compliance and other purposes)
* Improvements to the experimental future parser

### Improvements for Directory Environments

[environment.conf]: ./config_file_environment.html
[timeout]: ./environments.html#tuning-environment-caching

Directory environments were introduced in [Puppet 3.5][puppet_35] as a partially finished (but good enough for most people) feature. With Puppet 3.6, we consider them completed. We're pretty sure they can now handle every use case for environments we've ever heard of.

The final piece is [the `environment.conf` file][environment.conf]. This optional file allows any environment to override the `manifest`, `modulepath`, and `config_version` settings, which is necessary for some people and wasn't possible in Puppet 3.5. You can now exclude global module directories for some environments, or point all environments at a global main manifest file. For details, see [the page on directory environments][directory environments] and [the page on environment.conf][environment.conf].

It's also now possible to tune the cache timeout for environments, to improve performance on your puppet master. [See the note on timeout tuning][timeout] in the directory environments page.

- [PUP-1114: Deprecate environment configuration in puppet.conf](https://tickets.puppetlabs.com/browse/PUP-1114)
- [PUP-2213: The environmentpath setting is ignored by puppet faces unless set in \[main\]](https://tickets.puppetlabs.com/browse/PUP-2213)
- [PUP-2215: An existing directory environment will use config_version from an underlying legacy environment of the same name.](https://tickets.puppetlabs.com/browse/PUP-2215)
- [PUP-2290: ca_server and directory based environments don't play nice together](https://tickets.puppetlabs.com/browse/PUP-2290)
- [PUP-1596: Make modulepath, manifest, and config_version configurable per-environment](https://tickets.puppetlabs.com/browse/PUP-1596)
- [PUP-1699: Cache environments](https://tickets.puppetlabs.com/browse/PUP-1699)
- [PUP-1433: Deprecate 'implicit' environment settings and update packaging](https://tickets.puppetlabs.com/browse/PUP-1433)

### Deprecation: Config-File Environments and the Global `manifest`/`modulepath`/`config_version` Settings

Now that [directory environments][] are completed, [config-file environments](./environments_classic.html) are deprecated. Defining environment blocks in puppet.conf will cause a deprecation warning, as will any use of the `modulepath`, `manifest`, and `config_version` settings in puppet.conf.

This also means that using _no_ environments is deprecated. In a future version of Puppet (probably Puppet 4), directory environments will always be enabled, and the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.

Related issues:

- [PUP-1114: Deprecate environment configuration in puppet.conf](https://tickets.puppetlabs.com/browse/PUP-1114)
- [PUP-1433: Deprecate 'implicit' environment settings and update packaging](https://tickets.puppetlabs.com/browse/PUP-1433)

### Feature: Purging Unmanaged SSH Authorized Keys

Purging unmanaged [`ssh_authorized_key`](./type.html#sshauthorizedkey) resources has been on the most-wanted features list for a very long time, and we haven't been able to make [the `resources` meta-type](./type.html#resources) accommodate it.

Fortunately, the [user type](./type.html#user) accommodates it very nicely. You can now purge unmanaged SSH keys for a user by setting the `purge_ssh_keys` attribute:

    user { 'nick':
      ensure         => present,
      purge_ssh_keys => true,
    }

This will purge any keys in `~nick/.ssh/authorized_keys` that aren't being managed as Puppet resources.

Related issues:

- [PUP-1174: PR (2247) Ability to purge .ssh/authorized_keys](https://tickets.puppetlabs.com/browse/PUP-1174)
- [PUP-1955: purge_ssh_keys causes stack trace when creating new users on redhat](https://tickets.puppetlabs.com/browse/PUP-1955)

### Feature: Installing Gems for a Custom Provider During Puppet Runs

Previously, custom providers that required one or more gems would fail if at least one gem was missing *before* the current puppet run, even if they had been installed by the time the provider was actually called. This release fixes the behavior so that custom providers can rely on gems installed during the same puppet run.

Related issue:

- [PUP-1879: Library load tests in features should clear rubygems path cache](https://tickets.puppetlabs.com/browse/PUP-1879)

### Feature: Global `log_level` Setting

You can now set the global log level using the `log_level` setting in puppet.conf. It defaults to `notice`, and can be set to `debug`, `info`, `notice`, `warning`, `err`, `alert`, `emerg`, or `crit`.

Related issue:

- [PUP-1854: Global log_level param](https://tickets.puppetlabs.com/browse/PUP-1854)

### Feature: `digest_algorithm` Setting

You can now change the hashing algorithm that puppet uses for file digests to `sha256` using the new [`digest_algorithm` setting](./configuration.html#digestalgorithm) in puppet.conf. This is especially important for FIPS-compliant hosts, which would previously crash when puppet tried to use MD5 for hashing. Changing this setting won't affect the `md5` or `fqdn_rand` functions.

This setting **must** be set to the same value on all agents and all masters simultaneously; if they mismatch, you'll run into two problems:

- [PUP-2427: Pluginsync will download every file every time if digest_algorithms do not agree](https://tickets.puppetlabs.com/browse/PUP-2427) --- All files with a `source` attribute will download on every run, which wastes a lot of time and can swamp your puppet master.
- [PUP-2423: Filebucket server should warn, not fail, if checksum type is not supported](https://tickets.puppetlabs.com/browse/PUP-2423) --- If you're using a remote filebucket to back up file content, agent runs will fail.

Related issue:

- [PUP-1840: Let user change hashing algorithm, to avoid crashing on FIPS-compliant hosts](https://tickets.puppetlabs.com/browse/PUP-1840)

### Improvements to the Future Parser

It's still experimental, but the future parser has gotten a lot of attention in this release. For example, functions can now accept lambdas as arguments using the new Callable type. There are also a few changes laying the groundwork for the upcoming catalog builder.

- [PUP-1960: realizing an empty array of resources fails in future evaluator](https://tickets.puppetlabs.com/browse/PUP-1960)
- [PUP-1964: Using undefined variable as class parameter default fails in future evaluator](https://tickets.puppetlabs.com/browse/PUP-1964)
- [PUP-2190: Accessing resource metaparameters fails in future evaluator](https://tickets.puppetlabs.com/browse/PUP-2190)
- [PUP-2317: Future parser does not error on import statements](https://tickets.puppetlabs.com/browse/PUP-2317)
- [PUP-2302: New evaluator does not properly handle resource defaults](https://tickets.puppetlabs.com/browse/PUP-2302)
- [PUP-2026: Add a LambdaType to the type system](https://tickets.puppetlabs.com/browse/PUP-2026)
- [PUP-2027: Add support for Lambda in Function Call API](https://tickets.puppetlabs.com/browse/PUP-2027)
- [PUP-1956: Add function loader for new function API](https://tickets.puppetlabs.com/browse/PUP-1956)
- [PUP-2344: Functions unable to call functions in different modules](https://tickets.puppetlabs.com/browse/PUP-2344)
- [PUP-485: Add assert\_type functions for type checks](https://tickets.puppetlabs.com/browse/PUP-485)
- [PUP-1799: New Function API](https://tickets.puppetlabs.com/browse/PUP-1799)
- [PUP-2035: Implement Loader infrastructure API](https://tickets.puppetlabs.com/browse/PUP-2035)
- [PUP-2241: Add logging functions to static loader](https://tickets.puppetlabs.com/browse/PUP-2241)
- [PUP-485: Add assert_type functions for type checks](https://tickets.puppetlabs.com/browse/PUP-485)
- [PUP-1799: New Function API](https://tickets.puppetlabs.com/browse/PUP-1799)
- [PUP-2035: Implement Loader infrastructure API](https://tickets.puppetlabs.com/browse/PUP-2035)
- [PUP-2241: Add logging functions to static loader](https://tickets.puppetlabs.com/browse/PUP-2241)

### OS Support Changes

This release improves compatibility with Solaris 10 and adds support for Ubuntu 14.04 (Trusty Tahr).

Support for Ubuntu 13.04 (Raring Ringtail) has been discontinued; it was EOL'd in January 2014.

Related issues:

- [PUP-1749: Puppet module tool does not work on Solaris](https://tickets.puppetlabs.com/browse/PUP-1749)
- [PUP-2100: Allow Inheritance when setting Deny ACEs](https://tickets.puppetlabs.com/browse/PUP-2100)
- [PUP-1711: Add Ubuntu 14.04 packages](https://tickets.puppetlabs.com/browse/PUP-1711)
- [PUP-1712: Add Ubuntu 14.04 to acceptance](https://tickets.puppetlabs.com/browse/PUP-1712)
- [PUP-2347: Remove raring from build_defaults, it is EOL](https://tickets.puppetlabs.com/browse/PUP-2347)
- [PUP-2418: Remove Tar::Solaris from module_tool](https://tickets.puppetlabs.com/browse/PUP-2418)

### Module Tool Changes

The puppet module tool has been updated to deprecate the Modulefile in favor of metadata.json. To help ease the transition, the module tool will automatically generate metadata.json based on a Modulefile if it finds one. If neither Modulefile nor metadata.json is available, it will kick off an interview and generate metadata.json based on your responses.

The new module template has also been updated to include a basic README and spec tests. For more information, see [Publishing Modules on the Puppet Forge](./modules_publishing.html).

Related issues:

- [PUP-1976: `puppet module build` should use `metadata.json` as input format](https://tickets.puppetlabs.com/browse/PUP-1976)
- [PUP-1977: `puppet module build` should create `metadata.json` instead of `Modulefile`](https://tickets.puppetlabs.com/browse/PUP-1977)
- [PUP-2045: puppet module generate should produce a skeleton Rakefile](https://tickets.puppetlabs.com/browse/PUP-2045)
- [PUP-2093: PMT should use the Forge's /v3 API](https://tickets.puppetlabs.com/browse/PUP-2093)
- [PUP-2284: Add a user interview for creating a metadata.json file](https://tickets.puppetlabs.com/browse/PUP-2284)
- [PUP-2285: Update PMT generate's README template](https://tickets.puppetlabs.com/browse/PUP-2285)

Issues fixed during RC:

- [PUP-2484: `puppet module build` should provide deprecated functionality with warning until Puppet v4](https://tickets.puppetlabs.com/browse/PUP-2484) --- this would cause the Modulefile to be ignored if a metadata.json file also existed.
- [PUP-2561: PMT may deadlock when packing or unpacking large tarballs](https://tickets.puppetlabs.com/browse/PUP-2561)
- [PUP-2562: PMT will not install puppetlabs/openstack 4.0.0](https://tickets.puppetlabs.com/browse/PUP-2562)

### Type and Provider Fixes

#### Package:

Several providers were updated to support the `install_options` attribute, and the yum provider now has special behavior to make `--enablerepo` and `--disablerepo` work well when you set them as `install_options`.

- [PUP-748: PR (2067): Zypper provider install options - darix](https://tickets.puppetlabs.com/browse/PUP-748)
- [PUP-620: (PR 2429) Add install_options to gem provider](https://tickets.puppetlabs.com/browse/PUP-620)
- [PUP-1769: PR (2414) yum provider to support install_options](https://tickets.puppetlabs.com/browse/PUP-1769)
- [PUP-772: PR (2082): Add install options to apt](https://tickets.puppetlabs.com/browse/PUP-772)
- [PUP-1060: enablerepo and disablerepo for yum type](https://tickets.puppetlabs.com/browse/PUP-1060)

#### Nagios:

- [PUP-1041: PR (2385) naginator not parsing blank parameters](https://tickets.puppetlabs.com/browse/PUP-1041)

#### Cron:

- [PUP-1585: PR (2342) cron resources with target specified generate duplicate entries](https://tickets.puppetlabs.com/browse/PUP-1585)
- [PUP-1586: PR (2331) Cron Type sanity check for the command parameter is broken](https://tickets.puppetlabs.com/browse/PUP-1586)
- [PUP-1624: PR (2342) Cron handles crontab's equality of target and user strangely](https://tickets.puppetlabs.com/browse/PUP-1624)

#### Service:

OpenBSD services can now be enabled and disabled, and we fixed some bugs on other platforms.

- [PUP-1751: PR (2383): Suse chkconfig --check boot.\<service\> always returns 1 whether the service is enabled/disabled. - m4ce](https://tickets.puppetlabs.com/browse/PUP-1751)
- [PUP-1932: systemd reports transient (in-memory) services](https://tickets.puppetlabs.com/browse/PUP-1932)
- [PUP-1938: Remove Ubuntu default from Debian service provider](https://tickets.puppetlabs.com/browse/PUP-1938)
- [PUP-1332: "puppet resource service" fails on Ubuntu 13.04 and higher](https://tickets.puppetlabs.com/browse/PUP-1332)
- [PUP-2143: Allow OpenBSD service provider to implement :enableable](https://tickets.puppetlabs.com/browse/PUP-2143)

#### File:

We fixed a regression from Puppet 3.0 that broke file resources whose `source` URL specified a server other than the default. (That is, `puppet://myserver/modules/...` instead of `puppet:///modules/...`.)

- [PUP-1892: PR (2420) Puppet remote fileserver facility for file resources.](https://tickets.puppetlabs.com/browse/PUP-1892)

#### Yumrepo:

We fixed a few lingering regressions from the big yumrepo cleanup of Puppet 3.5, and added support for the `skip_if_unavailable` parameter.

- [PUP-2218: yumrepo can no longer manage repositories in yum.conf](https://tickets.puppetlabs.com/browse/PUP-2218)
- [PUP-2291: yumrepo priority can not be sent to absent](https://tickets.puppetlabs.com/browse/PUP-2291)
- [PUP-2292: Insufficient tests on yumrepo's => absent](https://tickets.puppetlabs.com/browse/PUP-2292)
- [PUP-2279: Add support for 'skip_if_unavailable' parameter to `yumrepo`](https://tickets.puppetlabs.com/browse/PUP-2279)

#### Augeas:

We added better control over the way Augeas resources display diffs, for better security and less noise.

- [PUP-2033: Allow augeas diffs to respect loglevel](https://tickets.puppetlabs.com/browse/PUP-2033)
- [PUP-2048: Allow suppressing diffs on augeas](https://tickets.puppetlabs.com/browse/PUP-2048)

### General Bug Fixes

- [PUP-530: Installer for Puppet 3 does not check for hiera](https://tickets.puppetlabs.com/browse/PUP-530)
- [PUP-1547: PR (2311) Undefined method `groups' for nil:NilClass](https://tickets.puppetlabs.com/browse/PUP-1547)
- [PUP-1552: V2.0 API reports Not Authorized as a "RUNTIME_ERROR"](https://tickets.puppetlabs.com/browse/PUP-1552)
- [PUP-1924: source function library *before* client sysconfig overrides](https://tickets.puppetlabs.com/browse/PUP-1924)
- [PUP-1954: use of 'attr' causes deprecation warning](https://tickets.puppetlabs.com/browse/PUP-1954)
- [PUP-1986: Permissions for libdir are set arbitrarily](https://tickets.puppetlabs.com/browse/PUP-1986)
- [PUP-2073: PR (2477) Multiple values for diff_args causes diff execution failure](https://tickets.puppetlabs.com/browse/PUP-2073)
- [PUP-2278: puppet module install fails when given path containing spaces](https://tickets.puppetlabs.com/browse/PUP-2278)
- [PUP-2101: resource parser: add the resource name on the validation error message when using create_resources](https://tickets.puppetlabs.com/browse/PUP-2101)
- [PUP-2282: Deprecation warnings issued with different messages from the same line are suppressed.](https://tickets.puppetlabs.com/browse/PUP-2282)
- [PUP-2306: Puppet::Util::Execution.execute no longer returns a String](https://tickets.puppetlabs.com/browse/PUP-2306)
- [PUP-2415: Puppet Agent Service - Rename /etc/sysconfig/puppetagent to /etc/sysconfig/puppet](https://tickets.puppetlabs.com/browse/PUP-2415)
- [PUP-2416: Puppet Service - Use no-daemonize and no forking (Master and Agent)](https://tickets.puppetlabs.com/browse/PUP-2416)
- [PUP-2417: Puppet Agent Should wait for Puppet Master to finish starting, if puppet master is installed](https://tickets.puppetlabs.com/browse/PUP-2417)
- [PUP-2395: Installation problem for puppetmaster-puppet 3.5.1 on Ubuntu 13.10](https://tickets.puppetlabs.com/browse/PUP-2395)

### All Resolved Issues for 3.6.0

Our ticket tracker has the list of [all issues resolved in Puppet 3.6.0.](https://tickets.puppetlabs.com/secure/ReleaseNote.jspa?projectId=10102&version=11200)
