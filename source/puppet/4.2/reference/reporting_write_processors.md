---
layout: default
title: "Writing Custom Report Processors"
canonical: "/puppet/latest/reference/reporting_write_processors.html"
---

[format]: ./format_report.html


You can write your own report processor plugin in Ruby and use it to send report data to the service of your choice.


## Location

Put report processors in the `lib/puppet/reports` directory of a Puppet module.

Once a custom report processer is available to Puppet, you can specify it as one of the values of the `reports` setting (link).

## Code

Your report processor must adhere to the following standards:

* The name of a report processor must be a Ruby symbol. It can contain only alphanumeric characters, and should start with a letter. (More liberal names haven't been tested; underscores are probably okay as well.)
* Each report processor must be in its own Ruby file, named `lib/puppet/reports/<NAME>.rb`.
* The Ruby file must have `require 'puppet'` at the top.
* It must contain a call to the `Puppet::Reports.register_report(:NAME)` method. This method takes the name of the report (as a symbol) and a mandatory block of code; the block should take no arguments.
* The block provided to the `register_report` method must contain the following:
    * A call to the `desc` method, which takes a Markdown-formatted string describing the report.
    * Implementation of a method named `process`, which can do basically anything. This method is the main substance of the report processor.
* The `process` method has access to a `self` object, which will be a [`Puppet::Transaction::Report` object][format] describing a Puppet run.
    * The processor can access all of the report's data by calling accessor methods (as described in the [report format docs][format]) on `self`, and it can forward that data to any service you set up.
    * It can also call `self.to_yaml` to dump the entire report to YAML. You'll have to be careful when loading that YAML, though, because it's not a safe, well-defined data format; it's just a serialized Ruby object.

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

## Examples

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

These example reports aren't necessarily vetted by Puppet Labs; they're linked here for educational purposes.

