---
layout: pe2experimental
title: "PE 2.0 » Installing » Preparing to Install"
---


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

Ensure that the puppet master server can be reached via domain name lookup by all of the future puppet agent nodes at the site, and decide on a preferred name or set of names at which to reach it. 

Optionally, you can add a CNAME record to your site's DNS configuration (or an alias in the relevant `/etc/hosts` files) to ensure that your puppet master can also be reached at the hostname `puppet` --- since this is the default puppet master hostname, using it can simplify installation for your agent nodes. 

### Firewall Configuration

Configure your firewalls to accomodate Puppet Enterprise's network traffic. The short version is that you should open up ports **8140, 61613, and 3000.** The more detailed version is:

* All agent nodes must be able to send requests to the puppet master on ports **8140** (for Puppet) and **61613** (for MCollective).
* The puppet master must be able to accept inbound traffic from agents on ports **8140** (for Puppet) and **61613** (for MCollective).
* Any hosts you will use to access the console must be able to reach the console server on port **3000,** or the port you will specify during installation. (Many users will run the console on port 443 for easier browser access and firewall configuration.)
* If you will be invoking MCollective client commands from machines other than the puppet master, they will need to be able to reach the master on port **61613.**
* If you will be running the console and puppet master on separate servers, the Dashboard server must be able to accept traffic from the puppet master (and the master must be able to send requests) on ports **3000** and **8140.** The Dashboard server must also be able to send requests to the puppet master on port **8140,** both for retrieving its own catalog and for viewing archived file contents.

Downloading PE
-----

Before installing Puppet Enterprise, you must [download it from the Puppet Labs website][downloadpe].

[downloadpe]: http://info.puppetlabs.com/puppet-enterprise

### Choosing Your Installer Tarball

Puppet Enterprise can be downloaded in tarballs specific to your OS version and architecture, or as a universal tarball. Although the universal tarball is simpler to use, it is roughly ten times the size of a version-specific tarball, and may prove unwieldy depending on your installation plan. 

#### Available Tarballs

|      Filename ends with...        |                     Will install...                           |
|-----------------------------------|---------------------------------------------------------------|
| `-all.tar`                        | anywhere                                                      |
| `-debian-<version and arch>.tar`  | on Debian                                                     |
| `-el-<version and arch>.tar`      | on RHEL, CentOS, Scientific Linux, or Oracle Enterprise Linux |
| `-sles-<version and arch>.tar`    | on SUSE Linux Enterprise Server                               |
| `-solaris-<version and arch>.tar` | on Solaris                                                    | 
| `-ubuntu-<version and arch>.tar`  | on Ubuntu LTS                                                 |

