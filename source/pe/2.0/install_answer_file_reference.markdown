---
layout: pe2experimental
title: "PE 2.0 » Installing » Answer File Reference"
---

* * *

&larr; [Installing: Automated Installation](./install_automated.html) --- [Index](./) --- [Installing: What gets installed where?](./install_what_and_where.html) &rarr;

* * *


Answer File Reference
=====================

Answer files are used when doing an automated installation of PE. See [the chapter on automated installation](./install_automated.html) for more details.

Answer File Syntax
------------------

Answer files consist of normal shell script variable assignments:

    q_puppet_enterpriseconsole_database_port=3306

Boolean answers should use Y or N (case-insensitive) rather than true, false, 1, or 0. 

A variable can be omitted if another answer ensures that it won't be used (i.e. `q_puppetmaster_certname` can be left blank if `q_puppetmaster_install` = n). 

Answer files can include arbitrary bash control logic, and can assign variables with commands in subshells (`$(command)`). For example, to set an agent node's certname to its fqdn:

    q_puppetagent_certname=$(hostname -f)

To set it to a UUID:

    q_puppetagent_certname=$(uuidgen)

Sample Answer Files
-------------------

PE includes a collection of sample answer files in the `answers` directory of your distribution tarball. A successful installation will also save an answer file called `answers.lastrun`, which can be used as a foundation for later installations. Finally, you can generate a new answer file without installing by running the installer with the `-s` option and a filename argument.

List of Answers
---------------

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


### Puppet Master Answers

These answers are only needed if you are installing the puppet master role. 

`q_puppetmaster_certname`
: **String** --- An identifying string for the puppet master. This ID must be unique across your entire site. The server's fully qualified domain name is often used as the puppet master's certname.

`q_puppetmaster_dnsaltnames`
: **String** --- Valid DNS names at which the puppet master can be reached. Must be a comma-separated list. In a normal installation, defaults to `<hostname>,<hostname.domain>,puppet,puppet.<domain>`.

`q_puppetmaster_enterpriseconsole_hostname`
: **String** --- The hostname of the server running the console role. Only needed if you are _not_ installing the console role on the puppet master server. 

`q_puppetmaster_enterpriseconsole_port`
: **Integer** --- The port on which to contact the console server. Only needed if you are _not_ installing the console role on the puppet master server. 


### Console Answers

These answers are only needed if you are installing the console role. 

`q_puppet_enterpriseconsole_httpd_port`
: **Integer** --- The port on which to serve the console. If this is set to 443, you can access the console from a web browser without manually specifying a port. 

`q_puppet_enterpriseconsole_auth_user`
: **String** --- The user name for accessing the console's web interface.

`q_puppet_enterpriseconsole_auth_password`
: **String** --- The password for accessing the console's web interface. Must be longer than four characters.

`q_puppet_enterpriseconsole_inventory_certname`
: **String** --- An identifying string for the inventory service. This ID must be unique across your entire site. Only needed if you are _not_ installing the puppet master role on the console server.

`q_puppet_enterpriseconsole_inventory_dnsaltnames`
: **String** --- Valid DNS names at which the console server can be reached. Only needed if you are _not_ installing the puppet master role on the console server. Must be a comma-separated list. In a normal installation, defaults to `<hostname>,<hostname.domain>,puppetinventory,puppetinventory.<domain>`.

`q_puppet_enterpriseconsole_database_install`
: **Y or N** --- Whether to install and configure a new MySQL database from the OS's package repositories. If set to Y, the installer will also create a new database and user with the `..._name, ..._user,` and `..._password` answers below.

`q_puppet_enterpriseconsole_database_root_password`
: **String** --- A new password to use for MySQL's root user. Only used when `q_puppet_enterpriseconsole_database_install` is Y.

`q_puppet_enterpriseconsole_database_remote`
: **Y or N** --- Whether the pre-existing database is on a remote MySQL server. Only used when `q_puppet_enterpriseconsole_database_install` is N.

`q_puppet_enterpriseconsole_database_host`
: **String** --- The hostname of the remote MySQL server. Only used when `q_puppet_enterpriseconsole_database_remote` is Y.

`q_puppet_enterpriseconsole_database_port`
: **String** --- The port used by the remote MySQL server. Only used when `q_puppet_enterpriseconsole_database_remote` is Y. In a normal installation, defaults to `3306`.

`q_puppet_enterpriseconsole_database_name`
: **String** --- The database the console will use. If you are not installing a new MySQL server, this database must already exist on the MySQL server.

`q_puppet_enterpriseconsole_database_user`
: **String** --- The MySQL user the console will use. If you are not installing a new MySQL server, this user must already exist on the MySQL server and must be able to edit the console's database.

`q_puppet_enterpriseconsole_database_password`
: **String** --- The password for the console's MySQL user.


<!-- TODO: answers for the upgrader. -->

* * *

&larr; [Installing: Automated Installation](./install_automated.html) --- [Index](./) --- [Installing: What gets installed where?](./install_what_and_where.html) &rarr;

* * *

