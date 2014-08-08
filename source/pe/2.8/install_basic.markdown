---
layout: default
title: "PE 2.8  » Installing » Installing PE"
subtitle: "Installing Puppet Enterprise"
canonical: "/pe/latest/install_basic.html"
---


[downloadpe]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This chapter covers \*nix operating systems. To install PE on Windows, see [Installing Windows Agents](./install_windows.html).

Downloading PE
-----

Before installing Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].


### Choosing an Installer Tarball

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball.

> Note: The universal tarball is simpler to use, but is roughly ten times the size of a version-specific tarball.


#### Available \*nix Tarballs

|      Filename ends with...        |                     Will install...                 |
|-----------------------------------|-----------------------------------------------------|
| `-all.tar`                        | anywhere                                            |
| `-debian-<version and arch>.tar.gz`  | on Debian                                           |
| `-el-<version and arch>.tar.gz`      | on RHEL, CentOS, Scientific Linux, or Oracle Linux  |
| `-sles-<version and arch>.tar.gz`    | on SUSE Linux Enterprise Server                     |
| `-solaris-<version and arch>.tar.gz` | on Solaris                                          |
| `-ubuntu-<version and arch>.tar.gz`  | on Ubuntu LTS                                       |
| `-aix-<version and arch>.tar.gz`  | on AIX                                       |


Starting the Installer
-----

* Unarchive the installer tarball, usually with `tar -xzf <TARBALL FILE>`.
* Navigate to the resulting directory in your shell.
* Run the `puppet-enterprise-installer` script with root privileges:

        $ sudo ./puppet-enterprise-installer
* Answer the interview questions to [select and configure PE's roles](#selecting-roles).
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

**Note: By default, the puppet master will check for updates whenever the `pe-httpd` service restarts.** In order to retrieve the correct update, the master will pass some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable upgrade checking can be found in the [answer file reference](/pe/latest/install_answer_file_reference.html#puppet-master-answers).

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

### Passwords
The following characters are forbidden in all passwords: `\` (backslash), `'` (single quote),  `"` (double quote), `,` (comma), `()` (right and left parentheses), `|` (pipe), `&` (ampersand), and `$` (dollar sign). For all passwords used during installation, we recommend using only alphanumeric characters.

### Puppet Master Questions

#### Certname

The certname is the puppet master's unique identifier. It should be a DNS name at which the master server can be reliably reached, and defaults to its fully-qualified domain name.

(If the master's certname is not one of its DNS names, you may need to [edit puppet.conf after installation][bucket-troubleshooting].)

[bucket-troubleshooting]: ./trouble_common_problems.html#can-agents-reach-the-filebucket-server

#### Valid DNS Names

The master's certificate contains a static list of valid DNS names, and agents won't trust the master if they contact it at an unlisted address. You should make sure that this list contains the DNS name or alias you'll be configuring your agents to contact.

The valid DNS names setting should be a comma-separated list of hostnames. The default set of DNS names will be derived from the certname you chose, and will include the default puppet master name of "puppet."

#### Location of the Console Server

If you are splitting the puppet master and console roles across different machines, the installer will ask you for the hostname and port of the console server.

### Console Questions

The console should usually run on its own dedicated server, but can also run on the same server as the puppet master. **If you are running the console and puppet master roles on separate servers, install the console _after_ the puppet master.**

#### Port

You must choose a port on which to serve the console's web interface. If you aren't already serving web content from this machine, it will default to **port 443,** so you can reach it at `https://yourconsoleserver` without specifying a port.

If the installer detects another web server on the node, it will suggest the first open port at or above 3000.

#### User Email and Password

Access to the console's web interface is [limited to approved users and governed by a lightweight system of roles](./console_auth.html). During installation, you must create an initial admin user for the console by providing an email address and password. Recall the limitations on characters in passwords listed [above](#passwords).

#### SMTP Server

The console's account management tools will send activation emails to new users, and requires an SMTP server to do so.

* If you cannot provide an SMTP server, an admin user can manually copy and email the activation codes for new users. (Note that `localhost` will usually work as well.)
* If your SMTP server requires TLS or a user name and password, you must [perform additional configuration after installing.][smtpconfig]

[smtpconfig]: ./config_advanced.html#configuring-the-smtp-server

#### Inventory Certname and DNS Names (Optional)

If you are splitting the master and the console roles, the console will maintain an inventory service to collect facts from the puppet master. Like the master, the inventory service needs a unique certname and a list of valid DNS names.

#### Databases

The console needs multiple MySQL databases and MySQL users in order to operate, but can automatically configure them. It can also automatically install the MySQL server if it isn't already present on the system.

The installer gives slightly different options to choose from depending on your system's configuration:

* Automatically install a MySQL server and auto-configure databases (only available if MySQL is not yet installed). **This option will generate a random root MySQL password,** and you will need to look it up in the saved answer file after installation finishes. A message at the end of the installer will tell you the location of the answer file.
* Auto-configure databases on an existing local or remote MySQL server. You will need to provide your server's root MySQL password to the installer. (Note that if you want to auto-configure databases on a remote server, you must make sure the root MySQL user is allowed to log in remotely.)
* Use a set of pre-existing manually configured databases and users.

##### Manual Database Configuration

If you are manually configuring your databases, the installer will ask you to provide:

* A name for the console's primary database
* A MySQL user name for the console
* A password for the console's user
* A name for the console authentication database
* A MySQL user name for console authentication
* A password for the console authentication user
* The database server's hostname (if remote)
* The database server's port (if remote; default: 3306)

You will also need to make sure the databases and users actually exist. The SQL commands you need will resemble the following:

    CREATE DATABASE console CHARACTER SET utf8;
    CREATE DATABASE console_inventory_service CHARACTER SET utf8;
    CREATE USER 'console'@'localhost' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON console.* TO 'console'@'localhost';
    GRANT ALL PRIVILEGES ON console_inventory_service.* TO 'console'@'localhost';

    CREATE DATABASE console_auth CHARACTER SET utf8;
    CREATE USER 'console_auth'@'localhost' IDENTIFIED BY 'password';
    GRANT ALL PRIVILEGES ON console_auth.* TO 'console_auth'@'localhost';
    FLUSH PRIVILEGES;

**Note that the names of the console and inventory databases are related:** the name of the inventory service database must start with the name of the primary console database, followed by `_inventory_service`.

Consult the MySQL documentation for more info.


### Puppet Agent Questions

#### Certname

The certname is the agent node's unique identifier.

This defaults to the node's fully-qualified domain name, but any arbitrary string can be used. If hostnames change frequently at your site or are otherwise unreliable, you may wish to use UUIDs or hashed firmware attributes for your agent certnames.

#### Puppet Master Hostname

Agent nodes need the hostname of a puppet master server. This must be one of the valid DNS names you chose when installing the puppet master.

This setting defaults to `puppet`.

#### Optional: Override Failed Puppet Master Communications

The installer will attempt to contact the puppet master before completing the installation. If it isn't able to reach it, it will give you a choice between correcting the puppet master hostname, or continuing anyway.

Final Questions
-----

### Vendor Packages

Puppet Enterprise may need some extra system software from your OS vendor's package repositories.

* The puppet master role requires **a Java runtime,** in order to run the ActiveMQ server for orchestration.
* The console role requires **MySQL;** if using local databases, it also requires **MySQL server.**

If these aren't already present, the installer will offer to automatically install them. If you decline, it will exit, and you will need to install them manually before running the installer again.

As of PE 2.7.0, you also have the option of verifying the integrity of the selected packages by using Puppet Labs' public GPG key. This is done by answering "yes" when asked if you want to verify the signatures of the PE RPM packages.. The key will be used to verify the signatures of the selected RPM packages. Because the key is added to the RPM database, the option to verify is only available on platforms that support RPM packages (currently EL 5,6-based and sles 11 platforms). The question will not be presented on non-RPM based platforms (e.g. Debian) and if it is present in a pre-made answer file it will be ignored on those platforms.

The option will appear in answer files as `verify_packages=y|n`.

Answering "no" to the question will preserve the PE 2.6.1 and earlier behavior of not verifying packages.

#### Java and MySQL Versions

* On every supported platform, PE can use the **default system packages** for MySQL and Java (OpenJDK on most Linuxes, and IBM Java on SUSE).
* Custom-compiled MySQL or Java versions may or may not work, as Puppet Enterprise expects to find shared objects and binaries in their standard locations. In particular, we have noticed problems with custom compiled MySQL 5.5 on Enterprise Linux variants.
* On Enterprise Linux variants, you may optionally use the Java and MySQL packages provided by Oracle. Before installing PE, you must manually install Java and/or MySQL, then install the  `pe-virtual-java` and/or `pe-virtual-mysql` packages included with Puppet Enterprise:

        $ sudo rpm -ivh packages/pe-virtual-java-1.0-1.pe.el5.noarch.rpm

Find these in the installer's `packages/` directory. Note that these packages may have additional ramifications if you later install other software that depends on OS MySQL or Java packages.

 Note: If installing `pe-virtual-java`, make sure that the `keytool` binary is in one of the following directories:

 * `/opt/puppet/bin`
 * `/usr/kerberos/sbin`
 * `/usr/kerberos/bin`
 * `/usr/local/sbin`
 * `/usr/local/bin`
 * `/sbin`
 * `/bin`
 * `/usr/sbin`
 * `/usr/bin`

 If `keytool` isn't already there, use `find` or `which` to locate it, and symlink it into place so that the PE installer can find it during installation. This binary is necessary for configuring MCollective.

     $ which keytool
     /path/to/keytool
     $ sudo ln -s /path/to/keytool /usr/local/bin/keytool

### Convenience Links

PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`. If you want to make the Puppet tools more visible to all users, the installer can make symlinks in `/usr/local/bin` for the `facter, puppet, pe-man`, and `mco` binaries.

### Confirming Installation

The installer will offer a final chance to confirm your answers before installing.

After Installing
-----

### Securing the Answer File

After finishing, the installer will print a message telling you where it saved its answer file. If you automatically configured console databases, **you should save and secure this file,** as it will contain the randomly-generated root MySQL password.

### Signing Agent Certificates

Before nodes with the puppet agent role can fetch configurations or appear in the console, an administrator has to sign their certificate requests. This helps prevent unauthorized nodes from intercepting sensitive configuration data.

During installation, PE will automatically submit a certificate request to the puppet master. Before the agent can retrieve any configurations, a user will have to sign a certificate for it.

Node requests can be approved or rejected using the console's certificate management capability. Pending node requests are indicated in the main nav bar. Click on the "node requests" indicator to go to a view where you can see current requests and approve or reject them as needed.

Alternatively, you can use the CLI. **Certificate signing with the CLI is done on the puppet master node.** To view the list of pending certificate requests, run:

    $ sudo puppet cert list

To sign one of the pending requests, run:

    $ sudo puppet cert sign <name>

After signing a new node's certificate, it may take up to 30 minutes before that node appears in the console and begins retrieving configurations. You can trigger a puppet run manually on the node if you want to see it right away.

### Verifying Your License

When you purchased Puppet Enterprise, you should have been sent a `license.key` file that lists how many nodes you can deploy. For PE to run without logging license warnings, **you should copy this file to the puppet master node as `/etc/puppetlabs/license.key`.** If you don't have your license key file, please email <sales@puppetlabs.com> and we'll re-send it.

Note that you can download and install Puppet Enterprise on up to ten nodes at no charge. No licence key is needed to run PE on up to ten nodes.

* * *

- [Next: Upgrading](./install_upgrading.html)
