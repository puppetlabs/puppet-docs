---
layout: default
title: "About Reporting"
canonical: "/puppet/latest/reporting_about.html"
---

[report]: /puppet/latest/configuration.html#report
[reports]: /puppet/latest/configuration.html#reports
[reportdir]: /puppet/latest/configuration.html#reportdir
[puppet.conf]: ./config_file_main.html

Puppet creates a report about its actions and your infrastructure each time it applies a catalog during a Puppet run. You can create and use report processors to generate insightful information or alerts from those reports.

## How Reporting Works

In a client/server configuration, a Puppet agent sends its report to the Puppet master for processing. In a standalone configuration, the `puppet apply` command processes the node's own reports.

In both configurations, report processor plugins handle received reports. If you enable multiple report processors, Puppet runs all of them for each report.

Each processor typically does one of two things with the report:

- It sends some of the report data to another service, such as PuppetDB, that can collate it.
- It triggers alerts on another service if the data matches a specified condition, such as a failed run.

That external service can then provide a way to view the processed report.

## Configuring Reporting

A Puppet agent sends reports by default. You can turn off reporting by changing the [`report`][report] setting in an agent's [`puppet.conf`][puppet.conf].

On Puppet master servers (and nodes running Puppet apply), you can configure enabled report processors as a comma-separated list in the [`reports`][reports] setting. The default `reports` value is 'store', which stores them in the configured [`reportdir`][reportdir]. You can also turn off reports entirely by setting `reports` to 'none'.

## Practical Reporting for Beginners

Puppet's reporting features are powerful, but there are simple ways to work with them. Puppet Enterprise includes [helpful reporting tools](/pe/latest/CM_reports.html) in the console. [PuppetDB](/puppetdb/latest/), with [its report processor enabled](/puppetdb/latest/connect_puppet_master.html#enabling-report-storage), can interface with third-party tools such as [Puppetboard](https://github.com/puppet-community/puppetboard) or [PuppetExplorer](https://github.com/spotify/puppetexplorer).

Puppet has several basic built-in [report processors](/puppet/latest/report.html). For example, the `http` processor sends YAML dumps of reports via POST requests to a designated URL, while `log` saves received logs to a local log file.

Certain Puppet modules --- for instance, [`tagmail`](https://forge.puppetlabs.com/puppetlabs/tagmail) --- add additional report processors. Each module has its own requirements, such as Ruby gems, operating system packages, or other Puppet modules.

## Advanced Reporting

For access to more Puppet report data, you can write your own [custom report processor](./reporting_write_processors.html) to process and send any report data into whatever formats you can use.

You can also query PuppetDB's stored report data and build your own tools to display it. PuppetDB doesn't collect everything that Puppet reports, but it provides an API for accessing useful data about Puppet's actions. For details about PuppetDB's reporting functions and API, see its [reports documentation](/puppetdb/latest/api/query/v4/reports.html). For details about the types of data PuppetDB collects, see the documentation for its [`events`](/puppetdb/latest/api/query/v4/events.html), [`event-counts`](/puppetdb/latest/api/query/v4/event-counts.html), and [`aggregate-event-counts`](/puppetdb/latest/api/query/v4/aggregate-event-counts.html) API endpoints.

## What Data is in a Report?

Puppet report processors handle these points of data:

* Metadata about the node, its environment and Puppet version, and the catalog used in the run.
* The status of every resource.
* Actions that Puppet took during the run, also called events.
* Log messages that were generated during the run.
* Metrics about the run, such as its duration and how many resources were in a given state.

For detailed information about Puppet's report data, see [the report format documentation](./format_report.markdown).
