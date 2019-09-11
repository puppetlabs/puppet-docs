---
layout: default
title: "Installing Puppet: Post-Install Tasks"
---

[peinstall]: {{pe}}/install_basic.html
[hiera_include]: {{hiera}}/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
[hiera]: {{hiera}}/
[puppet.conf]: ./config_file_main.html
[dns_alt_names]: ./configuration.html#dnsaltnames
[about_settings]: ./config_about_settings.html
[manifest]: ./dirs_manifest.html
[install_modules]: ./modules_installing.html
[directory environments]: ./environments.html
[modulepath]: ./dirs_modulepath.html
[rack]: http://rack.github.io/
[puppet classes]: ./lang_classes.html
[modules_fundamentals]: ./modules_fundamentals.html
[node definitions]: ./lang_node_definitions.html
[external node classifier]: ./external_nodes.html
[ssldir]: ./dirs_ssldir.html
[install-latest]: /puppet/3.8/install_pre.html

> #### **Note:** This document covers *open source* releases of Puppet version 3.8 and lower. For current versions, you should see instructions for [installing the latest version of Puppet][install-latest] or [installing Puppet Enterprise][peinstall].

Perform the following tasks after you finish installing Puppet. You should have already done the [pre-install tasks](./pre_install.html) and followed the installation instructions for your OS.

Configure a Puppet Master Server
-----

After installing Puppet on a node that will act as a puppet master server, you need to:

* Get the master's names and certificates set up
* Configure any necessary settings
* Put your Puppet modules and manifests in place
* Configure a production-ready web server
* Configure load balancing and CA service routing if you're using multiple masters
* Start the puppet master service

### Get the Master's Names and Certificates Set Up

When you create the puppet master's certificate, you must include every DNS name at which agent nodes might try to contact the master.

Decide on a main name for Puppet services at your site, and make sure your DNS resolves it to the puppet master (or its load balancer). Unconfigured agents will try to find a master at `puppet`, so if you use this name it can reduce setup time.

In the `[main]` section of the master's [puppet.conf][] file, set [the `dns_alt_names` setting][dns_alt_names] to a comma-separated list of each hostname the master should be allowed to use:

    dns_alt_names = puppet,puppet.example.com,puppetmaster01,puppetmaster01.example.com

#### For CA Masters

If this is the only puppet master in your deployment, or if it will be acting as the CA server for a multi-master site, you should now run:

    $ sudo puppet master --verbose --no-daemonize

This will create the CA certificate and the puppet master certificate, with the appropriate DNS names included. Once it says `Notice: Starting Puppet master version <VERSION>`, type ctrl-C to kill the process.

#### For Non-CA Masters

You have two main options:

* Run `puppet cert generate <NAME> --dns_alt_names=<NAME 1>,<NAME 2>,<NAME 3>` on your CA server, then manually copy the new master's cert, private key, and public key into place on the new master. You will also need to give it a copy of the CA's certificate and the CRL. See [the reference page on the ssldir][ssldir] for more info about these files.
* Run `puppet agent --test --ca_server=<SERVER>` to request a certificate. On the CA server, run `puppet cert list` and `puppet cert --allow-dns-alt-names sign <NAME>` to sign the certificate. On the new master, run `puppet agent --test --ca_server=<SERVER>` again to retrieve the cert.

### Configure Any Necessary Settings

You'll want to set a few settings in [puppet.conf][] before putting the new master to work. See [the list of master-related settings][master_settings] for details. You may also want to read about [how Puppet loads settings][about_settings] and [the syntax of the puppet.conf file][puppet.conf].

[master_settings]: ./config_important_settings.html#settings-for-puppet-master-servers

### Put Your Puppet Modules and Manifests in Place

If you already have a set of modules and a main manifest you use in your deployment, put them into place now. You will probably be checking them out with version control.

If you're starting from scratch, ensure that [the main manifest][manifest] exists. You may also want to [install some modules from the Puppet Forge][install_modules].

Relevant reference pages:

* [Directory environments][]
* [The main manifest][manifest]
* [The modulepath][modulepath]


### Configure a Production-Ready Web Server

Puppet includes a basic puppet master web server, but you cannot use it for real-life loads. You must configure a production quality web server before you start managing your nodes with Puppet.

If you have no particular preference, you should use Passenger with Apache, since it works well and is simple to set up. If you installed the `puppetmaster-passenger` package on Debian or Ubuntu, this is already configured; otherwise, [follow the instructions in the Puppet with Passenger setup guide.](./passenger.html)

Alternately, Puppet supports the [Rack][] interface, and you can configure your puppet master with any Rack web server stack. You can follow the Passenger guide for general guidelines. You will need to:

* [Grab the config.ru file from the `ext/rack` directory in the Puppet source][ext_rack], and set its ownership to the `puppet` user and group.
* Configure your web stack to listen on port 8140 and use that config.ru file to route requests to the puppet master application.
* Configure your front end to terminate SSL using the puppet master server's SSL certificate and the local Puppet CA. Make sure that it sets the `SSL_CLIENT_CERT` environment variable and the `X_CLIENT_VERIFY` and `X_CLIENT_DN` HTTP headers.

[ext_rack]: https://github.com/puppetlabs/puppet/tree/master/ext/rack

### Start the Puppet Master Service

The exact service you need to start will depend on the web server you configured. If you followed the Passenger guide, you'll want to start the `httpd` or `apache2` service, depending on your OS.


Configure a Puppet Agent Node
-----

After installing Puppet on a normal puppet agent node, you'll need to:

* Configure Puppet
* Start the puppet agent service (or configure a cron job)
* Sign the new node's certificate
* Classify (assign configurations to) the new node


### Configure Puppet

You will probably need to configure some settings in each agent's [puppet.conf][] file, to connect it to your puppet master server and change certain behavior.

See [the list of agent-related settings][agent_settings] for details. You may also want to read about [how Puppet loads settings][about_settings] and [the syntax of the puppet.conf file][puppet.conf].

[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes


### Start the Puppet Agent Service

If the puppet agent service isn't already running, you should now start it and configure it to start on boot. Alternately, you may want to run puppet agent via a cron job instead, or run puppet apply with a cron job for a standalone deployment.

#### Starting the Service

The name of the puppet agent service may vary by platform. On Windows and most \*nix platforms, it will be `puppet`; on OS X, it is `com.puppetlabs.puppet`.

You can start and enable the service by running:

    $ sudo puppet resource service <NAME> ensure=running enable=true

(Although on Windows you would omit the `sudo`.)

#### Creating a Cron Job

You may want to run puppet agent with cron rather than its init script; this can sometimes perform better and use less memory. You can create this cron job with Puppet:

    $ sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

(On Windows nodes, you should just run the service.)

If you are creating a standalone deployment, you can create a similar cron job to run puppet apply instead of puppet agent:

    $ sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/usr/bin/puppet apply $(puppet apply --configprint manifest)'


### Sign the New Node's Certificate

In an agent/master deployment, an admin must approve a certificate request for each agent node before that node can fetch configurations. Agent nodes will request certificates the first time they attempt to run.

* Periodically log into the CA puppet master server and run `sudo puppet cert list` to view outstanding requests.
* Run `sudo puppet cert sign <NAME>` to sign a request, or `sudo puppet cert sign --all` to sign all pending requests.

An agent node whose request has been signed on the master will run normally on its next attempt.

### Classify the Node

At this point, the new agent node will fetch and apply configurations from the puppet master server. It's up to you to make sure the configurations it fetches will actually do something. You can do this by assigning [Puppet classes][] to the node.

Classes are made available by Puppet modules; you'll need to [install some on the puppet master][install_modules] or [write your own][modules_fundamentals]. Once you have classes available, you can:

* Use [node definitions][] in the [main manifest][manifest] to determine which nodes receive which classes.
* Use an [external node classifier][] to assign classes to nodes.
* Use [Hiera][] to classify your nodes via [the `hiera_include` function][hiera_include].

