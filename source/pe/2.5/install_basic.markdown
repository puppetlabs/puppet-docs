---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Installing » Installing PE"
subtitle: "Installing Puppet Enterprise"
---


[downloadpe]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This chapter covers \*nix operating systems. To install PE on Windows, see [Installing Windows Agents](./install_windows.html).

Downloading PE
-----

Before installing Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].


### Choosing an Installer Tarball

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball. 

> Note: The universal tarball is simpler to use, but is roughly ten times the size of a version-specific tarball.

Puppet Enterprise for Windows is available as a single .msi installer package. 

#### Available \*nix Tarballs

|      Filename ends with...        |                     Will install...                 |
|-----------------------------------|-----------------------------------------------------|
| `-all.tar`                        | anywhere                                            |
| `-debian-<version and arch>.tar`  | on Debian                                           |
| `-el-<version and arch>.tar`      | on RHEL, CentOS, Scientific Linux, or Oracle Linux  |
| `-sles-<version and arch>.tar`    | on SUSE Linux Enterprise Server                     |
| `-solaris-<version and arch>.tar` | on Solaris                                          |
| `-ubuntu-<version and arch>.tar`  | on Ubuntu LTS                                       |


Starting the Installer
-----

* Unarchive the installer tarball, usually with `tar -xzf <TARBALL FILE>`.
* Navigate to the resulting directory in your shell.
* Run the `puppet-enterprise-installer` script with root privileges:

        # sudo ./puppet-enterprise-installer
* Answer the interview questions to [customize your installation](#customizing-your-installation). 
* Log into the puppet master server and [sign the new node's certificate](#signing-agent-certificates).
* If you have purchased PE and are installing the puppet master, [copy your license key into place](#verifying-your-license).

The installer can also be run non-interactively; [see the chapter on automated installation][automated] for details.

Note that after the installer has finished installing and configuring PE, it will save your interview answers to a file called `answers.lastrun`.

[automated]: ./install_automated.html

Using the Installer
-----

The PE installer configures Puppet by asking a series of questions. Most questions have a default answer (displayed in brackets), which you can accept by pressing enter without typing a replacement. For questions with a yes or no answer, the default answer is capitalized (e.g. "`[y/N]`").


### Installer Options

The installer will accept the following command-line flags:

`-h`
: Display a brief help message.

`-s <ANSWER FILE>`
: Save answers to file and quit without installing.

`-a <ANSWER FILE>`
: Read answers from file and fail if an answer is missing.

`-A <ANSWER FILE>`
: Read answers from file and prompt for input if an answer is missing.

`-D`
: Display debugging information.

`-l <LOG FILE>`
: Log commands and results to file.

`-n`
: Run in 'noop' mode; show commands that would have been run during installation without running them.


Selecting Roles
-----

First, the installer will ask which of PE's **roles** to install. The roles you choose will determine which other questions the installer will ask.

### The Puppet Agent Role

This role should be installed on **every node** in your deployment, including the master and console nodes. (If you choose the puppet master or console roles, the puppet agent role will be installed automatically.) Nodes with the puppet agent role can:

* Run the puppet agent daemon, which pulls configurations from the puppet master and applies them.
* Listen for MCollective messages, and invoke MCollective agent actions when they receive a valid command.
* Report changes to any resources being audited for PE's compliance workflow.

### The Puppet Master Role

In most deployments, this role should be installed on **one node;** installing multiple puppet masters requires additional configuration. The puppet master must be a robust, dedicated server; see the [system requirements](./install_system_requirements.html) for more detail. The puppet master server can:

* Compile and serve configuration catalogs to puppet agent nodes.
* Route MCollective messages through its ActiveMQ server.
* Issue valid MCollective commands (from an administrator logged in as the `peadmin` user). 

### The Console Role

This role should be installed on **one node.** It should usually run on its own dedicated server, but can also run on the same server as the puppet master. The console server can: 

* Serve the console web interface, with which administrators can directly edit resources on nodes, trigger immediate Puppet runs, group and assign classes to nodes, view reports and graphs, view inventory information, approve and reject audited changes, and invoke MCollective agent actions. 
* Collect reports from, and serve node information to the puppet master.

### The Cloud Provisioner Role

This optional role can be installed on a computer where administrators have shell access. Since it requires confidential information about your cloud accounts to function, it should be installed on a secure system. Administrators can use the cloud provisioner tools to:

* Create new VMware and Amazon EC2 virtual machine instances.
* Install Puppet Enterprise on any virtual or physical system.
* Add newly provisioned nodes to a group in the console. 


Customizing Your Installation
-----

After you choose the roles for the system you're installing onto, the installer will ask questions to configure those roles.

### Puppet Master Questions

#### Certname

The certname is the puppet master's unique identifier. It should be a DNS name at which the master server can be reliably reached, and defaults to its fully-qualified domain name. 

(If the master's certname is not one of its DNS names, you [may need to edit puppet.conf after installation][bucket-troubleshooting].)

[bucket-troubleshooting]: ./trouble_common_problems.html#can-agents-reach-the-filebucket-server

#### Valid DNS Names

The master's certificate contains a static list of valid DNS names, and agents won't trust the master if they contact it at an unlisted address. You should make sure that this list contains the DNS name or alias you'll be configuring your agents to contact.

The valid DNS names setting should be a comma-separated list of hostnames. The default set of DNS names will be derived from the certname you chose, and will include the default puppet master name of "puppet."

#### Location of the Console Server

If you are splitting the puppet master and console roles across different machines, the installer will ask you for the hostname and port of the console server.

### Console Questions

The console is usually run on the same server as the puppet master, but can also be installed on a separate machine. **If you are splitting the console and puppet master roles, install the console _after_ the puppet master.**

#### Port

You must choose a port on which to serve the console's web interface. If you aren't already serving web content from this machine, it will default to **port 443,** so you can reach it at `https://yourconsoleserver` without specifying a port.

If the installer detects another web server on the node, it will suggest the first open port at or above 3000.

#### User Name and Password

As the console's web interface is a major point of control for your infrastructure, access is restricted with a user name and password. Additional users and passwords can be added later with Apache's standard authentication tools. 

The only forbidden characters for a console password are `\` (backslash), `'` (single quote), and `$$` (two dollar signs in a row). 

#### Inventory Certname and DNS Names (Optional)

If you are splitting the master and the console roles, the console will maintain an inventory service to collect facts from the puppet master. Like the master, the inventory service needs a unique certname and a list of valid DNS names. 

#### Database

The console needs a pair of MySQL databases and a MySQL user in order to operate. If a MySQL server isn't already present on this system, the installer can automatically configure everything the console needs; just confirm that you want to install a new database server, and configure the following settings:

* A password for MySQL's root user
* A name for the console's primary database
* A MySQL user name for the console
* A password for the console's user

The only forbidden characters for a database password are `\` (backslash), `'` (single quote), and `$$` (two dollar signs in a row). 

If you don't install a new database server, you can either manually create a database and MySQL user for the console and configure the settings above with the correct information, or allow the installer to log into the MySQL server as root and automatically configure the databases.

Note that if you want to automatically configure databases on a remote database server, you must make sure the root MySQL user is allowed to log in remotely. 

If you are not automatically configuring the databases, you can create the necessary MySQL resources in a secondary shell session while the installer is waiting for input. The SQL commands you need will resemble the following:

    CREATE DATABASE console CHARACTER SET utf8;
    CREATE DATABASE console_inventory_service CHARACTER SET utf8;
    CREATE USER 'console'@'localhost' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON console.* TO 'console'@'localhost';
    GRANT ALL PRIVILEGES ON console_inventory_service.* TO 'console'@'localhost';
    FLUSH PRIVILEGES;

**Note that the names of the two databases are related:** the name of the inventory service database must start with the name of the primary console database, followed by `_inventory_service`. 

**Note also that the hostname for the console user will differ if you are using a remote database server.**

Consult the MySQL documentation for more info.

A local database is best, but you can also create a database on a remote server. If you do, you'll need to answer `Y` when asked if your MySQL server is remote, and provide:

* The database server's hostname
* The database server's port (default: 3306)


### Puppet Agent Questions

#### Certname

The certname is the agent node's unique identifier.

This defaults to the node's fully-qualified domain name, but any arbitrary string can be used. If hostnames change frequently at your site or are otherwise unreliable, you may wish to use UUIDs or hashed firmware attributes for your agent certnames.

#### Puppet Master Hostname

Agent nodes need the hostname of a puppet master server. This must be one of the valid DNS names you chose when installing the puppet master.

This setting defaults to `puppet`.

Final Questions
-----

### Vendor Packages

Puppet Enterprise may need some extra system software from your OS vendor's package repositories. If any of this software isn't yet installed, the installer will list the packages it needs and offer to automatically install them. If you decline, it will exit so you can install the necessary packages manually before installing.

**A note about Java and MySQL under Enterprise Linux variants:** Java and MySQL packages provided by Oracle can satisfy the puppet master and console roles' Java and MySQL dependencies, but the installer can't make that decision automatically and will default to using the OS's packages. If you wish to use Oracle's packages instead of the OS's, you must first use RPM to manually install the `pe-virtual-java` and/or `pe-virtual-mysql` packages included with Puppet Enterprise: 

    # sudo rpm -ivh packages/pe-virtual-java-1.0-1.pe.el5.noarch.rpm

Find these in the installer's `packages/` directory. Note that these packages may have additional ramifications if you later install other software that depends on OS MySQL or Java packages. 


### Convenience Links

PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`. If you want to make the Puppet tools more visible to all users, the installer can make symlinks in `/usr/local/bin` for the `facter, puppet, puppet-module, pe-man`, and `mco` binaries. 

### Confirming Installation

The installer will offer a final chance to confirm your answers before installing. 

After Installing
-----

### Signing Agent Certificates

Before nodes with the puppet agent role can fetch configurations or appear in the console, an administrator has to sign their certificate requests. This helps prevent unauthorized nodes from intercepting sensitive configuration data.

During installation, PE will automatically submit a certificate request to the puppet master. Before the agent can retrieve any configurations, a user will have to sign a certificate for it.

**Certificate signing is done on the puppet master node.** To view the list of pending certificate requests, run:

    $ sudo puppet cert list

To sign one of the pending requests, run:

    $ sudo puppet cert sign <name>

After signing a new node's certificate, it may take up to 30 minutes before that node appears in the console and begins retrieving configurations. 

### Verifying Your License

When you purchased Puppet Enterprise, you should have been sent a `license.key` file that lists how many nodes you can deploy. For PE to run without logging license warnings, **you should copy this file to the puppet master node as `/etc/puppetlabs/license.key`.** If you don't have your license key file, please email <sales@puppetlabs.com> and we'll re-send it.


* * *

Next: [Installing: Upgrading](./install_upgrading.html) &rarr;
