---
layout: legacy
title: "Using Multiple Puppet Masters"
---

Using Multiple Puppet Masters
=====

To scale beyond a certain size, an agent/master Puppet site will require more than one puppet master server. This document outlines a simple process to expand a single-master site to use multiple masters. 

> Note: As of this writing, this document does not cover:
> 
> * How to expand the inventory service or storeconfigs
> * How to expand PE's orchestration or live management features

In brief:

1. Centralize all certificate authority functions
2. Bring up additional puppet master servers
3. Keep manifests and modules in sync across your puppet masters
4. Distribute the agent load among the available masters


Centralize the Certificate Authority
-----

The additional puppet masters at a site should only share the burden of compiling and serving catalogs; any certificate authority functions should be delegated to a single server. **Choose one server** to act as the CA, and ensure that it is reachable at a **unique hostname other than (or in addition to) `puppet`.**

There are two main options for centralizing the CA:

### Option 1: Set `ca_server` on Agent Nodes

On **every agent node,** you must set the [`ca_server`](/references/latest/configuration.html#ca_server) setting in [`puppet.conf`](/guides/configuring.html) (in the `[main]` configuration block) to the hostname of the server acting as the certificate authority. 

* If you have a large number of existing nodes, it is easiest to do this by managing `puppet.conf` with a Puppet module and a template. 
* Be sure to pre-set this setting when provisioning new nodes.

### Option 2: Redirect Certificate Traffic

Alternately, if you do not wish to change every node's `puppet.conf`, you can configure the web server front-end on every new puppet master server to redirect certificate traffic to the CA server. This method only works if your puppet master servers are using a web server that provides a method for proxying requests, like Apache with Passenger.

All certificate request URLs begin with `/certificate`; simply catch and proxy these requests using whatever capabilities your web server offers.

[mod_proxy]: http://httpd.apache.org/docs/current/mod/mod_proxy.html

> #### Example: Apache configuration with [`mod_proxy`][mod_proxy]
> 
> At global scope in your Apache config file, add the following stanza, changing the BalancerMember URL to match your CA's hostname:
> 
>     <Proxy balancer://puppet_ca>
>      BalancerMember http://puppetca.example.com:8140
>     </Proxy>
> 
> In the scope of your puppet master vhost, add the following rules:
> 
>     ProxyPassMatch ^(/.*?)/(certificate.*?)/(.*)$ balancer://puppet_ca/
>     ProxyPassReverse ^(/.*?)/(certificate.*?)/(.*)$ balancer://puppet_ca/
> 
> These two changes must be made to the Apache configuration on every puppet master server other than the one serving as the CA. No changes need to be made to agent nodes' configurations.


Create New Puppet Master Servers
-----

### Install Puppet

To add a new puppet master server to your deployment, begin by installing and configuring Puppet as per normal. 

* [Installing Puppet (open source versions)](/guides/installation.html)
* [Installing Puppet Enterprise](/pe/2.5/install_basic.html)

Like with any puppet master, you'll need to use a production-grade web server rather than the default WEBrick server. We generally assume that you know how to do this if you're already at the point where you need multiple masters, but see [Scaling with Passenger][passenger] for one way to do it.

[passenger]: /guides/passenger.html


### Stop the Puppet Master Service

If puppet master is running, stop it.

### Configure CA Delegation and Get a Certificate

* In `puppet.conf`, do the following: 
    * Set `ca` to `false` in the `[master]` config block.
    * Set `ca_server` to the hostname of your CA server in the `[main]` config block.
    * Make sure the `ssldir` setting is either absent from all config blocks, specified in the `[main]` block only, or identical in the `[master]` and `[agent]` blocks.
* If the installation process created an `ssldir`, blow it away by running `sudo rm -rf $(puppet master --configprint ssldir)`.
* Request a certificate by running:

        $ sudo puppet agent --test --dns_alt_names "master2.example.com,puppet,puppet.example.com"
    
    The `dns_alt_names` setting is a comma-separated list, and should contain this master's unique hostname and any additional public DNS name(s) that agent nodes may use to contact a puppet master. Replace the example names with ones relevant to your site.
* Log into the CA server and run `sudo puppet cert sign <NEW MASTER'S CERTNAME>`.
* Retrieve the certificate on the new master by running `sudo puppet agent --test`.

### If Necessary, Configure CA Traffic Proxying

[See above.](#option-2-redirect-certificate-traffic)


Keep Manifests and Modules in Sync Across Your Puppet Masters
-----

You will need to find some way to ensure that all of your puppet masters have identical copies of your manifests, Puppet modules, and [external node classifier](/guides/external_nodes.html) data. Some options are:

* Run an out-of-band rsync task via cron.
* Configure puppet agent on each master node to point to a designated model puppet master, then use Puppet itself to distribute the modules. 


Distribute the Agent Load
-----

You must somehow arrange for the puppet agent requests at your site to be distributed more or less evenly across the pool of available puppet masters. There are several ways to do this. 

### Option 1: Statically Designate Servers on Agent Nodes

Manually or with Puppet, change the `server` setting in each agent node's `puppet.conf` file such that the nodes are divided more or less evenly among the available masters.

This option is labor-intensive and will gradually fall out of balance, but it will work without additional infrastructure.

### Option 2: Use Round-Robin DNS

Leave all of your agent nodes pointed at the same puppet master hostname, then configure your site's DNS to arbitrarily route all requests directed at that hostname to the pool of available masters.

Configuring DNS is beyond the scope of this document; see the documentation for your DNS server software.

### Option 3: Use a Load Balancer

You can also use a hardware load balancer or a load balancing proxy webserver to redirect requests more intelligently. 

Configuring a load balancer is beyond the scope of this document.

