---
layout: legacy
title: "Using Multiple Puppet Masters"
---

Using Multiple Puppet Masters
=====

To scale beyond a certain size, or for geographic distribution or disaster recovery, a deployment may warrant having more than one puppet master server. This document outlines options for deployments with multiple masters.

> Note: As of this writing, this document does not cover:
> 
> * How to expand the inventory service or storeconfigs ([PuppetDB](/puppetdb) should be implemented for this)
> * How to expand Puppet Enterprise's orchestration or live management features

In brief:

1. [Determine the method you will use to distribute the agent load among the available masters](#distributing-agent-load)
2. [Centralize all certificate authority functions](#centralize-the-certificate-authority)
3. [Bring up additional puppet master servers](#create-new-puppet-master-servers)
4. [Keep manifests and modules in sync across your puppet masters](#keep-manifests-and-modules-in-sync-across-your-puppet-masters)
5. [Implement agent load distribution](#implement-load-distribution)


Distributing Agent Load
-----

First things first; the rest of your configuration will depend on how you're planning on distributing the agent load.  You have several options available.  Determine what your deployment will look like now, but **implement this as the last step**, only after you have the infrastructure in place to support it.

### Option 1: DNS `SRV` Records

This option is new in Puppet 3.0, and is the recommended deployment if your entire Puppet infrastructure is on 3.0 or newer.

You can use DNS `SRV` records to assign a pool of Puppet masters for agents to communicate with.  This requires a DNS service capable of `SRV` records - all major DNS software including Windows Server's DNS and BIND are compatible.

Each of your puppet nodes will be configured with a `srv_domain` instead of a `server` in their `puppet.conf`:

    [main]
      use_srv_records = true
      srv_domain = example.com

..then they will look up a `SRV` record at `_x-puppet._tcp.example.com` when they need to talk to a Puppet master.

    # Equal-weight load balancing between master-a and master-b:
    _x-puppet._tcp.example.com. IN SRV 0 5 8140 master-a.example.com.
    _x-puppet._tcp.example.com. IN SRV 0 5 8140 master-b.example.com.

Advanced configurations are also possible.  For instance, if all devices in site A are configured with a `srv_domain` of `site-a.example.com` and all nodes in site B are configured to `site-b.example.com`, you can configure them to prefer a master in the local site, but fail over to the remote site:
    
    # Site A has two masters - master-1 is beefier, give it 75% of the load:
    _x-puppet._tcp.site-a.example.com. IN SRV 0 75 8140 master-1.site-a.example.com.
    _x-puppet._tcp.site-a.example.com. IN SRV 0 25 8140 master-2.site-a.example.com.
    _x-puppet._tcp.site-a.example.com. IN SRV 1 5 8140 master.site-b.example.com.
    
    # For site B, prefer the local master unless it's down, then fail back to site A
    _x-puppet._tcp.site-b.example.com. IN SRV 0 5 8140 master.site-b.example.com.
    _x-puppet._tcp.site-b.example.com. IN SRV 1 75 8140 master-1.site-a.example.com.
    _x-puppet._tcp.site-b.example.com. IN SRV 1 25 8140 master-2.site-a.example.com.

### Option 2: Statically Designate Servers on Agent Nodes

Manually or with Puppet, change the `server` setting in each agent node's `puppet.conf` file such that the nodes are divided more or less evenly among the available masters.

This option is labor-intensive and will gradually fall out of balance, but it will work without additional infrastructure.

### Option 3: Use Round-Robin DNS

Leave all of your agent nodes pointed at the same puppet master hostname, then configure your site's DNS to arbitrarily route all requests directed at that hostname to the pool of available masters.

For instance, if all of your agent nodes are configured with `server = puppet.example.com`, you'll configure a DNS name such as:

    # IP address of master 1:
    puppet.example.com. IN A 192.0.2.50
    # IP address of master 2:
    puppet.example.com. IN A 198.51.100.215

For this option, you'll need to configure your masters with `dns_alt_names` before their certificate request is made - [see below.](#before-running-puppet-agent-or-puppet-master)

### Option 4: Use a Load Balancer

You can also use a hardware load balancer or a load balancing proxy webserver to redirect requests more intelligently. Depending on how it's configured for SSL (either raw TCP proxying, or acting as its own SSL endpoint), you'll need to use a combination of the other procedures in this document.

Configuring a load balancer is beyond the scope of this document.

* * *

Centralize the Certificate Authority
-----

The additional Puppet masters at a site should only share the burden of compiling and serving catalogs; any certificate authority functions should be delegated to a single server. **Choose one server** to act as the CA, and ensure that it is reachable at a **unique hostname other than (or in addition to) `puppet`.**

There are two main options for centralizing the CA:

### Option 1: Direct agent nodes to the CA Master

#### Method A: DNS `SRV` Records

If you are [utilizing `SRV` records for agents](#option-1-dns-srv-records), then you can use the `_x-puppet-ca._tcp.$srv_domain` DNS name to configure clients to point to a single specific CA server, while the `_x-puppet._tcp.$srv_domain` DNS name will be handling the majority of their requests to masters and can be a set of Puppet masters without CA capabilities.

#### Method B: Individual Agent Configuration

On **every agent node,** you must set the [`ca_server`](/references/latest/configuration.html#ca_server) setting in [`puppet.conf`](/guides/configuring.html) (in the `[main]` configuration block) to the hostname of the server acting as the certificate authority. 

* If you have a large number of existing nodes, it is easiest to do this by managing `puppet.conf` with a Puppet module and a template. 
* Be sure to pre-set this setting when provisioning new nodes - they will be unable to successfully complete their initial agent run if they're not communicating with the correct `ca_server`.

### Option 2: Proxy Certificate Traffic

Alternately, if your nodes don't have direct connectivity to your CA master, you aren't using `SRV` records, or you do not wish to change every node's `puppet.conf`, you can configure the web server on the Puppet masters other than your CA master to proxy all certificate-related traffic to the designated CA master.

> This method only works if your puppet master servers are using a web server that provides a method for proxying requests, like [Apache with Passenger](/guides/passenger.html).

All certificate related URLs begin with `/certificate`; simply catch and proxy these requests using whatever capabilities your web server offers.

> #### Example: Apache configuration with [`mod_proxy`](http://httpd.apache.org/docs/current/mod/mod_proxy.html)
> 
> In the scope of your puppet master vhost, add the following configuration:
> 
>     SSLProxyEngine On
>     ProxyPassMatch ^/([^/]+/certificate.*)$ https://puppetca.example.com:8140/$1
> 
> This change must be made to the Apache configuration on every Puppet master server other than the one serving as the CA. No changes need to be made to agent nodes' configurations.
> 
> Additionally, the CA master must allow the nodes to download the certificate revocation list via the proxy, without authentication - certificate requests and retrieval of signed certificates are allowed by default, but not CRLs.  Add the following to the CA master's `auth.conf`:
> 
>     path /certificate_revocation_list
>     auth any
>     method find
>     allow *

* * * 

Create New Puppet Master Servers
-----

### Install Puppet

To add a new puppet master server to your deployment, begin by installing and configuring Puppet as per normal. 

* [Installing Puppet (open source versions)](/guides/installation.html)
* [Installing Puppet Enterprise](/pe/2.5/install_basic.html)

Like with any puppet master, you'll need to use a production-grade web server rather than the default WEBrick server. We generally assume that you know how to do this if you're already at the point where you need multiple masters, but see [Scaling with Passenger](/guides/passenger.html) for one way to do it.

### Before Running `puppet agent` or `puppet master`

* In `puppet.conf`, do the following:
    * Set `ca` to `false` in the `[master]` config block.
    * *If you're using the [individual agent configuration method of CA centralization](#option-1-direct-agent-nodes-to-the-ca-master):*
    
      Set `ca_server` to the hostname of your CA server in the `[main]` config block.
    * If an `ssldir` is configured, make sure it's configured in the `[main]` block only.

> If you're using the [DNS round robin method](#option-3-use-round-robin-dns) of agent load balancing, or a [load balancer](#option-4-use-a-load-balancer) in TCP proxying mode, your non-CA masters will need certificates with DNS Subject Alternative Names:
> 
> * Configure `dns_alt_names` in the `[main]` block of `puppet.conf`.
> 
>   It should be configured to cover every DNS name that might be used by a node to access this master.
>   
>       dns_alt_names = puppet,puppet.example.com,puppet.site-a.example.com
>       
> * If the agent or master has been run and already created a certificate, blow it away by running `sudo rm -rf $(puppet master --configprint ssldir)`.  If a cert has been requested from the master, you'll also need to delete it there to re-issue a new one with the alt names: `puppet cert clean master-2.example.com`.

* Request a new certificate by running `puppet agent --test --waitforcert 10`.
* Log into the CA server and run `puppet cert sign master-2.example.com`.

  (You'll need to add `--allow-dns-alt-names` to the command if `dns_alt_names` were in the certificate request.)

* * *

Keep Manifests and Modules in Sync Across Your Puppet Masters
-----

You will need to find some way to ensure that all of your puppet masters have identical copies of your manifests, Puppet modules, and [external node classifier](/guides/external_nodes.html) data. Some options are:

* Use a version control system such as Git, Mercurial, or Subversion to manage and sync your manifests, modules, and other data.
* Run an out-of-band rsync task via cron.
* Configure puppet agent on each master node to point to a designated model puppet master, then use Puppet itself to distribute the modules.

* * *

Implement Load Distribution
-----

Now that your other masters are ready, you can implement the agent load balancing mechanism that you selected [above](#distributing-agent-load).
