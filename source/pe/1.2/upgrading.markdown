---
layout: default
title: "PE Manual: Upgrading Puppet Enterprise
---

{% include pe_nav.markdown %}

Upgrading From Puppet Enterprise 1.x
======

Puppet Enterprise ships with an upgrade script that will do a large part of the work of upgrading your installation. However, you will have to finish the configuration of PE 1.2 manually. 

To upgrade to PE 1.2, you must:

* Download and unarchive the PE tarball.
* Run the `puppet-enterprise-upgrader` script.
* Create a new database for the inventory service and grant all permissions on it to the dashboard MySQL user. 
* Manually edit the `puppet.conf`, `auth.conf`, `site.pp`, and `settings.yml` files on your puppet master. 
* Generate and sign certificates for Puppet Dashboard to enable inventory and filebucket viewing. 
* Restart `pe-httpd`.

Choosing Your Installer Tarball
------

Puppet Enterprise can be downloaded in tarballs specific to your OS and version, or as a universal tarball. Although the universal archive can be more convenient, it is roughly ten times the size of the version-specific archives.

|      Filename ends with...        |                     Will install...                           |
|-----------------------------------|---------------------------------------------------------------|
| `-all.tar`                        | anywhere                                                      |
| `-debian-<version and arch>.tar`  | on Debian                                                     |
| `-el-<version and arch>.tar`      | on RHEL, CentOS, Scientific Linux, or Oracle Enterprise Linux |
| `-sles-<version and arch>.tar`    | on SUSE Linux Enterprise Server                               |
| `-solaris-<version and arch>.tar` | on Solaris                                                    | 
| `-ubuntu-<version and arch>.tar`  | on Ubuntu LTS                                                 |

Running the Upgrader
-----

Once you've retrieved a PE tarball, you should unarchive it, navigate to the resulting directory, and run `./puppet-enterprise-upgrader`. This script will examine your system to determine which Puppet Enterprise roles are currently installed, then list the packages these roles will require and ask if you want to continue with the upgrade. **Note that the list of packages shown is not complete:** any new dependencies from your operating system's repositories will be installed without confirmation, and the upgrade may fail if you are not connected to the source of these packages. Note also that **upgrades to PE 1.x systems with the Puppet Dashboard role and no puppet agent role may not upgrade cleanly,** as this configuration is no longer supported under PE 1.2. We recommend that you run the `puppet-enterprise-installer` script in this situation, although this upgrade path has not been thoroughly tested. 

After receiving confirmation, the upgrader will update existing packages, install new packages added in this version of PE, and run additional scripts or puppet manifests to make the system similar (though not necessarily identical) to a new installation of PE 1.2. 

Upgrading Puppet Agent
-----

The puppet agent role requires no additional upgrade steps. For machines running only the agent role, you don't need to do anything beyond run the upgrader script. 

As with a new installation, you need to [assign the `mcollectivepe` class][enablemco] to an agent node in order to enable MCollective.

[enablemco]: ./using.html#enabling-mcollective

Upgrading Puppet Master and Puppet Dashboard
-----

If you are running the puppet master and Puppet Dashboard roles on the same machine, you will need to perform some additional steps to complete the upgrade. **Puppet and Puppet Dashboard will continue to perform properly even if you skip these steps,** but they are necessary to enable new features added in version 1.2. 

### Create a New Inventory Database

To support the inventory service, you must manually create a new database for puppet master to store node facts in. To do this, use the `mysql` client on the server providing the database. The server providing the database will almost always be the server running puppet master and Dashboard. 

    # mysql -uroot -p
    Enter password: 
    mysql> CREATE DATABASE dashboard_inventory_service;
    mysql> GRANT ALL PRIVILEGES ON dashboard_inventory_service.* TO 'dashboard'@'localhost';

If you chose a different MySQL user name for Puppet Dashboard when you originally installed PE, use that user name instead of "dashboard". If the database is served by a remote machine, use the hostname of the master/Dashboard server instead of "localhost". 

### Edit `/etc/puppetlabs/puppet/puppet.conf`

* To use the new `accounts, mcollectivepe, stdlib,` and `baselines` modules, you must add the the `/opt/puppet/share/puppet/modules` directory to Puppet's `modulepath`: 

        [main]
            modulepath = /etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules
* To support the inventory service, you must configure Puppet to save facts to a MySQL database.

        [master]
            facts_terminus = inventory_active_record
            dbadapter = mysql
            dbname = dashboard_inventory_service
            dbuser = dashboard
            dbpassword = <MySQL password for dashboard user>
            dbserver = localhost

    If you chose a different MySQL user name for Puppet Dashboard when you originally installed PE, use that user name as the `dbuser` instead of "dashboard". If the database is served by a remote machine, use that server's hostname instead of "localhost". 
* To support filebucket viewing when using the Puppet Compliance workflow, you must set `archive_files` to true for puppet inspect:

        [agent]
            archive_files = true

### Edit `/etc/puppetlabs/puppet/auth.conf`

To support the inventory service, you must add the following stanzas to your [`auth.conf`](http://docs.puppetlabs.com/guides/rest_auth_conf.html) file:

    # Allow Dashboard to retrieve inventory facts:
    
    path /facts
    auth yes
    method find, search
    allow dashboard
    
    # Allow puppet master to save facts to the inventory:
    
    path /facts
    auth yes
    method save
    allow <puppet master's certname>

These stanzas **must** be inserted **before** the final stanza:

    ...method save
    allow <puppet master's certname>
    
    # final auth.conf stanza:
    
    path /
    auth any

If you paste these stanzas at the end of `auth.conf`, they will have no effect.

### Edit `/etc/puppetlabs/puppet/manifests/site.pp`

Even if you don't use `site.pp` to classify nodes, you must add the following resource and resource default in order to support Puppet Dashboard's filebucket viewing capabilities:

    # specify remote filebucket
    filebucket { 'main':
      server => 'screech.magpie.lan',
      path => false,
    }
    
    File { backup => 'main' }

This will cause all agent nodes to back up their file contents to the puppet master, which will then serve the files to Dashboard on demand. 

### Edit `/etc/puppetlabs/puppet-dashboard/settings.yml`

To support Dashboard's inventory and filebucket viewing capabilities, you must find and alter the following three settings in `settings.yml` to point to one of the puppet master's certified hostnames:

    ca_server: 'puppet'
    inventory_server: 'puppet'
    file_bucket_server: 'puppet'

### Generate and Sign Certificates for Puppet Dashboard

To support Dashboard's inventory and filebucket viewing capabilities, you must generate and sign certificates to allow it to request data from the puppet master.

First, you must modify your shell's `$PATH`:

    # export PATH=/opt/puppet/bin:/opt/puppet/sbin:$PATH

Next, navigate to Dashboard's installation directory:

    # cd /opt/puppet/share/puppet-dashboard

Next, create a keypair and request a certificate:

    # sudo -u puppet-dashboard rake cert:create_key_pair
    # rake cert:request

Next, sign the certificate request: 

    # puppet cert sign dashboard

Finally, retrieve the signed certificate:

    # sudo -u puppet-dashboard rake cert:retrieve

### Restart `pe-httpd`

To reload all of the relevant puppet master and Dashboard config files, restart Apache:

    # service pe-httpd restart

And you're done!

Upgrading Puppet Master Without Dashboard
-----

If you are not using Puppet Dashboard at your site, upgrading puppet master is significantly simpler.

### Edit `/etc/puppetlabs/puppet/puppet.conf`

* To use the new `accounts, mcollectivepe, stdlib,` and `baselines` modules, you must add the the `/opt/puppet/share/puppet/modules` directory to Puppet's `modulepath`: 

        [main]
            modulepath = /etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules

Upgrading Separated Puppet Master and Puppet Dashboard Servers
-----

### Coming Soon

Upgrading to PE 1.2 in cases where puppet master and Puppet Dashboard are being run on different servers is significantly more complicated. This upgrade procedure is not yet documented, and will be added to the manual at a later date. 
