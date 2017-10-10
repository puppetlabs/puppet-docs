---
layout: default
title: "Puppet 4.3 Release Notes"
---

[puppet lookup]: ./lookup_quick.html

This page lists the changes in Puppet 4.3 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y can increase for backwards-compatible new functionality
* Z can increase for bug fixes

## If You're Upgrading from Puppet 3.x

Read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.2 release notes](/puppet/4.2/release_notes.html) and [Puppet 4.1 release notes](/puppet/4.1/release_notes.html).

## Puppet 4.3.2

Released January 25, 2016.

Puppet 4.3.2 is a bug fix release.

* [Fixed in Puppet 4.3.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27PUP+4.3.2%27)
* [Introduced in Puppet 4.3.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27PUP+4.3.2%27)

### New Platform: Ubuntu Wily 15.10

As of Puppet 4.3.2, packages are available for Ubuntu Wily 15.10. Puppet 4.3.2 also modifies systemd to be the default service provider on Wily.

* [PUP-5553](https://tickets.puppetlabs.com/browse/PUP-5553)

### Improvements: Speed!

#### Faster Puppet lexer and parser

The lexer and parser in this version of Puppet complete tasks in less time when compared to Puppet 4.3.1. In limited testing, we've seen CPU time reduced by up to 55% in JRuby and by up to 13% in Ruby MRI.

* [PUP-5554](https://tickets.puppetlabs.com/browse/PUP-5554)

#### Faster service queries on OS X

Puppet 4.3.2 queries service enablement status on OS X several times faster than previous versions of Puppet.

* [PUP-5505](https://tickets.puppetlabs.com/browse/PUP-5505): 

#### Faster compilation when `environment_timeout = 0`

In previous versions of Puppet, an environment with an `environment_timeout` set to 0 that used many automatically bound default values would perform poorly, as each lookup caused the environment cache to be evicted and recreated. Puppet 4.3.2 greatly reduces the number of times it evicts the environment and significantly improves compilation performance.

* [PUP-5547: Environment is evicted many times during compilation](https://tickets.puppetlabs.com/browse/PUP-5547)

### New Feature: Use fact files with `puppet lookup`

Puppet 4.3.2 adds the ability to declare a JSON or YAML file containing key-value pairs (a **fact file**) when running the `puppet lookup` command. This populates a scope with facts from the fact file that Puppet can use when looking up data. For more information, see the [Puppet lookup quick reference][`puppet lookup`].

* [PUP-5060](https://tickets.puppetlabs.com/browse/PUP-5060)

### New Feature: Set HTTP proxy host and port for the `pip` provider

In previous versions of Puppet, the [`pip` package provider](/references/latest/type.html#package-provider-pip) could fail if used behind an HTTP proxy. This version adds the `http_proxy_host` and `http_proxy_port` settings to the provider.

* [PUP-5212](https://tickets.puppetlabs.com/browse/PUP-5212)

### New Feature: No catalog compilation on `puppet lookup` without the `--compile` flag

In previous versions of Puppet 4.3, the `puppet lookup` command always compiles the entire catalog before performing looking up a key. While correct, it can potentially be very time-consuming and produce unwanted logging. In Puppet 4.3.2, running `puppet lookup` instead uses an empty catalog (as `--noop`), and Puppet only compiles the entire catalog when run with the new `--compile` flag.

* [PUP-5461: `puppet lookup` is too verbose and compiles everything by default](https://tickets.puppetlabs.com/browse/PUP-5461)

### Regression Fix: Allow resource collectors to use resource references

Puppet 4.0 introduced a regression where resource collectors using resource references would produce an error. Puppet 4.3.2 fixes that regression.

* [PUP-5465](https://tickets.puppetlabs.com/browse/PUP-5465)

### Regression Fix: Retrieve resource state at evaluation time

In previous versions of Puppet 4.3, Puppet prematurely retrieves generated resources when they are generated, rather than during evaluation. This could cause certain types or providers to behave inconsistently. For instance, changing only the mode on an existing `remote_file` resource might lead to Puppet unnecessarily recreate the file on each Puppet run. This is a regression from Puppet 4.2, and Puppet 4.3.2 correctly retrieves generated resources when it evaluates the resource.

* [PUP-5595](https://tickets.puppetlabs.com/browse/PUP-5595)

### Regression Fix: Perform Hiera lookup on `undef` class parameters

In previous versions of Puppet 4.3, a Hiera lookup for a class parameter wouldn't occur if the parameter value was set to `undef` in the resource declaration. This is a regression from Puppet 4.2, and Puppet 4.3.2 correctly performs the lookup.

* [PUP-5592](https://tickets.puppetlabs.com/browse/PUP-5592)

### Regression Fix: Correctly interoplate default values

Puppet should interpolate default values from keys where the value is intentionally missing. However, this functionality stopped working in Puppet 4 due to the new distinction it makes between empty strings and undefined values, affecting lookups of missing variables. Puppet 4.3.2 fixes this by recognizing when a key has an undefined value and correctly interpolating its default value.

* [PUP-5578](https://tickets.puppetlabs.com/browse/PUP-5578)

### Regression Fix: Fix `yum` provider's handling of epoch-versioned RPM packages

Puppet 4.3.0 attempted to resolve an issue in handling epoch tags in DNF package names ([PUP-5025](https://tickets.puppetlabs.com/browse/PUP-5025)). However, the fix broke the `yum` provider's handling of epoch-versioned packages. This regression is fixed in Puppet 4.3.2.

* [PUP-5549](https://tickets.puppetlabs.com/browse/PUP-5549)

### Regression Fix: Make `--profile` flag compatible with Puppet 3

In Puppet 4, functions converted to the Puppet 4 function API were not included in the profiling information produced by the `--profile` flag. This caused the profiling output to produce less information than in Puppet 3. Puppet 4.3.2 restores this missing information.

* [PUP-5063](https://tickets.puppetlabs.com/browse/PUP-5063)

### Bug Fix: Unterminated C-style comments cause Puppet to hang

In previous versions of Puppet, an unterminated C-style comment in a Puppet manifest could lead to the `puppet master` process hanging indefinitely. Puppet 4.3.2 resolves this issue.

* [PUP-5127](https://tickets.puppetlabs.com/browse/PUP-5127)

### Bug Fix: Handle non-ASCII Unicode characters in inlined file content

In previous versions of Puppet, when a catalog contained inlined file content (typically from a template) with non-ASCII unicode characters, those characters could be corrupted when the agent used a cached catalog. Puppet 4.3.2 resolves this issue for the JSON cache.

* [PUP-5584](https://tickets.puppetlabs.com/browse/PUP-5584)

### Bug Fix: Correctly handle `yum` warnings

When run without an internet connection, the `yum` package manager returns a non-zero exit code. The [`yum` package provider](/references/latest/type.html#package-provider-yum) failed to handle this properly in previous versions of Puppet 4, resulting in an exception and failed resource. Puppet 4.3.2 updates the `yum` provider to gracefully warn the user instead of failing.

* [PUP-5594](https://tickets.puppetlabs.com/browse/PUP-5594)

### Bug Fix: Use `service` command to determine service status on Debian 8 and Ubuntu 15.04

If `systemd` is purged from a Debian 8 or Ubuntu 15.04 system running Puppet 4.3.1, the `service` provider failed to determine the state of a service because `systemctl` didn't exist. Puppet 4.3.1 instead uses the `service` command, which is an abstraction around each of the available init systems in the Debian family of platforms, to power the `service` provider.

* [PUP-5548](https://tickets.puppetlabs.com/browse/PUP-5548)

### Bug Fix: Always restore full trusted information from data stores

When trusted information was stored in PuppetDB, caches, or a file, and later retrieved, the value of the authenticated key was modified depending on whether the process ran as root. In Puppet 4.3.2, there is no difference, and the same information is always retrieved.

Therefore, the `authenticated` flag should be interpreted as "how the trusted information was authenticated when it entered the system". Historical data retains how it was authenticated in the past, and Puppet can obtain this information when reading it.

* [PUP-5061](https://tickets.puppetlabs.com/browse/PUP-5061)

### Bug Fixes: Puppet Language

* [PUP-3149: Removing packages on SuSE Linux should use `zypper`, not `rpm`](https://tickets.puppetlabs.com/browse/PUP-3149)
* [PUP-4744: `yumrepo` doesn't recognize whitespace-delimited `reposdir` settings in `/etc/yum.conf`](https://tickets.puppetlabs.com/browse/PUP-4744)
* [PUP-5209: Declaring a module dependency in `metadata.json` with a dash instead of a slash results in unexpected behavior](https://tickets.puppetlabs.com/browse/PUP-5209): When declaring one module as a dependency from another module's `metadata.json`, using a dash in the dependency's name (such as `puppetlabs-stdlib`) instead of a slash (`puppetlabs/stdlib`) could make functions in the dependency unexpectedly unavailable to the dependent module. Puppet 4.3.2 resolves the issue.
* [PUP-5552: Check parameter names in EPP templates](https://tickets.puppetlabs.com/browse/PUP-5552): In previous versions of Puppet, including the Puppet 3 future parser, Puppet would validate only the number of parameters passed to an EPP template, not their names, which could lead to Puppet failing to produce an error when passing an unknown parameter. Puppet 4.3.2 correctly validates EPP templates with the same logic used to validate resource parameters.
* [PUP-5589: No error logged when a type without a namevar causes a failure](https://tickets.puppetlabs.com/browse/PUP-5589): In previous versions of Puppet 4, a faulty implementation of a resource type could lead to a catalog compilation or Puppet run that fails without presenting a reason. Such problems are now logged.
* [PUP-5590: No error on duplicate parameters in classes and resources](https://tickets.puppetlabs.com/browse/PUP-5590): In previous versions of Puppet, you could illegally use the same parameter multiple times in a single class or resource without invoking an error. Puppet 4.3.2 adds an error message when parsing a manifest in which a parameter is specified more than once in a class or resource.
* [PUP-5612: Error message for declaring a resource without a title is confusing](https://tickets.puppetlabs.com/browse/PUP-5612): When declaring a resource without a title, previous versions of Puppet 4 produced a confusing, generic error message. Puppet 4.3.2 recognizes when a resource is missing a title and suggests adding one.
* [PUP-5628: Errors from functions written in the Puppet language don't mention the affected file](https://tickets.puppetlabs.com/browse/PUP-5628): When a function written in the Puppet language fails, previous versions of Puppet 4 only reported that an error occurred, but not the file in which it occurred. Puppet 4.3.2 identifies the path to the affected file.
* [PUP-5651: Puppet function declarations must be top-level constructs](https://tickets.puppetlabs.com/browse/PUP-5651): [Functions](./lang_functions.html) in the Puppet language should not be nested in any type of block, but Puppet 4 allowed you to illegally define a function inside a class or user-defined type without producing an error message. Puppet 4.3.2 correctly validates this rule and produces an error when it's violated.
* [PUP-5658: Disallow numeric ranges where from > to](https://tickets.puppetlabs.com/browse/PUP-5658): Previous versions of Puppet allowed you to create range sub-type declarations (such as `Integer[first,second]`) for integer and and float types where the maximum limit was set first and the minimum limit was set second. Now for such declarations, the first value must not be greater than the second.

### Bug Fixes: Puppet lookup

* [PUP-5502: Lookup adapter `lookup_global` produces bad error messages for faulty `hiera.yaml`](https://tickets.puppetlabs.com/browse/PUP-5502): In Puppet 4.3.1, errors in `hiera.yaml` produce vague error messages when handled during lookup actions. Puppet 4.3.2 produces a more concise error message, and includes the name of the key, location of the broken `hiera.yaml` file, and the location in `hiera.yaml` where the evaluation failed.
* [PUP-5511: `puppet lookup` rejects `--merge first`](https://tickets.puppetlabs.com/browse/PUP-5511): In Puppet 4.3.1, the [`puppet lookup`][] command's `--merge` option only accepted `unique` even though the `lookup()` function also accepted `first`. That made it impossible to override the lookup merge options provided in data files when performing a lookup from the command line. Puppet 4.3.2 resolves this by implementing the `--merge first` option for `puppet lookup`.
* [PUP-5618: Puppet ignores nested `lookup_options` in modules](https://tickets.puppetlabs.com/browse/PUP-5618): When a module using [`lookup_options`](./lookup_quick.html#setting-lookupoptions-in-data) includes another module using `lookup_options`, Puppet 4.3.1 ignores the nested options. Puppet 4.3.2 correctly respects the nested options.
* [PUP-5644: Puppet lookup creates new SSL hierarchy with self-signed CA](https://tickets.puppetlabs.com/browse/PUP-5644): When running `puppet lookup` under Puppet 4.3.1, Puppet created an unnecessary SSL hierarchy and self-signed certificate authority. Besides not being useful, these unnecessary creations could also cause lookups on masterless Puppet nodes to fail. Puppet 4.3.2 doesn't do this.

### Bug Fixes: Miscellaneous

* [PUP-5520: Exclude unsafe Yocto scripts from service init provider](https://tickets.puppetlabs.com/browse/PUP-5520): Gathering the status of service resources on Yocto Linux can cause unintended consequences, such as sending shutdown signals to daemons. Puppet 4.3.2 blacklists a series of unsafe init scripts shipped by Yocto so that Puppet does not try to execute them. 

* [PUP-5522: Puppet::Node attributes not kept consistent with its parameters](https://tickets.puppetlabs.com/browse/PUP-5522): In some Puppet-related applications, or in certain cases when using Puppet from Ruby, a Node object could use one environment but report that it was in another, resulting in the node having the wrong set of parameters. This doesn't affect regular catalog compilation, and is resolved in Puppet 4.3.2.

## Puppet 4.3.1

Released November 30, 2015.

Puppet 4.3.1 is a bug fix release.

* [Fixed in Puppet 4.3.1](https://tickets.puppetlabs.com/issues/?filter=16211)
* [Introduced in Puppet 4.3.1](https://tickets.puppetlabs.com/issues/?filter=16210)

### Bug Fixes: Miscellaneous

* [PUP-5525: Hiera special pseudo-variables breaking with Puppet 4.3](https://tickets.puppetlabs.com/browse/PUP-5525): Puppet 4.3.0 does not initialize Hiera for use with automatic class parameter lookups in the correct order, and does not correctly set special pseudovariables like `calling_module`. This led to lookups not finding values when the special variables were interpolated in hierarchy data paths.

## Puppet 4.3.0

Released November 17, 2015.

Puppet 4.3.0 is a feature and bug fix release in the Puppet 4 series. It adds OS X 10.11 (El Capitan) and Fedora 22 packages, introduces the experimental `lookup` system, support for new language features used by Application Orchestration, augeas improvements, and many bug fixes.

* [Fixed in Puppet 4.3.0](https://tickets.puppetlabs.com/issues/?filter=16109)
* [Introduced in Puppet 4.3.0](https://tickets.puppetlabs.com/issues/?filter=16108)

### New Feature: Puppet Lookup

Puppet lookup is a new and improved Hiera-like data lookup system, with lots of room for interesting future growth. It integrates with the existing Hiera system but fixes a lot of its most frustrating limitations.

{% partial ./_lookup_experimental.md %}

Today, the summary of Puppet lookup is:

* You can keep your hierarchy configuration in your environments, so it can be versioned alongside the data it controls.
* Modules can use Hiera-like data files to specify default values for their parameters.
* There's a new `lookup` function and `puppet lookup` command, with more powerful features and a more useful interface.
    * MUCH more powerful. Check out `puppet lookup`'s `--node` and `--explain` options.
* Automatic class parameter lookup can finally fetch merged data! You can specify merge behavior in your data sources with the new `lookup_options` metadata key.

Custom Hiera backends don't work with Puppet lookup.

For more details, see:

* [Quick Reference for Hiera Users][puppet lookup]
* [Quick Intro to Module Data](./lookup_quick_module.html)

Related tickets:

* [PUP-4474: Complete the "data in modules" functionality introduced in Puppet 4.0.0](https://tickets.puppetlabs.com/browse/PUP-4474)
* [PUP-4490: Pick up bindings from module's Metadata.json](https://tickets.puppetlabs.com/browse/PUP-4490)
* [PUP-5395: There's no way to set resolution_type when using data bindings](https://tickets.puppetlabs.com/browse/PUP-5395)
* [PUP-4489: Add data_provider to module metadata](https://tickets.puppetlabs.com/browse/PUP-4489)
* [PUP-4476: Add a 'puppet lookup' command line application as UI to lookup function](https://tickets.puppetlabs.com/browse/PUP-4476)
* [PUP-4485: Add a 'hiera' data provider](https://tickets.puppetlabs.com/browse/PUP-4485)
* [PUP-4475: Add explain-ability to the lookup and data provider APIs](https://tickets.puppetlabs.com/browse/PUP-4475)

### New Feature: Control the Execution of Augeas Resources

* [PUP-4629: Augeas onlyif does not work when using arrays to match against](https://tickets.puppetlabs.com/browse/PUP-4629): Makes it possible to control execution of an Augeas resource based on whether a property in the file being managed has a particular value. For example, you can ensure Augeas only applies changes to `/etc/nagios/nagios.cfg` if the `cfg_file` property in the `nagios.cfg` file does not equal a list of values.

~~~
augeas { 'configure-nagios-cfg_file':
incl => '/etc/nagios/nagios.cfg',
lens => 'NagiosCfg.lns',
changes => [ "rm cfg_file",
"ins cfg_file",
"set cfg_file[1] /etc/nagios/commands.cfg",
"ins cfg_file after /files/etc/nagios/nagios.cfg/cfg_file[last()]",
"set cfg_file[2] /etc/nagios/anotherconfig.cfg" ],
onlyif => "values cfg_file != ['/etc/nagios/commands.cfg', '/etc/nagios/anotherconfig.cfg']"
}
~~~

### New Features: Miscellaneous

* [PUP-4622: Add a diff command in Puppet filebucket](https://tickets.puppetlabs.com/browse/PUP-4622): Adds a new `puppet filebucket diff` command that lets you compare two files. You can specify files using either a local path or the checksum of the file in the filebucket. The diff command works with both local and remote filebuckets.

    For example, `puppet filebucket diff d43a6ecaa892a1962398ac9170ea9bf2 7ae322f5791217e031dc60188f4521ef` will diff two files from the filebucket.

* [PUP-5097: Hostname and Domain as trusted facts](https://tickets.puppetlabs.com/browse/PUP-5097): This change adds two new trusted facts, `hostname` and `domainname`, which can be handy in a Hiera hierarchy. See the ticket description for an example of how it might be used in Hiera.

* [PUP-4602: 'bsd' service provider doesn't work with rcng](https://tickets.puppetlabs.com/browse/PUP-4602): Previously, Puppet could not manage services on NetBSD. This change adds an `rcng` service provider, which is the default provider for platforms where the `operatingsystem` fact returns `netbsd` or `cargos`.

* [PUP-2315: function call error message about mis-matched arguments is hard to understand](https://tickets.puppetlabs.com/browse/PUP-2315): When giving unacceptable arguments to functions, defined types, or classes, Puppet would produce too much information, thereby making it hard to understand exactly were the unacceptable argument value was and why it was unacceptable.

    This release improves the error message and provides more information toward diagnosing the issue.

* [PUP-4780: enhance versioncmp() error checking as it only accepts strings](https://tickets.puppetlabs.com/browse/PUP-4780): The `versioncmp()` function now type-checks its arguments, which must be strings, and reports a type mismatch error if this is not the case. Before this, if data other than strings were given, Puppet could produce a confusing error message.

* [PUP-5355: Add additional OIDs for cloud specific data](https://tickets.puppetlabs.com/browse/PUP-5355): Adds more Puppet OIDs under ppRegCertExt (1.3.6.1.4.1.34380.1.1) for certificate extension information. See the table of [Puppet Specific Registered IDs](/puppet/latest/4.3/ssl_attributes_extensions.html#puppet-specific-registered-ids).

* [PUP-4055: Support DNF package manager (yum successor)](https://tickets.puppetlabs.com/browse/PUP-4055): Fedora 22 has moved to DNF as a replacement for yum. With this ticket, we now have a new DNF package provider that supports DNF.

* [PUP-1388: Add 'list' subcommand to filebucket](https://tickets.puppetlabs.com/browse/PUP-1388): Makes it possible to list _local_ filebuckets, returning the checksum, date and path of each file in the file bucket. Listing remote filebuckets is not supported. The list command can take `--fromdate` and `--todate` options to limit which files are returned.

* [PUP-4890: Add code_id to catalog](https://tickets.puppetlabs.com/browse/PUP-4890) and [PUP-5221: (Ankeny) Direct Puppet: code_id support](https://tickets.puppetlabs.com/browse/PUP-5221): Adds `code_id` to the catalog that is serialized with the catalog, such as when the agent requests a catalog. This release updates the catalog schema and API documentation. For now, the `code_id` will always be nil, so there is not much in the way of user-facing changes.

### Bug Fixes: Language

* [PUP-4926: Relationship with a parameter does not work](https://tickets.puppetlabs.com/browse/PUP-4926): When giving a resource reference such as Notify['x'] as an attribute value in a resource or class it was not possible to form a relationship with this value.

* [PUP-4610: multi-resource references do not accept trailing commas](https://tickets.puppetlabs.com/browse/PUP-4610): A trailing comma was not accepted in expressions like `Type[title,]`.

* [PUP-5026: error message "illegal comma separated argument list" does not give a line number](https://tickets.puppetlabs.com/browse/PUP-5026): Some error messages like "illegal comma separated list" did not contain the source location (file and line).

### Bug Fixes: Resource Types and Providers

* [PUP-2573: Puppet::Agent::Locker#lock doesn't return whether it acquired the lock or not](https://tickets.puppetlabs.com/browse/PUP-2573): The Puppet agent uses a lock file to ensure that only one instance is running at a time. However, the agent was susceptible to a race condition that could cause two agents to try to acquire the lock at the same time, and have one of them fail with a generic "Could not run" error. Now the agent will atomically try to acquire the lock, and if that fails, log a meaningful error.

* [PUP-2509: puppet resource service on Solaris needs -H flag](https://tickets.puppetlabs.com/browse/PUP-2509): This change was necessary on Solaris 11 due to a new format for service listings when calling `svcs`. Puppet was fooled into thinking that the literal column headers of the command output were services, when they clearly were not.

* [PUP-5016: SysV init script managed by 'init' provider instead of 'debian' provider on Debian8](https://tickets.puppetlabs.com/browse/PUP-5016): In Debian 8 and Ubuntu 15.04, Systemd was introduced as the default service manager. However, many packages and services still utilize older SysVInit scripts to manage services, necessitating the systemd-sysv-init compatibility layer.

    This layer confused Puppet into improperly managing SysVInit services on these platforms. The final outcome of this ticket is that Puppet now falls back to the Debian service provider when managing a service without a Systemd unit file. All services should be enable-able, which they were not before due to Puppet incorrectly falling back to the Init provider.

    In another, closely related scenario (on versions of Ubuntu before 15.04), the init provider was erroneously being favored over the debian provider when managing the 'enable' attribute of upstart services. This meant that `puppet resource service <name>` would not show whether the service was enabled or not.

    This change causes the debian provider to be used instead, which utilizes upstart rather than init to manage these services. Thus, the `enable` attribute is always displayed when a service is queried.

* [PUP-5271: Windows user resource should not manage password unless specified](https://tickets.puppetlabs.com/browse/PUP-5271): When you are attempting to create users without specifying the password and you have the Windows Password Policy for `Password must meet complexity requirements` set to Enabled, it caused Puppet to fail to create the user. Now it works appropriately.

    > **Note:** When the Windows Password Policy `Minimum password length` is greater than 0, the password must always be specified. This is due to Windows validation for new user creation requiring a password for all new accounts, so it is not possible to leave password unspecified once that password policy is set.

    It is also important to note that when a user is specified with `managehome => true`, the password must always be specified if it is not an already existing user on the system.

* [PUP-4633: User resource fails with UTF-8 comment on 2nd run](https://tickets.puppetlabs.com/browse/PUP-4633): Failure to parse existing non-ASCII characters in user comment field - performed when comment is set by the user type - has been fixed.

* [PUP-4738: launchd enable/disable on OS X 10.11](https://tickets.puppetlabs.com/browse/PUP-4738): On OS X 10.10+, the launchd provider would fail to update the correct plist. On OS X 10.11 this would result in an error when trying to update a service registered in /System because permission is restricted on /System. Fixed so that the launchd provider now updates the correct override plist rather than falling back to attempting to modify the service plist.

* [PUP-5058: The sshkey Type's Default Target for Mac OS X 10.11 (El Capitan) is Incorrect](https://tickets.puppetlabs.com/browse/PUP-5058): In OSX 10.11, the ssh_known_hosts file is in /etc/ssh, whereas it's in /etc in older OSX versions. This fix allows Puppet to manage the file on 10.11, while continuing to manage the file at the previous location on 10.9 and 10.10.

* [PUP-4917: puppet resource package does not display installs that use QuietDisplayName](https://tickets.puppetlabs.com/browse/PUP-4917): Previously, `puppet resource package` didn't display all installed programs as there was a new field added to the registry keys named QuietDisplayName. We've now fixed that so those items can now be managed with the Puppet built-in Windows package resource.

### Bug Fixes: Miscellaneous

* [PUP-1963: Generated resources never receive dependency edges](https://tickets.puppetlabs.com/browse/PUP-1963): Resources created by another type (via the `generate` method) will now have any relationship metaparams respected, and will participate in `autorequire`.
* [PUP-4918: Logrotate and init scripts permission and signal issues](https://tickets.puppetlabs.com/browse/PUP-4918): Log rotation was incorrectly configured on Fedora/RHEL and Debian-based systems; it pointed to the wrong file location and so would not rotate logs. Fix log locations so log rotation works again.

    Also the log rotation script tried to own permissions for Puppet's log file, which conflicted with service restarts on Fedora/RHEL where the Puppet service would also try to update permissions for the log file. Installation on those systems will now set the correct permissions for log files, and the log rotation script will not try to update them.

* [PUP-3953: Puppet resource doesn't properly escape single quotes.](https://tickets.puppetlabs.com/browse/PUP-3953): `puppet resource` did not escape single quotes in resource titles, causing it to generate invalid manifests. This commit escapes single quotes so the title is valid.

* [PUP-4653: filebucket fails when environment is specified](https://tickets.puppetlabs.com/browse/PUP-4653): This ticket was supposed to cleanup the client-side filebucket code so that in the future we could support HTTP(S) based file sources. After this change was made, we realized it fixed another bug where filebucket requests failed when an environment was specified (PUP-4954). So for release notes, Puppet will correctly filebucket files when an environment is specified, such as when using agent specified environments.

* [PUP-5014: Base class for JSON/msgpack indirection termini calls log_exception() wrong](https://tickets.puppetlabs.com/browse/PUP-5014): If an exception occurred while serializing objects to JSON or msgpack, Puppet generated a new exception while logging the original exception, causing the reason for the original exception to be lost.

* [PUP-4781: filemode retrieved by static_compiler should be stringified](https://tickets.puppetlabs.com/browse/PUP-4781): The static compiler was completely broken in Puppet 4, because it would generate file resources with numeric file modes, which is not allowed. This fix causes the static compiler to generate a quoted octal mode, such as "644".

* [PUP-5282: Allow local of install of a gem on windows](https://tickets.puppetlabs.com/browse/PUP-5282): Makes it possible to use the gem provider on windows where the source is a local gem.

* [PUP-5192: undefined method `[]' for Puppet::Transaction::Event with certain reports](https://tickets.puppetlabs.com/browse/PUP-5192): PUP-3272 introduced a regression where you could not load a report containing status events, such as `YAML.load_file("last_run_report.yaml")`. This ticket fixes fixes that and adds tests to ensure we don't regress.

* [PUP-5055: parent attributes are set from metadata too early in static_compiler](https://tickets.puppetlabs.com/browse/PUP-5055): When using the static compiler (catalog_terminus=static_compiler), and managing a directory with `recurse => true`, then the static compiler would copy the metadata, such as the owner, from the parent to the child even when the manifest already specified the child's metadata.

* [PUP-4697: Puppet service provider for SuSE should default to systemd except for version 11](https://tickets.puppetlabs.com/browse/PUP-4697): Changes the default service provider for suse to be `systemd`, and falls back to `redhat` for versions 10 and 11. This change aligns with future suse releases as they will be `systemd` based. It's a breaking change for suse 9 and earlier, but those are not supported.

* [PUP-2575: OS X group resource triggers spurious notice of a change](https://tickets.puppetlabs.com/browse/PUP-2575): Previously, if the manifest specified group members in a different order than the OSX group provider returned them in, then Puppet would generate a spurious notice that the resource was not insync. The same would also happen if you specified the same member more than once.

* [PUP-4776: `puppet agent arg` silently eats arguments and runs the agent](https://tickets.puppetlabs.com/browse/PUP-4776): Previously, Puppet agent would allow arguments to be passed to it that it didn't understand, and would ignore them. For example, `puppet agent disable`, and because the Puppet agent deamonizes by default, this would actually start the agent running in the background instead of disabling it. Now the Puppet agent will reject options it doesn't understand.

* [PUP-4771: Static compiler only looks for file content in production environment](https://tickets.puppetlabs.com/browse/PUP-4771): Fixes the static compiler to use the specified environment, rather than always using production.

* [PUP-5062: static compiler fails to remove existing resources from children.](https://tickets.puppetlabs.com/browse/PUP-5062): Previously the static compiler would fail to remove children from the graph that already exist thanks to recursive directory resources, causing an error for valid Puppet code. This has been fixed.

* [PUP-4919: static compiler always sets ensure parameter to 'file' if a source is declared](https://tickets.puppetlabs.com/browse/PUP-4919): When using the static compiler, it was not possible to ensure a file resource was absent. Instead it would always ensure it was a file.

* [PUP-5037: RedHat puppetmaster service status report is invalid when it's stopped and client is running](https://tickets.puppetlabs.com/browse/PUP-5037): If the Puppet service was running, but the passenger-based puppetmaster service was not, then you would receive an error when trying to get the status of the puppetmaster service. Now it reports that the puppetmaster service is stopped.

* [PUP-4740: Add missing query parameters to Puppet HTTPS API docs](https://tickets.puppetlabs.com/browse/PUP-4740): Updates the REST API docs to include source_permissions and configured_environment query parameters that the agent sends. No code/behavior changes were made.

* [PUP-1189: Custom reports not working (Class is already defined in Puppet::Reports)](https://tickets.puppetlabs.com/browse/PUP-1189): Previously, if a report handler failed during initialization, it wasn't cleaned up. So the second time a report was submitted, Puppet would try to instantiate a new class, and then fail because it had already been instantiated. This instructs the class loader to overwrite if needed.

* [PUP-3694: puppet cert fingerprint invalidhost returns zero instead of non-zero](https://tickets.puppetlabs.com/browse/PUP-3694): Previously, `puppet cert fingerprint invalid_host_name` would report an error but still exit 0. This fixes the command to return a non-zero exit code if the certificate can not be found.

* [PUP-4814: Path of scheduled tasks folder is not necessarily C:\Windows\Tasks](https://tickets.puppetlabs.com/browse/PUP-4814): Previously Puppet's scheduled_task provider on windows assumed the Windows system directory was `C:\windows\system32`. However, it possible for the directory to be on an alternative drive or have a different root directory, such as `D:\winnt\system32`. As a result the provider could not manage scheduled tasks. This change uses the SystemRoot environment variable to resolve the correct directory.

* [PUP-5340: puppet apply doesn't honor --catalog_cache_terminus](https://tickets.puppetlabs.com/browse/PUP-5340): Changes `puppet apply` to observe the `catalog_cache_terminus` Puppet setting to be consistent with `puppet agent`. This way you can run `puppet apply <manifest.pp> --catalog_cache_terminus=json`, then Puppet will store a cached copy of the catalog in `$client_datadir/catalog/<hostname>.json`. The default behavior of `puppet apply` is unchanged.

* [PUP-5381: Evaluating instance match with Optional[T] and NotUndef[T] fails when T is a string value](https://tickets.puppetlabs.com/browse/PUP-5381): The type references Optional[T] and NotUndef[T] should have accepted a string S as a shorthand notation for Enum[S]. Instead this failed with an error which is not corrected.

* [PUP-5292: regsubst doesn't work on empty arrays in Puppet 4.x](https://tickets.puppetlabs.com/browse/PUP-5292): The type system did not recognize an empty array as an acceptable value when an array with a specified subtype was declared. This caused certain calls to be reported as being given the wrong types of arguments, such as a `regsubst` function call operating on an empty array.

* [PUP-5427: incorrect path being defined in puppet-agent's init script is causing gems to be installed into Puppet's gem env.](https://tickets.puppetlabs.com/browse/PUP-5427): When running Puppet as a daemon, our private bin directory `/opt/puppetlabs/puppet/bin` was prepended to the PATH for the Puppet process, causing Puppet to install gems (such as when using the `gem` package provider) into Puppet's vendored Ruby instead of the system's Ruby. Puppet 4.3.0 correctly installs gems into the system's Ruby when running daemonized, which is consistent with running Puppet in the foreground (`puppet agent -t`).

* [PUP-5262: Solaris (10) service provider returns before service refresh is complete](https://tickets.puppetlabs.com/browse/PUP-5262): In versions of Solaris older than 11.2, service state transitions are not atomic. On slower systems, this could cause race conditions when starting, stopping, or restarting services, as Puppet did not wait for services to conclude their operations before continuing to apply different resources. The SMF service provider has been updated to wait up for up to 60 seconds when changing the state of a service.

* [PUP-5309: Yum package provider: ensure => latest fails when kernel is updated but not current](https://tickets.puppetlabs.com/browse/PUP-5309): The yum provider no longer throws "undefined method `[]' for nil:NilClass" if the yum-security plugin is enabled when trying to manage a yum package.

* [PUP-5441: $trusted is not available in master compile and fails when coming from PDB](https://tickets.puppetlabs.com/browse/PUP-5441): Sanitizes the trusted info in the node object when it is restored from cache. This prevents "Attempt to assign to a reserved variable name: 'trusted' " errors when running standalone compiles on a master node, among other scenarios.

* [PUP-5025: Package resource showing notice when ensure attribute contains Epoch tag](https://tickets.puppetlabs.com/browse/PUP-5025): Previously, if the `ensure` property for a yum or dnf package contained an epoch tag,  Puppet would consider the resource to always be out of sync try to reinstall the package. Puppet now takes into account the epoch tag when comparing the current and desired versions.

* [PUP-4458: Refactor validation of 4.x parameter signatures](https://tickets.puppetlabs.com/browse/PUP-4458): Earlier there were several different implementatations and they differed in how they checked and reported type mismatches. This release makes the typechecking and reporting of parameter types consistent.

* [PUP-5035: undefined method `keys' for nil:NilClass in static_compiler](https://tickets.puppetlabs.com/browse/PUP-5035): The static compiler would raise a NoMethodError exception if it tried to inline metadata for a file resource where recurse was true, but the source parameter (such as `source => 'puppet:///modules/puppet/puppet.conf'`) referred to a file on the master.

* [PUP-4702: Replace rgen model for the Puppet Type system with immutable classes](https://tickets.puppetlabs.com/browse/PUP-4702): A refactoring was done of the Puppet type system to make it use less memory and faster performing.

* [PUP-5342: Empty arrays does not match type of typed arrays](https://tickets.puppetlabs.com/browse/PUP-5342): The type system did not accept an empty array as valid when the array type matched against did not accept Undef entries.

* [PUP-4932: Deprecate cfacter setting](https://tickets.puppetlabs.com/browse/PUP-4932): The `cfacter` setting allowed users in past versions of Puppet to use a native Facter implementation instead of the older Ruby Facter. In the `puppet-agent` package, native Facter is the only available implementation, and trying to set the `cfacter` setting will fail since native Facter does not provide `cfacter.rb`. This release deprecates the `cfacter` setting, and it will be removed in the next major version.

* [PUP-5032: Update node terminus configured_environment to mirror agent_specified_environment](https://tickets.puppetlabs.com/browse/PUP-5032): When the `configured_environment` property was added to node and catalog communication, it was always set even when accepting the default. This was less useful than intended, as a node classifier may expect to know whether the agent explicitly requested that environment or is using the default. Change to only set the `configured_environment` property if an environment was explicitly requested on the agent, i.e. via puppet.conf or the command-line.

* [PUP-4516: Agent does not stop with Ctrl-C](https://tickets.puppetlabs.com/browse/PUP-4516): Puppet agents and WEBrick masters now immediately exit in response to SIGINT and SIGTERM signals, such as when pressing Ctrl-C. Previously, if the agent process was idle, it would take up to 5 seconds for the process to stop. If the agent was performing a run, it could not be interrupted until after the run completed.

* [PUP-5387: AIX service provider returns before service operations are complete](https://tickets.puppetlabs.com/browse/PUP-5387): In AIX, service state transitions are not atomic. On slower systems, this could cause race conditions when starting, stopping or restarting services, as Puppet did not wait for services to conclude their operations before continuing to apply different resources. The SRC service provider has been updated to wait up for up to 60 seconds when changing the state of a service.

* [PUP-5422: Daemonized agent's pidfile never removed if stopped while waiting for a certificate](https://tickets.puppetlabs.com/browse/PUP-5422): If the daemonized agent was waiting for a cert to be issued, and the process was killed, e.g. SIGTERM or SIGINT, then the agent would exit ungracefully and leave its pid file behind. Now the agent gracefully exits and deletes its pid file.

### Regression: Puppet retrieves resource state prematurely

In Puppet 4.3.0, Puppet prematurely retrieves generated resources when they are generated, rather than during evaluation. This could cause certain types or providers to behave inconsistently. For instance, changing only the mode on an existing `remote_file` resource might lead to Puppet unnecessarily recreate the file on each Puppet run. This is a regression from Puppet 4.2 and is fixed in Puppet 4.3.2.

* [PUP-5595](https://tickets.puppetlabs.com/browse/PUP-5595)

### Regression: Puppet doesn't perform Hiera lookups on `undef` class parameters

In Puppet 4.3.0, a Hiera lookup for a class parameter wouldn't occur if the parameter value was set to `undef` in the resource declaration. This is a regression from Puppet 4.2 and is fixed in Puppet 4.3.2.

* [PUP-5592](https://tickets.puppetlabs.com/browse/PUP-5592)

### Regression: Package version behavior is broken for epoch-versioned RPM packages

Puppet 4.3.0 attempted to resolve an issue in handling epoch tags in DNF package names ([PUP-5025](https://tickets.puppetlabs.com/browse/PUP-5025)). However, the fix broke the `yum` provider's handling of epoch-versioned packages. This regression is fixed in Puppet 4.3.2.

* [PUP-5549](https://tickets.puppetlabs.com/browse/PUP-5549)
