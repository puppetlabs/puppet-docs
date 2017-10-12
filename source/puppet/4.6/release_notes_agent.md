---
layout: default
title: "Puppet agent release notes"
canonical: "/puppet/latest/release_notes_agent.html"
---

[Puppet 4.6.0]: /puppet/4.6/release_notes.html#puppet-460
[Puppet 4.6.1]: /puppet/4.6/release_notes.html#puppet-461
[Puppet 4.6.2]: /puppet/4.6/release_notes.html#puppet-462

[Facter 3.4.0]: /facter/3.4/release_notes.html#facter-340
[Facter 3.4.1]: /facter/3.4/release_notes.html#facter-341

[Hiera 3.2.1]: /hiera/3.2/release_notes.html#hiera-321

[MCollective 2.9.0]: /mcollective/releasenotes.html#2_9_0

[pxp-agent]: https://github.com/puppetlabs/pxp-agent


This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.6 release notes](./release_notes.html).

## Puppet agent 1.6.2

Released September 1, 2016.

This release fixes Puppet regressions introduced by 1.6.0 and 1.6.1, as well as a few other bugs.

### Component updates

This release updates [Puppet 4.6.2][].

## Puppet agent 1.6.1

Released August 23, 2016.

This release in the Puppet agent 1.6 series includes a critical bug fix for Puppet.

### Component updates

This release updates [Puppet 4.6.1][], [Facter 3.4.1][], and [pxp-agent][] 1.2.1.

## Puppet agent 1.6.0

Released August 10, 2016.

### Component updates

This release includes updates to most of the components in Puppet agent, [Puppet 4.6.0][], [Facter 3.4.0][], [Hiera 3.2.1][], [MCollective 2.9.0][], and [pxp-agent][] 1.2.0.

### New platforms

Puppet agent has recently added packages for the following platforms, in some cases there were packages for the platform but not specifically the architecture.

* SUSE Linux Enterprise Server 11 s390x
* SUSE Linux Enterprise Server 12 s390x
* Red Hat Enterprise Linux 6 s390x
* Red Hat Enterprise Linux 7 s390x
* Fedora 24
