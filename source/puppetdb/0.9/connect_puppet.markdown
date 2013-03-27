---
title: "PuppetDB 0.9 » Connecting Puppet to PuppetDB"
layout: default
canonical: "/puppetdb/latest/connect_puppet_master.html"
---

[puppetdb_download]: http://downloads.puppetlabs.com/puppetdb
[puppetdb_conf]: /guides/configuring.html#puppetdbconf
[routes_yaml]: /guides/configuring.html#routesyaml

> Note: Your site's puppet master(s) must be running Puppet 2.7.12 or later to use PuppetDB.

After PuppetDB is installed and running, you should configure your puppet master(s) to use it. A properly configured puppet master will do the following: 

* Send every node's catalog to PuppetDB
* Send every node's facts to PuppetDB 
* Query PuppetDB when compiling node catalogs that collect [exported resources](/guides/exported_resources.html)
* Query PuppetDB when responding to [inventory service](/guides/inventory_service.html) requests

Follow all of the instructions below **on your puppet master server(s).**

## Step 1: Install Plugins

Currently, puppet masters need extra Ruby plugins in order to use PuppetDB. Unlike custom facts or functions, these cannot be loaded from a module, and must be installed in Puppet's main source directory. 

### For PE Users

* [Enable the Puppet Labs repo](/guides/puppetlabs_package_repositories.html#puppet-enterprise-repositories).
* Install the `pe-puppetdb-terminus` package. 
    * On Debian and Ubuntu: run `sudo apt-get install pe-puppetdb-terminus`
    * On EL or Fedora: run `sudo yum install pe-puppetdb-terminus`


### For Open Source Users

* [Enable the Puppet Labs repo](/guides/puppetlabs_package_repositories.html#open-source-repositories).
* Install the `puppetdb-terminus` package. 
    * On Debian and Ubuntu: run `sudo apt-get install puppetdb-terminus`
    * On EL or Fedora: run `sudo yum install puppetdb-terminus`

### On Platforms Without Packages

If your puppet master isn't running Puppet from a supported package, you will need to install the plugins manually:

* [Download the PuppetDB source code][puppetdb_download]; unzip it, and navigate into the resulting directory in your terminal.
* Run `sudo cp -R puppet/lib/puppet /usr/lib/ruby/site_ruby/1.8/puppet` --- replace the second path with the path to your Puppet installation if you have installed it somewhere other than `/usr/lib/ruby/site_ruby`.

## Step 2: Edit Config Files

### Locate Puppet's Config Directory

Find your puppet master's config directory by running `sudo puppet config print confdir`. It will usually be at either `/etc/puppet/` or `/etc/puppetlabs/puppet/`. 

You will need to edit (or create) three files in this directory:

### Edit puppetdb.conf

The [puppetdb.conf][puppetdb_conf] file will probably not exist yet. Create it, and edit it to contain the PuppetDB server's hostname and port:

    [main]
    server = puppetdb.example.com
    port = 8081

* PuppetDB's port for secure traffic defaults to 8081.
* PuppetDB's port for insecure traffic defaults to 8080, but doesn't accept connections by default. 

If no puppetdb.conf file exists, the following default values will be used:

    server = puppetdb
    port = 8081

### Edit puppet.conf

To enable PuppetDB for the inventory service and saved catalogs/exported resources, add the following settings to the `[master]` block of puppet.conf (or edit them if already present):

    [master]
      storeconfigs = true
      storeconfigs_backend = puppetdb

> Note: If you previously set the `thin_storeconfigs` or `async_storeconfigs` settings to `true`, you should delete them at this time. The old queuing mechanism will interfere with performance, and thinned catalogs are no longer necessary. Likewise, if you previously used the puppet queue/puppetqd daemon, you should now disable it. 

### Edit routes.yaml

The [routes.yaml][routes_yaml] file will probably not exist yet. Create it if necessary, and edit it to contain the following: 

    ---
    master:
      facts:
        terminus: puppetdb
        cache: yaml

This is necessary for making PuppetDB the authoritative source for the inventory service.

## Step 3: Restart Puppet Master

Use your system's service tools to restart the puppet master service. For open source users, the command to do this will vary depending on the front-end web server being used. For Puppet Enterprise users, run:

    $ sudo /etc/init.d/pe-httpd restart

> Your puppet master should now be using PuppetDB to store and retrieve catalogs, facts, and exported resources. You can test this by triggering a puppet agent run on an arbitrary node, then logging into your PuppetDB server and viewing the `/var/log/puppetdb/puppetdb.log` or `/var/log/pe-puppetdb/pe-puppetdb.log` file --- you should see calls to the "replace facts" and "replace catalog" commands:
>
>     2012-05-17 13:08:41,664 INFO  [command-proc-67] [puppetdb.command] [85beb105-5f4a-4257-a5ed-cdf0d07aa1a5] [replace facts] screech.example.com
>     2012-05-17 13:08:45,993 INFO  [command-proc-67] [puppetdb.command] [3a910863-6b33-4717-95d2-39edf92c8610] [replace catalog] screech.example.com
