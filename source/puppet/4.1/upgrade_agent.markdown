---
layout: default
title: "Puppet 3.x to 4.x Agent Upgrades"
canonical: "/puppet/latest/upgrade_agent.html"
---

This guide will help you update your Puppet 3.x agents to Puppet 4.x.

If you have currently running Puppet agents that you want to update to Puppet 4, you must follow the [server upgrade instructions](server_upgrade.markdown) on at least one Puppet server before you update the agents. 

## Linux Hosts

* Install the `puppetlabs-release-pc1` package for your OS, per the regular install instructions.
* Note the current `ssldir` location by running (as root) `puppet agent --configprint ssldir`; you'll need this information to avoid re-issuing certificates.
* Disable the previous Puppet Labs `products` and `devel` repositories.
* Using your package manager, install the `puppet-agent` package for your operating system.
* Modify the new, Puppet 4-compatible `/etc/puppetlabs/puppet/puppet.conf` file to include any local customizations from the old `/etc/puppet/puppet.conf` configuration file. You will need to set the `server` setting (and `ca_server`, if you've set up a separate Puppet 4 CA) to point at the hostname of your new Puppet 4 master. Be sure to check the Puppet 4.0 release notes for [deprecated and changed settings](/puppet/4.0/release_notes.html#break-changed-defaults-for-settings) that should not be copied over. Notably, if you previously set `stringify_facts=false`, this is no longer necessary.  
* Copy your SSL certificate tree from its previous location (from `puppet agent --configprint ssldir` above) to its new path (`/etc/puppetlabs/puppet/ssl`), making sure to preserve permissions and ownership. For example:

    `cp -rp /var/lib/puppet/ssl /etc/puppetlabs/puppet/ssl`

* Run the agent manually and make sure it talks to the server:

    `/opt/puppetlabs/bin/puppet agent -tv`

* Ensure that Puppet will continue to run automatically. If you used a cron job to periodically run `puppet agent -t`, update the path to the binary. If you run puppet as a daemon, ensure it's set to start up on system boot using `puppet resource`:

    `/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`

## Windows Hosts

The filesystem paths for configuration and certificates did not change from Puppet 3.x. Windows upgraders need to check individual settings that [may be deprecated or whose defaults have changed](/puppet/4.0/release_notes.html#break-changed-defaults-for-settings).
