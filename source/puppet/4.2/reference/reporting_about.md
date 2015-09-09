---
layout: default
title: "About Reporting"
canonical: "/puppet/latest/reference/reporting_about.html"
---

[`report`]: /references/latest/configuration.html#report
[`reports`]: /references/latest/configuration.html#reports
[`reportdir`]: /references/latest/configuration.html#reportdir
[`puppet.conf`]: ./config_file_main.html

Puppet creates a report about your infrastructure and the actions it takes each time it applies a catalog during a Puppet run. You can create and use report processors to generate insightful information or alerts from those reports.

## How Reporting Works

In a client/server configuration, a Puppet agent sends its report to the Puppet master for processing. In a standalone configuration, the `puppet apply` command processes the node's own reports.

In both configurations, report processor plugins handle recieved reports. If you enable multiple report processors, Puppet runs all of them for each report.

Each processor typically does one of two things with the report:

- It sends some of the report data to another service, such as PuppetDB, that can collate it.
- It triggers alerts on another service if the data matches a specified condition, such as a failed run.

That external service can then provide a way to view the processed report.

## Configuring Reporting

Agents do not send reports by default. You can enable reporting by changing the [`report`][] setting on agents' [`puppet.conf`][] to true.

You can configure enabled report processors, whether on a Puppet master or via `puppet apply`, by passing a comma-separated list of report processor names in the [`reports`][] setting. The default `reports` value is 'store', which stores them in the configured [`reportdir`][]. You can also disable reports entirely by setting `reports` to 'none'.


## Practical Reporting for Beginners

Puppet's reporting features are powerful, but there are simple ways to work with them. Puppet Enterprise includes [helpful reporting tools](/pe/latest/CM_reports.html) in the console, and [PuppetDB](/puppetdb/latest/) provides the [`puppetdb` report processor](/puppetdb/latest/connect_puppet_master.html#enabling-report-storage) with the `puppetdb-termini` package that can interface with tools like [Puppetboard](https://github.com/puppet-community/puppetboard) or [PuppetExplorer](https://github.com/spotify/puppetexplorer).

Puppet has several basic built-in [report processors](/references/latest/report.html). For example, the `http` processor sends YAML dumps of reports via POST requests to a designated URL, while `log` saves received logs to a local log file.

Certain Puppet modules---for instance, [`tagmail`](https://forge.puppetlabs.com/puppetlabs/tagmail)---add new report processors. Each module has its own requirements, such as Ruby gems, operating system packages, or other Puppet modules.

## Advanced Reporting

For access to more Puppet report data, you can write your own [custom report processor](./reporting_write_processors.html) to process and send any report data into whatever formats you can use.

You can also query PuppetDB's stored report data and build your own tools to display it. PuppetDB doesn't collect everything that Puppet reports, but it provides an API for accessing useful data about Puppet's actions. For details about PuppetDB's reporting functions and API, see its [reports documentation](/puppetdb/latest/api/query/v4/reports.html). For details about the types of data PuppetDB collects, see the documentation for its [`events`](/puppetdb/latest/api/query/v4/events.html), [`event-counts`](/puppetdb/latest/api/query/v4/event-counts.html), and [`aggregate-event-counts`](/puppetdb/latest/api/query/v4/aggregate-event-counts.html) API endpoints.

## What Data is in a Report?

Puppet report processors handle these points of data:

* Metadata about the node, its environment and Puppet version, and the catalog used in the run.
* Every resource's status.
* Actions Puppet took during the run, also known as events.
* Log messages generated during the run.
* Metrics about the run, such as its duration and resources' statuses during the run.

For detailed information about Puppet's report data, see [the Puppet report format documentation](./format_report.markdown).
