---
layout: default
title: "Facter 3.3: Release notes"
---

[puppet-agent 1.5.x]: /puppet/4.5/reference/about_agent.html

This page documents the history of the Facter 3.3 series. If you're upgrading from Facter 2, review the [Facter 3.0 release notes](../3.0/release_notes.html) for important information about other breaking changes, new features, and changed functionality. Also review the [Facter 3.1 release notes](../3.0/release_notes.html) for changes since 3.0. 

## Facter 3.3.0

Released July 20, 2016.

Shipped in [puppet-agent 1.5.3][puppet-agent 1.5.x].

Although Facter's previous released version number was Facter 3.1.8, Facter 3.3.0 is a minor bug fix release. Facter 3.2.0 was skipped intentionally to avoid confusion, as Facter 3.1.7 and Facter 3.1.8 incorrectly self identified as Facter 3.2.0  ([FACT-1425](https://tickets.puppetlabs.com/browse/FACT-1425)) when using `facter --version` as well as `facter facterversion`.

* [Introduced in Facter 3.3.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion%20%3D%20%27FACT%203.3.0%27)
* [Fixed in Facter 3.3.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27FACT%203.3.0%27)

## Enhancement

* [FACT-1422](https://tickets.puppetlabs.com/browse/FACT-1422): PhotonOS detection has been added to the Facter `os` structured facts and related legacy flat facts. The OS name is "PhotonOS", and its family is "RedHat".

### Bug fixes

* [FACT-1448](https://tickets.puppetlabs.com/browse/FACT-1448): Previously, all Facter boolean values returned 'true' when JSON output was requested. This corrects the issue, now 'false' is returned when the fact value is in fact 'false'.

* [FACT-1406](https://tickets.puppetlabs.com/browse/FACT-1406): On 32-bit Linux or BSD, several individual fields within the mountpoints fact could be corrupt. This is now fixed.

* [FACT-1244](https://tickets.puppetlabs.com/browse/FACT-1244): Facter inappropriately reported Xen domU and dom0 VMs as "xen". This was a regression to Facter 2. Facter now reports the Xen domains separately as Facter 2 did.
