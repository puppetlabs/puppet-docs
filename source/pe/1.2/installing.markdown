Installing Puppet Enterprise 
============================

To install Puppet Enterprise, navigate to the distribution directory in a shell session and run `./puppet-enterprise-installer` with root privileges; this will run the installer in interactive mode and guide you through the process of customizing your installation. 

After you have customized your installation, Puppet Enterprise will install the requested software in `/opt/puppet`, start all of the relevant services, and configure this machine to start Puppet at every boot. 

Customizing Your Installation
=============================

The Puppet Enterprise installer will ask which of the primary Puppet components (master, Dashboard, and agent) you wish to install on the current machine; for each component you select, additional configuration information will be requested.

## puppet master

The puppet master service is the center of your Puppet installation: it holds the modules and manifests describing your site, controls which computers are allowed to receive configurations, and determines which configurations each node should receive. Puppet Enterprise currently supports sites with a single puppet master server; future releases will support more complex deployments.

The following puppet master options can be specified at install time:

### Certified Hostnames

During installation, puppet master requires a colon-separated list of the hostnames by which it will be reachable to agent nodes.

Puppet's communications are secured with SSL certificates, with signing usually handled by a certificate authority installed alongside puppet master. A certificate for the puppet master will be generated and signed during installation, and puppet agent nodes will only consider this certificate valid if they connect to one of the hostnames supplied when it was generated. 

The installer will detect the server's hostname, and will offer the following default list of hostnames to certify:

* The server's fully-qualified domain name
* The server's short hostname
* puppet.{domainname}
* puppet

These defaults will most likely be sufficient, but can be overridden as needed.  

Note that the special short hostname `puppet` will always be included in the puppet master's SSL certificate; if you configure your site's DNS to direct searches for `puppet` to the puppet master server, it can greatly simplify configuration. 

### Integration with Puppet Dashboard

If you are installing Puppet Dashboard at your site, the puppet master must be properly configured to take advantage of it. As described below, Puppet Dashboard can serve as both a reports viewer and an external node classifier; puppet master can be configured to use both functions or only one. 

After choosing to use Dashboard for reports and/or node classification, the installer will ask for your Dashboard's hostname and port.  The default answers assume you are running the Puppet Dashboard under its default configuration on the same server as the puppet master; if you are running the Dashboard on a different server, make sure to configure both machines' firewalls such that the master can reach it.

## Puppet Dashboard

Puppet Dashboard is an optional addition to the Puppet solution, and provides a convenient web interface for viewing reports and assigning classes and parameters to nodes. The Dashboard is frequently run on the same server as puppet master, but can also be installed on a separate machine.

If installing the Dashboard, you will need to assign it a port (the default is 3000) and provide for access to a MySQL database. Puppet Enterprise's installer can install and configure a new MySQL database server, or it can configure Puppet Dashboard to connect to an existing MySQL server. 

### Installing a New MySQL Database Server

If you choose to install a new MySQL server on this computer, the software will be installed from your operating system vendor's package repositories. You will be asked to provide a password for MySQL's root user. 

### Using a Pre-existing MySQL Database Server

Puppet Dashboard can also connect to a pre-existing remote or local database server; if the server is remote, the installer will ask for a hostname and port. 

When using a pre-existing server, you will need to manually create a user for Puppet Dashboard, create a database, and ensure that Dashboard's user has ALTER, CREATE, DELETE, DROP, INDEX, INSERT, SELECT, and UPDATE privileges on that database **before** completing the installation. Consult the MySQL documentation for more details. The relevant commands will likely resemble the following: 

	CREATE DATABASE dashboard CHARACTER SET utf8;
	CREATE USER 'dashboard'@'localhost' IDENTIFIED BY 'password';
	GRANT ALL PRIVILEGES ON dashboard.* TO 'dashboard'@'localhost';

Before performing the installation, the Puppet Enterprise installer will provide a code snippet which can be copied and pasted verbatim into an interactive MySQL shell. 

### MySQL Database Configuration

The installer will ask for a MySQL user name, a password, and a database name. If you chose to use a new database server, this information will be used to configure a new user and database for Puppet Dashboard. If you chose to use a pre-existing server, Puppet Dashboard will use this information to connect and identify itself. 

### A Note on Firewalls

You may have to configure your system's firewall after installation in order to access the Dashboard's web interface from other computers on the network. See "Configuring and Troubleshooting" below.

## puppet agent

The puppet agent service runs on every node managed by Puppet; it contacts a designated puppet master server, provides information about the node, and receives and applies configurations.

The following puppet agent options can be specified at install time:

### Unique Identifier (Certificate Common Name, or "certname")

Like the puppet master server, each puppet agent node is identified by an SSL certificate signed by the CA certificate. Unlike the master, an agent node's certificate does not have to identify a valid address at which the node can be contacted; instead, the certificate's Common Name (referred to as a "certname" in most documentation) must simply contain a unique string identifying the node. 

Nevertheless, common practice is to use a node's fully-qualified domain name as its certname, which is the default option provided by the installer. If domain names change frequently at your site or are otherwise unreliable, you may wish to investigate other schemes of node identification, such as [Universally Unique Identifiers](http://en.wikipedia.org/wiki/Universally_unique_identifier) or the hash of a permanent attribute of the node.

### puppet master Hostname

By default, puppet agent will attempt to connect to a puppet master server at the hostname `puppet`. If necessary, you can override this with a hostname of your choosing during installation. 

### Copying Plugins From puppet master With pluginsync

Pluginsync allows puppet agent nodes to receive executable Ruby code from their puppet master. This is most frequently used for custom facts, types, and providers. 

In most cases, you will want to enable pluginsync. 

## Development Libraries

Some users may wish to install additional RubyGems packages for use with Puppet Enterprise, and a significant subset of gems require native code to be compiled. Since PE provides its own copy of Ruby (and `gem`), you will need PE-specific copies of the Ruby development libraries if you intend to install any gems with native bindings. 

If your platform's build tools are not currently installed and you choose to install the Ruby development libraries, Puppet Enterprise will ask to install those tools from your operating system vendor's package repositories; see "Additional Packages" below.

If you do not install the development libraries when installing Puppet Enterprise and find that you need them later, you can install the necessary packages manually; see "Configuring and Troubleshooting" below. 

## Convenience Links

Puppet Enterprise installs the Puppet software and manpages into subdirectories of `/opt/puppet`, which aren't included in your system's default `$PATH` or `$MANPATH`. For ease of use, the installer can create symbolic links to the Puppet executables in `/usr/local/bin` and install `pe-man`, a tool which functions similarly to the traditional `man` utility (e.g. `pe-man puppet` or `pe-man puppet agent`). 

If you do not expect to manually invoke Puppet on this machine, these conveniences are not necessary. If you do expect to manually invoke Puppet but do not wish to install the convenience links, you can add `/opt/puppet/bin` to the `PATH` and `/opt/puppet/share/man` to the `MANPATH` of each user who will be working with Puppet. (Or, alternately, invoke the Puppet executables using their full paths.) 

## Additional Packages

Puppet Enterprise requires certain software from your operating system vendor's package repositories, and it is possible that your system will be missing some of this software at the time of installation. The Puppet Enterprise installer will list which packages (if any) are still needed, and will offer to automatically install them using your system's package management tools. If you decline to automatically install these packages, the installer will exit so you can install them manually. 

Advanced Installation
=====================

## Installer Options

The Puppet Enterprise installer will accept the following command-line flags:

* `-a ANSWER_FILE` -- Read answers from file and quit with error if an answer is missing.
* `-A ANSWER_FILE` -- Read answers from file and prompt for input if an answer is missing.
* `-D` -- Display debugging information.
* `-h` -- Display a brief help message.
* `-l LOG_FILE` -- Log commands and results to file.
* `-n` -- Run in 'noop' mode; show commands that would have been run during installation without running them.
* `-s ANSWER_FILE` -- Save answers to file and quit without installing.

## Non-interactive Installation

To streamline your deployment, the Puppet Enterprise installer can run non-interactively. When run with the `-a` or `-A` flags, the installer will load an answer file specified by the user. 

Answer files are simply shell scripts; they set a number of predefined variables and are sourced by the installer at runtime. Although static answer files are easily generated by running the installer with the `-s ANSWER_FILE` option, they can also be constructed by hand or with other tools, and can contain arbitrary shell code. This feature of the installer can be used to, for example, automate the generation of puppet agent certnames for sites that do not identify nodes by FQDN. 

Further details and a full description of the available variables can be found in Appendix A.

