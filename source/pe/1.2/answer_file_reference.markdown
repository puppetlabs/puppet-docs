---
layout: default
title: "PE 1.2 Manual: Answer File Reference"
canonical: "/pe/latest/install_answer_file_reference.html"
---

{% include pe_1.2_nav.markdown %}

Answer File Reference
=====================

When run with the `-a` or `-A` flag and a filename argument, the Puppet Enterprise installer will read its installation instructions from an answer file. `-a` will use the provided answer file to perform a non-interactive installation (which will fail if any required variables are not set), and `-A` will perform a partially-interactive installation, prompting the user for any missing answers. 

Answer files consist of normal shell script variable assignments (`q_puppetdashboard_database_port=3306`), and can include arbitrary control logic or assign variables based on the output of backtick-wrapped shell commands. One of the most common uses of answer files is to automatically set a puppet agent node's unique identifier (certname) to something other than its fully-qualified domain name; this is most efficiently done by running the installer with `-s ANSWER_FILE`, then editing the resultant file to include, for example:

    q_puppetagent_certname=`uuidgen`

The answer file could then be used for any number of puppet agent installations without further modification or interaction. 

Boolean answers should use Y or N (case-insensitive) rather than true, false, 1, or 0. 

A variable can be omitted if another answer ensures that it won't be used (i.e. `q_puppetmaster_certname` can be left blank if `q_puppetmaster_install` = n). 

Allowed Variables In Answer Files
---------------------------------

### puppet master Answers

`q_puppetmaster_install`
: _Y or N (Default: Y)_ --- Sets whether the puppet master service will be installed on this computer. 

`q_puppetmaster_certname`
: _String (Default: the node's fully-qualified domain name)_ --- Sets the puppet master's SSL certificate common name (CN). This should usually be set to either "puppet" or the server's fully-qualified domain name.

`q_puppetmaster_certdnsnames`
: _String (Default: "puppet:puppet.{domain}:{hostname}:{fully-qualified domain name}")_ --- Sets the puppet master's certified hostnames. Must be a colon-separated list of hostnames and fully-qualified domain names. 

`q_puppetmaster_use_dashboard_reports`
: _Y or N (Default: Y)_ --- Sets whether the puppet master will send reports received from puppet agent nodes to Puppet Dashboard. 

`q_puppetmaster_use_dashboard_classifier`
: _Y or N (Default: Y)_ --- Sets whether the puppet master will request node definitions from Puppet Dashboard. 

`q_puppetmaster_dashboard_hostname`
: _String (Default: "localhost")_ --- Sets the hostname where Puppet Dashboard is located. Used when `q_puppetmaster_use_dashboard_reports` = y or `q_puppetmaster_use_dashboard_classifier` = y.

`q_puppetmaster_dashboard_port`
: _String (Default: "3000")_ --- Sets the port to use when connecting to Puppet Dashboard. Used when `q_puppetmaster_use_dashboard_reports` = y or `q_puppetmaster_use_dashboard_classifier` = y.


### Puppet Dashboard Answers

`q_puppetdashboard_install`
: _Y or N (Default: Y)_ --- Sets whether Puppet Dashboard will be installed on this computer. 

`q_puppetdashboard_httpd_port`
: _String (Default: "3000")_ --- Sets which port Puppet Dashboard will use.

`q_puppetdashboard_database_install`
: _Y or N (Default: Y)_ --- Sets whether to install and configure a new MySQL database from the OS's repositories. 

`q_puppetdashboard_database_root_password`
: _Y or N (Default: Y, unless MySQL is already installed on this system)_ --- Sets the password that will be assigned to MySQL's root user. Used when `q_puppetdashboard_database_install` = y.

`q_puppetdashboard_database_remote`
: _Y or N (Default: Y)_ --- Sets whether the MySQL database server is running on a remote host; if set to N, Dashboard will be configured to connect to a database on localhost. Used when `q_puppetdashboard_database_install` = n.

`q_puppetdashboard_database_host`
: _String (Default: "localhost")_ --- Sets the hostname of the remote MySQL database server. Used when `q_puppetdashboard_database_remote` = y.

`q_puppetdashboard_database_port`
: _String (Default: "3306")_ --- Sets the port used by the remote MySQL database server. Used when `q_puppetdashboard_database_remote` = y.

`q_puppetdashboard_database_name`
: _String (Default: "dashboard")_ --- Sets the name of the database Dashboard will use.

`q_puppetdashboard_database_user`
: _String (Default: "dashboard")_ --- Sets the MySQL user Dashboard will connect to the database server as. This user must already exist on the MySQL server, and must have the necessary privileges (see "Puppet Dashboard" above) for the database Puppet Dashboard will be using.

`q_puppetdashboard_database_password`
: _String or blank (Default: blank)_ --- Sets the password with which Puppet Dashboard's MySQL user will connect to the database.


### puppet agent Answers

`q_puppetagent_install`
: _Y or N (Default: Y)_ --- Sets whether the puppet agent service will be installed on this computer. 

`q_puppetagent_certname`
: _String (Default: the node's fully-qualified domain name)_ --- Sets the unique identifier ("certname") for this puppet agent node's SSL certificate.

`q_puppetagent_server`
: *String (Default: "puppet"; however, if `q_puppetmaster_install` = y, this will default to the value of `q_puppetmaster_certname`.)*  --- Sets the hostname of the puppet master.

`q_puppetagent_pluginsync`
: _Y or N (Default: Y)_ --- Sets whether to sync executable Ruby code (e.g. custom facts, types, and providers) from the puppet master. 


### Other Answers

`q_rubydevelopment_install`
: _Y or N (Default: N)_ --- Sets whether to install the Ruby development libraries for Puppet Enterprise's copy of Ruby.

`q_vendor_packages_install`
: _Y or N (Default: Y)_ --- Sets whether the installer has permission to install additional packages from the operating system's repositories. If this is set to "n," the installation will only go forward if the installer detects no missing dependencies. 

`q_puppet_symlinks_install`
: _Y or N (Default: Y)_ --- Sets whether `/usr/local/bin` should contain symbolic links to the Puppet executables (located in `/opt/puppet/bin`).

`q_install`
: _Y or N (Default: Y)_ --- Sets whether the installation should occur. Setting this to "n" is not considered useful for non-interactive installation.

