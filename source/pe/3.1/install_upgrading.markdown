---
layout: default
title: "PE 3.1 » Installing » Upgrading"
subtitle: "Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---


Summary
-----

The Puppet Installer script is used to perform both installations and upgrades. You start by [downloading][downloading] and unpacking a tarball with the appropriate version of the PE packages for your system. Then, when you run the `puppet-enterprise-installer` script, the script will check for a prior installation of PE and, if it detects one, will ask if you want to proceed with the upgrade. The installer will then upgrade all the PE components (master, agent, etc.) it finds on the node to version 3.1.3.

### Upgrading a Monolithic Installation
If you have a monolithic installation (with the master, console, and database roles all on the same node), the installer will upgrade each role in the correct order, automatically.

### Upgrading a Split Installation
If you have a split installation (with the master, console and database roles on different nodes), the process involves the following steps, which *must be performed in the following order:*

1. Upgrade Master
2. Upgrade PuppetDB
3. Upgrade Console
4. Upgrade Agents

> ![windows logo](./images/windows-logo-small.jpg) To upgrade Windows agents, simply download and run the new MSI package as described in [Installing Windows Agents](./install_windows.html). However, be sure to upgrade your master, console, and database nodes first.


Important Notes and Warnings
---
### Before Upgrading Back Up Your Databases and Other PE Files

   We recommend that you backup the following databases and PE files. 

   On a monolithic (all-in-one) install, the databases and PE files will all be located on the same node as the puppet master.

   - `/etc/puppetlabs/`
   - `/opt/puppet/share/puppet-dashboard/certs`
   - [The console and console_auth databases](./maintain_console-db.html#database-backups)
   - [The PuppetDB database](/puppetdb/1.5/migrate.html#exporting-data-from-an-existing-puppetdb-database)
   
On a split install, the databases and PE files will be located across the various roles assigned to your servers.

   - `/etc/puppetlabs/`: different versions of this directory can be found on the server assigned to the puppet master role, the server assigned to the console role, and the server assigned to the database support role (i.e., PuppetDB and PostgreSQL). You should back up each version.
   - `/opt/puppet/share/puppet-dashboard/certs`: located on the server assigned to the console role. 
   - The console and console_auth databases: located on the server assigned to the database support role.
   - The PuppetDB database: located on the server assigned to the database support role. 

### Upgrading is only supported from PE 2.8.3 or the latest point release of newer versions.

 To upgrade from a version older than 2.8.3, you *must* first upgrade to 2.8.3, make sure everything is working correctly, and then move on to upgrading to 3.1.1. To upgrade from 3.0.x you *must* first upgrade to the latest point release of the 3.0.x series, make sure everything is working, and then move on to upgrading to 3.1.1. You can find older versions of PE on the [previous releases page](https://puppetlabs.com/misc/pe-files/previous-releases/). 
- If you are upgrading from an installation of PE 2.8.3 or later in the 2.8.x series that includes a manually added PuppetDB, you will need to remove PuppetDB before upgrading or your upgrade the will fail. 

  Before upgrading, remove the following:
  
   * `/etc/puppetlabs/puppet/routes.yaml`
   * `/etc/puppetlabs/puppet/puppetdb.conf`
   * PostgreSQL (if installed on the master), including any data and config directories
   
Next, in the `[master]` stanza of `/etc/puppetlabs/puppet/puppet.conf`, make the following changes:
  
   * remove the entire `storeconfigs_backend` entry; it will default to ActiveRecord.
   * make sure the `facts_terminus` parameter is set to `inventory_active_record`.

Finally, perform your upgrade.

### Upgrades to PE 3.x from 2.8.3 Can Fail if PostgreSQL is Already Installed

This issue has been documented in the [Known Issues section of the Appendix](./appendix.html#upgrades-to-pe-3.x-from-2.8.3-can-fail-if-postgresql-is-already-installed).

### Other Important Notes

- Upgrading is now handled by the installer, which will detect whether or not a previous version of PE is present and will then run in "install" or "upgrade" mode as appropriate.
- After upgrading your puppet master server, you will not be able to issue orchestration commands to PE 2.x agent nodes until they have been upgraded to PE 3.1. The version of the orchestration engine used in PE 3.x is incompatible with that used by PE 2.x.
- For PE 3.0 and later, URLs pointing to module files must contain `modules/`, as in `puppet:///modules/`.
- PE 3 uses Ruby 1.9 which is stricter about character encoding than the previous version used in PE 2.8. If your manifests contain non-ASCII characters they may fail to compile or behave unpredictably. When upgrading, make sure manifests contain only ASCII characters. For more information see the [release notes](./appendix.html#puppet-code-issues-with-utf-8-encoding).
- On AIX 5.3, as in PE 2.8.3, puppet agents still depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`.
- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading by running:

        rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

    If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed and you can proceed with the upgrade (you can verify the installation with  `rpm -q readline`).
- If you upgraded from PE 2.5, your `cas_client_config.yml` and `rubycas-server/config.yml` files will not have the relevant commented-out sections, as they were added for 2.6 and the upgrader does not overwrite the config files. To find example config code that can be copied and pasted into the live config files, look in files with **the same names and either the `.rpmnew` or `.dpkg-new` extension.**


Downloading PE
-----

If you haven't done so already, you will need a Puppet Enterprise tarball appropriate for your system(s). See the [Installing PE][downloading] section of this guide for more information on accessing Puppet Enterprise tarballs, or go directly to the [download page](http://info.puppetlabs.com/download-pe.html).

[downloading]: ./install_basic.html#downloading-pe

Once downloaded, copy the appropriate tarball to each node you'll be upgrading.


Running the Upgrade
-----

Before starting the upgrade, all of the components (agents, master, console, etc.) in your current deployment should be correctly configured and communicating with each other, and live management should be up and running with all nodes connected.

> **Important:** All installer commands should be run as `root`.

> **Note:** PE3 has moved from the MySQL implementation used in PE 2.x to PostgreSQL for all database support. PE3 also now includes PuppetDB, which requires PostgreSQL. When upgrading from 2.x to 3.x, the installer will automatically pipe your existing data from MySQL to PostgreSQL.
>
> You will need to have a node available and ready to receive an installation of PuppetDB and PostgreSQL. This can be the same node as the one running the master and console (if you have a monolithic, all-on-one implementation), or it can be a separate node (if you are running a split role implementation). In a split role implementation, **the database node must be up and running and reachable at a known hostname before starting the upgrade process on the console node.**
>
> The upgrader can install a pre-configured version of PostgreSQL (must be version 9.1 or higher) along with PuppetDB on the node you select. If you prefer to use a node with an existing instance of PostgreSQL, that instance needs to be manually configured with the [correct users and access](./install_basic.html#database-support-questions). This also needs to be done BEFORE starting the upgrade.

### Upgrade Master

Start the upgrade by running the `puppet-enterprise-installer` script on the master node. You can use any of the flags described in the [install instructions](/pe/latest/install_basic.html). The script will detect any previous versions of PE roles and stop any PE services that are currently running. The script will then step through the install script, providing default answers based on the roles it has detected on the node (e.g., if the script detects only an agent on a given node, it will provide "No" as the default answer to installing the master role). The installer should be able to answer all of the questions based on your current installation except for the hostname and port of the PuppetDB node you prepped before starting the install.

As with installation, the script will also check for any missing dependent vendor packages and offer to install them automatically.

Lastly, the script will summarize the upgrade plan and ask you to go ahead and perform the upgrade. Your answers to the script will be saved as usual in `/etc/puppetlabs/installer/answers.install`.

The upgrade script will run and provide detailed information as to what it installs, what it updates and what it replaces. It will preserve existing certificates and `puppet.conf` files.

### Upgrade PuppetDB

On the node you provisioned for PuppetDB before starting the upgrade, unpack the PE 3.1 tarball and run the `puppet-enterprise-installer` script. 

If you are upgrading from a 2.8 deployment, you will need to provide some answers to the upgrader. These answers are ONLY needed when upgrading from the 2.8 line.

*  `?? Install puppet master? [y/N]` Answer N. This will not be your master. The master was upgraded in the previous step.
*  `?? Puppet master hostname to connect to? [Default: puppet]` Enter the FQDN of the master node you upgraded in the previous step.
*  `?? Install PuppetDB? [y/N]` Answer Y. This is the reason we are performing this installation on this node.
*  `?? Install the cloud provisioner? [y/N]` Choose whether or not you would like to install the cloud provisioner role on this node.
*  `?? Install a PostgreSQL server locally? [Y/n]` If you want the installer to create a PostgreSQL server instance for PuppetDB data, answer 'Y'. If you are using an existing PostgresSQL instance located elsewhere, answer 'N' and be prepared to answer questions about its hostname, port, database name, database user, and password.
*  `?? Certname for this node? [Default: my_puppetdb_node.example.com ]` Enter the FQDN for this node.
*  `?? Certname for the master? [Default: hostname.entered.earlier ]` You only need to change the default if the hostname and certname of your master are different.

The installer will save auto-generated users and passwords in `/etc/puppetlabs/installer/database_info.install`. Do not delete this file, you will need its information in the next step.

#### Potential Database Transfer Issues

* The node running PostgreSQL must have access to the en_US.UTF8 locale. Otherwise, certain non-ASCII characters will not translate correctly and may cause issues and unpredictability.

* If you have manually re-ordered the columns in your old MySQL database, the transfer may fail or may import values into inappropriate columns, leading to incorrect data and unpredictable behavior.

* If some string values (e.g. for "group name") are literals written *exactly* as `NULL`, they will be transferred as undefined values or, if the target PostgreSQL column has a not-null constraint, the import may fail altogether.

### Upgrade the Console

On the node serving the console role, unpack the PE 3.1 tarball and run the `puppet-enterprise-installer` script. The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment.

> **Note:** When upgrading a node running the console role, the upgrader will pipe the current MySQL databases into the new PostgreSQL databases. If your databases contain a lot of data, this transfer may take some time to complete.
>
> * [Pruning the MySQL data](./maintain_console-db.html#cleaning-old-reports) before starting the upgrade will make things go faster. While not absolutely necessary, to make the transfer go faster we recommend deleting all but two-four weeks worth of reports.
> * If you are running the console on a VM, you may also wish to temporarily increase the amount of RAM available.
>
> Note that your old database will NOT be deleted after the upgrade completes. After you are sure the upgrade was successful, you will need to delete the database files yourself to reclaim disk space.


The installer will also ask for the following information:

* The hostname and port number for the PuppetDB node you created in the previous step.
* Database credentials; specifically, the database names, user names, and passwords for the `console`, `console_auth`, and `pe-puppetdb` databases. These can be found in `/etc/puppetlabs/installer/database_info.install` on the PuppetDB node.

**Note:** If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

### Upgrade Agents and Complete the Upgrade

On each node with a puppet agent, unpack the PE 3.1 tarball and run the `puppet-enterprise-installer` script. The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment. Note that the agents on your master and console nodes will have been updated already when you upgraded those nodes. Nodes running 2.x agents will not be available for live management until they have been upgraded.

PE services should restart automatically after the upgrade. But if you want to check that everything is working correctly, you can run `puppet agent -t` on your agents to ensure that everything is behaving as it was before upgrading. Generally speaking, it's a good idea to run puppet right away after an upgrade to make sure everything is hooked and has gotten the latest configuration.

Checking For Updates
-----

[Check here][updateslink] to find out what the latest maintenance release of Puppet Enterprise is. To see the version of PE you are currently using, you can run `puppet --version` on the command line .


[updateslink]: http://info.puppetlabs.com/download-pe.html

**Note: By default, the puppet master will check for updates whenever the `pe-httpd` service restarts.** As part of the check, it passes some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable checking can be found in the [answer file reference](./install_answer_file_reference.html#puppet-master-answers).

* * *


- [Next: Uninstalling](./install_uninstalling.html)
