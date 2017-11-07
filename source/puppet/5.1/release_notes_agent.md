---
layout: default
title: "Puppet agent release notes"
---

[Puppet 5.1.0]: /puppet/5.1/release_notes.html#puppet-510

[Facter 3.8.0]: /facter/3.8/release_notes.html#facter-380

[MCollective 2.11.2]: /mcollective/releasenotes.html#2_11_2

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 5.0 release notes](./release_notes.html).

## Puppet agent 5.1.0

Released August 17, 2017.

### Component updates

This release of `puppet-agent` includes component updates to [Puppet 5.1.0][], [Facter 3.8.0][], and [MCollective 2.11.2][].

### New platforms

Packages have been added in this release for:

* Debian 9 "Stretch"
