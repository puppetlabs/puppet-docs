---
layout: default
title: "Puppet Agent Release Notes"
canonical: "/puppet/latest/reference/release_notes_agent.html"
---

[Puppet 4.3.0]: /puppet/4.3/reference/release_notes.html#puppet-430
[Facter 3.1.2]: /facter/3.1/reference/release_notes.html#facter-312
[Hiera 3.0.5]: /hiera/3.0/release_notes.html#hiera-305
[MCollective 2.8.6]: /mcollective/releasenotes.html#2_8_6

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

The `puppet-agent` package installs Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](/puppet/4.3/reference/about_agent.html) and the [Puppet 4.3 release notes](/puppet/4.3/reference/release_notes.html).

## Puppet Agent 1.3.0

Released November 17, 2015.

Includes [Puppet 4.3.0][], [Facter 3.1.2][], [Hiera 3.0.5][], [MCollective 2.8.6][], Ruby 2.1.7, and OpenSSL 1.0.2d. This version also introduces the [`pxp-agent`](https://github.com/puppetlabs/pxp-agent) component at version 1.0.0 in support of the [PCP Execution Protocol](https://github.com/puppetlabs/pcp-specifications/blob/master/pxp/README.md) and forthcoming Application Orchestration features in Puppet Enterprise 2015.3.

### New Platforms

This release adds `puppet-agent` packages for OS X 10.11 (El Capitan).


### Windows Server 2003 Removed

We no longer provide `puppet-agent` packages that will install on Windows Server 2003 or Server 2003 R2. We [deprecated](./deprecated_win2003.html) those platforms in Puppet 4.2.

### Bug Fixes

* Resolves [a daemonization issue on AIX](https://tickets.puppetlabs.com/browse/PA-67) that made the service appear to be inoperative when running.

### Updated Components

* Updates Puppet and Facter. This release also updates Hiera, but the update contains no functional changes.
* [Updates vendored Ruby gems on Windows](https://tickets.puppetlabs.com/browse/PA-69) and [registers non-MCollective vendored gems](https://tickets.puppetlabs.com/browse/PA-25) on all platforms.
* Adds [more certificates](https://tickets.puppetlabs.com/browse/PA-73) to enable Forge access on non-Windows platforms.

### Updated Paths

* [Moves `dmidecode`](https://tickets.puppetlabs.com/browse/PA-2) to `/opt/puppetlabs/puppet/bin`.

### 1.2.x and earlier

For details on `puppet-agent` 1.2.x releases, see [their release notes](/puppet/4.2/reference/release_notes_agent.html).

For details on `puppet-agent` 1.1.x and earlier, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).
