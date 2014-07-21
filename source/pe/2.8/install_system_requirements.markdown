---
layout: default
title: "PE 2.8  » Installing » System Requirements"
subtitle: "System Requirements and Pre-Installation"
canonical: "/pe/latest/install_system_requirements.html"
---

Before installing Puppet Enterprise:

* Ensure that your nodes are running a supported operating system.
* Ensure that your puppet master and console servers are sufficiently powerful.
* Ensure that your network, firewalls, and name resolution are configured correctly.
* Plan to install the puppet master server before the console server, and the console server before any agent nodes.

Operating System
-----

Puppet Enterprise 2.8 supports the following systems:

|       Operating system       |  Version(s)          |       Arch        |   Roles   |
|------------------------------|-------------------|-------------------|-----------|
| Red Hat Enterprise Linux     | 5 and 6           | x86 and x86\_64   | all roles |
| CentOS                       | 5 and 6           | x86 and x86\_64   | all roles |
| Ubuntu LTS                   | 10.04 and 12.04   | 32- and 64-bit    | all roles |
| Debian                       | Squeeze (6)       | i386 and amd64    | all roles |
| Oracle Linux                 | 5 and 6           | x86 and x86\_64   | all roles |
| Scientific Linux             | 5 and 6           | x86 and x86\_864  | all roles |
| SUSE Linux Enterprise Server | 11                | x86 and x86\_864  | all roles |
| Solaris                      | 10                | SPARC and x86\_64 | agent     |
| Microsoft Windows            | 2003, 2008, and 7 | x86 and x86\_864  | agent     |
| AIX            | 5, 6, and 7 | Power Arch.  | agent     |

<br>

> *Note:* Upgrading your OS while PE is installed can cause problems with PE. To perform an OS upgrade, you'll need to uninstall PE, perform the OS upgrade, and then reinstall PE as follows:
>
1. Back up your databases and other PE files.
>
2. Perform a complete [uninstall](/pe/2.8/install_uninstalling.html) (including the -pd uninstaller option).
>
3. Upgrade your OS.
>
4. [Install PE](/pe/2.8/install_basic.html).
>
5. Restore your backup.

Hardware
-----

Puppet Enterprise's hardware requirements depend on the roles a machine performs. 

* The **puppet master** role should be installed on a robust, dedicated server.
    * Minimum requirements: 2 processor cores, 1 GB RAM, and very accurate timekeeping.
    * Recommended requirements: 2-4 processor cores, at least 4 GB RAM, and very accurate timekeeping. Performance will vary, but this configuration can generally manage approximately 1,000 agent nodes.
* The **console** role should usually be installed on a separate server from the puppet master, but can optionally be installed on the same server.
    * Minimum requirements: A machine able to handle moderate web traffic, perform processor-intensive background tasks, and run a disk-intensive MySQL database server. Requirements will vary significantly depending on the size and complexity of your site.
* The **cloud provisioner** role has very modest requirements.
    * Minimum requirements: A system which provides interactive shell access for trusted users. This system should be kept very secure, as the cloud provisioning tools must be given cloud service account credentials in order to function.
* The **puppet agent** role has very modest requirements.
    * Minimum requirements: Any hardware able to comfortably run a supported operating system.


Configuration
-----

Before installing Puppet Enterprise at your site, you should make sure that your nodes and network are properly configured.

### Name Resolution

* Decide on a preferred name or set of names agent nodes can use to contact the puppet master server.
* Ensure that the puppet master server can be reached via domain name lookup by all of the future puppet agent nodes at the site.

You can also simplify configuration of agent nodes by using a CNAME record to make the puppet master reachable at the hostname `puppet`. (This is the default puppet master hostname that is automatically suggested when installing an agent node.)

### Firewall Configuration

Configure your firewalls to accomodate Puppet Enterprise's network traffic. The short version is that you should open up ports **8140, 61613, and 443.** The more detailed version is:

* All agent nodes must be able to send requests to the puppet master on ports **8140** (for Puppet) and **61613** (for MCollective).
* The puppet master must be able to accept inbound traffic from agents on ports **8140** (for Puppet) and **61613** (for MCollective).
* Any hosts you will use to access the console must be able to reach the console server on port **443,** or whichever port you specify during installation. (Users who cannot run the console on port **443** will often run it on port **3000**.)
* If you will be invoking MCollective client commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.**
* If you will be running the console and puppet master on separate servers, the console server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **443** and **8140.** The Dashboard server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.

### Dependencies and OS Specific Details

This section details the packages that are installed from the various OS repos.  Unless you do not have internet access, you shouldn't need to worry about installing these manually, they will be set up during PE installation.

***Amazon Linux AMI***

|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  apr                           |  apr                                 |  sudo                                         |  libxslt
|  system-logos      |  apr-util                     |  apr-util                           |  mysql51                                    |  libxml2
|  which                  | curl                           |  curl                                |  mysql51-server                         |  
|  libxml2                | mailcap                     | mailcap
|  dmidecode         | java-1.6.0-openjdk*   | 
| net-tools              |            

*Only needed if java isn't already installed.
<br>

***Centos***

|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  apr                           |  apr                                 |  sudo                                         |  libxslt
|  system-logos      |  apr-util                     |  apr-util                           |  mysql                                        |  libxml2
|  which                  | curl                           |  curl                                |  mysql-server                             |  
|  libxml2                | mailcap                     | mailcap
|  dmidecode         |                                   | 
| net-tools              |      
| java-1.6.0-openjdk*         

*Only needed if java isn't already installed.
<br>

***RHEL***

|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  apr                           |  apr                                 |  sudo                                         |  libxslt
|  system-logos      |  apr-util                     |  apr-util                           |  mysql                                        |  libxml2
|  which                  | apr-util-ldap (RHEL 6) |  curl                             |  mysql-server                             |  
|  libxml2                |   curl                            | mailcap                        |
|  dmidecode         |  mailcap                       | apr-util-ldap (RHEL 6)  |
| net-tools              |    java-1.6.0-openjdk*  |
|  cronie (RHEL 6)
| vixie-cron (RHEL 5)       

*Only needed if java isn't already installed.
<br>

***SLES***

|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  libapr1                        |  libapr1                        |  sudo                                         |  libxslt
|  pmtools              |  libapr-util1                   |  libapr-util1                  |  mysql                                        |  libxml2
|  cron                    |  java-1_6_0-ibm          |  curl                             |  mysql-client                             |  
|  libxml2                |   curl                            |                                     |
|  net-tools             |                                     |                                     |
  
  <br>  
  
***Debian***

|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  file                             |  file                              |  mysql-common                           |  libxslt1.1                            |
|  dmidecode         |  libmagic1                   |  libmagic1                   |  mysql-server                               |  
|  cron                    |  libpcre3                     |  libpcre3                      |  mysql-client                                |  
|  libxml2                |  curl                            |  curl                             |
|  hostname           |  perl                            |  perl                             |
|  libldap-2.4-2       |  mime-support            |  mime-support             |
|  libreadline5        |  libapr1                        |  libapr1                        |
|                            |  libcap2                        |  libcap2                       |
|                            |  libaprutil1                    |  libaprutil1                   |
|                            |  libaprutil1-dbd-sqlite3 |  libaprutil1-dbd-sqlite3 |
|                            |  libaprutil1-ldap            |  libaprutil1-ldap            |
|                            |  openjdk-6-jre-headless |

<br>


***Ubuntu***


|       All Nodes       |  Master Nodes          |       Console Nodes        |   Console/Console DB Nodes   |   Cloud Provisioner Nodes  |
|------------------------|-----------------------------|---------------------------------|-------------------------------------------|-------------------------------------|
|   pciutils               |  file                             |  file                              |  mysql-common                           |  libxslt1.1                            |
|  dmidecode         |  libmagic1                   |  libmagic1                   |  mysql-server                               |  
|  cron                    |  libpcre3                     |  libpcre3                      |  mysql-client                                |  
|  libxml2                |  curl                            |  curl                             |
|  hostname           |  perl                            |  perl                             |
|  libldap-2.4-2       |  mime-support            |  mime-support             |
|  libreadline5        |  libapr1                        |  libapr1                        |
|                            |  libcap2                        |  libcap2                       |
|                            |  libaprutil1                    |  libaprutil1                   |
|                            |  libaprutil1-dbd-sqlite3 |  libaprutil1-dbd-sqlite3 |
|                            |  libaprutil1-ldap            |  libaprutil1-ldap            |
|                            |  openjdk-6-jre-headless |

<br>

***AIX***  
In order to run the puppet agent on AIX systems, you'll need to ensure the following are installed before attempting to install the puppet agent:

* bash
* zlib
* readline

All [AIX toolbox packages](http://www-03.ibm.com/systems/power/software/aix/linux/toolbox/alpha.html) are available from IBM.

To install the packages on your selected node directly, you can run `rpm -Uvh` with the following URLs (note that the RPM package provider on AIX must be run as root):  

 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/bash/bash-3.2-1.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/zlib/zlib-1.2.3-4.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm

*Note:* if you are behind a firewall or running an http proxy, the above commands may not work. Use the link above instead to find the packages you need.

*Note:* GPG verification will not work on AIX, the RPM version used by AIX (even 7.1) is too old. Also, The AIX package provider doesn't support package downgrades (installing an older package over a newer package). Lastly, avoid using leading zeros when specifying a version number for the AIX provider (i.e., use `2.3.4` not `02.03.04`).

The PE AIX implementation supports the NIM, BFF, and RPM package providers. Check the [Type Reference](reference_type.html#package) for technical details on these providers.

***Solaris***  
In some instances, bash may not be present on Solaris systems. It needs to be installed before running the PE installer. Install it via the media used to install the OS or via CSW if that is present on your system.


Next
----

* To install Puppet Enterprise on \*nix nodes, continue to [Installing Puppet Enterprise](./install_basic.html).
* To install Puppet Enterprise on Windows nodes, continue to [Installing Windows Agents](./install_windows.html).
