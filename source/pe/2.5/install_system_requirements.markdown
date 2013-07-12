---
layout: default
title: "PE 2.5 » Installing » System Requirements"
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

Puppet Enterprise 2.5 supports the following systems:

|       Operating system       |  Version          |       Arch        |   Roles   |
|------------------------------|-------------------|-------------------|-----------|
| Red Hat Enterprise Linux     | 5 and 6           | x86 and x86\_64   | all roles |
| CentOS                       | 5 and 6           | x86 and x86\_64   | all roles |
| Ubuntu LTS                   | 10.04 and 12.04\* | 32- and 64-bit    | all roles |
| Debian                       | Squeeze (6)       | i386 and amd64    | all roles |
| Oracle Linux                 | 5 and 6           | x86 and x86\_64   | all roles |
| Scientific Linux             | 5 and 6           | x86 and x86\_864  | all roles |
| SUSE Linux Enterprise Server | 11\*              | x86 and x86\_864  | all roles |
| Solaris                      | 10                | SPARC and x86\_64 | agent     |
| Microsoft Windows            | 2003, 2008, and 7 | x86 and x86\_864  | agent     |

> \* SUSE 11 **SP 2** and Ubuntu 12.04 Precise both require PE 2.5.2 or later.

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
* Any hosts you will use to access the console must be able to reach the console server on port **443,** or whichever port you specify during installation. (Users who cannot run the console on port 443 will often run it on port 3000.)
* If you will be invoking MCollective client commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.**
* If you will be running the console and puppet master on separate servers, the console server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **443** and **8140.** The Dashboard server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.


Next
----

* To install Puppet Enterprise on \*nix nodes, continue to [Installing Puppet Enterprise](./install_basic.html).
* To install Puppet Enterprise on Windows nodes, continue to [Installing Windows Agents](./install_windows.html).
