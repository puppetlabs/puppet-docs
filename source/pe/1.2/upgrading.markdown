---
layout: default
title: "PE 1.2 Manual: Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---

{% include pe_1.2_nav.markdown %}

[altnamespage]: http://puppetlabs.com/security/cve/cve-2011-3872/
[altnamesmodule]: https://github.com/puppetlabs/puppetlabs-cve20113872/
{% capture altnames %}### Remediate the AltNames Vulnerability

PE versions prior to 1.2.4 are vulnerable to the [CVE-2011-3872 AltNames vulnerability][altnamespage]. If you haven't already neutralized any dangerous certificates at your site, you should download and use [the remediation toolkit module][altnamesmodule] to do so. See the README files included in the module for full documentation.{% endcapture %}

Upgrading to Puppet Enterprise 1.2
======

Puppet Enterprise ships with an upgrade script that will do a large part of the work of upgrading your installation. However, you will have to finish the configuration of PE 1.2 manually.

To upgrade to PE 1.2, you must:

* Download and unarchive the PE tarball.
* Run the `puppet-enterprise-upgrader` script.
* Check the notes below to find the version you're upgrading from, and perform any manual tasks required.

Choosing Your Installer Tarball
------

Before upgrading Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].

[downloadpe]: http://puppetlabs.com/misc/pe-files/

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball. Although the universal tarball can be more convenient, it is roughly ten times the size of the version-specific tarball.

|      Filename ends with...        |                     Will install...                           |
|-----------------------------------|---------------------------------------------------------------|
| `-all.tar`                        | anywhere                                                      |
| `-debian-<version and arch>.tar`  | on Debian                                                     |
| `-el-<version and arch>.tar`      | on RHEL, CentOS, Scientific Linux, or Oracle Linux            |
| `-sles-<version and arch>.tar`    | on SUSE Linux Enterprise Server                               |
| `-solaris-<version and arch>.tar` | on Solaris                                                    |
| `-ubuntu-<version and arch>.tar`  | on Ubuntu LTS                                                 |

Running the Upgrader
-----

Once you've retrieved a PE tarball, you should unarchive it, navigate to the resulting directory, and run `./puppet-enterprise-upgrader`. This script will examine your system to determine which Puppet Enterprise roles are currently installed, then list the packages these roles will require and ask if you want to continue with the upgrade. **Note that the list of packages shown is not complete:** any new dependencies from your operating system's repositories will be installed without confirmation, and the upgrade may fail if you are not connected to the source of these packages. Note also that **upgrades to PE 1.x systems with the Puppet Dashboard role and no puppet agent role may not upgrade cleanly,** as this configuration is no longer supported under PE 1.2. We recommend that you run the `puppet-enterprise-installer` script in this situation, although this upgrade path has not been thoroughly tested.

After receiving confirmation, the upgrader will update existing packages, install new packages added in this version of PE, and run additional scripts or puppet manifests to make the system similar (though not necessarily identical) to a new installation of PE 1.2.

Upgrading From PE 1.2.1 Through 1.2.3
-----

{{ altnames }}

Upgrading From PE 1.2.0
-----

### Enable File Archiving

The PE 1.2.0 installer incorrectly placed `puppet.conf`'s `archive_files = true` setting in an inert `[inspect]` block. This caused puppet inspect to not upload files when submitting compliance reports.

If you haven't already, you should edit your puppet.conf file to include `archive_files = true` under the `[main]` block when upgrading from 1.2.0.

{{ altnames }}

Upgrading From PE 1.1 and Earlier
-----

When upgrading from PE 1.1 and 1.0, you must:

* Create a new database for the inventory service and grant all permissions on it to the dashboard MySQL user.
* Manually edit the `puppet.conf`, `auth.conf`, `site.pp`, and `settings.yml` files on your puppet master.
* Generate and sign certificates for Puppet Dashboard to enable inventory and filebucket viewing.
* Restart `pe-httpd`.
* Remediate the AltNames vulnerability, if you have not already done so.

Puppet and Puppet Dashboard will continue to perform their pre-existing tasks properly if you skip the first four steps, but they are necessary to enable new features added in version 1.2.

Upgrades to sites which run the master and Dashboard on different servers can be significantly more complicated, and are supported on a case-by-case basis. Contact Puppet Labs support for more details.

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

    Note that if you were previously using an older version of the `stdlib` module, or any modules with the same name as the `accounts, mcollectivepe,` or `baselines` modules, you will have to delete them in order to use the modules included with PE 1.2.
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

        [main]
            archive_files = true

### Edit `/etc/puppetlabs/puppet/auth.conf`

To support the inventory service, you must add the following stanzas to your [`auth.conf`](/guides/rest_auth_conf.html) file:

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

These stanzas **must** be inserted **before** the final stanza, which looks like this:

    path /
    auth any

If you paste the new stanzas after this final stanza, they will not take effect.

### Edit `/etc/puppetlabs/puppet/manifests/site.pp`

Even if you don't use `site.pp` to classify nodes, you must add the following resource and resource default in order to support Puppet Dashboard's filebucket viewing capabilities:

    # specify remote filebucket
    filebucket { 'main':
      server => '<puppet master's hostname>',
      path => false,
    }

    File { backup => 'main' }

This will cause all agent nodes to back up their file contents to the puppet master, which will then serve the files to Dashboard on demand.

### Edit `/etc/puppetlabs/puppet-dashboard/settings.yml`

To turn on inventory and filebucket viewing, you must ensure that the following two options in `settings.yml` are set to true:

    enable_inventory_service: true
    use_file_bucket_diffs: true

You'll also need to ensure that the following three settings point to one of the puppet master's certified hostnames:

    ca_server: '<puppet master's hostname>'
    inventory_server: '<puppet master's hostname>'
    file_bucket_server: '<puppet master's hostname>'

Also, make sure the following settings exist and are set to the suggested values; if any are missing, you will need to add them to settings.yml yourself:

    private_key_path: 'certs/pe-internal-dashboard.private_key.pem'
    public_key_path: 'certs/pe-internal-dashboard.public_key.pem'
    ca_crl_path: 'certs/pe-internal-dashboard.ca_crl.pem'
    ca_certificate_path: 'certs/pe-internal-dashboard.ca_cert.pem'
    certificate_path: 'certs/pe-internal-dashboard.cert.pem'
    key_length: 1024
    cn_name: 'pe-internal-dashboard'

### Generate and Sign Certificates for Puppet Dashboard

To support Dashboard's inventory and filebucket viewing capabilities, you must generate and sign certificates to allow it to request data from the puppet master.

First, navigate to Dashboard's installation directory:

    $ cd /opt/puppet/share/puppet-dashboard

Next, create a keypair and request a certificate:

    $ sudo /opt/puppet/bin/rake cert:create_key_pair
    $ sudo /opt/puppet/bin/rake cert:request

Next, sign the certificate request:

    $ sudo /opt/puppet/bin/puppet cert sign dashboard

Next, retrieve the signed certificate:

    $ sudo /opt/puppet/bin/rake cert:retrieve

And finally, make `puppet-dashboard` the owner of the certificates directory:

    $ sudo chown -R puppet-dashboard:puppet-dashboard certs

#### Troubleshooting

If these rake tasks fail with errors like `can't convert nil into String`, you may be missing a certificate-related setting from the settings.yml file. Go back to the previous section and make sure all of the required settings exist.

### Restart `pe-httpd`

To reload all of the relevant puppet master and Dashboard config files, restart Apache:

    $ sudo /etc/init.d/pe-httpd restart

{{ altnames }}

