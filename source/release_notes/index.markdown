---
layout: default
title: Puppet Release Notes
description: Links to Puppet and Puppet Enterprise release notes
---

# Puppet Releases

## Puppet Open Source

### Current Releases

- [Puppet 3.7](/puppet/3.7/reference/release_notes.html)

### Previous Releases

- [Puppet 3.6][3.6]
- [Puppet 3.5][3.5]
- [Puppet 3.0 through 3.4][3.x]
- [Puppet 2.7][]
- [Puppet 2.6][]
- [Puppet 0.25][]
- [Puppet 0.24][]
- [Puppet 0.23][]

## Puppet Enterprise

### Current Release

- [Puppet Enterprise 3.3][pe3.3]

### Maintenance and Security Branches

- [Puppet Enterprise 3.2][pe3.2]
- [Puppet Enterprise 3.1][pe3.1]
- [Puppet Enterprise 3.0][pe3.0]
- [Puppet Enterprise 2.8][pe2.8]
- [Puppet Enterprise 2.7][pe2.7]
- [Puppet Enterprise 2.6][pe2.6]
- [Puppet Enterprise 2.5][pe2.5]
- [Puppet Enterprise 2.0][pe2.0]
- [Puppet Enterprise 1.2][pe1.2] (receiving security fixes until April, 2013)


## About Puppet Releases

### Understanding Puppet Versions

Puppet Labs has adopted [semantic versioning ("SemVer")][semver]. The SemVer specification provides a way for developers to communicate the impact of new releases through the version numbering scheme, which in turn helps users assess the benefits and potential drawbacks of upgrading their software.

In Puppet Open Source versions prior to 3.0.0 and in Puppet Enterprise versions prior to 2.5.3, release numbering did not comply with the SemVer specification.

In versions released prior to the introduction of semantic versioning it is especially important to consult all the release notes when upgrading: Version numbers for these releases do not make any guarantees about backward compatibility.

### Upgrading Puppet

We strongly recommend ensuring your master and agents are the same version.

We also strongly recommend that you upgrade your master first and then your agents: Earlier agent versions usually work with later masters, but frequently have issues with earlier masters.

### Finding Specific Fixes

The [Roadmap Tracker](https://tickets.puppetlabs.com/browse/PUP#selectedTab=com.atlassian.jira.plugin.system.project%3Aversions-panel) lists tickets closed for each release.


[semver]: http://semver.org
[3.6]: /puppet/3.6/reference/release_notes.html
[3.5]: /puppet/3.5/reference/release_notes.html
[3.x]: /puppet/3/reference/release_notes.html
[pe3.0]: /pe/3.0/appendix.html#release-notes
[pe3.1]: /pe/3.1/appendix.html#release-notes
[pe3.3]: /pe/3.3/release_notes.html
[pe3.2]: /pe/3.2/appendix.html#release-notes
[pe3.1]: /pe/3.1/appendix.html#release-notes
[pe2.8]: /pe/2.8/appendix.html#release-notes
[pe2.7]: /pe/2.7/appendix.html#release-notes
[pe2.6]: /pe/2.6/appendix.html#release-notes
[pe2.5]: /pe/2.5/appendix.html#release-notes
[pe2.0]: /pe/2.0/welcome_whats_new.html
[pe1.2]: /pe/1.2/upgrading.html
[Puppet 2.7]: /puppet/2.7/reference/release_notes.html
[Puppet 2.6]: /puppet/2.6/reference/release_notes.html
[Puppet 0.25]: /puppet/0.25/reference/release_notes.html
[Puppet 0.24]: /puppet/0.24/reference/release_notes.html
[Puppet 0.23]: /puppet/0.23/reference/release_notes.html