---
layout: default
title: "Puppet agent release notes"
---

[Puppet 5.0.0]: /puppet/5.0/release_notes.html#puppet-500
[Puppet 5.1.0]: /puppet/5.1/release_notes.html#puppet-510
[Puppet 5.2.0]: /puppet/5.2/release_notes.html#puppet-520
[Puppet 5.3.1]: /puppet/5.3/release_notes.html#puppet-531
[Puppet 5.4.0]: /puppet/5.4/release_notes.html#puppet-540
[Puppet 5.5.0]: /puppet/5.5/release_notes.html#puppet-550

[Facter 3.10.0]: /facter/3.10/release_notes.html#facter-3100
[Facter 3.11.0]: /facter/3.11/release_notes.html#facter-3110
[Facter 3.11.1]: /facter/3.11/release_notes.html#facter-3111

[MCollective 2.12.0]: /mcollective/current/releasenotes.html#2_12_0
[MCollective 2.12.1]: /mcollective/current/releasenotes.html#2_12_1

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y may increase for backward-compatible new functionality
-   Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 5.4.0][], [Puppet 5.3.1][], [Puppet 5.2.0][], [Puppet 5.1.0][], and [Puppet 5.0.0][] release notes.

## Puppet agent 5.5.1

Released April 17, 2018.

This release of Puppet Platform contains several new features and bug fixes.

### Component updates

This release includes component updates to [Puppet 5.5.1][], [Facter 3.11.1][], Hiera 3.4.3, [MCollective 2.12.1][], [pxp-agent][] 1.9.1, and LTH 1.4.1.

### Platform updates

This release removes packages for Fedora 25, macOS 10.10 and 10.11, Scientific Linux 5, and Windows Vista.

### Security updates

-   Updates `curl` to version 7.59.0. ([PA-1913](https://tickets.puppetlabs.com/browse/PA-1913))

### Bug fixes

-   MCollective now relies only on its internal log rotation rather than also using logrotate config. This prevents conflicting rotation and simplifies the config. ([PA-1908](https://tickets.puppetlabs.com/browse/PA-1908))

-   Log rotation under `systemd` correctly signals pxp-agent to re-open the log file. ([PCP-834](https://tickets.puppetlabs.com/browse/PCP-834))

### New features

-   puppet-agent 5.5.1 and above now ships the hiera-eyaml 2.1.0, highline 1.6.21, and trollop 2.1.2 Ruby gems in the shared gem directory. ([PA-1925](https://tickets.puppetlabs.com/browse/PA-1925))

## Puppet agent 5.5.0

Released March 20, 2018.

This release of Puppet Platform contains several new features and bug fixes.

### Component updates

This release includes component updates to [Puppet 5.5.0][], [Facter 3.11.0][], [MCollective 2.12.0][], and [pxp-agent][] 1.9.0.

### Platform updates

This release adds packages for Fedora 27.
