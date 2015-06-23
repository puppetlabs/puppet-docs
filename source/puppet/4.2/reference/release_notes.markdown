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

4.2.0 is a feature release in the Puppet 4 series. This release's main focus was TODO. It also includes some improvements to resource types and a few miscellaneous fixes.

Also notable in this release: we're [officially deprecating Windows Server 2003 and 2003 R2][win2003dep], which we will stop supporting in Puppet 5.

* [All tickets fixed in 4.1.0](TODO)
* [Issues introduced in 4.1.0](TODO)


### DEPRECATED: Windows 2003

[win2003dep]: ./deprecated_win2003.html

* [PUP-4631: Introduce Windows 2003 deprecation notices](https://tickets.puppetlabs.com/browse/PUP-4631)

### New Feature: Support for the `no_proxy` Environment Variable

* [PUP-4030: Add support for no_proxy env var](https://tickets.puppetlabs.com/browse/PUP-4030)

    This change allows puppet to respect the `no_proxy` ENV var when set on the system. Previously, Puppet would respect the http(s)_proxy ENV var when connecting HTTP services (e.g. puppet forge) but ignore the no_proxy setting.

    Documentation is a bit inconsistent with regards to specifying domain level exception. WGET docs for example, state that the no_proxy list should be of suffixes and thus an entry with a preceding '.' (e.g. .example.com) creates an exception for any host under that domain. Curl man pages and other internet resources, suggest the use of a '*' as a wildcard.

    This change supports both notations.

    [Chris Portman](https://github.com/ChrisPortman)

### New Features: Miscellaneous

* [PUP-4363: Support splay in apply as well](https://tickets.puppetlabs.com/browse/PUP-4363)
* [PUP-4521: Pass agent-requested environment to external node classifiers](https://tickets.puppetlabs.com/browse/PUP-4521)
* [PUP-4522: Provide Facts for a classifier to select whether to enable overriding the environment](https://tickets.puppetlabs.com/browse/PUP-4522)


### Bug Fixes: Miscellaneous

* [PUP-4356: Remove undocumented puppetversion key functionality in module metadata](https://tickets.puppetlabs.com/browse/PUP-4356)
* [PUP-3341: Puppet apply breaks when an ENC returns an environment](https://tickets.puppetlabs.com/browse/PUP-3341)
* [PUP-2638: Puppet apply fails to write the graph if puppet agent has never run](https://tickets.puppetlabs.com/browse/PUP-2638)
* [PUP-4747: resource_types response has AST for parameters' default values](https://tickets.puppetlabs.com/browse/PUP-4747)
* [PUP-4538: plugin face application does not use source permissions during fact sync](https://tickets.puppetlabs.com/browse/PUP-4538)
* [PUP-4601: Puppet gem should require at least 1.9+ ruby version](https://tickets.puppetlabs.com/browse/PUP-4601)
* [PUP-3088: Debug logging messages can't be used by providers with a "path" method](https://tickets.puppetlabs.com/browse/PUP-3088)
* [PUP-4517: Add type name to Puppet.newtype deprecation warning](https://tickets.puppetlabs.com/browse/PUP-4517)
* [PUP-4436: With a gem install of puppet, when run as root, 'puppet {agent|apply}' fail](https://tickets.puppetlabs.com/browse/PUP-4436)

### Bug Fixes: Language

* [PUP-4648: Problem of indentation with epp()](https://tickets.puppetlabs.com/browse/PUP-4648)
* [PUP-4665: Puppet::Parser::Scope has no inspect method which is causing an extremely large string to be produced](https://tickets.puppetlabs.com/browse/PUP-4665)
* [PUP-4668: cannot create a define named something that starts with 'class'](https://tickets.puppetlabs.com/browse/PUP-4668)
* [PUP-4698: Make fqdn_rand() Return A Numeric Instead of a String](https://tickets.puppetlabs.com/browse/PUP-4698)
* [PUP-4709: Square braces in title confuse puppet 4 parser](https://tickets.puppetlabs.com/browse/PUP-4709)
* [PUP-4753: cannot call 4.x functions from 3.x function ERB templates](https://tickets.puppetlabs.com/browse/PUP-4753)
* [PUP-4662: EPP template can't explicitly access top scope variables if there's no node definition in the scope chain](https://tickets.puppetlabs.com/browse/PUP-4662)


### Performance Improvements

* [PUP-3930: Applying catalogs spends an inordinate amount of time checking for failed dependencies.](https://tickets.puppetlabs.com/browse/PUP-3930)

    [Nelson Elhage](https://github.com/nelhage)

### New Features: Resource Types and Providers

* [PUP-4503: systemd should be the default provider for Debian Jessie](https://tickets.puppetlabs.com/browse/PUP-4503)
* [PUP-4663: Make systemd the default service provider for Fedora 22](https://tickets.puppetlabs.com/browse/PUP-4663)
* [PUP-4210: Support "rename" in the augeas resource type](https://tickets.puppetlabs.com/browse/PUP-4210)
* [PUP-3480: Puppet does not have Python 3 package provider (pip3)](https://tickets.puppetlabs.com/browse/PUP-3480)
* [PUP-1253: systemd service provider should support masking](https://tickets.puppetlabs.com/browse/PUP-1253)

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

    Since the pw provider is only intended for use on BSD operating systems, it should use confine to prevent accidental activation on non-BSD systems. Linux was particularly susceptible to this as there are no default providers declared for that platform.

#### Other

* [PUP-1931: mount provider improvement when options property is not specified](https://tickets.puppetlabs.com/browse/PUP-1931)

