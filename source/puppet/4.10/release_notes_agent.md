---
layout: default
title: "Puppet agent release notes"
---

[Puppet 4.10.0]: /puppet/4.10/release_notes.html#puppet-4100
[Puppet 4.10.1]: /puppet/4.10/release_notes.html#puppet-4101
[Puppet 4.10.2]: /puppet/4.10/release_notes.html#puppet-4102

[Facter 3.6.3]: /facter/3.6/release_notes.html#facter-363
[Facter 3.6.4]: /facter/3.6/release_notes.html#facter-364
[Facter 3.6.5]: /facter/3.6/release_notes.html#facter-365

[Hiera 3.3.2]: /hiera/3.3/release_notes.html#hiera-332

[MCollective 2.10.3]: /mcollective/releasenotes.html#2_10_3
[MCollective 2.10.4]: /mcollective/releasenotes.html#2_10_4
[MCollective 2.10.5]: /mcollective/releasenotes.html#2_10_5

[`pxp-agent`]: https://github.com/puppetlabs/pxp-agent


This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 4.10 release notes](./release_notes.html).

## Puppet agent 1.10.3

Released June 15, 2017.

### Component updates

This release only affects Puppet. Using ampersands (&) in custom facts was causing Puppet runs to fail in Puppet 4.10.2. This release includes Puppet 4.10.3, which resolves that issue.

## Puppet agent 1.10.2

Released June 12, 2017.

### Component updates

This is a bug fix release with updates to several components, including [Puppet 4.10.2][], [Facter 3.6.5][], [Hiera 3.3.2][], [MCollective 2.10.5][], and [`pxp-agent`][] 1.5.3.

## Puppet agent 1.10.1

Released May 11, 2017.

### Component updates

This is a security release with an update to OpenSSL 1.0.2k, and also includes bug fixes for [Puppet 4.10.1][], [MCollective 2.10.4][], and [Facter 3.6.4][].

An authenticated agent could make a catalog request with facts encoded in YAML. The Puppet master did not properly validate and reject the request, resulting in the server loading arbitrary objects, which could lead to remote code execution. ([PUP-7483](https://tickets.puppetlabs.com/browse/PUP-7483))

### End of life platforms

As of the Puppet agent 1.10.1 release, we no longer ship packages for EL 4, Fedora 23, and Ubuntu 12.04.

## Puppet agent 1.10.0

Released April 5, 2017.

### Component updates

Components with updates in this release are [Puppet 4.10.0][], [Facter 3.6.3][], [MCollective 2.10.3][], and [`pxp-agent`][] 1.5.0.

The largest updates in this release include improvements and bug fixes for Hiera 5, which ships with Puppet 4.10.

#### `pxp-agent` new feature

`pxp-agent` Now responds to PXP non-blocking requests that use a duplicate transaction ID by sending a provisional response, rather than an error message. Status requests can then be sent as normal to check on the status of the original request that was duplicated. It also detects duplicate IDs that are stored on-disk, rather than only those in-memory (it no longer "forgets" when the process is restarted). ([PCP-627](https://tickets.puppetlabs.com/browse/PCP-627))

#### `pxp-agent` bug fix

The default ping interval has been increased to two minutes to reduce disconnect and reconnect cycling against a heavily loaded broker. This has a side effect that failover when a connection is unavailable but the TCP connection was not properly closed now takes 4-6 minutes instead of 35-50 seconds. ([PCP-729](https://tickets.puppetlabs.com/browse/PCP-627))