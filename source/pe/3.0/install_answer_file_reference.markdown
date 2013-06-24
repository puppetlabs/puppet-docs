---
layout: default
title: "PE 3.0 » Installing » Answer File Reference"
subtitle: "Answer File Reference"
---

Answer files are used for automated installations of PE. See [the chapter on automated installation](./install_automated.html) for more details.

Answer File Syntax
------------------

Answer files consist of normal shell script variable assignments:

    q_puppet_enterpriseconsole_database_port=3306

Boolean answers should use Y or N (case-insensitive) rather than true, false, 1, or 0.

A variable can be omitted if a prior answer ensures that it won't be used (i.e. `q_puppetmaster_certname` can be left blank if `q_puppetmaster_install` = n).

Answer files can include arbitrary bash control logic and can assign variables with commands in subshells (`$(command)`). For example, to set an agent node's certname to its fqdn:

    q_puppetagent_certname=$(hostname -f)

To set it to a UUID:

    q_puppetagent_certname=$(uuidgen)

Sample Answer Files
-------------------

PE includes a collection of sample answer files in the `answers` directory of your distribution tarball. A successful installation will also save an answer file called `answers.lastrun`, which can be used as a foundation for later installations. Finally, you can generate a new answer file without installing by running the installer with the `-s` option and a filename argument.

Installer Answers
-----

### Global Answers

These answers are always needed.

`q_install`
: **Y or N** --- Whether to install. Answer files must set this to Y.

`q_vendor_packages_install`
: **Y or N** --- Whether the installer has permission to install additional packages from the OS's repositories. If this is set to N, the installation will fail if the installer detects missing dependencies.

`q_puppet_symlinks_install`
: **Y or N** --- Whether to make the Puppet tools more visible to all users by installing symlinks in `/usr/local/bin`.


### Roles

These answers are always needed.

`q_puppetmaster_install`
: **Y or N** --- Whether to install the puppet master role.

`q_puppetdb_install`
: **Y or N** --- Whether to install the database support (the console Postgres server and PuppetDB) role.

`q_puppet_enterpriseconsole_install`
: **Y or N** --- Whether to install the console role.

`q_puppetagent_install`
: **Y or N** --- Whether to install the puppet agent role.

`q_puppet_cloud_install`
: **Y or N** --- Whether to install the cloud provisioner role.


### Puppet Agent Answers

These answers are always needed.

`q_puppetagent_certname`
: **String** --- An identifying string for this agent node. This per-node ID must be unique across your entire site. Fully qualified domain names are often used as agent certnames.

`q_puppetagent_server`
: **String** --- The hostname of the puppet master server. For the agent to trust the master's certificate, this must be one of the valid DNS names you chose when installing the puppet master.

`q_fail_on_unsuccessful_master_lookup`
: **Y or N** --- Whether to quit the install if the puppet master cannot be reached.


### Puppet Master Answers

These answers are generally needed if you are installing the puppet master role.

`q_all_in_one_install`
: **Y or N** --- Whether or not the installation is an all-in-one installation, (i.e., are puppetdb and the console also being installed on this node).

`q_puppetmaster_certname`
: **String** --- An identifying string for the puppet master. This ID must be unique across your entire site. The server's fully qualified domain name is often used as the puppet master's certname.

`q_puppetmaster_dnsaltnames`
: **String** --- Valid DNS names at which the puppet master can be reached. Must be a comma-separated list. In a normal installation, defaults to `<hostname>,<hostname.domain>,puppet,puppet.<domain>`.

`q_puppetmaster_enterpriseconsole_hostname`
: **String** --- The hostname of the server running the console role. Only needed if you are _not_ installing the console role on the puppet master server.

`q_puppetmaster_enterpriseconsole_port`
: **Integer** --- The port on which to contact the console server. Only needed if you are _not_ installing the console role on the puppet master server.

In addition, by default the puppet master will check for available PE software updates whenever the `pe-httpd` service restarts. To help ensure the correct update is retrieved, the master will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

    * the IP address of the client
    * the type and version of the client's OS
    * the Installed version of PE

If you wish to disable manual update checks, or if your company policy forbids transmitting this information, you will need to add the following line to the answer file: `q_pe_check_for_updates=n`. Keep in mind that if you delete your answers file, the check will turn back on the next time `pe-httpd` restarts.


### Console Answers

These answers are generally needed if you are installing the console role.

`q_database_host`
: **String** --- The hostname of the server running the PostgreSQL server that supports the console.

`q_database_port`
: **Integer** --- The port where the PostgreSQL server that supports the console can be reached.

`q_pe_database`
:**Y or N** "Yes" if you chose to have the Postgres server for the console installed by PE, "No" if you're managing it yourself. Used for classifying PuppetDB in the console, so it knows whether or not to manage the database.

`q_puppet_enterpriseconsole_master_hostname`
: **String** --- The hostname of the server running the master role. Only needed if you are _not_ installing the console role on the puppet master server.

`q_puppet_enterpriseconsole_httpd_port`
: **Integer** --- The port on which to serve the console. The default is port 443, which will allow access to the console from a web browser without manually specifying a port. If port 443 is not available, the installer will try port 3000, 3001, 3002, 3003, 3004, and 3005.

`q_puppet_enterpriseconsole_auth_user_email`
: **String** --- The email address the console's admin user will use to log in.

`q_puppet_enterpriseconsole_auth_password`
: **String** --- The password for the console's admin user. Must be longer than eight characters.

`q_puppet_enterpriseconsole_smtp_host`
: **String** -- The SMTP server used to email account activation codes to new console users. 

`q_puppet_enterpriseconsole_database_name`
: **String** --- The database the console will use. Note that if you are not installing the database support role, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_database_user`
: **String** --- The PostgreSQL user the console will use. Note that if you are not installing the database support role, this user must already exist on the PostgreSQL server and must be able to edit the console's database.

`q_puppet_enterpriseconsole_database_password`
: **String** --- The password for the console's PostgreSQL user.

`q_puppet_enterpriseconsole_auth_database_name`
: **String** --- The database the console authentication will use. Note that if you are not installing the database support role, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_auth_database_user`
: **String** --- The PostgreSQL user the console authentication will use. Note that if you are not installing the database support role, this user must already exist on the PostgreSQL server and must be able to edit the auth database.

`q_puppet_enterpriseconsole_auth_database_password`
: **String** --- The password for the auth database's PostgreSQL user.

Database Support Answers
-----

These answers are only needed if you are installing the console role.

`q_database_host`
: **String** --- The hostname of the server running the PostgreSQL server that supports the console.

`q_database_install`
: **Y or N** --- Whether or not to install the PostgreSQL server that supports the console.  

`q_database_port`
: **Integer** --- The port where the PostgreSQL server that supports the console can be reached.
 
`q_database_root_password`
: **String** --- The password for the console's PostgreSQL user.

`q_database_root_user`
: **String** --- The console's PostgreSQL root user name.

`q_puppetdb_database_name`
: **String** --- The database PuppetDB will use.

`q_puppetdb_database_password`
: **String** --- The password for PuppetDB's root user.

`q_puppetdb_database_user`
: **String** --- PuppetDB's root user name. 

`q_puppetdb_hostname`
: **String** --- The hostname of the server running PuppetDB.

`q_puppetdb_install`
: **Y or N** --- Whether or not to install PuppetDB. 

`q_puppetdb_port`
: **Integer** --- The port where the PuppetDB server can be reached. 


<!-- TODO_upgrade
Upgrader Answers
-----

`q_upgrade_installation`
: **Y or N** --- Whether to upgrade. Answer files must set this to Y.

`q_puppet_cloud_install`
: **Y or N** --- Whether to install the cloud provisioner tools on this node during the upgrade. Previous versions of PE did not include the cloud provisioner tools.

`q_puppet_enterpriseconsole_setup_auth_db`
: **Y or N** --- Whether to automatically configure the console's authentication database.

`q_puppet_enterpriseconsole_database_root_password`
: **String** --- The password for the root user on the console's database server. Only required if `q_puppet_enterpriseconsole_setup_auth_db` is true.

`q_puppet_enterpriseconsole_auth_user_email`
: **String** --- The email address with which the console's admin user will log in. Only required if this node has the console role installed.

`q_puppet_enterpriseconsole_auth_password`
: **String** --- A password for accessing the console. Previous versions of PE did not secure the Dashboard with a username and password. Only required if this node has the console role (previously Puppet Dashboard) installed.

`q_puppet_enterpriseconsole_auth_database_name`
: **String** --- The database the console authentication will use. Note that if you are not automatically configuring the auth database, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_auth_database_user`
: **String** --- The PostgreSQL user the console authentication will use. Note that if you are not automatically configuring the databases, this user must already exist on the PostgreSQL server and must be able to edit the auth database.

`q_puppet_enterpriseconsole_auth_database_password`
: **String** --- The password for the auth database's PostgreSQL user.

`q_puppet_enterpriseconsole_smtp_host`
: **String** -- The SMTP server with which to email account activation codes to new console users.

`q_vendor_packages_install`
: **Y or N** --- Whether to install additional packages from your OS vendor's repository, if the upgrader determines any are needed.
 -->

Uninstaller Answers
-----

`q_pe_uninstall`
: **Y or N** --- Whether to uninstall. Answer files must set this to Y.

`q_pe_purge`
: **Y or N** --- Whether to purge additional files when uninstalling, including all
  configuration files, modules, manifests, certificates, and the
  home directories of any users created by the PE installer.

`q_pe_remove_db`
: **Y or N** --- Whether to remove any PE-specific databases when uninstalling.

`q_pe_db_root_pass`
: **String** --- The PostgreSQL root user's password, to be used when deleting
  databases. Only used when `q_pe_remove_db` is Y.


* * *

- [Next: What gets installed where?](./install_what_and_where.html)
