---
layout: default
title: "Puppet agent release notes"
---

[Puppet 4.10]: /puppet/4.10/release_notes.html#puppet-410

[Facter 3.6.3]: /facter/3.6/release_notes.html#facter-363

[MCollective 2.10.3]: /mcollective/releasenotes.html#2_10_3

[pxp-agent]: https://github.com/puppetlabs/pxp-agent


This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/reference/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 4.10 release notes](./release_notes.html).


## Puppet agent 1.10.0

Released April 5, 2017.

### Component updates

Components with updates in this release are [Puppet 4.10][], [Facter 3.6.3][], [MCollective 2.10.3][], and [`pxp-agent`][] 1.5.0.

The largest updates in this release include improvements and bug fixes for Hiera 5, which ships with Puppet 4.10.

#### `pxp-agent` new feature

`pxp-agent` Now responds to PXP non-blocking requests that use a duplicate transaction ID by sending a provisional response, rather than an error message. Status requests can then be sent as normal to check on the status of the original request that was duplicated. It also detects duplicate IDs that are stored on-disk, rather than only those in-memory (it no longer "forgets" when the process is restarted). ([PCP-627](https://tickets.puppetlabs.com/browse/PCP-627))

#### `pxp-agent` bug fix

The default ping interval has been increased to two minutes to reduce disconnect and reconnect cycling against a heavily loaded broker. This has a side effect that failover when a connection is unavailable but the TCP connection was not properly closed now takes 4-6 minutes instead of 35-50 seconds. ([PCP-729](https://tickets.puppetlabs.com/browse/PCP-627))