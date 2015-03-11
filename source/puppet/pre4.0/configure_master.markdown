---
layout: default
title: "Installing Puppet: Post-Install: Configure Puppet Server"
---

[peinstall]: /pe/latest/install_basic.html
[hiera_include]: /hiera/latest/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
[hiera]: /hiera/latest/
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[dns_alt_names]: /references/latest/configuration.html#dnsaltnames
[about_settings]: /puppet/latest/reference/config_about_settings.html
[manifest]: /puppet/latest/reference/dirs_manifest.html
[install_modules]: /puppet/latest/reference/modules_installing.html
[directory environments]: /puppet/latest/reference/environments.html
[modulepath]: /puppet/latest/reference/dirs_modulepath.html
[rack]: http://rack.github.io/
[multi_masters]: /guides/scaling_multiple_masters.html
[puppet classes]: /puppet/latest/reference/lang_classes.html
[modules_fundamentals]: /puppet/latest/reference/modules_fundamentals.html
[node definitions]: /puppet/latest/reference/lang_node_definitions.html
[external node classifier]: /guides/external_nodes.html
[ssldir]: /puppet/latest/reference/dirs_ssldir.html

> **Note:** This is for a pre-release version.


Perform the following tasks after you finish installing Puppet. You should have already done the [pre-install tasks](./pre_install.html) and followed the installation instructions for your OS.


After installing Puppet Server on a node, you should:

* Configure DNS alt names
* Configure other settings in `puppet.conf`
* Configure Java heap size for Puppet Server
* Configure settings in `/etc/puppetlabs/puppetserver/conf.d`
* Deploy your modules and manifests to environments on the server
* Configure load balancing and CA service routing if you're using multiple masters
* Start Puppet Server

## Configure DNS alt names

Before you start Puppet Server for the first time, check /etc/puppetlabs/puppet/puppet.conf and make sure the `certname` and `dns_alt_names` settings are what you want them to be. These settings control the DNS names at which agent nodes might try to contact the server.

Decide on a main name for Puppet services at your site, and make sure your DNS resolves it to the puppet master (or its load balancer). Unconfigured agents will try to find a master at `puppet`, so if you use this name it can reduce setup time.

In the `[main]` section of the master's [puppet.conf][] file, set [the `dns_alt_names` setting][dns_alt_names] to a comma-separated list of each hostname the master should be allowed to use:

    dns_alt_names = puppet,puppet.example.com,puppetmaster01,puppetmaster01.example.com

When you start Puppet Server for the first time, it will automatically create a certificate with the correct names.

### If You Already Started Puppet Server

If the master's certificate doesn't have the DNS names it needs to authenticate itself to agents, you'll need to stop the `puppetserver` service, run `puppet cert clean <NAME>`, make sure puppet.conf is configured correctly, then restart `puppetserver`.

If this server node isn't acting as a CA, you will have to stop `puppetserver`, edit puppet.conf, then run  `puppet agent --test --ca_server=<SERVER>` to request a certificate. On the CA server, run `puppet cert list` and `puppet cert --allow-dns-alt-names sign <NAME>` to sign the certificate. On the new master, run `puppet agent --test --ca_server=<SERVER>` again to retrieve the cert.


## Configure Other Settings

You might want to set a few settings in [puppet.conf][] before putting the new master to work. See [the list of master-related settings][master_settings] for details. You may also want to read about [how Puppet loads settings][about_settings] and [the syntax of the puppet.conf file][puppet.conf].

TODO delete a bunch of this stuff from the puppet 4 docs! Most of these master settings are no longer needed!


[master_settings]: /puppet/latest/reference/config_important_settings.html#settings-for-puppet-master-servers

## Configure Java heap size for Puppet Server

Defaults to 2GB, which might be too much for a small testing machine.

It's in /etc/sysconfig/puppetserver. More info here:

/puppetserver/latest/install_from_packages.html#memory-allocation

## Configure settings in `/etc/puppetlabs/puppetserver/conf.d`

link to /puppetserver/latest/configuration.html

one of the main ones: certificate whitelist for the puppet-admin API, if you want to trigger environment refreshes after deploying code.  /puppetserver/latest/configuration.html#puppetserverconf

## Deploy Your Modules and Manifests to Environments on the Server

If you already have a set of modules and a main manifest you use in your deployment, put them into place now. You will probably be checking them out with version control.

Puppet 4 always has directory environments turned on, so your default place to put your modules and your main manifest is now `/etc/puppetlabs/code/environments/production/`. This directory was created when you installed the puppet-agent package.

If you're using something like r10k to manage and deploy your puppet code, make sure you've changed the deployment target to match the new directory structure.

TODO link to the "where'd all my stuff go" page.

Relevant reference pages:

* [Directory environments][]
* [The main manifest][manifest]
* [The modulepath][modulepath]


## Configure Load Balancing and CA Service Routing

If you're using multiple masters, you'll need to make sure traffic is being directed properly.

TODO: Right now, we're not providing docs for this. delete section i guess?

## Start the Puppet Master Service

Run `sudo service puppetserver start`.

