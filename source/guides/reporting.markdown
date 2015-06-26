---
layout: default
title: Reporting
---

Reporting
=========

How to learn more about the activity of your nodes.

* * *

## Reports and Reporting

Puppet clients can be configured to send reports at the end of
every configuration run. These reports include all of the
log messages generated during the configuration run and metrics related to what happened on that run.

### Logs

The bulk of the report is every log message generated during the
transaction. This is a simple way to send almost all client logs to
the Puppet server; you can use the log report to send all of these
client logs to syslog on the server.

### Metrics

The rest of the report contains some basic metrics describing what
happened in the transaction. There are three types of metrics in
each report, and each type of metric has one or more values:

- **Time**: Keeps track of how long things took.
    - *Total*: Total time for the configuration run
    - *File*:
    - *Exec*:
    - *User*:
    - *Group*:
    - *Config Retrieval*: How long the configuration took to retrieve
    - *Service*:
    - *Package*:
- **Resources**: Keeps track of the following stats:
    - *Total*: The total number of resources being managed
    - *Skipped*: How many resources were skipped, because of either
      tagging or scheduling restrictions
    - *Scheduled*: How many resources met any scheduling restrictions
    - *Out of Sync*: How many resources were out of sync
    - *Applied*: How many resources were attempted to be fixed
    - *Failed*: How many resources were not successfully fixed
    - *Restarted*: How many resources were restarted because their
      dependencies changed
    - *Failed Restarts*: How many resources could not be restarted
- **Changes**: The total number of changes in the transaction.


## Setting Up Reporting

By default:

* The agent sends reports to the master.
* The master is configured to use the `store` report handler, which just dumps reports as YAML to disk in the [`reportdir`](/references/latest/configuration.html#reportdir).

### Make Masters Process Reports

By default, the puppet master server stores incoming YAML reports to
disk in the [`reportdir`](/references/latest/configuration.html#reportdir). There are other report types available that can process each report as it arrives; you can use Puppet's built-in report processors, write custom report processor plugins, or write an out-of-band report analyzer task that consumes the stored YAML reports on your own schedule.

#### Using Built-In Reports

* [A list of the available built-in report processors](/references/latest/report.html)

Select the report processors to use with the [`reports`](/references/latest/configuration.html#reports) setting in the puppet master's [`puppet.conf`][conf] file. This setting should be a comma-separated list of report processors to use; if there is more than one, Puppet will run all of them.

The most useful one is usually the `http` processor, which sends reports to an arbitrary URL. Puppet Dashboard uses this, and it's easy enough to write a web service that consumes reports.

The [PuppetDB](/puppetdb/latest) terminus plugins also include a `puppetdb` report processor.

#### Writing Custom Reports

You can easily write your own report processor in place of any of
the built-in reports. Put the report into the `lib/puppet/reports` directory of a Puppet module to make it available to the master.

The report processor API is as follows:

* The name of a report processor should contain only alphanumeric characters, and should start with a letter. (More liberal names haven't been tested; underscores might be okay as well.)
* Each report processor must be in its own Ruby file, named `lib/puppet/reports/<NAME>.rb`.
* The Ruby file must have `require 'puppet'` at the top.
* It must contain a call to the `Puppet::Reports.register_report(:NAME)` method. This method takes the name of the report (as a Symbol) and a mandatory block of code; the block takes no arguments.
* The block provided to the `register_report` method must contain the following:
    * A call to the `desc` method, which takes a Markdown-formatted string describing the report.
    * Implementation of a method named `process`, which can do basically anything. This method is the main substance of the report processor.
* The `process` method has access to a `self` object, which will be a [`Puppet::Transaction::Report` object](/puppet/latest/reference/format_report.html) describing a Puppet run. Generally, the `process` method will either call `self.to_yaml` and forward the resulting data to some other service, or will filter through the attributes of the report object and do something whenever it finds events matching certain criteria.
* When enabled via the `reports` setting, the report processor will be executed immediately whenever the puppet master receives a new report from an agent node.

In summary, a report processor looks more or less like this:

~~~ ruby
    # /etc/puppetlabs/puppet/modules/myreport/lib/puppet/reports/myreport.rb
    require 'puppet'
    # require any other Ruby libraries necessary for this specific report

    Puppet::Reports.register_report(:myreport) do
      desc "Process reports via the my_cool_cmdb API."

      def process
        # do something that sets up the API we're sending the report to.
        # Post the report object (self), after dumping it to yaml:
        my_api.post(self.to_yaml)
      end
    end
~~~

You would then set something like `reports = store,myreport` in the puppet master's puppet.conf.

For examples of using this API, you can use [the built-in reports](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/reports) as a guide, or use and/or hack one of these simple custom reports:


* [Report failed runs to an IRC channel](https://github.com/jamtur01/puppet-irc)
* [Report failed runs and logs to PagerDuty](https://github.com/jamtur01/puppet-pagerduty)
* [Report failed runs to Jabber/XMPP](https://github.com/jamtur01/puppet-xmpp)
* [Report failed runs to Twitter](https://github.com/jamtur01/puppet-twitter)
* [Report failed runs and logs to Campfire](https://github.com/jamtur01/puppet-campfire)
* [Report failed runs to Twilio](https://github.com/jamtur01/puppet-twilio)
* [Report failed runs to Boxcar](https://github.com/jamtur01/puppet-boxcar)
* [Report failed runs to HipChat](https://github.com/jamtur01/puppet-hipchat)
* [Send metrics to a Ganglia server via gmetric](https://github.com/jamtur01/puppet-ganglia)
* [Report failed runs to Growl](https://github.com/jamtur01/puppet-growl)

These example reports were [posted to the Puppet users group by a Puppet Labs employee][jamesreports], and are linked here for educational purposes.

[jamesreports]: http://groups.google.com/group/puppet-users/browse_thread/thread/939cfc2e714544df/6d5aa6ae2ce51831

When writing a report processor, you will need to handle a Puppet::Transaction::Report object provided by Puppet. See [Report Formats below](#report-formats).

#### Using External Report Processors

Alternately, you can use the default `store` report and write an external
report processor that reads in and analyzes the saved YAML files. This is ideal for analyzing large amounts of reports on demand, and allows the report processor to be written in any common scripting language.

Report Formats
-----

Puppet creates reports as Puppet::Transaction::Report objects, which have changed format several times over the course of Puppet's history. We have report format references for the following Puppet versions:

* [Puppet 3.x](/puppet/3/reference/format_report.html) (report formats 3 and 4)
* [Puppet 2.7.x](/puppet/2.7/reference/format_report.html) (report formats 3 and 2)
* [Puppet 2.6.x](/puppet/2.6/format_report.html) (report formats 2 and 1)
* [Puppet 0.25.5](/puppet/0.25/format_report.html) (report format 0)

The report format applies to both the Ruby object handed to a report processor and the YAML object written to disk by the default `store` processor.
