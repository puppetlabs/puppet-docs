---
layout: default
title: "Overview of Puppet's Architecture"
---

[agent_unix]: ./services_agent_unix.html
[agent_win]: ./services_agent_windows.html
[https_walkthrough]: ./subsystem_agent_master_comm.html
[multi_master]: /guides/scaling_multiple_masters.html
[ext_ca]: ./config_ssl_external_ca.html
[facter]: /facter/latest/
[facts]: ./lang_facts_and_builtin_vars.html
[reporting]: /guides/reporting.html
[rack]: ./services_master_rack.html
[webrick]: ./services_master_webrick.html
[master_http]: /references/3.6.latest/developer/file.http_api_index.html
[auth.conf]: ./conf_file_auth.html
[environment]: ./environments.html
[enc]: /guides/external_nodes.html
[catalog_compilation]: ./subsystem_catalog_compilation.html
[static_compiler]: /references/3.6.latest/indirection.html#staticcompiler-terminus
[file resource]: /references/3.6.latest/type.html#file
[node terminus]: /references/3.6.latest/configuration.html#nodeterminus
[catalog terminus]: /references/3.6.latest/configuration.html#catalogterminus
[usecacheonfailure]: /references/3.6.latest/configuration.html#usecacheonfailure
[ca_server]: /references/3.6.latest/configuration.html#caserver
[server]: /references/3.6.latest/configuration.html#server
[noop_setting]: /references/3.6.latest/configuration.html#noop
[reportserver]: /references/3.6.latest/configuration.html#reportserver
[report_setting]: /references/3.6.latest/configuration.html#report
[reports_setting]: /references/3.6.latest/configuration.html#reports
[ca_server_setting]: /references/3.6.latest/configuration.html#caserver
[report handlers]: /references/3.6.latest/report.html
[request manager]: /pe/latest/console_cert_mgmt.html
[autosigning]: ./ssl_autosign.html


Puppet configures systems in two main stages:

1. Compile a "catalog" that describes a desired system state, using Puppet modules, site-specific manifests, and other data.
2. Apply the catalog --- that is, compare the desired state to the state of the actual system, and make (or simulate) any necessary changes to enforce the desired state.

We generally recommend splitting these stages up: a **puppet master server** can compile catalogs for all nodes, and **puppet agent nodes** can fetch their own catalogs and enforce them.

Alternately, the **puppet apply application** can do both of these stages.

Differences Between Agent/Master and Puppet Apply
-----

In general, puppet apply can do the same things as the combination of puppet agent and puppet master. There are several trade-offs around security and the ease of certain tasks.

* **Principle of least privilege.** In agent/master Puppet, each agent only gets its own configuration, and is unable to see how other nodes are configured. With puppet apply, it's impractical to do this, so every node has access to complete knowledge about how your site is configured. Depending on how you're configuring your systems, this can potentially raise the risks of horizontal privilege escalation.
* **Ease of centralized reporting.** Agents send reports to the puppet master by default, and the master can be configured with any number of [report handlers][] to pass these on to other services. Puppet apply nodes handle their own reports, so if you're sending those reports to another service, each node needs to be configured and authorized to connect to it.
* **Ease of updating configurations.** Only the puppet master server(s) have the Puppet modules, main manifests, and other data necessary for compiling catalogs. This means that when you need to update your systems' configurations, you only need to update content on one (or a few) servers. In a decentralized puppet apply deployment, you'll need to sync new configuration data to every node.
* **CPU and memory usage on managed machines.** Since puppet agent doesn't compile its own catalogs, it uses fewer resources on the machines it manages, leaving them with more capacity for their designated tasks.
* **Need for a dedicated master server.** The puppet master should usually be a dedicated machine with a fast processor, lots of RAM, and a fast disk. Not everybody wants to (or is able to) allocate that, and puppet apply can get around the need for it.
* **Need for good network connectivity.** Agents need to be able to reach the puppet master at a reliable hostname in order to configure themselves. If a system lives in a degraded network environment, you may want it to be more self-sufficient.
* **Security overhead.** Agents and masters use HTTPS to secure their communications and authenticate each other, and every system involved needs an SSL certificate. Puppet includes a built-in CA to easily manage certificates, but it's even easier to not manage them at all. (Of course, you'll still need to manage security somehow, since you're probably using Rsync or something to update Puppet content on every node.)


The Architecture of Agent/Master Puppet
-----

In agent/master puppet, many computers (**managed nodes** or **agent nodes**) run the **puppet agent application,** usually as a service. Periodically, puppet agent will request a catalog from its configured **puppet master server.** The puppet master will respond with a catalog, and the agent will apply it.

The two sections below will cover the subtleties of how this happens.

### What Puppet Agent Does

[agent_does]: #what-puppet-agent-does

This section describes the actual tasks performed by puppet agent. For details about puppet agent's run environment and how to control it, see:

* [Puppet Agent on \*nix Systems][agent_unix]
* [Puppet Agent on Windows Systems][agent_win]

Puppet agent has three main tasks, all of which require it to interact with a puppet master server:

* It manages its own SSL credentials, if necessary.
* It fetches a catalog and configures the system it's running on.
* It sends a report about its activity after each time it applies a catalog.

For more granular details about this process, see [the walkthrough of Puppet's HTTPS communications.][https_walkthrough]

#### Managing Credentials

To request a catalog, the agent requires an SSL certificate signed by the certificate authority (CA) that the puppet master trusts. It also needs a copy of that CA's certificate, and the certificate revocation list (CRL) published by that CA.

Usually, the puppet master runs its own CA. In a multi-master deployment, it's best to centralize this function on one master; see [the multi-master guide][multi_master] for more info.

Alternately, you can run your own CA. See [the reference page on external CAs][ext_ca] for more info. If you run your own CA, you must make sure credentials are in place before puppet agent runs.

If it's time to fetch and apply a catalog and puppet agent lacks the credentials it needs, it will try to obtain them from the server specified by its [`ca_server` setting][ca_server], which defaults to the main puppet master from the `server` setting. It will contact that master over unsecured HTTPS and use the `certificate` endpoint to obtain the CA certificate, the `certificate_revocation_list` endpoint to obtain the CSR, the `certificate_request` endpoint to submit a certificate request, and the `certificate` endpoint again to obtain its own signed certificate. For details about this process, see [the walkthrough of Puppet's HTTPS communications.][https_walkthrough]

#### Fetching Catalogs and Applying Them

When it's time to fetch and apply a catalog (see the [sections on the agent run environment][agent_does] linked above for details), puppet agent will do the following:

* Check whether its SSL credentials are sorted, and attempt to obtain them if they aren't. (See above.)
* Fetch its node object from the puppet master, and use the
* Fetch plugins from the puppet master configured by the [`server` setting][server]. These plugins may include custom resource types, custom resource providers, and custom facts. (This is implemented as HTTPS GET requests to the `file_metadata` and `file_content` endpoints.)
* Run [Facter][] to collect data about the system's status (hostname, operating system, any custom facts received as plugins, etc.). See [Facts and Built-in Variables][facts] and the [Facter docs][Facter] for details.
* Request a catalog from the puppet master server configured by the [`server` setting][server], while submitting the system data (**facts**) obtained from Facter. (This is implemented as an HTTPS POST request to the `catalog` endpoint, with the facts as the body of the POST.)
* Apply the received catalog. Puppet agent goes through the catalog resource-by-resource, checks the actual state of that resource, and makes changes if necessary. If [the `noop` setting][noop_setting] is set to `true`, the agent will simulate changes instead of applying them.

    In the default configuration, the agent will re-use the previous catalog if it was unable to get a fresh one. This can be configured with [the `usecacheonfailure` setting.][usecacheonfailure]

#### Reporting

While it applies a catalog, puppet agent also prepares a report of all activity during this run --- including changes, simulated changes, etc.

After the run, it submits the report to the server configured by [the `reportserver` setting][reportserver]. (Defaults to the main puppet master from `server`.) This can be disabled with [the `report` setting][report_setting]. See [the reference page on reporting][reporting] for details.


### What Puppet Master Does

This section describes the actual tasks performed by the puppet master application. For details about its run environment and how to control it, see:

* [The Rack Puppet Master][rack]
* [The WEBrick Puppet Master][webrick]

The puppet master application listens for several kinds of requests and responds to them. These requests usually come from puppet agent nodes.

The requests the puppet master can handle are defined by its [HTTP interface][master_http]. When it receives a request, it consults the access rules in its [auth.conf file][auth.conf] to decide whether it should respond.

The main HTTP endpoints used by puppet agent nodes are:

#### Node

Puppet agent fetches a "node object" from the puppet master before attempting to fetch a catalog. It uses the [environment][] in the node object to decide which environment to use for its subsequent requests.

A node object contains information from the configured [node terminus][]. This means that if you use an [external node classifier (ENC)][enc], it can set an environment for nodes.

The auth.conf only allows nodes to request their own node object, not those of other nodes.

#### Catalog

Puppet agent requests a catalog by making a POST request to the catalog endpoint. The body of the POST contains the node's [facts][].

When the master receives a catalog request, it obtains a catalog from its configured [catalog terminus][], then serves it to the requesting agent node.

Nearly everybody uses the "compiler" catalog terminus. This code path causes the puppet master to go through the catalog compilation process, [as described on the Catalog Compilation page,][catalog_compilation] using that node's facts, name, environment, and certificate data to initialize the process.

Some people use [the "static compiler" terminus][static_compiler], which is similar to the normal compiler terminus but embeds the metadata for files with `source` attributes. This can decrease catalog application time and HTTP overhead, at the cost of increased compilation time and more complicated configuration.

#### File Content, File Metadata, and Filebucket

For each [file resource][] that specifies a `source => puppet:///...` attribute, puppet agent may make requests for metadata and content.

If agents are configured to back up files to a central filebucket, they will send content to the `file_bucket_file` endpoint whenever they overwrite a file.

If the master is configured with the [static compiler terminus][static_compiler], agents will request file content from the `file_bucket_file` endpoint instead of the file content endpoint.

#### Report

After running, agents will usually send a [report][reporting] to the puppet master. The master can process these reports using any number of [report handlers][], configured using [the `reports` setting.][reports_setting]

#### Certificate, Certificate Request, and Certificate Revocation List

If the agent doesn't already have the SSL infrastructure it needs to communicate with the puppet master, it will contact the server specified in its [`ca_server` setting][ca_server_setting] to fetch a CA certificate, submit a certificate signing request, and fetch its signed certificate.

By default, a user must sign all agent certificate requests using `puppet cert sign` or Puppet Enterprise's [request manager][]. You can also configure [autosigning][].
