---
layout: default
title: OpenSSL based Security Plugin
disqus: true
canonical: "/mcollective/reference/plugins/security_ssl.html"
---
[SimpleRPCAuthorization]: /mcollective1.2/simplerpc/authorization.html
[Registration]: registration.html
[AESPlugin]: security_aes.html
[SecurityOverview]: ../../security.html

# {{page.title}}

 * TOC Placeholder
 {:toc}

## Overview
Implements a public/private key based message validation system using SSL
public and private keys.

Please review the [Security Overview][SecurityOverview] for a general discussion about security in Marionette Collective.

The design goal of the plugin are two fold:

 * give different security credentials to clients and servers to avoid a compromised server from sending new client requests.
 * create a token that uniquely identify the client - based on the filename of the public key.  This creates a strong identity token for [SimpleRPCAuthorization].

Serialization uses Marshal or YAML, which means data types in and out of mcollective
will be preserved from client to server and reverse.

Validation is as default and is provided by *MCollective::Security::Base*

Initial code was contributed by Vladimir Vuksan and modified by R.I.Pienaar

An [alternative plugin][AESPlugin] exist that encrypts data but is more work to setup and maintain.

## Setup

### Nodes
To setup you need to create a SSL key pair that is shared by all nodes.

{% highlight console %}
 % openssl genrsa -out server-private.pem 1024
 % openssl rsa -in server-private.pem -out server-public.pem -outform PEM -pubout
{% endhighlight %}

Distribute the private and public file to */etc/mcollective/ssl* on all the nodes.
Distribute the public file to */etc/mcollective/ssl* everywhere the client code runs.

server.cfg:

{% highlight ini %}
  securityprovider = ssl
  plugin.ssl_server_private = /etc/mcollective/ssl/server-private.pem
  plugin.ssl_server_public = /etc/mcollective/ssl/server-public.pem
  plugin.ssl_client_cert_dir = /etc/mcollective/ssl/clients/
{% endhighlight %}


### Users and Clients
Now you should create a key pair for every one of your clients, here we create one
for user john - you could also if you are less concerned with client id create one
pair and share it with all clients:

{% highlight console %}
 % openssl genrsa -out john-private.pem 1024
 % openssl rsa -in john-private.pem -out john-public.pem -outform PEM -pubout
{% endhighlight %}

Each user has a unique userid, this is based on the name of the public key.
In this example case the userid would be *'john-public'*.

Store these somewhere like:

{% highlight console %}
 /home/john/.mc/john-private.pem
 /home/john/.mc/john-public.pem
{% endhighlight %}

Every users public key needs to be distributed to all the nodes, save the john one
in a file called:

{% highlight console %}
  /etc/mcollective/ssl/clients/john-public.pem
{% endhighlight %}

If you wish to use [Registration] or auditing that sends connections over MC to a
central host you will need also put the *server-public.pem* in the clients directory.

You should be aware if you do add the node public key to the clients dir you will in
effect be weakening your overall security.  You should consider doing this only if
you also set up an Authorization method that limits the requests the nodes can make.

client.cfg:

{% highlight ini %}
 securityprovider = ssl
 plugin.ssl_server_public = /etc/mcollective/ssl/server-public.pem
 plugin.ssl_client_private = /home/john/.mc/john-private.pem
 plugin.ssl_client_public = /home/john/.mc/john-public.pem
{% endhighlight %}

If you have many clients per machine and dont want to configure the main config file
with the public/private keys you can set the following environment variables:

{% highlight console %}
 export MCOLLECTIVE_SSL_PRIVATE=/home/john/.mc/john-private.pem
 export MCOLLECTIVE_SSL_PUBLIC=/home/john/.mc/john-public.pem
{% endhighlight %}

### Serialization Method

**Note: This option is available from version 0.4.8 onward**

You can choose either YAML or Marshal, the default is Marshal.  The view with optional Marshal encoding is to have a serializer supported by other languages other than Ruby to enable future integration with those.

To use YAML set this in both *client.cfg* and *server.cfg*:

{% highlight ini %}
plugin.ssl_serializer = yaml
{% endhighlight %}
