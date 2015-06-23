---
layout: default
title: "Puppet 4.2 Release Notes"
---




This page lists the changes in Puppet 4.2 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes


## Puppet 4.2.0

Released June 24, 2015.

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

[splay]: /references/4.2.latest/configuration.html#splay

Puppet apply now supports [the `splay` setting][splay], and Puppet agent sets a new [`agent_specified_environment` fact](./lang_facts_and_builtin_vars.html#puppet-agent-facts).

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
* [PUP-4436: With a gem install of puppet, when run as root, 'puppet {agent|apply}' fail](https://tickets.puppetlabs.com/browse/PUP-4436)

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

