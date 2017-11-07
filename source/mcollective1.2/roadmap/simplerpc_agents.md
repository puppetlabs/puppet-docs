---
layout: default
title: SimpleRPC Agents
disqus: true
canonical: "/mcollective/index.html"
---

# {{page.title}}

|                    |         |
|--------------------|---------|
|Target release cycle|**1.0.x**|

## Overview
We want to make writing SimpleRPC agents even easier, there's a lot of unneeded boiler place in the agent, it should
look more like the DDL.  This will mean a new plugin directory must exist but the agents should just be file like
this:

{% highlight ruby %}
metadata    :name        => "Echo Agent",
            :description => "Simple Echo Agent",
            :author      => "Me",
            :license     => "Apache v.2",
            :version     => "1.0",
            :url         => "http://www.devco.net/",
            :timeout     => 2

action "echo" do
    validate :msg, String

    reply.fail! "Boom!" if rand(10) % 2 == 0

    reply[:msg] = request[:msg]
    reply[:time] = Time.now.to_s
end
{% endhighlight %}

They'd go in _plugindir/rpcagents_ and at startup something should load them all up like it would normal agents.

We'd need to make some kind of hook into the runner for this, it might be worth making that hook an extendable
system so other frameworks can plug into the main and have their startups executed.
