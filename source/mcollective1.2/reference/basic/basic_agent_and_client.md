---
layout: default
title: Basic Agents and Clients
disqus: true
canonical: "/mcollective/reference/basic/basic_agent_and_client.html"
---
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/

# {{page.title}}

 * TOC Placeholder
 {:toc}

In general you should use [SimpleRPC][SimpleRPCIntroduction] for writing agents and clients.  SimpleRPC is a framework that wraps the core MCollective client and agent structures in a lot of helpful convention and tools.

SimpleRPC though is a wrapper around the core message flow and routing components, this page documents the core.  You should first read up about [SimpleRPC][SimpleRPCIntroduction] before delving into this.

Writing agents for mcollective is simple, we'll write a simple _echo_ agent as well as a cli tool to communicate with it that supports discovery, filtering and more.

The agent will send back everything that got sent to it, not overly useful but enough to demonstrate the concepts.

## The Agent

Agents go into a directory configured in the _server.cfg_ using the _libdir_ directive.  You should have _mcollective/agents_ directory under that, restart the daemon when you've put it there.

Create a file echo.rb with the following, I'll walk through each part:

{% highlight ruby linenos %}
module MCollective
    module Agent
        # Simple echo agent
        class Echo
            attr_reader :timeout, :meta

            def initialize
                @timeout = 5
                @meta = {:license => "Apache License, Version 2",
                         :author => "R.I.Pienaar <rip@devco.net>",
                         :version => "1.0"}
            end

            def handlemsg(msg, stomp)
                msg[:body]
            end

            def help
            <<-EOH
            Echo Agent
            ==========

            Simple agent that just sends the body of any request back
            EOH
            end
        end
    end
end
{% endhighlight %}

Once you have it running you can test your agent works as below, we'll send the word _hello_ to the agent and we'll see if we get it back:

{% highlight console %}
% ./mc-call-agent --config etc/client.cfg --agent echo --arg hello
Determining the amount of hosts matching filter for 2 seconds .... 1

devel.your.com>
"hello"

---- stomp call summary ----
           Nodes: 1 / 1
      Start Time: Tue Nov 03 23:18:40 +0000 2009
  Discovery Time: 2001.65ms
      Agent Time: 44.17ms
      Total Time: 2045.82ms
{% endhighlight %}


### Agent name
Each agent should be wrapped in a module and class as below, this will create an agent called _echo_ and should live in a file called _agents/echo.rb_.

{% highlight ruby %}
module MCollective
    module Agent
        class Echo
        end
    end
end
{% endhighlight %}

### Initialization
Every agent needs to specify a timeout and meta data.  The timeout gets used by the app server to kill off agents that is taking too long to finish.

Meta data contains some information about the licence, author and version of the agent.  Right now the information is free-form but I suggest supplying at the very least the details below as we'll start enforcing the existence of it in future.

{% highlight ruby %}
            attr_reader :timeout, :meta

            def initialize
                @timeout = 1
                @meta = {:license => "Apache License, Version 2",
                         :author => "R.I.Pienaar <rip@devco.net>",
                         :version => "1.0"}
            end
{% endhighlight %}

### Handling incoming messages
You do not need to be concerned with filtering, authentication, authorization etc when writing agents - the app server takes care of all of that for you.

Whenever a message for your agent pass all the checks it will be passed to you via the _handlemsg_ method.

{% highlight ruby %}
            def handlemsg(msg, stomp)
                msg[:body]
            end
{% endhighlight %}

The msg will be a hash with several keys giving you information about sender, hashes, time it was sent and so forth, in our case we just want to know about the body and we're sending it right back as a return value.

### Online Help
We keep help information, not used right now but future version of the code will have a simple way to get help for each agent, the intent is that inputs, outputs and behavior to all agents would be described in this.

{% highlight ruby %}
            def help
            <<-EOH
            Echo Agent
            ==========

            Simple agent that just sends the body of any request back
            EOH
            end
{% endhighlight %}

## More complex agents
As you write more complex agents and clients you might find the need to have a few separate files make up your agent, you can drop these files into the util directory under plugins.

The classes should be _MCollective::Util::Youclass_ and you should use the following construct to require them from disk:

{% highlight ruby %}
MCollective::Util.loadclass("MCollective::Util::Youclass")
{% endhighlight %}

At present simply requiring them will work and we'll hope to maintain that but to be 100% future safe use this method.

## The Client
We provide a client library that abstracts away a lot of the work in writing simple attractive cli frontends to your agents that supports discovery, filtering, generates help etc.  The client lib is functional but we will improve/refactor the options parsing a bit in future.

{% highlight ruby linenos %}
#!/usr/bin/ruby

require 'mcollective'

oparser = MCollective::Optionparser.new({}, "filter")

options = oparser.parse{|parser, options|
    parser.define_head "Tester for the echo agent"
    parser.banner = "Usage: mc-echo [options] msg"
}

if ARGV.length > 0
    msg = ARGV.shift
else
    puts("Please specify a message to send")
    exit 1
end

begin
    options[:filter]["agent"] = "echo"

    client = MCollective::Client.new(options[:config])

    stats = client.discovered_req(msg, "echo", options) do |resp|
        next if resp == nil

        printf("%30s> %s\n", resp[:senderid], resp[:body])
    end
rescue Exception => e
    puts("Failed to contact any agents: #{e}")
    exit 1
end

client.display_stats(stats, options)
{% endhighlight %}

We can test it works as below:

{% highlight console %}
% ./mc-echo --config etc/client.cfg "hello world"
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> hello world

Finished processing 1 / 1 hosts in 45.02 ms
{% endhighlight %}

Verbose statistics:

{% highlight console %}
% ./mc-echo --config etc/client.cfg "hello world" -v
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> hello world

---- stomp call summary ----
           Nodes: 1 / 1
      Start Time: Tue Nov 03 23:28:34 +0000 2009
  Discovery Time: 2002.27ms
      Agent Time: 45.84ms
      Total Time: 2048.11ms
{% endhighlight %}

Discovery and filtering:

{% highlight console %}
% ./mc-echo --config etc/client.cfg "hello world" --with-fact country=au

Failed to contact any agents: No matching clients found

% ./mc-echo --config etc/client.cfg "hello world" --with-fact country=uk
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> hello world

Finished processing 1 / 1 hosts in 38.77 ms
{% endhighlight %}

Standard Help:

{% highlight console %}
% ./mc-echo --help
Usage: mc-echo [options] msg
Tester for the echo agent

Common Options
    -c, --config FILE                Load configuratuion from file rather than default
        --dt SECONDS                 Timeout for doing discovery
        --discovery-timeout
    -t, --timeout SECONDS            Timeout for calling remote agents
    -q, --quiet                      Do not be verbose
    -v, --verbose                    Be verbose
    -h, --help                       Display this screen

Host Filters
        --wf, --with-fact fact=val   Match hosts with a certain fact
        --wc, --with-class CLASS     Match hosts with a certain configuration management class
        --wa, --with-agent AGENT     Match hosts with a certain agent
        --wi, --with-identity IDENT  Match hosts with a certain configured identity
{% endhighlight %}
