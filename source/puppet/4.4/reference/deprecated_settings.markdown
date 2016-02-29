---
layout: default
title: "Deprecated Settings"
---


The following Puppet settings are deprecated and will be removed in Puppet 5.0.


## `configtimeout`

The `configtimeout` setting mashed the connect and read timeouts together, and could cause erroneous timeouts if everything was working fine but Puppet was transferring a very large file.

It's been replaced by two new settings:

* [`http_connect_timeout`](./configuration.html#httpconnecttimeout) --- controls how long Puppet should attempt to make a connection. A short timeout for this is sensible, since an over-long connect time usually means something's wrong.
* [`http_read_timeout`](./configuration.html#httpreadtimeout) --- controls how long Puppet should allow transfers to continue. It's normal to let this last a long time or be infinite, since some things just take a while to compile or download.

The old `configtimeout` setting now logs a deprecation warning if it's set, and will be removed in Puppet 5.0.

