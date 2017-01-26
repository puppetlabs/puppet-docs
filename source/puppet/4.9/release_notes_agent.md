---
layout: default
title: "Puppet agent release notes"
---

[Puppet 4.8.0]: /puppet/4.8/reference/release_notes.html#puppet-480
[Puppet 4.8.1]: /puppet/4.8/reference/release_notes.html#puppet-481


[Facter 3.5.0]: /facter/3.5/release_notes.html#facter-350

[Hiera 3.2.2]: /hiera/3.2/release_notes.html#hiera-322

[MCollective 2.9.1]: /mcollective/releasenotes.html#2_9_1

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

[security]: /security/index.html


This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 4.9 release notes](./release_notes.html).

## Puppet agent 1.9.0

Released January  , 2017.

### Component updates


### New platforms

We now have `puppet-agent` packages available for the following platform:

* Fedora 25

### Platforms end of life

We will no longer be providing packages for the following platforms:

* Fedora 22
* Mac OS X 10.9
* Ubuntu 15.10 (Wily)
* Ubuntu 10.04 (Lucid)
* SLES 10