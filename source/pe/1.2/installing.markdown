---
layout: default
title: "PE 1.2 Manual: Installing Puppet Enterprise"
canonical: "/pe/latest/install_basic.html"
---

{% include pe_1.2_nav.markdown %}

Installing Puppet Enterprise
============================

Puppet Enterprise is the easiest way to install Puppet in a production-ready state --- after some quick pre-install sanity checks, simply run the interactive installer and get started immediately.

Preparing to Install
------------------

Before installing Puppet Enterprise at your site, you should:

* Decide in advance which server will fill the role of puppet master, and decide whether it will also run Puppet Dashboard. **If you are splitting these two roles, you must perform some [extra configuration][dashboardconfig] after installation.**
* Ensure that the puppet master server can be reached via domain name lookup by all of the future puppet agent nodes at the site.
* Optionally, add a CNAME record to your site's DNS configuration (or an alias in the relevant `/etc/hosts` files) to ensure that your puppet master can also be reached at the hostname `puppet` --- since this is the default puppet master hostname, using it can simplify installation on your agent nodes.
* Configure your firewalls to accomodate Puppet Enterprise's network traffic.
    * All agent nodes must be able to send send requests to the puppet master on ports **8140** (for Puppet) and **61613** (for MCollective).
    * The puppet master must be able to accept inbound traffic from agents on ports **8140** (for Puppet) and **61613** (for MCollective).
    * Any hosts you will be using to access Puppet Dashboard must be able to communicate with the Dashboard server on port **3000.**
    * If you will be invoking MCollective client commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.**
    * If you will be running Puppet Dashboard and puppet master on separate servers, the Dashboard server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **3000** and **8140.** The Dashboard server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.

You should plan to install PE on the puppet master (and the Dashboard server, if you have chosen to separate the two) **before** installing on any agent nodes.

Choosing Your Installer Tarball
------

Before installing Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].

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

Installing PE
-----

To install PE, unarchive the tarball, navigate to the resulting directory, and run the `./puppet-enterprise-installer` script with root privileges in your shell; this will start the installer in interactive mode and guide you through the process of customizing your installation. After you've finished, it will save your answers in a file called `answers.lastrun`, install the selected software, and configure and enable all of the necessary services.

The installer can also be run non-interactively; [see below][noninteractive] for details.

Customizing Your Installation
-----

The PE installer configures Puppet by asking a series of questions. Most questions have a default answer (displayed in brackets), which you can accept by pressing enter without typing a replacement. For questions with a yes or no answer, the default answer is capitalized (e.g. "`[y/N]`").

### Roles

First, the installer will ask which of PE's [three roles](./overview.html#roles) (puppet master, Puppet Dashboard, and puppet agent) to install. The roles you apply will determine which other questions the installer will ask.

If you choose the puppet master or Puppet Dashboard roles, the puppet agent role will be installed automatically.

### Puppet Master Options

#### Certname

The puppet master's certname --- its unique identifier --- should always be its fully-qualified domain name. The installer will automatically detect this, but offers the chance to change it if necessary.

#### Certified Hostnames

The puppet master's certified hostnames should be a colon-separated list of every hostname (short and fully-qualified) you use to reach it. This list will be included in the master's SSL certificate, and agent nodes will refuse to connect to a puppet master unless the hostname at which they reached it is included in the certificate.

This list should at least include the master's fully-qualified domain name and its short hostname, but may also include aliases like `puppet` and `puppet.<domain>.com`. If you ensure that the hostname `puppet` resolves to your puppet master and is included in the master's certificate, you can use the default puppet master hostname when installing subsequent agent nodes.

#### Integration with Puppet Dashboard

The installer will ask if you wish to:

* Send reports to Dashboard
* Use Dashboard as a node classifier
* Forward facts to Dashboard's inventory service

(The latter question won't appear unless you chose not to install Dashboard on the same machine as the master; if they are running on the same machine, inventory viewing will be enabled by default.) 

For most users, we recommend doing all three. If you selected any of them, the installer will then ask for Dashboard's hostname and port.

### Puppet Dashboard Options

Puppet Dashboard is usually run on the same server as the puppet master, but can also be installed on a separate machine; **if you choose to do so, you will need to do some [additional configuration][dashboardconfig] after installing.**

#### Port

By default, Dashboard will run on port 3000. If the server you install it on is not running any other webserver instances, you may wish to use the standard HTTP port of 80 instead; if so, remember to [point puppet master to the correct port during installation](#integration-with-puppet-dashboard). If you need to change puppet's settings later, edit the `reporturl` setting  in [puppet.conf](/puppet/3.6/reference/config_file_main.html) and the `BASE=` line in `/etc/puppetlabs/puppet-dashboard/external_node`.

#### Inventory Certname/Certified Hostnames

Dashboard will automatically use the puppet master's inventory service if you install it on the same server, but will have to maintain the inventory service[^technically] itself if you're installing it on a separate server.

Like puppet master, the inventory service needs a certname and a list of certified hostnames, which include the Dashboard server's short hostname and fully-qualified domain name. Unlike puppet master, its certified hostnames shouldn't include `puppet`.

Note that if you split Dashboard and master and wish to enable Dashboard's inventory and filebucket features, **you will need to [exchange certificates between Dashboard and the puppet master after installation][dashboardconfig].**


[^technically]: Under the hood, this is a private instance of puppet master that doesn't serve catalogs to agent nodes.

#### MySQL Server

Dashboard needs a MySQL server, user, and database to operate. If MySQL isn't already installed on Dashboard's server, the installer can automatically configure everything Dashboard needs; just confirm that you want to install a new database server, and answer the questions about:

* MySQL's root user's password
* A name for Dashboard's database
* Dashboard's database user (default: "dashboard")
* A password for Dashboard's user

If you choose not to install a new database server, you'll need to have already created a database and MySQL user[^createdb] for Dashboard prior to installation, and to have granted that user all privileges on the database. If the database server is on a remote machine, you'll also need to provide the installer with:

* The database server's hostname
* The database server's port (default: 3306)

[^createdb]: The SQL commands to do so will likely resemble the following: <br><br>`CREATE DATABASE dashboard CHARACTER SET utf8;`<br>`CREATE USER 'dashboard'@'localhost' IDENTIFIED BY 'password';`<br>`GRANT ALL PRIVILEGES ON dashboard.* TO 'dashboard'@'localhost';`


### Puppet Agent Options


#### Unique Identifier ("Certname")

Like the puppet master, each puppet agent node needs a unique identifier for its SSL certificate. Unlike the master, this doesn't have to be a valid hostname, and can be any unique string that identifies the node.

If domain names change frequently at your site or are otherwise unreliable, you may wish to investigate other schemes of node identification, such as UUIDs or hashes of some permanent firmware attribute.

#### Puppet Master Hostname

By default, puppet agent will attempt to connect to a puppet master server at the hostname `puppet`. If your puppet master isn't reachable at that hostname, you should override this.

#### Using Pluginsync

Puppet agent's pluginsync feature will download executable Ruby code (such as custom facts, types, and providers) from the puppet master. This should almost always be enabled, as Puppet Enterprise requires it to activate MCollective on agent nodes.

### Development Libraries

As Puppet Enterprise maintains its own copy of Ruby and `gem`, you will need PE-specific copies of the Ruby development libraries if you intend to install any gems with native bindings.

Most users will not need to install the Ruby development libraries on any of their nodes. If you do not install the development libraries when installing Puppet Enterprise and find that you need them later, you can install them manually; see "Configuring and Troubleshooting" below.

### Convenience Links

Puppet Enterprise installs the Puppet software and manpages into subdirectories of `/opt/puppet`, which aren't included in your system's default `$PATH` or `$MANPATH`. For ease of use, the installer can create symbolic links to the Puppet executables in `/usr/local/bin`.

### Additional Packages

Puppet Enterprise requires certain software from your operating system vendor's package repositories. If any of this software isn't yet installed, the installer will list which packages (if any) are needed and offer to automatically install them. If you decline, the installer will exit so you can install the necessary packages manually.


Post-install Configuration
-----

### Signing Agent Certificates

When installing the puppet agent role on a new node, the installer will automatically submit a certificate request to the puppet master. Before the agent will be able to receive any configurations, a user will have to sign the certificate from the puppet master. To view the list of pending certificate signing requests, run:

    puppet cert list

To sign one of the pending requests, run:

    puppet cert sign <name>


[dashboardconfig]: #configuring-a-stand-alone-dashboard-server

### Configuring a Stand-Alone Dashboard Server

Most users should install Puppet Dashboard on the same server as the puppet master. However, if you need to split the two, you should install Dashboard **after** the puppet master, and do the following after installing both:

**On the Dashboard server:**

    # cd /opt/puppet/share/puppet-dashboard
    # export PATH=/opt/puppet/sbin:/opt/puppet/bin:$PATH
    # rake RAILS_ENV=production cert:request

**On the puppet master server:**

    # puppet cert sign dashboard
    # puppet cert sign <inventory service's certname>

**On the Dashboard server (in the same shell as before, with the modified PATH):**

    # rake RAILS_ENV=production cert:retrieve
    # receive_signed_cert.rb <inventory service's certname> <puppet master's hostname>
    # service pe-httpd start



[noninteractive]: #non-interactive-installation

Advanced Installation
----

### Installer Options

The Puppet Enterprise installer will accept the following command-line flags:

* `-a ANSWER_FILE` -- Read answers from file and quit with error if an answer is missing.
* `-A ANSWER_FILE` -- Read answers from file and prompt for input if an answer is missing.
* `-D` -- Display debugging information.
* `-h` -- Display a brief help message.
* `-l LOG_FILE` -- Log commands and results to file.
* `-n` -- Run in 'noop' mode; show commands that would have been run during installation without running them.
* `-s ANSWER_FILE` -- Save answers to file and quit without installing.

### Non-interactive Installation

To streamline your deployment, the Puppet Enterprise installer can run non-interactively. When run with the `-a` or `-A` flags, the installer will load an answer file specified by the user.

Answer files are simply shell scripts; they set a number of predefined variables and are sourced by the installer at runtime. Although static answer files are easily generated by running the installer with the `-s ANSWER_FILE` option (or by retrieving the `answers.lastrun` file from a previous installation), they can also be constructed by hand or with other tools, and can contain arbitrary shell code. This feature of the installer can be used to, for example, automate the generation of puppet agent certnames for sites that do not identify nodes by FQDN.

Further details and a full description of the available variables can be found in the [answer file reference](./answer_file_reference.html).

