---
layout: default
title: "Puppet agent release notes"
---

[Puppet 4.10.0]: /puppet/4.10/release_notes.html#puppet-4100
[Puppet 4.10.1]: /puppet/4.10/release_notes.html#puppet-4101
[Puppet 4.10.2]: /puppet/4.10/release_notes.html#puppet-4102
[Puppet 4.10.5]: /puppet/4.10/release_notes.html#puppet-4105
[Puppet 4.10.6]: /puppet/4.10/release_notes.html#puppet-4106
[Puppet 4.10.7]: /puppet/4.10/release_notes.html#puppet-4107
[Puppet 4.10.8]: /puppet/4.10/release_notes.html#puppet-4108
[Puppet 4.10.9]: /puppet/4.10/release_notes.html#puppet-4109

[Facter 3.6.3]: /facter/3.6/release_notes.html#facter-363
[Facter 3.6.4]: /facter/3.6/release_notes.html#facter-364
[Facter 3.6.5]: /facter/3.6/release_notes.html#facter-365
[Facter 3.6.6]: /facter/3.6/release_notes.html#facter-366
[Facter 3.6.7]: /facter/3.6/release_notes.html#facter-367
[Facter 3.6.8]: /facter/3.6/release_notes.html#facter-368

[Hiera 3.3.2]: /hiera/3.3/release_notes.html#hiera-332

[MCollective 2.10.3]: /mcollective/releasenotes.html#2_10_3
[MCollective 2.10.4]: /mcollective/releasenotes.html#2_10_4
[MCollective 2.10.5]: /mcollective/releasenotes.html#2_10_5
[MCollective 2.10.6]: /mcollective/releasenotes.html#2_10_6

[`pxp-agent`]: https://github.com/puppetlabs/pxp-agent

This page lists changes to the `puppet-agent` package. For details about changes to components in a `puppet-agent` release, follow the links to those components in the package release's notes.

The `puppet-agent` package's version numbers use the format X.Y.Z, where:

-   X must increase for major backwards-incompatible changes
-   Y may increase for backwards-compatible new functionality
-   Z may increase for bug fixes

## If you're upgrading from Puppet 3.x

The `puppet-agent` package installs the latest version of Puppet 4. Also read the [Puppet 4.0 release notes](/puppet/4.0/release_notes.html), since they cover any breaking changes since Puppet 3.8.

Also of interest: [About Agent](./about_agent.html), and the [Puppet 4.10 release notes](./release_notes.html).

## Puppet agent 1.10.10

Released February 5, 2018.

### Component updates

This release contains bug fixes in [Puppet 4.10.10][] and [Facter 3.6.9][].

### Platform updates

This release adds packages for RHEL 7 on ARM and macOS 10.13 High Sierra.

## Puppet agent 1.10.9

Released November 6, 2017.

### Component updates

This release contains bug fixes in [Puppet 4.10.9][], [Facter 3.6.8][], and [MCollective 2.10.6][], updates its vendored cURL to v7.56.1, and updates its certificate authority (CA) certificate bundle.

This release also updates Puppet's vendored Ruby to version 2.1.9, which addresses the following security vulnerabilities:

-   CVE-2017-0898
-   CVE-2017-10784
-   CVE-2017-14033
-   CVE-2017-14064

It also updates rubygems to version 2.6.13, which addresses the following security vulnerabilities:

-   CVE-2017-0902
-   CVE-2017-0899
-   CVE-2017-0900
-   CVE-2017-0901

### Bug fixes

-   When running Facter from previous versions of the Puppet agent package on a machine with a Power8 architecture, `dmesg` would produce an error message:

    ```
    Program dmidecode tried to access /dev/mem between f0000->100000.
    ```

    Puppet agent 1.10.9 resolves this issue by not including a vendored `dmidecode` in packages targeting Power8 architectures.

### Improvements

-   The `mcollective` service is no longer configured to kill all child processes when stopped under systemd. It will now only kill the `mcollective` service, letting agent subprocesses continue to completion. As a result, MCollective can now upgrade puppet-agent.

## Puppet agent 1.10.8

Released September 14, 2017.

### Component updates

This release contains a bug fix in [Puppet 4.10.8][] and a versioning fix in the Windows package. No other components are updated.

### Bug fix: Change NSSM version increment to avoid upgrade issues

Previous versions of Puppet agent did not increment the version of NSSM in a manner expected by Microsoft Installer (MSI), leading to MSI unintentionally removing it upon upgrade. Puppet agent 1.10.8 resolves this issue by changing the versioning scheme for NSSM.

* [PA-1504](https://tickets.puppetlabs.com/browse/PA-1504)

## Puppet agent 1.10.7

Released September 6, 2017.

### Component updates

This release contains a security improvement in the Windows package, and bug fixes in [Puppet 4.10.7][], [Facter 3.6.7][], and [`pxp-agent`][] 1.5.5.

### Security improvement: Enable Data Execution Prevention (DEP) support in Windows builds of `pxp-agent`

As part of security robustness measure, this version of the `puppet-agent` package for Windows enables data execution prevention (aka /NX) and address space layout randomization (ASLR) in third-party binaries, such as Ruby and OpenSSL, that are built along with Puppet Agent modules. There was no specific known vulnerability, but this improvement prevents potential exploits using the above concerns as attack vectors.

* [PA-1406](https://tickets.puppetlabs.com/browse/PA-1406)
* [PCP-775](https://tickets.puppetlabs.com/browse/PCP-775)
* [FACT-1730](https://tickets.puppetlabs.com/browse/FACT-1730)

## Puppet agent 1.10.6

Released August 9, 2017.

### Component updates

The only component update in this Puppet agent release is [Puppet 4.10.6][].

### New platforms

These platforms have been added as of Puppet agent 1.10.6:

* Debian 9 "Stretch"

## Puppet agent 1.10.5

Released July 26, 2017.

### Component updates

This release contains bug fixes in [Puppet 4.10.5][], and [Facter 3.6.6][] and [`pxp-agent`][] 1.5.4.

### New platforms

These platforms have been added as of Puppet agent 1.10.5:

* Ubuntu 16.04 (ppc64le)
* Enterprise Linux 7 (ppc64le)
* Amazon Linux 2017.03 (by using packages for RHEL 6)

## Puppet agent 1.10.4

Released June 19, 2017.

### Component updates

This release only affects Puppet. A regression in Puppet 4.10.3 where resources created using the syntax `Resource[xx::yy]` would cause an error because Puppet would not find an existing `xx::yy` user defined resource type. This was caused by fixing another problem with inconsistent use of upper and lowercase in references.

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
