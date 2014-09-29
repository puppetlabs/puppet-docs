---
layout: default
title: "PE 3.2 » Installing » Upgrading"
subtitle: "Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---


Summary
-----

The Puppet Installer script is used to perform both installations and upgrades. The script will check for a prior version and run as upgrader or installer as needed. You start by [downloading][downloading] and unpacking a tarball with the appropriate version of the PE packages for your system. Then, when you run the `puppet-enterprise-installer` script, the script will check for a prior installation of PE and, if it detects one, will ask if you want to proceed with the upgrade. The installer will then upgrade all the PE components (master, agent, etc.) it finds on the node to version 3.2.

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

### Before Upgrading, Back Up Your Databases and Other PE Files

   We recommend that you back up the following databases and PE files.

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

### Upgrades from 3.2.0 Can Cause Issues with Multi-Platform Agent Packages

   Users upgrading from PE 3.2.0 to a later version of 3.x (including 3.2.3) will see errors when attempting to download agent packages for platforms other than the master. After adding `pe_repo` classes to the master for desired agent packages, errors will be seen on the subsequent puppet run as PE attempts to access the requisite packages. For a simple workaround to this issue, see the [installer troubleshooting page](./trouble_install.html#upgrades-from-320-can-cause-issues-with-multi-platform-agent-packages).

### Upgrades to PE 3.x from 2.8.3 Can Fail if PostgreSQL is Already Installed

This issue has been documented in the [Known Issues section of the Appendix](./appendix.html#upgrades-to-pe-3x-from-283-can-fail-if-postgresql-is-already-installed).

### A Note about Changes to `puppet.conf` that Can Cause Issues During Upgrades

If you manage `puppet.conf` with Puppet or a third-party tool like Git or r10k, you may encounter errors after upgrading based on the following changes. Please assess these changes before upgrading.

* **`node_terminus` Changes**

   In PE versions earlier than 3.2, node classification was configured with `node_terminus=exec`, located in `/etc/puppetlabs/puppet/puppet.conf`. This caused the puppet master to execute a custom shell script (`/etc/puppetlabs/puppet-dashboard/external_node`) which ran a curl command to retrieve data from the console.

   PE 3.2 changes node classification in `puppet.conf`. The new configuration is `node_terminus=console`. The `external_node` script is no longer available; thus, `node_terminus=exec` no longer works.

   With this change, we have improved security, as the puppet master can now verify the console. The console certificate name is `pe-internal-dashboard`. The puppet master now finds the console by reading the contents of /`etc/puppetlabs/puppet/console.conf`, which provides the following:

      [main]
      server=<console hostname>
      port=<console port>
      certificate_name=pe-internal-dashboard

   This file tells the puppet master where to locate the console and what name it should expect the console to have. If you want to change the location of the console, you can edit `console.conf`, but **DO NOT** change the `certificate_name` setting.

   The rules for certificate-based authorization to the console are found in `/etc/puppetlabs/console-auth/certificate_authorization.yml` on the console node. By default, this file allows the puppet master read-write access to the console (based on it's certificate name) to request node data and submit report data.

* **Reports Changes**

   Reports are no longer submitted to the console using `reports=https`. PE 3.2 changed the setting in `puppet.conf` to `reports=console`. This change works in the same way as the `node_terminus` changes described above.

### Upgrading Split Console and Custom PostgreSQL Databases

When upgrading from 3.1 to 3.2, the console database tables are upgraded from 32-bit integers to 64-bit. This helps to avoid ID overflows in large databases. In order to migrate the database, the upgrader will temporarily require disc space equivalent to 20% more than the largest table in the console's database (by default, located here: `/opt/puppet/var/lib/pgsqul/9.2/console`). If the database is in this default location, on the same node as the console, the upgrader can successfully determine the amount of disc space needed and provide warnings if needed. However, there are certain circumstances in which the upgrader cannot make this determination automatically. Specifically, the installer cannot determine the disc space requirement if:

   1. The console database is installed on a different node than the console.
   2. The console database is a custom instance, not the database installed by PE.

   In case 1, the installer can determine how much space is needed, but it will be up to the user to determine if sufficient free-space exists.
In case 2, the installer is unable to obtain any information about the size or state of the database.

### Running a 3.x Master with 2.8.x Agents is not Supported

3.x versions of PE contain changes to the MCollective module that are not compatible with 2.8.x agents. When running a 3.x master with a 2.8.x agent, it is possible that puppet will still continue to run and check into the console, but this means puppet is running in a degraded state that is not supported.

### Upgrades to PE 3.2.x or Later Removes Commented Authentication Sections from `rubycas-server/config.yml`

If you are upgrading to PE 3.2.x or later, `rubycas-server/config.yml` will not contain the commented sections for the third-party services. We've provided the commented sections on [the console config page](./console_config.html#configuring-rubycas-server-config-yml), which you can copy and paste into `rubycas-server/config.yaml` after you upgrade.

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

On the node you provisioned for PuppetDB before starting the upgrade, unpack the PE 3.2 tarball and run the `puppet-enterprise-installer` script.

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

On the node serving the console role, unpack the PE 3.2 tarball and run the `puppet-enterprise-installer` script. The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment.

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


#### Disabling/Enabling Live Management During an Upgrade

The status of live management is not managed during an upgrade of PE unless you specifically indicate a change is needed in an answer file. In other words, if your previous version of PE had live management enabled (the PE default), it will remain enabled after you upgrade unless you add or change `q_disable_live_manangement={y|n}` in your answer file.

Depending on your answer, the `disable_live_management` setting in `/etc/puppetlabs/puppet-dashboard/settings.yml` on the puppet master will be set to either `true` or `false` after the upgrade is complete.

(Note that you can enable/disable Live Management at any time during normal operations by editing the aforementioned `settings.yml` and then running `sudo /etc/init.d/pe-httpd restart`.)

### Upgrade Agents and Complete the Upgrade

The simplest way to upgrade agents is to upgrade the `pe-agent` package in the repo your package manager (e.g., Satellite) is using. Similarly, if you are using the PE package repo hosted on the master, it will get upgraded when you upgrade the master. You can then [use the agent install script](./install_basic.html#installing-agents-using-pe-package-management) as usual to upgrade your agent.

For nodes running an OS that doesn't support remote package repos (e.g., RHEL 4, AIX) you'll need to use the installer script on the PE tarball as you did for the master, etc. On each node with a puppet agent, unpack the PE 3.2 tarball and run the `puppet-enterprise-installer` script. The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment. Note that the agents on your master and console nodes will have been updated already when you upgraded those nodes. Nodes running 2.x agents will not be available for live management until they have been upgraded.

PE services should restart automatically after the upgrade. But if you want to check that everything is working correctly, you can run `puppet agent -t` on your agents to ensure that everything is behaving as it was before upgrading. Generally speaking, it's a good idea to run puppet right away after an upgrade to make sure everything is hooked and has the latest configuration.

Checking For Updates
-----

[Check here][updateslink] to find out the latest maintenance release of Puppet Enterprise. To see the version of PE you are currently using, you can run `puppet --version` on the command line.



[updateslink]: http://info.puppetlabs.com/download-pe.html

**Note: By default, the puppet master will check for updates whenever the `pe-httpd` service restarts.** As part of the check, it passes some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable checking can be found in the [answer file reference](./install_answer_file_reference.html#puppet-master-answers).

* * *


- [Next: Uninstalling](./install_uninstalling.html)
