---
layout: default
title: "Writing custom report processors"
---

[format]: ./format_report.html
[report processor]: ./reporting_about.html
[Puppet module]: ./modules_fundamentals.html

You can write your own [report processor][] in Ruby and include it in a [Puppet module][]. Puppet can then use the processor to send report data to any service and in any format.

## Writing a report processor

A report processor must adhere to these standards:

* Its name must be a valid Ruby symbol that contains only alphanumeric characters and starts with a letter.
* It must be in its own Ruby file named `<NAME>.rb`, inside a Puppet module's `lib/puppet/reports/` directory.
* Its Ruby code must start with `require 'puppet'`.
* It must call the `Puppet::Reports.register_report(:NAME)` method. This method takes the name of the report as a symbol, and a mandatory block of code with no arguments that contains:
    * A Markdown-formatted string describing the processor, passed to the `desc(<DESCRIPTION>)` method.
    * An implementation of a method named `process` that contains the report processor's main functionality.

Puppet will let the `process` method access a `self` object, which will be a [`Puppet::Transaction::Report` object][format] describing a Puppet run.

The processor can access all of the report's data by calling accessor methods (as described in the [report format docs][format]) on `self`, and it can forward that data to any service you configure in the report processor.

It can also call `self.to_yaml` to dump the entire report to YAML. Note that the YAML output doesn't represent a safe, well-defined data format---it's simply a serialized Ruby object.

### Example

A report processor looks like this:

``` ruby
# Located in /etc/puppetlabs/puppet/modules/myreport/lib/puppet/reports/myreport.rb.
require 'puppet'
# If necessary, require any other Ruby libraries for this report here.

Puppet::Reports.register_report(:myreport) do
  desc "Process reports via the fictional my_cool_cmdb API."

  # Declare and configure any settings here. We'll pretend this connects to our API.
  my_api = MY_COOL_CMD

  # Next, define and configure the report processor.
  def process
    # Do something that sets up the API we're sending the report to here.
    # For instance, let's check on the node's status using the report object (self):
    if self.status != nil then
      status = self.status
    else
      status = 'undefined'
    end

    # Next, let's do something if the status equals 'failed'.
    if status == 'failed' then
      # Finally, dump the report object to YAML and post it using the API object:
      my_api.post(self.to_yaml)
    end
  end
end
```

The above report processor could then be included in the comma-separated list of processors in the Puppet master's `reports` setting in `puppet.conf`, such as `reports = store,myreport`.

For more examples using this API, see [the built-in reports' source](https://github.com/puppetlabs/puppet/tree/master/lib/puppet/reports) or one of these simple custom reports created by a member of the Puppet community:

* [Report failed runs to Jabber/XMPP](https://github.com/jamtur01/puppet-xmpp)
* [Send metrics to a Ganglia server via gmetric](https://github.com/jamtur01/puppet-ganglia)

These community reports aren't provided or guaranteed by Puppet.
