---
layout: default
title: Registration
disqus: true
canonical: "/mcollective/reference/plugins/registration.html"
---
[RegistrationMonitor]: http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/AgentRegistrationMonitor

# {{page.title}}

MCollective supports the ability for each node to register with a central inventory. The core functionality
of Mcollective doesn't require registration internally; it's simply provided as a framework to enable you to 
build inventory systems or Web UIs.

## Details

Registration plugins are easy to write. You can configure your nodes to use your own or the provided one.

The one we provide simply sends a list of agents to the inventory. It's available in the plugins directory
under *registration/agentlist.rb* and can be seen in its entirety below:

{% highlight ruby %}
module MCollective
    module Registration
        # A registration plugin that simply sends in the list of agents we have
        class Agentlist<Base
            def body
                MCollective::Agents.agentlist
            end
        end
    end
end
{% endhighlight %}

You can see it's very simple, you just need to subclass *MCollective::Registration::Base* to ensure they get 
loaded into the plugin system and provide a _body_ method whose return value will be sent to the registration agent(s).

As of version 1.1.2 the registration plugin can decide if a message should be sent or not.  If your plugin
responds with a _nil_ value the message will not be sent.  This can be useful if you wish to only send
registration data when some condition has changed. On large collectives, registration messages can be
quite high-volume. It's worthwhile to sample the size of your registration messages and multiply by the number 
of nodes to determine an appropriate frequency to send them. 

To configure it to be used you just need the following in your config:

{% highlight ini %}
registerinterval = 300
registration = Agentlist
{% endhighlight %}

This will cause the plugin to be called every 300 seconds.

We do not provide the receiving end of this in the core mcollective. You will need to write an agent called
*registration* and do something useful with the data you receive from all the nodes. You can find
[a simple monitoring system][RegistrationMonitor] built using this method as an example. The receiving agent 
can simply be installed as an extra mcollectived plugin on a node which participates in the collective. 

You need to note a few things about the receiving agents:

 * They need to be fast. You'll receive a lot of registration messages so if your agent talks to a database that
   is slow you'll run into problems
 * They should not return anything other than *nil*. The MCollective server will interpret *nil* from an agent as
   an indication that you do not want to send back any reply.  Replying to registration requests is almost always undesired.

There's nothing preventing you from running more than one type of receiving agent in your collective, you can have one
on your monitor server as above and another with completely different code on a web server feeding a local 
cache for your web interfaces.  As long as both agents are called *registration* you'll be fine. However this 
does mean you can't run more than one registration receiver on the same server.
