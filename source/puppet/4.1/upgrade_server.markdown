---
layout: default
title: "Puppet 3.x to 4.x Server Upgrades"
canonical: "/puppet/latest/upgrade_server.html"
---

This guide is for sites that have all master-related functions (Puppet master, certificate authority, file server) on one system.

## Overview

The steps to start serving a Puppet 4 server are:

1. Install the `puppet-agent` and `puppetserver` packages for your operating system.
1. Copy your certificate authority files to the new filesystem location (`/etc/puppetlabs/puppet/ssl`)
2. Migrate your code (modules + manifests + hiera) to the new location and directory structure (`/etc/puppetlabs/code`) and prepare the server for Directory Environments.
3. Transfer any custom settings that were in your previous puppet.conf to `/etc/puppetlabs/puppet/puppet.conf`. **Note:** Do not copy the file in-place. Many older settings are removed or their defaults have changed.
4. If you were previously using Apache: start running your Puppet master under Puppet Server 2.0.

We recommend that you set up a new VM or physical system to start fresh. Migrate only those pieces of data that are required to ensure continuity of your infrastructure such as modules and certificates. Your existing Puppet masters will continue to run as-is. Rollback will be much simpler than doing an in-place upgrade over a running Puppet 3.x server.

## Install Packages

Follow the [Linux installation guide](install_linux.html) for Puppet 4. Add the release package, then install the `puppetserver` package (which will automatically add the `puppet-agent` package as well.)

## Set up SSL

On the 3.x master installation, find the SSL directory tree and copy it into the new location:
`/etc/puppetlabs/puppet/ssl`. We recommend using `rsync -a` if you're setting up a new master server. SSL is picky about file permissions; this will preserve the permissions on the files.

If this is a new host, you must generate a certificate for it so that it will be able to answer requests from agents. Once the puppet-agent package is installed and the CA files are in place, run

    /opt/puppetlabs/bin/puppet cert generate --dns_alt_names=puppet,puppet.mydomain myhostname.mydomain

## Migrate Code

Standardization of directory environments is one of the big changes in Puppet 4. Nearly all code belongs in an environment, and directory environments are set up by default.

For more information, see:

* [About Environments](./environments.html)
* [Creating Environments](./environments_creating.html)
* [Configuring Environments](./environments_configuring.html)
* [The Code and Data Directory](./dirs_codedir.html)

Out of the box, Puppet's directory structure will look like this:

    /etc/puppetlabs/code
    ├── environments
    │   └── production
    │       ├── environment.conf
    │       ├── manifests
    │       └── modules
    ├── hieradata
    ├── hiera.yaml
    └── modules

For r10k users, this should look familiar. The `code` directory is usually the control repo that contains your Puppetfile. Every `environments/_something_` directory is a branch into which `r10k deploy` will install the appropriate versions of your modules.

If you're not using r10k, or not using environments at all, put your `site.pp` and other top-level manifests inside `/etc/puppetlabs/code/environments/production/manifests`, and they'll be automatically loaded. Note that the `import` directive is gone in Puppet 4. If no other environment is specified, your modules will go under the default `production` environment: `/etc/puppetlabs/code/environments/production/modules`.

## Transfer Custom Settings

The default settings written into this version of puppet.conf should work for most people. If your old puppet.conf had settings related to environments (especially static "config file environments" that use the `[environmentname]` stanzas in puppet.conf, these will either become global (such as adjusting `basemodulepath` [as described here](./environments_configuring.html#basemodulepath]) or move into an environment-specific config file, [documented in the environment.conf section](./environments_creating.html#the-environmentconf-file).

Read through the [Puppet 4 Release Notes](/puppet/4.0/release_notes.html) for more detail on other settings that were removed or whose defaults may have changed.

## Start Running the Puppet Server

Puppet server won't automatically start up on system boot; you'll need to enable it. You can use `puppet resource` to do this regardless of the OS flavor you're running:

    /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true

Check the logfile in `/var/log/puppetlabs/puppetserver/puppetserver.log` to make sure your agents can check in successfully.
