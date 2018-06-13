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
[Puppet 5.3.6]: /puppet/5.3/release_notes.html#puppet-536
[Puppet 5.3.7]: /puppet/5.3/release_notes.html#puppet-537

[Facter 3.9.0]: /facter/3.9/release_notes.html#facter-390
[Facter 3.9.2]: /facter/3.9/release_notes.html#facter-392
[Facter 3.9.3]: /facter/3.9/release_notes.html#facter-393
[Facter 3.9.4]: /facter/3.9/release_notes.html#facter-394
[Facter 3.9.5]: /facter/3.9/release_notes.html#facter-395
[Facter 3.9.6]: /facter/3.9/release_notes.html#facter-396

[MCollective 2.11.2]: /mcollective/releasenotes.html#2_11_2
[MCollective 2.11.3]: /mcollective/releasenotes.html#2_11_3
[MCollective 2.11.4]: /mcollective/releasenotes.html#2_11_4
[MCollective 2.11.5]: /mcollective/releasenotes.html#2_11_5

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y may increase for backward-compatible new functionality
-   Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 5.2.0][], [Puppet 5.1.0][], and [Puppet 5.0.0][] release notes.

## Puppet agent 5.3.8

Released June 13, 2018.

This release of Puppet agent resolves a critical Windows installer bug.

### Component updates

There are no component updates in this Puppet agent release.

### Bug fixes

-   The previous version of the Windows Puppet agent installer had an internal MSI property resolution issue that could be triggered when requesting that msiexec install the same version of the Puppet agent package that was already installed on the node. In those rare instances, and when combined with the permission resetting code introduced in [PA-2019](https://tickets.puppetlabs.com/browse/PA-2019) as a response to CVE-2018-6513, the Puppet agent package could execute `takeown.exe` and `icacls.exe` against the filesystem root (`C:\`), resulting in incorrectly rewritten permissions across the filesystem.

    Using the Chocolatey package provider to perform an in-place upgrade of the Puppet package during a Puppet run, which is the workflow used by Foreman, most commonly triggered this behavior.

    Puppet agent 5.3.8 resolves both of these problems by implementing a workaround of the MSI property resolution issue and making the PA-2019 permission resetting code more defensive. ([PA-2075](https://tickets.puppetlabs.com/browse/PA-2075))

-   In Puppet agent 5.3.7, Puppet's systemd services were not always enabled as expected on Debian and derivative operating systems, such as within the `debian-installer` chroot. This could lead to Puppet services being disabled after an automated deployment of agent 5.3.7 on these operating systems. Puppet agent 5.3.8 fixes this regression. ([PA-2072](https://tickets.puppetlabs.com/browse/PA-2072))


## Puppet agent 5.3.7

Released June 7, 2018.

This release of Puppet Platform contains several Puppet and Facter security and bug fixes.

### Known issues

-   Due to an issue with the Windows installer, Puppet agent 5.3.7 can inadvertently change permissions on files across a Windows node's filesystem when re-installed or in certain rare installation scenarios. This can cause serious issues on those nodes. The Puppet agent 5.3.7 installer binaries for Windows have been removed from our downloads as well as the Chocolatey community feed, and they should not be installed if downloaded or installed on their own or as part of Puppet Enterprise (PE) 2017.3.7. ([PA-2075](https://tickets.puppetlabs.com/browse/PA-2075))

### Component updates

This release updates Puppet to [Puppet 5.3.7][].

### Bug fixes

-   Previous versions of Puppet on Ruby 2.0 or newer would close and reopen HTTP connection that were idle for more than 2 seconds, causing increased load on Puppet masters. This version of Puppet ensures that the agent uses the `http_keepalive_timeout` setting when determining when to close idle connections. ([PUP-8663](https://tickets.puppetlabs.com/browse/PUP-8663))

-   When installing or updating `puppet-agent` 5.3.7, it updates the `MANPATH` environment variable so that Puppet's man pages are available. ([PA-1847](https://tickets.puppetlabs.com/browse/PA-1847))

### Security updates

-   On Windows, Puppet no longer includes `/opt/puppetlabs/puppet/modules` in its default basemodulepath, because unprivileged users could create a `C:\opt` directory and escalate privileges. ([PUP-8707](https://tickets.puppetlabs.com/browse/PUP-8707))

-   This version of Puppet agent restricts permissions to some directories within `C:\ProgramData\PuppetLabs` so that only LocalSystem and members of the local Administrators group have access. ([PA-2019](https://tickets.puppetlabs.com/browse/PA-2019))

## Puppet agent 5.3.6

Released April 17, 2018.

This release of Puppet Platform contains several Puppet and Facter bug fixes.

### Component updates

This release includes component updates to [Puppet 5.3.6][], [Facter 3.9.6][], Hiera 3.4.3, [MCollective 2.11.5][], and [pxp-agent][] 1.8.3. It also updates `virt-what` to version 1.18 on Linux platforms.

### Security update

-   Updates `curl` to version 7.59.0. ([PA-1913](https://tickets.puppetlabs.com/browse/PA-1913))

### Bug fixes

-   The `puppet-agent` package no longer invokes custom facts on upgrade, avoiding a deadlock when such a fact tried to access the package manager's database. ([PA-1402](https://tickets.puppetlabs.com/browse/PA-1402))

-   Resolved an issue that prevented locales from appearing. ([PA-1846](https://tickets.puppetlabs.com/browse/PA-1846))

-   All of the Dynamic Link Library (dll) files required by the `pxp-agent` binary are copied to the executable's directory (`<pxp-agent-install-root>/bin`). ([PA-1850](https://tickets.puppetlabs.com/browse/PA-1850))

-   Any `hiera.yaml` files that exist on the old agent are now copied to temporary files during an agent upgrade via an RPM package provider, in a manner that preserves permissions and file metadata. ([PA-1890](https://tickets.puppetlabs.com/browse/PA-1890))

-   MCollective now relies only on its internal log rotation rather than also using the `logrotate` configuration. This prevents conflicting rotations and simplifies configuration. ([PA-1908](https://tickets.puppetlabs.com/browse/PA-1908))

-   Log rotation under `systemd` correctly signals `pxp-agent` to re-open the log file. ([PCP-834](https://tickets.puppetlabs.com/browse/PCP-834))

### Platform updates

This release removes packages for Fedora 25.

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
