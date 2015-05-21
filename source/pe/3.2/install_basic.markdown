---
layout: default
title: "PE 3.2 » Installing » Installing PE"
subtitle: "Installing Puppet Enterprise"
canonical: "/pe/latest/install_basic.html"
---


[downloadpe]: http://info.puppetlabs.com/download-pe.html

> ![windows logo](./images/windows-logo-small.jpg) This chapter covers \*nix operating systems. To install PE on Windows, see [Installing Windows Agents](./install_windows.html).



Downloading PE
-----

Start by downloading the [current version of Puppet Enterprise and the GPG signature from the Puppet Labs website][downloadpe].

### Choosing an Installer Tarball

Puppet Enterprise is distributed in tarballs specific to your OS version and architecture.

#### Available \*nix Tarballs

|      Filename ends with...        |                     Will install on...                 |
|-----------------------------------|-----------------------------------------------------|  |
| `-debian-<version and arch>.tar.gz`  | Debian                                           |
| `-el-<version and arch>.tar.gz`      | RHEL, CentOS, Scientific Linux, or Oracle Linux  |
| `-solaris-<version and arch>.tar.gz` | Solaris                                          |
| `-ubuntu-<version and arch>.tar.gz`  | Ubuntu LTS                                       |
| `-aix-<version and arch>.tar.gz`     | AIX                                              |

*Note:* Bindings for SELinux are available on RHEL 5 and 6. They are not installed by default but are included in the installation tarball. See [the appendix](./appendix.html) for complete information.

### Verifying the Installer

To verify the PE installer, you can import the Puppet Labs public key and run a cryptographic verification of the tarball you downloaded. The Puppet Labs public key is certified by Puppet Labs and is available from public keyservers, such as `pgp.mit.edu`, as well as from Puppet Labs. You'll need to have GnuPG installed and the GPG signature (.asc file) that you downloaded with the PE tarball.

To import the Puppet Labs public key, run:

    wget -O - https://downloads.puppetlabs.com/puppetlabs-gpg-signing-key.pub | gpg --import

The result should be similar to

    gpg: key 4BD6EC30: public key "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>" imported
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)

To print the fingerprint of our key, run:

    gpg --fingerprint 0x1054b7a24bd6ec30

You should also see an exact match of the fingerprint of our key, which is printed on the verification:

    Primary key fingerprint: 47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30

Next, verify the release signature on the tarball by running:

	$ gpg --verify puppet-enterprise-<version>-<platform>.tar.gz.asc

The result should be similar to

	 gpg: Signature made Tue 18 Jun 2013 10:05:25 AM PDT using RSA key ID 4BD6EC30
     gpg: Good signature from "Puppet Labs Release Key (Puppet Labs Release Key)"

 **Note**: When you verify the signature but do not have a trusted path to one of the signatures on the release key, you will see a warning similar to

	 	Could not find a valid trust path to the key.
      	gpg: WARNING: This key is not certified with a trusted signature!
      	gpg:          There is no indication that the signature belongs to the owner.

This warning is generated because you have not created a trust path to certify who signed the release key; it can be ignored.

Installation: Overview
-----

Installation will go more smoothly if you know a few things in advance. Puppet Enterprise's functions are spread across several different "roles" which get installed and configured when you run the installer. You can choose to install multiple roles on a single node or spread the roles across nodes (except for the "agent" role, which gets installed on every node). You should decide on this architecture before starting the install process. For each node where you will be installing a PE role, you should know the fully qualified domain name where that node can be reached and you should ensure that firewall rules are set up to allow access to the [required ports](./install_system_requirements.html#firewall-configuration).

When separating the roles across nodes, you should install in the following order:

  1. Master role
  2. Database support role
  3. Console role
  4. Cloud provisioner role
  5. Agents

With that knowledge in hand, the installation process will proceed in *two stages*:

* Initially, you will install the main components of PE (master, database support, console, provisioner) by running the installer script included on the installation tarball.
* Next, you will install the PE agent on all the nodes you wish to manage with PE.

> **Note:** Starting with PE 3.2 you can install agents just as you would any other package, using the node's native package manager (e.g. yum or apt). This approach can be used on any modern *nix system that supports remote package repos. You can use an existing package repository or, if you don't have one, the master installer will create one (called `pe_repo`) for the OS and architecture on which it is installed.
>
> To install the agent on systems with no native support for remote package repositories (Solaris, RHEL 4, AIX, Windows), you can still use the tarball and installer script method as with the other components.

Initial Installation: Using the Installer Script
-----

The installation process begins with the initial installation of the master, database, console, and provisioner roles:

1. Unarchive the installer tarball, usually with `tar -xzf <TARBALL FILE>`.
2. Navigate to the resulting directory in your shell.
3. Run the `puppet-enterprise-installer` script with root privileges:

        $ sudo ./puppet-enterprise-installer
4. Answer the interview questions to [select and configure PE's roles](#selecting-roles).
5. Log into the puppet master server and [sign the new node's certificate](#signing-agent-certificates).
6. If you have purchased PE and are installing the puppet master, [copy your license key into place](#verifying-your-license).
7. Wait 30 minutes for the next puppet run, or kick off a run manually, to get all the agents checked in.

Note that after the installer has finished installing and configuring PE, it will save your interview answers to a file called `answers.lastrun`. This file can be used as the basis for future, automated installations. For details [see the section on automated installation][automated].

[automated]: ./install_automated.html

The PE installer installs and configures Puppet Enterprise by asking a series of questions. Most questions have a default answer (displayed in brackets), which you can accept by pressing enter without typing a replacement. For questions with a yes or no answer, the default answer is capitalized (e.g. "`[y/N]`").

> ### Using Answer Files
>
> Answer files are used to create customized, automated installations of PE. For example, you can use an answer file to set custom port configurations for things like PuppetDB. You create an answer file by performing a dry run of the installer, using the `-s <ANSWER FILE>` flag. After you create the answer file, you can edit it for further customization and then use it in any of your deployments; additionally, you can create a separate answer file for each PE role. For more information, consult the [answers file reference](./install_answer_file_reference.html) and [automated installation](./install_automated.html) sections of this guide.


### Installer Options

The installer will accept the following command-line flags:

`-h`: Display a brief help message.

`-s <ANSWER FILE>`: Save answers to a file and quit without actually installing.

`-a <ANSWER FILE>`: Read answers from a file and fail if an answer is missing.

`-A <ANSWER FILE>`: Read answers from a file and prompt for input if an answer is missing.

`-D`: Display debugging information.

`-l <LOG FILE>`: Log commands and results to file.

`-n`: Run in 'no-op' mode; show commands that would have been run during installation without running them.


Selecting Roles
-----

First, the installer will ask which of PE's **roles** to install. The role(s) you choose will determine the additional questions the installer will ask.

### The Puppet Agent Role

The agent role is most easily installed using a package manager (see [installing agents](#installing-agents) below). On platforms that do not support remote package repos, you can use the installer script.

This role should be installed on **every node** in your deployment, including the master, database support, and console nodes. (When you choose the puppet master, database support, or console roles, the puppet agent role will be installed automatically at the same time.) Nodes with the puppet agent role can:

* Run the puppet agent daemon, which receives and applies configurations from the puppet master.
* Listen for orchestration messages and invoke orchestration actions.
* Send data to the master for use by PuppetDB.

### The Puppet Master Role

In most deployments, this role should be installed on **one node;** installing multiple puppet masters requires additional configuration. The puppet master must be a robust, dedicated server; see the [system requirements](./install_system_requirements.html) for more detail. The puppet master server can:

* Compile and serve configuration catalogs to puppet agent nodes.
* Route orchestration messages through its ActiveMQ server.
* Issue valid orchestration commands (from an administrator logged in as the `peadmin` user).

**Note: By default, the puppet master will check for the availability of updates whenever the `pe-httpd` service restarts**. In order to retrieve the correct update information, the master will pass some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled. You can find the details on what is collected and how to disable upgrade checking in the [answer file reference](./install_answer_file_reference.html#puppet-master-answers). If an update is available, a message will alert you.


### The Database Support Role
This role provides required database support for PuppetDB and the console:

* PuppetDB is the fast, scalable, and reliable centralized data service for Puppet. It caches data generated by Puppet and gives you rapid access to advanced features with a powerful API.
* The console relies on data provided by a PostgreSQL server and database, both of which will be installed along with PuppetDB on the node you specify.

You can install database support on the same node as the console or onto a separate node. When installing the database support role on a separate node, you should install it BEFORE installing the console role.

>**Tip**: Avoid mixed case when entering your server hostnames (e.g., ServerName). Since certificates are generated using the hostnames you provide for the servers, using all lowercase hostnames will minimize the chances of installation issues.

Installing this role will auto-generate database user passwords. You will need these user passwords to answer some questions you'll be asked during the console installation interview. For more information, see the Console Role section below.

If you want to set up a PuppetDB database manually, the [PuppetDB configuration documentation](/puppetdb/1.3/configure.html#using-postgresql) has more information. Otherwise, the console requires two databases, one for the console and one for console_auth (used for user management), with separate admin user access for each.

If you choose to use a database server separate from the PuppetDB server, you must configure it manually. The installer cannot install and configure postgres on a remote server without PuppetDB.

**Note**: If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

**IMPORTANT**: The node you choose to run database support must have the en_US.UTF8 locale present before you begin installation. The installer will abort with a message if the locale is not present.

### The Console Role

This role should be installed on **one node.** It should usually run on its own dedicated server, but it can run on the same server as the puppet master if that server is also running the database support role. The console server can:

* Serve the console web interface, which enables administrators to directly edit resources on nodes, trigger immediate Puppet runs, group and assign classes to nodes, view reports and graphs, view inventory information, and invoke orchestration actions.
* Collect reports from and serve node information to the puppet master.

#### Console Database

The console relies on data provided by a PostgreSQL database installed along with PuppetDB. This database can be served by a PostgreSQL server running on the same node as the console or on a separate node. The server and database files can be installed by the Puppet Enterprise installer via the database support role, or you can add the databases manually on an existing PostgreSQL server. You only need to create the database instances, the console will populate them.

IMPORTANT: If you are not performing an all-in-one installation (e.g. Master, Database Support, and Console on one node), you will be prompted for the host name and port of the node you intend to use to provide database support, and you will be asked for the user passwords for accessing the databases. The database support role must be installed on that node for the console to function. You should do this BEFORE installing the console role so that you have access to the database users' passwords during installation of the console.

The database users' passwords are auto-generated when the database support role is installed and are saved in `/etc/puppetlabs/installer/database_info.install`. If you copy this file to the node where you'll be installing the console, you can [automate password entry](./install_automated.html#running-the-installer-in-automated-mode) by adding the `-A` flag and the path to the saved database.info.install file to the `puppet-enterprise-installer` command.

### The Cloud Provisioner Role

This optional role can be installed on a system where administrators have shell access. Since it requires confidential information about your cloud accounts to function, it should be installed on a secure system. Administrators can use the cloud provisioner tools to:

* Create new VMware and Amazon EC2 virtual machine instances.
* Install Puppet Enterprise on any virtual or physical system.
* Add newly provisioned nodes to a group in the console.

**Note:** After completing installation, you should run puppet using `puppet agent -t` or live management. This helps avoid issues (e.g., sometimes the master does not report to the console until after the first run, resulting in inaccurate license counts or MCollective agents don't check in, preventing live management from working on those nodes). Of course, puppet will run automatically within 30 minutes of install.


Customizing Your Installation
-----

After you choose the roles for the target node, the installer will ask questions needed to configure those roles.

### Passwords
The following characters are forbidden in all passwords: `\` (backslash), `'` (single quote),  `"` (double quote), `,` (comma), `()` (right and left parentheses), `|` (pipe), `&` (ampersand), and `$` (dollar sign). For all passwords used during installation, we recommend using only alphanumeric characters.

### Puppet Master Questions

#### Certname

The certname is the puppet master's unique identifier. It should be a DNS name at which the master server can be reliably reached, and it will default to its fully qualified domain name.

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


#### Disabling/Enabling Live Management During Installation

If necessary, you can disable live management during the installation process (it's enabled by default), but you must first create an answer file and then manually add `q_disable_live_management={y|n}` to the file. You can then use the answer file to [perform an automated installation of PE](./install_automated.html).

Depending on your answer, the `disable_live_management` setting in `/etc/puppetlabs/puppet-dashboard/settings.yml` (located on the puppet master) will be set to either `true` or `false` after the installation is complete.

(Note that you can enable/disable Live Management at any time during normal operations by editing the aforementioned `settings.yml` and then running `sudo /etc/init.d/pe-httpd restart`.)

#### Databases

The console needs multiple PostgresSQL databases and PostgresSQL users in order to operate, but these can be automatically created and configured by the installer. It can also automatically install the PostgreSQL server if it isn't already present on the system.

The installer gives slightly different options to choose from, depending on your system's configuration:

* Automatically install a PostgreSQL server and auto-configure databases on a local server. **This option will generate a random root PostgreSQL password,** and you will need to look it up in the saved answer file after installation finishes. A message at the end of the installer will tell you the location of the answer file.
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
	CREATE USER "console" PASSWORD 'password';
	CREATE DATABASE "console" OWNER "console" TABLESPACE "pe-console" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;
	CREATE USER "console_auth" PASSWORD 'password';
	CREATE DATABASE "console_auth" OWNER "console_auth" TABLESPACE "pe-console" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;
	CREATE TABLESPACE "pe-puppetdb" LOCATION '/opt/puppet/var/lib/pgsql/9.2/puppetdb';
	CREATE USER "pe-puppetdb" PASSWORD 'password';
	CREATE DATABASE "pe-puppetdb" OWNER "pe-puppetdb" TABLESPACE "pe-puppetdb" ENCODING 'utf8' LC_CTYPE 'en_US.utf8' LC_COLLATE 'en_US.utf8' template template0;

Consult the [PostgreSQL documentation](http://www.postgresql.org/docs/) for more info.


### Puppet Agent Questions

#### Certname

The certname is the agent node's unique identifier.

This defaults to the node's fully qualified domain name (FQDN), but any arbitrary string can be used. If hostnames change frequently at your site or are otherwise unreliable, you may wish to use UUIDs or hashed firmware attributes for your agent certnames.

#### Puppet Master Hostname

Agent nodes need the hostname of a puppet master server. This must be one of the valid DNS names you chose when installing the puppet master.

This setting defaults to `puppet`. The FQDN of the master is probably a better choice.

#### Optional: Override Failed Puppet Master Communications

The installer will attempt to contact the puppet master before completing the installation. If it isn't able to reach the master, it will give you a choice between correcting the puppet master hostname or continuing anyway.

Installing Agents
-----

If you are using a supported OS that is capable of using remote package repos, the simplest way to install the PE agent is with standard *nix package management tools. To install the agent on other OS's (Solaris, AIX, RHEL 4, Windows) you'll need to use the installer script just as you did above.

### Installing Agents Using PE Package Management

If your infrastructure does not currently host a package repository, PE hosts a package repo on the master that corresponds to the OS and architecture of the master node. The repo is created during installation of the master. The repo serves packages over HTTPS using the same port as the puppet master (8140). This means agents won't require any new ports to be open other than the one they already need to communicate with the master.

You can also add repos for any PE-supported OS and architecture by creating a new repository for that platform.

>**Warning**: Installing agents using the `pe_repo` class requires an internet connection. If you don't have access to the internet, refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

When you run the installation script on your agent, the script will detect the OS on which it is running, set up an apt (or yum, or zypper) repo that refers back to the master, pull down and install the `pe-agent` packages, and create a simple `puppet.conf` file. The certname for the agent node installed this way will be the value of `facter fqdn`.

Note that if install.bash can't find agent packages corresponding to the agent's platform, it will fail with an error message telling you which `pe_repo` class you need to add to the master.

After you’ve installed the agent on the target node, you can configure it using [`puppet config set`][config_set]. See [Configuring Agents](#Configuring-Agents) below.

#### Example Script Usage

>**Note**: The `<master hostname>` portion of the installer script--as provided in the following examples--refers to the FQDN of the puppet master. In a monolithic install, this is the same node on which you installed the puppet master, console, and PuppetDB components; in a split install, this is the node you assigned to the puppet master component. Note that if you've already logged into the console, you can find the exact script with the correct master hostname for your installation by clicking on **node requests** in the top right-hand corner of the console. (You do not need to have pending node requests to click.)

**Scenario 1**: The OS/architecture of the Puppet master and the agent node are the same.

Simply SSH into the node where you want to install the PE agent, and run `curl -k https://<master hostname>:8140/packages/current/install.bash | sudo bash`.

This script will detect the OS on which it is running, set up an apt, yum, or zipper repo that refers back to the Puppet master, and then pull down and install the `pe-agent` packages. It will also create a basic `puppet.conf`, and kick off a puppet run.

Note that you can replace `current` in the script with a specific PE version number, in the form of `3.x.x`.

>**Note**: The `-k` flag is needed in order to get `curl` to trust the master, which it wouldn't otherwise since Puppet and its SSL infrastructure have not yet been set up on the node. 
>   
>However, users of AIX 5.3, 6.1, and 7.1 should note that the `-k` is not supported. You should replace the `-k` flag with `-tlsv1` or `-1`. 
>
>In some cases, you may be using `wget` instead of `curl`---please use the appropriate flags as needed.

> After the installation is complete, continue on to [Signing Agent Certificates](#signing-agent-certificates)

**Scenario 2**: The OS/architecture of the Puppet master and the agent node are different.

As an example, if your master is on a node running EL6 and you want to add an agent node running Debian 6 on AMD64 hardware:

1. Use the console to add the `pe_repo::platform::debian_6_amd64` class.

   a. From the sidebar of the console, click **Add Classes**.

   b. From the **Available Classes** page, in the list of classes, locate `pe_repo::platform::debian_6_amd64`, and select it.

   c. Click __Add selected classes__.

   d. Navigate to the node page for your puppet master.

   e. Click __Edit__ and begin typing "`pe_repo::platform::debian_6_amd64`" in the __Classes__ field; you can select the class from the list of autocomplete suggestions.

   f. Click __Update__.

2. To create the new repo containing the agent packages, use live management to kick off a puppet run.

   a. Navigate to the live management page, and select the __Control Puppet__ tab.

   b. Select only the puppet master node. (If you have other agents installed, they do not need to run at this time.)

   c. Click the __runonce__ action and then __Run__ to trigger a puppet run

   The new repo is created in `/opt/puppet/packages/public`. It will be called `puppet-enterprise-3.3.0-debian-6-amd64-agent`.

3. SSH into the node where you want to install the agent, and run `curl -k https://<master hostname>:8140/packages/current/install.bash | sudo bash`.

   **Tip**: Refer to [Platform-Specific Install Script](#platform-specific-install-script) below for a note about the `<master hostname>` portion of the script.

The script will install the PE agent packages, create a basic `puppet.conf`, and kick off a puppet run.

>**Note**: The `-k` flag is needed in order to get `curl` to trust the master, which it wouldn't otherwise since Puppet and its SSL infrastructure have not yet been set up on the node. 
>   
>However, users of AIX 5.3, 6.1, and 7.1 should note that the `-k` is not supported. You should replace the `-k` flag with `-tlsv1` or `-1`. 
>
>In some cases, you may be using `wget` instead of `curl`---please use the appropriate flags as needed.

> #### About the Platform Specific Install Script
>
> The `install.bash` script actually uses a secondary script to retrieve and install an agent package repo once it has detected the platform on which it is running. You can use this secondary script if you want to manually specify the platform of the agent packages. You can also use this script as an example or as the basis for your own custom scripts.
> The script can be found at `https://<master>:8140/packages/current/<platform>.bash`, where `<platform>` uses the form `el-6 x86_64`. Platform names are the same as those used for the PE tarballs:
>
 >   - el-{5, 6}-{i386, x86_64}
 >   - debian-{6, 7}-{i386, amd64}
 >   - ubuntu-{10.04, 12.04}-{i386, amd64}
 >   - sles-11-{i386, x86_64}
>
> The `<master hostname>` portion of the installer script refers to the FQDN of the puppet master. In a monolithic install, this is the same node on which you installed the puppet master, console, and PuppetDB components; in a split install, this is the node you assigned to the puppet master component. Note that if you've already logged into the console, you can find the exact script with the correct master hostname for your installation by clicking on **node requests** in the top right-hand corner of the console. (You do not need to have pending node requests to click.)

> **Warning**: If the puppet master and agent differ in architecture and OS type/version, the correct `pe_repo` class for the agent must be assigned to the puppet master node before running the script. If you have not added the correct agent class and run the script, you will get an error message returned by `curl` similar to, `the indirection name must be purely alphanumeric, not <'3.2.0-15-gd7f6fa6'>`. This error is safe to ignore, but you will need to be sure you add the correct `pe_repo` class for the agent to the puppet master before running the script again.

#### Installing Agents in a Puppet Enterprise Infrastructure without Internet Access

When installing agents on a platform that is different from the puppet master platform, the agent install script attempts to connect to the internet to download the appropriate agent tarball after you classify the puppet master, as described in [Installing Agents Using PE Package Management](#installing-agents-using-pe-package-management).

If your PE infrastructure does not have access to the outside internet, you will not be able to fully use the agent installation instructions.  Instead, you will need to [download](http://puppetlabs.com/misc/pe-files/agent-downloads) the appropriate agent tarball in advance and use the option below that corresponds to your deployment needs.

* **Option 1**

    If you would like to use the PE-provided repo, you can copy the agent tarball into the `/opt/staging/pe_repo` directory on your master.

    Note that if you upgrade your server at any point, you will need to perform this task again for the new version.

* **Option 2**

    If you already have a package management/distribution system, you can use it to install agents by adding the agent packages to your own repo. In this case, you can disable the PE-hosted repo feature altogether by [removing](./console_classes_groups.html#classes) the `pe_repo` class from your master, along with any class that starts with `pe_repo::`.

    Note that if you upgrade your server, you will need to perform this task again for the new version.

* **Option 3**

    If your deployment has multiple masters and you don't wish to copy the agent tarball to each one, you can specify a path to the agent tarball. This can be done with an [answer file](./install_automated.html), by setting `q_tarball_server` to an accessible server containing the tarball, or by [using the console](./console_classes_groups.html#editing-class-parameters-on-nodes) to set the `base_path` parameter of the `pe_repo` class to an accessible server containing the tarball.

### Installing Agents with Your Package Management Tools

If you are currently using native package management, you just need to add the agent packages to the appropriate repo, configure your package manager (Yum, apt) to point at that repo, and then install the packages as you would any other. You can find agent packages that correspond to the master's OS/architecture in `/opt/puppet/packages/public` on the master. In that directory you will find a `<installed version of PE & platform>-agent/agent_packages` directory which in turn contains a directory with all the packages needed to install an agent (as well as a JSON file that lists the versions of those packages).

For nodes running an OS and/or architecture different from the master, [download the appropriate agent tarball](http://puppetlabs.com/misc/pe-files/agent-downloads). Extract the agent packages into the appropriate repo and then you can install agents on your nodes just as you would any other package (e.g., `yum install pe-agent`). Alternatively, you can follow the instructions above and classify the master using one of the built-in `pe_repo::platform::<platform>` classes. Once the master is classified and a puppet run has occurred, the appropriate agent packages will be generated and stored in `/opt/puppet/packages/public/<platform version>`.

Once the agent has been installed on the target node, it can be configured using `puppet config set`. See "[Configuring Agents](#configuring-agents)" below.

### Configuring Agents

Once the agent is installed it can be configured (pointed to the correct master, assigned a certname, etc.) by editing `/etc/puppetlabs/puppet/puppet.conf` directly or by using [the `puppet config set` sub-command][config_set], which will edit `puppet.conf` automatically.  For example, to point the agent at a master called "puppetmaster.example.com" you would run `puppet config set server puppetmaster.example.com`. This will add the setting `server = puppetmaster.example.com` to the `[main]` section of `puppet.conf`. For more details, see [the documentation for `puppet config set`][config_set].

[config_set]: ./config_set.html

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

If you need to remove certificates (e.g., during reinstallation of a node), you can use the `puppet cert clean <node name>` command.


Final Questions
-----

### Vendor Packages

Puppet Enterprise may need some extra system software from your OS vendor's package repositories.

If these aren't already present, the installer will offer to automatically install them. If you decline, it will exit, and you will need to install them manually before running the installer again.

### Convenience Links

PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`.

### Confirming Installation

The installer will offer a final chance to confirm your answers before installing.

Finishing and Cleaning Up
-----

### Securing the Answer File

After finishing, the installer will print a message telling you where it saved the answer file. If you automatically configured console databases, **you should save and secure this file,** as it will contain the randomly-generated root user PostgreSQL passwords. When installing the database support role, the answers file will contain the auto-generated passwords that you will need to answer questions regarding the console role.

### Verifying Your License

When you purchased Puppet Enterprise, you should have been sent a `license.key` file that lists how many nodes you can deploy. For PE to run without logging license warnings, **you should copy this file to the puppet master node as `/etc/puppetlabs/license.key`.** If you don't have your license key file, please email <sales@puppetlabs.com> and we'll re-send it.

Note that you can download and install Puppet Enterprise on up to ten nodes at no charge. No license key is needed to run PE on up to ten nodes.

* * *

- [Next: Upgrading](./install_upgrading.html)
