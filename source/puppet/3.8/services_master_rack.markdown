---
layout: default
title: "Puppet's Services: The Rack Puppet Master"
canonical: "/puppet/latest/reference/services_master_rack.html"
---


[rack]: http://rack.github.io/
[passenger_guide]: /guides/passenger.html
[passenger]: http://www.modrails.com/
[external_ca]: ./config_ssl_external_ca.html
[client authentication]: /background/ssl/tls_ssl.html
[subject dn]: /background/ssl/cert_anatomy.html#the-subject-dn-cn-certname-etc
[pem format]: /background/ssl/cert_anatomy.html#pem-file
[trusted]: ./lang_facts_and_builtin_vars.html#trusted-facts
[webrick]: ./services_master_webrick.html
[puppet server]: /puppetserver/1.1/services_master_puppetserver.html

Puppet master is the application that compiles configurations for any number of Puppet agent nodes, using Puppet code and various other data sources. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

[Rack][] is an interface for deploying Ruby web apps. The Puppet master application supports running as a Rack app.

A Rack server is one of two recommended ways to run the Puppet master service; the other is [Puppet Server][]. Today, they're very nearly equivalent, but we're putting the bulk of our development effort behind Puppet Server --- it's going to keep getting better than Rack, and Rack support will eventually be removed.

> Puppet Enterprise 3.8 uses Puppet Server instead of Rack; previous versions configure Rack for you. You do not need to manually configure a Rack server under Puppet Enterprise.

This page describes the generic requirements and run environment for running under Rack; for practical configuration instructions, see [the guide to configuring a Passenger + Apache Puppet master.][passenger_guide]

For details about invoking the Puppet master command, see [the puppet master man page](./man/master.html).

## Supported Platforms

The Rack Puppet master will run on any \*nix platform, including all Linux variants and OS X. It requires a **multi-process** (_not_ threaded) Rack web server.

You cannot run a Puppet master on Windows.

### Rack Web Servers

There are a lot of Rack web server stacks available. Puppet should work with any Rack server that spawns multiple processes to handle parallel requests.

> Note that Puppet **will not** work with **threaded** Rack servers like Puma. Puppet's code isn't thread-safe, and it expects to be isolated in a single process.

If you don't have any particular preference, you should start with [Passenger][] and Apache, since it's the most familiar and most thoroughly tested stack in the Puppet community. We have [a detailed guide to configuring Passenger for Puppet.][passenger_guide] Additionally, some OSes have packages that automatically configure a Puppet master with Passenger.

The Unicorn + Nginx stack is also fairly popular, but it has more pieces that you'll need to assemble and configure.

## Controlling the Service

Under Rack, the Puppet master processes are started and managed by your Rack web server. The way to start and stop the Puppet master will depend on your specific web server stack.

If your Rack stack isn't running any other applications or sites, you can simply start and stop the whole server process; if it also provides other services, as a Passenger/Apache stack sometimes does, you may need to disable the Puppet master's virtual host and do a graceful restart.

## The Rack Puppet Master's Run Environment

Rack and the Puppet master application each have various expectations about their environment. To make them work together, you'll need to make sure these expectations are met.

### User

The Puppet master Ruby processes should be run as a specific **non-root** user, which is usually `puppet`. This should match the user specified by [the `user` setting][user].

The Rack web server sets the Puppet master process's user. By default, it will use the owner of the `config.ru` file. (See below.)

All of the Puppet master's files and directories must be readable and writable by this user.

[user]: ./configuration.html#user

### Required Directories

[confdir]: ./dirs_confdir.html
[vardir]: ./dirs_vardir.html

Before a Rack Puppet master can fully start up, it needs access to a [confdir][] and a [vardir][] that its user has permission to write to. The locations of the confdir and vardir it will use are set in the `config.ru` file (see below).

The Puppet master application can manage its own files inside those directories, but since Rack doesn't start the master with root permissions, it won't be able to create the initial directories in `/etc` or `/var`.

You can create these directories manually and set their ownership to the Puppet master's user. Alternately, you can briefly start a [WEBrick Puppet master][webrick] and let it handle the initial setup. Run:

    $ sudo puppet master --verbose --no-daemonize

Once the terminal says `Notice: Starting Puppet master version <VERSION>`, type ctrl-C to kill the process.

### Ports

By default, Puppet's HTTPS traffic uses port 8140. Your web server must be listening on this port, and the OS and firewall must allow it to accept incoming connections on this port.

A Rack Puppet master will ignore [the `masterport` setting](./configuration.html#masterport); instead, the web server's configuration (for example, an Apache vhost) controls the port. You must ensure that the web server is listening on this port and is routing those requests to the Puppet master application.

If you want to switch to a non-default port, you'll have to change your web server's configuration, then make sure `masterport` is set correctly on all agents.

### Keepalive Timeout

By default, the Puppet agent application will keep its HTTPS connections open for **up to four seconds** of idle time. (Configurable with [the `http_keepalive_timeout` setting.](./configuration.html#httpkeepalivetimeout))

This means Puppet expects the Rack web server to have **a keepalive timeout of at least four seconds, preferably five.** This is compatible with the default configuration of the most popular Rack stack.

If the keepalive timeout is set too low on the master, agents will occasionally fail with an "Error: Could not retrieve catalog from remote server: end of file reached" message.

### Logging

When running under Rack, Puppet master's logging is split.

Your Rack server stack is in charge of logging any information about incoming HTTPS requests and errors. It may maintain per-vhost log files, or send messages elsewhere. See your server's documentation for details.

The Puppet master application itself logs its activity to syslog. This is where things like compilation errors and deprecation warnings go. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

Alternately, if you specify the `--logdest <FILE>` option in `config.ru`, Puppet master will log to the file specified by `<FILE>`.

### The `config.ru` File

All Rack web servers use a `config.ru` file to load applications. This file is a Ruby script that loads any necessary libraries, performs any necessary configuration, and creates an application object that can handle Rack-formatted requests.

The Puppet source includes a `config.ru` file for the Puppet master application. It is located at `ext/rack/config.ru`. If you don't have a full copy of the Puppet source, you can [download this `config.ru` file directly from GitHub](https://raw.github.com/puppetlabs/puppet/stable/ext/rack/config.ru).

To run a Rack Puppet master, you must configure your Rack web server to load an application from this `config.ru` file and to route all Puppet requests to it.

The exact steps will depend on your Rack server; see the [Passenger guide][passenger_guide] for an example.

Note that the `config.ru` file must be owned by the user `puppet` and the group `puppet` (or whatever user you want the Puppet master to run as; see "User" above). Most Rack servers use this file's ownership to set the application's user. Alternately, you may be able to explicitly configure your Rack server to use a specific user.

### SSL Termination

Your Rack web server stack must terminate SSL and verify agent certificates. The stack must also pass certain certificate data from each request to the Puppet master.

This may be done by the Rack web server itself, or by some kind of SSL terminating proxy. For general information about this, see [our background reference on SSL.][ssl_persist]

You should have already initialized a CA and created the Puppet master's credentials. To terminate SSL you will need one or more CA certificates, a Puppet master certificate, a Puppet master private key, and a certificate revocation list (CRL).

Your SSL termination must be configured as follows:

* It must use a set of cyphers and protocols compatible with the version(s) of OpenSSL that your Puppet agent nodes are using.
* It must trust the Puppet CA certificate as its CA. (If you are using an intermediate or split external CA, this is somewhat more complicated; see [the external CA reference][external_ca] for details.)
* It must identify itself to clients using the Puppet master's certificate and private key.
* It must have [client authentication][] enabled but optional.
* It must note whether the client connection was verified. This information must eventually reach the Puppet master; see below.
* It must note the [Subject DN][] of the client's certificate, if the connection was verified. This information must eventually reach the Puppet master.
* It should pass on the entire client certificate, if the connection was verified. This information should eventually reach the Puppet master.


[ssl_persist]: /background/ssl/https.html#persistence-of-sslcertificate-data-in-https-applications

### Required Environment Variables / Headers

The Rack server should set three per-request environment variables for the Puppet master: `HTTP_X_CLIENT_VERIFY`, `HTTP_X_CLIENT_DN`, and `SSL_CLIENT_CERT`.

None of these are set by default; you'll need to configure your SSL terminator to preserve the information, and configure your Rack server to make it available to Puppet.

#### `HTTP_X_CLIENT_VERIFY`

Mandatory. Must be one of `NONE`, `SUCCESS`, `GENEROUS` or `FAILED:reason`.

The Rack server will automatically set this variable if some other part of the stack added the `X-Client-Verify` HTTP header to the request.

You can change the variable name Puppet looks for with [the `ssl_client_verify_header` setting.](./configuration.html#sslclientverifyheader)

#### `HTTP_X_CLIENT_DN`

Mandatory. Must be the [Subject DN][] of the agent's certificate, if a certificate was presented.

The Rack server will automatically set this variable if some other part of the stack added the `X-Client-DN` HTTP header to the request.

You can change the variable name Puppet looks for with [the `ssl_client_header` setting.](./configuration.html#sslclientheader)

#### `SSL_CLIENT_CERT`

Optional. Should be the entire client certificate in [PEM format][], if a certificate was presented.

Puppet uses this variable to enable [the `$trusted` hash][trusted] and to log warnings when agent certificates are about to expire. If the variable is absent, you will not be able to use these features.

If the Rack server is embedded in the same server that terminates SSL, this variable may be easy to fill. For example, in Apache with `mod_ssl`, setting `SSLOptions +ExportCertData` will automatically put the client certificate into `SSL_CLIENT_CERT`.

If the Rack server is _not_ embedded in the SSL terminating part of your stack (for example, when running under the Nginx + Unicorn stack), you may need to embed the certificate in an HTTP header, then configure your Rack server to extract the certificate data and set the environment variable.

The name of this variable is not configurable.

## Configuring a Rack Puppet Master

As [described elsewhere,][about_settings] the Puppet master application reads most of its settings from [puppet.conf][] and can accept additional settings on the command line. When running under Rack, Puppet master gets its command line options from the `config.ru` file. By default, it only sets the `confdir` and `vardir` settings and the special `--rack` option.

To change the Puppet master's settings, you should use [puppet.conf][]. The only two options you may want to set in `config.ru` are `--verbose` or `--debug`, to change the amount of detail in the logs.

[about_settings]: ./config_about_settings.html
[puppet.conf]: ./config_file_main.html

> ## Aside: How a Rack Puppet Master Works
>
> A Rack web server loads and executes a special part of Puppet's Ruby code, which creates a Puppet master application object that can respond to specially formatted requests. To handle parallel requests, it can do this any number of times. (The number of workers depends on how the Rack server is configured.)
>
> When an HTTPS request comes in, the web server passes it to Rack. Rack reformats the request, turning it into a Ruby object that contains all of the relevant information (URL, method, POST data, headers, SSL info). It then passes the formatted request to the application object.
>
> The Puppet master application reads information from the request, then builds a response, doing whatever is necessary to construct it. This may involve returning file contents, returning certificates or other credentials, or the full process of catalog compilation (request a node object from an ENC, evaluate the main manifest, load and evaluate classes from modules, evaluate templates, collect exported resources, etc.). The Puppet master object then formats its response and passes it to Rack, which passes it on to the web server and the agent node that made the request.

