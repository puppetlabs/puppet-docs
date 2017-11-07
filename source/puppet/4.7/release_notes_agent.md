---
layout: default
title: "Puppet agent release notes"
canonical: "/puppet/latest/release_notes_agent.html"
---

[Puppet 4.7.0]: /puppet/4.7/release_notes.html#puppet-470
[Puppet 4.7.1]: /puppet/4.7/release_notes.html#puppet-471

[Facter 3.4.1]: /facter/3.4/release_notes.html#facter-341
[Facter 3.4.2]: /facter/3.4/release_notes.html#facter-342

[Hiera 3.2.1]: /hiera/3.2/release_notes.html#hiera-321
[Hiera 3.2.2]: /hiera/3.2/release_notes.html#hiera-322

[MCollective 2.9.0]: /mcollective/releasenotes.html#2_9_0
[MCollective 2.9.1]: /mcollective/releasenotes.html#2_9_1

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

[security]: /security/index.html

[cpp-pcp-agent]: https://github.com/puppetlabs/cpp-pcp-client

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.7 release notes](./release_notes.html).

## Puppet agent 1.7.2

Released January 17, 2017.

This is a maintenance release. Many components in the `puppet-agent` package have been updated, you can find more information on their individual release notes pages.

### Component updates

Updates to compenents include [Puppet 4.7.1][], [Facter 3.4.2][], [Hiera 3.2.2][], [MCollective 2.9.1][], [pxp-agent][] 1.2.1, and [cpp-pcp-agent][] 1.2.1.

## Puppet agent 1.7.1

Released October 20, 2016.

This is a security release, addressing vulnerabilities in OpenSSL, curl, and [pxp-agent][]. You can read about the related CVEs in the [security section][security].

## Puppet agent 1.7.0

Released September 22, 2016.

This release updates the puppet-agent package to a new GPG signing key.

### Component updates

A critical bug fix is included in [Puppet 4.7.0][].