Reporting
=========

How to learn more about the activity of your nodes.

* * *

# Reports and Reporting

Puppet clients can be configured to send reports at the end of
every configuration run. Because the Transaction interals of Puppet are
responsible for creating and sending the reports, these are called
transaction reports. Currently, these reports include all of the
log messages generated during the configuration run, along with
some basic metrics of what happened on that run.  In Rowlf, more
detailed reporting information will be available, allowing users
to see detailed change information regarding what happened on nodes.

## Logs

The bulk of the report is every log message generated during the
transaction. This is a simple way to send almost all client logs to
the Puppet server; you can use the log report to send all of these
client logs to syslog on the server.

## Metrics

The rest of the report contains some basic metrics describing what
happened in the transaction. There are three types of metrics in
each report, and each type of metric has one or more values:

-   **Time**: Keeps track of how long things took.
    :   -   *Total*: Total time for the configuration run
        -   *File*:
        -   *Exec*:
        -   *User*:
        -   *Group*:
        -   *Config Retrieval*: How long the configuration took to retrieve
        -   *Service*:
        -   *Package*:


-   **Resources**: Keeps track of the following stats:
    :   -   *Total*: The total number of resources being managed
        -   *Skipped*: How many resources were skipped, because of either
            tagging or scheduling restrictions
        -   *Scheduled*: How many resources met any scheduling restrictions
        -   *Out of Sync*: How many resources were out of sync
        -   *Applied*: How many resources were attempted to be fixed
        -   *Failed*: How many resources were not successfully fixed
        -   *Restarted*: How many resources were restarted because their
            dependencies changed
        -   *Failed Restarts*: How many resources could not be restarted


-   **Changes**: The total number of changes in the transaction.


# Setting Up Reporting

By default, the client does not send reports, and the server only
is only configured to store reports, which just stores recieved YAML-formatted report
in the reportdir.

Clients default to sending reports to the same server they get
their configurations from, but you can change that by setting
`reportserver` on the client, so if you have load-balanced Puppet
servers you can keep all of your reports consolidated on a single
machine.

## Sending Reports

In order to turn on reporting on the client-side (puppetd), the
`report` argument must be given to the puppetd executable either by
passing the argument to the executable on the command line, like
this:

    $ puppetd --report

or by including the configuration parameter in the Puppet
configuration file, usually located in /etc/puppet/puppet.conf:

    #
    #  /etc/puppet/puppet.conf
    #
    [puppetd]
        report = true

With this setting enabled, the client will then send the report to
the puppetmasterd server at the end of every transaction.

If you are using namespaceauth.conf, you must allow the clients to
access the name space:

    #
    # /etc//puppet/namespaceauth.conf
    #
    [puppetreports.report]
        allow *

Note: some explanations of namespaceauth.conf are due in this documentation.

{{MISSINGREFS}}

## Processing Reports

As previously mentioned, by default the server stores incoming YAML reports to
disk. There are other reports types available that can process each report as it arrives, 
or you can write a separate processor that handles the reports on your own schedule.

### Using Builtin Reports

As with the rest of Puppet, you can configure the server to use different
reports with either command-line arguments or configuration file
changes.   The value you need to change is called `reports`, and it must be a
comma-separated list of the reports you want to use. Here's how
you'd configure extra reports on the command line:

    $ puppetmasterd --reports tagmail,store,log

Note that we're still specifying `store` here; any reports you
specify replace the default, so you must still manually specify
`store` if you want it. You can also specify `none` if you want the
reports to just be thrown away.

Or we can include these configuration parameters in the
configuration file, typically /etc/puppet/puppet.conf. For
example:

    #
    #  /etc/puppet/puppet.conf
    #
    [puppetmasterd]
        reports = tagmail,store,log

Note that in the configuration file, the list of reports should be
comma-separated and not enclosed in quotes (which is otherwise
acceptable for a command-line invocation).

### Writing Custom Reports

You can easily write your own report processor in place of any of
the built-in reports. Just drop the report into lib/puppet/reports,
using the existing reports as an example.  This is only necessary on
the server, as the report reciever does not run on the clients.

### Using External Report Processors

Many people are only using the `store` report and writing an external
report processor that processes many reports at once and produces
summary pages.  This is easiest if these processors are written in
Ruby, since you can just read the YAML files in and de-serialize
them into Ruby objects. Then, you can just do whatever you need
with the report objects.

# Available reports

Read the [Report Reference](/references/latest/report.html) for a list of available reports and
how to configure them. It is automatically generated from the reports available
in Puppet, and includes documentation on how to use each report.





