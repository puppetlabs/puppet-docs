---
layout: legacy
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

By default, the client does not send reports, and the server only
is only configured to store reports, which just stores received YAML-formatted report
in the reportdir.

Clients default to sending reports to the same server they get
their configurations from, but you can change that by setting
`reportserver` on the client, so if you have load-balanced Puppet
servers you can keep all of your reports consolidated on a single
machine.

### Sending Reports

In order to turn on reporting on puppet agent nodes, the
[`report`](/references/latest/configuration.html#report) setting must be set to true. This should be done in the [`puppet.conf` file][conf]:

[conf]: ./configuring.html

    #
    #  /etc/puppet/puppet.conf
    #
    [agent]
        report = true

With this setting enabled, the agent will then send the report to
the puppet master server at the end of every transaction.

### Processing Reports

By default, the puppet master server stores incoming YAML reports to
disk in the [`reportdir`](/references/latest/configuration.html#reportdir). There are other report types available that can process each report as it arrives; you can use Puppet's built-in report processors, write custom report processor plugins, or write an out-of-band report analyzer task that consumes the stored YAML reports on your own schedule.

#### Using Built-In Reports

Select the report processors to use with the [`reports`](/references/latest/configuration.html#reports) setting in the puppet master's [`puppet.conf`][conf] file. This setting should be a comma-separated list of available report processors.

A list of the available built-in report processors [is available here](/references/latest/report.html).

#### Writing Custom Reports

You can easily write your own report processor in place of any of
the built-in reports. Put the report into the puppet master's `lib/puppet/reports` directory to make it available.

Documentation of the report plugin API is forthcoming; however, you can use the built-in reports as a guide, or use and/or hack one of these simple custom reports:


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



#### Using External Report Processors

Alternately, you can use the default `store` report and write an external
report processor that reads in and analyzes the saved YAML files. This is ideal for analyzing large amounts of reports on demand, and allows the report processor to be written in any common scripting language. 

