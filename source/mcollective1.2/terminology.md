---
layout: default
title: Terminology
disqus: true
canonical: "/mcollective/terminology.html"
---
[Software_agent]: http://en.wikipedia.org/wiki/Software_agent
[Plugin]: http://en.wikipedia.org/wiki/Plugin
[Publish_subscribe]: http://en.wikipedia.org/wiki/Publish_subscribe
[Apache ActiveMQ]: http://activemq.apache.org/
[SimpleRPCAgents]: /mcollective1.2/simplerpc/agents.html
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/
[WritingFactsPlugins]: /mcollective1.2/reference/plugins/facts.html
[Subcollective]: /mcollective1.2/reference/basic/subcollectives.html
[Registration]: /mcollective1.2/reference/plugins/registration.html
[SimpleRPCAuthorization]: /mcollective1.2/simplerpc/authorization.html

# {{page.title}}
This page documents the various terms used in relation to mcollective.

## Server
The mcollective daemon, an app server for hosting Agents and managing
the connection to your Middleware.

## Node
The Computer or Operating System that the Server runs on.

## Agent
A block of Ruby code that performs a specific role, the main reason for
mcollective's existence is to host agents.  Agents can perform tasks like
manipulate firewalls, services, packages etc. See [Wikpedia][Software_agent].

Docs to write your own can be seen in [SimpleRPCAgents]

## Plugins
Ruby code that lives inside the server and takes on roles like security, connection
handling, agents and so forth.  See [Wikipedia][Plugin]

## Middleware
A [publish subscribe][Publish_subscribe] based system like [Apache ActiveMQ].

## Connector
A plugin of the type *MCollective::Connector* that handles the communication with your chosen Middleware.

## Name Space
Currently messages are sent to the middleware directed at topics named */topic/mcollective.package.command*
and replies come back on */topic/mcollective.package.reply*.

In this example the namespace is "mcollective" and all servers and clients who wish to form part of the same
Collective must use the same name space.

Middleware can generally carry several namespaces and therefore several Collectives.

## Collective
A combination of Servers, Nodes and Middleware all operating in the same Namespace.

Multiple collectives can be built sharing the same Middleware but kept separate by using different Namespaces.

## Subcollective
A server can belong to many Namespaces.  A [Subcollective] is a Namespace that only a subset of a full collectives nodes belong to.

Subcolllectives are used to partition networks and to control broadcast domains in high traffic networks.

## Simple RPC
A Remote Procedure Call system built ontop of MCollective that makes it very simple to write feature
full agents and clients.  See [SimpleRPCIntroduction].

## Action
Agents expose tasks, we call these tasks actions.  Each agent like a exim queue management agent might
expose many tasks like *mailq*, *rm*, *retry* etc.  These are al actions provided by an agent.

## Facts
Discrete bits of information about your nodes. Examples could be the domain name, country,
role, operating system release etc.

Facts are provided by plugins of the type *MCollective::Facts*, you can read about writing
your own in [WritingFactsPlugins]

## Registration
Servers can send regular messages to an agent called *registration*.  The code that sends the
registration messages are plugins of the type *MCollective::Registration*.  See [Registration].

## Security
A plugin of the type *MCollective::Security* that takes care of encryption, authentication
and encoding of messages on which will then be passed on to the Connector for delivery to the Collective.

## Client
Software that produce commands for agents to process, typically this would be a computer with
the client package installed and someone using the commands like *mc-package* to interact with Agents.

Often clients will use the *MCollective::Client* library to communicate to the Collective

## User
Servers and Clients all authenticate to the Middleware, user would generally refer to the username
used to authenticate against the middleware.

## Audit
In relation to SimpleRPC an audit action is a step requests go through where they can get
logged to disk or other similar action

## Authorization
In relation to SimpleRPC authorization is a processes whereby requests get allowed or denied
based on some identifying information of the requester.  See [SimpleRPCAuthorization].
