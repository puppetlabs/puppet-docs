---
layout: default
title: Controlling the Daemon
disqus: true
canonical: "/mcollective/reference/basic/daemon.html"
---
# {{page.title}}

 * TOC Placeholder
 {:toc}

The main daemon that runs on nodes keeps internal stats and supports reloading of agents, we provide
a tool - *mco controller* - to interact with any running daemon from a client.

If all you want is to reload all the agents without restarting the daemon you can just send it signal
*USR1* and it will reload its agents.  This is available from version *0.4.5* onward.

From version *0.4.8* onward you can send *USR2* to cycle the log level through DEBUG to FATAL and back
again, just keep sending the signal and look at the logs.

## Details

The _mco controller_ application allows you to:

 * Get stats for each mcollectived
 * Reload a specific agent
 * Reload all agents

## Usage
Usage is like for any other client, you run _mco controller_ from your management station and use filters
to target just the nodes you need.

## Statistics
This will show some basic statistics about the daemon:

{% highlight console %}
% mco controller stats
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> total=22 replies=17 valid=22 invalid=0 filtered=0 passed=22

---- mcollectived controller summary ----
           Nodes: 1 / 1
      Start Time: Wed Feb 17 21:06:53 +0000 2010
  Discovery Time: 2010.40ms
      Agent Time: 53.13ms
      Total Time: 2063.53ms
{% endhighlight %}

Each stat means:

|Statistic   |Meaning                                    |
|------------|-------------------------------------------|
|total|Total messages received from the middleware|
|replies|Replies sent back|
|valid|Messages that passed validity checks like the PSK|
|invalid|Messages that could not be validated|
|filtered|Messages that we received but that we did not reply to due to the filter|

## Reloading an agent
You can reload a specific agent if you've just copied a new one out and don't want to restart the daemons:

{% highlight console %}
% mco controller reload_agent --arg rpctest
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> reloaded rpctest agent

---- mcollectived controller summary ----
           Nodes: 1 / 1
      Start Time: Wed Feb 17 21:10:13 +0000 2010
  Discovery Time: 2004.02ms
      Agent Time: 57.65ms
      Total Time: 2061.67ms
{% endhighlight %}

## Reloading all agent
Like the previous command but acts on all agents, this is the same as sending *USR1* signal to the process:

{% highlight console %}
% mco controller reload_agents
Determining the amount of hosts matching filter for 2 seconds .... 1

                devel.your.com> reloaded all agents

---- mcollectived controller summary ----
           Nodes: 1 / 1
      Start Time: Wed Feb 17 21:10:46 +0000 2010
  Discovery Time: 2006.71ms
      Agent Time: 182.45ms
      Total Time: 2189.16ms
{% endhighlight %}
