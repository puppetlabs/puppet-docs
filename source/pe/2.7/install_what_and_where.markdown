---
layout: default
title: "PE 2.7  » Installing » What Gets Installed Where?"
canonical: "/pe/latest/install_what_and_where.html"
---



## License File


Your PE license file (which was emailed to you when you purchased Puppet Enterprise) should be placed at `/etc/puppetlabs/license.key`.

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master.

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>.

## Software

### <i>What</i>

All working components of PE, excluding configuration files. These are files you are not likely to need to change.

### <i>Where</i>

All PE software (excluding config files) is installed under `/opt/puppet`.

* Executable binaries are in `/opt/puppet/bin` and `/opt/puppet/sbin`.
* Optionally, you can choose at install time to symlink the most common binaries into `/usr/local/bin`.
* The Puppet modules included with PE are installed in `/opt/puppet/share/puppet/modules`. Don't edit this directory to add modules of your own. Instead, install them in `/etc/puppetlabs/puppet/modules`.
* MCollective plugins are installed in `/opt/puppet/libexec/mcollective/`. If you are adding new plugins to your PE agent nodes, you should distribute them via Puppet.

## Configuration Files

### <i>What</i>

 Files used to configure Puppet and its subsidiary components. These are the files you will likely change to accomodate the needs of your environment.

### <i>Where</i>

Puppet Enterprise's configuration files all live under `/etc/puppetlabs`, with subdirectories for each of PE's components.

* Puppet's `confdir` is in `/etc/puppetlabs/puppet`. This directory contains the [`puppet.conf`](/puppet/3.6/reference/config_file_main.html) file, the site manifest (`manifests/site.pp`), and the `modules` directory.
* [MCollective's](orchestration_overview.html) config files are in `/etc/puppetlabs/mcollective`.
* The console's config files are in `/etc/puppetlabs/puppet-dashboard`.

## Log Files

### <i>What</i>
The software distributed with Puppet Enterprise generates the following log files, which can be found as follows.

### <i>Where</i>

### Puppet Master Logs

- `/var/log/pe-httpd/access.log`
- `/var/log/pe-httpd/error.log`

These logs are solely for HTTP activity; the puppet master service logs most of its activity to the syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux and `/var/adm/messages` on Solaris.

### Puppet Agent Logs

The puppet agent service logs its activity to the syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux and `/var/adm/messages` on Solaris.

### ActiveMQ Logs

- `/var/log/pe-activemq/wrapper.log`
- `/var/log/pe-activemq/activemq.log`
- `/var/opt/puppet/activemq/data/kahadb/db-1.log`
- `/var/opt/puppet/activemq/data/audit.log`

### Orchestration Service Log

This log is maintained by the orchestration service, which is installed on all nodes.

- `/var/log/pe-mcollective/mcollective.log`

### Console Log

- `/var/log/pe-httpd/puppetdashboard.access.log`
- `/var/log/pe-httpd/puppetdashboard.error.log`
- `/var/log/pe-puppet-dashboard/delayed_job.log`
- `/var/log/pe-puppet-dashboard/mcollective_client.log`
- `/var/log/pe-puppet-dashboard/production.log`

### Miscellaneous Logs

These files may or may not be present.

- `/var/log/pe-httpd/other_vhosts_access.log`
- `/var/log/pe-puppet/masterhttp.log`
- `/var/log/pe-puppet/rails.log`


## Puppet Enterprise Components

### Tools

Puppet Enterprise installs several suites of command line tools to help you work with the major components of the software. These include:

- **Puppet Tools:** Tools that control basic functions of Puppet such as `puppet master,` `puppet apply` and `puppet cert.`
    See the Puppet reference manual page on [Puppet's commands](/puppet/3.6/reference/services_commands.html) for more information.
- **Cloud Provisioning Tools:** Tools used to provision new nodes. Mostly based around the `node` subcommand, these tools are used for tasks such as creating or destroying virtual machines, classifying new nodes, etc. See the [Cloud Provisioning Section](./cloudprovisioner_overview.html)  for more information.
- **Orchestration Tools:** Tools used to orchestrate simultaneous actions across a number of nodes. These tools are built on the MCollective framework and are accessed either via the `mco` command or via the Live Management tab of the PE console. See the [Orchestration Section](./orchestration_overview.html) for more information.
- **Module Tools:** The Module tool is used to access and create Puppet Modules, which are reusable chunks of Puppet code users have written to automate configuration and deployment tasks. For more information, and to access modules, visit the [Puppet Forge](http://forge.puppetlabs.com/).
- **Console:** The console is Puppet Enterprise's GUI web interface. The console provides tools to view and edit resources on your nodes, view reports and activity graphs, trigger Puppet runs, etc. See the [Console Section](./console_accessing.html) of the Puppet Manual for more information.

For more details, you can also refer to the man page for a given command or subcommand.

### Services

PE uses the following services:

- **`pe-puppet`** (on EL platforms) and **`pe-puppet-agent`** (on Debian-based platforms) --- The puppet agent daemon. Runs on every agent node.
- **`pe-httpd`** --- Apache 2, which manages and serves puppet master and the console on servers with those roles. (Note that PE uses Passenger to run puppet master, instead of running it as a standalone daemon.)
- **`pe-mcollective`** --- The MCollective server. Runs on every agent node.
- **`pe-puppet-dashboard-workers`** --- A supervisor that manages the console's background processes. Runs on servers with the console role.
- **`pe-activemq`** --- The ActiveMQ message server, which passes messages to the MCollective servers on agent nodes. Runs on servers with the puppet master role.

### User Accounts

PE creates the following users:

- **`peadmin`** --- An administrative account which can issue MCollective client commands. This is the only PE user account intended for use in a login shell. See [the section on orchestration](./orchestration_overview.html) for more about this user. This user exists on servers with the puppet master role, and replaces the `mco` user that was present in PE 1.2.
- **`pe-puppet`**  --- A system user which runs the puppet master processes spawned by Passenger.
- **`pe-apache`** --- A system user which runs Apache (`pe-httpd`).
- **`pe-activemq`** --- A system user which runs the ActiveMQ message bus used by MCollective.
- **`puppet-dashboard`** --- A system user which runs the console processes spawned by Passenger.

### Certificates

PE generates a number of certificates at install. These are:

- **`pe-internal-dashboard`** ---  The certificate for the puppet dashboard.
- **`<user entered console certname>`** ---  The certificate for the PE console. Only generated if the user has chosen to install the console.
- **`  <user entered master certname> `** --- This certificate is either generated at install if the puppet master and console are the same machine or is signed by the master if the console is on a separate machine.
- **`pe-internal-mcollective-servers`** --- A shared certificate generated on the puppet master and shared to all Mcollective servers.
- **`pe-internal-peadmin-mcollective-client`** --- The certificate for the peadmin account on the puppet master.
- **`pe-internal-puppet-console-mcollective-client`** --- The certificate for the PE Console/Live Management
- **`pe-internal-broker`** ---  The certificate generated for the activemq instance running over SSL on the puppet master. Added to /etc/puppetlabs/activemq/broker.ks.

A fresh PE install should thus give the following list of certificates:

~~~ ruby
root@master:~# puppet cert list --all
+ "master"                                        (40:D5:40:FA:E2:94:36:4D:C4:8C:CE:68:FB:77:73:AB) (alt names: "DNS:master", "DNS:puppet", "DNS:puppet.soupkitchen.internal")
+ "pe-internal-broker"                            (D3:E1:A8:B1:3A:88:6B:73:76:D1:E3:DA:49:EF:D0:4D) (alt names: "DNS:master", "DNS:master.soupkitchen.internal", "DNS:pe-internal-broker", "DNS:stomp")
+ "pe-internal-dashboard"                         (F9:10:E7:7F:97:C8:1B:2F:CC:D9:F1:EA:B2:FE:1E:79)
+ "pe-internal-mcollective-servers"               (96:4F:AA:75:B5:7E:12:46:C2:CE:1B:7B:49:FF:05:49)
+ "pe-internal-peadmin-mcollective-client"        (3C:4D:8E:15:07:41:18:E2:21:57:19:01:2E:DB:AB:07)
+ "pe-internal-puppet-console-mcollective-client" (97:10:76:B5:3E:8D:02:D2:3D:A6:43:F4:89:F4:8B:94)
~~~

### Documentation

Man pages for the Puppet subcommands are generated on the fly. To view them, run `puppet man <SUBCOMMAND>`.

The `pe-man` command from previous versions of Puppet Enterprise is no longer functional. Use the above method instead.



* * *

- [Next: Accessing the Console](./console_accessing.html)
