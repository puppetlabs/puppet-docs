---
layout: default
title: Message Format
disqus: true
canonical: "/mcollective/reference/basic/messageformat.html"
---
[SecurityPlugins]: http://github.com/puppetlabs/marionette-collective/tree/master/plugins/mcollective1.2/security/
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/
[MessageFlow]: messageflow.html
[ScreenCast]: /mcollective1.2/screencasts.html#message_flow

# {{page.title}}

 * TOC Placeholder
 {:toc}

The messages that gets put on the middleware attempts to contain everything that mcollective needs to function, avoiding where possible special features in the Middle Ware.  This will hopefully make it easier to create Connector plugins for other middleware.

At present the task of encoding and decoding messages lies with the _MCollective::Security::`*`_ classes, see the provided [security plugins][SecurityPlugins] as a examples.

Abstracting the encoding away from the security plugins is a goal for future refactorings, till then each security plugin will need to at least conform to the following structure.

In general this is all hidden from the developers, especially if you use [Simple RPC][SimpleRPCIntroduction].  If you want to implement your own security or serialization you will need to know exactly how all of this sticks together.

There is also a [screencast][ScreenCast] that shows this process and message format, recommend you watch that.

## Message Flow
For details of the flow of messages and how requests / replies travel around the network see the [MessageFlow] page.

## History

|Date|Description|Ticket|
|----|-----------|------|
|2011/04/23|Add _agent_ and _collective_ to the request hashes|7113|

### Requests sent to agents
A sample request that gets sent to the connector can be seen here, each component is described below:

{% highlight ruby %}
{:filter    =>
  {"cf_class"      => ["common::linux"],
   "fact"          => [{:fact=>"country", :value=>"uk"}],
   "agent"         => ["package"]},
 :senderid    => "devel.your.com",
 :msgtarget   => "/topic/mcollective.discovery.command",
 :agent:      => 'discovery',
 :collective' => 'mcollective',
 :body        => body,
 :hash        => "2d437f2904980ac32d4ebb7ca1fd740b",
 :msgtime     => 1258406924,
 :requestid   => "0b54253cb5d04eb8b26ea75bbf468cbc"}
{% endhighlight %}

Once this request is created the security plugin will serialize it and sent it to the connector, in the case of the PSK security plugin this is done using Marshal.

#### :filter
The filter will be evaluated by each node, if it passes the node will dispatch the message to an agent.

You can see all these types of filter in action in the _MCollection::Optionparser_ class.

Each filter is an array and you can have multiple filters per type which will be applied with an _AND_
Valid filter types are:

##### CF Class

This will look in a list of classes/recipes/cookbooks/roles applied by your
configuration management system and match based on that

{% highlight ruby %}
filter["cf_class"] = ["common::linux"]
{% endhighlight %}

##### MCollective Agent

This will look through the list of known agents and match against that.

{% highlight ruby %}
filter["agent"] = ["package"]
{% endhighlight %}

##### Facts

Since facts are key => value pairs this is a bit more complex than normal as you need to build a nested Hash.

{% highlight ruby %}
filter["fact"] = [{:fact => "country", :value => "uk"}]
{% endhighlight %}

Regular expression matches are:

{% highlight ruby %}
filter["fact"] = [{:fact => "country", :value => "/uk/"}]
{% endhighlight %}

As of version 1.1.0 this has been extended to support more comparison operators:

{% highlight ruby %}
filter["fact"] = [{:fact => "country", :value => "uk", :operator => "=="}]
{% endhighlight %}

Valid operators are: ==, =~, &lt;=, =&gt;, &gt;=, =&lt;, &gt; &lt; and !=

As regular expressions are now done using their own operator backwards compatability
is lost and in mixed version environment 1.1.x clients doing regex matches on facts
will be treated as equality on 1.0.x and older clients.

##### Identity

The identity is the configured identity in the server config file, many hosts can have the same identity it's just another level of filter doesn't really mean much like a hostname that would need to be unique.

{% highlight ruby %}
filter["identity"] = ["foo.bar.com"]
{% endhighlight %}

#### :senderid

The value of _identity_ in the configuration file.

#### :msgtarget

The Middleware topic or channel the message is being sent to

#### :body

The contents of the body will vary by what ever the security provider choose to impliment, the PSK security provider simply Marshal encodes the body into a serialized format ready for transmission.

This ensures that variable types etc remain in tact end to end.  Other security providers might use JSON etc, the decoding of this is also handled by the security provider so its totally up to the provider to decide.

In the case of [Simple RPC][SimpleRPCIntroduction] the entire RPC request and replies will be in the body of the messages, it's effectively a layer on top of the basic message flow.

#### :hash

This is an example of something specific to the security provider, this is used only by the PSK provider so it's optional and specific to the PSK provider

#### :msgtime

The unix timestamp that the message was sent at.

#### :requestid

This is a unique id for each message that gets sent, replies will have the same id attached to them for validation.

### Replies from Agents
Replies are very similar to requests, I'll show a reply below and only highlight the differences between requests.

{% highlight ruby %}
{:senderid    => "devel.your.com",
 :senderagent => "package",
 :msgtarget   => "/topic/mcollective.package.reply",
 :body        => body,
 :hash        => "2d437f2904980ac32d4ebb7ca1fd740b",
 :msgtime     => 1258406924,
 :requestid   => "0b54253cb5d04eb8b26ea75bbf468cbc"}
{% endhighlight %}

Once this reply is created the security plugin will serialize it and sent it to the connector, in the case of the PSK security plugin this is done using serialization tools like Marshal or YAML depending on Security Plugin.

#### :senderagent
This is the agent name that sent the reply

#### :requestid
The id that was contained in the request we are replying to.  Agents do not generally tend to generate messages - they only reply - so this should always be provided.
