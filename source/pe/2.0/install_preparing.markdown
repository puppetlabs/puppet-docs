---
layout: default
title: "PE 2.0 » Installing » Preparing to Install"
canonical: "/pe/latest/install_basic.html"
---

* * *

&larr; [Installing: System Requirements](./install_system_requirements.html) --- [Index](./) --- [Installing: Basic Installation](./install_basic.html) &rarr;

* * *


Preparing to Install
=====

Planning
-----

Before anything else, decide in advance which server will fill the role of puppet master. This should be a robust dedicated server with accurate timekeeping and at least 1 GB of RAM. 

You must also decide whether the puppet master server will also be filling the console role. In general, we recommend installing the master and the console together.

Plan to install PE on the puppet master **before** installing on any agent nodes. If you will be splitting the master and console roles, you should install the console role **immediately after** the master role.

Configuring Your Site
-----

Before installing Puppet Enterprise at your site, you should make sure that your nodes and network are properly configured.

### Name Resolution

* Decide on a preferred name or set of names at which agent nodes should contact the puppet master server.
* Ensure that the puppet master server can be reached via domain name lookup by all of the future puppet agent nodes at the site.

You can also simplify configuration of agent nodes by using a CNAME record to make the puppet master reachable at the hostname `puppet`. (This is the default puppet master hostname that is automatically suggested when installing an agent node.)

### Firewall Configuration

Configure your firewalls to accommodate Puppet Enterprise's network traffic. The short version is that you should open up ports **8140, 61613, and 443.** The more detailed version is:

* All agent nodes must be able to send requests to the puppet master on ports **8140** (for Puppet) and **61613** (for MCollective).
* The puppet master must be able to accept inbound traffic from agents on ports **8140** (for Puppet) and **61613** (for MCollective).
* Any hosts you will use to access the console must be able to reach the console server on port **443,** or whichever port you specify during installation. (Users who cannot run the console on port 443 will often run it on port 3000.)
* If you will be invoking MCollective client commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.**
* If you will be running the console and puppet master on separate servers, the console server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **443** and **8140.** The Dashboard server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.

Downloading PE
-----

Before installing Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].

[downloadpe]: http://info.puppetlabs.com/download-pe.html

### Choosing Your Installer Tarball

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball. Although the universal tarball is simpler to use, it is roughly ten times the size of a version-specific tarball, and may prove unwieldy depending on your installation plan. 

#### Available Tarballs

|      Filename ends with...        |                     Will install...                           |
|-----------------------------------|---------------------------------------------------------------|
| `-all.tar`                        | anywhere                                                      |
| `-debian-<version and arch>.tar`  | on Debian                                                     |
| `-el-<version and arch>.tar`      | on RHEL, CentOS, Scientific Linux, or Oracle Linux            |
| `-sles-<version and arch>.tar`    | on SUSE Linux Enterprise Server                               |
| `-solaris-<version and arch>.tar` | on Solaris                                                    |
| `-ubuntu-<version and arch>.tar`  | on Ubuntu LTS                                                 |

* * *

&larr; [Installing: System Requirements](./install_system_requirements.html) --- [Index](./) --- [Installing: Basic Installation](./install_basic.html) &rarr;

* * *

