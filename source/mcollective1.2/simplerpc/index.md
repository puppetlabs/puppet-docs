---
layout: default
title: SimpleRPC Introduction
disqus: true
canonical: "/mcollective/simplerpc/index.html"
---
[WritingAgents]: /mcollective1.2/reference/basic/basic_agent_and_client.html
[SimpleRPCAgents]: /mcollective1.2/simplerpc/agents.html
[SimpleRPCClients]: /mcollective1.2/simplerpc/clients.html
[SimpleRPCAuditing]: /mcollective1.2/simplerpc/auditing.html
[SimpleRPCAuthorization]: /mcollective1.2/simplerpc/authorization.html
[SimpleRPCDDL]: /mcollective1.2/simplerpc/ddl.html
[SimpleRPCMessageFormat]: /mcollective1.2/simplerpc/messageformat.html
[RPCUtil]: /mcollective1.2/reference/plugins/rpcutil.html
[WritingAgentsScreenCast]: http://mcollective.blip.tv/file/3808928/
[RestGateway]: http://github.com/puppetlabs/marionette-collective/blob/master/ext/mc-rpc-restserver.rb

# {{page.title}}

MCollective is a framework for writing feature full agents and clients and provides a [rich system to do that][WritingAgents].  MCollective's native Client though is very low level, a bit like TCP/IP is to HTTP.  Like TCP/IP the native client does not provide any Authentication, Authorization etc.

MCollective Simple RPC is a framework on top of the standard client that abstracts away a lot of the complexity and provides a lot of convention and standards.  It's a bit like using HTTP ontop of TCP/IP to create REST services.

SimpleRPC is a framework that provides the following:

 * Provide simple conventions for writing [agents][SimpleRPCAgents] and [clients][SimpleRPCClients], favoring convention over custom design
 * Very easy to write agents including input validation and a sensible feedback mechanism in case of error
 * Provide [audit logging][SimpleRPCAuditing] abilities of calls to agents
 * Provide the ability to do [fine grain Authorization][SimpleRPCAuthorization] of calls to agents and actions.
 * Has a [Data Definition Language][SimpleRPCDDL] used to describe agents and assist in giving hints to auto generating user interfaces.
 * The provided generic calling tool should be able to speak to most compliant agents
 * Should you need to you can still write your own clients, this should be very easy too
 * Return data should be easy to print, in most cases the framework should be able to print a sensible output with a single, provided, function.  The [SimpleRPCDDL] is used here to improve the standard one-size-fits-all methods.
 * The full capabilities of the standard Client classes shouldddl still be exposed in case you want to write advanced agents and clients
 * A documented [standard message format][SimpleRPCMessageFormat] built ontop of the core format.


We've provided full tutorials on [Writing Simple RPC Agents][SimpleRPCAgents] and [Clients][SimpleRPCClients].  There is also a [screencast that will give you a quick look at what is involved in writing agents][WritingAgentsScreenCast].


A bit of code probably says more than lots of English, so here's a simple hello world Agent, it just echo's back everything you send it in the _:msg_ argument:

{% highlight ruby linenos %}
module MCollective
    module Agent
        class Helloworld<RPC::Agent
            # Basic echo server
            def echo_action
                validate :msg, String

                reply.data = request[:msg]
            end
        end
    end
end
{% endhighlight %}

The nice thing about using a standard abstraction for clients is that you often won't even need to write a client for it, we ship a standard client that you can use to call the agent above:

{% highlight console %}
 % mco rpc --agent helloworld --action echo --arg msg="Welcome to MCollective Simple RPC"
 Determining the amount of hosts matching filter for 2 seconds .... 1

 devel.your.com                          : OK
     "Welcome to MCollective Simple RPC"



 ---- rpctest#echo call stats ----
            Nodes: 1
       Start Time: Wed Dec 23 20:49:14 +0000 2009
   Discovery Time: 0.00ms
       Agent Time: 54.35ms
       Total Time: 54.35ms
{% endhighlight %}

You could also use *mco rpc* like this and achieve the same result:

{% highlight console %}
 % mco rpc helloworld echo msg="Welcome to MCollective Simple RPC"
{% endhighlight %}

For multiple options just add more *key=val* pairs at the end

But you can still write your own clients, it's incredibly simple, full details of a client is out of scope for the introduction - see the [SimpleRPCClients] page instead for full details - but here is some sample code to do the same call as above including full discovery and help output:

{% highlight ruby linenos %}
#!/usr/bin/ruby

require 'mcollective'

include MCollective::RPC

mc = rpcclient("helloworld")

printrpc mc.echo(:msg => "Welcome to MCollective Simple RPC")

printrpcstats
{% endhighlight %}

With a standard interface come a lot of possibilities, just like the standard one-size-fits-all CLI client above you can make web interfaces, there's a [simple MCollective <-> REST bridge in the ext directory][RestGateway].

A helper agent called [_rpcutil_][RPCUtil] is included from version _0.4.9_ onward that helps you gather stats, inventory etc about the running daemon.
