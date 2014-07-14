---
layout: default
title: "PE 3.3 » Installing » Installing Monolithic Answer File"
subtitle: "Monolithic Puppet Enterprise Install Answer File Reference"
canonical: "/pe/latest/install_mono_answers.html"
---

The following answers can be used to perform an automated monolithic (all-in-one) installation of PE. 

A .txt file version can be found in the `answers` directory of the PE installer tarball.

See the [Answer File Overview](./install_answer_file_reference.html) and the section on [automated installation](./install_automated.html) for more details.

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

### Components

These answers are always needed.

`q_puppetmaster_install=y`
: **Y** or **N** --- Whether to install the puppet master component.

`q_all_in_one_install=y`
: **Y** or **N** --- Whether or not the installation is an all-in-one installation, (i.e., are PuppetDB and the console also being installed on this node). 

`q_puppet_cloud_install=n`
: **Y** or **N** --- Whether to install the cloud provisioner component.

#### Additional Component Answers

These answers are optional.

`q_puppetagent_install`
: **Y** or **N** --- Whether to install the puppet agent component.

### Puppet Agent Answers

These answers are always needed.

`q_puppetagent_certname=pe-puppet.<your local domain>`
: **String** --- An identifying string for this agent node. This per-node ID must be unique across your entire site. Fully qualified domain names are often used as agent certnames.

### Puppet Master Answers

These answers are generally needed if you are installing the puppet master component.

`q_puppetmaster_certname=pe-puppet.<your local domain>`
: **String** --- An identifying string for the puppet master. This ID must be unique across your entire site. The server’s fully qualified domain name is often used as the puppet master’s certname.

`q_puppetmaster_dnsaltnames=pe-puppet,pe-puppet.<your local domain>`
: **String** --- Valid DNS names at which the puppet master can be reached. Must be a comma-separated list. In a normal installation, defaults to `<hostname>,<hostname.domain>,puppet,puppet.<domain>`.

`q_pe_check_for_updates=n`
: **y** or **n**; **MUST BE LOWERCASE** --- Whether to check for updates whenever the pe-httpd service restarts. To get the correct update info, the server will pass some basic, anonymous info to Puppet Labs’ servers. Specifically, it will transmit:

   * the IP address of the client
   * the type and version of the client’s OS
   * the installed version of PE
   * the number of nodes licensed and the number of nodes used

If you wish to disable update checks (e.g. if your company policy forbids transmitting this information), you will need to set this to "n". You can also disable checking after installation by editing the `/etc/puppetlabs/installer/answers.install` file.

`q_disable_live_manangement=n`
: **Y** or **N** --- Whether to disable or enable live management in the console. Note that you need to manually add this question to your answer to file before an installation or upgrade.

`q_puppet_enterpriseconsole_httpd_port=443`
: **Integer** --- The port on which to serve the console. The default is port 443, which will allow access to the console from a web browser without manually specifying a port. If port 443 is not available, the installer will try port 3000, 3001, 3002, 3003, 3004, and 3005.

`q_puppet_enterpriseconsole_auth_user_email=<your email>`
: **String** --- The email address the console’s admin user will use to log in.

`q_puppet_enterpriseconsole_auth_password=<your password>`
: **String** --- The password for the console’s admin user. Must be longer than eight characters.

`q_puppet_enterpriseconsole_smtp_host=smtp.<your local domain>`
: **String** --- The SMTP server used to email account activation codes to new console users.

`q_puppet_enterpriseconsole_smtp_port=25`
: **Integer** --- The port to use when contacting the SMTP server.

`q_puppet_enterpriseconsole_smtp_use_tls=n`
: **Y** or **N** --- Whether to use TLS when contacting the SMTP server.

`q_puppet_enterpriseconsole_smtp_user_auth=n`
: **Y** or **N** --- Whether to authenticate to the SMTP server with a username and password.

`q_puppet_enterpriseconsole_smtp_username=`
: **String** --- The username to use when contacting the SMTP server. Only used when q\_puppet\_enterpriseconsole\_smtp\_user\_auth is "Y".

`q_puppet_enterpriseconsole_smtp_password=`
: **String** --- The password to use when contacting the SMTP server. Only used when q\_puppet\_enterpriseconsole\_smtp\_user\_auth is "Y".

`q_public_hostname=`
: **String** --- A publicly accessible hostname where the console can be accessed if the host name resolves to a private interface (e.g., Amazon EC2). This is set automatically by the installer on EC2 nodes, but can be set manually in environments with multiple hostnames.

#### Additional Puppet Master Answers

These answers are optional.

`q_tarball_server`
: **String** --- The location from which PE agent tarballs will be downloaded before installation. Note that agent tarballs are only available for certain operating systems. For details, see the [PE agent installation instructions](./install_agents.html).

### Database Support Answers

These answers are only needed if you are installing the database support component.

`q_database_install=y`
: **Y** or **N** --- Whether or not to install the PostgreSQL server that supports the console.

`q_puppetdb_database_name=pe-puppetdb`
: **String** --- The database PuppetDB will use.

`q_puppetdb_database_password=<your password>`
: **String** --- The password for PuppetDB’s root user.

`q_puppetdb_database_user=pe-puppetdb`
: **String** — PuppetDB’s root user name.

#### Additional Database Support Answers

`q_database_root_password`
: **String** --- The password for the console's PostgreSQL user.

`q_database_root_user`
: **String** --- The console's PostgreSQL root user name.

`q_puppetdb_plaintext_port`
: **Integer** --- The port on which PuppetDB accepts plain-text HTTP connections (default port is 8080).



