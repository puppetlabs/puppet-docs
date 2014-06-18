---
layout: default
title: "PE 3.2 » Installing » Answer File Reference"
subtitle: "Answer File Reference"
canonical: "/pe/latest/install_answer_file_reference.html"
---

Answer files are used for automated installations of PE. See [the section on automated installation](./install_automated.html) for more details.

Answer File Syntax
------------------

Answer files consist of normal shell script variable assignments:

    q_database_port=3306

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
: **Y or N** --- Whether the installer has permission to install additional packages from the OS's repositories. If set to N, the installation will fail if the installer detects missing dependencies.

`q_run_updtvpkg`
: **Y or N** --- Only used on AIX. Whether to run the `updtvpkg` command to add info about native libraries to the RPM database. The answer should usually be Y, unless you have special needs around the RPM database.

These answers are only used in some cases, such as when upgrading or reinstalling.

`q_backup_and_purge_old_configuration`
: **Y or N** --- Whether the installer should backup the existing configuration files and then purge them, or leave them in place. If set to N the installer will fail. This is only needed if Puppet Enterprise was uninstalled without the `-p` option.

`q_upgrade_installation`
: This option is no longer used, upgrades will be detected automatically.

`q_continue_or_reenter_master_hostname`
: **C or R** --- Used if the installer cannot reach the puppet master. If C, the installer will continue; if R, the installer will ask for a new puppet master hostname. (This answer applies to all roles except for the master role.)

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

`q_skip_master_verification`
: **Y or N** --- This is a silent install option, default is N. When set to Y, the installer will skip master verification which allows the user to deploy agents when they know the master won't be available.

`q_puppet_agent_first_run`
: **Y or N** --- Controls whether or not the puppet agent should run after being installed. 

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

`q_pe_check_for_updates`
: **y or n; MUST BE LOWERCASE** --- Whether to check for updates whenever the `pe-httpd` service restarts. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs' servers. Specifically, it will transmit:

  * the IP address of the client
  * the type and version of the client's OS
  * the installed version of PE
  * the number of nodes licensed and the number of nodes used

  If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to set this to `n`. You can also disable checking after installation by editing the `/etc/puppetlabs/installer/answers.install` file.

`q_tarball_server`
: **String** --- The location from which PE agent tarballs will be downloaded before installation. Note that agent tarballs are only available for certain operating systems. For details, see [the PE installation instructions](./install_basic.html)

### Console Answers

These answers are generally needed if you are installing the console role.

`q_database_host`
: **String** --- The hostname of the server running the PostgreSQL server that supports the console.

`q_database_port`
: **Integer** --- The port where the PostgreSQL server that supports the console can be reached.

`q_disable_live_manangement`
: **Y or N** --- Whether to disable or enable live management in the console. Note that you need to manually add this question to your answer to file before an installation or upgrade.

`q_pe_database`
: **Y or N** --- Whether to have the Postgres server for the console installed by PE or to manage it yourself. Used for classifying PuppetDB in the console, so it knows whether or not to manage the database.

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

`q_puppet_enterpriseconsole_smtp_port`
: **Integer** -- The port to use when contacting the SMTP server.

`q_puppet_enterpriseconsole_smtp_use_tls`
: **Y or N** -- Whether to use TLS when contacting the SMTP server.

`q_puppet_enterpriseconsole_smtp_user_auth`
: **Y or N** -- Whether to authenticate to the SMTP server with a username and password.

`q_puppet_enterpriseconsole_smtp_username`
: **String** -- The username to use when contacting the SMTP server. Only used when `q_puppet_enterpriseconsole_smtp_user_auth` is Y.

`q_puppet_enterpriseconsole_smtp_password`
: **String** -- The password to use when contacting the SMTP server. Only used when `q_puppet_enterpriseconsole_smtp_user_auth` is Y.

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

  If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to set this to `n`. You can also disable checking after installation by editing the `/etc/puppetlabs/installer/answers.install` file.
  
`q_public_hostname` 
: **String** ---   A publicly accessible hostname where the console can be accessed if the host name resolves  to a private interface (e.g., Amazon EC2). This is set automatically by the installer on EC2 nodes, but can be set manually in environments with multiple hostnames.

`q_backup_and_purge_old_database_directory`
: **Y or N** --- Whether the installer should backup the existing database directory and then purge it, or leave it in place. If set to N the installer will fail. Used when Puppet Enterprise was uninstalled without the `-d` option.

`q_database_transfer`
: **Y or N** --- Used when upgrading from PE 2.x to PE 3.x. Controls whether or not the existing data in the PE 2.x MySQL database should be converted and transferred to the newer PostgreSQL database.

### Database Support Answers

These answers are only needed if you are installing the database support role.

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

`q_puppetdb_plaintext_port`
: **Integer** --- The port on which PuppetDB accepts plain-text HTTP connections (default port is 8080).

`q_upgrade_with_low_disk_space`
: **Y or N** --- Used when upgrading and the amount of disk space available appears to be too low for the database to be converted. This can be a false alarm at times if the dataabse has not been vacuumed. If N the install will fail.

`q_upgrade_with_unknown_disk_space`
: **Y or N** --- Used when upgrading and the amount of disk space available cannot be determined.  If N the install will fail.

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


* * *

- [Next: What gets installed where?](./install_what_and_where.html)
