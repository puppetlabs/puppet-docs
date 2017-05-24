---
layout: default
title: SimpleRPC Authorization
disqus: true
canonical: "/mcollective/simplerpc/authorization.html"
---
[SimpleRPCIntroduction]: index.html
[SecurityWithActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[SimpleRPCAuditing]: /mcollective1.2/simplerpc/auditing.html
[ActionPolicy]: http://code.google.com/p/mcollective-plugins/wiki/ActionPolicy

# {{page.title}}

As part of the [SimpleRPC][SimpleRPCIntroduction] framework we've added an authorization system that you can use to exert fine grained control over who can call agents and actions.

Combined with [Connection Security][SecurityWithActiveMQ], [Centralized Auditing][SimpleRPCAuditing] and Crypto signed messages this rounds out a series of extremely important features for large companies that in combination allow for very precise control over your MCollective Cluster.

The clients will include the _uid_ of the process running the client library in the requests and the authorization function will have access to that on the requests.

There is a sample full featured plugin called [ActionPolicy] that you can use or get some inspiration from.

## Writing Authorization Plugins

Writing an Authorization plugin is pretty simple, the below example will only allow RPC calls from Unix UID 500.

{% highlight ruby linenos %}
module MCollective::Util
    class AuthorizeIt
        def self.authorize(request)
            if request.caller != "uid=500"
                raise("Not authorized")
            end
        end
    end
end
{% endhighlight %}

Any exception thrown by your class will just result in the message not being processed or audited.

You'd install this in your libdir where you should already have a Util directory for these kinds of classes.

To use your authorization plugin in an agent simply do something like this:

{% highlight ruby linenos %}
module MCollective::Agent
    class Service<RPC::Agent
        authorized_by :authorize_it

        # ...
    end
end
{% endhighlight %}

The call extra _authorized`_`by :authorize`_`it_ line tells your agent to use the _MCollective::Util::AuthorizeIt_ class for authorization.

## Enabling RPC auditing globally
You can enable a specific plugin on all RPC agents in the server config file.  If you do this and an agent also specify it's own authorization the agent will take priority.

{% highlight ini %}
rpcauthorization = yes
rpcauthprovider = action_policy
{% endhighlight %}

Note setting _rpcauthorization = no_ here doesn't disable it everywhere, agents that specify authorization will still be used.  This boolean enables the global auth policy not the per agent.
