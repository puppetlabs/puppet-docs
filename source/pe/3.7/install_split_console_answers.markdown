---
layout: default
title: "PE 3.7 » Installing » Installing Split Console Answer File"
subtitle: "Split Puppet Enterprise Install, Console Answer File Reference"
canonical: "/pe/latest/install_split_console_answers.html"
---

The following example answers can be used to perform an automated split installation of PE on the node assigned to the console component. 

A .txt file version can be found in the `answers` directory of the PE installer tarball.

See the [Answer File Overview](./install_answer_file_reference.html) and [Installing with an answer file](./install_automated.html) for more details. In addition, [the Complete Answer File Reference](./install_complete_answer_file_reference.html) contains all answers that you can use to install PE.

>**Warning**: If you're performing a split installation of PE using an answer file, install the components in the following order:
>
> 1. Puppet master
> 2. Puppet DB and database support (which includes the console database)
> 3. The PE console 

### Global Answers

These answers are always needed.

`q_install=y`
: **Y** or **N** --- Whether to install. Answer files must set this to "Y".

`q_vendor_packages_install=y`
: **Y** or **N** --- Whether the installer has permission to install additional packages from the OS’s repositories. If this is set to N, the installation will fail if the installer detects missing dependencies.

#### Additional Global Answers

These answers are optional.

`q_run_updtvpkg`
: **Y** or **N** --- Only used on AIX. Whether to run `updtvpkg` command to add info about native libraries to the RPM database. The answer should usually be "Y", unelss you have special needs around the RPM.

### Component Answers

These answers are always needed.

`q_puppetmaster_install=n`
: **Y** or **N** --- Whether to install the Puppet master component.

`q_puppetdb_install=n`
: **Y** or **N** --- Whether to install the database support (the console PostgreSQL server and PuppetDB) component.

`q_puppet_enterpriseconsole_install=y`
: **Y** or **N** --- Whether to install the console component.

`q_puppet_cloud_install=n`
: **Y** or **N** --- Whether to install the cloud provisioner component.

### Additional Component Answers

These answers are optional.

`q_puppetagent_install`
: **Y** or **N** --- Whether to install the Puppet agent component.

### Puppet Agent Answers
These answers are always needed.

`q_puppetagent_certname=pe-console.<your local domain>`
: **String** --- An identifying string for this agent node. This per-node ID must be unique across your entire site. Fully qualified domain names are often used as agent certnames.

`q_puppetagent_server=pe-master.<your local domain>`
: **String** --- The hostname of the Puppet master server. For the agent to trust the master’s certificate, this must be one of the valid DNS names you chose when installing the Puppet master.

`q_fail_on_unsuccessful_master_lookup=y`
: **Y** or **N** --- Whether to quit the install if the Puppet master cannot be reached.

`q_skip_master_verification=n`
: **Y** or **N** --- This is a silent install option, default is N. When set to "Y", the installer will skip master verification which allows the user to deploy agents when they know the master won’t be available.

### Puppet Master Answers
These answers are generally needed if you are installing the Puppet master component.

`q_disable_live_manangement=n`
: **Y** or **N** --- Whether to disable or enable live management in the console. Note that you need to manually add this question to your answer to file before an installation or upgrade.

`q_pe_database=y`
: **Y** or **N** --- Whether to have the PostgreSQL server for the console managed by PE or to manage it yourself. Set to "Y" if you're using PE-managed PostgreSQL.

`q_puppet_enterpriseconsole_auth_user_email=<your email>`
: **String** --- The email address the console’s admin user will use to log in.

`q_puppet_enterpriseconsole_auth_password=<your password>`
: **String** --- The password for the console’s admin user. Must be longer than eight characters.

`q_puppet_enterpriseconsole_database_name=console`
: **String** --- The database the console will use. Note that if you are not installing the database support component, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_database_user=console` 
: **String** --- The PostgreSQL user the console will use. Note that if you are not installing the database support component, this user must already exist on the PostgreSQL server and must be able to edit the console’s database.

`q_puppet_enterpriseconsole_database_password=<your password>`
: **String* --- The password for the console’s PostgreSQL user.

`q_puppet_enterpriseconsole_auth_database_name=console_auth`
: **String** --- The database the console authentication will use. Note that if you are not installing the database support component, this database must already exist on the PostgreSQL server.

`q_puppet_enterpriseconsole_auth_database_user=console_auth`
: **String** --- The PostgreSQL user the console authentication will use. Note that if you are not installing the database support component, this user must already exist on the PostgreSQL server and must be able to edit the auth database.

`q_puppet_enterpriseconsole_auth_database_password=<your password>`
: **String** --- The password for the auth database’s PostgreSQL user.

`q_public_hostname=`
: **String** --- A publicly accessible hostname where the console can be accessed if the host name resolves to a private interface (e.g., Amazon EC2). This is set automatically by the installer on EC2 nodes, but can be set manually in environments with multiple hostnames.

#### Additional Puppet Master Answers

These answers are optional.

`q_tarball_server`
: **String** --- The location from which PE agent tarballs will be downloaded before installation. Note that agent tarballs are only available for certain operating systems. For details, see the [PE agent installation instructions](./install_agents.html).

#### Additional Console Answers

`q_puppet_enterpriseconsole_master_hostname`
: **String** --- The hostname of the server running the master component. Only needed in a split install.


### Database Support Answers
These answers are only needed if you are installing the database support component.

`q_database_host=pe-puppetdb.localdomain`
: **String** --- The hostname of the server running the PostgreSQL server that supports the console.

`q_database_port=5432`
: **Integer** --- The port where the PostgreSQL server that supports the console can be reached.

`q_puppetdb_database_name=pe-puppetdb`
: **String** --- The database PuppetDB will use.

`q_puppetdb_database_password=strongpassword1748`
: **String** --- The password for PuppetDB’s root user.

`q_puppetdb_database_user=pe-puppetdb`
: **String** --- PuppetDB’s root user name.

`q_puppetdb_hostname=pe-puppetdb.localdomain`
: **String** --- The hostname of the server running PuppetDB.

`q_rbac_database_name=pe-rbac`
: **String** --- The database the RBAC service will use.

`q_rbac_database_password=<your password>`
: **String** --- The password for the RBAC service root user.

`q_rbac_database_user=pe-rbac`
: **String** --- The RBAC service root user name.

`q_activity_database_name=pe-activity`
: **String** --- The database the activity service will use.

`q_activity_database_password=<your password>`
: **String** --- The password for the activity service root user.

`q_activity_database_user=pe-activity`
: **String** --- The activity service root user name.

`q_classifier_database_name=pe-classifier`
: **String** --- The database the node classifier will use.

`q_classifier_database_password=<your password>`
: **String** --- The password for the node classifer root user.

`q_classifier_database_user=pe-classifier`
: **String** --- The node classifier root user name.

#### Additional Database Support Answers

`q_database_root_password`
: **String** --- The password for the console's PostgreSQL user.

`q_database_root_user`
: **String** --- The console's PostgreSQL root user name.

`q_puppetdb_plaintext_port`
: **Integer** --- The port on which PuppetDB accepts plain-text HTTP connections (default port is 8080).


