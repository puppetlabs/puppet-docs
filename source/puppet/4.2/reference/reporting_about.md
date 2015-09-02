---
layout: default
title: "About Reporting"
canonical: "/puppet/latest/reference/reporting_about.html"
---


Every time it applies a catalog, Puppet makes a report of activity during the run. You can analyze these reports to get insight or alerts about what Puppet's doing in your infrastructure.


## How Reporting Works

In the standard agent/master arrangement, Puppet agent sends its report to the Puppet master server, which can process that report in a variety of ways. In a standalone arrangement, Puppet apply processes its own reports.

Puppet master uses _report processor_ plugins to handle the reports it receives. If multiple processors are enabled, Puppet will run all of them for each report. (Puppet apply also uses report processors.)

Each report processor can do _something_ with the data in the report. This is usually one of two things:

- Send some of the data in the report to some other service (like PuppetDB) that can collate it.
- Trigger alerts on some other service if the data matches some kind of condition (like a failed run).

Then, you use that external service to actually view the report data.

## Configuring Reporting

* You can disable reporting on agent nodes by changing the `report` setting (link to config ref) to false. This keeps Puppet agent from sending a report to the master.
* You can configure the enabled report processors (on Puppet master or Puppet apply) with the `reports` setting (link), which is a comma-separated list of report processor names. (Defaults to just `store`.)
    * point to list of built-in report processors. /references/4.2.latest/report.html
* You can install new report processors with modules. (example: tagmail) Read the docs for a module with a report processor, because you might need to install a gem or something.


## Practical Reporting for Beginners

- Use Puppet Enterprise, which includes helpful reporting tools in the console. (link to relevant parts of PE docs, ask michelle.)
- Install and configure PuppetDB, enable the `puppetdb` report processor (installed automatically along w/ the puppetdb termini package), and use something like Puppetboard or PuppetExplorer. (PE users can use these too, since they always have PuppetDB.)

https://github.com/spotify/puppetexplorer
https://github.com/puppet-community/puppetboard

## Advanced Reporting

* Directly query PuppetDB's report data, and build something to display it nicely. Limits you to what PuppetDB collects (which isn't everything), but should still be useful.

/puppetdb/latest/api/query/v4/reports.html
/puppetdb/latest/api/query/v4/events.html
/puppetdb/latest/api/query/v4/event-counts.html
/puppetdb/latest/api/query/v4/aggregate-event-counts.html

* Write your own custom report processor, which can access ANY info from a report and do whatever with it. Link to ./reporting_write_processors.html

## What Kind of Data is in a Report?

Short version:

* Metadata about the node, its environment, its version of Puppet, and the catalog used in the run.
* The status of every resource.
* Actions Puppet took during the run ("events").
* Log messages generated during the run.
* Metrics about the run (how long it took, how many resources were in what state, etc.).

For complete info, (link to report format page)

