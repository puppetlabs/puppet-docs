---
layout: default
title: SimpleRPC Message Format
disqus: true
canonical: "/mcollective/simplerpc/messageformat.html"
---
[MessageFormat]: ../reference/basic/messageformat.html
[ErrorCodes]: clients.html#dealing-with-the-results-directly

# {{page.title}}

 * TOC Placeholder
 {:toc}

SimpleRPC has a specific message structure that builds on the core
[MessageFormat].  As such SimpleRPC is simply a plugin developed
ontop of The Marionette Collective rather than an integrated part.

The core messages has a _:body_ structure where agents and clients
can send any data between nodes and clients.  All the SimpleRPC
structures below goes in this body.  Filters, targets etc all use the
standard core [MessageFormat].

# Requests

A basic SimpleRPC message can be seen below:

{% highlight ruby %}
{:agent           => "echo",
 :action          => "echo",
 :caller          => "cert=rip",
 :data            => {:message => "hello world"},
 :process_results => true}
{% endhighlight %}

This structure will be sent as the _:body_ of the core message, you might create
this request using the command below:

{% highlight ruby %}
  e = rpcclient("echo")
  e.echo(:message => "hello world")
{% endhighlight %}

## :agent

Records the agent that this message is targetted at.

## :action

The action being called.  As the core protocol has no concept of actions per
agent this provides the needed data to route the request to the right code in
the SimpleRPC agent

## :caller

The callerid initiating the request.  This is redundant and might be removed
later since the core message format also includes this information - the core
did not always include it.  Removing it will only break backwards compatability
with really old versions.

## :data

The data being sent to the SimpleRPC action as its _request_ structure,
technically this can be any data but by SimpleRPC convention this would be a
hash with keys being of the Symbol type as per the example above

## :process_results

Indicates the client preference to receive a result or not, the SimpleRPC agent
should not send a response at all if this is true.

# Replies

As with requests the replies just build on the core [MessageFormat] and would be
in the body of the standard message.

A typical rely would look like:

{% highlight ruby %}
{:statuscode => 0
 :statusmsg  => "OK",
 :data       => {:message => "hello world"}}
{% endhighlight %}

## :statuscode and :statusmsg

The statuscode and statusmsg are related and is used for error propagation
through the collective.

These are the [documented errors clients receive][ErrorCodes] and will result
in exceptions raised on the client in some cases.

The agent's _fail_ and _fail!_ methods will manipulate these structures.

## :data

This is a freeform variable for any data being returned by agents.  Technically
it can be anything but by SimpleRPC convention it's a hash with keys being of
type Symbol.
