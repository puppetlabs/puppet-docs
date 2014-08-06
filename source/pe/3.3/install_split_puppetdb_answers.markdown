---
layout: default
title: "PE 3.3 » Installing » Installing Split PuppetDB Answer File"
subtitle: "Split Puppet Enterprise Install, PuppetDB Answer File Reference"
canonical: "/pe/latest/install_split_puppetdb_answers.html"
---

The following answers can be used as baseline to perform an automated split installation of PE on the node assigned to the PuppetDB component.

A .txt file version can be found in the `answers` directory of the PE installer tarball.

See the [Answer File Overview](./install_answer_file_reference.html) and the section on [automated installation](./install_automated.html) for more details.

>**Warning**: If you're performing a split installation of PE using the automated installation process, install the components in the following order:
>
> 1. Puppet master
> 2. Puppet DB and database support (which includes the console database)
> 3. The PE console 

### Global Answers
These answers are always needed.

`q_install=y`
: **Y** or **N** --- Whether to install. Answer files must set this to "Y".

`q_vendor_packages_install=y`
: **Y** or **N** --- Whether the installer has permission to install additional packages from the OS’s repositories. If this is set to "N", the installation will fail if the installer detects missing dependencies.

#### Additional Global Answers

These answers are optional.

`q_run_updtvpkg`
: **Y** or **N** --- Only used on AIX. Whether to run `updtvpkg` command to add info about native libraries to the RPM database. The answer should usually be "Y", unelss you have special needs around the RPM.

### Component Answers
These answers are always needed.

`q_puppetmaster_install=n`
: **Y** or **N** --- Whether to install the puppet master component.

`q_puppetdb_install=y`
: **Y** or **N** --- Whether to install the database support (the console Postgres server and PuppetDB) component.

`q_puppet_cloud_install=n`
: **Y** or **N** --- Whether to install the cloud provisioner component.

### Additional Component Answers

These answers are optional.

`q_puppetagent_install`
: **Y** or **N** --- Whether to install the puppet agent component.

### Puppet Agent Answers
These answers are always needed.

`q_puppetagent_certname=pe-puppetdb.<your local domain>`
: **String** --- An identifying string for this agent node. This per-node ID must be unique across your entire site. Fully qualified domain names are often used as agent certnames.

`q_puppetagent_server=pe-master.<your local domain>`
: **String** --- The hostname of the puppet master server. For the agent to trust the master’s certificate, this must be one of the valid DNS names you chose when installing the puppet master.

`q_fail_on_unsuccessful_master_lookup=y`
: **Y** or **N** --- Whether to quit the install if the puppet master cannot be reached.

`q_skip_master_verification=n`
: **Y** or **N** --- This is a silent install option, default is "N". When set to "Y", the installer will skip master verification which allows the user to deploy agents when they know the master won’t be available.

### Puppet Master Answers
These answers are generally needed if you are installing the puppet master role.

`q_puppetmaster_certname=${q_puppetagent_server}`
: **String** --- An identifying string for the puppet master. This ID must be unique across your entire site. The server’s fully qualified domain name is often used as the puppet master’s certname.

`q_puppet_enterpriseconsole_database_name=console`
: **String** --- The database the console will use. Note that if you are not installing the database support role, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_database_user=console`
: **String** --- The PostgreSQL user the console will use. Note that if you are not installing the database support role, this user must already exist on the PostgreSQL server and must be able to edit the console’s database.

`q_puppet_enterpriseconsole_database_password=<your password>`
: **String** --- The password for the console’s PostgreSQL user.

`q_puppet_enterpriseconsole_auth_database_name=console_auth`
: **String** --- The database the console authentication will use. Note that if you are not installing the database support role, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_auth_database_user=console_auth`
: **String** --- The PostgreSQL user the console authentication will use. Note that if you are not installing the database support role, this user must already exist on the PostgreSQL server and must be able to edit the auth database.

`q_puppet_enterpriseconsole_auth_database_password=<your password>`
: **String** --- The password for the auth database’s PostgreSQL user.

#### Additional Puppet Master Answers

These answers are optional.

`q_tarball_server`
: **String** --- The location from which PE agent tarballs will be downloaded before installation. Note that agent tarballs are only available for certain operating systems. For details, see the [PE agent installation instructions](./install_agents.html).

### Database Support Answers
These answers are only needed if you are installing the database support role.

`q_database_install=y`
: **Y** or **N** --- Whether or not to install the PostgreSQL server that supports the console.

`q_puppetdb_database_name=pe-puppetdb`
: **String** --- The database PuppetDB will use.

`q_puppetdb_database_password=<your password>`
: **String** --- The password for PuppetDB’s root user.

`q_puppetdb_database_user=pe-puppetdb`
: **String** --- PuppetDB’s root user name.

#### Additional Database Support Answers

`q_database_root_password`
: **String** --- The password for the console's PostgreSQL user.

`q_database_root_user`
: **String** --- The console's PostgreSQL root user name.

`q_puppetdb_plaintext_port`
: **Integer** --- The port on which PuppetDB accepts plain-text HTTP connections (default port is 8080).

