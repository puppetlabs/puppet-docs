---
layout: default
title: "PE 3.0 » Installing » Installing PE"
subtitle: "Installing Puppet Enterprise"
canonical: "/pe/latest/install_basic.html"
---


[downloadpe]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This chapter covers \*nix operating systems. To install PE on Windows, see [Installing Windows Agents](./install_windows.html).

Downloading PE
-----

Start by downloading the [current version of Puppet Enterprise from the Puppet Labs website][downloadpe].


### Choosing an Installer Tarball

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball.

> Note: The universal tarball is simpler to use but is roughly ten times the size of a version-specific tarball.


#### Available \*nix Tarballs

|      Filename ends with...        |                     Will install...                 |
|-----------------------------------|-----------------------------------------------------|
| `-all.tar`                        | anywhere                                            |
| `-debian-<version and arch>.tar.gz`  | on Debian                                           |
| `-el-<version and arch>.tar.gz`      | on RHEL, CentOS, Scientific Linux, or Oracle Linux  |
| `-solaris-<version and arch>.tar.gz` | on Solaris                                          |
| `-ubuntu-<version and arch>.tar.gz`  | on Ubuntu LTS                                       |
| `-aix-<version and arch>.tar.gz`  | on AIX                                       |


Starting the Installer
-----

Installation will go more smoothly if you know a few things in advance. Puppet Enterprise's functions are spread across several different "roles" which get installed and configured when you run the installer. You can choose to install multiple roles on a single node or spread the roles across nodes (except for the "agent" role, which gets installed on every node). You should decide on this architecture before starting the install process. For each node where you will be installing a PE role, you should know the fully qualified domain name where that node can be reached and you should ensure that firewall rules are set up to allow access to the [required ports](./install_system_requirements.html#firewall-configuration).

When separating the roles across nodes, you should install in the following order:

  1. Master Role
  2. Database Support Role
  3. Console Role
  4. Cloud Provisioner Role
  5. Agents

With that knowledge in hand, the installation process on each node is as follows:

* Unarchive the installer tarball, usually with `tar -xzf <TARBALL FILE>`.
* Navigate to the resulting directory in your shell.
* Run the `puppet-enterprise-installer` script with root privileges:

        $ sudo ./puppet-enterprise-installer
* Answer the interview questions to [select and configure PE's roles](#selecting-roles).
* Log into the puppet master server and [sign the new node's certificate](#signing-agent-certificates).
* If you have purchased PE and are installing the puppet master, [copy your license key into place](#verifying-your-license).
* Wait 30 minutes for the next puppet run, or kick off a run manually, to get all the agents checked in.

Note that after the installer has finished installing and configuring PE, it will save your interview answers to a file called `answers.lastrun`. This file can be used as the basis for future, automated installations. For details [see the chapter on automated installation][automated].

[automated]: ./install_automated.html

Using the Installer
-----

The PE installer installs and configures Puppet Enterprise by asking a series of questions. Most questions have a default answer (displayed in brackets), which you can accept by pressing enter without typing a replacement. For questions with a yes or no answer, the default answer is capitalized (e.g. "`[y/N]`").


### Installer Options

The installer will accept the following command-line flags:

`-h`
: Display a brief help message.

`-s <ANSWER FILE>`
: Save answers to a file and quit without installing.

`-a <ANSWER FILE>`
: Read answers from a file and fail if an answer is missing.

`-A <ANSWER FILE>`
: Read answers from a file and prompt for input if an answer is missing.

`-D`
: Display debugging information.

`-l <LOG FILE>`
: Log commands and results to file.

`-n`
: Run in 'noop' mode; show commands that would have been run during installation without running them.


Selecting Roles
-----

First, the installer will ask which of PE's **roles** to install. The role(s) you choose will determine the additional questions the installer will ask.

### The Puppet Agent Role

This role should be installed on **every node** in your deployment, including the master, database support, and console nodes. (If you choose the puppet master, database support, or console roles, the puppet agent role will be installed automatically.) Nodes with the puppet agent role can:

* Run the puppet agent daemon, which pulls configurations from the puppet master and applies them.
* Listen for orchestration messages and invoke orchestration actions when they receive a valid command.
* Send data to the master for use by PuppetDB.

### The Puppet Master Role

In most deployments, this role should be installed on **one node;** installing multiple puppet masters requires additional configuration. The puppet master must be a robust, dedicated server; see the [system requirements](./install_system_requirements.html) for more detail. The puppet master server can:

* Compile and serve configuration catalogs to puppet agent nodes.
* Route orchestration messages through its ActiveMQ server.
* Issue valid orchestration commands (from an administrator logged in as the `peadmin` user).

**Note: By default, the puppet master will check for the availability of updates whenever the `pe-httpd` service restarts.** In order to retrieve the correct update information, the master will pass some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable upgrade checking can be found in the [answer file reference](./install_answer_file_reference.html#puppet-master-answers). If an update is available, a message alert you.

### The Database Support Role
This role provides required database support for PuppetDB and the console:

* PuppetDB is the fast, scalable, and reliable centralized data service for Puppet. It caches data generated by Puppet and gives you rapid access to advanced features with a powerful API.
* The console relies on data provided by a PostgreSQL server and database, both of which will be installed along with PuppetDB on the node you specify.

You can install database support on the same node as the console or onto a separate node. When installing the database support role on a separate node, you should install it BEFORE installing the console role.

Installing this role will auto-generate database user passwords. You will need these user passwords to answer some questions you'll be asked during the console installation interview. For more information, see the Console Role section below.

If you want to set up a PuppetDB database manually, the [PuppetDB configuration documentation](/puppetdb/1.3/configure.html#using-postgresql) has more information. Otherwise, the console requires two databases, one for the console and one for console_auth (used for user management), with separate admin user access for each.

If you choose to use a database server separate from the PuppetDB server, you must configure it manually. The installer cannot install and configure postgres on a remote server without PuppetDB.

**Note:** If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

### The Console Role

This role should be installed on **one node.** It should usually run on its own dedicated server, but it can run on the same server as the puppet master if that server is also running the database support role. The console server can:

* Serve the console web interface, which enables administrators to directly edit resources on nodes, trigger immediate Puppet runs, group and assign classes to nodes, view reports and graphs, view inventory information, and invoke orchestration actions.
* Collect reports from and serve node information to the puppet master.

#### Console Database

The console relies on data provided by a PostgreSQL database installed along with PuppetDB. This database can be served by a PostgreSQL server running on the same node as the console or on a separate node. The server and database files can be installed by the Puppet Enterprise installer via the database support role, or you can add the databases manually on an existing PostgreSQL server. You only need to create the database instances, the console will populate them.

IMPORTANT: If you choose not to install the database support role on the console's node, you will be prompted for the host name and port of the node you intend to use to provide database support, and you will be asked for the user passwords for accessing the databases. The database support role must be installed on that node for the console to function. You should do this BEFORE installing the console role so that you have access to the database users' passwords during installation of the console.

The database users' passwords are auto-generated when the database support role is installed and are saved in `/etc/puppetlabs/installer/database_info.install`. If you copy this file to the node where you'll be installing the console, you can [automate password entry](./install_automated.html#running-the-installer-in-automated-mode) by adding the `-A` flag and the path to the saved database.info.install file to the `puppet-enterprise-installer` command.

### The Cloud Provisioner Role

This optional role can be installed on a system where administrators have shell access. Since it requires confidential information about your cloud accounts to function, it should be installed on a secure system. Administrators can use the cloud provisioner tools to:

* Create new VMware and Amazon EC2 virtual machine instances.
* Install Puppet Enterprise on any virtual or physical system.
* Add newly provisioned nodes to a group in the console.


Customizing Your Installation
-----

After you choose the roles for the target node, the installer will ask questions to configure those roles.

### Passwords
The following characters are forbidden in all passwords: `\` (backslash), `'` (single quote),  `"` (double quote), `,` (comma), `()` (right and left parentheses), `|` (pipe), `&` (ampersand), and `$` (dollar sign). For all passwords used during installation, we recommend using only alphanumeric characters.

### Puppet Master Questions

#### Certname

The certname is the puppet master's unique identifier. It should be a DNS name at which the master server can be reliably reached, and it will default to its fully-qualified domain name.

(If the master's certname is not one of its DNS names, you may need to [edit puppet.conf after installation][bucket-troubleshooting].)

[bucket-troubleshooting]: ./trouble_comms.html#can-agents-reach-the-filebucket-server

#### Valid DNS Names

The master's certificate contains a static list of valid DNS names, and agents won't trust the master if they contact the master at an unlisted address. You should make sure that the static list contains the DNS name or alias you'll be configuring your agents to contact.

The valid DNS names setting should be a comma-separated list of hostnames. The default set of DNS names will be derived from the certname you chose and will include the default puppet master name of "puppet."

#### Location of the Console Server

If you are splitting the puppet master and console roles across different nodes, the installer will ask you for the hostname and port of the console node.

### Database Support Questions

#### Install a PostgreSQL server
The database support role includes a PostgreSQL server, which is required by both the console and PuppetDB. The installer will ask you if you wish to install a PostgreSQL server locally or use a remote database server. If you choose to use a remote database server, the installer will ask you for the host name, port, the name of the PuppetDB database, and the name and password for the PuppetDB database user.

### Console Questions

The console should usually run on its own dedicated server but can also run on the same server as the puppet master. **If you are running the console and puppet master roles on separate servers, install the console _after_ the puppet master and database support roles are installed.**

#### Port

You must choose a port on which to serve the console's web interface. If you aren't already serving web content from this machine, it will default to **port 443,** so you can reach it at `https://yourconsoleserver` without specifying a port.

If the installer detects another web server on the node, it will suggest the first open port at or above 3000.

#### User Email and Password

Access to the console's web interface is [limited to approved users and governed by a lightweight system of user roles](./console_auth.html). During installation, you must create an initial admin user for the console by providing an email address and password. Recall the limitations on characters in passwords listed [above](#passwords).

#### SMTP Server

The console's account management tools will send activation emails to new users and requires an SMTP server to do so.

* If you cannot provide an SMTP server, an admin user can manually copy and email the activation codes for new users. (Note that `localhost` will usually work as well.)
* If your SMTP server requires TLS or a user name and password, you must [perform additional configuration after installing.][smtpconfig]

[smtpconfig]: ./console_config.html#configuring-the-smtp-server

#### Databases

The console needs multiple PostgresSQL databases and PostgresSQL users in order to operate, but these can be automatically created and configured by the installer. It can also automatically install the PostgreSQL server if it isn't already present on the system.

The installer gives slightly different options to choose from depending on your system's configuration:

* Automatically install a PostgreSQL server and auto-configure databases on a local or remote server (only available if PostgreSQL is not yet installed). **This option will generate a random root PostgreSQL password,** and you will need to look it up in the saved answer file after installation finishes. A message at the end of the installer will tell you the location of the answer file.
* Auto-configure databases on an existing local or remote PostgreSQL server. You will need to provide your server's root PostgreSQL password to the installer. (Note that if you want to auto-configure databases on a remote server, you must make sure the root PostgreSQL user is allowed to log in remotely.)
* Use a set of pre-existing manually configured databases and users.

##### Manual Database Configuration

If you are manually configuring your databases, the installer will ask you to provide:

* A name for the console's primary database
* A PostgreSQL user name for the console
* A password for the console's user
* A name for the console authentication database
* A PostgreSQL user name for console authentication
* A password for the console authentication user
* A name for the PuppetDB database
* A PostgreSQL user name for the PuppetDB database
* A password for the PuppetDB user
* The database server's hostname (if remote)
* The database server's port (if remote; default: 5432)


You will also need to make sure the databases and users actually exist. The SQL commands you need will resemble the following:


    CREATE TABLESPACE "pe-console" LOCATION '/opt/puppet/var/lib/pgsql/9.2/console';
    CREATE USER "console_auth" PASSWORD 'password';
    CREATE DATABASE "console_auth" OWNER "console_auth" TABLESPACE "console" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;
    CREATE USER "console" PASSWORD 'password';
    CREATE DATABASE "console" OWNER "console" TABLESPACE "console" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;
     LC_COLLATE 'en_US.utf8' template template0;
    CREATE TABLESPACE "pe-puppetdb" LOCATION '/opt/puppet/var/lib/pgsql/9.2/puppetdb';
    CREATE USER "pe-puppetdb" PASSWORD 'password';
    CREATE DATABASE "pe-puppetdb" OWNER "pe-puppetdb" TABLESPACE "pe-puppetdb" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;

Consult the [PostgreSQL documentation](http://www.postgresql.org/docs/) for more info.


### Puppet Agent Questions

#### Certname

The certname is the agent node's unique identifier.

This defaults to the node's fully-qualified domain name, but any arbitrary string can be used. If hostnames change frequently at your site or are otherwise unreliable, you may wish to use UUIDs or hashed firmware attributes for your agent certnames.

#### Puppet Master Hostname

Agent nodes need the hostname of a puppet master server. This must be one of the valid DNS names you chose when installing the puppet master.

This setting defaults to `puppet`. The FQDN of the master is probably a better choice.

#### Optional: Override Failed Puppet Master Communications

The installer will attempt to contact the puppet master before completing the installation. If it isn't able to reach the master, it will give you a choice between correcting the puppet master hostname or continuing anyway.

Final Questions
-----

### Vendor Packages

Puppet Enterprise may need some extra system software from your OS vendor's package repositories.

If these aren't already present, the installer will offer to automatically install them. If you decline, it will exit, and you will need to install them manually before running the installer again.

### Convenience Links

PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`. If you want to make the Puppet tools more visible to all users, the installer can make symlinks in `/usr/local/bin` for the `facter, puppet, pe-man`, and `mco` binaries.

### Confirming Installation

The installer will offer a final chance to confirm your answers before installing.

After Installing
-----

### Securing the Answer File

After finishing, the installer will print a message telling you where it saved the answer file. If you automatically configured console databases, **you should save and secure this file,** as it will contain the randomly-generated root user PostgreSQL passwords. When installing the database support role, the answers file will contain the auto-generated passwords that you will need to answer questions regarding the console role.

### Signing Agent Certificates

Before nodes with the puppet agent role can fetch configurations or appear in the console, an administrator has to sign their certificate requests. This helps prevent unauthorized nodes from intercepting sensitive configuration data.

After the first puppet run (which the installer should trigger at the end of installation, or it can be triggered manually with `puppet agent -t`), the agent will automatically submit a certificate request to the puppet master. Before the agent can retrieve any configurations, a user will have to approve this certificate.

Node requests can be approved or rejected using the console's [certificate management capability](./console_cert_mgmt.html). Pending node requests are indicated in the main navigation bar. Click on this indicator to go to a page where you can see current requests and approve or reject them as needed.

![request management view](./images/console/request_mgmt_view.png)


Alternatively, you can use the command line interface (CLI). **Certificate signing with the CLI is done on the puppet master node.** To view the list of pending certificate requests, run:

    $ sudo puppet cert list

To sign one of the pending requests, run:

    $ sudo puppet cert sign <name>

After signing a new node's certificate, it may take up to 30 minutes before that node appears in the console and begins retrieving configurations. You can use live management or the CLI to trigger a puppet run manually on the node if you want to see it right away.

If you need to remove certificates (e.g., during reinstallation of a node), you can use the `puppet cert clean <node name>` command on the CLI.

### Verifying Your License

When you purchased Puppet Enterprise, you should have been sent a `license.key` file that lists how many nodes you can deploy. For PE to run without logging license warnings, **you should copy this file to the puppet master node as `/etc/puppetlabs/license.key`.** If you don't have your license key file, please email <sales@puppetlabs.com> and we'll re-send it.

Note that you can download and install Puppet Enterprise on up to ten nodes at no charge. No license key is needed to run PE on up to ten nodes.

* * *

- [Next: Upgrading](./install_upgrading.html)
