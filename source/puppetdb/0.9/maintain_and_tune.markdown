---
title: "PuppetDB 0.9 » Maintaining and Tuning"
layout: default
canonical: "/puppetdb/latest/maintain_and_tune.html"
---

[configure_jetty]: ./configure.html#jetty-http
[configure_heap]: ./configure.html#configuring-the-java-heap-size
[memrec]: ./requirements.html#memory-recommendations

PuppetDB requires a relatively small amount of maintenance and tuning. You should become familiar with the following occasional tasks:

## Deactivate Decommissioned Nodes

When you remove a node from your Puppet deployment, you should tell PuppetDB to deactivate it. This will ensure that any resources exported by that node will stop appearing in the catalogs served to the remaining agent nodes. 

The PuppetDB plugins installed on your puppet master(s) include a `deactivate` action for the `node` face. On your puppet master, run:

    $ sudo puppet node deactivate <node> [<node> ...]

Although deactivated nodes will be excluded from storeconfigs queries, their data is still preserved, and a node will be reactivated if a new catalog or facts are received for it.

## Redoing SSL setup after changing certificates

If you've recently changed the certificates in use by the PuppetDB server, you'll need to update the SSL configuration for PuppetDB itself.

If you've installed PuppetDB from Puppet Labs packages, you can simply re-run the `puppetdb-ssl-setup` script. Otherwise, you'll need to perform again all the SSL configuration steps outlined in [the installation instructions](./install_from_source.html).

## Monitor the Performance Console

Once you have PuppetDB running, visit the following URL, substituting in the name and port of your PuppetDB server:

`http://puppetdb.example.com:8080/dashboard/index.html`

PuppetDB uses this page to display a web-based console with performance information and metrics, including its memory use, queue depth, command processing metrics, duplication rate, and query stats. It displays min/max/median of each metric over a configurable duration, as well as an animated SVG sparkline.

[![Screenshot of the performance dashboard](./images/perf-dash-small.png)](./images/perf-dash-large.png)

You can use the following URL parameters to change the attributes of the dashboard:

* width = width of each sparkline, in pixels
* height = height of each sparkline, in pixels
* nHistorical = how many historical data points to use in each sparkline
* pollingInterval = how often to poll PuppetDB for updates, in milliseconds

E.g.: `http://puppetdb.example.com:8080/dashboard/index.html?height=240&pollingInterval=1000`

> Note: You may need to change PuppetDB's configuration to make the dashboard available, since the default configuration will only allow unauthenticated access to `localhost`. [See here to configure unauthenticated HTTP for PuppetDB.][configure_jetty]

## View the Log

PuppetDB's log file lives at `/var/log/pe-puppetdb/pe-puppetdb.log` (for PE users) or `/var/log/puppetdb/puppetdb.log` (for open source users). Check the log when you need to confirm that PuppetDB is working correctly or troubleshoot visible malfunctions.

The PuppetDB packages install a logrotate job in `/etc/logrotate.d/puppetdb`, which will keep the log from becoming too large. 

## Tune the Max Heap Size

Although we provide [rule-of-thumb memory recommendations][memrec], PuppetDB's RAM usage depends on several factors, and everyone's memory needs will be different depending on their number of nodes, frequency of Puppet runs, and amount of managed resources. 1000 nodes that check in once a day will require much less memory than if they check in every 30 minutes.

So the best way to manage PuppetDB's max heap size is to guess a ballpark figure, then [monitor the performance console](#monitor-the-performance-console) and [increase the heap size][configure_heap] if the "JVM Heap" metric keeps approaching the maximum. You may need to revisit your memory needs whenever your site grows substantially. 

The good news is that memory starvation is actually not very destructive. It will cause `OutOfMemoryError` exceptions to appear in [the log](#view-the-log), but you can restart PuppetDB with a [larger memory allocation][configure_heap] and it'll pick up where it left off --- any requests successfully queued up in PuppetDB *will* get processed.

## Tune the Number of Threads

When viewing [the performance console](#monitor-the-performance-console), note the MQ depth. If it is rising and you have CPU cores to spare, [increasing the number of threads](./configure.html#command-processing) may help churn through the backlog faster.

If you are saturating your CPU, we recommend [lowering the number of threads](./configure.html#command-processing).  This prevents other PuppetDB subsystems (such as the web server, or the MQ itself) from being starved of resources, and can actually _increase_ throughput.
