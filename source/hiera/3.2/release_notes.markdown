---
layout: default
title: "Hiera 3.2: Release Notes"
---

[`puppet-agent`]: /puppet/4.4/reference/about_agent.html

[1.5.0]: /puppet/4.5/reference/release_notes_agent.html#puppet-agent-150

## Hiera 3.2.0

Released May 17, 2016. 

Shipped in [`puppet-agent`][] version [1.5.0][].

* [Fixed in Hiera 3.2.0]()
* [Introduced in Hiera 3.2.0]()

### New default location for hiera.yaml

The default location of hiera.yaml has changed from the `$codedir` to the `$confdir`. Updating via `puppet-agent 1.5.0` packages will not move your existing file, but new installations will place it in this location. You need to manually move the file to `$confdir`.