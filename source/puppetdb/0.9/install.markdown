---
title: "PuppetDB 0.9 » Installing PuppetDB"
layout: default
canonical: "/puppetdb/latest/install_via_module.html"
---


[keystore_instructions]: ./install_from_source.html#step-3-option-b-manually-create-a-keystore-and-truststore
[ssl_script]: ./install_from_source.html#step-3-option-a-run-the-ssl-configuration-script
[configure_postgres]: ./configure.html#postgresql-db-settings
[configure_heap]: ./configure.html#configuring-the-java-heap-size
[puppetdb_conf]: ./configure.html
[configure_jetty]: ./configure.html#jetty-http

Before installing, [review the PuppetDB system requirements](./requirements.html).

These package-based install instructions cover the [supported versions](./requirements.html#easy-install-requirements) of enterprise Linux, Debian, Ubuntu, and Fedora. To install on other systems, you should instead see [Installing from Source](./install_from_source.html).

Step 1: Install and Configure Puppet
-----

Your PuppetDB server should be running puppet agent and have a signed certificate from your puppet master server. If you run `puppet agent --test`, it should successfully complete a run, ending with "`notice: Finished catalog run in X.XX seconds`."

If Puppet isn't fully configured yet, install it and request/sign/retrieve a certificate for the node:

* [Instructions for Puppet Enterprise][installpe]
* [Instructions for open source Puppet][installpuppet]

[installpuppet]: puppet/latest/reference/install_pre.html
[installpe]: /pe/latest/install_basic.html

> Note: If Puppet doesn't have a valid certificate when PuppetDB is installed, you will have to [run the SSL config script and edit the config file][ssl_script], or [manually configure PuppetDB's SSL credentials][keystore_instructions] before the puppet master will be able to connect to PuppetDB.

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


Step 4: Configure Database
-----

If this is a production deployment, you should confirm and configure your database settings:

- Deployments of **100 nodes or fewer** can continue to use the default built-in database backend, but should [increase PuppetDB's maximum heap size][configure_heap] to at least 1 GB.
- Large deployments should [set up a PostgreSQL server and configure PuppetDB to use it][configure_postgres]. You may also need to [adjust the maximum heap size][configure_heap].

You can change PuppetDB's database at any time, but note that changing the database does not migrate PuppetDB's data, and the new database will be empty. However, as this data is automatically generated many times a day, PuppetDB should recover in a relatively short period of time.

Step 5: Start the PuppetDB Service
-----

Use Puppet to start the PuppetDB service and enable it on startup.

### For PE Users

    $ sudo puppet resource service pe-puppetdb ensure=running enable=true

### For Open Source Users

    $ sudo puppet resource service puppetdb ensure=running enable=true

You must also configure your PuppetDB server's firewall to accept incoming connections on port 8081.

> PuppetDB is now fully functional and ready to receive catalogs and facts from any number of puppet master servers.


Finish: Connect Puppet to PuppetDB
-----

[You should now configure your puppet master(s) to connect to PuppetDB](./connect_puppet.html).

Troubleshooting Installation Problems
-----

* Check the log file, and see whether PuppetDB knows what the problem is. This file will be either `/var/log/puppetdb/puppetdb.log` or `/var/log/pe-puppetdb/pe-puppetdb.log`.
* If PuppetDB is running but the puppet master can't reach it, check [PuppetDB's jetty configuration][configure_jetty] to see which port(s) it is listening on, then attempt to reach it by telnet (`telnet <host> <port>`) from the puppet master server. If you can't connect, the firewall may be blocking connections. If you can, Puppet may be attempting to use the wrong port, or PuppetDB's keystore may be misconfigured (see below).
* Check whether any other service is using PuppetDB's port and interfering with traffic.
* Check [PuppetDB's jetty configuration][configure_jetty] and the `/etc/puppetdb/ssl` (or `/etc/pe-puppetdb/ssl`) directory, and make sure it has a truststore and keystore configured. If it didn't create these during installation, you will need to [run the SSL config script and edit the config file][ssl_script] or [manually configure a truststore and keystore][keystore_instructions] before a puppet master can contact PuppetDB.

