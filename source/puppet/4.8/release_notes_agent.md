---
layout: default
title: "Puppet agent release notes"
canonical: "/puppet/latest/release_notes_agent.html"
---

[Puppet 4.8.0]: /puppet/4.8/release_notes.html#puppet-480
[Puppet 4.8.1]: /puppet/4.8/release_notes.html#puppet-481
[Puppet 4.8.2]: /puppet/4.8/release_notes.html#puppet-482

[Facter 3.5.0]: /facter/3.5/release_notes.html#facter-350
[Facter 3.5.1]: /facter/3.5/release_notes.html#facter-351

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

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 4.8 release notes](./release_notes.html).

## Puppet agent 1.8.3

Released January 19, 2017.

## Component updates

This is a bug fix release, that includes [Puppet 4.8.2][], and [Facter 3.5.1][].

## Puppet agent 1.8.2

Released December 6, 2016.

### Component updates

This is a bug fix release that only updates [pxp-agent][]. All other components remain the same from the previous release.

## Puppet agent 1.8.1

Released November 22, 2016.

### Component updates

This is a minor release in the Puppet agent 1.8 series. It is primarily a maintenance and bug fix release, with an update to [Puppet 4.8.1][].

## Puppet agent 1.8.0

Released November 1, 2016.

### Component updates

Puppet agent 1.8.0 includes feature releases [Puppet 4.8.0][], and [Facter 3.5.0][], as well as [Hiera 3.2.2][], [MCollective 2.9.1][], and [pxp-agent][] 1.3.0.

### New platforms

Packages now available for the following platforms:

* Windows Server 2016
* macOS Sierra
