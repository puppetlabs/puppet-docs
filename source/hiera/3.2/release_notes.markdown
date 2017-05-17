---
layout: default
title: "Hiera 3.2: Release Notes"
---

[`puppet-agent`]: /puppet/latest/reference/about_agent.html

[1.5.0]: /puppet/4.5/reference/release_notes_agent.html#puppet-agent-150
[1.6.0]: /puppet/4.6/reference/release_notes_agent.html#puppet-agent-160
[1.7.2]: /puppet/4.7/reference/release_notes_agent.html#puppet-agent-172
[1.8.0]: /puppet/4.8/reference/release_notes_agent.html#puppet-agent-180

{% partial /hiera/_hiera_update.md %}

## Hiera 3.2.2

Released November 1, 2016.

Minor bug fix release shipped in [`puppet-agent`][] version [1.7.2][] and [1.8.0][].

* [Fixed in Hiera 3.2.2](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27HI%203.2.2%27)
* [Introduced in Hiera 3.2.2](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.2.2%27)

## Hiera 3.2.1

Released August 10, 2016.

Minor bug fix release shipped in [`puppet-agent`][] version [1.6.0][].

* [Fixed in Hiera 3.2.1](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.2.1%27)
* [Introduced in Hiera 3.2.1](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.2.1%27)

### Bug fixes

* [HI-528](https://tickets.puppetlabs.com/browse/HI-528): Hiera 3.2.x does not support Rubies < 1.9.3. The dependencies on 'json' and 'json_pure' has therefore been dropped from hiera's gemspec to make it easier to consume hiera as a gem.


## Hiera 3.2.0

Released May 17, 2016.

Shipped in [`puppet-agent`][] version [1.5.0][].

* [Fixed in Hiera 3.2.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion+%3D+%27HI+3.2.0%27)
* [Introduced in Hiera 3.2.0](https://tickets.puppetlabs.com/issues/?jql=affectedVersion+%3D+%27HI+3.2.0%27)

### New default location for hiera.yaml

The default location of hiera.yaml has changed from the `$codedir` to the `$confdir`. Updating via `puppet-agent 1.5.0` packages will not move your existing file, but new installations will place it in this location. You need to manually move the file to `$confdir`.