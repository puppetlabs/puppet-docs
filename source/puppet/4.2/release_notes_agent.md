---
layout: default
title: "Puppet Agent 1.2.x Release Notes"
canonical: "/puppet/latest/release_notes_agent.html"
---

[Puppet 4.2.0]: ./release_notes.html#puppet-420
[Puppet 4.2.1]: ./release_notes.html#puppet-421
[Puppet 4.2.2]: ./release_notes.html#puppet-422
[Puppet 4.2.3]: ./release_notes.html#puppet-423
[Facter 3.0.0]: /facter/3.0/reference/release_notes.html#facter-300
[Facter 3.0.1]: /facter/3.0/reference/release_notes.html#facter-301
[Facter 3.0.2]: /facter/3.0/reference/release_notes.html#facter-302
[Facter 3.1.0]: /facter/3.1/reference/release_notes.html#facter-310
[Facter 3.1.1]: /facter/3.1/reference/release_notes.html#facter-311
[Hiera 3.0.1]: /hiera/3.0/release_notes.html#hiera-301
[Hiera 3.0.3]: /hiera/3.0/release_notes.html#hiera-303
[Hiera 3.0.4]: /hiera/3.0/release_notes.html#hiera-304
[MCollective 2.8.6]: /mcollective/releasenotes.html#2_8_6
[MCollective 2.8.5]: /mcollective/releasenotes.html#2_8_5
[MCollective 2.8.2]: /mcollective/releasenotes.html#2_8_2

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

The `puppet-agent` package installs Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.2 release notes](./release_notes.html).

## Puppet Agent 1.2.7

Released October 29, 2015.

Includes [Puppet 4.2.3](./release_notes.html#puppet-423), [Facter 3.1.1][], [Hiera 3.0.4][], [MCollective 2.8.6][], Ruby 2.1.7, and OpenSSL 1.0.2d.

### New Platforms

The [Puppet Enterprise 2015.2.3](/pe/2015.2/) repositories include `puppet-agent` packages for AIX and Solaris 11.

### Security

* [Resolves a security issue](https://tickets.puppetlabs.com/browse/PA-27) in Windows.

### Updated Components

* Updates Puppet, Facter, and Hiera.
* Updates Ruby on Windows.
* [Adds a root certificate](https://tickets.puppetlabs.com/browse/PA-20) in Enterprise Linux 4 to enable Forge access.

### Updated Paths

* [Moves the OS X bill of materials](https://tickets.puppetlabs.com/browse/PA-21) to `/usr/local/share` on all supported OS X platforms to ensure future compatibility with OS X 10.11 (El Capitan)

## Puppet Agent 1.2.6

Released October 12, 2015.

Includes [Puppet 4.2.2](./release_notes.html#puppet-422), [Facter 3.1.0][], [Hiera 3.0.3][], [MCollective 2.8.6][], Ruby 2.1.6, and OpenSSL 1.0.2d.

This release contains no component fixes or updates. It only resolves a packaging issue that could leave the `puppet` and `mcollective` services stopped and unregistered after a package upgrade from an earlier `puppet-agent` release.

## Puppet Agent 1.2.5

Released October 1, 2015.

Includes [Puppet 4.2.2](./release_notes.html#puppet-422), [Facter 3.1.0][], [Hiera 3.0.3][], [MCollective 2.8.6][], Ruby 2.1.6, and OpenSSL 1.0.2d.

### Bug Fixes

* Updates [MCollective](/mcollective/releasenotes.html#changes-since-284) to fix an issue when trying to start `mcollectived` on Solaris 10.

### Updated File Names

* Changes the package file names on OS X to use major and minor OS versions (such as `puppet-agent-1.2.5-1.osx10.10.dmg`) instead of codenames (such as `puppet-agent-1.2.5-1.yosemite.dmg`).

## Puppet Agent 1.2.4

Released September 14, 2015.

Includes [Puppet 4.2.2](./release_notes.html#puppet-422), [Facter 3.1.0][], [Hiera 3.0.3][], [MCollective 2.8.5][], Ruby 2.1.6, and OpenSSL 1.0.2d.

### Updated Components

* Updates Puppet, Facter, and MCollective.

<a id="puppet-agent-123"></a>
There was no `puppet-agent` 1.2.3 release.

## Puppet Agent 1.2.2

Released July 22, 2015.

Includes [Puppet 4.2.1](./release_notes.html#puppet-421), [Facter 3.0.2][], [Hiera 3.0.1][], [MCollective 2.8.2][], Ruby 2.1.6, and OpenSSL 1.0.0s.

### Bug Fixes

* Resolves bugs in Facter and Puppet.

## Puppet Agent 1.2.1

Released June 25, 2015.

Includes [Puppet 4.2.0](./release_notes.html#puppet-420), [Facter 3.0.1][], [Hiera 3.0.1][], [MCollective 2.8.2][], Ruby 2.1.6, and OpenSSL 1.0.0s.

### Regression Fixes

* Fixes a regression in Facter.

## Puppet Agent 1.2.0

Released June 24, 2015.

Includes [Puppet 4.2.0](./release_notes.html#puppet-420), [Facter 3.0.0][], [Hiera 3.0.1][], [MCollective 2.8.2][], Ruby 2.1.6, and OpenSSL 1.0.0s.

### Updated Components

* Updates Puppet and Facter.

### Puppet Agent 1.1.x and earlier

For details on earlier `puppet-agent` releases, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).
