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

This page documents the history of the Puppet 3 series.

Starting from version 3.0.0, Puppet is semantically versioned with a three-part version number. In version X.Y.Z:

* X must increase for major backwards-incompatible changes.
* Y may increase for backwards-compatible new functionality.
* Z may increase for bug fixes.

> **Note:** When preparing to upgrade, please read our [general recommendations for upgrading between two major versions of Puppet][upgrade], which include suggested roll-out plans and package management practices. In general, upgrade the puppet master servers before upgrading the agents they support.
>
> Also, before upgrading, look above at the _table of contents_ for this page. Identify the version you're upgrading TO and any versions you're upgrading THROUGH, and check them for a subheader labeled "Upgrade Warning," which will always be at the top of that version's notes. If there's anything special you need to know before upgrading, we will put it here.


Puppet 3.3.1
-----

Released October 7, 2013.

3.3.1 is a bug fix release in the Puppet 3.3 series. The focus of the release is fixing backwards compatibility regressions that slipped in via the YAML deprecations in 3.3.0.

### Upgrade Note

The release of Puppet 3.3.1 supersedes the upgrade warning for Puppet 3.3.0. As of this release, agent nodes are compatible with all Puppet 3.x masters with no extra configuration.

### Fixes for Backwards Compatibility Regressions in 3.3.0

[331_compat]: #fixes-for-backwards-compatibility-regressions-in-330

* [Issue 22535: puppet 3.3.0 ignores File ignore in recursive copy][22535]
* [Issue 22608: filebucket (backup) does not work with 3.3.0 master and older clients][22608]
* [Issue 22530: Reports no longer work for clients older than 3.3.0 when using a 3.3.0 puppet master][22530]
* [Issue 22652: ignore doesn't work if pluginsync enabled][22652]

New backward compatibility issues were discovered after the release of 3.3.0, so we changed our handling of deprecated wire formats.

Starting with 3.3.1, you do not need to set additional settings in puppet.conf on your agent nodes in order to use newer agents with puppet masters running 3.2.4 or earlier. Agents will work with all 3.x masters, and they will automatically negotiate wire formats as needed. This behavior supersedes [the behavior described for 3.3.0][yaml_deprecation]; the `report_serialization_format` setting is now unnecessary.

Additionally, this release fixes:

* Two cases where 3.3.0 masters would do the wrong thing with older agents. (Reports would fail unless the master had `report_serialization_format` set to `yaml`, which was not intended, and remote filebucket backups would always fail.)
* A regression where files that should have been ignored during pluginsync were being copied to agents.

### Miscellaneous Regression Fixes

[22772]: http://projects.puppetlabs.com/issues/22772

[Issue 22772: Managing an empty file causes a filebucket error][22772]

This was a regression in 3.3.0, caused by deprecating YAML for content we send to remote filebuckets.

[Issue 22384: Excessive logging for files not found][22384]

This was a regression in 3.3.0.

When using multiple values in an array for the file type's `source` attribute, Puppet will check them in order and use the first one it finds; whenever it doesn't find one, it will log a note at the "info" log level, which is silent when logging isn't verbose. In 3.3.0, the level was accidentally changed to the "notice" level, which was too noisy.

[Issue 22529: apt package ensure absent/purged causes warnings on 3.3.0][22529]

This was a regression in 3.3.0. The `apt` package provider was logging bogus warnings when processing resources with `ensure` values of `absent` or `purged`.

[Issue 22493: Can't start puppet agent on non english Windows][22493]

This problem was probably introduced in Puppet 3.2, when our Windows installer switched to Ruby 1.9; a fix was attempted in 3.2.4, but it wasn't fully successful.

The behavior was caused by a bug in one of the Ruby libraries Puppet relies on. We submitted a fix upstream, and packaged a fixed version of the gem into the Windows installer.


### Fixes for Long-Standing Bugs

[Issue 19994: ParsedFile providers do not clear failed flush operations from their queues][19994]

This bug dates to Puppet 2.6 or earlier.

The bug behavior was weird. Basically:

* Your manifests include multiple `ssh_authorized_key` resources for multiple user accounts.
* _One_ of the users has messed-up permissions for their authorized keys file, and their resource fails because Puppet tries to write to the file as that user.
* _All remaining key resources_ also fail, because Puppet tries to write the rest of them to that same user's file instead of the file they were _supposed_ to go in.

[Issue 21975: Puppet Monkey patch `'def instance_variables'` clashing with SOAP Class...][21975]

This bug dates to 3.0.0. It was causing problems when using plugins that use SOAP libraries, such as the types and providers in the puppetlabs/f5 module.

[Issue 22474: `--no-zlib` flag doesn't prevent zlib from being required in Puppet][22474]

This bug dates to 3.0.0, and caused Puppet to fail when running on a copy of Ruby without zlib compiled in.

[Issue 22471: Malformed state.yaml causes puppet to fail runs with Psych yaml parser][22471]

This bug dates to 3.0.0, and could cause occasional agent run failures under Ruby 1.9 or 2.0.

[22535]: http://projects.puppetlabs.com/issues/22535
[22608]: http://projects.puppetlabs.com/issues/22608
[22530]: http://projects.puppetlabs.com/issues/22530
[19994]: http://projects.puppetlabs.com/issues/19994
[21975]: http://projects.puppetlabs.com/issues/21975
[22474]: http://projects.puppetlabs.com/issues/22474
[22471]: http://projects.puppetlabs.com/issues/22471
[22384]: http://projects.puppetlabs.com/issues/22384
[22529]: http://projects.puppetlabs.com/issues/22529
[22493]: http://projects.puppetlabs.com/issues/22493
[22652]: http://projects.puppetlabs.com/issues/22652

Puppet 3.3.0
-----

Released September 12, 2013.

3.3.0 is a backward-compatible feature and fix release in the Puppet 3 series.

### Upgrade Warning (Superseded by Puppet 3.3.1)

> **Note:** The following is superseded by [compatibility improvements in Puppet 3.3.1][331_compat], which requires no configuration to work with older masters. If possible, you should upgrade directly to 3.3.1 instead of 3.3.0.

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

> **Note:** The following is superseded by [compatibility improvements in Puppet 3.3.1][331_compat], which requires no configuration to work with older masters. If possible, you should upgrade directly to 3.3.1 instead of 3.3.0.

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

> **Ruby Bug Warning:** Ruby 1.9.3-p0 has bugs that cause a number of known issues with Puppet 3.2.0 and later, and you should use a different release. To the best of our knowledge, these issues were fixed in the second public release of Ruby 1.9.3 (p125), and we are positive they are resolved in p392 (which ships with Fedora 18). Unfortunately, Ubuntu Precise ships with p0 for some reason if you choose the system 1.9.3 package, and there's not a lot we can do about it. If you're using Precise and want to use Ruby 1.9.3, we recommend using Puppet Enterprise or installing a third-party Ruby package.

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


Puppet 3.1.0
-----

Puppet 3.1.0 is a features and fixes release in the 3.x series, focused on adding documentation and cleaning up extension loading.

### New: YARD API Documentation

To go along with the improved usability of Puppet as a library, we've added [YARD documentation](http://yardoc.org) throughout the codebase. YARD generates browsable code documentation based on in-line comments. This is a first pass through the codebase but about half of it's covered now. To use the YARD docs, simply run `gem install yard` then `yard server --nocache` from inside a puppet source code checkout (the directory containing `lib/puppet`). YARD documentation is also available in the [generated references section](/references/3.stable/index.html) under [Developer Documentation](/references/3.stable/developer/).


### Fix: YAML Node Cache Restored on Master

In 3.0.0, we inadvertently removed functionality that people relied upon to get a list of all the nodes checking into a particular puppet master. This is now enabled for good, added to the test harness, and available for use as:

    # shell snippet
    export CLIENTYAML=`puppet master --configprint yamldir`
    puppet node search "*" --node_terminus yaml --clientyamldir $CLIENTYAML

### Improvements When Loading Ruby Code

A major area of focus for this release was loading extension code. As people wrote and distributed Faces (new puppet subcommands that extend Puppet's capabilities), bugs like [#7316](https://projects.puppetlabs.com/issues/7316) started biting them. Additionally, seemingly simple things like retrieving configuration file settings quickly got complicated, causing problems both for Puppet Labs' code like Cloud Provisioner as well as third-party integrations like Foreman. The upshot is that it's now possible to fully initialize puppet when using it as a library, loading Ruby code from Forge modules works correctly, and tools like puppetlabs_spec_helper now work correctly.


### All Bugs Fixed in 3.1.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.1.0][target_310] (approx. 53)


## Puppet 3.0.2

3.0.2 Target version and resolved issues: <https://projects.puppetlabs.com/versions/337>

## Puppet 3.0.1

3.0.1 Target version and resolved issues: <https://projects.puppetlabs.com/versions/328>

## Puppet 3.0.0

Puppet 3.0.0 is the first release of the Puppet 3 series, which includes breaking changes, new features, and bug fixes.

### Upgrade Warning: Many Breaking Changes

Puppet 3.0.0 is a release on a [major version boundary](#improved-version-numbering), which means it contains breaking changes that make it incompatible with Puppet 2.7.x. These changes are listed below, and their headers begin with a "BREAK" label. You should read through them and determine which will apply to your installation.

### Improved Version Numbering

Puppet 3 marks the beginning of a new version scheme for Puppet releases. Beginning with 3.0.0, Puppet uses a strict three-field version number:

* The leftmost segment of the version number must increase for major backwards-incompatible changes.
* The middle segment may increase for backwards-compatible new functionality.
* The rightmost segment may increase for bug fixes.

### BREAK: Changes to Dependencies and Supported Systems

* Puppet 3 adds support for Ruby 1.9.3, and drops support for Ruby 1.8.5. (Puppet Labs is publishing Ruby 1.8.7 packages in its repositories to help users who are still on RHEL and CentOS 5.)
    * Note that `puppet doc` is only supported on Ruby 1.8.7, due to 1.9's changes to the underlying RDoc library. See [ticket # 11786](http://projects.puppetlabs.com/issues/11786) for more information.
* [Hiera][] is now a dependency of Puppet.
* Puppet now requires Facter 1.6.2 or later.
* Support for Mac OS X 10.4 has been dropped.

### BREAK: Dynamic Scope for Variables is Removed

Dynamic scoping of variables, which was deprecated in Puppet 2.7, has been removed. See [Language: Scope][lang_scope] for more details. The most recent 2.7 release logs warnings about any variables in your code that are still being looked up dynamically.

> **Upgrade note:** Before upgrading from Puppet 2.x, you should do the following:
>
> * Restart your puppet master --- this is necessary because deprecation warnings are only produced once per run, and warnings that were already logged may not appear again in your logs until a restart.
> * Allow all of your nodes to check in and retrieve a catalog.
> * Examine your puppet master's logs for dynamic scope warnings.
> * Edit any manifests referenced in the warnings to remove the dynamic lookup behavior. Use [fully qualified variable names][qualified_vars] where necessary, and move makeshift data hierarchies out of your manifests and into [Hiera][].

### BREAK: Parameters In Definitions Must Be Variables

Parameter lists in class and defined type **definitions** must include a dollar sign (`$`) prefix for each parameter. In other words, parameters must be styled like variables. Non-variable-like parameter lists have been deprecated since at least Puppet 0.23.0.

The syntax for class and defined resource **declarations** is unchanged.

Right:

    define vhost ($port = 80, $vhostdir) { ... }

Wrong:

    define vhost (port = 80, vhostdir) { ... }

Unchanged:

    vhost {'web01.example.com':
      port     => 8080,
      vhostdir => '/etc/apache2/conf.d',
    }

### BREAK: Deprecated Commands Are Removed

The legacy standalone executables, which were replaced by subcommands in Puppet 2.6, have been removed. Additionally, running `puppet` without a subcommand no longer defaults to `puppet apply`.


Pre-2.6       | Post-2.6
--------------|--------------
puppetmasterd | puppet master
puppetd       | puppet agent
puppet        | puppet apply
puppetca      | puppet cert
ralsh         | puppet resource
puppetrun     | puppet kick
puppetqd      | puppet queue
filebucket    | puppet filebucket
puppetdoc     | puppet doc
pi            | puppet describe

> **Upgrade note:** Examine your Puppet init scripts, the configuration of the puppet master's web server, and any wrapper scripts you may be using, and ensure that they are using the new subcommands instead of the legacy standalone commands.

### BREAK: Puppet Apply's `--apply` Option Is Removed

The `--apply` option has been removed. It was replaced by `--catalog`.

### BREAK (Partially Reverted in 3.0.2): Console Output Formatting Changes

The format of messages displayed to the console has changed slightly, potentially leading to scripts that watch these messages breaking. Additionally, we now use STDERR appropriately on \*nix platforms.

> **Upgrade Note:** If you scrape Puppet's console output, revise the relevant scripts. Note that some of these changes were reverted in 3.0.2.

This does not change the formatting of messages logged through other channels (eg: syslog, files), which remain as they were before. [See bug #13559 for details](https://projects.puppetlabs.com/issues/13559)

### BREAK: Removed and Modified Settings

The following settings have been removed:

* `factsync` (Deprecated since Puppet 0.25 and replaced with `pluginsync`; see [ticket #2277](http://projects.puppetlabs.com/issues/2277))
* `ca_days` (Replaced with `ca_ttl`)
* `servertype` (No longer needed, due to [removal of built-in Mongrel support](#special-case-mongrel-support-is-removed))
* `downcasefact` (Long-since deprecated)
* `reportserver` (Long-since deprecated; replaced with `report_server`)


The following settings now behave differently:

* `pluginsync` is now enabled by default
* `cacrl` can no longer be set to `false`. Instead, Puppet will now ignore the CRL if the file in this setting is not present on disk.

### BREAK: Puppet Master Rack Configuration Is Changed

Puppet master's `config.ru` file has changed slightly; see `ext/rack/files/config.ru` in the Puppet source code for an updated example. The new configuration:

* Should now require `'puppet/util/command_line'` instead of `'puppet/application/master'`.
* Should now run `Puppet::Util::CommandLine.new.execute` instead of `Puppet::Application[:master].run`.
* Should explicitly set the `--confdir` option (to avoid reading from `~/.puppet/puppet.conf`).

{% highlight diff %}
    diff --git a/ext/rack/files/config.ru b/ext/rack/files/config.ru
    index f9c492d..c825d22 100644
    --- a/ext/rack/files/config.ru
    +++ b/ext/rack/files/config.ru
    @@ -10,7 +10,25 @@ $0 = "master"
     # ARGV << "--debug"

     ARGV << "--rack"
    +ARGV << "--confdir" << "/etc/puppet"
    +
    -require 'puppet/application/master'
    +require 'puppet/util/command_line'

    -run Puppet::Application[:master].run
    +run Puppet::Util::CommandLine.new.execute
    +
{% endhighlight %}

> **Upgrade note:** If you run puppet master via a Rack server like Passenger, you **must** change the `config.ru` file as described above.

### BREAK: Special-Case Mongrel Support Is Removed; Use Rack Instead

Previously, the puppet master had special-case support for running under Mongrel. Since Puppet's standard Rack support can also be used with Mongrel, this redundant code has been removed.

> **Upgrade note:** If you are using Mongrel to run your puppet master, re-configure it to run Puppet as a standard Rack application.

### BREAK: File Type Changes

* The `recurse` parameter can no longer set recursion depth, and must be set to `true`, `false`, or `remote`. Use the `recurselimit` parameter to set recursion depth. (Setting depth with the `recurse` parameter has been deprecated since at least Puppet 2.6.8.)

### BREAK: Mount Type Changes

* The `path` parameter has been removed. It was deprecated and replaced by `name` sometime before Puppet 0.25.0.

### BREAK: Package Type Changes

* The `type` parameter has been removed. It was deprecated and replaced by `provider` some time before Puppet 0.25.0.
* The `msi` provider has been deprecated in favor of the more versatile `windows` provider.
* The `install_options` parameter for Windows packages now accepts an array of mixed strings and hashes; however, it remains backwards-compatible with the 2.7 single hash format.
* A new `uninstall_options` parameter was added for Windows packages. It uses the same semantics as `install_options`.

### BREAK: Exec Type Changes

* The `logoutput` parameter now defaults to `on_failure`.
* Due to misleading values, the `HOME` and `USER` environment variables are now unset when running commands.

### BREAK: Deprecated `check` Metaparameter Is Removed

* The `check` metaparameter has been removed. It was deprecated and replaced by `audit` in Puppet 2.6.0.

### BREAK: Puppet Agent Now Requires `node` Access in Master's `auth.conf`

Puppet agent nodes now requires access to their own `node` object on the puppet master; this is used for making ENC-set environments authoritative over agent-set environments. Your puppet master's auth.conf file must contain the following stanza, or else agent nodes will not be able to retrieve catalogs:

    # allow nodes to retrieve their own node object
    path ~ ^/node/([^/]+)$
    method find
    allow $1

Auth.conf has allowed this by default since 2.7.0, but puppet masters which have been upgraded from previous versions may still be disallowing it.

> **Upgrade note:** Check your auth.conf file and make sure it includes the above stanza **before** the final stanza. Add it if necessary.

### BREAK: `auth no` in `auth.conf` Is Now the Same as `auth any'

Previously, `auth no` in [auth.conf][auth_conf] would reject connections with valid certificates. This was confusing, and the behavior has been removed; `auth no` now allows any kind of connection, same as `auth any`.


### BREAK: `auth.conf`'s `allow` Directive Rejects IP Addresses; Use `allow_ip` Instead

To allow hosts based on IP address, use the new `allow_ip` directive. It functions exactly like IP addresses in `allow` used to, except that it does not support backreferences. The `allow` directive now assumes that the string is not an IP address.

> **Upgrade Note:** If your `auth.conf` allowed any specific nodes by IP address, you must replace those `allow` directives with `allow_ip`.

### BREAK: `fileserver.conf` Cannot Control Access By IP; Use `auth.conf` Instead

The above fix to ambiguous ACLs in `auth.conf` caused authorization by IP address in `fileserver.conf` to break. We are opting not to fix it, in favor of centralizing our authorization interfaces.

All authorization rules in `fileserver.conf` can be reproduced in auth.conf instead, as access must pass through auth.conf before reaching fileserver.conf. If you need to control access to custom fileserver mount points by IP address, set the rule in fileserver.conf to `allow *`, and create rules in `auth.conf` like the following:

    path ~ ^/file_(metadata|content)s?/my_custom_mount_point/
    auth yes
    allow /^(.+\.)?example.com$/
    allow_ip 192.168.100.0/24

Rules like these must go above the rule for `/file/`. Note that you must control both the `file_metadata(s)` and `file_content(s)` paths; the regular expression above should do the trick.

### BREAK: "Resource Type" API Has Changed

The API for querying resource types has changed to more closely match standard Puppet terminology.  This is most likely to be visible to any external tools that were using the HTTP API to query for information about resource types.

* You can now add a `kind` option to your request, which will allow you to filter results by one of the following kinds of resource types: `class`, `node`, `defined_type`.
* The API would previously return a field called `type` for each result; this has been changed to `kind`.
* The API would previously return the value `hostclass` for the `type` field for classes; this has been changed to `class`.
* The API would previously return the value `definition` for the `type` field for classes; this has been changed to `defined_type`.
* The API would previously return a field called `arguments` for any result that contained a parameter list; this has been changed to `parameters`.

An example of the new output:

    [
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/init.pp",
        "name": "resource_type_foo",
        "kind": "class"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_parameterized_class.pp",
        "parameters": {
          "param1": null,
          "param2": "\"default2\""
        },
        "name": "resource_type_foo::my_parameterized_class",
        "kind": "class"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_defined_type.pp",
        "parameters": {
          "param1": null,
          "param2": "\"default2\""
        },
        "name": "resource_type_foo::my_defined_type",
        "kind": "defined_type"
      },
      {
        "line": 1,
        "file": "/home/cprice/work/puppet/test/master/conf/modules/resource_type_foo/manifests/my_node.pp",
        "name": "my_node",
        "kind": "node"
      }
    ]

### BREAK: Deprecated XML-RPC Support Is Entirely Removed

XML-RPC support has been removed entirely, in favor of the HTTP API introduced in 2.6. XML-RPC support has been deprecated since 2.6.0.



### BREAK: Changes to Ruby API, Including Type and Provider Interface

The following hard changes have been made to Puppet's internal Ruby API:

* **Helper code:** `String#lines` and `IO#lines` revert to standard Ruby semantics. Puppet used to emulate these methods to accomodate ancient Ruby versions, and its emulation was slightly inaccurate. We've stopped emulating them, so they now include the separator character (`$/`, default value `\n`) in the output and include content where they previously wouldn't.
* **Functions:** Puppet functions called from Ruby code (templates, other functions, etc.) must be called with an **array of arguments.** Puppet has always expected this, but was not enforcing it. See [ticket #15756](https://projects.puppetlabs.com/issues/15756) for more information.
* **Faces:** The `set_default_format` method has been removed. It had been deprecated and replaced by `render_as`.
* **Resource types:** The following methods for type objects have been removed: `states`, `newstate`, `[ ]`, `[ ]=`, `alias`, `clear`, `create`, `delete`, `each`, and `has_key?`.
* **Providers:** The `mkmodelmethods` method for provider objects has been removed. It was replaced with `mk_resource_methods`.
* **Providers:** The `LANG`, `LC_*`, and `HOME` environment variables are now unset when providers and other code execute external commands.

The following Ruby methods are now deprecated:

* **Applications:** The `Puppet::Application` class's `#should_parse_config`, `#should_not_parse_config`, and `#should_parse_config?` methods are now deprecated, and will be removed in a future release. They are no longer necessary for individual applications and faces, since Puppet now automatically determines when the config file should be re-parsed.


### BREAK: Changes to Agent Lockfile Behavior

Puppet agent now uses two lockfiles instead of one:

* The run-in-progress lockfile (configured with the `agent_catalog_run_lockfile` setting) is present if an agent catalog run is in progress. It contains the PID of the currently running process.
* The disabled lockfile (configured with the `agent_disabled_lockfile` setting) is present if the agent was disabled by an administrator. The file is a JSON hash which **may** contain a `disabled_message` key, whose value should be a string with an explanatory message from the administrator.

### BREAK: Non-Administrator Windows Data Directory Is Changed

When running as a non-privileged user (i.e. not an Administrator), the location of Puppet's data directory has changed. Previously, it was in `~/.puppet`, but it is now located in the Local Application Data directory following Microsoft best-practices for per-user, non-roaming data. The location of the directory is contained in the `%LOCALAPPDATA%` environment variable, which on Windows 2003 and earlier is: `%USERPROFILE%\Local Settings\Application Data` On Windows Vista and later: `%USERPROFILE%\AppData\Local`

### DEPRECATION: Ruby DSL is Deprecated

The [Ruby DSL that was added in Puppet 2.6](http://projects.puppetlabs.com/projects/puppet/wiki/Ruby_Dsl) (and then largely ignored) is deprecated. Deprecation warnings have been added to Puppet 3.1.

### Automatic Data Bindings for Class Parameters

When you declare or assign classes, Puppet now automatically looks up parameter values in Hiera. See [Classes][] for more details.

### Hiera Functions Are Available in Core

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are now included in Puppet core. If you previously installed these functions with the `hiera-puppet` package, you may need to uninstall it before upgrading.

### Major Speed Increase

Puppet 3 is faster than Puppet 2.6 and _significantly_ faster than Puppet 2.7. The exact change will depend on your site's configuration and Puppet code, but many 2.7 users have seen up to a 50% improvement.


### Solaris Improvements

* Puppet now supports the ipkg format, and is able to "hold" packages (install without activating) on Solaris.
* Zones support is fixed.
* Zpool support is significantly improved.


### Rubygem Extension Support

Puppet can now load extensions (including subcommands) and plugins (custom types/providers/functions) from gems. See [ticket #7788](https://projects.puppetlabs.com/issues/7788) for more information.

### Puppet Agent Is More Efficient in Daemon Mode

Puppet agent now forks a child process to run each catalog. This allows it to return memory to system more efficiently when running in daemon mode, and should reduce resource consumption for users who don't run puppet agent from cron.

### `puppet parser validate` Will Read From STDIN

Piped content to `puppet parser validate` will now be read and validated, rather than ignoring it and requiring a file on disk.

### The HTTP Report Processor Now Supports HTTPS

Use an `https://` URL in the `report_server` setting to submit reports to an HTTPS server.

### The `include` Function Now Accepts Arrays

Formerly, it would accept a comma separated list but would fail on arrays. This has been remedied.

### `unless` Statement

Puppet now has [an `unless` statement][unless].

### Puppet Agent Can Use DNS SRV Records to Find Puppet Master

> **Note:** This feature is meant for certain unusual use cases; if you are wondering whether it will be useful to you, the answer is probably "No, use [round-robin DNS or a load balancer](/guides/scaling_multiple_masters.html) instead."

Usually, agent nodes use the `server` setting from puppet.conf to locate their puppet master, with optional `ca_server` and `report_server` settings for centralizing some kinds of puppet master traffic.

If you set [`use_srv_records`](/references/latest/configuration.html#usesrvrecords) to `true`, agent nodes will instead use DNS SRV records to attempt to locate the puppet master. These records must be configured as follows:

Server                       | SRV record
-----------------------------|-----------------------------
Puppet master                | `_x-puppet._tcp.$srv_domain`
CA server (if different)     | `_x-puppet-ca._tcp.$srv_domain`
Report server (if different) | `_x-puppet-report._tcp.$srv_domain`
File server\* (if different) | `_x-puppet-fileserver._tcp.$srv_domain`

The [`srv_domain`](/references/latest/configuration.html#srvdomain) setting can be used to set the domain the agent will query; it defaults to the value of the [domain fact](/facter/latest/core_facts.html#domain). If the agent doesn't find an SRV record or can't contact the servers named in the SRV record, it will fall back to the `server`/`ca_server`/`report_server` settings from puppet.conf.

\* (Note that the file server record is somewhat dangerous, as it overrides the server specified in **any** `puppet://` URL, not just URLs that use the default server.)


### All Bugs Fixed in 3.0.0

Use the Puppet issue tracker to find every bug fixed in a given version of Puppet.

* [All bugs fixed in 3.0.0][target_300] (approx. 220)

