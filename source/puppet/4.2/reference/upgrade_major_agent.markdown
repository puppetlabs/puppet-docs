---
layout: default
title: "Puppet 3.x to 4.x Agent Upgrades"
canonical: "/puppet/latest/reference/upgrade_major_agent.html"
---


(intro: because a lot changed from Puppet 3 to 4, upgrading agents involves a lot of steps, including moving configuration and credentials for Puppet and MCollective.

However, since puppet agent gets most of what it needs from Puppet Server instead of from local state, it's much easier to automate the upgrade.)



## Decide How to Upgrade Your Nodes

We provide [a module called `puppet_agent`](https://forge.puppetlabs.com/puppetlabs/puppet_agent) to help with Puppet 3.x to 4.x upgrades.

If you're running Puppet on:

* Windows
* The Linux versions we ship official packages for

...then you can use this module to automatically upgrade Puppet, MCollective, and all of their dependencies on agent nodes.

If you're running Puppet on other operating systems, you can't upgrade them with the module; you'll need to either upgrade your agent nodes manually, or build your own automation to handle everything. We go over the steps below.

## Upgrade With the `puppet_agent` Module

(Again, this only works with some operating systems.)

(The module does a bunch of stuff automatically:

- enables the Puppet Collection 1 (PC1) repo, if applicable.
- Installs the latest version of the puppet-agent package (which will replace the current versions of Puppet and MCollective).
- Copies Puppet's SSL files to their new location.
- Migrates puppet.conf: copies your old one to the new location, but then cleans out old settings that either got removed in Puppet 4 or need to revert to their default values.
- Migrates your MCollective server and client config files: copies them to their new locations, and adds the new plugin path to the `libdir` setting.
- Makes sure the Puppet and MCollective services are running.

It's completely inert on any nodes that have already been upgraded to Puppet 4.x. The only purpose of the current version of this module is to get across the 3.x to 4.x chasm.
)

### Install the Module on Puppet Servers

If you manage your Puppet code manually, you can use `puppet module install puppetlabs/puppet_agent --environment <ENVIRONMENT>` to install it. If you manage your code with r10k, add the module (and its dependencies) to your Puppetfile. If you manage your code some other way, do whatever you need to do.

### Assign the `puppet_agent` Class to Nodes

(Using whatever you use to assign classes to nodes. the main manifest (link), your ENC, whatever.

You can customize it a bit, to control which services to start or to force a different architecture on Windows. See the README (link) for more info.

Like with any major new configuration, you'll want to control the roll-out. First you should assign it in your dev or test environment, to make sure it works as expected on machines that look like your production machines.)



## Upgrade Manually or Build Your Own Automation

(Here are the steps to upgrade an agent if you don't use the module. Either do them manually, or build some automation that supports the nodes in your deployment. )


### Install the New Version of Puppet

Follow the installation instructions (link) to install the newest version of Puppet.

### Migrate SSL Files (Skip on Windows)

(On \*nix systems, the `ssldir` (link to page about ssldir) changed. Locate the old ssldir, and copy its entire contents to `/etc/puppetlabs/puppet/ssl`, making sure to preserve the permissions. For example:

    `cp -rp /var/lib/puppet/ssl /etc/puppetlabs/puppet/ssl`

The default location of the old ssldir is `/etc/puppet/ssl`, but it might also be at `/var/lib/puppet/ssl` --- check your `/etc/puppet/puppet.conf` file to see whether the `ssldir` setting was set to a non-default value.

### Reconcile puppet.conf

On \*nix systems, the location of puppet.conf (link to page about puppet.conf) has changed, from `/etc/puppet/puppet.conf` to `/etc/puppetlabs/puppet/puppet.conf`. You'll need to edit it or copy your old config file into place.

On Windows, the config file location stayed the same.

In either case, examine the config file. Make sure:

* It includes any modified settings you care about.
* It excludes any settings that were [removed in Puppet 4.0](/puppet/3.8/reference/deprecated_settings.html). Notably, if you previously set `stringify_facts=false`, this is no longer necessary.

### Start Service or Update Cron Job

Ensure that Puppet will continue to run automatically.

If you run puppet as a service, ensure it's set to start up on system boot using `puppet resource`:

    /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

(On Windows, you can use the same command but omit the `/opt/puppetlabs/bin/` prefix.)

If you use a cron job to periodically run `puppet agent -t` on your \*nix systems, edit the job and update the path to the `puppet` binary --- it's now at `/opt/puppetlabs/bin/puppet`.


### Reconcile MCollective Config Files (Skip on Windows)

If you use MCollective on \*nix systems, the config files have moved from the `/etc/mcollective` directory to `/etc/puppetlabs/mcollective`.

You'll need to edit the new config files and make sure they have any settings you need from the old files. Note that the default plugin and lib directories have also changed; you should make sure those settings contain both the new directory and any other directories you wish to use.

