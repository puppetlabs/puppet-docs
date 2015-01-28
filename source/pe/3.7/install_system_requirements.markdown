---
layout: default
title: "PE 3.7 » Installing » System Requirements"
subtitle: "System Requirements and Pre-Installation"
canonical: "/pe/latest/install_system_requirements.html"
---

Before installing Puppet Enterprise:

* Ensure that your nodes are running a supported operating system.
* Ensure that your Puppet master and console servers are sufficiently powerful (see the [hardware section](#hardware-requirements) below).
* Ensure that your network, firewalls, and name resolution are configured correctly and all target servers are communicating.
* Plan to install the Puppet master server before the console server, and the console server before any agent nodes. If you are separating components, install them in this order:
    1. Puppet Master
    2. PuppetDB and PostgreSQL
    3. Console
    4. Agents

Operating System
-----

Puppet Enterprise 3.7 supports the following systems:

Operating system             | Version(s)                              | Arch          | Component(s)
-----------------------------|-----------------------------------------|---------------|----------------------------
Red Hat Enterprise Linux     | 4, 5, 6, 7                                   |x86\_64 | all (RHEL 4 supports agent only)
CentOS                       | 4, 5, 6, 7                                 | x86 & x86\_64 | all (CentOS 4 supports agent only)
Ubuntu LTS                   | 10.04, 12.04, 14.04                           | i386 & amd64  | all
Debian                       | Squeeze (6), Wheezy (7)                | i386 & amd64  | all
Oracle Linux                 | 4, 5, 6, 7                                   | x86 & x86\_64 | all (Oracle Linux 4 supports agent only)
Scientific Linux             | 4, 5, 6                                   | x86 & x86\_64 | all (Scientific Linux 4 supports agent only)
SUSE Linux Enterprise Server | 10 (SP4 only), 11 (SP1 and later), 12                      | x86 & x86\_64 (10 also i386; 12 x86\_64 only) | all (SLES 10 supports agent only)
Solaris                      | 10 (Update 9 or later), 11          | SPARC & i386   | agent
Microsoft Windows            | 2008, 2008R2, 7 Ultimate SP1, 8 Pro, 8.1 Pro, 2012, 2012R2| x86 & x64 | agent
Microsoft Windows            | 2003, 2003R2                            | x86           | agent
AIX                          | 5.3, 6.1, 7.1                         | Power         | agent
Mac OS X                     | Mavericks (10.9)                        | x86_64         | agent


>**Note**: Some operating systems require an active subscription with the vendor's package management system to install dependencies, such as Red Hat Network.

>**Note**: In addition, upgrading your OS while PE is installed can cause problems with PE. To perform an OS upgrade, you’ll need to uninstall PE, perform the OS upgrade, and then reinstall PE as follows:
>
>1. [Back up](./maintain_backup_restore.html#back-up-your-database-and-puppet-enterprise-files) your databases and other PE files.
>
>2. Perform a complete [uninstall](./install_uninstalling.html) (including the -p -d uninstaller option).
>
>3. Upgrade your OS.
>
>4. [Install PE](/pe/latest/install_basic.html).
>
>5. [Restore](./maintain_backup_restore.html#restore-your-database-and-puppet-enterprise-files) your backup.

Hardware Requirements
-----

Puppet Enterprise's hardware requirements depend on the size of your environment.  

### Evaluation Environment

An evaluation environment is run on a monolithic installation and is suitable for evaluating PE on 250 or fewer nodes. We recommend that your hardware meets the following: 

- A 4-core server with 4 GB of RAM 
- At least 100 GB of free storage in `/opt` for PuppetDB

### Small Environment

A small environment is run on a monolithic installation and is suitable for running PE on 500 nodes. We recommend that your hardware meets the following: 

- 4-core server with 16 GB of RAM 
  - Amazon EC2 m3.xlarge instance is adequate for this environment
- At least 100 GB of free space in `/opt` on the PuppetDB node
- At least 1 GB of free space in `/var` on each node 

### Medium Environment

A medium environment is run on a split installation and is suitable for running PE on up to 1,000 nodes. We recommend that your hardware meets the following: 

- 4-core servers with 16 GB of RAM  
  - Amazon EC2 m3.xlarge instances are adequate for each of these servers
- At least 100 GB of free space in `/opt` on the PuppetDB node
- At least 1 GB of free space in `/var` on each node

### Large Environment

A large environment is run on a split/large environment installation and is suitable for running PE on 1,000 or more nodes. We recommend that your hardware meets the following:

- **Puppet masters**: Four 4-core servers with 16 GB of RAM and 40 GB of disk space each 
   - Amazon EC2 m3.xlarge instances are adequate for servers in this role. 
- **Console Server**: An 8-core server with 30 GB of RAM and 40 GB of disk space
   - Amazon EC2 m3.2xlarge instances are adequate for servers in this role.
- **PuppetDB**: An 8-core server with 30 GB of RAM and 100 GB of high-performance disk space with write caching enabled 
   - Amazon EC2 m3.2xlarge instances are adequate for servers in this role.
   
For large environments with more than 2,000 nodes under management, it may be necessary to add ActiveMQ resources:

- **ActiveMQ Hub**: 4-8 cores, 8 GB of RAM, and 10 GB of disk space 
- **ActiveMQ Spokes**: 4 cores, 4 GB of RAM, and 10 GB of disk space

It may be desirable to move the certificate authority (CA) role to a separate node. 

- **Certificate Authority**: 4 cores, 4 GB of RAM, 40 GB of storage
 
Supported Browsers
-----

The following browsers are supported for use with the console:

* Chrome: Current version, as of release
* Firefox: Current version, as of release
* Internet Explorer: 9, 10, and 11
* Safari: 7


System Configuration
-----

Before installing Puppet Enterprise at your site, you should make sure that your nodes and network are properly configured.

### Timekeeping

We recommend using NTP or an equivalent service to ensure that time is in sync between your Puppet master and any Puppet agent nodes. If time drifts out of sync in your PE infrastructure, you may encounter issues such as nodes disappearing from live manangement in the console. A service like NTP ([available as a Puppet Labs supported module](https://forge.puppetlabs.com/puppetlabs/ntp)) will ensure accurate timekeeping.

### Name Resolution

* Decide on a preferred name or set of names agent nodes can use to contact the Puppet master server.
* Ensure that the Puppet master server can be reached via domain name lookup by all of the future Puppet agent nodes at the site.

You can also simplify configuration of agent nodes by using a CNAME record to make the Puppet master reachable at the hostname `puppet`. (This is the default Puppet master hostname that is automatically suggested when installing an agent node.)

### Firewall Configuration

[mono_port_diagram]: ./images/mono_port_diagram.svg
[split_port_diagram]: ./images/split_port_diagram.svg
[lei_port_diagram]: ./images/lei_port_diagram.svg


Configure your firewalls to accommodate Puppet Enterprise's network traffic. 

#### For Monolithic Installs

![mono ports][mono_port_diagram]

<table>
  <tr>
    <th>Port</th>
    <th>Use</th>
  </tr>
  <tr>
    <td>8140</td>
    <td>
     <ul>
      <li>The Puppet master uses this port to accept inbound traffic/requests from Puppet agents.</li>
      <li>The PE console sends request to the Puppet master on this port.</li>
      <li>Certificate requests are passed over this port unless ca_port is set differently.</li>
      <li>Classifier group: “PE Master”</li>
     </ul>
    </td>
  </tr>
  <tr>
    <td>443</td>
    <td>
     <ul>
      <li>This port provides host access to the PE console.</li>
      <li>The PE console accepts traffic from the Puppet master on this port.</li>
      <li>Classifier group: “PE Console”</li>
     </ul> 
   </td>
  </tr>
  <tr>
    <td>61613</td>
    <td>
     <ul>
      <li>MCollective uses this port to accept inbound traffic/requests from Puppet agents for orchestration.</li>
      <li>Any host used to invoke orchestration commands must be able to reach MCollective on this port.</li>
      <li>Classifier group: “PE ActiveMQ Broker”</li>
     </ul> 
    </td>
  </tr>
</table>

#### For Split Installs

![split ports][split_port_diagram]                                                                                                             

<table>
  <tr>
    <th>Port</th>
    <th>Use</th>
  </tr>
  <tr>
    <td>8140</td>
    <td>
     <ul>
      <li>The Puppet master uses this port to accept inbound traffic/requests from Puppet agents.</li>
      <li>The PE console sends request to the Puppet master on this port.</li>
      <li>Certificate requests are passed over this port unless ca_port is set differently.</li>
      <li>Classifier group: “PE Master”</li>
     </ul> 
    </td>
  </tr>
  <tr>
    <td>443</td>
    <td>
     <ul>
      <li>This port provides host access to the PE console.</li>
      <li>The PE console accepts traffic from the Puppet master on this port.</li>
      <li>Classifier group: “PE Console”</li>
     </ul>
    </td>
  </tr>
  <tr>
    <td>8081</td>
    <td>
     <ul>
      <li>PuppetDB accepts traffic/requests on this port.</li>
      <li>The Puppet master and PE console send traffic to PuppetDB on this port.</li>
      <li>Classifier group: “PE PuppetDB”</li>
     </ul> 
    </td>
  </tr>
  <tr>
    <td>61613</td>
    <td>
     <ul>
      <li>MCollective uses this port to accept inbound traffic/requests from Puppet agents for orchestration.</li>
      <li>Any host used to invoke orchestration commands must be able to reach MCollective on this port.</li>
      <li>Classifier group: “PE ActiveMQ Broker”</li>
     </ul> 
    </td>
  </tr>
  <tr>
    <td>5432</td>
    <td>
     <ul>
      <li>PostgreSQL runs on this port.</li>
      <li>The PE console node will need to connect to the PuppetDB node hosting the PostgreSQL database on this port.</li>
      <li>Classifier group: “PE PuppetDB”</li>
     </ul> 
    </td>
  </tr>
  <tr>
    <td>4433</td>
    <td>
     <ul>
      <li>This port is used as a Classifier / Console Services API endpoint.</li>
      <li>The Puppet master needs to be able to talk to the Console over this port.</li>
      <li>Classifier group: “PE Console”</li>
     </ul> 
    </td>
  </tr>
  <tr>
    <td>4435</td>
    <td>
     <ul>
      <li>This port is used as a report submission endpoint.</li>
      <li>The Puppet master communicates with the PE console over this port.</li>
      <li>Classifier group: “PE Console”</li>
      </ul> 
     </td>
  </tr>
  <tr>
    <td>61616</td>
    <td>
     <ul>
      <li>This port is used for ActiveMQ hub and spoke communication.</li>
      <li>Classifier group: “PE ActiveMQ Broker”</li>
     </ul> 
   </td>
  </tr>
</table>


> Note: For split and mono installs: If you are installing PE using the web-based installer, ensure port **3000** is open. You can close this port when the installation is complete. If necessary, instructions for port forwarding to the web-based installer are available in the installation instructions.

#### For Large Environment Installations

![lei ports][lei_port_diagram]

See the split installation port/use table for explanations of the ports and their uses. 

### Dependencies and OS Specific Details

This section details the packages that are installed from the various OS repos.  Unless you do not have internet access, you shouldn't need to worry about installing these manually, they will be set up during PE installation.

#### PostgreSQL Requirement

If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

#### OpenSSL Requirement

OpenSSL is a dependency required for PE. For Solaris 10 and all versions of RHEL, Debian, Ubuntu, Windows, and AIX nodes, OpenSSL is included with PE; for all other platforms it is installed directly from the system repositories.

***Centos***

 &nbsp;      | All Nodes | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|:---------:|:------------:|:-------------:|:------------------------:|:----------------------:
pciutils     | x         |              |               |                          |
system-logos | x         |              |               |                          |
which        | x         |              |               |                          |
libxml2      | x         |              |               |                          | 
dmidecode    | x         |              |               |                          |
net-tools    | x         |              |               |                          |
virt-what    | x         |              |               |                          |
apr    		 |           | x            | x             |                          |
apr-util     |           | x            | x             |                          |
curl         |           | x            | x             |                          |
mailcap      |           | x            | x             |                          |
libjpeg      |           | x            |               | x                        |
libtool-ltdl |           | x            | x             |                          |
unixODBC     |           | x            | x             |                          |
libxslt      |           |              |               |                          | x
zlib         | x         |              |               |                          |

<br>

***RHEL***

 &nbsp;      | All Nodes | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|:---------:|:------------:|:-------------:|:------------------------:|:----------------------:
pciutils     | x         |              |               |                          |
system-logos | x         |              |               |                          |
which        | x         |              |               |                          |
libxml2      | x         |              |               |                          | 
dmidecode    | x         |              |               |                          |
net-tools    | x         |              |               |                          |
cronie (RHEL 6, 7) | x      |              |               |                          |
vixie-cron (RHEL 4, 5) | x |            |               |                          |
virt-what    | x         |              |               |                          |
apr          |           | x            | x             |                          |
apr-util     |           | x            | x             |                          |
apr-util-ldap (RHEL 6) | | x            | x             |                          |
curl         |           | x            | x             |                          |
mailcap      |           | x            | x             |                          |
libjpeg      |           | x            |               | x                        |
libtool-ltdl (RHEL 7) |  | x            | x             |                          |
unixODBC (RHEL 7) |      | x            | x             |                          |
libxslt      |           |              |               |                          | x
zlib         | x         |              |               |                          |

  <br>

***SLES***

 &nbsp;      | All Nodes | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|:---------:|:------------:|:-------------:|:------------------------:|:----------------------:
pciutils     | x         |              |               |                          |
pmtools      | x         |              |               |                          |
cron         | x         |              |               |                          |
libxml2      | x         |              |               |                          | 
net-tools    | x         |              |               |                          |
libxslt      | x         | x            |               |                          |
libapr1      |           | x            | x             |                          |
libapr-util1 |           | x            | x             |                          |
curl         |           | x            | x             |                          |
libjpeg      |           | x            |               | x                        |
db43         |           | x            | x             |                          |
unixODBC     |           | x            | x             |                          |
zlib         | x         |              |               |                          |

 <br>

***Debian***

 &nbsp;      | All Nodes | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|:---------:|:------------:|:-------------:|:------------------------:|:----------------------:
pciutils     | x         |              |               |                          |
dmidecode    | x         |              |               |                          |
cron         | x         |              |               |                          |
libxml2      | x         |              |               |                          | 
hostname     | x         |              |               |                          |
libldap-2.4-2 | x        |              |               |                          |
libreadline5 | x         |              |               |                          |
virt-what    | x         |              |               |                          |
file         |           | x            | x             |                          |
libmagic1    |           | x            | x             |                          |
libpcre3     |           | x            | x             |                          |
curl         |           | x            | x             |                          |
perl         |           | x            | x             |                          |
mime-support |           | x            | x             |                          |
libapr1      |           | x            | x             |                          |
libcap2      |           | x            | x             |                          |
libaprutil1  |           | x            | x             |                          |
libaprutil1-dbd-sqlite3 | | x           | x             |                          |
libaprutil1-ldap |       | x            | x             |                          |
libjpeg62    |           | x            |               | x                        |
libcurl3 (Debian 7) |    | x            | x             |                          |
libxml2-dev (Debian 7) | | x            | x             | x                        |
locales-all (Debian 7) | |              |               | x                        |
libxslt1.1   |           |              |               |                          | x
zlib         | x         |              |               |                          |

<br>

***Ubuntu***


 &nbsp;      | All Nodes | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|:---------:|:------------:|:-------------:|:------------------------:|:----------------------:
pciutils     | x         |              |               |                          |
dmidecode    | x         |              |               |                          |
cron         | x         |              |               |                          |
libxml2      | x         |              |               |                          | 
hostname     | x         |              |               |                          |
libldap-2.4-2 | x        |              |               |                          |
libreadline5 | x         |              |               |                          |
virt-what    | x         |              |               |                          |
file         |           | x            | x             |                          |
libmagic1    |           | x            | x             |                          |
libpcre3     |           | x            | x             |                          |
curl         |           | x            | x             |                          |
perl         |           | x            | x             |                          |
mime-support |           | x            | x             |                          |
libapr1      |           | x            | x             |                          |
libcap2      |           | x            | x             |                          |
libaprutil1  |           | x            | x             |                          |
libaprutil1-dbd-sqlite3 | | x           | x             |                          |
libaprutil1-ldap |       | x            | x             |                          |
libjpeg62    |           | x            |               | x                        |
libxslt1.1   |           |              |               |                          | x
libgtk2.0-0  |           | x            | x             | x                        |
ca-certificates-java |   | x            | x             | x                        |
openjdk-7-jre-headless* | | x            | x             | x                        |
libossp-uuid16 |         | x            | x             | x                        |
zlib         | x         |              |               |                          |

*For Ubuntu 10.04 and Debian 6, use openjdk-6-jre-headless.

<br>

***AIX***

In order to run the Puppet agent on AIX systems, you'll need to ensure the following are installed *before* attempting to install the Puppet agent:

* bash
* zlib
* readline
* curl

All [AIX toolbox packages](http://www-03.ibm.com/systems/power/software/aix/linux/toolbox/alpha.html) are available from IBM.  

To install the packages on your selected node directly, you can run `rpm -Uvh` with the following URLs (note that the RPM package provider on AIX must be run as root):

 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/bash/bash-3.2-1.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/zlib/zlib-1.2.3-4.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-6.1-1.aix6.1.ppc.rpm (AIX 6.1 and 7.1 *only*)
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm (AIX 5.3 *only*)

*Note:* if you are behind a firewall or running an http proxy, the above commands may not work. Instead, use the link above to find the packages you need.

*Note:* GPG verification will not work on AIX, the RPM version used by AIX (even 7.1) is too old. The AIX package provider doesn't support package downgrades (installing an older package over a newer package). Avoid using leading zeros when specifying a version number for the AIX provider (i.e., use `2.3.4` not `02.03.04`).

The PE AIX implementation supports the NIM, BFF, and RPM package providers. Check the [Type Reference](/references/3.4.latest/type.html#package) for technical details on these providers.

***Solaris***

Solaris support is agent only.

For Solaris 10, the following packages are required:

  * SUNWgccruntime
  * SUNWzlib
  * In some instances, bash may not be present on Solaris systems. It needs to be installed before running the PE installer. Install it via the media used to install the OS or via CSW if that is present on your system. (CSWbash or SUNWbash are both suitable.)

For Solaris 11 the following packages are required:

  * system/readline
  * system/library/gcc-45-runtime
  * library/security/openssl

These packages are available in the Oracle Solaris release repository (enabled by default on Solaris 11). The PE installer will automatically install them; however, if the release repository is not enabled, the packages will need to be installed manually.

* * *

Next Steps

* To install Puppet Enterprise on \*nix nodes, continue to [Installing Puppet Enterprise](./install_basic.html).
* To install Puppet Enterprise on Windows nodes, continue to [Installing Windows Agents](./install_windows.html).
* To install Puppet Enterprise on OS X, continue to [Installing Mac OS X Agents](./install_osx.html).
