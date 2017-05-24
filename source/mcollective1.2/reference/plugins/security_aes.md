---
layout: default
title: OpenSSL based Security Plugin
disqus: true
canonical: "/mcollective/reference/plugins/security_aes.html"
---
[SimpleRPCAuthorization]: /mcollective1.2/simplerpc/authorization.html
[Registration]: registration.html
[SSLSecurity]: security_ssl.html
[SecurityOverview]: ../../security.html

# {{page.title}}

 * TOC Placeholder
 {:toc}

## Overview
This plugin impliments a AES encryption and RSA public / private key based security system
for The Marionette Collective.

Please review the [Security Overview][SecurityOverview] for a general discussion about security in Marionette Collective.

The design goals of this plugin are:

 * Each actor - clients and servers - can have their own set of public and private keys
 * All actors are uniquely and cryptographically identified
 * Requests are encrypted using the clients private key and anyone that has
   the public key can see the request.  Thus an atacker may see the requests
   given access to a public key of the requester.
 * Replies are encrypted using the calling clients public key.  Thus no-one but
   the caller can view the contents of replies.
 * Servers can all have their own SSL keys, or share one, or reuse keys created
   by other PKI using software like Puppet
 * Requests from servers - like registration data - can be secured even to external
   eavesdropping depending on the level of configuration you are prepared to do
 * Given a network where you can ensure third parties are not able to access the
   middleware public key distribution can happen automatically

During the design of this system we considered the replies back to clients to be most
important piece of information on the network.  This is secured in a way that only
the client can decrypt the replies he gets.  An attacker will need to gain access
to every private key of every client to see all the reply data.

Serialization uses Marshal or YAML, which means data types in and out of mcollective
will be preserved from client to server and reverse.

*This plugin will only function with MCollective 1.1.1 or newer*

## Compared to the SSL plugin

The earlier [SSLSecurity] only provided message signing and identification of clients, this
new plugin builds on this adding payload encryption, identification of servers and optional
automatic key distribution.

The [SSLSecurity] plugin puts less drain on resources, if you do not specifically need encryption
you should consider using that one instead.

## Deployment Scenarios

There are various modes of deployment, the more secure you wish to be the more work you have
to do in terms of key exchange and initial setup.

This plugin is designed to allow you to strike a balance between security and setup cost
the sections below discuss the possible deployment scenarios to help you choose an approach.

In all of the below setups the following components are needed:

 * Each user making requests - the client - needs a public and private key pair
 * Each server receiving requests need the public key of each client

In cases where you wish to use [Registration] or initiate requests from the server for any
reason the following are needed:

 * Each server needs a public and private key pair
 * Each other server that wish to receive these requests need the public key of the sending server

In this scenario each server will act as a client making RPC requests to the collective network
for any agent called _registration_.  So in this scenario the server acts as a client and therefore
need a key-pair to identify it.

### Manual key distribution with each server and client having unique keys

In this setup each client and each server needs a unique set of keys.  You need to
distribute these keys manually and securely - perhaps using Puppet.

The setup cost is great, to enable registration the nodes receiving registration data
need to have the public key of every other node stored locally before registration
data can be received.

If you do not use Puppet or some other PKI system that provide access to keys you need
create keypairs for each node and client.

This is the most secure setup protecting all replies and registration data.  Rogue people
on the network who do not compromise a running host cannot make requests on the network.

Attackers who compromise a server can only make registration requests assuming you deployed
a strictly configured [Authorization][SimpleRPCAuthorization] system they cannot use those
machines as starting points to inject requests for the rest of your network.

By gaining access to your Middleware an attacker will not be able to observe the contents of
requests, replies or registration messages.  Attackers need to compromise servers and gain
access to private keys before they can start observing parts of the exchange.

|Feature / Capability|Supported|
|--------------------|---------|
|Clients are uniquely identified using cryptographic means|yes|
|Anyone with the client public key can observe request contents|yes|
|Attackers can gain access to the client public key by just listening on the network|no|
|Replies back to the client are readable only by client that initiated the request|yes|
|Attackers can create new certificates and start using them to make requests as clients|no|
|Servers are uniquely identified using cryptographic means|yes|
|Anyone with the server public key can observe registration contents|yes|
|Attackers can gain access to the server public keys by just listening on the network|no|
|Registration data can be protected from rogue agents posing as registration agents|yes|
|Attackers can create new nodes and inject registration data for those new nodes|no|

To configure this scenario use the following options and manually copy public keys to the
_plugin.aes.client`_`cert`_`dir_ directory:

|Settings|Value|Descritpion|
|--------|-----|-----------|
|plugin.aes.send_pubkey|0|Do not send public keys|
|plugin.aes.learn_pubkeys|0|Do not learn public keys|

### Automatic public key distribution with each server and client having unique keys

Here we enable the  _plugin.aes.learn`_`pubkeys_ feature on all servers.  Your public keys
will now be distributed automatically on demand but you loose some security in that anyone
with access to your network or middleware can observe the contents of replies and registration
data

You still need to create keys for every node - or use Puppets.  You still need to create keys
for every user.

In order to protect against attackers creating new certificates and making requests on your network
deploy a [Authorization][SimpleRPCAuthorization] plugin that denies unknown clients.

|Feature / Capability|Supported|
|--------------------|---------|
|Clients are uniquely identified using cryptographic means|yes|
|Anyone with the client public key can observe request contents|yes|
|Attackers can gain access to the client public key by just listening on the network|*yes*|
|Replies back to the client are readable only by client that initiated the request|yes|
|Attackers can create new certificates and start using them to make requests as clients|*yes*|
|Servers are uniquely identified using cryptographic means|yes|
|Anyone with the server public key can observe registration contents|yes|
|Attackers can gain access to the server public keys by just listening on the network|*yes*|
|Registration data can be protected from rogue agents posing as registration agents|yes|
|Attackers can create new nodes and inject registration data for those new nodes|*yes*|

To configure this scenario use the following options and ensure the _mcollectived_ can write
to the _plugin.aes.client`_`cert`_`dir_ directory:

|Settings|Value|Descritpion|
|--------|-----|-----------|
|plugin.aes.send_pubkey|1|Send public keys|
|plugin.aes.learn_pubkeys|1|Learn public keys|

### Manual public key distribution with servers sharing a key pair and clients having unique keys

This is comparable to the older SSL plugin where all servers shared the same public / private
pair.  Here anyone who is part of the network can decrypt the traffic related to registration
but replies to clients are still securely encrypted and visable only to them.

You will not need to create unique keys for every server, you can simply copy the same one out
everywhere.  You still need to create keys for every user.

If you do not use registration, this is a very secure setup that requires a small configuration
overhead.

|Feature / Capability|Supported|
|--------------------|---------|
|Clients are uniquely identified using cryptographic means|yes|
|Anyone with the client public key can observe request contents|yes|
|Attackers can gain access to the client public key by just listening on the network|no|
|Replies back to the client are readable only by client that initiated the request|yes|
|Attackers can create new certificates and start using them to make requests as clients|no|
|Servers are uniquely identified using cryptographic means|*no*|
|Anyone with the server public key can observe registration contents|yes|
|Attackers can gain access to the server public keys by just listening on the network|no|
|Registration data can be protected from rogue agents posing as registration agents|*no*|

To configure this scenario use the following options and ensure the _mcollectived_ can write
to the _plugin.aes.client`_`cert`_`dir_ directory:

|Settings|Value|Descritpion|
|--------|-----|-----------|
|plugin.aes.send_pubkey|0|Do not send public keys|
|plugin.aes.learn_pubkeys|0|Do not learn public keys|

### Automatic public key distribution with servers sharing a key and client having unique keys

This is comparable to the older SSL plugin where all servers shared the same public / private
pair.  Here anyone who is part of the network can decrypt the traffic related to registration
but replies to clients are still securely encrypted and visable only to them.

Here we enable the  _plugin.aes.learn`_`pubkeys_ feature on all servers.  Your public keys
will now be distributed automatically on demand but you loose some security in that anyone
with access to your network or middleware can observe the contents of replies and registration
data

You will not need to create unique keys for every server, you can simply copy the same one out
everywhere.  You still need to create keys for every user.

In order to protect against attackers creating new certificates and making requests on your network
deploy a [Authorization][SimpleRPCAuthorization] plugin that denies unknown clients.

|Feature / Capability|Supported|
|--------------------|---------|
|Clients are uniquely identified using cryptographic means|yes|
|Anyone with the client public key can observe request contents|yes|
|Attackers can gain access to the client public key by just listening on the network|*yes*|
|Replies back to the client are readable only by client that initiated the request|yes|
|Attackers can create new certificates and start using them to make requests as clients|*yes*|
|Servers are uniquely identified using cryptographic means|*no*|
|Anyone with the server public key can observe registration contents|yes|
|Attackers can gain access to the server public keys by just listening on the network|*yes*|
|Registration data can be protected from rogue agents posing as registration agents|*no*|

To configure this scenario use the following options and ensure the _mcollectived_ can write
to the _plugin.aes.client`_`cert`_`dir_ directory:

|Settings|Value|Descritpion|
|--------|-----|-----------|
|plugin.aes.send_pubkey|1|Send public keys|
|plugin.aes.learn_pubkeys|1|Learn public keys|

## Creating keys

Keys are created using OpenSSL.  The filenames of public keys are significant you should name
them so that they are unique for your network and they should match on the client and servers.

{% highlight console %}
 % openssl genrsa -out server-private.pem 1024
 % openssl rsa -in server-private.pem -out server-public.pem -outform PEM -pubout
{% endhighlight %}

Client and Server keys are made using the same basic method.

## Reusing Puppet keys

Puppet managed nodes will all have keys created by Puppet already, you can reuse these if your
_mcollectived_ runs as root.

Generally Puppet stores these in _/var/lib/puppet/ssl/private`_`keys/fqdn.pem_ and _/var/lib/puppet/ssl/public`_`keys/fqdn.pem_
simply configure these paths for your _server`_`private_ and _server`_`public_ options.

Clients will still need their own keys made and distributed.

## Future Roadmap

 * Depending on performance of the initial system we might validate request certificates are
   signed by a known CA this will provide an additional level of security preventing attackers
   from creating their own keys and using those on the network without also compromising the CA.
 * Private keys will be secured with a password


## Configuration Options

### Common Options

|Setting|Example / Default|Description
|-------|-----------------|-----------|
|securityprovider|aes_security|Enables this security provider|
|plugin.aes.serializer|yaml or marshal|Serialization to use|
|plugin.aes.send_pubkey|0 or 1|Send the public key with every request|
|plugin.aes.learn_pubkeys|0 or 1|Receive public keys from the network and cache them locally|

### Client Options

|Setting|Example / Default|Description
|-------|-----------------|-----------|
|plugin.aes.client_private|/home/user/.mcollective.d/user-private.pem|The private key path for the user|
|plugin.aes.client_public|/home/user/.mcollective.d/user.pem|The public key path for the user|

### Server Options

|Setting|Example / Default|Description
|-------|-----------------|-----------|
|plugin.aes.client_cert_dir|/etc/mcollective/ssl/clients|Where to store and load client public keys|
|plugin.aes.server_private|/etc/mcollective/ssl/server-private.pem|Server private key|
|plugin.aes.server_public|/etc/mcollective/ssl/server-public.pem|Server public key|



