---
layout: default
title: Marionette Collective
disqus: true
canonical: "/mcollective/index.html"
---
[Func]: https://fedorahosted.org/func/
[Fabric]: http://fabfile.org/
[Capistrano]: http://www.capify.org
[Publish Subscribe Middleware]: http://en.wikipedia.org/wiki/Publish/subscribe
[Screencasts]: /mcollective1.2/screencasts.html
[Amazon EC2 based demo]: /mcollective1.2/ec2demo.html
[broadcast paradigm]: /mcollective1.2/reference/basic/messageflow.html
[UsingWithPuppet]: /mcollective1.2/reference/integration/puppet.html
[UsingWithChef]: /mcollective1.2/reference/integration/chef.html
[Facter]: http://code.google.com/p/mcollective-plugins/wiki/FactsRLFacter
[Ohai]: http://code.google.com/p/mcollective-plugins/wiki/FactsOpsCodeOhai
[WritingFactsPlugins]: /mcollective1.2/reference/plugins/facts.html
[NodeReports]: /mcollective1.2/reference/ui/nodereports.html
[PluginsSite]: http://code.google.com/p/mcollective-plugins/
[SimpleRPCIntroduction]: /mcollective1.2/simplerpc/
[SecurityOverview]: /mcollective1.2/security.html
[SecurityWithActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[SSLSecurityPlugin]: /mcollective1.2/reference/plugins/security_ssl.html
[AESSecurityPlugin]: /mcollective1.2/reference/plugins/security_aes.html
[SimpleRPCAuthorization]: /mcollective1.2/simplerpc/authorization.html
[SimpleRPCAuditing]: /mcollective1.2/simplerpc/auditing.html
[ActiveMQClusters]: /mcollective1.2/reference/integration/activemq_clusters.html
[JSONSchema]: http://json-schema.org/
[Registration]: /mcollective1.2/reference/plugins/registration.html
[GettingStarted]: /mcollective1.2/reference/basic/gettingstarted.html
[Configuration]: /mcollective1.2/reference/basic/configuration.html
[Terminology]: /mcollective1.2/terminology.html
[devco]: http://www.devco.net/archives/tag/mcollective
[mcollective-users]: http://groups.google.com/group/mcollective-users
[WritingAgents]: /mcollective1.2/reference/basic/basic_agent_and_client.html
[ActiveMQ]: /mcollective1.2/reference/integration/activemq_security.html
[MessageFormat]: /mcollective1.2/reference/basic/messageformat.html
[ChangeLog]: /mcollective1.2/changelog.html

# {{page.title}}
The Marionette Collective is a framework to build server
orchestration or parallel job execution systems.

**Warning:**
Puppet Enterprise 2018.1 is the last release to support Marionette Collective, also known as MCollective. While PE 2018.1 remains supported, Puppet will continue to address security issues for MCollective. Feature development has been discontinued. Future releases of PE will not include MCollective. For more information, see the [Puppet Enterprise support lifecycle](https://puppet.com/misc/puppet-enterprise-lifecycle).

To prepare for these changes, migrate your MCollective work to [Puppet orchestrator](https://puppet.com/docs/pe/2018.1/migrating_from_mcollective_to_orchestrator.html#concept-5391) to automate tasks and create consistent, repeatable administrative processes. Use orchestrator to automate your workflows and take advantage of its integration with Puppet Enterprise console and commands, APIs, role-based access control, and event tracking.


## Overview
Primarily we'll use it as a means of programmatic execution of Systems Administration
actions on clusters of servers.  In this regard we operate in the same space as tools
like [Func], [Fabric] or [Capistrano].

We've attempted to think out of the box a bit designing this system by not relying on
central inventories and tools like SSH, we're not simply a fancy SSH "for loop".  MCollective use modern tools like
[Publish Subscribe Middleware] and modern philosophies like real time discovery of network resources using meta data
and not hostnames.  Delivering a very scalable and very fast parallel execution environment.

To get an immediate feel for what I am on about you can look at some of the videos on the
[Screencasts] page and then keep reading below for further info and links.  We've also created an [Amazon EC2 based demo]
where you can launch as many instances as you want to see how it behaves first hand.

## What is MCollective and what does it allow you to do

 * Interact with small to very large clusters of servers
 * Use a [broadcast paradigm] for request distribution.  All servers get all requests at the same time, requests have
   filters attached and only servers matching the filter will act on requests.  There is no central asset database to
   go out of sync, the network is the only source of truth.
 * Break free from ever more complex naming conventions for hostnames as a means of identity.  Use a very
   rich set of meta data provided by each machine to address them.  Meta data comes from
   [Puppet][UsingWithPuppet], [Chef][UsingWithChef], [Facter], [Ohai] or [plugins][WritingFactsPlugins] you provide yourself.
 * Comes with simple to use command line tools to call remote agents.
 * Ability to write [custom reports][NodeReports] about your infrastructure.
 * A number of agents to manage packages, services and other common components are [available from
   the community][PluginsSite].
 * Allows you to write [simple RPC style agents, clients][SimpleRPCIntroduction] and Web UIs in an easy to understand language - Ruby
 * Extremely pluggable and adaptable to local needs
 * Middleware systems already have rich [authentication and authorization models][SecurityWithActiveMQ], leverage these as a first
   line of control.  Include fine grained Authentication using [SSL][SSLSecurityPlugin] or [RSA][AESSecurityPlugin], [Authorization][SimpleRPCAuthorization] and
   [Auditing][SimpleRPCAuditing] of requests.  You can see more details in the [Security Overview][SecurityOverview].
 * Re-use the ability of middleware to do [clustering, routing and network isolation][ActiveMQClusters]
   to realize secure and scalable setups.

## Pluggable Core
We aim to provide a stable core framework that allows you to build it out into a system that meets
your own needs, we are pluggable in the following areas:

 * Replace our choice of middleware - STOMP compliant middleware - with your own like AMQP based.
 * Replace our authorization system with one that suits your local needs
 * Replace our serialization - Ruby Marshal and YAML based - with your own like [JSONSchema] that is cross language.
 * Add sources of data, we support [Chef][UsingWithChef] and [Puppet][UsingWithPuppet].   You can
   [provide a plugin to give us access to your tools data][WritingFactsPlugins].
   The community have ones for [Facter and Ohai already][PluginsSite]
 * Create a central inventory of services [leveraging MCollective as transport][Registration]
   that can run and distribute inventory data on a regular basis.

MCollective is licensed under the Apache 2 license.

## Next Steps and Further Reading

### Introductory and Tutorial Pages
 * See it in action in our [Screencasts]
 * Read the [GettingStarted] and [Configuration] guides for installation instructions
 * Read the [Terminology] page if you see any words where the meaning in the context of MCollective is not clear
 * Read the [ChangeLog] page to see how MCollective has developed
 * Learn how to write basic reports for your servers - [NodeReports]
 * Learn how to write simple Agents and Clients using our [Simple RPC Framework][SimpleRPCIntroduction]
 * The author maintains some agents and clients on another project [here][PluginsSite].
 * The author has written [several blog posts][devco] about mcollective.
 * Subscribe and post questions to the [mailing list][mcollective-users].

### Internal References and Developer Docs
 * Finding it hard to do something complex with Simple RPC? See [WritingAgents] for what lies underneath
 * Role based security, authentication and authorization using [ActiveMQ]
 * Structure of [Request and Reply][MessageFormat] messages

