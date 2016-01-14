---
layout: default
title: "PE 3.2 » Installing » What Gets Installed Where?"
canonical: "/pe/latest/install_what_and_where.html"
---



## License File


Your PE license file (which was emailed to you when you purchased Puppet Enterprise) should be placed in `/etc/puppetlabs/license.key`.

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master.

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>.

## Software

### <i>What</i>

All functional components of PE, excluding configuration files. You are not likely to need to change these components. The following software components are installed:

 * Puppet
 * PuppetDB
 * Facter
 * MCollective
 * Hiera
 * Puppet Dashboard

### <i>Where</i>

On \*nix nodes, all PE software (excluding config files and generated data) is installed under `/opt/puppet`.

On Windows nodes, all PE software is installed in the "Puppet Enterprise" subdirectory of [the standard 32-bit applications directory](./install_windows.html#program-directory)

* Executable binaries on \*nix are in `/opt/puppet/bin` and `/opt/puppet/sbin`.
* The Puppet modules included with PE are installed on the puppet master server in `/opt/puppet/share/puppet/modules`. Don't edit this directory to add modules of your own. Instead, install them in `/etc/puppetlabs/puppet/modules`.
* Orchestration plugins are installed in `/opt/puppet/libexec/mcollective/mcollective` on \*nix and in [`<COMMON_APPDATA>`](./install_windows.html#data-directory)`\PuppetLabs\mcollective\etc\plugins\mcollective`. If you are adding new plugins to your PE agent nodes, you should [distribute them via Puppet as described in the "Adding Actions" page of this manual](./orchestration_adding_actions.html).

## Dependencies

### PostgreSQL Requirement
If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

### OpenSSL Requirement
OpenSSL is a dependency required for PE. For RHEL 4, Windows, AIX, and Solaris 10 nodes, OpenSSL is included with PE; for all other platforms it is installed directly from the system repositories.

## Configuration Files

### <i>What</i>

Files used to configure Puppet and its subsidiary components. These are the files you will likely change to accomodate the needs of your environment.

### <i>Where</i>

On \*nix nodes, Puppet Enterprise's configuration files all live under `/etc/puppetlabs`.

On Windows nodes, Puppet Enterprise's configuration files all live under `<COMMON_APPDATA>\PuppetLabs`. The location of this folder [varies by Windows version](./install_windows.html#data-directory); in 2008 and 2012, its default location is `C:\ProgramData\PuppetLabs\`.

PE's various components all have subdirectories inside this main data directory:

* Puppet's `confdir` is in the `puppet` subdirectory. This directory contains the [`puppet.conf`](/puppet/3.6/reference/config_file_main.html) file, the site manifest (`manifests/site.pp`), and the `modules` directory.
* [The orchestration engine](orchestration_overview.html)'s config files are in the `mcollective` subdirectory on all agent nodes, as well as the `activemq` subdirectory and the `/var/lib/peadmin` directories on the puppet master. The default files in these directories are managed by Puppet Enterprise, but you can add [plugin config files](./orchestration_adding_actions.html#step-4-configure-the-plugin-optional) to the `mcollective/plugin.d` directory.
* The console's config files are in the `puppet-dashboard`, `rubycas-server`, and `console-auth` subdirectories.
* PuppetDB's config files are in the `puppetdb` subdirectory.

## Log Files

### <i>What</i>
The software distributed with Puppet Enterprise generates the following log files, which can be found as follows.

### <i>Where</i>

### Puppet Master Logs

- `/var/log/pe-httpd/access.log`
- `/var/log/pe-httpd/puppetmasteraccess.log` contains all the endpoints that have been accessed with the puppet master REST API.

### Puppet Agent Logs

The puppet agent service logs its activity to the syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux and `/var/adm/messages` on Solaris.

### ActiveMQ Logs

- `/var/log/pe-activemq/wrapper.log`
- `/var/log/pe-activemq/activemq.log`
- `/var/opt/puppet/activemq/data/kahadb/db-1.log`
- `/var/opt/puppet/activemq/data/audit.log`

### Orchestration Service Log

- `/var/log/pe-mcollective/mcollective.log` maintained by the orchestration service, which is installed on all nodes.
- `/var/log/pe-mcollective/mcollective_audit.log/` exists on all nodes that have mcollective installed; logs any mcollective actions run on the node, including information about the client that called the node


### Console Logs

- `/var/log/pe-httpd/puppetdashboard.error.log`
- `/var/log/pe-puppet-dashboard/delayed_job.log`
- `/var/log/pe-puppet-dashboard/mcollective_client.log`
- `/var/log/pe-puppet-dashboard/production.log`
- `/var/log/pe-puppet-dashboard/event-inspector.log`
- `/var/log/pe-puppet-dashboard/certificate_manager.log`
- `/var/log/pe-puppet-dashboard/live-management.log`
- `/var/log/pe-console-auth/auth.log`
- `/var/log/pe-console-auth/cas_client.log`
- `/var/log/pe-console-auth/cas.log`
- `/var/log/pe-httpd/puppetdashboard.access.log` contains all the endpoints that have been accessed in the console.
- `var/log/pe-puppet-dasboard/failed_reports/` contains a collection of any reports that fail to upload the to the dashboard.
- `/var/log/pe-httpd/error.log` contains errors related to Passenger. Console errors that don't get logged anywhere else can be found in this log. If you have problems with the console or Puppet, this log may be useful.

### Database Log

- `/var/log/pe-puppetdb/pe-puppetdb.log`

### Miscellaneous Logs

These files may or may not be present.

- `/var/log/pe-httpd/other_vhosts_access.log`
- `/var/log/pe-puppet/masterhttp.log`
- `/var/log/pe-puppet/rails.log`


### Puppet Enterprise Components

PE 3.2 includes the following major components:

 * Puppet 3.4.3
 * PuppetDB 1.5.2
 * Facter 1.7.5
 * MCollective 2.2.4
 * ActiveMQ 5.9.0
 * Live Management: 1.3.0
 * Cloud Provisioner 1.1.6
 * Hiera 1.3.2
 * Dashboard 2.1.1
 * PostgreSQL 9.2.7
 * Ruby 1.9.3
 * Augeas 1.1.0
 * Passenger 4.0.29
 * Java 1.7.0
 * OpenSSL 1.0.01

### Tools

Puppet Enterprise installs several suites of command line tools to help you work with the major components of the software. These include:

- **Puppet Tools:** Tools that control basic functions of Puppet such as `puppet master,` `puppet apply` and `puppet cert.`
    See the Puppet reference manual page on [Puppet's commands](/puppet/3.6/reference/services_commands.html) for more information.
- **Cloud Provisioning Tools:** Tools used to provision new nodes. Mostly based around the `node` subcommand, these tools are used for tasks such as creating or destroying virtual machines, classifying new nodes, etc. See the [Cloud Provisioning section](./cloudprovisioner_overview.html)  for more information.
- **Orchestration Tools:** Tools used to orchestrate simultaneous actions across a number of nodes. These tools are built on the MCollective framework and are accessed either via the `mco` command or via the __Live Management__ page of the PE console. See the [Orchestration section](./orchestration_overview.html) for more information.
- **Module Tools:** The Module tool is used to access and create Puppet Modules, which are reusable chunks of Puppet code users have written to automate configuration and deployment tasks. For more information, and to access modules, visit the [Puppet Forge](http://forge.puppetlabs.com/).
- **Console:** The console is Puppet Enterprise's GUI web interface. The console provides tools to view and edit resources on your nodes, view reports and activity graphs, trigger Puppet runs, etc. See the [Console section](./console_accessing.html) of the Puppet Manual for more information.

For more details, you can also refer to the man page for a given command or subcommand.

### Services

PE uses the following services:

- **`pe-activemq`** --- The ActiveMQ message server, which passes messages to the MCollective servers on agent nodes. Runs on servers with the puppet master component.
- **`pe-httpd`** --- Apache 2, which manages and serves puppet master and the console on servers with those components. (Note that PE uses Passenger to run puppet master, instead of running it as a standalone daemon.)
- **`pe-mcollective`** --- The orchestration (MCollective) daemon, which listens for orchestration messages and invokes actions. Runs on every agent node.
- **`pe-memcached`** --- The PE console memcached daemon. Runs on the same node as the PE console.
- **`pe-puppet`** (on EL and Debian-based platforms) --- The puppet agent daemon. Runs on every agent node.
- **`pe-puppet-dashboard-workers`** --- A supervisor that manages the console's background processes. Runs on servers with the console component.
- **`pe-puppetdb`** and **`pe-postgresql`** --- Daemons that manage and serve the database components. Note that pe-postgresql is only created if we install and manage PostgreSQL for you.

### User Accounts

PE creates the following users:

- **`peadmin`** --- An administrative account which can invoke orchestration actions. This is the only PE user account intended for use in a login shell. See [the "Invoking Orchestration Actions" page of this manual](./orchestration_invoke_cli.html) for more about this user. This user exists on servers with the puppet master role.
- **`pe-puppet`**  --- A system user which runs the puppet master processes spawned by Passenger.
- **`pe-apache`** --- A system user which runs Apache (`pe-httpd`).
- **`pe-activemq`** --- A system user which runs the ActiveMQ message bus used by MCollective.
- **`puppet-dashboard`** --- A system user which runs the console processes spawned by Passenger.
- **`pe-puppetdb`** --- A system user with root access to the db.
- **`pe-auth`** --- Puppet Console Auth User
- **`pe-memcached`** --- Puppet Enterprise Memcached Daemon User
- **`pe-postgres`** --- A system user with access to the pe-postgreSQL instance. Note that this user is only created if we install and manage PostgreSQL for you.

### Certificates

PE generates a number of certificates at install. These are:

- **`pe-internal-dashboard`** ---  The certificate for the puppet dashboard.
- **`<user-entered console certname>`** ---  The certificate for the PE console. Only generated if the user has chosen to install the console in a split role configuration.
- **`<user entered PuppetDB certname>`** ---  The certificate for the database role. Only generated if the user has chosen to install the database in a split role configuration.
- **` <user-entered master certname> `** --- This certificate is either generated at install if the puppet master and console are the same machine or is signed by the master if the console is on a separate machine.
- **`pe-internal-mcollective-servers`** --- A shared certificate generated on the puppet master and shared to all agent nodes.
- **`pe-internal-peadmin-mcollective-client`** --- The orchestration certificate for the peadmin account on the puppet master.
- **`pe-internal-puppet-console-mcollective-client`** --- The orchestration certificate for the PE console/live management
- **`pe-internal-broker`** ---  The certificate generated for the activemq instance running over SSL on the puppet master. Added to /etc/puppetlabs/activemq/broker.ks.

A fresh PE install should thus give the following list of certificates:

    root@master:~# puppet cert list --all
    + "master"                                        (40:D5:40:FA:E2:94:36:4D:C4:8C:CE:68:FB:77:73:AB) (alt names: "DNS:master", "DNS:puppet", "DNS:puppet.soupkitchen.internal")
    + "pe-internal-broker"                            (D3:E1:A8:B1:3A:88:6B:73:76:D1:E3:DA:49:EF:D0:4D) (alt names: "DNS:master", "DNS:master.soupkitchen.internal", "DNS:pe-internal-broker", "DNS:stomp")
    + "pe-internal-dashboard"                         (F9:10:E7:7F:97:C8:1B:2F:CC:D9:F1:EA:B2:FE:1E:79)
    + "pe-internal-mcollective-servers"               (96:4F:AA:75:B5:7E:12:46:C2:CE:1B:7B:49:FF:05:49)
    + "pe-internal-peadmin-mcollective-client"        (3C:4D:8E:15:07:41:18:E2:21:57:19:01:2E:DB:AB:07)
    + "pe-internal-puppet-console-mcollective-client" (97:10:76:B5:3E:8D:02:D2:3D:A6:43:F4:89:F4:8B:94)

### Documentation

Man pages for the Puppet subcommands are generated on the fly. To view them, run `puppet man <SUBCOMMAND>`.

The `pe-man` command from previous versions of Puppet Enterprise is no longer functional. Use the above method instead.



* * *

- [Next: Accessing the Console](./console_accessing.html)
