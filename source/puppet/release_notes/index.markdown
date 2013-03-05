---
layout: default
title: Puppet Release Notes
description: Links to Puppet release notes for versions 3, 2.6, 2.7, and 0.2x
---

Puppet Release Notes
----------------------

- [The 3.x series][3.x] is the current branch of Puppet releases.
- [The 2.7 series][2.7] is a maintenance branch of Puppet releases.
- [The 2.6 series][2.6] is a security-fixes-only branch of Puppet.

The [Roadmap Tracker](http://projects.puppetlabs.com/projects/puppet/roadmap?tracker_ids%5B%5D=1&tracker_ids%5B%5D=2&tracker_ids%5B%5D=4&completed=1&with_subprojects=0&with_subprojects=0) lists tickets closed for each release. 

## Understanding Puppet Versions

Beginning with Puppet 3, Puppet has adopted [semantic versioning ("SemVer")][semver]. The SemVer specification provides a way for developers to communicate the impact of new releases through the version numbering scheme, which in turn helps users assess the benefits and potential drawbacks of upgrading their software. 

In versions prior to 3.0.0, release numbering did not comply with the SemVer specification. In those versions it is especially important to consult all the release notes when upgrading: Version numbers for these releases do not make any guarantees about backward compatibility.

## Upgrading Puppet 

We strongly recommend ensuring your master and agents are the same version.

We also strongly recommended that you upgrade your master first and then your agents: Earlier agent versions usually work with later masters, but frequently have issues with earlier masters.

[semver]: http://semver.org
[3.x]: /puppet/3/reference/release_notes.html
[2.7]: /puppet/2.7/reference/release_notes.html
[2.6]: /puppet/2.6/reference/release_notes.html
