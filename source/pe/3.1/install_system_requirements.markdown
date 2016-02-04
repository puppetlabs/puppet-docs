---
layout: default
title: "PE 3.1 » Installing » System Requirements"
subtitle: "System Requirements and Pre-Installation"
canonical: "/pe/latest/install_system_requirements.html"
---

Before installing Puppet Enterprise:

* Ensure that your nodes are running a supported operating system.
* Ensure that your puppet master and console servers are sufficiently powerful.
* Ensure that your network, firewalls, and name resolution are configured correctly and all target servers are communicating.
* Plan to install the puppet master server before the console server, and the console server before any agent nodes. If you are separating roles, install them in this order:  
    1. Puppet Master
    2. Database Support/PuppetDB
    3. Console
    4. Agents

Operating System
-----

Puppet Enterprise 3.1.3 supports the following systems:

Operating system             | Version(s)                              | Arch          | Roles
-----------------------------|-----------------------------------------|---------------|----------------------------
Red Hat Enterprise Linux     | 4, 5 & 6                                   | x86 & x86\_64 | all (RHEL 4 supports agent only)
CentOS                       | 4, 5 & 6                                   | x86 & x86\_64 | all (CentOS 4 supports agent only)
Ubuntu LTS                   | 10.04 & 12.04                           | i386 & amd64  | all
Debian                       | Squeeze (6) & Wheezy (7)                | i386 & amd64  | all
Oracle Linux                 | 4, 5 & 6                                   | x86 & x86\_64 | all (Oracle Linux 4 supports agent only)
Scientific Linux             | 4, 5 & 6                                   | x86 & x86\_64 | all (Scientific Linux 4 supports agent only)
SUSE Linux Enterprise Server | 11 (SP1 and later)                      | x86 & x86\_64 | all
Solaris                      | 10 (Update 9 or later)                                      | SPARC & i386  | agent
Microsoft Windows            | 2003, 2003R2, 2008, 2008R2, 7, 8, & 2012 | x86 & x86\_64 | agent
AIX                          | 5.3, 6.1, & 7.1                         | Power         | agent

<br>

> *Note:* Upgrading your OS while PE is installed can cause problems with PE. To perform an OS upgrade, you'll need to uninstall PE, perform the OS upgrade, and then reinstall PE as follows:
>
1. Back up your databases and other PE files.
>
2. Perform a complete [uninstall](/pe/3.1/install_uninstalling.html) (including the -pd uninstaller option).
>
3. Upgrade your OS.
>
4. [Install PE](/pe/3.1/install_basic.html).
>
5. Restore your backup.

Hardware
-----

Puppet Enterprise's hardware requirements depend on the roles a machine performs.

* The **puppet master** role should be installed on a robust, dedicated server.
    * Minimum requirements: 2 processor cores, 1 GB RAM, and very accurate timekeeping.
    * Recommended requirements: 2-4 processor cores, at least 4 GB RAM, and very accurate timekeeping. Performance will vary, but this configuration can generally manage approximately 1,000 agent nodes.
* The **database support** role can be installed on the same server as the console or, optionally, on a separate, dedicated server.
    * Minimum requirements: These will vary considerably depending on the size of your deployment. However, you'll need a machine able to handle moderate network traffic, perform processor-intensive background tasks, and run a disk-intensive PostgreSQL database server.  The machine should have two to four processor cores. As a rough rule of thumb for RAM needed, start here: 1-500 nodes: 192-1024MB, 500-1000 nodes: 1-2GB, 1000-2000 nodes: 2-4 GB, 2000+ nodes, 4GB or greater. So as your deployment scales, make sure to scale RAM allocations accordingly. More information about scaling PuppetDB is available in the [PuppetDB manual's scaling guidelines](/puppetdb/1.3/scaling_recommendations.html).
* The **console** role should usually be installed on a separate server from the puppet master, but can optionally be installed on the same server in smaller deployments.
    * Minimum requirements:  A machine able to handle moderate network traffic and perform processor-intensive background tasks. It should have a very fast network connection to the database support server, which it uses for all of the console's database requirements. Requirements will vary significantly depending on the size and complexity of your site.
* The optional **cloud provisioner** role has very modest requirements.
    * Minimum requirements: A system which provides interactive shell access for trusted users. This system should be kept very secure, as the cloud provisioning tools must be given cloud service account credentials in order to function.
* The **puppet agent** role has very modest requirements.
    * Minimum requirements: Any hardware able to comfortably run a supported operating system.


Browser
-----

 The following browsers are supported for use with the console:

* Chrome: Current version 
* Firefox: Current version
* Internet Explorer: 9 or higher
* Safari: 5.1 and higher


Configuration
-----

Before installing Puppet Enterprise at your site, you should make sure that your nodes and network are properly configured.

### Timekeeping

We recommend using NTP or an equivalent service to ensure that time is in sync between your puppet master and any puppet agent nodes. If time drifts out of sync in your PE infrastructure, you may encounter issues such as nodes disappearing from live manangement in the console. A service like NTP ([available as a Forge module](https://forge.puppetlabs.com/puppetlabs/ntp)) will ensure accurate timekeeping.

### Name Resolution

* Decide on a preferred name or set of names agent nodes can use to contact the puppet master server.
* Ensure that the puppet master server can be reached via domain name lookup by all of the future puppet agent nodes at the site.

You can also simplify configuration of agent nodes by using a CNAME record to make the puppet master reachable at the hostname `puppet`. (This is the default puppet master hostname that is automatically suggested when installing an agent node.)

### Firewall Configuration

Configure your firewalls to accommodate Puppet Enterprise's network traffic. In brief: you should open up ports **8140, 61613, and 443.** The more detailed version is:

* All agent nodes must be able to send requests to the puppet master on ports **8140** (for Puppet) and **61613** (for orchestration).
* The puppet master must be able to accept inbound traffic from agents on ports **8140** (for Puppet) and **61613** (for orchestration).
* Any hosts you will use to access the console must be able to reach the console server on port **443,** or whichever port you specify during installation. (Users who cannot run the console on port **443** will often run it on port **3000**.)
* If you will be invoking orchestration commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.** (**Note:** enabling other machines to invoke orchestration actions is possible but not supported in this version of Puppet Enterprise.)
* If you will be running the console and puppet master on separate servers, the console server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **443** and **8140.** The console server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.

### Dependencies and OS Specific Details

This section details the packages that are installed from the various OS repos.  Unless you do not have internet access, you shouldn't need to worry about installing these manually, they will be set up during PE installation.

#### PostgreSQL Requirement

If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.

***Centos***

All Nodes    | Master Nodes | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
-------------|--------------|---------------|--------------------------|------------------------
pciutils     | apr          | apr           | libjpeg                  | libxslt
system-logos | apr-util     | apr-util      |                          | libxml2
which        | curl         | curl          |                          |
libxml2      | mailcap      | mailcap       |                          |
dmidecode    | libjpeg      |               |                          |
net-tools    |              |               |                          |
virt-what    |              |               |                          |

<br>

***RHEL***

All Nodes           | Master Nodes           | Console Nodes          | Console/Console DB Nodes | Cloud Provisioner Nodes
--------------------|------------------------|------------------------|--------------------------|------------------------
pciutils            | apr                    | apr                    | libjpeg                  | libxslt
system-logos        | apr-util               | apr-util               |                          | libxml2
which               | apr-util-ldap (RHEL 6) | curl                   |                          |
libxml2             | curl                   | mailcap                |                          |
dmidecode           | mailcap                | apr-util-ldap (RHEL 6) |                          |
net-tools           | libjpeg                |                        |                          |
cronie (RHEL 6)     |                        |                        |                          |
vixie-cron (RHEL 4, 5) |                        |                        |                          |
virt-what           |                        |                        |                          |

  <br>

***SLES***

All Nodes | Master Nodes   | Console Nodes | Console/Console DB Nodes | Cloud Provisioner Nodes
----------|----------------|---------------|--------------------------|------------------------
pciutils  | libapr1        | libapr1       | libjpeg                  | libxml2
pmtools | libapr-util1   | libapr-util1  |                          |
cron      | libxslt | curl          |                          |
libxml2  | curl           |               |                          |
net-tools | libjpeg        |               |                          |
libxslt      | | | |

 <br>

***Debian***

All Nodes     | Master Nodes            | Console Nodes           | Console/Console DB Nodes | Cloud Provisioner Nodes
--------------|-------------------------|-------------------------|--------------------------|------------------------
pciutils      | file                    | file                    | libjpeg62                | libxslt1.1
dmidecode     | libmagic1               | libmagic1               |                          | libxml2
cron          | libpcre3                | libpcre3                |                          |
libxml2       | curl                    | curl                    |                          |
hostname      | perl                    | perl                    |                          |
libldap-2.4-2 | mime-support            | mime-support            |                          |
libreadline5  | libapr1                 | libapr1                 |                          |
virt-what     | libcap2                 | libcap2                 |                          |
              | libaprutil1             | libaprutil1             |                          |
              | libaprutil1-dbd-sqlite3 | libaprutil1-dbd-sqlite3 |                          |
              | libaprutil1-ldap        | libaprutil1-ldap        |                          |
              | libjpeg62               |                         |                          |

<br>


***Ubuntu***


All Nodes     | Master Nodes            | Console Nodes           | Console/Console DB Nodes | Cloud Provisioner Nodes
--------------|-------------------------|-------------------------|--------------------------|------------------------
pciutils      | file                    | file                    | libjpeg62                | libxslt1.1
dmidecode     | libmagic1               | libmagic1               |                          | libxml2
cron          | libpcre3                | libpcre3                |                          |
libxml2       | curl                    | curl                    |                          |
hostname      | perl                    | perl                    |                          |
libldap-2.4-2 | mime-support            | mime-support            |                          |
libreadline5  | libapr1                 | libapr1                 |                          |
virt-what     | libcap2                 | libcap2                 |                          |
              | libaprutil1             | libaprutil1             |                          |
              | libaprutil1-dbd-sqlite3 | libaprutil1-dbd-sqlite3 |                          |
              | libaprutil1-ldap        | libaprutil1-ldap        |                          |
              | libjpeg62               |                         |                          |

<br>

***AIX***

In order to run the puppet agent on AIX systems, you'll need to ensure the following are installed *before* attempting to install the puppet agent:

* bash
* zlib
* readline
* OpenSSL (use 0.9.8r or a more recent version; this version maps to IBM OpenSSL 0.9.8.1800)

All [AIX toolbox packages](http://www-03.ibm.com/systems/power/software/aix/linux/toolbox/alpha.html) are available from IBM.

To install the packages on your selected node directly, you can run `rpm -Uvh` with the following URLs (note that the RPM package provider on AIX must be run as root):

 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/bash/bash-3.2-1.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/zlib/zlib-1.2.3-4.aix5.2.ppc.rpm
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-6.1-1.aix6.1.ppc.rpm (AIX 6.1 and 7.1 *only*)
 * ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm (AIX 5.3 *only*)

*Note:* if you are behind a firewall or running an http proxy, the above commands may not work. Instead, use the link above to find the packages you need.

*Note:* GPG verification will not work on AIX, the RPM version used by AIX (even 7.1) is too old. The AIX package provider doesn't support package downgrades (installing an older package over a newer package). Avoid using leading zeros when specifying a version number for the AIX provider (i.e., use `2.3.4` not `02.03.04`).

The PE AIX implementation supports the NIM, BFF, and RPM package providers. Check the [Type Reference](/puppet/3.3/reference/type.html#package) for technical details on these providers.

***Solaris***

Solaris support is agent only. The following packages are required:

  * SUNWgccruntime
  * SUNWzlib
  * In some instances, bash may not be present on Solaris systems. It needs to be installed before running the PE installer. Install it via the media used to install the OS or via CSW if that is present on your system. (CSWbash or SUNWbash are both suitable.)


Next
----

* To install Puppet Enterprise on \*nix nodes, continue to [Installing Puppet Enterprise](./install_basic.html).
* To install Puppet Enterprise on Windows nodes, continue to [Installing Windows Agents](./install_windows.html).
