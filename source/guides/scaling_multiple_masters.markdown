---
layout: default
title: "Using Multiple Puppet Masters With Open Source Puppet"
description: "This document outlines options for open source Puppet deployments with multiple masters."
---

Using Multiple Puppet Masters With Open Source Puppet
=====

To scale beyond a certain size, or for geographic distribution or disaster recovery, a deployment may warrant having more than one Puppet master. This document outlines options for open source Puppet deployments with multiple masters.

> Note: This document is specific to open source Puppet, versions 2.7 through 3.2. If you're using Puppet Enterprise 3.7 or later, please use the [split installation guide][pe_split], then add [new Puppet masters][pe_add_master] or [additional ActiveMQ resources][pe_add_amq] to your deployment as needed.

[pe_split]: /pe/latest/install_pe_split.html
[pe_add_master]: /pe/latest/install_multimaster.html
[pe_add_amq]: /pe/latest/install_add_activemq.html

In brief:

1. [Determine the method you will use to distribute the agent load among the available masters](#distributing-agent-load)
2. [Centralize all certificate authority functions](#centralize-the-certificate-authority)
3. [Bring up additional puppet master servers](#create-new-puppet-master-servers)
4. [Centralize reporting, inventory service, and storeconfigs (if necessary)](#centralize-reports-inventory-service-and-catalog-searching-storeconfigs)
5. [Keep manifests and modules in sync across your puppet masters](#keep-manifests-and-modules-in-sync-across-your-puppet-masters)
6. [Implement agent load distribution](#implement-load-distribution)


Distributing Agent Load
-----

First things first; the rest of your configuration will depend on how you're planning on distributing the agent load.  You have several options available.  Determine what your deployment will look like now, but **implement this as the last step**, only after you have the infrastructure in place to support it.

### Option 1: Statically Designate Servers on Agent Nodes

Manually or with Puppet, change the `server` setting in each agent node's `puppet.conf` file such that the nodes are divided more or less evenly among the available masters.

This option is labor-intensive and will gradually fall out of balance, but it will work without additional infrastructure.

### Option 2: Use Round-Robin DNS

Leave all of your agent nodes pointed at the same puppet master hostname, then configure your site's DNS to arbitrarily route all requests directed at that hostname to the pool of available masters.

For instance, if all of your agent nodes are configured with `server = puppet.example.com`, you'll configure a DNS name such as:

    # IP address of master 1:
    puppet.example.com. IN A 192.0.2.50
    # IP address of master 2:
    puppet.example.com. IN A 198.51.100.215

For this option, you'll need to configure your masters with `dns_alt_names` before their certificate request is made --- [see below.](#before-running-puppet-agent-or-puppet-master)

### Option 3: Use a Load Balancer

You can also use a hardware load balancer or a load balancing proxy webserver to redirect requests more intelligently. Depending on how it's configured for SSL (either raw TCP proxying, or acting as its own SSL endpoint), you'll need to use a combination of the other procedures in this document.

Configuring a load balancer is beyond the scope of this document.

### Option 4: DNS `SRV` Records

This option is new in Puppet 3.0, and will only work if your entire Puppet infrastructure is on 3.0 or newer.

> Note: Designating Puppet services with SRV records is an **experimental feature.** It is currently being used in production at several large sites, but there are still some issues with the implementation to be wary of. Specifically: it makes a large number of DNS requests, request timeouts are completely under the DNS server's control and agents cannot bail early, the way it divides services does not map perfectly to the pre-existing `server`/`ca_server`/etc. settings, and SRV records don't interact well with static servers set in the config file (i.e. static settings can't be used for failover, it's one or the other). Please keep these potential pitfalls in mind when configuring your DNS!

You can use DNS `SRV` records to assign a pool of puppet masters for agents to communicate with.  This requires a DNS service capable of `SRV` records --- all major DNS software including Windows Server's DNS and BIND are compatible.

Each of your puppet nodes will be configured with a `srv_domain` instead of a `server` in their `puppet.conf`:

    [main]
      use_srv_records = true
      srv_domain = example.com

..then they will look up a `SRV` record at `_x-puppet._tcp.example.com` when they need to talk to a puppet master.

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

* * *

Centralize the Certificate Authority
-----

The additional puppet masters at a site should only share the burden of compiling and serving catalogs; any certificate authority functions should be delegated to a single server. **Choose one server** to act as the CA, and ensure that it is reachable at a **unique hostname other than (or in addition to) `puppet`.**

There are two main options for centralizing the CA:

### Option 1: Direct agent nodes to the CA Master

#### Method A: Individual Agent Configuration

On **every agent node,** you must set the [`ca_server`](/puppet/latest/reference/configuration.html#caserver) setting in [`puppet.conf`](/puppet/latest/reference/config_file_main.html) (in the `[main]` configuration block) to the hostname of the server acting as the certificate authority.

* If you have a large number of existing nodes, it is easiest to do this by managing `puppet.conf` with a Puppet module and a template.
* Be sure to pre-set this setting when provisioning new nodes --- they will be unable to successfully complete their initial agent run if they're not communicating with the correct `ca_server`.

#### Method B: DNS `SRV` Records

If you are [utilizing `SRV` records for agents](#option-4-dns-srv-records), then you can use the `_x-puppet-ca._tcp.$srv_domain` DNS name to configure clients to point to a single specific CA server, while the `_x-puppet._tcp.$srv_domain` DNS name will be handling the majority of their requests to masters and can be a set of puppet masters without CA capabilities.

### Option 2: Proxy Certificate Traffic

Alternately, if your nodes don't have direct connectivity to your CA master, you aren't using `SRV` records, or you do not wish to change every node's `puppet.conf`, you can configure the web server on the puppet masters other than your CA master to proxy all certificate-related traffic to the designated CA master.

> This method only works if your puppet master servers are using a web server that provides a method for proxying requests, like [Apache with Passenger](/guides/passenger.html).

All certificate related URLs begin with `/<NAME OF PUPPET ENVIRONMENT>/certificate`; simply catch and proxy these requests using whatever capabilities your web server offers.

> #### Example: Apache configuration with [`mod_proxy`](http://httpd.apache.org/docs/current/mod/mod_proxy.html)
>
> In the scope of your puppet master vhost, add the following configuration:
>
>     SSLProxyEngine On
>     # Proxy all requests that start with things like /production/certificate to the CA
>     ProxyPassMatch ^/([^/]+/certificate.*)$ https://puppetca.example.com:8140/$1
>     ProxyPassReverse ^(/.*?)/(certificate.*?)/(.*)$ https://puppetca.example.com:8140/$1
>
> This change must be made to the Apache configuration on every puppet master server other than the one serving as the CA. No changes need to be made to agent nodes' configurations.
>
> Note that if your puppet master vhost sets `PassengerHighPerformance On`, you'll need to disable it for the CA routes, since it interferes with `mod_proxy` (among other things). Since PassengerHighPerformance can be enabled or disabled at global, vhost, or directory scope, you can use a Location directive to disable it:
>
>     <Location ~ "/[^/]+/certificate">
>         PassengerHighPerformance Off
>     </Location>
>
> Additionally, the CA master must allow the nodes to download the certificate revocation list via the proxy, without authentication --- certificate requests and retrieval of signed certificates are allowed by default, but not CRLs.  Add the following to the CA master's `auth.conf`:
>
>     path /certificate_revocation_list
>     auth any
>     method find
>     allow *

* * *

Create New Puppet Master Servers
-----

### Install Puppet

To add a new puppet master server to your deployment, begin by [installing and configuring Puppet](/puppet/latest/reference/install_pre.html) as per normal.

As with any puppet master, you'll need to use a production-grade web server rather than the default WEBrick server. We generally assume that you know how to do this if you're already at the point where you need multiple masters, but see [Scaling with Passenger](/guides/passenger.html) for one way to do it.

### Before Running `puppet agent` or `puppet master`

* In `puppet.conf`, do the following:
    * Set `ca` to `false` in the `[master]` config block.
    * *If you're using the [individual agent configuration method of CA centralization](#option-1-direct-agent-nodes-to-the-ca-master):*

      Set `ca_server` to the hostname of your CA server in the `[main]` config block.
    * If an `ssldir` is configured, make sure it's configured in the `[main]` block only.

> If you're using the [DNS round robin method](#option-2-use-round-robin-dns) of agent load balancing, or a [load balancer](#option-3-use-a-load-balancer) in TCP proxying mode, your non-CA masters will need certificates with DNS Subject Alternative Names:
>
> * Configure `dns_alt_names` in the `[main]` block of `puppet.conf`.
>
>   It should be configured to cover every DNS name that might be used by a node to access this master.
>
>       dns_alt_names = puppet,puppet.example.com,puppet.site-a.example.com
>
> * If the agent or master has been run and already created a certificate, blow it away by running `sudo rm -r $(puppet master --configprint ssldir)`.  If a cert has been requested from the master, you'll also need to delete it there to re-issue a new one with the alt names: `puppet cert clean master-2.example.com`.

* Request a new certificate by running `puppet agent --test --waitforcert 10`.
* Log into the CA server and run `puppet cert sign master-2.example.com`.

  (You'll need to add `--allow-dns-alt-names` to the command if `dns_alt_names` were in the certificate request.)

* * *

Centralize Reports, Inventory Service, and Catalog Searching (storeconfigs)
-----

If you are using Puppet Dashboard or another HTTP report processor, you should point all of your puppet masters at the same shared Dashboard server; otherwise, you won't be able to see all of your nodes' reports.

If you are using the inventory service or exported resources, it's complex and impractical to use any of the older (activerecord) backends in a multi-master environment. **You should definitely switch to [PuppetDB](/puppetdb),** and point all of your puppet masters at a shared PuppetDB instance. A reasonably robust PuppetDB server can handle many puppet masters and many thousands of agent nodes.

See [the PuppetDB manual](/puppetdb/latest) for instructions on setting up PuppetDB. You will need to deploy a PuppetDB server, then configure each puppet master to use it. Note that every puppet master will need to have its own [whitelist entry](/puppetdb/latest/configure.html#certificate-whitelist) if you're using HTTPS certificates for authorization.


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
