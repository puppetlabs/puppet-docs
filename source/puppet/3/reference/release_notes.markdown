---
layout: default
title: Puppet 3 Release Notes
description: Puppet release notes for version 3.x
---

[classes]: ./lang_classes.html
[lang_scope]: ./lang_scope.html
[qualified_vars]: ./lang_variables.html#accessing-out-of-scope-variables
[auth_conf]: /guides/rest_auth_conf.html
[upgrade]: /guides/upgrading.html
[upgrade_issues]: http://projects.puppetlabs.com/projects/puppet/wiki/Telly_Upgrade_Issues
[target_300]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f[]=fixed_version_id&op[fixed_version_id]=%3D&v[fixed_version_id][]=271&f[]=&c[]=project&c[]=tracker&c[]=status&c[]=priority&c[]=subject&c[]=assigned_to&c[]=fixed_version&group_by=
[unless]: ./lang_conditional.html#unless-statements
[target_310]: http://projects.puppetlabs.com/projects/puppet/issues?set_filter=1&f%5B%5D=fixed_version_id&op%5Bfixed_version_id%5D=%3D&v%5Bfixed_version_id%5D%5B%5D=288&f%5B%5D=&c%5B%5D=project&c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=priority&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=fixed_version&group_by=
[new_in_31]: ./whats_new.html#new-features-in-puppet-310
[CVE-2013-2275]: http://puppetlabs.com/security/cve/cve-2013-2275
[CVE-2013-1655]: http://puppetlabs.com/security/cve/cve-2013-1655
[CVE-2013-1654]: http://puppetlabs.com/security/cve/cve-2013-1654
[CVE-2013-1653]: http://puppetlabs.com/security/cve/cve-2013-1653
[CVE-2013-1652]: http://puppetlabs.com/security/cve/cve-2013-1652
[CVE-2013-1640]: http://puppetlabs.com/security/cve/cve-2013-1640
[32issues]: http://projects.puppetlabs.com/versions/371
[32splay]: /references/latest/configuration.html#splay
[32modulo_operator]: /puppet/3/reference/lang_expressions.html#modulo
[32profiling_setting]: /references/3.stable/configuration.html#profile
[32cron_type]: /references/3.stable/type.html#cron
[32hiera_auto_param]: /hiera/1/puppet.html#automatic-parameter-lookup
[19983]: http://projects.puppetlabs.com/issues/19983 "egrammar parser loses filename in error messages"
[11331]: http://projects.puppetlabs.com/issues/11331 "Add 'foreach' structure in manifests"
[18494]: http://projects.puppetlabs.com/issues/18494 "Ensure that puppet works on Ruby 2.0"
[19877]: http://projects.puppetlabs.com/issues/19877 "Puppet Support for OpenWrt"
[15561]: http://projects.puppetlabs.com/issues/15561 "Fix for CVE-2012-3867 is too restrictive"
[17864]: http://projects.puppetlabs.com/issues/17864 "puppet client requests /production/certificate_revocation_list/ca even with certificate_revocation=false"
[19271]: http://projects.puppetlabs.com/issues/19271 "The HTTP SSL errors assume the puppet ca subject name starts with 'puppet ca'"
[20027]: http://projects.puppetlabs.com/issues/20027 "Puppet ssl_client_ca_auth setting does not behave as documented"
[18950]: http://projects.puppetlabs.com/issues/18950 "Add a modulo operator to puppet"
[17190]: http://projects.puppetlabs.com/issues/17190 "detailed accounting/debugging of catalog compilation times"
[593]: http://projects.puppetlabs.com/issues/593 "Puppet's cron type struggles with vixie-cron"
[656]: http://projects.puppetlabs.com/issues/656 "cron entries with newlines keep being updated"
[1453]: http://projects.puppetlabs.com/issues/1453 "removing a cron parameter does not change the object"
[2251]: http://projects.puppetlabs.com/issues/2251 "cron provider doesn't correctly employ user property for resource existence checks."
[3047]: http://projects.puppetlabs.com/issues/3047 "Cron entries using "special" parameter lose their title when changed"
[5752]: http://projects.puppetlabs.com/issues/5752 "Solaris 10 root crontab gets destroyed"
[16121]: http://projects.puppetlabs.com/issues/16121 "Cron user change results in duplicate entries on target user"
[16809]: http://projects.puppetlabs.com/issues/16809 "cron resource can destroy other resources"
[19716]: http://projects.puppetlabs.com/issues/19716 "cron job not sucked into puppet"
[19876]: http://projects.puppetlabs.com/issues/19876 "Regression: cron now matches on-disk records too aggressively"
[11276]: http://projects.puppetlabs.com/issues/11276 "Get puppet module tool working on Windows"
[13542]: http://projects.puppetlabs.com/issues/13542 "PMT cannot install tarballs for modules that don't exist on the Forge"
[14728]: http://projects.puppetlabs.com/issues/14728 "puppet module changes incorrectly errors when a file is missing"
[18229]: http://projects.puppetlabs.com/issues/18229 "Eroneous command given in puppet module error message"
[19128]: http://projects.puppetlabs.com/issues/19128 ""puppet module build" doesn't escape PSON correctly"
[19409]: http://projects.puppetlabs.com/issues/19409 "puppet module errors from Puppet::Forge don't obey render mode"
[15841]: http://projects.puppetlabs.com/issues/15841 "Consider bundling minitar (or equivalent) for use by puppet module face"
[7680]: http://projects.puppetlabs.com/issues/7680 "Checksum missmatch when copying followed symlinks"
[14544]: http://projects.puppetlabs.com/issues/14544 "The apply application should support writing the resources file and classes file"
[14766]: http://projects.puppetlabs.com/issues/14766 "2nd puppet run after restart is ignoring runinterval, negating splay"
[18211]: http://projects.puppetlabs.com/issues/18211 "puppet agent sleeping well past runinterval"
[14985]: http://projects.puppetlabs.com/issues/14985 "calling_module and calling_class don't always return the calling module/class"
[17474]: http://projects.puppetlabs.com/issues/17474 "Indirector treats false from a terminus as nil"


Puppet 3.x Release Notes
------------------------

For a full description of the Puppet 3 release, including major changes, backward incompatibilities, and focuses of development, please see the [long-form Puppet 3 "What's New" document](./whats_new.html).

Puppet 3.3.0
-----

Released September 12, 2013.

3.3.0 is a backward-compatible feature and fix release in the Puppet 3 series.

### Upgrade Warning

**Note:** Whenever possible, _upgrade your puppet masters first._

Although 3.3.0 is backward-compatible, its default configuration will cause reporting failures when ≥ 3.3.0 agent nodes connect to a sub-3.3.0 master.

* This only affects newer agents + older masters; it is not a problem if you [upgrade the puppet master first.](/guides/upgrading.html#always-upgrade-the-puppet-master-first)
* To use ≥ 3.3.0 agents with an older puppet master, set `report_serialization_format` to `yaml` in their puppet.conf files; this restores full compatibility.

[See the note below on yaml deprecation for details.][yaml_deprecation]

### Configurable Resource Ordering

[(Issue 22205: Order of resource application should be selectable by a setting.)][22205]

Puppet can now optionally apply unrelated resources in the order they were written in their manifest files.

A [new `ordering` setting](/references/3.latest/configuration.html#ordering) configures how unrelated resources should be ordered when applying a catalog. This setting affects puppet agent and puppet apply, but not puppet master.

The allowed values for this setting are `title-hash`, `manifest`, and `random`:

* `title-hash` (the default) will order resources randomly, but will use
  the same order across runs and across nodes.
* `manifest` will use the order in which the resources were declared in
  their manifest files.
* `random` will order resources randomly and change their order with each
  run. This can work like a fuzzer for shaking out undeclared dependencies.

Regardless of this setting's value, Puppet will always obey explicit dependencies set with the before/require/notify/subscribe metaparameters and the `->`/`~>` chaining arrows; this setting only affects the relative ordering of _unrelated_ resources.

### Data in Modules

[(Issue 16856: puppet should support data in modules)][16856]

This feature makes it possible to contribute data bindings from modules to a
site-wide hierarchy of data bindings. This feature is introduced as an opt-in,
and it is turned on by setting `binder` to `true` in puppet.conf. It is turned on by default
when using the future parser. The implementation is based on [ARM-9
Data in Modules](http://links.puppetlabs.com/arm9-data_in_modules), which
contains the background, a description, and a set of examples.

### Security: YAML Over the Network is Now Deprecated

[yaml_deprecation]: #security-yaml-over-the-network-is-now-deprecated

[(Issue 21427: Deprecate YAML for network data transmission)][21427]

YAML has been the cause of many security problems, so we are refactoring Puppet to stop sending YAML over the network. Puppet will still write YAML to disk (since that doesn't add security risks), but all data objects sent over the network will be serialized as JSON. (Or, for the time being, as "PSON," which is JSON that may sometimes contain non-UTF8 data.)

As of this release:

* All places where the puppet master accepts YAML are deprecated. If the master receives YAML, it will still accept it but will log a deprecation warning.
* The puppet master can now accept reports in JSON format. (Prior to 3.3.0, puppet masters could only accept reports in YAML.)
* The puppet agent no longer defaults to requesting YAML from the puppet master (for catalogs, node objects, etc.).
* The puppet agent no longer defaults to sending YAML to the puppet master (for reports, query parameters like facts, etc.).

> **Deprecation plan:** Currently, we plan to remove YAML over the network in Puppet 4.0. This means in cases where Puppet 3.3 would issue a deprecation warning, Puppet 4 will completely refuse the request.

#### New Setting for Compatibility With Sub-3.3.0 Masters

Puppet 3.3 agents now default to sending reports as JSON, and masters running Puppet 3.2.4 and earlier cannot understand JSON reports. Using an out of the box 3.3 agent with a 3.2 puppet master will therefore fail.

* To avoid errors, [upgrade the puppet master first](/guides/upgrading.html#always-upgrade-the-puppet-master-first).
* If you must use ≥ 3.3.0 agents with older puppet masters, set the new `report_serialization_format` to `yaml` in the agents' puppet.conf; this restores full compatibility.

### Regex Capture Variables from Node Definitions ($1, etc.)

[(Issue 2628: It would be useful if node name regexps set $1)][2628]

Node definitions now set the standard regex capture variables, similar to the behavior of conditional statements that use regexes.

### Redirect Response Handling

[(Issue 18255: accept 301 response from fileserver)][18255]

Puppet's HTTP client now follows HTTP redirects when given status codes 301 (permanent), 302 (temporary), or 307 (temporary). The new functionality includes a redirection limit, and recreates the redirected connection with the same certificates and store as the original (as long as the new location is ssl protected). Redirects are performed for GET, HEAD, and POST requests.

This is mostly useful for configuring the puppet master's front end webserver to send fileserver traffic to the closest server.

### Filebucket Improvements

[(Issue 22375: File bucket and Puppet File resource: fails with "regexp buffer overflow" when backing up binary file)][22375]

There were a number of problems with the remote filebucket functionality for
backing up files under Puppet's management over the network. It is now possible
to back up binary files, which previously would consume lots of memory and
error out. Non-binary filebucket operations should also be faster as we
eliminated an unnecessary network round-trip that echoed the entire contents
of the file back to the agent after it was uploaded to the server.

### Internal Format and API Improvements

#### Report Format 4

[report4]: /puppet/3/reference/format_report.html#report-format-4

Puppet's [report format version][report4] has been bumped to 4. This is backward-compatible with report format 3, and adds `transaction_uuid` to reports and `containment_path` to resource statuses.

#### Unique Per-run Identifier in Reports and Catalog Requests

[(Issue 21831: Generate a UUID for catalog retrieval and report posts)][21831]

Puppet agent now embeds a per-run UUID in its catalog requests, and embeds the same UUID in its reports after applying the catalog. This makes it possible to correlate events from reports with the catalog that provoked those events.

There is currently no interface for doing this correlation, but a future version of PuppetDB will provide this functionality via catalog and report queries.

#### Readable Attributes on Puppet::ModuleTool::Dependency Objects

[(Issue 21749: Make attributes readable on Puppet::ModuleTool::Dependency objects)][21749]

This API change enables access to module dependency information via Ruby code.

### User Interface Improvements

#### Improved CSS for Puppet Doc Rdoc Output

[(Issue 6561: Better looking CSS for puppet doc rdoc mode)][6561]

The standard skin for rdoc generated from Puppet manifests has been updated to improve
readability. Note that puppet doc rdoc functionality remains broken on Ruby 1.9 and up.

#### Improved Display of Arrays in Console Output

[(Issue 20284: Output one item per line for arrays in console output)][20284]

This changes the output to console from faces applications to output array
items as one item per line.

#### Configurable Module Skeleton Directory

[(Issue 21170: enhancement of the module generate functionality)][21170]

Previously, you could provide your own template for the `puppet module generate` action by creating a directory called `skeleton` in the directory specified by [the `module_working_dir` setting](/references/3.latest/configuration.html#module_working_dir). (The layout of the directory should match that of [`lib/puppet/module_tool/skeleton`](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/module_tool/skeleton).) This directory can now be configured independently with [the `module_skeleton_dir` setting](/references/3.latest/configuration.html#module_skeleton_dir).

### Improvements to Resource Types

#### Package Type: Multi-Package Removal With Urpmi Provider

[(Issue 16792: permit to remove more than 1 package using urpmi provider)][16792]

It was tedious to remove some packages when using the urpmi provider since it
only allowed to remove one package at the time, and that removal must be made
in dependency order.  Now, the urpmi provider behaves similar to the apt
provider.


#### Package Type: Package Descriptions in RAL

[(Issue 19875: Get package descriptions from RAL)][19875]

Previously, rpm and dpkg provider implementations obtained package information from the system without capturing descriptions. They now capture the single line description summary for packages as a read-only parameter.

#### Package Type: OpenBSD Improvements

Jasper Lievisse Adriaanse contributed several improvements and fixes
to the OpenBSD package provider.

[(Issue 21930: Enchance OpenBSD pkg.conf handling)][21930]

It is now possible to use `+=` when defining the `installpath` for OpenBSD.
Previously, an attempt to use this was ignored; now, it's possible to have
a pkg.conf like:

    installpath = foo
    installpath += bar

Which will be turned into a `PKG_PATH: foo:bar`.

[(Issue 22021: Implement (un)install options feature for OpenBSD package provider)][22021]

It is now possible to specify `install_options` and `uninstall_options` for the
OpenBSD package provider. These were previously not available.

[(Issue 22023: Implement purgeable feature for OpenBSD package provider)][22023]

It is now possible to use the `purged` value for `ensure` with the OpenBSD package provider.


#### Yumrepo Type: AWS S3 Repos

[(Issue 21452: Add `s3_enabled` option to the yumrepo type)][21452]

It is now possible to use a yum repo stored in AWS S3 (via the yum-s3-iam
plugin) by setting the resource's `s3_enabled` attribute to `1`.


### Special thanks to 3.3.0 Contributors

Adrien Thebo, Alex Dreyer, Alexander Fortin, Alexey Lapitsky, Aman Gupta, Andrew Parker, Andy Brody, Anton Lofgren, Brice Figureau, Charlie Sharpsteen, Chris Price, Clay Caviness, David Schmitt, Dean Wilson, Duncan Phillips, Dustin J. Mitchell, Eric Sorenson, Erik Dalén, Felix Frank, Garrett Honeycutt, Henrik Lindberg, Hunter Haugen, Jasper Lievisse Adriaanse, Jeff McCune, Jeff Weiss, Jesse Hathaway, John Julien, Josh Cooper, Josh Partlow, Juan Ignacio Donoso, Kosh, Kylo Ginsberg, Mathieu Parent, Matthaus Owens, Melissa Stone, Melissa, Michael Scherer, Michal Růžička, Moses Mendoza, Neil Hemingway, Nick Fagerlund, Nick Lewis, Patrick Carlisle, Pieter van de Bruggen, Richard Clamp, Richard Pijnenburg, Richard Soderberg, Richard Stevenson, Sergey Sudakovich, Stefan Schulte, Thomas Hallgren, W. Andrew Loe III, arnoudj, floatingatoll, ironpinguin, joshrivers, phinze, superseb

### All 3.3.0 Changes

[See here for a list of all changes in the 3.3.0 release.](http://projects.puppetlabs.com/versions/401)

[22205]: http://projects.puppetlabs.com/issues/22205
[16856]: http://projects.puppetlabs.com/issues/16856
[21427]: http://projects.puppetlabs.com/issues/21427
[2628]: http://projects.puppetlabs.com/issues/2628
[18255]: http://projects.puppetlabs.com/issues/18255
[21831]: http://projects.puppetlabs.com/issues/21831
[21749]: http://projects.puppetlabs.com/issues/21749
[6561]: http://projects.puppetlabs.com/issues/6561
[20284]: http://projects.puppetlabs.com/issues/20284
[21170]: http://projects.puppetlabs.com/issues/21170
[16792]: http://projects.puppetlabs.com/issues/16792
[19875]: http://projects.puppetlabs.com/issues/19875
[21930]: http://projects.puppetlabs.com/issues/21930
[22021]: http://projects.puppetlabs.com/issues/22021
[22023]: http://projects.puppetlabs.com/issues/22023
[21452]: http://projects.puppetlabs.com/issues/21452
[22375]: http://projects.puppetlabs.com/issues/22375


Puppet 3.2.4
-----

Released August 15, 2013.

3.2.4 is a security fix release of the Puppet 3.2 series. It has no other bug fixes or new features.

### Security Fixes

#### [CVE-2013-4761 (`resource_type` Remote Code Execution Vulnerability)](http://puppetlabs.com/security/cve/cve-2013-4761/)

By using the `resource_type` service, an attacker could cause Puppet to load
arbitrary Ruby files from the puppet master server's file system. While this behavior is not
enabled by default, `auth.conf` settings could be modified to allow it. The exploit requires
local file system access to the Puppet Master.


#### [CVE-2013-4956 (Puppet Module Permissions Vulnerability)](http://puppetlabs.com/security/cve/cve-2013-4956/)

The puppet module subcommand did not correctly control permissions of modules it installed, instead transferring permissions that existed when the module was built.


Puppet 3.2.3
-----

Released July 15, 2013.

3.2.3 is a bugfix release of the Puppet 3.2 series. It fixes some Windows bugs introduced in 3.2.0, as well as a few performance problems and miscellaneous bugs.

### Windows Fixes

This release fixes several Windows bugs that couldn't be targeted for earlier 3.2 releases.

* [#20768: windows user provider can not manage password or home directory](https://projects.puppetlabs.com/issues/20768) --- This was a regression in 3.2.0/3.2.1.
* [#21043: runinterval setting in puppet.conf ignored on Windows in Puppet 3.2.1](https://projects.puppetlabs.com/issues/21043) --- This was a regression in 3.2.0/3.2.1.
* [#16080: Service provider broken in Windows Server 2012](https://projects.puppetlabs.com/issues/16080) --- This affected all previous Puppet versions.
* [#20787: 'puppet resource group' takes incredibly long on Windows](https://projects.puppetlabs.com/issues/20787) --- This affected all previous Puppet versions.
* [#20302: Windows File.executable? now returns false on ruby 1.9](https://projects.puppetlabs.com/issues/20302)
* [#21280: Don't create c:\dev\null in windows specs](https://projects.puppetlabs.com/issues/21280) --- This was only relevant to Puppet developers.

### Logging and Reporting Fixes

* [#20383: Bring back helpful error messages like prior to Puppet 3](https://projects.puppetlabs.com/issues/20383) --- This was a regression from 3.0.0, which caused file names and line numbers to disappear from duplicate resource declaration errors.
* [#20900: tagmail triggers in --onetime mode without changes after upgrade from 3.1.1 to 3.2.1](https://projects.puppetlabs.com/issues/20900) --- This was a regression in 3.2.0/3.2.1.
* [#20919: Logging behaviour issues in 3.2.1](https://projects.puppetlabs.com/issues/20919) --- This was a regression in 3.2.0/3.2.1, which caused noisy logging to the console even if the `--logdest` option was set.

### Performance Fixes

* [#21376: Stack level too deep after updating from 3.1.1 to 3.2.2](https://projects.puppetlabs.com/issues/21376) --- This would sometimes cause total failures when importing a large number of manifest files (such as with the `import nodes/*.pp` idiom).
* [#21320: Puppet daemon may sleep for 100 years after receiving USR1 on 64 bit systems](https://projects.puppetlabs.com/issues/21320) --- MCollective's Puppet plugin uses puppet agent's USR1 signal to trigger a run if the agent is running; on 64-bit systems, this could cause puppet agent to keep running, but stop doing scheduled configuration runs. This was caused by a bug in Ruby \< 2.0, but we modified Puppet to work around it.
* [#20901: `puppet --version` is unnecessarily slow](https://projects.puppetlabs.com/issues/20901) --- This was a regression in 3.2.0/3.2.1.

### Misc Fixes

* [#21264: parser = future breaks executing functions as class defaults](https://projects.puppetlabs.com/issues/21264)

### All 3.2.3 Changes

[See here for a list of all changes in the 3.2.3 release.](https://projects.puppetlabs.com/versions/410)

Puppet 3.2.2
-----

3.2.2 is a security fix release of the Puppet 3.2 series. It has no other bug fixes or new features.

### Security Fix

*[CVE-2013-3567 Unauthenticated Remote Code Execution Vulnerability](http://puppetlabs.com/security/cve/cve-2013-3567/).*

A critical vulnerability was found in puppet wherein it was possible for the puppet master to take YAML from an untrusted client via the REST API. This YAML could be deserialized to construct an object containing arbitrary code.

Puppet 3.2.1
-----

3.2.1 is a bugfix release of the Puppet 3.2 series. It addresses two major
issues that were uncovered in 3.2.0 and caused us to pull that release (#20726 and #20742). It also includes a fix for Solaris support (#19760).

Issues fixed:

* [Bug #19760](https://projects.puppetlabs.com/issues/19760): install sun packages failed with: `Error: /Stage[main]/Inf_sol10defaultpkg/Package[SMCcurl]: Could not evaluate: Unable to get information about package SMCcurl because of: No message`
* [Bug #20726](https://projects.puppetlabs.com/issues/20726): usermod command arguments out of order
* [Bug #20742](https://projects.puppetlabs.com/issues/20742): unauthenticated clients unable to communicate with puppet master (running in passenger)

### Known Regressions

On Windows, Puppet 3.2.1 is unable to manage the home directory for a user account. ([Bug #20768](https://projects.puppetlabs.com/issues/20768)) This is a regression from Puppet 3.1.1; it was introduced by switching to Ruby 1.9 in the Windows .msi package. This bug will be fixed soon in a point release, but wasn't severe enough to delay shipping.

### All 3.2.1 Changes

[See here for a list of all changes in the 3.2.1 release.][321_changes]

[321_changes]: https://projects.puppetlabs.com/versions/405

## Puppet 3.2.0

3.2.0 is a backward-compatible features and fixes release in the Puppet 3 series. It was never officially released, as major bugs were discovered after the release was tagged but before it was published; 3.2.1 was the first official Puppet 3.2 release.

The most notable changes are:

* An optional, experimental "Future" parser
* Ruby 2.0 support
* OpenWRT OS support
* External CA support
* A new modulo (`%`) operator
* New slow catalog profiling capabilities
* General improvements and fixes, including improved splay behavior, fixes to the cron type, improvements to the module tool, and some Hiera-related fixes

> **Ruby Bug Warning:** Ruby 1.9.3-p0 has bugs that cause a number of known issues with Puppet 3.2.0 and later, and you should use a different release. To the best of our knowledge, these issues were fixed in the second public release of Ruby 1.9.3 (p125), and we are positive they are resolved in p392 (which ships with Fedora 18). Unfortunately, Ubuntu Precise ships with p0 for some reason, and there's not a lot we can do about it. If you're using Precise, we recommend using Puppet Enterprise or installing a third-party Ruby package.

### Experimental "Future" Parser With Iteration

In a first for Puppet, we're shipping two versions of the Puppet language in one release.

- [Language: Experimental Features (Puppet 3.2)][32experimental]
- Demonstration: [Revision of the puppet-network module][experimentalcommit] using experimental features ([GitHub home][experimentalmodule] for the revised module)

By default, Puppet 3.2 is backward compatible with Puppet 3.1, with only minimal new language features (the modulo operator). However, if you set `parser = future` in puppet.conf, you can try out new, proposed language features like iteration (as defined in [arm-2][arm2]). See the documents linked above for complete details.

Note that **features in the experimental parser are exempt from semantic versioning.** They might change several times before being released in the "current" parser.

[arm2]: https://github.com/puppetlabs/armatures/tree/master/arm-2.iteration
[32experimental]: /puppet/3/reference/lang_experimental_3_2.html
[experimentalmodule]: https://github.com/hlindberg/puppet-network
[experimentalcommit]: https://github.com/hlindberg/puppet-network/commit/b1665a2da730e31b76a9230796510d01e6a626d7

(Issues [19983][] and [11331][])

### Ruby 2.0 Support

> Special thanks to: Dominic Cleal.

Previous releases almost worked on Ruby 2.0; this one officially works.

(Issue [18494][])

### OpenWRT OS Support

> Special thanks to: Kyle Anderson.

OpenWRT is a distribution of Linux that runs on small consumer-grade routers, and you can now manage more of it with Puppet. This requires **Facter 1.7.0-rc1 or later,** as well as Puppet 3.2. Puppet Labs doesn't ship any packages for OpenWRT.

New OpenWRT support includes:

- Facter values:
    - `operatingsystem` and `osfamily` will report as `OpenWrt`
    - `operatingsystemrelease` will resolve correctly, by checking the `/etc/openwrt_version` file
    - General Linux facts will generally resolve as expected.
- Packages:
    - The new `opkg` provider can install packages and dependencies from the system repositories (set in `/etc/opkg.conf`), can ensure specific package versions, and can install packages from files.
- Services:
    - The new `openwrt` provider can enable/disable services on startup, as well as ensuring started/stopped states. Since OpenWRT init scripts don't have status commands, it uses the system process table to detect status; if a service's process name doesn't match the init script name, be sure to specify a `status` or `pattern` attribute in your resources.

(Issue [19877][])


### External CA Support

> Special thanks to: Dustin Mitchell.

* [Puppet 3 reference manual: using an external CA][external_ca].

We now officially support using an external certificate authority with Puppet. See the documentation linked above for complete details.

If you were stalled on 2.7.17 due to [bug 15561][15561], upgrading to 3.2 should fix your problems.

[external_ca]: /puppet/3/reference/config_ssl_external_ca.html

(Issues [15561][], [17864][], [19271][], and [20027][])

### Modulo Operator

> Special thanks to: Erik Dalén.

The new [`%` modulo operator][32modulo_operator] will return the remainder of dividing two values.

(Issue [18950][])


### Better Profiling and Debugging of Slow Catalog Compilations

> Special thanks to: Andy Parker and Chris Price.

If you set [the `profile` setting][32profiling_setting] to `true` in  an agent node's puppet.conf (or specify `--profile` on the command line), the puppet master will log additional debug-level messages about how much time each step of its catalog compilation takes.

If you're trying to profile, be sure to check the `--logdest` and `--debug` command-line options on the master --- debug must be on, and messages will go to the log destination, which defaults to syslog. If you're running via Passenger or another Rack server, these options will be set in the config.ru file.

To find the messages, look for the string `PROFILE` in the master's logs --- each catalog request will get a unique ID, so you can tell which messages are for which request.

(Issue [17190][])

### General Improvements and Fixes

#### Splay Fixes for Puppet Agent

The [`splay` setting][32splay] promised relief from thundering-herd problems, but it was broken; the agents would splay on their first run, then they'd all sync up on their second run. That's fixed now.

(Issues [14766][] and [18211][])

#### Cron Fixes

> Special thanks to: Felix Frank, Stefan Schulte, and Charlie Sharpsteen.

The [cron resource type][32cron_type] is now much better behaved, and some truly ancient bugs are fixed.

(Issues [593][], [656][], [1453][], [2251][], [3047][], [5752][], [16121][], [16809][], [19716][], and [19876][])

#### Module Tool Improvements

The `puppet module` command no longer misbehaves on systems without GNU `tar` installed, and it works on Windows now.

(Issues [11276][], [13542][], [14728][], [18229][], [19128][], [19409][], and [15841][])

#### Hiera-Related Fixes

The [`calling_module` and `calling_class` pseudo-variables][hiera_pseudo] were broken, and [automatic parameter lookup][32hiera_auto_param] would die when it found `false` values. These bugs are both fixed.

[hiera_pseudo]: /hiera/1/puppet.html#special-pseudo-variables

(Issues [14985][] and [17474][])


#### `puppet:///` URIs Pointing to Symlinks Work Now

> Special thanks to: Chris Boot.

In older versions, a `source => puppet:///.....` URI pointing to a symlink on the puppet master would fail annoyingly. Now Puppet follows the symlink and serves the linked content.

(Issue [7680][])


#### Puppet Apply Writes Data Files Now

> Special thanks to: R.I. Pienaar.

Puppet apply now writes the classes file and resources file. If you run a masterless Puppet site, you can now integrate with systems like MCollective that use these files.

(Issue [14544][])


### All 3.2.0 Changes

[See here for a list of all non-trivial changes for the 3.2.0 release.][32issues]

## Puppet 3.1.1

Puppet 3.1.1 is a **security release** addressing several vulnerabilities discovered in the 3.x line of Puppet. These
vulnerabilities have been assigned Mitre CVE numbers [CVE-2013-1640][], [CVE-2013-1652][], [CVE-2013-1653][], [CVE-2013-1654][], [CVE-2013-1655][] and [CVE-2013-2275][].

All users of Puppet 3.1.0 and earlier are strongly encouraged to upgrade to 3.1.1.

### Puppet 3.1.1 Downloads

* Source: <https://downloads.puppetlabs.com/puppet/puppet-3.1.1.tar.gz>
* Windows package: <https://downloads.puppetlabs.com/windows/puppet-3.1.1.msi>
* RPMs: <https://yum.puppetlabs.com/el> or `/fedora`
* Debs: <https://apt.puppetlabs.com>
* Mac package: <https://downloads.puppetlabs.com/mac/puppet-3.1.1.dmg>
* Gems are available via rubygems at <https://rubygems.org/downloads/puppet-3.1.1.gem> or by using `gem
install puppet --version=3.1.1`

See the Verifying Puppet Download section at:
<https://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet>

Please report feedback via the Puppet Labs Redmine site, using an affected puppet version of 3.1.1:
<http://projects.puppetlabs.com/projects/puppet/>

### Puppet 3.1.1 Changelog

* Andrew Parker (3):
     * (#14093) Cleanup tests for template functionality
     * (#14093) Remove unsafe attributes from TemplateWrapper
     * (#14093) Restore access to the filename in the template

* Jeff McCune (2):
     * (#19151) Reject SSLv2 SSL handshakes and ciphers
     * (#19531) (CVE-2013-2275) Only allow report save from the node matching the certname

* Josh Cooper (7):
     * Fix module tool acceptance test
     * Run openssl from windows when trying to downgrade master
     * Remove unnecessary rubygems require
     * Don't assume puppetbindir is defined
     * Display SSL messages so we can match our regex
     * Don't require openssl client to return 0 on failure
     * Don't assume master supports SSLv2

* Justin Stoller (6):
     * Acceptance tests for CVEs 2013 (1640, 1652, 1653, 1654,2274, 2275)
     * Separate tests for same CVEs into separate files
     * We can ( and should ) use grep instead of grep -E
     * add quotes around paths for windows interop
     * remove tests that do not run on 3.1+
     * run curl against the master on the master

* Moses Mendoza (1):
     * Update PUPPETVERSION for 3.1.1

* Nick Lewis (3):
     * (#19393) Safely load YAML from the network
     * Always read request body when using Rack
     * Fix order-dependent test failure in network/authorization_spec

* Patrick Carlisle (3):
     * (#19391) (CVE-2013-1652) Disallow use\_node compiler parameter for remote requests
     * (#19392) (CVE-2013-1653) Validate instances passed to indirector
     * (#19392) Don't validate key for certificate_status

* Pieter van de Bruggen (1):
     * Updating module tool acceptance tests with new expectations.


## Puppet 3.1.0

For a full description of all the major changes in Puppet 3.1, please see the list of [new features in Puppet 3.1][new_in_31].

### All Bugs Fixed in 3.1.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.1.0][target_310] (approx. 53)


## Puppet 3.0.2

3.0.2 Target version and resolved issues: <https://projects.puppetlabs.com/versions/337>

## Puppet 3.0.1

3.0.1 Target version and resolved issues: <https://projects.puppetlabs.com/versions/328>

## Puppet 3.0.0

For a full description of the Puppet 3 release, including major changes, backward incompatibilities, and focuses of development, please see the [long-form Puppet 3 "What's New" document](./whats_new.html).

### All Bugs Fixed in 3.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.0.0][target_300] (approx. 220)


