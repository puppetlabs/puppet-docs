---
layout: default
title: "Overview of Puppet's Architecture"
---

[agent_unix]: ./services_agent_unix.html
[agent_win]: ./services_agent_windows.html
[https_walkthrough]: ./subsystem_agent_master_comm.html
[rack]: ./services_master_rack.html
[webrick]: ./services_master_webrick.html
[master_http]: ./yard/file.http_api_index.html
[auth.conf]: ./conf_file_auth.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[report handlers]: ./report.html
[lang_basics]: ./lang_summary.html
[apply]: ./services_apply.html
[puppetdb]: /puppetdb/latest
[resource]: ./lang_resources.html


Puppet usually uses an agent/master (client/server) architecture for configuring systems, using the **puppet agent** and **puppet master** applications. It can also run in a self-contained architecture with the **puppet apply** application.

> Note: Two Stages for Configuration Management
> -----
>
> Puppet configures systems in two main stages:
>
> 1. Compile a catalog
> 2. Apply the catalog
>
> ### What is a Catalog?
>
> A catalog is a document that describes the desired system state for one specific computer. It lists all of the resources that need to be managed, as well as any dependencies between those resources.
>
> To compile a catalog, Puppet uses several sources of information. For more info, see the pages on [basics of the Puppet language][lang_basics] and [catalog compilation][catalog_compilation].


The Agent/Master Architecture
-----

Puppet usually runs in an agent/master architecture, where a puppet master server controls important configuration info and managed agent nodes request only their own configuration catalogs.

### Basics

In this architecture, managed nodes run the **puppet agent** application, usually as a background service. One or more servers run the **puppet master** application, usually [as a Rack application][rack] managed by a web server (like Apache with Passenger).

Periodically, puppet agent will send facts to the puppet master and request a catalog. The master will compile and return that node's catalog, using several sources of information it has access to.

Once it receives a catalog, puppet agent will apply it by checking each [resource][] the catalog describes. If it finds any resources that are not in their desired state, it will make any changes necessary to correct them. (Or, in no-op mode, it will report on what changes would have been needed.)

After applying the catalog, the agent will submit a report to the puppet master.

### About the Puppet Services

* [Puppet Agent on \*nix Systems][agent_unix]
* [Puppet Agent on Windows Systems][agent_win]
* [The Rack Puppet Master][rack]
* [The WEBrick Puppet Master][webrick]

### Communications and Security

Puppet agent nodes and puppet masters communicate via HTTPS with client-verification.

The puppet master provides an HTTP interface, with [various endpoints][master_http] available. When requesting or submitting anything to the master, the agent will make an HTTPS request to one of those endpoints.

For details, see:

* [A walkthrough of Puppet's HTTPS communications][https_walkthrough]
* [The puppet master's HTTP API][master_http]
* [The puppet master's auth.conf file][auth.conf]

Client-verified HTTPS means each master or agent must have an identifying SSL certificate, and will examine their counterpart's certificate to decide whether to allow an exchange of information.

Puppet includes a built-in certificate authority (CA) for managing certificates. Agents can automatically request certificates via the master's HTTP API, users can use the **puppet cert** command to inspect requests and sign new certificates, and agents can then download the signed certificates.

For general info about SSL, see [our background reference on SSL and HTTPS.](/background/ssl/)


The Stand-Alone Architecture
-----

Puppet can run in a stand-alone architecture, where each managed server has its own complete copy of your configuration info and compiles its own catalog.

### Basics

In this architecture, managed nodes run the **puppet apply** application, usually as a scheduled task or cron job. (You can also run it on demand for initial configuration of a server or for smaller configuration tasks.)

Like the puppet master application, puppet apply needs access to several sources of configuration data, which it uses to compile a catalog for the node it is managing.

After puppet apply compiles the catalog, it immediately applies it by checking each [resource][] the catalog describes. If it finds any resources that are not in their desired state, it will make any changes necessary to correct them. (Or, in no-op mode, it will report on what changes would have been needed.)

After applying the catalog, puppet apply will store a report on disk. It can also be configured to send reports to a central service.

### About the Puppet Apply Application

* [The Puppet Apply Application][apply]


> Note: Differences Between Agent/Master and Puppet Apply
> -----
>
> In general, puppet apply can do the same things as the combination of puppet agent and puppet master, but there are several trade-offs around security and the ease of certain tasks.
>
> If you don't have a preference, you should default to an agent/master architecture. If you have questions, considering these trade-offs will help you make your decision.
>
> * **Principle of least privilege.** In agent/master Puppet, each agent only gets its own configuration, and is unable to see how other nodes are configured. With puppet apply, it's impractical to do this, so every node has access to complete knowledge about how your site is configured. Depending on how you're configuring your systems, this can potentially raise the risks of horizontal privilege escalation.
> * **Ease of centralized reporting and inventory.** Agents send reports to the puppet master by default, and the master can be configured with any number of [report handlers][] to pass these on to other services. You can also connect the master to [PuppetDB][], a powerful tool for querying inventory and activity data. Puppet apply nodes handle their own information, so if you're using PuppetDB or sending reports to another service, _each_ node needs to be configured and authorized to connect to it.
> * **Ease of updating configurations.** Only the puppet master server(s) have the Puppet modules, main manifests, and other data necessary for compiling catalogs. This means that when you need to update your systems' configurations, you only need to update content on one (or a few) servers. In a decentralized puppet apply deployment, you'll need to sync new configuration code and data to every node.
> * **CPU and memory usage on managed machines.** Since puppet agent doesn't compile its own catalogs, it uses fewer resources on the machines it manages, leaving them with more capacity for their designated tasks.
> * **Need for a dedicated master server.** The puppet master takes on the performance load of compiling all catalogs, and it should usually be a dedicated machine with a fast processor, lots of RAM, and a fast disk. Not everybody wants to (or is able to) allocate that, and puppet apply can get around the need for it.
> * **Need for good network connectivity.** Agents need to be able to reach the puppet master at a reliable hostname in order to configure themselves. If a system lives in a degraded or isolated network environment, you may want it to be more self-sufficient.
> * **Security overhead.** Agents and masters use HTTPS to secure their communications and authenticate each other, and every system involved needs an SSL certificate. Puppet includes a built-in CA to easily manage certificates, but it's even easier to not manage them at all. (Of course, you'll still need to manage security somehow, since you're probably using Rsync or something to update Puppet content on every node.)
