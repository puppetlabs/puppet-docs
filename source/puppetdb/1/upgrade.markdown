---
title: "PuppetDB 1 » Upgrading PuppetDB"
layout: default
canonical: "/puppetdb/latest/upgrade.html"
---


[dashboard]: ./maintain_and_tune.html#monitor-the-performance-dashboard
[connect_master]: ./connect_puppet_master.html
[connect_apply]: ./connect_puppet_apply.html
[jira]: https://tickets.puppetlabs.com/browse/PDB-16?jql=project%20%3D%20PDB%20AND%20resolution%20%3D%20Unresolved%20ORDER%20BY%20priority%20DESC
[start_source]: ./install_from_source.html#step-6-start-the-puppetdb-service
[plugin_source]: ./connect_puppet_master.html#on-platforms-without-packages


Checking for Updates
-----

PuppetDB's [performance dashboard][dashboard] displays the current version in the upper right corner. It also automatically checks for updates and will show a link to the newest version under the version indicator if your deployment is out of date. 

What to Upgrade
-----

When a new version of PuppetDB is released, you will need to upgrade:

1. PuppetDB itself
2. The [terminus plugins][connect_master] on every puppet master (or [every node][connect_apply], if using a standalone deployment)

You should **upgrade PuppetDB first.** Since PuppetDB will be down for a few minutes during the upgrade and puppet masters will not be able to serve catalogs until it comes back, you should schedule upgrades during a maintenance window during which no new nodes will be brought on line. 

If you upgrade PuppetDB without upgrading the terminus plugins, your Puppet deployment should continue to function identically, with no loss of functionality. However, you may not be able to take advantage of new PuppetDB features until you upgrade the terminus plugins. 

Upgrading PuppetDB
-----

**On your PuppetDB server:** stop the PuppetDB service, upgrade the PuppetDB package, then restart the PuppetDB service. 

### For PE Users

    $ sudo puppet resource service pe-puppetdb ensure=stopped
    $ sudo puppet resource package pe-puppetdb ensure=latest
    $ sudo puppet resource service pe-puppetdb ensure=running

### For Open Source Users

    $ sudo puppet resource service puppetdb ensure=stopped
    $ sudo puppet resource package puppetdb ensure=latest
    $ sudo puppet resource service puppetdb ensure=running

### On Platforms Without Packages

If you installed PuppetDB by running `rake install`, you should obtain a fresh copy of the source, stop the service, and run `rake install` again. Note that this workflow is not well tested; if you run into problems, please report them on the [PuppetDB issue tracker][jira].

If you are running PuppetDB from source, you should stop the service, replace the source, and [start the service as described in the advanced installation guide][start_source].

Upgrading the Terminus Plugins
-----

**On your puppet master servers:** upgrade the PuppetDB terminus plugins package, then restart the puppet master's web server: 

### For PE Users

    $ sudo puppet resource package pe-puppetdb-terminus ensure=latest
    $ sudo puppet resource service pe-httpd ensure=stopped
    $ sudo puppet resource service pe-httpd ensure=running

### For Open Source Users

    $ sudo puppet resource package puppetdb-terminus ensure=latest

The command to restart the puppet master will vary depending on which web server you are using. 

### On Platforms Without Packages

Obtain a fresh copy of the PuppetDB source, and follow [the instructions for installing the terminus plugins][plugin_source]. 

The command to restart the puppet master will vary depending on which web server you are using. 
