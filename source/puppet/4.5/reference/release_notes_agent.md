---
layout: default
title: "Puppet agent release notes"
canonical: "/puppet/latest/reference/release_notes_agent.html"
---

[Puppet 4.5.0]: /puppet/4.5/reference/release_notes.html#puppet-450
[Puppet 4.5.1]: /puppet/4.5/reference/release_notes.html#puppet-451


[Facter 3.1.7]: /facter/3.1/release_notes.html#facter-317
[Facter 3.1.8]: /facter/3.1/release_notes.html#facter-318

[Hiera 3.2.0]: /hiera/3.2/release_notes.html#hiera-320


[MCollective 2.8.8]: /mcollective/releasenotes.html#2_8_8

[pxp-agent]: https://github.com/puppetlabs/pxp-agent


This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.5 release notes](./release_notes.html).

## Puppet agent 1.5.2

Released June 14, 2016.

### Component updates

Bug fixes in Puppet 4.5.2.

All other components remain unchanged from `puppet-agent` 1.5.1.

## Puppet agent 1.5.1

Released June 1, 2016.

### Component updates

Includes bug fixes in [Puppet 4.5.1][], and [Facter 3.1.8][].

All other components remain unchanged from `puppet-agent` 1.5.0.

## Puppet agent 1.5.0

Released May 17, 2016.

### Component updates

Includes [Puppet 4.5.0][], [Facter 3.1.7][], and [Hiera 3.2.0][].

Ruby has been updated to 2.1.9, on all platforms except Windows. 

### Path change 

The default location of hiera.yaml has changed from the `$codedir` to the `$confdir`. Updating to `puppet-agent 1.5.0` will not move your existing file, but new installations will place it in this location. You should move the file to `$confdir`.

MCollective, pxp-agent, and OpenSSL remain unchanged from `puppet-agent` 1.4.2.

## 1.4.x and earlier

* [`puppet-agent` 1.4.x release notes](/puppet/4.4/reference/release_notes_agent.html).

* [`puppet-agent` 1.3.x release notes](/puppet/4.3/reference/release_notes_agent.html).

* [`puppet-agent` 1.2.x release notes](/puppet/4.2/reference/release_notes_agent.html).

* For details on `puppet-agent` 1.1.x and earlier, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).