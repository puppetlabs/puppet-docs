---
title: "PuppetDB 0.9 » Installing and Connecting"
layout: pe2experimental
nav: puppetdb0.9.html
---


[keystore_instructions]: ./install_from_source.html#manual-ssl-setup
[configure_postgres]: TODO
[configure_heap]: TODO
[puppetdb_conf]: TODO

Before installing on a production server, [review the PuppetDB system requirements](./requirements.html).

These instructions cover the following operating systems:

* Red Hat Enterprise Linux 5 and 6
* Linux distros derived from RHEL 5 and 6, including but not limited to CentOS, Scientific Linux, and Ascendos.
* Debian Squeeze, Lenny, Wheezy, and Sid
* Ubuntu's 8.04, 10.04, and 12.04 LTS releases, as well as 11.10 "Oneiric Ocelot" and 11.04 "Natty Narwhal"
* Fedora 15 and 16

Users on these systems can use Puppet Labs' official PuppetDB packages. To install on other systems, you should instead follow [the instructions to install from source](./install_from_source.html).

Step 1: Install and Configure Puppet
-----

Your PuppetDB server should be running puppet agent and have a signed certificate from your puppet master server. If you run `puppet agent --test`, it should successfully complete a run, ending with "`notice: Finished catalog run in X.XX seconds`."

If Puppet isn't fully configured yet, install it and request/sign/retrieve a certificate for the node:

* [Instructions for Puppet Enterprise][installpe]
* [Instructions for open source Puppet][installpuppet]

[installpuppet]: /guides/installation.html
[installpe]: /pe/2.5/install_basic.html

> Note: If Puppet doesn't have a valid certificate when PuppetDB is installed, you will have to [perform extra configuration steps][keystore_instructions] before the puppet master will be able to connect to PuppetDB.

Step 2: Enable the Puppet Labs Package Repository
-----

If you didn't already use it to install Puppet, you will need to enable the Puppet Labs package repository for your system. Follow the instructions linked below, then continue with step 3 of this guide:

- [Instructions for PE users](/guides/puppetlabs_package_repositories.html#puppet-enterprise-repositories)
- [Instructions for open source users](/guides/puppetlabs_package_repositories.html#open-source-repositories)


Step 3: Install PuppetDB
-----

### For PE Users

**On EL systems, run:**

    $ sudo yum install pe-puppetdb

**On Debian and Ubuntu systems, run:**

    $ sudo apt-get install pe-puppetdb

### For Open Source Users

**On EL and Fedora systems, run:**

    $ sudo yum install puppetdb

**On Debian and Ubuntu systems, run:**

    $ sudo apt-get install puppetdb


Step 4: Start the PuppetDB Service
-----

Use Puppet to start the PuppetDB service and enable it on startup. 

### For PE Users

    $ sudo puppet resource service pe-puppetdb ensure=running enable=true

### For Open Source Users

    $ sudo puppet resource service puppetdb ensure=running enable=true

You must also configure your PuppetDB server's firewall to accept incoming connections on port 8081.

> PuppetDB is now fully functional and ready to receive catalogs and facts from a puppet master server.

Step 5: Connect the Puppet Master to PuppetDB
-----

Follow all of the instructions in this step **on your puppet master server(s).**

> Note: Your site's puppet master(s) must be running Puppet 2.7.12 or later.

### Install Plugins

Your puppet master needs extra Ruby plugins in order to use PuppetDB. Unlike custom facts or functions, these cannot be loaded from a module, and must be installed in Puppet's main source directory. 

#### For PE Users

* [Enable the Puppet Labs repo](/guides/puppetlabs_package_repositories.html#puppet-enterprise-repositories)
* Install the `pe-puppetdb-terminus` package. 
    * On Debian and Ubuntu: run `sudo apt-get install pe-puppetdb-terminus`
    * On EL or Fedora: run `sudo yum install pe-puppetdb-terminus`


#### For Open Source Users

* [Enable the Puppet Labs repo](/guides/puppetlabs_package_repositories.html#open-source-repositories).
* Install the `puppetdb-terminus` package. 
    * On Debian and Ubuntu: run `sudo apt-get install puppetdb-terminus`
    * On EL or Fedora: run `sudo yum install puppetdb-terminus`


### Locate Puppet's Configuration Directory

Find your puppet master's config directory by running `sudo puppet config print confdir`. It will usually be at either `/etc/puppet/` or `/etc/puppetlabs/puppet/`. 

You will need to edit or create three files in this directory:

### Edit puppetdb.conf

The [puppetdb.conf][puppetdb_conf] file will probably not exist yet. Create it, and edit it to contain the PuppetDB server's hostname and port:

    [main]
    server = puppetdb.example.com
    port = 8081

* PuppetDB's port for secure traffic defaults to 8081.
* PuppetDB's port for insecure traffic defaults to 8080, but doesn't accept connections by default. 

If no puppetdb.conf file exists, the following default values will be used:

    server = puppetdb
    port = 8080

### Edit puppet.conf

To enable PuppetDB for the inventory service and saved catalogs/exported resources, create or edit the following settings in the `[master]` block of puppet.conf:

    [master]
      ...
      storeconfigs = true
      storeconfigs_backend = puppetdb

> Note: If you previously set the `thin_storeconfigs` or `async_storeconfigs` settings to `true`, you should delete them at this time. The old queuing mechanism will interfere with performance, and thinned catalogs are no longer necessary. Likewise, if you previously used the puppet queue/puppetqd daemon, you should now disable it. 

### Edit routes.yaml

The routes.yaml file will probably not exist yet. Create it if necessary, and edit it to contain the following: 

    ---
    master:
      facts:
        terminus: puppetdb
        cache: yaml

This is necessary for making PuppetDB the authoritative source for the inventory service.

### Restart Puppet Master

Use your system's service tools to restart the puppet master service. For open source users, the command to do this will vary depending on the front-end web server being used. For Puppet Enterprise users, run:

    $ sudo /etc/init.d/pe-httpd restart

Finish
-----

PuppetDB is now fully functional and connected to your puppet master. You can use exported resources and the inventory service.

- If this is a production deployment, do a little additional configuration:
    - Small deployments can continue to use the built-in database backend, but should [increase PuppetDB's maximum heap size][configure_heap] to 1 GB.
    - Large deployments should [set up a PostgreSQL server and configure PuppetDB to use it][configure_postgres]. You may also need to [adjust the maximum heap size][configure_heap]. 
- [Read the chapter on maintaining PuppetDB](./maintain_and_tune.html). It covers monitoring PuppetDB's performance and removing decommissioned nodes from the database. 


Troubleshooting Installation Problems
-----

* Check the log file, and see whether the problem is being clearly reported. This file will be either `/var/log/puppetdb/puppetdb.log` or `/var/log/pe-puppetdb/pe-puppetdb.log`. 
* If PuppetDB is running but the puppet master can't reach it, check [PuppetDB's jetty configuration][puppetdb_conf] to see which port(s) it is listening on, then attempt to reach it by telnet (`telnet <host> <port>`) from the puppet master server. If you can't connect, the firewall may be blocking connections. If you can, Puppet may be attempting to use the wrong port, or PuppetDB's keystore may be misconfigured (see below). 
* Check whether any other service is using PuppetDB's port and interfering with traffic. 
* Check [PuppetDB's jetty configuration][puppetdb_conf] and the `/etc/puppetdb/ssl` (or `/etc/pe-puppetdb/ssl`) directory, and make sure it has a truststore and keystore configured. If it didn't create these during installation, you will need to [manually configure a truststore and keystore][keystore_instructions].

