---
layout: default
title: "PE 3.2 » Maintenance » Back Up and Restore"
subtitle: "Back Up and Restore a Puppet Enterprise Installation"
canonical: "/pe/latest/maintain_backup_restore.html"
---

Once you have PE installed, we recommend that you keep regular backups of your PE infrastructure. Regular backups allow you to recover from failed upgrades between versions, to troubleshoot those upgrades, and to quickly recover in the case of system failures. The instructions in this doc can also help you migrate your PE infrastructure from one set of nodes to another.

To perform a full backup and restore, you will:

1. [Back Up Your Database and Puppet Enterprise Files](#back-up-your-database-and-puppet-enterprise-files)
2. [Purge the Puppet Enterprise Installation (Optional)](purge-the-puppet-enterprise-installation-(optional\))
3. [Restore Your Database and Puppet Enterprise Files](Restore Your Database and Puppet Enterprise Files)

### Back Up Your Database and Puppet Enterprise Files

To properly back up your PE installation, the following databases and PE files should be backed up. 

 - `/etc/puppetlabs/`
 - `/opt/puppet/share/puppet-dashboard/certs`
 - [The PuppetDB, console, and console_auth databases](./maintain_console-db.html#database-backups)
 - The modulepath——if you've configured it to be outside the PE default of `modulepath = /etc/puppetlabs/puppet/module:/opt/puppet/share/puppet/modules` in `puppet.conf`.
 
> **Note**: If you have any custom Simple RPC agents, you will want to back these up. These are located in the `libdir` configured in `/etc/puppetlabs/mcollective/server.cfg`. 

On a monolithic (all-in-one) install, the databases and PE files will all be located on the same node as the puppet master.
   
On a split install (master, console, PuppetDB/PostgreSQL each on a separate node), they will be located across the various servers assigned to these PE roles.

   - `/etc/puppetlabs/`: different versions of this directory can be found on the server assigned to the puppet master role, the server assigned to the console role, and the server assigned to the PuppetDB/PostgreSQL role. You should back up each version.
   - `/opt/puppet/share/puppet-dashboard/certs`: located on the server assigned to the console role. 
   - The console and console_auth databases: located on the server assigned to the PuppetDB/PostgreSQL role.
   - The PuppetDB database: located on the server assigned to the PuppetDB/PostgreSQL role. 

### Purge the Puppet Enterprise Installation (Optional)

If you're planning on restoring your databases and PE files to the same server(s), you'll want to first fully purge your existing Puppet Enterprise installation.

PE contains an uninstaller script located at `/opt/puppet/bin/puppet-enterprise-uninstaller`.
 
You can also run it from the same directory as the installer script in the PE tarball you originally downloaded.  To do so, run `sudo ./puppet-enterprise-uninstaller -p -d`. The `-p` and `-d` flags are to purge all configuration data and local databases. 

> **Important**: If you have a split install, you will need to run the uninstaller on each server that has been assigned a role.

After running the uninstaller, ensure that `/opt/puppet/` and `/etc/puppetlabs/` are no longer present on the system. 

For more information about using the PE uninstaller, refer to [Uninstalling Puppet Enterprise](./install_uninstalling.html).

### Restore Your Database and Puppet Enterprise Files

1. Using the standard install process (run the `puppet-enterprise-installer` script.), reinstall the same version of Puppet Enterprise that was installed for the files you backed up. 

   If you have your original answer file, use it during the installation process; otherwise, be sure to set the same database passwords you used during initial installation. 
   
   If you need to review the PE installation process, check out [Installing Puppet Enterpise](./install_basic.html). 
  
2. Run the following commands, in the order specified:

   a. `service pe-httpd stop`
   
   b. `service pe-puppet stop` 
   
   c. `service pe-mcollective stop`
   
   d. `service pe-puppet-dashboard-workers stop`
   
   e. `service pe-activemq stop`
   
   f. `service pe-puppetdb stop`

3. Purge any locks remaining on the database from the services that were running earlier with `service pe-postgresql restart`.

4. Run the following commands, in the order specified: 

   a. `su - pe-postgres -s /bin/bash -c "psql"`
   
   b. `drop database console;`
   
   c. `drop database console_auth;`
   
   d. `drop database "pe-puppetdb";`
   
   e. `\q`
   
   > **Note**: During this process, you may encounter an error message similar to, `ERROR:  role "console" already exists`. This error is safe to ignore. 

5. Restore from your `/etc/puppetlabs/` backup the following directories and files:

   For a monolithic install, these files should all be replaced on the puppet master: 
   
   * `/etc/puppetlabs/puppet/puppet.conf`
   * `/etc/puppetlabs/puppet/ssl` (fully replace with backup, do not leave existing ssl data)
   * `/opt/puppet/share/puppet-dashboard/certs`
   * [The PuppetDB, console, and console_auth databases](./maintain_console-db.html#database-backups)
   * The modulepath——if you've configured it to be something other than the PE default. 
   
   For a split install, these files and databases should be replaced on the various servers assigned to these PE roles.

   - `/etc/puppetlabs/`: as noted earlier, there is a different version of this directory for the puppet master role, the console role, and the database support role (i.e., PuppetDB and PostgreSQL). You should replace each version.
   - `/opt/puppet/share/puppet-dashboard/certs`: located on the server assigned to the console role. 
   - The console and console_auth databases: located on the server assigned to the database support role.
   - The PuppetDB database: located on the server assigned to the database support role. 
   - The modulepath: located on the server assigned to assigned to the puppet master role.  
   
   >**Note**: If you backed up any Simple RPC agents, you will need to restore these on the same server assigned to the puppet master role.   
  
6. Run `chown -R pe-puppet:pe-puppet /etc/puppetlabs/puppet/ssl/`.
7. Run `chown -R puppet-dashboard /opt/puppet/share/puppet-dashboard/certs/`.
8. Restore modules, manifests, hieradata, etc, if necessary. 
   These are typically located in the `/etc/puppetlabs/` directory, but you may have configured them in another location.
9. Run `/opt/puppet/sbin/puppetdb-ssl-setup -f`. This script generates SSL certificates and configuration based on the agent cert on your PuppetDB node.
10. Start all PE services you stopped in step 2. (For example, run `service pe-httpd start`.)

    >**Note**: During this process, you may get a message indicating that starting the dashboard workers failed, but they have in fact started. You can verify this by running `service pe-puppet-dashboard-workers status`.
