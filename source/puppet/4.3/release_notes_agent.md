---
layout: default
title: "Puppet Agent Release Notes"
canonical: "/puppet/latest/release_notes_agent.html"
---

[Puppet 4.3.0]: /puppet/4.3/release_notes.html#puppet-430
[Puppet 4.3.1]: /puppet/4.3/release_notes.html#puppet-431
[Puppet 4.3.2]: /puppet/4.3/release_notes.html#puppet-432

[Facter 3.1.2]: /facter/3.1/release_notes.html#facter-312
[Facter 3.1.3]: /facter/3.1/release_notes.html#facter-313
[Facter 3.1.4]: /facter/3.1/release_notes.html#facter-314

[Hiera 3.0.5]: /hiera/3.0/release_notes.html#hiera-305
[Hiera 3.0.6]: /hiera/3.0/release_notes.html#hiera-306

[MCollective 2.8.6]: /mcollective/releasenotes.html#2_8_6
[MCollective 2.8.7]: /mcollective/releasenotes.html#2_8_7

[pxp-agent]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## If You're Upgrading from Puppet 3.x

The `puppet-agent` package installs Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html) and the [Puppet 4.3 release notes](./release_notes.html).

## Puppet Agent 1.3.6

Released March 14, 2016.

This security release fixes a vulnerability that allowed arbitrary remote code execution on Puppet agent nodes.

* [Puppet Labs CVE announcement](https://puppetlabs.com/security/cve/CVE-2016-2786)


## Puppet Agent 1.3.5

Released February 3, 2016.

This release is a security release that updates vulnerable versions of OpenSSL shipped with builds of `puppet-agent` to OpenSSL 1.0.2.f.

* [Puppet Labs CVE announcement](https://puppetlabs.com/security/cve/openssl-jan-2016-security-fixes)
* [OpenSSL security announcement](http://openssl.org/news/secadv/20160128.txt)

## Puppet Agent 1.3.4

Released January 25, 2016.

This release includes [Puppet 4.3.2][], [Facter 3.1.4][], [Hiera 3.0.6][], [MCollective 2.8.7][], and [`pxp-agent`][pxp-agent] 1.0.2, and updates OpenSSL to the latest version of 1.0.2 and Ruby to 2.1.8. This release also adds packages for Ubuntu Wily 15.10.

There was no release for `puppet-agent` 1.3.3.

* [Fixed in `puppet-agent` 1.3.4](https://tickets.puppetlabs.com/issues/?filter=17100)
* [Introduced in `puppet-agent` 1.3.4](https://tickets.puppetlabs.com/issues/?filter=17101)

### New platforms

This release adds `puppet-agent` packages for Ubutnu Wily 15.10 and Cisco eXR.

### Security fix: Ruby CVE-2015-7551

This release includes Ruby 2.1.8, which resolves [CVE-2015-7551](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/).

### Security fixes: OpenSSL 1.0.2

This release includes the latest version of OpenSSL 1.0.2, which resolves [several CVEs](http://openssl.org/news/secadv/20151203.txt).

### Updated components

* Updates Puppet, MCollective, and `pxp-agent`. This release also updates Facter and Hiera, but the update contains no functional changes.
* [Updates Ruby on Windows]() to resolve a security issue.

## Puppet Agent 1.3.2

Released December 2, 2015.

This release includes a more comprehensive root certificate authority (CA) certificate bundle. No other components are updated.

* [Fixed in `puppet-agent` 1.3.2](https://tickets.puppetlabs.com/issues/?filter=16400)
* [Introduced in `puppet-agent` 1.3.2](https://tickets.puppetlabs.com/issues/?filter=16401)

### Regression Fixes

#### More CA Certificates Bundled

In `puppet-agent` 1.3.0 and 1.3.1, the included bundle of CA certificates was smaller than the system bundles used in `puppet-agent` 1.2.7 and earlier, which could cause Puppet features that rely on the omitted CA certificates to fail. This release resolves the issue by expanding the certificate bundle to be more comparable to the set provided by other vendors.

* [PA-95: DigiCert Global Root cert missing in puppet-agent 1.3.0](https://tickets.puppetlabs.com/browse/PA-95)
* [PA-101: AIO's OpenSSL cannot make SSL connection to apt.dockerproject.org](https://tickets.puppetlabs.com/browse/PA-101)

## Puppet Agent 1.3.1

Released November 30, 2015.

Includes [Puppet 4.3.1][], [Facter 3.1.3][], and [`pxp-agent` 1.0.1][pxp-agent], each with bug or regression fixes and no new functionality. No other components are updated.

This release also closes a race condition in `pxp-agent` between the completion of an action command and the corresponding metadata file being updated.

* [Fixed in `puppet-agent` 1.3.1](https://tickets.puppetlabs.com/issues/?filter=16106)
* [Introduced in `puppet-agent` 1.3.1](https://tickets.puppetlabs.com/issues/?filter=16209)

## Puppet Agent 1.3.0

Released November 17, 2015.

Includes [Puppet 4.3.0][], [Facter 3.1.2][], [Hiera 3.0.5][], [MCollective 2.8.6][], Ruby 2.1.7, and OpenSSL 1.0.2d. This version also introduces the [`pxp-agent`][pxp-agent] component at version 1.0.0 in support of the [PCP Execution Protocol](https://github.com/puppetlabs/pcp-specifications/blob/master/pxp/README.md) and forthcoming Application Orchestration features in Puppet Enterprise 2015.3.

### New Platforms

This release adds `puppet-agent` packages for OS X 10.11 (El Capitan) and Fedora 22.

### Windows Server 2003 Removed

We no longer provide `puppet-agent` packages that will install on Windows Server 2003 or Server 2003 R2. We [deprecated](./deprecated_win2003.html) those platforms in Puppet 4.2.

### Fedora 20 Removed

We no longer provide `puppet-agent` packages for Fedora 20, which reached its end-of-life on June 23, 2015.

### Known Issues

#### Windows Uninstaller Falsely Suggests a Reboot is Required

When uninstalling `puppet-agent` 1.3.0 and newer for Windows, Windows Installer presents a dialog stating:

> The setup must update files or services that cannot be updated while the system is running. If you choose to continue, a reboot will be required to complete the setup.

Windows Installer incorrectly assumes the newly included `pxp-agent.exe` will be locked by the time it will be removed. This is not true, and you can ignore the dialog. Unattended installs and future upgrades might log an error from the MSI Restart Manager that you can also ignore.

* [PA-65: Windows claims to requires reboot after uninstalling MSI when pxp-agent is running when it does not](https://tickets.puppetlabs.com/browse/PA-65)

### Bug Fixes

* Resolves [a daemonization issue on AIX](https://tickets.puppetlabs.com/browse/PA-67) that made the service appear to be inoperative when running.

### Regressions

#### Smaller CA Certificate Bundle Can Cause Failures

Through version 1.2.7, the `puppet-agent` package used the system-provided OpenSSL certificate authority (CA) certificate bundle on platforms where it was available, such as on Linux-based operating systems. Starting with `puppet-agent` 1.3.0, the package includes a CA certificate bundle to support authenticated SSL connections consistently across platforms, including platforms that don't provide their own certificate bundle.

However, the bundle we provide in `puppet-agent` 1.3.0 and 1.3.1 includes only a subset of the CA certificates generally provided by Linux vendors, which can cause some Puppet features that require any of the omitted certificates to fail. Starting in version 1.3.2, the bundle includes a more complete set of CA certificates that's comparable to the full set provided by other vendors.

* [PA-95: DigiCert Global Root cert missing in puppet-agent 1.3.0](https://tickets.puppetlabs.com/browse/PA-95)
* [PA-101: AIO's OpenSSL cannot make SSL connection to apt.dockerproject.org](https://tickets.puppetlabs.com/browse/PA-101)

### Updated Components

* Updates Puppet and Facter. This release also updates Hiera, but the update contains no functional changes.
* [Updates vendored Ruby gems on Windows](https://tickets.puppetlabs.com/browse/PA-69) and [registers non-MCollective vendored gems](https://tickets.puppetlabs.com/browse/PA-25) on all platforms.
* Adds [more certificates](https://tickets.puppetlabs.com/browse/PA-73) to enable Forge access on non-Windows platforms.

### Updated Paths

* [Moves `dmidecode`](https://tickets.puppetlabs.com/browse/PA-2) to `/opt/puppetlabs/puppet/bin`.

### 1.2.x and earlier

For details on `puppet-agent` 1.2.x releases, see [their release notes](/puppet/4.2/release_notes_agent.html).

For details on `puppet-agent` 1.1.x and earlier, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).
