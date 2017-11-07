---
layout: default
title: Configuration Guide
disqus: true
canonical: "/mcollective/reference/basic/configuration.html"
---

[SSLSecurity]: /mcollective1.2/reference/plugins/security_ssl.html
[AESSecurity]: /mcollective1.2/reference/plugins/security_aes.html
[Registration]: /mcollective1.2/reference/plugins/registration.html
[Auditing]: /mcollective1.2/simplerpc/auditing.html
[Authorization]: /mcollective1.2/simplerpc/authorization.html
[Subcollectives]: /mcollective1.2/reference/basic/subcollectives.html

# {{page.title}}

 * TOC Placeholder
 {:toc}

This guide tells you about the major configuration options in the daemon and client config files.  There are options not mentioned
here typically ones specific to a certain plugin.

## Configuration Files
There are 2 configuration files, one for the client and one for the server, these default to */etc/mcollective/server.cfg* and */etc/mcollective/client.cfg*.

Configuration is a simple *key = val* style configuration file.

## Common Options

|Key|Sample|Description|
|---|------|-----------|
|topicprefix|/topic/mcollective|Prefix that gets used for all messages.  Post 1.1.3 this should just be /topic/|
|topicnamesep|.|The seperator to use between parts of the topic path|
|collectives|mcollective,subcollective|A list of [Subcollectives] to join - 1.1.3 and newer only|
|main_collective|mcollective|The main collective to target - 1.1.3 and newer only|
|logfile|/var/log/mcollective.log|Where to log|
|loglevel|debug|Can be info, warn, debug, fatal, error|
|identity|dev1.your.com|Identifier for this node, does not need to be unique, defaults to hostname if unset|
|keeplogs|5|The amount of logs to keep|
|max_log_size|2097152|Max size in bytes for log files before rotation happens|
|libdir|/usr/libexec/mcollective:/site/mcollective|Where to look for plugins|
|connector|Stomp|Which _connector_ plugin to use for communication|
|securityprovider|Psk|Which security model to use, see [SSL Security Plugin][SSLSecurity] and [AES Security Plugin][AESSecurity] for details on others|
|rpchelptemplate|/etc/mcollective/rpc-help.erb|The path to the erb template used for generating help|
|loggertype|file|Valid logger types, currently file, syslog or console|
|ssl_cipher|aes-256-cbc|This sets the cipher in use by the SSL code, see _man enc_ for a list supported by OpenSSL|

## Server Configuration
The server configuration file should be root only readable

|Key|Sample|Description|
|---|------|-----------|
|daemonize|1|Runs the server in the background|
|factsource|Facter|Which fact plugin to use|
|registration|Agentlist|[Registration] plugin to use|
|registerinterval|120|How many seconds to sleep between registration messages, setting this to zero disables registration|
|classesfile|/var/lib/puppet/classes.txt|Where to find a list of classes configured by your configuration management system|
|rpcaudit|1|Enables [SimpleRPC Auditing][Auditing]|
|rpcauditprovider|Logfile|Enables auditing using _MCollective::Audit::Logfile_|
|rpcauthorization|1|Enables [SimpleRPC Authorization][Authorization] globally|
|rpcauthprovider|action_policy|Use the _MCollective::Util::ActionPolicy_ plugin to manage authorization|
|rpclimitmethod|The method used for --limit-results.  Can be either _first_ or _random_|
|fact_cache_time|300|How long to cache fact results for before refreshing from source|
|plugin.discovery.timeout|10|Sets the timeout for the discovery agent, useful if facts are very slow|

The last example sets a option for the _discovery_ plugin, you can also set this in _/etc/mcollective/plugin.d/discovery.cfg_, in that case
you'd just set _timeout=10_ in the file.

## Client Configuration
The client configuration file should be readable by everyone, it's not advised to put PSK's or client SSL certs in a world readable file, see below how to do that per user.

|Key|Sample|Description|
|---|------|-----------|
|color|0|Disables the use of color in RPC results|

## Plugin Configuration
You can add free form config options for plugins, they take the general form like:

{% highlight ini %}
    plugin.pluginname.option = value
{% endhighlight %}

Each plugin's documentation should tell you what options are availble.

Common plugin options are:

|Key|Sample|Description|
|---|------|-----------|
|plugin.stomp.host|stomp.your.com|Host to connect too|
|plugin.stomp.port|6163|Port to connecto too|
|plugin.stomp.user|mcollective|User to connect as|
|plugin.stomp.password|password|Password to use|
|plugin.yaml|/etc/mcollective/facts.yaml:/other/facts.yaml|Where the yaml fact source finds facts from, multiples get merged|
|plugin.psk|123456789|The pre-shared key to use for the Psk security provider|
|plugin.psk.callertype|group|What to base the callerid on for the PSK plugin, uid, gid, user, group or identity|

## Client Setup
It's recommended that you do not set host, user, password and Psk in the client configuration file since these files are generally world readable unlike the server one that should be root readable only.  I just set mine to *unset* so it's clear to someone who looks at the config file that it's not going to work without the settings below.

From version _0.4.8_ onwards you can also put client configuration in _~/.mcollective_ as an alternative to the method below, but you will need a full client.cfg then in that location.

You can set various Environment variables per user to supply these values:

{% highlight bash %}
export STOMP_USER=user
export STOMP_PASSWORD=password
export STOMP_SERVER=stomp.your.com
export MCOLLECTIVE_PSK=123456789
{% endhighlight %}

You an set options that will always apply using the _MCOLLECTIVE_EXTRA_OPTS_ as below:

{% highlight bash %}
export MCOLLECTIVE_EXTRA_OPTS="--dt 5 --timeout 3 --config /home/you/mcollective.cfg"
{% endhighlight %}

The client library will use these and so you can give each user who use the admin utilities their own username and rights.
