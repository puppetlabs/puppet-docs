---
title: "PuppetDB 0.9 » Installing and Connecting"
layout: pe2experimental
nav: puppetdb0.9.html
---


[keystore_instructions]: TODO
[download_termini]: TODO
[configure_postgres]: TODO
[configure_heap]: TODO
[puppetdb_conf]: TODO

Before installing on a production server, [review the PuppetDB system requirements](./requirements.html).

These instructions cover the following operating systems:

* Red Hat Enterprise Linux 5 and 6
* Linux distros derived from RHEL 5 and 6, including but not limited to CentOS, Scientific Linux, and Ascendos.
* Debian Squeeze, Lenny, Wheezy, and Sid
* Ubuntu (all three current LTS releases, as well as 11.10 "Oneiric Ocelot" and 11.04 "Natty Narwhal")
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

If you didn't already enable it to install Puppet, you will need to enable the Puppet Labs package repository for your system. 

TODO handle the PE-specific repos. 

**On EL 5 systems, run:**

    $ sudo rpm -ivh http://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-1.noarch.rpm

**On EL 6 systems, run:**

    $ sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-1.noarch.rpm

**On Debian and Ubuntu systems, run:**

    $ wget http://apt.puppetlabs.com/puppetlabs-release_1.0-2_all.deb
    $ sudo dpkg -i puppetlabs-release_1.0-2_all.deb

**On Fedora 15 systems, run:**

    $ sudo rpm -ivh http://yum.puppetlabs.com/fedora/f15/products/i386/puppetlabs-release-15-1.noarch.rpm

**On Fedora 16 systems, run:**

    $ sudo rpm -ivh http://yum.puppetlabs.com/fedora/f16/products/i386/puppetlabs-release-16-1.noarch.rpm

Step 3: Install PuppetDB
-----

**On EL and Fedora systems, run:**

    $ sudo yum install puppetdb

**On Debian and Ubuntu systems, run:**

    $ sudo apt-get install puppetdb


Step 4: Start the PuppetDB Service
-----

Use Puppet to start the PuppetDB service and enable it on startup:

    $ sudo puppet resource service puppetdb ensure=running enable=true

PuppetDB is now fully functional and ready to receive catalogs and facts from a puppet master server. 

> Note: You must also configure your PuppetDB server's firewall to accept incoming connections on port 8081.

Step 5: Connect the Puppet Master to PuppetDB
-----

> Note: Your site's puppet master(s) must be running Puppet 2.7.12 or later.

### Install Plugins

Puppet needs extra Ruby plugins in order to use PuppetDB. Unlike custom facts or functions, these cannot be loaded from a module, and must be installed in Puppet's main source directory. 

Puppet Labs provides a package to install these plugins. On your puppet master server, [follow the instructions above for enabling the Puppet Labs repo](#step-2-enable-the-puppet-labs-package-repository) and install the package `puppetdb-terminus`:

    # On Debian and Ubuntu:
    $ sudo apt-get install puppetdb-terminus
    # On EL or Fedora:
    $ sudo yum install puppetdb-terminus

> TODO: Package name or repo might be different for PE, since the package will need to install in a different place. 

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
      facts_terminus = puppetdb

> Note: If you previously set the `thin_storeconfigs` or `async_storeconfigs` settings to `true`, you should delete them at this time. The old queuing mechanism will interfere with performance, and thinned catalogs are no longer necessary. Likewise, if you previously used the puppet queue/puppetqd daemon, you should now disable it. 

### Edit routes.yaml

The routes.yaml file will probably not exist yet. Create it if necessary, and edit it to contain the following: 

    ---
    master:
      facts:
        terminus: puppetdb
        cache: yaml

This is necessary for making PuppetDB the authoritative source of inventory information.

### Restart Puppet Master

Use your system's service tools to restart the puppet master service. The command to do this will vary depending on the front-end web server being used in your deployment. For Puppet Enterprise users, run:

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

TODO

- Firewall
- non-default port? 
- Certs didn't get bundled up? How can we do that after install without having to do the whole from-source hassle? 
- checking things with telnet

