---
layout: default
title: Message Flow
disqus: true
canonical: "/mcollective/reference/basic/messageflow.html"
---
[MessageFormat]: /mcollective1.2/reference/basic/messageformat.html
[ActiveMQClusters]: /mcollective1.2/reference/integration/activemq_clusters.html
[SecurityWithActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[ScreenCast]: /mcollective1.2/screencasts.html#message_flow

# {{page.title}}

The diagram below shows basic message flow on a MCollective system.  There is also a [screencast][ScreenCast] that shows this process, recommend you watch that.

The key thing to take away from this diagram is the broadcast paradigm that is in use, one message only leaves the client and gets broadcast to all nodes.  We'll walk you through each point below.

![Message Flow](/mcollective1.2/images/message-flow-diagram.png)

|Step|Description|
|----|-----------|
|A|A single messages gets sent from the workstation of the administrator to the middleware.  The message has a filter attached saying only machines with the fact _cluster=c_ should perform an action.|
|B|The middleware network broadcasts the message to all nodes.  The middleware network can be a [cluster of multiple servers in multiple locations, networks and data centers][ActiveMQClusters].|
|C|Every node gets the message and validates the filter|
|D|Only machines in _cluster=c_ act on the message and sends a reply, depending on your middleware only the workstation will get the reply.|

For further information see:

 * [Messages and their contents][MessageFormat]
 * [Clustering ActiveMQ brokers][ActiveMQClusters]
 * [Security, authentication and authorization][SecurityWithActiveMQ]
