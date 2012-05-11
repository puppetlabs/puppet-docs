---
title: "PuppetDB 0.9 » Maintaining and Tuning"
layout: pe2experimental
nav: puppetdb0.9.html
---

## Web Console

Once you have PuppetDB running, visit the following URL on your
PuppetDB host (what port to use depends on your configuration, as
does whether you need to use HTTP or HTTPS):

    /dashboard/index.html?pollingInterval=1000

PuppetDB includes a simple, web-based console that displays a fixed
set of key metrics around PuppetDB operations: memory use, queue
depth, command processing metrics, duplication rate, and REST endpoint
stats.

We display min/max/median of each metric over a configurable duration,
as well as an animated SVG sparkline.

Currently the only way to change the attributes of the dashboard is via URL
parameters:

* width = width of each sparkline
* height = height of each sparkline
* nHistorical = how many historical data points to use in each sparkline
* pollingInterval = how often to poll PuppetDB for updates, in milliseconds



## Operational information

### Deactivating nodes

A Puppet Face action is provided to "deactivate" nodes. Deactivating
the node will cause it to be excluded from storeconfigs queries, and
it useful if a node no longer exists. The node's data is still
preserved, however, and the node will be reactivated if a new catalog
or facts are received for it.

`puppet node deactivate <node> [<node> ...] --mode master`

This command will submit deactivation commands to PuppetDB for each of
the nodes provided. It's necessary to run this in master mode so that
it can be sure to find the right puppetdb.conf file.

Note that `puppet node destroy` can also be used to deactivate nodes,
as the current behavior of destroy in PuppetDB is to simply
deactivate. However, this behavior may change in future, and the
command is not specific to PuppetDB, so the preferred method is
`puppet node deactivate`.

