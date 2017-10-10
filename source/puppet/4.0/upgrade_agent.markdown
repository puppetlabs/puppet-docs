---
layout: default
title: "Puppet 3.x to 4.x Agent Upgrades"
canonical: "/puppet/latest/upgrade_agent.html"
---

This guide will help you update your Puppet 3.x agents to Puppet 4.0.

## Linux Hosts

If you have currently running Puppet agents that you want to update to Puppet 4, make sure you have followed the [server 
upgrade instructions](server_upgrade.markdown) on at least one host so the agents will have a Puppet 4 server to talk to.

* Install the `puppetlabs-release-pc1` package for your OS, per the regular install instructions.
* Make a note of the current `ssldir` location by running (as root) `puppet agent --configprint ssldir`; you'll need   this to avoid re-issuing certificates.
* Disable the previous `products` and `devel` repositories
* Using your package manager, install the `puppet-agent` package for your operating system.
* Modify the new, Puppet 4-compatible `/etc/puppetlabs/puppet/puppet.conf` file to include any local customizations from 
  the old `/etc/puppet/puppet.conf` configuration file, taking note of the [deprecated and changed 
  settings](release_notes.html#break-changed-defaults-for-settings) which should not be copied over (notably, if you previously set 
  `stringify_facts=false`, this is no longer necessary).  You will need to set the `server` (and `ca_server`, if you've 
  set up a separate Puppet 4 CA) setting to point at the hostname of your new Puppet 4 master.
* Copy your SSL certificate tree from its previous location (from `puppet agent --configprint ssldir` above) to its new 
  AIO path: `/etc/puppetlabs/puppet/ssl`, making sure to preserve permissions and ownership. For example:

    `cp -rp /var/lib/puppet/ssl /etc/puppetlabs/puppet/ssl`

* Run the agent manually and make sure it correctly talks to the server:

    `/opt/puppetlabs/bin/puppet agent -tv`

* Ensure that Puppet will continue to run automatically. If you used a cron job to periodically run `puppet agent -t`, 
  make sure you update the path to the binary; if you run puppet as a daemon, ensure it's set to start up on system boot.  
  Here's a handy `puppet resource` command to do just that:

    `/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`

## Windows Hosts

The filesystem paths for configuration and certificates did not change from Puppet 3.x, so the only things Windows upgraders need to look out for are individual settings which may be deprecated or whose defaults have changed. 
