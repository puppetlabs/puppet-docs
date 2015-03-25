---
layout: default
title: "PE 2.5 » Installing » Upgrading"
subtitle: "Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---

To upgrade from a previous version of Puppet Enterprise, use the same installer tarball as in a basic installation, but **don't** run the `puppet-enterprise-installer` script. Instead, run `puppet-enterprise-upgrader`.

Depending on the version you upgrade from, **you may need to take extra steps** after running the upgrader. See below for your specific version.

> ![windows logo](./images/windows-logo-small.jpg) To upgrade Windows nodes, simply download and run the new MSI package as described in [Installing Windows Agents](./install_windows.html).

{% capture slowbigdatabase %}**Note that if your console database is very large, the upgrader may take a long time on the console node, possibly thirty minutes or more.** This is due to a resource-intensive database migration that must be run. Make sure that you schedule your upgrade appropriately, and avoid interrupting the upgrade process.{% endcapture %}{{ slowbigdatabase }}

**Warning:** If you have created custom modules and stored them in  `/opt/puppet/share/puppet/modules`, the upgrader will fail. Before upgrading, you should move your custom modules to `/etc/puppetlabs/puppet/modules`. Alternatively, you can update your modules manually to have the correct metadata.

> **NOTE: PE 1.2.5 cannot be upgraded to this version of PE.** Systems running PE 1.2.5 can only upgrade to PE 2.6.1 or higher.
>
> This is because PE 1.2.5 includes some packages that are newer than those in PE 2.5. This is known to block upgrades on SLES systems, and may cause more subtle failures on other platforms. If you run into an upgrade failure, it can be fixed by running the 2.6.1 upgrader.


Checking For Updates
-----

[Check here][updateslink] to find out what the latest maintenance release of Puppet Enterprise is. You can run `puppet --version` at the command line to see the version of PE you are currently running.


[updateslink]: http://info.puppetlabs.com/download-pe.html

Downloading PE
-----

See the [Installing PE][downloading] of this guide for information on downloading Puppet Enterprise tarballs.

[downloading]: ./install_basic.html#downloading-pe

Starting the Upgrader
-----

The upgrader must be run with root privileges:

    # ./puppet-enterprise-upgrader

This will start the upgrader in interactive mode. If the puppet master role and the console role are installed on different servers, **you must upgrade the puppet master first.**

{{ slowbigdatabase }}

### Upgrader Options

Like the installer, the upgrade will accept some command-line options:

`-h`
: Display a brief help message.

`-s <ANSWER FILE>`
: Save answers to file and quit without installing.

`-a <ANSWER FILE>`
: Read answers from file and fail if an answer is missing. See the [upgrader answers section][upgrader_answers] of the answer file reference for a list of available answers.

`-A <ANSWER FILE>`
: Read answers from file and prompt for input if an answer is missing. See the [upgrader answers section][upgrader_answers] of the answer file reference for a list of available answers.

`-D`
: Display debugging information.

`-l <LOG FILE>`
: Log commands and results to file.

`-n`
: Run in 'noop' mode; show commands that would have been run during installation without running them.

Non-interactive upgrades work identically to non-interactive installs, albeit with different answers available.

[upgrader_answers]: ./install_answer_file_reference.html#upgrader-answers


Configuring the Upgrade
-----

The upgrader will ask you the following questions:

### Cloud Provisioner

PE 2.5 includes a cloud provisioner tool that can be installed on trusted nodes where administrators have shell access. On nodes which lack the cloud provisioner role, you'll be asked whether you wish to install it.

### Vendor Packages

If PE 2.5 needs any packages from your OS's repositories, it will ask permission to install them.

### Puppet Master Options

#### Removing `mco`'s home directory

When upgrading from PE 1.2, the `mco` user gets deleted during the upgrade and is replaced with the `peadmin` user.

If the `mco` user had any preference files or documents you need, you should tell the upgrader to preserve the `mco` user's home directory; otherwise, it will be deleted.

#### Installing Wrapper Modules

When upgrading from PE 1.2, the `mcollectivepe`, `accounts`, and `baselines` modules will be renamed to `pe_mcollective, pe_accounts,` and `pe_compliance`, respectively. If you have used any of these modules by their previous names, you should install the wrapper modules so your site will continue to work while you switch over.

### Console Options

#### Admin User Email and Password

The console now uses role-based user authentication. You will be asked for an email address and password for the initial admin user; additional users [can be configured after the upgrade is completed](./console_auth.html).

Upgrader Warnings
-----

On console servers, the upgrader will check your MySQL server's `innodb_buffer_pool_size` setting. If it is too small, the upgrader will advise you to increase it.

If you receive a warning about the `innodb_buffer_pool_size` setting, you should:

* Cancel the upgrade and exit the upgrader.
* [Follow these instructions](./config_advanced.html#increasing-the-mysql-buffer-pool-size) to increase the buffer size.
* Re-run the upgrader and allow it to finish.



Final Steps: From PE 2.0 or 1.2
-----

* If you received an upgrader warning on your console server as [described above](#upgrader-warnings), be sure to increase your MySQL server's `innodb_buffer_pool_size`.

Otherwise, no extra steps are needed when upgrading from PE 2.0 or 1.2.

**Note that some features may not be available until puppet agent has run once on every node.** In normal installations, this means all features will be available within 30 minutes after upgrading all nodes.

Final Steps: From PE 1.1 or 1.0
-----

**Important note: Upgrades from some configurations of PE 1.1 and 1.0 aren't fully supported.** To upgrade from PE 1.1 or 1.0, **you must have originally installed the puppet master and Puppet Dashboard roles on the same node.** Contact Puppet Labs support for help with other configurations on a case-by-case basis, and see [issue #10872](http://projects.puppetlabs.com/issues/10872) for more information.

After running the upgrader on the puppet master/Dashboard (now console) node, you must:

* Stop the `pe-httpd` service
* Create a new database for the inventory service and grant all permissions on it to the console's MySQL user.
* Manually edit the puppet master's `puppet.conf`, `auth.conf`, `site.pp`, and `settings.yml` files
* Generate and sign certificates for the console, to enable inventory and filebucket viewing.
* Edit `passenger-extra.conf`
* Restart the `pe-httpd` service.

You can upgrade agent nodes after upgrading the puppet master and console. After upgrading an agent node, you must:

* Manually edit `puppet.conf`.

### Stop `pe-httpd`

For the duration of these manual steps, Puppet Enterprise's web server should be stopped.

    $ sudo /etc/init.d/pe-httpd stop

### Create a New Inventory Database

To support the inventory service, you must manually create a new database for puppet master to store node facts in. To do this, use the `mysql` client on the node running the database server. (This will almost always be the same server running the puppet master and console.)

    # mysql -uroot -p
    Enter password:
    mysql> CREATE DATABASE console_inventory_service;
    mysql> GRANT ALL PRIVILEGES ON console_inventory_service.* TO '<USER>'@'localhost';

Replace `<USER>` with the MySQL user name you gave Dashboard during your original installation.

### Edit Puppet Master's `/etc/puppetlabs/puppet/puppet.conf`

* To support the inventory service, you must configure Puppet to save facts to a MySQL database.

        [master]
            # ...
            facts_terminus = inventory_active_record
            dbadapter = mysql
            dbname = console_inventory_service
            dbuser = <CONSOLE/DASHBOARD'S MYSQL USER>
            dbpassword = <PASSWORD FOR CONSOLE'S MYSQL USER>
            dbserver = localhost

    If you chose a different MySQL user name for Puppet Dashboard when you originally installed PE, use that user name as the `dbuser` instead of "dashboard". If the database is served by a remote machine, use that server's hostname instead of "localhost".
* If you configured the puppet master to not send reports to the Dashboard, you must configure it to report to the console now:

        [master]
            # ...
            reports = https, store
            reporturl = https://<CONSOLE HOSTNAME>:<PORT>/reports/upload
* Puppet agent on this node also has some new requirements:

        [agent]
            # support filebucket viewing when using compliance features:
            archive_files = true
            # if you didn't originally enable pluginsync, enable it now:
            pluginsync = true

### Edit Puppet Master's `/etc/puppetlabs/puppet/auth.conf`

To support the inventory service, you must add the following two stanzas to your puppet master's [`auth.conf`](/guides/rest_auth_conf.html) file:

    # Allow the console to retrieve inventory facts:

    path /facts
    auth yes
    method find, search
    allow pe-internal-dashboard

    # Allow puppet master to save facts to the inventory:

    path /facts
    auth yes
    method save
    allow <PUPPET MASTER'S CERTNAME>

These stanzas **must** be inserted **before** the final stanza, which looks like this:

    path /
    auth any

If you paste the new stanzas after this final stanza, they will not take effect.

### Edit `/etc/puppetlabs/puppet/manifests/site.pp`

You must add the following lines to site.pp in order to view file contents in the console:

    # specify remote filebucket
    filebucket { 'main':
      server => '<puppet master's hostname>',
      path => false,
    }

    File { backup => 'main' }

### Edit `/etc/puppetlabs/puppet-dashboard/settings.yml`

Change the following three settings to point to one of the puppet master's valid DNS names:

    ca_server: '<PUPPET MASTER HOSTNAME>'
    inventory_server: '<PUPPET MASTER HOSTNAME>'
    file_bucket_server: '<PUPPET MASTER HOSTNAME>'

Change the following two settings to true:

    enable_inventory_service: true
    use_file_bucket_diffs: true

Ensure that the following settings exist and are set to the suggested values; if any are missing, you will need to add them to `settings.yml` yourself:

    private_key_path: 'certs/pe-internal-dashboard.private_key.pem'
    public_key_path: 'certs/pe-internal-dashboard.public_key.pem'
    ca_crl_path: 'certs/pe-internal-dashboard.ca_crl.pem'
    ca_certificate_path: 'certs/pe-internal-dashboard.ca_cert.pem'
    certificate_path: 'certs/pe-internal-dashboard.cert.pem'
    key_length: 1024
    cn_name: 'pe-internal-dashboard'

### Generate and Sign Console Certificates

First, navigate to the console's installation directory:

    $ cd /opt/puppet/share/puppet-dashboard

Next, start a temporary WEBrick puppet master:

    $ sudo /opt/puppet/bin/puppet master

Next, create a keypair and request a certificate:

    $ sudo /opt/puppet/bin/rake cert:create_key_pair
    $ sudo /opt/puppet/bin/rake cert:request

Next, sign the certificate request:

    $ sudo /opt/puppet/bin/puppet cert sign dashboard

Next, retrieve the signed certificate:

    $ sudo /opt/puppet/bin/rake cert:retrieve

Next, stop the temporary puppet master:

    $ sudo kill $(cat $(puppet master --configprint pidfile) )

Finally, chown the certificates directory to `puppet-dashboard`:

    $ sudo chown -R puppet-dashboard:puppet-dashboard certs

#### Troubleshooting

If these rake tasks fail with errors like `can't convert nil into String`, you may be missing a certificate-related setting from the `settings.yml` file. Go back to the previous section and make sure all of the required settings exist.

### Start `pe-httpd`

You can now start PE's web server again.

    $ sudo /etc/init.d/pe-httpd start

### Edit `puppet.conf` on Each Agent Node

On each agent node you upgrade to PE 2.5, make the following edits to `/etc/puppetlabs/puppet/puppet.conf`:

    [agent]
        # support filebucket viewing when using compliance features:
        archive_files = true
        # if you didn't originally enable pluginsync, enable it now:
        pluginsync = true


* * *

- [Next: Uninstalling](./install_uninstalling.html)
