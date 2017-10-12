---
layout: default
title: "Puppet 4.2 Release Notes"
---

[puppet-agent]: /puppet/latest/about_agent.html

This page lists the changes in Puppet 4.2 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

Make sure you also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: the [Puppet 4.1 release notes](/puppet/4.1/release_notes.html).

## Puppet 4.2.3

Released October 29, 2015.

Shipped in [puppet-agent][] version 1.2.7.

Puppet 4.2.3 is a bug fix and platform support release in the Puppet 4.2 series. It also removes support for Ubuntu 14.10 (Utopic).

For JIRA issues related to Puppet 4.2.3, see:

* [Fixes for Puppet 4.2.3](https://tickets.puppetlabs.com/issues/?filter=15778)
* [Introduced in Puppet 4.2.3](https://tickets.puppetlabs.com/issues/?filter=15770)

### New Platforms: AIX 5.3, 6.1, and 7.1, and Solaris 11

Puppet 4.2.3 adds functionality for AIX 5.3, 6.1, and 7.1 on PowerPC architectures, and Solaris 11 on SPARC and i386 architectures. Note that [puppet-agent][] packages for these platforms are available only in Puppet Enterprise.

### SUPPORT END: Ubuntu 14.10 (Utopic)

Ubuntu 14.10 (Utopic) reached the end of its life on [July 23, 2015](https://lists.ubuntu.com/archives/ubuntu-announce/2015-July/000198.html). Support for it ends with Puppet 4.2.3. We continue to support Ubuntu 14.04 (Trusty) and 15.04 (Vivid).

* [PUP-5001](https://tickets.puppetlabs.com/browse/PUP-5001)

### REGRESSION FIX: Revert Error Code When Running Puppet Master Without a `puppet` User or Group

Prior to Puppet 4.1.0, running Puppet master as root would exit with error code 74 if the `puppet` user, which Puppet uses for the process, did not exist. In Puppet 4.1.0, this error code was unintentionally changed to 1. Puppet 4.2.3 reinstates error code 74 in this situation.

* [PUP-5317](https://tickets.puppetlabs.com/browse/PUP-5317)

### REGRESSION FIX: Properly Filter with Tags with Segmented Names

Since Puppet 3.5.0, running Puppet agent with a tag filter (the `--tag` flag) would split the given tag if it contained a segmented name, such as the double-colon separator in `apache::mod`. This resulted in Puppet behaving as if you had specified multiple tags, which could lead to inconsistent or unexpected results. Puppet 4.2.3 resolves this issue.

* [PUP-4495](https://tickets.puppetlabs.com/browse/PUP-4495)

### FIX: Manage Passwords for Windows User Resources Only When Specified

In previous versions of Puppet for Windows, Puppet fails when attempting to create users without specifying a password while the Windows Password Policy [`Password must meet complexity requirements`](https://technet.microsoft.com/en-us/library/cc786468.aspx) policy is enabled. Puppet 4.2.3 resolves this issue.

> **Note:** When the Windows Password Policy [`Minimum password length`](https://technet.microsoft.com/en-us/library/hh994560.aspx) is greater than 0, the password must be specified because Windows requires passwords for all new user accounts.
> 
> Also, when you specify a user resource for a new user in Puppet with the `managehome` parameter set to true, you must _always_ specify the password.

* [PUP-5271](https://tickets.puppetlabs.com/browse/PUP-5271)

### FIX: Log Exceptions Raised by Indirector Save Methods

In previous versions of Puppet, Puppet did not log exceptions raised by an indirector save methods, resulting in no indication in the logs when code exits on an exception. Puppet 4.2.3 ensures that Puppet logs these exceptions.

* [PUP-5290](https://tickets.puppetlabs.com/browse/PUP-5290)

### FIX: Puppet Can Manage the `puppet` Service on Enterprise Linux 4

In Enterprise Linux 4, the `puppet` service installed by [puppet-agent][] would always stop when attempting to manage it with Puppet. Puppet 4.2.3 resolves this issue.

* [PUP-5257](https://tickets.puppetlabs.com/browse/PUP-5257)

### FIX: Puppet Language's `filter` Function Returns Elements as Specified

In Puppet 4.2.2, the `filter` function did not behave according to specification when filtering a hash, as it allowed any "truthy" value as a return from the lambda to include the element in the result. Puppet 4.2.3 only includes an element in the result when the lambda returns a Boolean true.

* [PUP-5350](https://tickets.puppetlabs.com/browse/PUP-5350)

## Puppet 4.2.2

Released September 14, 2015.

Shipped in [puppet-agent][] version 1.2.4.

Puppet 4.2.2 is a security, bug fix, and platform support release in the Puppet 4.2 series. It also adds warnings for new reserved words, to prepare for upcoming language features.

For JIRA issues related to Puppet 4.2.2, see:

* [Fixes for Puppet 4.2.2](https://tickets.puppetlabs.com/issues/?filter=15437)
* [Introduced in Puppet 4.2.2](https://tickets.puppetlabs.com/issues/?filter=15435)

### SECURITY: Override Cert File Locations on Windows

Puppet on Windows was relying on OpenSSL's default certificate locations, which aren't guaranteed to be safe. With this fix, Puppet now overrides the default locations with known safe ones. We recommend all Windows users upgrade for this security fix.

* [PUP-5218: Set SSL_CERT_FILE environment variable for windows services](https://tickets.puppetlabs.com/browse/PUP-5218)

### New Reserved Words: `application`, `consumes`, and `produces`

To prepare for upcoming language features, we've reserved three new words in the Puppet language:

* `application`
* `consumes`
* `produces`

Like all [reserved words](./lang_reserved.html), you can't use these as unquoted strings or as names for classes, defined types, resource types, or custom functions.

Since this isn't a major version boundary, using these words will log warnings instead of errors. In the next major version of Puppet, they will become normal reserved words. When we introduce features that use these words, they will be opt-in via a setting until the next major version of Puppet.

This change also went into Puppet 3.8.2's future parser.

* [PUP-4941: Reserve keywords 'application', 'consumes', and 'produces'](https://tickets.puppetlabs.com/browse/PUP-4941)
* [PUP-5036: `--parser future` breaks `class application {}`](https://tickets.puppetlabs.com/browse/PUP-5036)

### New Platform: Ubuntu 15.04 Vivid Vervet

We're now providing Puppet agent packages for Vivid, along with a PC1 repo for that platform.

### Packaging Change: OS X Disk Image Names

Our Mac OS X disk images had a redundant and unwieldy naming scheme (`puppet-agent-1.2.2-osx-10.10-x86_64.dmg`), so we simplified it (`puppet-agent-1.2.4-yosemite.dmg`). [OS X agent packages are available here.](http://downloads.puppetlabs.com/mac/PC1/)

### Bug Fixes: Windows

* [PUP-4854: PMT fails to install modules on Windows that have long paths](https://tickets.puppetlabs.com/browse/PUP-4854) --- Windows has a default maximum path length of 260 characters (`MAX_PATH`), and the module tool's temp path was taking up too much of that. We've changed it to use a shorter temp directory.
* [PUP-5018: Puppet::FileSystem.unlink fails on Windows when the target path doesn't exist](https://tickets.puppetlabs.com/browse/PUP-5018) --- Puppet would raise an error when removing a symlink whose target no longer exists. Now it works fine.

### Bug Fixes: Mac OS X

* [PUP-4639: Refreshing a LaunchDaemon leaves it disabled](https://tickets.puppetlabs.com/browse/PUP-4639) --- When refreshing a service on Mac OS X that was already running (via `notify`, `subscribe`, or `~>`), Puppet would stop the service and fail to start it.
* [PUP-4822: Regression PMT cannot connect to forge on OSX](https://tickets.puppetlabs.com/browse/PUP-4822) --- The bundled copy of OpenSSL in our OS X packages didn't have the CA cert it needed to connect to the Puppet Forge, so `puppet module` wasn't working correctly.
* [PUP-5044: launchd enable/disable on OS X 10.10](https://tickets.puppetlabs.com/browse/PUP-5044) --- Enable/disable of services on El Capitan (10.10) wasn't working because the overrides plist moved. Puppet now knows where to find that plist on 10.10+.

### Bug Fixes: Linux

* [PUP-4865: Package resources no longer fail with bad names on EL5](https://tickets.puppetlabs.com/browse/PUP-4865) --- On Red Hat Enterprise Linux 5, there was a regression wherein package resources with bad names (which should fail) were not failing. This fix restores the correct behavior, which is to fail the catalog application.
* [PUP-4605: With a systemd masked service: 'enable=true ensure=running' doesn't work](https://tickets.puppetlabs.com/browse/PUP-4605) --- With a systemd masked service the combination of the enable=true and ensure=running attributes did not work, although using them serially would work. This fix addresses that use case.
* [PUP-4196: agent command line options ignored running under systemd](https://tickets.puppetlabs.com/browse/PUP-4196) --- Puppet agent under systemd lets you set command line options with the `PUPPET_EXTRA_OPS` variable in the `/etc/sysconfig/puppet` file, but a syntax glitch was making it ignore them.

### Bug Fixes: Misc

* [PUP-3318: Puppet prints warning when "environment" is set using classifier rather than local puppet.conf](https://tickets.puppetlabs.com/browse/PUP-3318) --- When a Puppet agent was instructed by the Puppet master to change its environment, it would issue a warning about changing environment even though that's the intended behavior. That message has been changed to a notice.
* [PUP-5013: resource evaluation metrics are missing when not using an ENC](https://tickets.puppetlabs.com/browse/PUP-5013) --- Puppet Server's metrics for resource evaluation were very incomplete, because we were only tracking one of the several code paths that can evaluate resources. The metrics should be more complete now.
* [PUP-3045: exec resource with timeout doesn't kill executed command that times out](https://tickets.puppetlabs.com/browse/PUP-3045) --- On POSIX systems, `exec` resources with a `timeout` value will now send a TERM signal if their command runs too long.
* [PUP-4936: Add smf service files for puppet](https://tickets.puppetlabs.com/browse/PUP-4936) --- We've added SMF service files for running Puppet agent on Solaris 10. They're in the Puppet source at [ext/solaris/smf](https://github.com/puppetlabs/puppet/tree/master/ext/solaris/smf).

## Puppet 4.2.1

Released July 22, 2015.

Shipped in [puppet-agent][] version 1.2.2.

Puppet 4.2.1 is a bug fix release.

### Known issue

Running `puppet resource user` in US-ASCII on Mac OSX 10.10 results in an error, "Error: Could not run: invalid byte sequence".

This is an offshoot of Puppet and Ruby's more strict UTF-8 handling. The solution is to set a high-bit-capable locale in your shell: 

~~~
export LANG=en_US.UTF-8 
~~~

To make this permanent, it needs to be in your shell initialization file (~/.profile or one of its kin).

### Bug fixes

* [PUP-4752](https://tickets.puppetlabs.com/browse/PUP-4752): Variable names were being checked for allowed characters, but not if they appeared as names of parameters.
* [PUP-4770](https://tickets.puppetlabs.com/browse/PUP-4770): Solaris Zone's provider debug and error messages were changed to global, this has been reverted to so that it is prefixed with provider context.
* [PUP-4777](https://tickets.puppetlabs.com/browse/PUP-4770): Puppet gem dependencies updated to use Hiera 3.
* [PUP-4789](https://tickets.puppetlabs.com/browse/PUP-4789): The 4.x hiera_include function was not propagating the correct scope to the include function.
* [PUP-4826](https://tickets.puppetlabs.com/browse/PUP-4826): When using Integer[1], the expectation was that this produces the type Integer[1, default], but it produced Integer[1,1]. The same was occuring with Float. After the fix, they are both operating as documented in the [Puppet Language Reference](http://docs.puppetlabs.com./lang_data_number.html#parameters).
* [PUP-4775](https://tickets.puppetlabs.com/browse/PUP-4775): Serialization of node objects could produce giant serializations. When loaded later would cause 'stack level too deep' errors. This was caused by logic missing in the node implementation that should have prevented serialization of the entire runtime state of the environment.
* [PUP-4810](https://tickets.puppetlabs.com/browse/PUP-4810): Puppet was caching parse results even when environment_timeout was set to 0.
* [PUP-4847](https://tickets.puppetlabs.com/browse/PUP-4847): When using custom providers, the puppet resource command could not use custom facts.

* [All tickets fixed in 4.2.1](https://tickets.puppetlabs.com/issues/?filter=15117)
* [Issues introduced in 4.2.1](https://tickets.puppetlabs.com/issues/?filter=15116)

## Puppet 4.2.0

Released June 24, 2015.

Shipped in [puppet-agent][] version 1.2.0.

> **Note:** Make sure you install the [puppet-agent][] 1.2.1 package instead of 1.2.0. The .0 release included a Facter regression involving external facts, which was fixed in 1.2.1.

4.2.0 is a feature and bug fix release in the Puppet 4 series. There aren't any particular keystone features; just a solid grab-bag of nice smaller improvements.

Also notable in this release: we're [officially deprecating Windows Server 2003 and 2003 R2][win2003dep], which we will stop supporting in Puppet 5.

* [All tickets fixed in 4.2.0](https://tickets.puppetlabs.com/issues/?filter=14558)
* [Issues introduced in 4.2.0](https://tickets.puppetlabs.com/issues/?filter=14559)

### DEPRECATED: Windows 2003

[win2003dep]: ./deprecated_win2003.html

Windows Server 2003 and 2003 R2 are approaching Microsoft's official end of support deadline, which means we, too, will stop supporting it soon.

Puppet 4.x will continue to work with Windows 2003, but the installer and upgrader will issue deprecation warnings. Once Puppet 5 is released, Windows 2003/2003R2 will be officially unsupported.

For more information, [see the Windows 2003 deprecation page.][win2003dep]

* [PUP-4631: Introduce Windows 2003 deprecation notices](https://tickets.puppetlabs.com/browse/PUP-4631)

### New Feature: Support for the `no_proxy` Environment Variable

Many command-line tools in Unix-land support common environment variables for configuring HTTP(S) proxies. Previously, Puppet respected the `http_proxy` and `https_proxy` variables when connecting to HTTP services (like the Puppet Forge), but ignored the `no_proxy` variable.

Now, Puppet will respect a comma-separated list of domain exceptions in the `no_proxy` environment variable, if present. The exceptions can be:

* Full domains (`web01.example.com`)
* IP addresses (`127.0.0.1`)
* Domain suffixes beginning with a dot (`.example.com`)
* Domains with `*` as a wildcard (`*.example.com`)
* Any of the above with a port number included (`*.example.com:8081`)

Special thanks to [Chris Portman](https://github.com/ChrisPortman) for help with this.

* [PUP-4030: Add support for no_proxy env var](https://tickets.puppetlabs.com/browse/PUP-4030)

### New Features: Miscellaneous

[splay]: ./configuration.html#splay

Puppet apply now supports [the `splay` setting][splay], and Puppet agent sets a new [`agent_specified_environment` fact](./lang_facts_and_builtin_vars.html#puppet-agent-facts).

And of internal interest only: The `node` HTTPS endpoint has a new, optional, `configured_environment` query parameter.

* [PUP-4363: Support splay in apply as well](https://tickets.puppetlabs.com/browse/PUP-4363)
* [PUP-4521: Pass agent-requested environment to external node classifiers](https://tickets.puppetlabs.com/browse/PUP-4521)
* [PUP-4522: Provide Facts for a classifier to select whether to enable overriding the environment](https://tickets.puppetlabs.com/browse/PUP-4522)

### New Features: Resource Types and Providers

* [PUP-1253: systemd service provider should support masking](https://tickets.puppetlabs.com/browse/PUP-1253)
* [PUP-4503: systemd should be the default provider for Debian Jessie](https://tickets.puppetlabs.com/browse/PUP-4503)
* [PUP-4663: Make systemd the default service provider for Fedora 22](https://tickets.puppetlabs.com/browse/PUP-4663)
* [PUP-4210: Support "rename" in the augeas resource type](https://tickets.puppetlabs.com/browse/PUP-4210)
* [PUP-3480: Puppet does not have Python 3 package provider (pip3)](https://tickets.puppetlabs.com/browse/PUP-3480)

### Performance Improvement: Catalog Application

This release gets a cool and noticeable speed-up when applying catalogs. Special thanks to [Nelson Elhage](https://github.com/nelhage) for finding this win.

* [PUP-3930: Applying catalogs spends an inordinate amount of time checking for failed dependencies.](https://tickets.puppetlabs.com/browse/PUP-3930)

### Bug Fixes: Miscellaneous

* [PUP-4356: Remove undocumented puppetversion key functionality in module metadata](https://tickets.puppetlabs.com/browse/PUP-4356)

    This was undocumented, unused, and effectively unusable since it didn't let you specify ranges of versions (just a single x.y.z version).
* [PUP-3341: Puppet apply breaks when an ENC returns an environment](https://tickets.puppetlabs.com/browse/PUP-3341)
* [PUP-2638: Puppet apply fails to write the graph if puppet agent has never run](https://tickets.puppetlabs.com/browse/PUP-2638)
* [PUP-4747: resource_types response has AST for parameters' default values](https://tickets.puppetlabs.com/browse/PUP-4747)

    The `resource_type` HTTP API's response format changed when we didn't intend it to. This restores the documented response format.
* [PUP-4538: plugin face application does not use source permissions during fact sync](https://tickets.puppetlabs.com/browse/PUP-4538)
* [PUP-4601: Puppet gem should require at least 1.9+ ruby version](https://tickets.puppetlabs.com/browse/PUP-4601)
* [PUP-3088: Debug logging messages can't be used by providers with a "path" method](https://tickets.puppetlabs.com/browse/PUP-3088)
* [PUP-4517: Add type name to Puppet.newtype deprecation warning](https://tickets.puppetlabs.com/browse/PUP-4517)
* [PUP-4436: With a gem install of puppet, when run as root, 'puppet agent / apply' fail](https://tickets.puppetlabs.com/browse/PUP-4436)

### Bug Fixes: Language

* [PUP-4648: Problem of indentation with epp()](https://tickets.puppetlabs.com/browse/PUP-4648)
* [PUP-4662: EPP template can't explicitly access top scope variables if there's no node definition in the scope chain](https://tickets.puppetlabs.com/browse/PUP-4662)
* [PUP-4665: Puppet::Parser::Scope has no inspect method which is causing an extremely large string to be produced](https://tickets.puppetlabs.com/browse/PUP-4665)
* [PUP-4668: cannot create a define named something that starts with 'class'](https://tickets.puppetlabs.com/browse/PUP-4668)
* [PUP-4698: Make fqdn_rand() Return A Numeric Instead of a String](https://tickets.puppetlabs.com/browse/PUP-4698)

    This was a regression from `fqdn_rand`'s behavior in 3.x, caused when we split strings and numbers into separate data types.
* [PUP-4709: Square braces in title confuse puppet 4 parser](https://tickets.puppetlabs.com/browse/PUP-4709)
* [PUP-4753: cannot call 4.x functions from 3.x function ERB templates](https://tickets.puppetlabs.com/browse/PUP-4753)

### Bug Fixes: Resource Types and Providers

#### Service

* [PUP-4431: Service with 'hasstatus => false' fails](https://tickets.puppetlabs.com/browse/PUP-4431)
* [PUP-4530: FreeBSD specific Service provider fix](https://tickets.puppetlabs.com/browse/PUP-4530)
* [PUP-4562: 'bsd' service provider non-functional](https://tickets.puppetlabs.com/browse/PUP-4562)
* [PUP-3166: Debian service provider on docker with insserv (dep boot sequencing)](https://tickets.puppetlabs.com/browse/PUP-3166)

#### Package

* [PUP-4497: Yum package provider: ensure => latest fails when obsoleted packages are present](https://tickets.puppetlabs.com/browse/PUP-4497)
* [PUP-4546: pkgin output incorrectly parsed](https://tickets.puppetlabs.com/browse/PUP-4546)
* [PUP-4635: Cannot install packages without membership to any group with pacman provider](https://tickets.puppetlabs.com/browse/PUP-4635)
* [PUP-4131: Gem version specifiers are not idempotent](https://tickets.puppetlabs.com/browse/PUP-4131)
* [PUP-1295: Yum provider "purge" target runs irrespective of package installation status](https://tickets.puppetlabs.com/browse/PUP-1295)

#### User and Group

* [PUP-4386: Windows Group resource reports errors incorrectly when specifying an invalid group member](https://tickets.puppetlabs.com/browse/PUP-4386)
* [PUP-4693: The pw provider for users and groups should be confined to freeBSD](https://tickets.puppetlabs.com/browse/PUP-4693)

    The BSD-only `pw` provider was being accidentally used by several Linux distros; that's now fixed.

#### Other

* [PUP-1931: mount provider improvement when options property is not specified](https://tickets.puppetlabs.com/browse/PUP-1931)
