---
layout: default
title: "Puppet agent release notes"
---

[Puppet 5.0.1]: /puppet/5.0/release_notes.html#puppet-501

[Facter 3.7.0]: /facter/3.7/release_notes.html#facter-370
[Facter 3.7.1]: /facter/3.7/release_notes.html#facter-371

[MCollective 2.11.0]: /mcollective/releasenotes.html#2_11_0
[MCollective 2.11.1]: /mcollective/releasenotes.html#2_11_1

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 5.0 release notes](./release_notes.html).

## Puppet agent 5.0.1

Released July 19, 2017.

This is a minor bug fix release in the Puppet agent 5 series.

### Component updates

The components updated in this release are [Puppet 5.0.1][], [Facter 3.7.1][], [MCollective 2.11.1][], and [pxp-agent][] 1.6.1.

## Puppet agent 5.0.0

Released June 26, 2017.

This is a major release of Puppet agent, and includes updates to nearly every component.

### Component updates

-   **Puppet 5:** Feature improvements for types and providers, UTF-8, and Hiera 5.
-   **Ruby 2.4:** Reinstallation of user-installed Puppet agent gems is required after upgrade to Puppet agent 5.0.
    -    Due to Ruby API changes between Ruby 2.1 and 2.4, any user-installed Puppet agent gems (Ruby gems installed using Puppet agent's gem binary) require re-installation following upgrade to Puppet agent 5.0.
    -    Some gems may also require upgrade to versions that are compatible with Ruby 2.4.
-   **Augeas 1.8.0:** This component has been updated from 1.4.0 to resolve issues caused by a segfault.
-   **Facter 3.7:** Read the [Facter 3.7.0][] release notes about some small bug fixes in this release.
-   **MCollective 2.11:** Read the [MCollective 2.11.0][] release notes to see the bug fixes in this verison.
-   **`pxp-agent` 1.6.0:** `pxp-module-puppet` now returns metrics about resource events when a run finishes. It can also accept `job-id` as an argument and pass it to Puppet.
-   **Hiera 3.4:** The component version of Hiera in Puppet agent has been increased to 3.4, but Hiera 5 is fully integrated into Puppet. You should update your configuration to use version 5 of `hiera.yaml`.

### New packages

Packages are now available for Ubuntu 16.04 ppc64le and EL7 ppc64le.

### Removed packages

AIX 5.3 and HuaweiOS are no longer available as an open source package for `puppet-agent`.