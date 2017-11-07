---
layout: default
title: "Puppet 3.x to 4.x Server Upgrades"
canonical: "./upgrade_server.html"
---

This guide is for sites which have all master-related functions (puppetmaster, certificate authority, file server) on one 
system. 

## Overview

The steps to start serving a Puppet 4 server are:

1. Install the puppet-agent-1.0 and puppetserver-2.0 packages for your operating system.
1. Copy your certificate authority files to the new filesystem location (`/etc/puppetlabs/puppet/ssl`)
2. Migrate your code (modules + manifests + hiera) to the new location and directory structure (`/etc/puppetlabs/code`) 
   and prepare the server for Directory Environments.
3. Transfer any custom settings that were in your previous puppet.conf to `/etc/puppetlabs/puppet/puppet.conf`; do not 
   simply copy the file in-place as many older settings are removed or their defaults have changed.
4. Start running your puppetmaster under Puppet Server 2.0 (if you were previously using Apache)

While it is possible to do an in-place upgrade over a running Puppet 3.x server, we recommend that you set up a new VM 
or physical system to start fresh, and migrate only those pieces of data which are required to ensure continuity of your 
infrastructure such as modules and certificates. That way, your existing Puppet masters continue to run as-is and 
rollback becomes much simpler.

## Install packages

This is simply a matter of following the [Linux installation guide](install_linux.html) for Puppet 4: add the release
package, then install the puppetserver package (which will automatically add the puppet-agent as well)

## Set up SSL

On the 3.x master installation, find the SSL directory tree and copy it into the new location: 
`/etc/puppetlabs/puppet/ssl`. We recommend using `rsync -a` if you're setting up a new master server, as this will 
preserve the permissions on the files, which SSL is picky about.

If this is a new host, you'll also need to generate a certificate for it, so that it will be able to answer requests 
from agents. Once the puppet-agent package is installed and the CA files are in place, run

    /opt/puppetlabs/bin/puppet cert generate --dns_alt_names=puppet,puppet.mydomain myhostname.mydomain

## Migrate code

One of the big changes in Puppet 4 is its standardization on Directory Environments. There's an in-depth document
on [configuration settings for directory 
environments](/puppet/latest/environments_configuring.html#global-settings-for-configuring-environments) but 
the defaults have been adjusted for Puppet 4 so very little configuration should be necessary for most people. Out of 
the box, the puppet-agent's directory structure will look like this:

    /etc/puppetlabs/code
    ├── environments
    │   └── production
    │       ├── environment.conf
    │       ├── manifests
    │       └── modules
    ├── hieradata
    ├── hiera.yaml
    └── modules

For r10k users, this should look pretty familiar as the `code` directory is usually the control repo which contains your Puppetfile, and every `environments/_something_` directory is a branch into which `r10k deploy` will install the appropriate versions of your modules.

If you're not using r10k, or not using environments at all, you can simply put your `site.pp` and other top-level manifests inside `/etc/puppetlabs/code/environments/production/manifests`, and they'll be automatically loaded (Note that the `import` directive is gone in Puppet 4!). Your modules go under `/etc/puppetlabs/code/environments/production/modules`, because `production` is the name of the default environment if no other environment is specified.

## Transfer custom settings

The default settings written into the newer, slimmer puppet.conf should work pretty well for most people. If your old puppet.conf had settings related to environments (especially static "config file environments" that use the `[environmentname]` stanzas in puppet.conf, these will either become global (such as adjusting `basemodulepath` [as described here](/puppet/latest/environments_configuring.html#basemodulepath]) or move into an environment-specific config file, [documented in the environment.conf section](/puppet/3.7/environments_creating.html#the-environmentconf-file). 

Read through the [Puppet 4 Release Notes](release_notes.html) for more detail on other settings which were removed or whose defaults may have changed.

## Start running the Puppet Server

There are great instructions in the Puppet Server documentation for getting started with it, but the important thing to note for upgraders is that it won't automatically start up on system boot; you'll need to enable it. Similar to the Puppet agent, you can use a `puppet resource` one-liner to do this regardless of the OS flavor you're running:

    /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true

Watch the logfile in `/var/log/puppetlabs/puppetserver/puppetserver.log` to make sure your agents can check in successfully and you should be good to go.
