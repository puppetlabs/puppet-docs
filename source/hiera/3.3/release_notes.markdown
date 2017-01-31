---
layout: default
title: "Hiera 3.3: Release Notes"
---

[`puppet-agent`]: /puppet/latest/about_agent.html
[Puppet agent 1.9.0]: /puppet/latest/release_notes_agent.html#puppet-agent-190
[Puppet 4.9 release notes]: /puppet/4.9/release_notes.html#puppet-490


## Hiera 3.3

Released January 31, 2017.

This version of Hiera ships with [Puppet agent 1.9.0][]. Hiera 5, a successor of the experimental Puppet lookup feature is built into Puppet 4.9, and uses the classic Hiera 3.3 codebase. You can learn more about Hiera 5 in the [Puppet 4.9 release notes][].

* [Fixed in Hiera 3.3](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.3.0%27)
* [Introduced in Hiera 3.3](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.3.0%27)

### Bug fixes

Hiera now errors if it is given a 'hiera.yaml' configuration file that uses the version 4 format, because that format is only available in environments and modules. Previously, Hiera silently ignored its content and no keys were given values. Now there is a clear error if a 'hiera.yaml' version 4 configuration file ends up in the wrong place. ([HI-544](https://tickets.puppetlabs.com/browse/HI-544))

Hiera did not read data files into cache using UTF-8, which could lead to encoding problems occurring much later. Now the data files (YAML, JSON) are read with UTF-8 encoding. ([HI-519](https://tickets.puppetlabs.com/browse/HI-519))
