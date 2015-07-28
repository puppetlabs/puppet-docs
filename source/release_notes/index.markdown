---
layout: default
title: Puppet Release Notes
description: Links to Puppet and Puppet Enterprise release notes
---

# Puppet Releases

## Puppet Open Source

### Current Releases

- [Puppet 4.2][4.2]
- [Puppet 3.8][3.8]

### Previous Releases

- [Puppet 4.1][4.1]
- [Puppet 4.0][4.0]
- [Puppet 3.7][3.7]
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

- [Puppet Enterprise 2015.2](/pe/latest/release_notes.html)

### Maintenance and Security Branches

- [Puppet Enterprise 3.8][pe3.8]
- [Puppet Enterprise 3.7][pe3.7]
- [Puppet Enterprise 3.3][pe3.3]
- [Puppet Enterprise 3.2][pe3.2]
- [Puppet Enterprise 3.1][pe3.1]
- [Puppet Enterprise 3.0][pe3.0]
- [Puppet Enterprise 2.8][pe2.8]
- [Puppet Enterprise 2.7][pe2.7]
- [Puppet Enterprise 2.6][pe2.6]
- [Puppet Enterprise 2.5][pe2.5]
- [Puppet Enterprise 2.0][pe2.0]
- [Puppet Enterprise 1.2][pe1.2] (receiving security fixes until April, 2013)

## About Version Numbers

### Puppet Labs' Open Source Projects

All of our open source projects --- including Puppet, PuppetDB, Facter, and Hiera --- use [semantic versioning ("semver")][semver] for their version numbers. This means that in an `x.y.z` version number, the "y" will increase if new features are introduced and the "x" will increase if existing features change or get removed.

Our semver promises only refer to the code in a single project; it's possible for packaging or interactions with new "y" releases of other projects to cause new behavior in a "z" upgrade of Puppet.

Historical note: In Puppet versions prior to 3.0.0 and Facter versions prior to 1.7.0, we weren't using semantic versioning.

### Puppet Enterprise

Since Puppet Enterprise bundles a lot of interrelated software together, it doesn't use semantic versioning. In an `x.y.z` version number, the "z" will increase for patch releases that make only minor changes to capabilities, and the "x.y" portion will increase for major new releases.

## Upgrading Puppet

Before upgrading, you should skim our [page of advice about upgrading Puppet](/guides/install_puppet/upgrading.html).

The short version is that you should upgrade when you're ready to upgrade, skim the release notes first, reserve some time for testing, upgrade the Puppet master first, and roll out upgrades in stages.

## Finding Specific Fixes

The [Roadmap Tracker](https://tickets.puppetlabs.com/browse/PUP#selectedTab=com.atlassian.jira.plugin.system.project%3Aversions-panel) lists tickets closed for each release.


[semver]: http://semver.org
[4.2]: /puppet/4.2/reference/release_notes.html
[4.1]: /puppet/4.1/reference/release_notes.html
[4.0]: /puppet/4.0/reference/release_notes.html
[3.8]: /puppet/3.8/reference/release_notes.html
[3.7]: /puppet/3.7/reference/release_notes.html
[3.6]: /puppet/3.6/reference/release_notes.html
[3.5]: /puppet/3.5/reference/release_notes.html
[3.x]: /puppet/3/reference/release_notes.html
[pe3.8]: /pe/3.8/release_notes.html
[pe3.7]: /pe/3.7/release_notes.html
[pe3.3]: /pe/3.3/release_notes.html
[pe3.2]: /pe/3.2/appendix.html#release-notes
[pe3.1]: /pe/3.1/appendix.html#release-notes
[pe3.0]: /pe/3.0/appendix.html#release-notes
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
