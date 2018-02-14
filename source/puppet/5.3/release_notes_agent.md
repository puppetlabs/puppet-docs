---
layout: default
title: "Puppet agent release notes"
---

[Puppet 5.0.0]: /puppet/5.0/release_notes.html#puppet-500
[Puppet 5.1.0]: /puppet/5.1/release_notes.html#puppet-510
[Puppet 5.2.0]: /puppet/5.2/release_notes.html#puppet-520
[Puppet 5.3.1]: /puppet/5.3/release_notes.html#puppet-531
[Puppet 5.3.2]: /puppet/5.3/release_notes.html#puppet-532
[Puppet 5.3.3]: /puppet/5.3/release_notes.html#puppet-533
[Puppet 5.3.4]: /puppet/5.3/release_notes.html#puppet-534
[Puppet 5.3.5]: /puppet/5.3/release_notes.html#puppet-535

[Facter 3.9.0]: /facter/3.9/release_notes.html#facter-390
[Facter 3.9.2]: /facter/3.9/release_notes.html#facter-392
[Facter 3.9.3]: /facter/3.9/release_notes.html#facter-393
[Facter 3.9.4]: /facter/3.9/release_notes.html#facter-394
[Facter 3.9.5]: /facter/3.9/release_notes.html#facter-395

[MCollective 2.11.2]: /mcollective/releasenotes.html#2_11_2
[MCollective 2.11.3]: /mcollective/releasenotes.html#2_11_3
[MCollective 2.11.4]: /mcollective/releasenotes.html#2_11_4

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y may increase for backward-compatible new functionality
-   Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 5.2.0][], [Puppet 5.1.0][], and [Puppet 5.0.0][] release notes.

## Puppet agent 5.3.5

Released February 13, 2018.

This release of Puppet Platform contains several Puppet bug fixes, and security fixes for Puppet and Facter.

### Component updates

This release includes component updates to [Puppet 5.3.5][], [Facter 3.9.5][], and [pxp-agent][] 1.8.2.

### Platform updates

This release adds packages for FIPS-enabled platforms.

## Puppet agent 5.3.4

Released February 5, 2018.

This release of Puppet Platform contains several Puppet bug fixes, and security fixes for Puppet and Facter.

### Component updates

This release includes component updates to [Puppet 5.3.4][] and [Facter 3.9.4][].

### Platform updates

This release adds packages for RHEL 7 on ARM architectures, macOS 10.13 High Sierra, and Amazon Linux 2 (as RHEL 7).

## Puppet agent 5.3.3

Released November 6, 2017.

This release of Puppet Platform contains several Puppet and Facter bug fixes.

### Component updates

This release includes component updates to [Puppet 5.3.3][], [Facter 3.9.3][], and [MCollective 2.11.4][]. It also updates Puppet's vendored cURL to v7.56.1, and updates its certificate authority (CA) certificate bundle.

This release also updates Puppet's vendored Ruby to version 2.4.2, which addresses the following security vulnerabilities:

-   CVE-2017-0898
-   CVE-2017-10784
-   CVE-2017-14033
-   CVE-2017-14064

### Bug fixes

-   When running Facter from previous versions of the Puppet agent package on a machine with a Power8 architecture, `dmesg` would produce an error message:

    ```
    Program dmidecode tried to access /dev/mem between f0000->100000.
    ```

    Puppet agent 5.3.3 resolves this issue by not including a vendored `dmidecode` in packages targeting Power8 architectures.

## Puppet agent 5.3.2

Released October 5, 2017.

This is a bug-fix release of Puppet Platform that adds a [new `disable_i18n` setting](./configuration_about_settings.html) to optionally disable some internationalized strings for improved performance.

### Component updates

This release includes a component update to [Puppet 5.3.2][].

## Puppet agent 5.3.1

Released October 2, 2017.

This is a feature and bug-fix release of Puppet Platform that also adds new operating system packages. There was no packaged release of Puppet agent 5.3.0; version 5.3.1 is the first packaged release of the 5.3.x series.

### Component updates

This release includes component updates to [Puppet 5.3.1][], [Facter 3.9.2][], [MCollective 2.11.3][], and [pxp-agent][] 1.8.0.

### Platform updates

This release adds packages for Fedora 26, and for SLES 12 on POWER architectures. It also removes packages for Fedora 24, which [entered end-of-life status on August 8, 2017](https://fedoraproject.org/wiki/End_of_life).
