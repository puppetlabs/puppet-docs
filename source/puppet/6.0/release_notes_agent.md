---
layout: default
title: "Puppet agent release notes"
---

[Puppet 5.5.6]: /docs/puppet/5.5/release_notes.html#puppet-556

[Facter 3.10.0]: /docs/facter/3.10/release_notes.html#facter-3100
[Facter 3.11.0]: /docs/facter/3.11/release_notes.html#facter-3110
[Facter 3.11.1]: /docs/facter/3.11/release_notes.html#facter-3111
[Facter 3.11.2]: /docs/facter/3.11/release_notes.html#facter-3112
[Facter 3.11.3]: /docs/facter/3.11/release_notes.html#facter-3113
[Facter 3.11.4]: /docs/facter/3.11/release_notes.html#facter-3114

[MCollective 2.12.0]: /docs/mcollective/current/releasenotes.html#2_12_0
[MCollective 2.12.1]: /docs/mcollective/current/releasenotes.html#2_12_1
[MCollective 2.12.2]: /docs/mcollective/current/releasenotes.html#2_12_2

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y may increase for backward-compatible new functionality
-   Z may increase for bug fixes

The `puppet-agent` package installs the latest version of Puppet 5.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 5.5.6][] release notes.

## Puppet agent 5.5.6

Released 22 August 2018

This is primarily a bug fix release. Note that there is no Puppet agent 5.5.5 release.

### Component updates

Puppet Platform 5.5.6 includes puppet-agent 5.5.6, [PuppetDB 5.2.4](/docs/puppetdb/5.2/release_notes.html), and [Puppet Server 5.3.5](/docs/puppetserver/5.3/release_notes.html).

`puppet-agent` 5.5.6 includes updates to [Puppet 5.5.6][], [Facter 3.11.4][], [Hiera 3.4.4][], `cpp-pcp-client` 1.5.7, and [`pxp-agent`][pxp-agent] 1.9.4.

See the linked release notes for details about each component release.

### Bug fixes

- After installing `puppet-agent-5.5.3-1.el6.s390x.rpm` on a CentOS 6 s390 box, all Puppet commands failed with a Ruby error. This is now fixed. ([PA-2126](https://tickets.puppetlabs.com/browse/PA-2126))

- The Puppet agent installer now idempotently sets permissions on the install folder on Windows. Previously it would run `takeown` and `icacls` against the folder recursively, potentially taking many minutes to run. ([PA-2113](https://tickets.puppetlabs.com/browse/PA-2113))


## Puppet agent 5.5.4

Released July 17, 2018.

This release of Puppet Platform contains several bug fixes, some new features, and several new deprecations in Puppet.

### Component updates

Puppet Platform 5.5.4 includes puppet-agent 5.5.4, [PuppetDB 5.2.3](/docs/puppetdb/5.2/release_notes.html), and [Puppet Server 5.3.4](/docs/puppetserver/5.3/release_notes.html).

`puppet-agent` 5.5.4 includes updates to [Puppet 5.5.3][], [Facter 3.11.3][], `cpp-pcp-client` 1.5.6, [`pxp-agent`][pxp-agent] 1.9.3, and `leatherman` 1.4.2. It also includes Hiera 3.4.3 and MCollective 2.12.2, which were not updated.

See the linked release notes for details about each component release.

> **Deprecation Note:** As of Puppet agent 5.5.4, MCollective is deprecated and will be removed in a future version of Puppet agent. If you use MCollective with Puppet Enterprise, consider [moving from MCollective to Puppet orchestrator](/docs/pe/2018.1/migrating_from_mcollective_to_orchestrator.html). If you use MCollective with open source Puppet, consider migrating MCollective agents and filters using tools like [Bolt](/docs/bolt/) and PuppetDB's [Puppet Query Language](/docs/puppetdb/latest/api/query/tutorial-pql.html).

### Platform updates

This version of Puppet agent adds packages for Fedora 28 (i386 and x86_64).

### Bug fixes

-   pxp-agent 1.9.3 adds proxy configuration options. Set a proxy between `pxp-agent` and `pcp-broker` with `broker-ws-proxy`, and between `pxp-agent` and a Puppet master with `master-proxy`.

## Puppet agent 5.5.3

Released June 13, 2018.

This release of Puppet agent resolves a critical Windows installer bug.

### Component updates

There are no component updates in this Puppet agent release.

### Bug fixes

-   The previous version of the Windows Puppet agent installer had an internal MSI property resolution issue that could be triggered when requesting that msiexec install the same version of the Puppet agent package that was already installed on the node. In those rare instances, and when combined with the permission resetting code introduced in [PA-2019](https://tickets.puppetlabs.com/browse/PA-2019) as a response to CVE-2018-6513, the Puppet agent package could execute `takeown.exe` and `icacls.exe` against the filesystem root (`C:\`), resulting in incorrectly rewritten permissions across the filesystem.

    Using the Chocolatey package provider to perform an in-place upgrade of the Puppet package during a Puppet run, which is the workflow used by Foreman, most commonly triggered this behavior.

    Puppet agent 5.5.3 resolves both of these problems by implementing a workaround of the MSI property resolution issue and making the PA-2019 permission resetting code more defensive. ([PA-2075](https://tickets.puppetlabs.com/browse/PA-2075))

-   In Puppet agent 5.5.2, Puppet's systemd services were not always enabled as expected on Debian and derivative operating systems, such as within the `debian-installer` chroot. This could lead to Puppet services being disabled after an automated deployment of agent 5.5.2 on these operating systems. Puppet agent 5.5.3 fixes this regression. ([PA-2072](https://tickets.puppetlabs.com/browse/PA-2072))

## Puppet agent 5.5.2

Released June 7, 2018.

This release of Puppet Platform contained several Puppet and Facter security and bug fixes, but due to issues with the Windows agent installer, this release was pulled from our repositories and should not be used. Use Puppet agent 5.5.3 or newer instead, which include all of the changes listed below.

### Component updates

This release includes component updates to [Puppet 5.5.2][], [Facter 3.11.2][], [MCollective 2.12.2][], and [pxp-agent][] 1.9.2.

### Known issues

-   Due to an issue with the Windows installer, Puppet agent 5.5.2 can inadvertently change permissions on files across a Windows node's filesystem when re-installed or in certain rare installation scenarios. This can cause serious issues on those nodes. The Puppet agent 5.5.2 installer binaries for Windows have been removed from our downloads as well as the Chocolatey community feed, and they should not be installed if downloaded or installed on their own or as part of Puppet Enterprise (PE) 2018.1.1. ([PA-2075](https://tickets.puppetlabs.com/browse/PA-2075))

### Bug fixes

-   Previous versions of Puppet on Ruby 2.0 or newer would close and reopen HTTP connection that were idle for more than 2 seconds, causing increased load on Puppet masters. This version of Puppet ensures that the agent uses the `http_keepalive_timeout` setting when determining when to close idle connections. ([PUP-8663](https://tickets.puppetlabs.com/browse/PUP-8663))

-   When installing or updating `puppet-agent` 5.5.2, it updates the `MANPATH` environment variable so that Puppet's man pages are available. ([PA-1847](https://tickets.puppetlabs.com/browse/PA-1847))

### Security updates

-   On Windows, Puppet no longer includes `/opt/puppetlabs/puppet/modules` in its default basemodulepath, because unprivileged users could create a `C:\opt` directory and escalate privileges. ([PUP-8707](https://tickets.puppetlabs.com/browse/PUP-8707))

-   This version of Puppet agent restricts permissions to some directories within `C:\ProgramData\PuppetLabs` so that only LocalSystem and members of the local Administrators group have access. ([PA-2019](https://tickets.puppetlabs.com/browse/PA-2019))

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
