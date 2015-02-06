---
layout: default
title: "PE 3.7 » Installing » Components, Logs, and License Files"
subtitle: "Components, Logs, and License Files: What Gets Installed and Where?"
canonical: "/pe/latest/install_what_and_where.html"
---



### License File

Your PE license file (which was emailed to you when you purchased Puppet Enterprise) should be placed in `/etc/puppetlabs/license.key`.

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the Puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the Puppet master.

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>.

####License Files in the Console

The **licenses** menu shows you the number of nodes that are currently active and the number of nodes still available on your current license. If the number of available licenses is exceeded, a warning will be displayed. The number of licenses used is determined by the number of active nodes known to Puppetdb. This is a change from previous behavior which used the number of unrevoked certs known by the CA to determine used licenses. The menu item provides convenient links to purchase and pricing information.

Unused nodes will be deactivated automatically after seven days with no activity (no new facts, catalog or reports), or you can use `puppet node deactivate` for immediate results. The console will cache license information for some time, so if you have made changes to your license file (e.g. adding or renewing licenses), the changes may not show for up to 24 hours. You can restart the `pe-memcached` service in order to update the license display sooner.

### Software

#### What

All functional components of PE, excluding configuration files. You are not likely to need to change these components. The following software components are installed:

 * Puppet
 * PuppetDB
 * Facter
 * MCollective
 * Hiera
 * Puppet Dashboard

#### Where

On \*nix nodes, all PE software (excluding config files and generated data) is installed under `/opt/puppet`.

On Windows nodes, all PE software is installed in the "Puppet Enterprise" subdirectory of [the standard 32-bit applications directory](./install_windows.html#program-directory)

* Executable binaries on \*nix are in `/opt/puppet/bin` and `/opt/puppet/sbin`.
* The Puppet modules included with PE are installed on the Puppet master server in `/opt/puppet/share/puppet/modules`. Don't modify anything in this directory or add modules of your own. Instead, install them in `/etc/puppetlabs/puppet/environments/<environment>/modules`.
* Orchestration plugins are installed in `/opt/puppet/libexec/mcollective/mcollective` on \*nix and in [`<COMMON_APPDATA>`](./install_windows.html#data-directory)`\PuppetLabs\mcollective\etc\plugins\mcollective` on Windows. If you are adding new plugins to your PE agent nodes, you should [distribute them via Puppet as described in the "Adding Actions" page of this manual](./orchestration_adding_actions.html).

### Dependencies

For information about PostgreSQL and OpenSSL requirements, refer to the [system requirements](./install_system_requirements.html#dependencies-and-os-specific-details).

### Configuration Files

#### What

Most files used to configure Puppet Enterprise and its subsidiary components are managed by Puppet. The files listed below  are files you may need to change to accomodate the needs of your environment.

#### Where

On *nix nodes, Puppet Enterprise's configuration files all live under `/etc/puppetlabs`.

On Windows nodes, Puppet Enterprise's configuration files all live under `<COMMON_APPDATA>\PuppetLabs`. The location of this folder [varies by Windows version](./install_windows.html#data-directory); in 2008 and 2012, its default location is `C:\ProgramData\PuppetLabs\`.

PE's various components all have subdirectories inside this main data directory:

* Puppet's `confdir` is in the `puppet` subdirectory. This directory contains the [`puppet.conf`](/guides/configuring.html) file, the site manifest (`manifests/site.pp`), and the `modules` directory.


### Log Files

The software distributed with Puppet Enterprise generates the following log files, which can be found as follows.

#### Puppet Master Logs

The Puppet master service's logging are contained in two files:

* `/var/log/pe-puppetserver/puppetserver.log`: the Puppet master application logs its activity here; this is where things like compilation errors and deprecation warnings can be found.
* `/var/log/pe-puppetserver/pe-puppetserver-daemon.log`: this is where fatal errors or crash reports can be found. 

#### Puppet Agent Logs

On *nix nodes, the Puppet agent service logs its activity to the syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

On Windows nodes, the Puppet agent service logs its activity to the Windows Event Log. You can view its logs by browsing the Event Viewer. (Control Panel → System and Security → Administrative Tools → Event Viewer)

#### ActiveMQ Logs

- `/var/log/pe-activemq/wrapper.log`
- `/var/log/pe-activemq/activemq.log`
- `/var/opt/puppet/activemq/data/audit.log`

#### Orchestration Service Log

- `/var/log/pe-mcollective/mcollective.log` maintained by the orchestration service, which is installed on all nodes.
- `/var/log/pe-mcollective/mcollective-audit.log` exists on all nodes that have mcollective installed; logs any mcollective actions run on the node, including information about the client that called the node


#### Console Logs

- `/var/log/pe-httpd/error.log` contains errors related to Passenger. Console errors that don't get logged anywhere else can be found in this log. If you have problems with the console or Puppet, this log may be useful.
- `/var/log/pe-httpd/puppetdashboard.access.log` 
- `/var/log/pe-httpd/puppetdashboard.error.log`
- `/var/log/pe-puppet-dashboard/certificate_manager.log`
- `/var/log/pe-puppet-dashboard/delayed_job.log`
- `/var/log/pe-puppet-dashboard/event-inspector.log`
- `/var/log/pe-puppet-dasboard/failed_reports/` contains a collection of any reports that fail to upload the to the dashboard.
- `/var/log/pe-puppet-dashboard/live-management.log`
- `/var/log/pe-puppet-dashboard/mcollective_client.log`
- `/var/log/pe-puppet-dashboard/production.log`
- `/var/log/pe-console-services/console-services.log`
- `/var/log/pe-console-services/console-services-access.log`
- `/var/log/pe-console-services/pe-console-services-daemon.log`

#### Installer Logs

- `/var/log/pe-installer/http.log` contains the web requests sent to the installer; present only on the machine from which the web-based install was performed
- `/var/log/pe-installer/installer-<timestamp>.log` contains the operations performed and any errors that occurred during installation
- `/var/log/pe-installer/answers.install` contains the contents of the answer file used to install PE; passwords are redacted from this file
- `/var/log/pe-installer/install_log.lastrun.<hostname>.log` contains the contents of the last installer run

#### Database Log

- `/var/log/pe-puppetdb/pe-puppetdb.log`
- `/var/log/pe-postgresql/pgstartup.log`

#### Miscellaneous Logs

These files may or may not be present.

- `/var/log/pe-httpd/other_vhosts_access.log`
- `/var/log/pe-puppet/masterhttp.log`
- `/var/log/pe-puppet/rails.log`


### Puppet Enterprise Software Components

PE 3.7 includes the following major software components:

 * Puppet 3.7.1
 * PuppetDB 2.2.1
 * Facter 2.2.0
 * MCollective 2.6.0
 * ActiveMQ 5.9.0
 * Live Management: 1.3.1
 * Cloud Provisioner 1.1.7
 * Hiera 1.3.4
 * Dashboard 2.1.6
 * PostgreSQL 9.2.7
 * Ruby 1.9.3
 * Augeas 1.2.0
 * Passenger 4.0.37
 * Java 1.7.0
 * OpenSSL 1.0.0o

### Additional Puppet Enterprise Components

PE installs the following additional components.

#### Tools for Working with Puppet Enterprise

PE installs several suites of tools to help you work with the major components of the software. These include:

- **Puppet Tools** --- Tools that control basic functions of Puppet such as `puppet master,` `puppet apply` and `puppet cert.`
    See the [Tools section](/guides/tools.html) of the Puppet Manual for more information.
- **Cloud Provisioning Tools** --- Tools used to provision new nodes. Mostly based around the `node` subcommand, these tools are used for tasks such as creating or destroying virtual machines, classifying new nodes, etc. See the [Cloud Provisioning section](./cloudprovisioner_overview.html)  for more information.
- **Orchestration Tools** --- Tools used to orchestrate simultaneous actions across a number of nodes. These tools are built on the MCollective framework and are accessed either via the `mco` command or via the __Live Management__ page of the PE console. See the [Orchestration section](./orchestration_overview.html) for more information.
- **Module Tools** --- The Module tool is used to access and create Puppet Modules, which are reusable chunks of Puppet code users have written to automate configuration and deployment tasks. For more information, and to access modules, visit the [Puppet Forge](http://forge.puppetlabs.com/).
- **Console** --- The console is Puppet Enterprise's GUI web interface. The console provides tools to view and edit resources on your nodes, view reports and activity graphs, trigger Puppet runs, etc. See the [Console section](./console_accessing.html) of the Puppet Manual for more information.

For more details, you can also refer to the man page for a given command or subcommand.

#### Services

PE uses the following services:

- **`pe-activemq`** --- The ActiveMQ message server, which passes messages to the MCollective servers on agent nodes. Runs on servers with the Puppet master component.
- **`pe-console-services`** --- Manages and serves the PE console.
- **`pe-puppetserver`** --- The Puppet master server, which manages the Puppet master component.
- **`pe-httpd`** --- Apache 2, serves as a reverse-proxy to the PE console.
- **`pe-mcollective`** --- The orchestration (MCollective) daemon, which listens for orchestration messages and invokes actions. Runs on every agent node.
- **`pe-memcached`** --- The Puppet memcached daemon. Runs on the same node as the PE console.
- **`pe-puppet`** (on EL and Debian-based platforms) --- The Puppet agent daemon. Runs on every agent node.
- **`pe-puppet-dashboard-workers`** --- A supervisor that manages the console's background processes. Runs on servers with the console component.
- **`pe-puppetdb`** and **`pe-postgresql`** --- Daemons that manage and serve the database components. Note that pe-postgresql is only created if we install and manage PostgreSQL for you.

#### User Accounts

PE creates the following users:

- **`peadmin`** --- An administrative account which can invoke orchestration actions. This is the only PE user account intended for use in a login shell. See [the "Invoking Orchestration Actions" page of this manual](./orchestration_invoke_cli.html) for more about this user. This user exists on servers with the Puppet master component.
- **`pe-puppet`**  --- A system user that runs the Puppet master processes spawned by Passenger.
- **`pe-apache`** --- A system user that runs Apache (`pe-httpd`).
- **`pe-activemq`** --- A system user that runs the ActiveMQ message bus used by MCollective.
- **`puppet-dashboard`** --- A system user that runs the console processes spawned by Passenger.
- **`pe-puppetdb`** --- A system user with root access to the database.
- **`pe-auth`** --- The PE console auth user.
- **`pe-memcached`** --- The PE memcached daemon user.
- **`pe-postgres`** --- A system user with access to the pe-postgreSQL instance. Note that this user is only created if we install and manage PostgreSQL for you.
- **`pe-console-services`** --- A system user that runs the console process.

#### Group Accounts

PE creates the following groups:

- **`peadmin`** --- An administrative group which can invoke orchestration actions.
- **`pe-puppet`** --- A system group that runs the Puppet master processes spawned by Passenger.
- **`pe-apache`** --- A system group that runs Apache (`pe-httpd`).
- **`pe-activemq`** --- A system group that runs the ActiveMQ message bus used by MCollective.
- **`puppet-dashboard`** --- A system group that runs the console processes spawned by Passenger.
- **`pe-puppetdb`** --- A system group with root access to the database.
- **`pe-auth`** --- The PE console auth group.
- **`pe-memcached`** --- The PE memcached daemon group.
- **`pe-postgres`** --- A system group with access to the pe-postgreSQL instance. Note that this group is only created if we install and manage PostgreSQL for you.
- **`pe-console-services`** --- A system group that runs the console process.

#### Certificates

During install, PE generates the following certificates (can be found at `/etc/puppetlabs/puppet/ssl/certs`):

- **`pe-internal-dashboard`** ---  The certificate for the Puppet Dashboard.
- **`<user-entered console certname>`** ---  The certificate for the PE console. Only generated if the user has chosen to install the console in a split component configuration.
- **`<user entered PuppetDB certname>`** ---  The certificate for the database component. Only generated if the user has chosen to install the database in a split component configuration.
- **` <user-entered master certname> `** --- This certificate is either generated at install if the Puppet master and console are the same machine or is signed by the master if the console is on a separate machine.
- **`pe-internal-mcollective-servers`** --- A shared certificate generated on the Puppet master and shared to all agent nodes.
- **`pe-internal-peadmin-mcollective-client`** --- The orchestration certificate for the peadmin account on the Puppet master.
- **`pe-internal-puppet-console-mcollective-client`** --- The orchestration certificate for the PE console/live management
- **`pe-internal-classifier`** --- The certificate for the node classifier. 

A fresh PE install should thus give the following list of certificates:

    root@master:~# puppet cert list --all
    + "master"                                        (40:D5:40:FA:E2:94:36:4D:C4:8C:CE:68:FB:77:73:AB) (alt names: "DNS:master", "DNS:puppet", "DNS:puppet.soupkitchen.internal")
    + "pe-internal-classifier"                        F3:57:28:CC:72:2A:8B:75:93:65:27:99:AC:72:B4:AF
    + "pe-internal-dashboard"                         F6:07:C7:E9:33:76:D4:3E:12:D7:77:6D:85:0B:2A:D1
    + "pe-internal-mcollective-servers"               C2:59:69:2E:A1:45:7D:BA:BC:63:71:74:83:03:BF:49
    + "pe-internal-peadmin-mcollective-client"        85:56:72:72:04:02:8E:61:8C:34:B8:53:34:0A:3E:8C
    + "pe-internal-puppet-console-mcollective-client" A1:16:FB:12:9B:3E:85:2A:BF:28:C7:46:A9:8C:E7:55

### Documentation

Man pages for the Puppet subcommands are generated on the fly. To view them, run `puppet man <SUBCOMMAND>`.

The `pe-man` command from previous versions of Puppet Enterprise is no longer functional. Use the above method instead.



* * *

- [Next: Accessing the Console](./console_accessing.html)
