---
layout: default
title: SimpleRPC Auditing
disqus: true
canonical: "/mcollective/simplerpc/auditing.html"
---
[SimpleRPCIntroduction]: index.html
[AuditCentralRPCLog]: http://code.google.com/p/mcollective-plugins/wiki/AuditCentralRPCLog

# {{page.title}}

As part of the [SimpleRPC][SimpleRPCIntroduction] framework we've added an auditing system that you can use to log all requests received into a file or even send it over mcollective to a central auditing system.  What actually happens with audit data is pluggable and you can provide your own plugins to do what you need.

The clients will include the _uid_ of the process running the client library in the requests and the audit function will have access to that on the requests.

## Configuration
To enable logging you should set an option to enable it and also one to configure which plugin to use:

{% highlight ini %}
rpcaudit = 1
rpcauditprovider = Logfile
{% endhighlight %}

This sets it up to use _MCollective::Audit::Logfile_ plugin for logging evens.

The client will embed a caller id - the Unix UID of the program running it or SSL cert - in requests which you can find in the _request_ object.

## Logfile plugin

Auditing is implemented using plugins that you should install in the normal plugin directory under _mcollective/audit/_.  We have a sample Logfile plugin that you can see below:

{% highlight ruby %}
module MCollective
    module RPC
        class Logfile<Audit
	    require 'pp'

            def audit_request(request, connection)
                logfile = Config.instance.pluginconf["rpcaudit.logfile"] || "/var/log/mcollective-audit.log"

                now = Time.now
                now_tz = tz = now.utc? ? "Z" : now.strftime("%z")
                now_iso8601 = "%s.%06d%s" % [now.strftime("%Y-%m-%dT%H:%M:%S"), now.tv_usec, now_tz]

                File.open(logfile, "w") do |f|
                    f.puts("#{now_iso8601}: reqid=#{request.uniqid}: reqtime=#{request.time} caller=#{request.caller}@#{request.sender} agent=#{request.agent} action=#{request.action} data=#{request.data.pretty_print_inspect}")
                end
            end
        end
    end
end
{% endhighlight %}

As you can see you only need to provide one method called _audit_request_, you will get the request in the form of an _MCollective::RPC::Request_ object as well as the connection to the middleware should you wish to send logs to a central host.

The Logfile plugin takes a configuration option:

{% highlight ini %}
plugin.rpcaudit.logfile = /var/log/mcollective-audit.log
{% endhighlight %}

We do not do log rotation of this file so you should do that yourself if you enable this plugin.

This log lines like:

{% highlight ruby %}
2010-12-28T17:09:03.889113+0000: reqid=319719cc475f57fda3f734136a31e19b: reqtime=1293556143 caller=cert=nagios@monitor1 agent=nrpe action=runcommand data={:process_results=>true, :command=>"check_mailq"}
{% endhighlight %}

Other plugins can be found on the community site like [a centralized logging plugin][AuditCentralRPCLog].
