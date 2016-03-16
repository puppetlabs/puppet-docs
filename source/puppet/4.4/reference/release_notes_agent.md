---
layout: default
title: "Puppet Agent Release Notes"
canonical: "/puppet/latest/reference/release_notes_agent.html"
---

[Puppet 4.4.0]: /puppet/4.4/reference/release_notes.html#puppet-440

[Facter 3.1.5]: /facter/3.1/release_notes.html#facter-315

[Hiera 3.1.0]: /hiera/3.0/release_notes.html#hiera-310

[MCollective 2.8.8]: /mcollective/releasenotes.html#2_8_8

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

The `puppet-agent` package installs Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.4 release notes](./release_notes.html).

## Puppet Agent 1.4.0

Released March 16, 2016.

Includes [Puppet 4.4.0][], [Facter 3.1.5][], [Hiera 3.1.0][], [MCollective 2.8.8][], [`pxp-agent`][pxp-agent] 1.1.1, OpenSSL 1.0.2g, and Ruby to 2.1.8.

### Component Updates

* Updates [Puppet](/puppet/4.4/reference/), [Hiera](/hiera/3.1/), and [Facter](/facter/3.1/). This release also updates Mcollective and pxp-agent, but the updates to these components contain no functional changes.

### New Platform

This release adds `puppet-agent` packages for Fedora 23.

### Windows Certificate Updates

* Windows `puppet-agent` MSI packages are now signed with a new SHA-2 certificate. This is an update from a now expired SHA-1 certificate that was previously used to sign packages. This change does not affect your interaction with `puppet-agent`.


### 1.3.x and earlier

For details on `puppet-agent` 1.3.x releases, see [their release notes](/puppet/4.3/reference/release_notes_agent.html).

For details on `puppet-agent` 1.2.x releases, see [their release notes](/puppet/4.2/reference/release_notes_agent.html).

For details on `puppet-agent` 1.1.x and earlier, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).
