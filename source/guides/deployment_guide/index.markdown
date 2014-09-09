---
layout: default
title: "PE Deployment Guide"
subtitle: "Introduction and Installation"
---

Back to the [PE user guide](/pe/latest/index.html).

Introduction
-----

[pe_dl]: http://info.puppetlabs.com/download-pe.html

You've just [downloaded a shiny new tarball][pe_dl] containing Puppet Enterprise (PE) and are wondering to yourself, "now what?" This guide will help you answer that question. Based on the collective decades of experience of Puppet Labs' professional services engineers and support staff, this guide will help you discover the best practices for initially deploying Puppet Enterprise in your infrastructure. It will also help you avoid common errors and pitfalls, and will point to detailed instructions for completing typical and important tasks you'll encounter during deployment.

Because there is so much variation in the infrastructures where PE is used, we will focus on some standard things most sysadmins typically manage. Hopefully, learning how to automate basic services such as NTP will provide you with the knowledge you need to understand how and why PE's automation is so powerful.  Armed with this knowledge, you'll be ready to take care of more specialized needs -- such as automating the configuration of application servers -- and you'll be able to take your infrastructure to the next level of performance, reliability and visibility.

The guide will be released in chapters.

* This first chapter covers initial architecture decisions you'll need to make, and other best practices for installation and preparation.
* The next chapter will look at setting up your work environment with version control, best practices for hardening your installation, and managing users and security.
* The third chapter gets to the meat of the matter by demonstrating how and why automation can help you do your job better and faster. You'll follow a fictional sysadmin while she sets up automation for some simple services, configurations, and other things that a typical admin might want to first start managing with PE. This chapter will cover using the console and the forge, will introduce you to writing manifests, and will recommend some modules to help you get automation up and running quickly. We'll also discuss some methods for testing your work before going live.
* The fourth chapter will move on to more advanced automation tasks and will explore manifest writing and the puppet language in more detail.
* The fifth chapter will discuss some of the regular maintenance tasks  and troubleshooting tips you'll want to know about to keep things humming along smoothly.
* The final chapter will discuss different resources for reporting so you can stay on top of performance metrics and discover issues early before they become problems.

So warm up your keyboard, grab a fresh cup of coffee and let's get PE up and running.

Installing PE
-----

First of all, if you are entirely new to PE and puppet, we strongly recommend you work your way through our [Quick Start Guide](/pe/latest/quick_start.html), if you haven't done so already. It will familiarize you with basic concepts and components and give you a jump on creating a solid deployment and making good decisions.

The [installing PE  page](/pe/latest/install_basic.html) provides detailed instructions for downloading and installing PE.  If you haven't yet downloaded a fresh production copy of PE, that page also provides links and instructions for how to choose the version of PE best suited for your environment. Once you have a copy and are ready to install, the first major decision involves where and how to set up the various roles that make up PE.

### Before Starting the install

Having a few things set up correctly in advance will make installation and deployment much easier. Specifically:

* Make sure that networking on the node chosen for the puppet master is working correctly and reliably.
* Similarly, make sure your firewalls are properly configured and are not blocking any of [PE's needed ports](/pe/latest/install_system_requirements.html#firewall-configuration). Remember to check that any loop-back ports are also open.
* Make sure the system clocks on all the nodes you've selected are correct. They don't need to be exactly synchronized, just all within a minute or two of each other. You'll likely be setting up NTP management as one of the first services you manage with PE.
* Initially, you will want to start with a small number of carefully chosen nodes. Choose nodes that are not mission critical and select simple, easy to manage services. Many admins will start with dev and test machines. Eventually, you'll deploy Puppet throughout your infrastructure, but because Puppet is so powerful, you'll want to start out slowly and carefully while you get comfortable with the tools. In the next chapter, we'll talk about some approaches to selecting initial nodes for management.

#### Hostnames and DNS

Finally, you need to get hostnames and DNS resolving correctly for the nodes you want to manage, especially the master. Sanity check DNS by pinging the master and agents at their expected names. You should do this from a representative sample of the nodes you are expecting to manage so you can be sure that DNS is resolving correctly throughout your ecosystem and not being influenced by something like, for example, DNS Views.

While PE can be set up to use, for example, aliases, doing so can be complex and messy. Having hostnames in DNS the way you want them before you start installing will spare you from this pain. This is particularly true for the hostname of the machine that will take the master role, because its name needs to be in every agent's config file and the master's SSL certificate, and changing these later can be tedious.

At some point in the not too distant future, you will want to review and regularize the way your organization creates host names and IP tables.

If you need some help troubleshooting DNS, please refer to [these requirements](/pe/latest/trouble_install.html#is-dns-wrong) in the Puppet Enterprise User's Guide. Additionally, this [troubleshooting thread](https://ask.puppetlabs.com/question/25/how-can-i-troubleshoot-problems-with-puppets-ssl-layer/) on our ask.puppetlabs site has tons more useful information.

### Choosing Where to Install Each Role

PE consists of several components, which are grouped into a handful of **roles.**

* The **puppet agent** role gets installed on _every_ server you will manage with PE.
* The **puppet master, console server,** and **database support** roles make up the central infrastructure of PE. They can either be installed on _three separate servers,_ or _all on one server._ We strongly recommend installing them on separate servers.
* The optional **cloud provisioner** role can be installed on any puppet agent node.

Before installing, you must plan where to install these roles.

#### The Puppet Agent Role

This one is easy. The puppet agent will get installed on every node in your infrastructure that you want to manage with PE, including the master and any other nodes that run other PE roles. Don't be shy about installing it on existing infrastructure. And remember, if you are using a supported OS that is capable of using remote package repos, the easiest way to install PE agent is with standard *nix package management tools. To install the agent on other OS's (Solaris, AIX, RHEL 4, Windows) you'll need to use the installer script in the PE tarball.

#### The Puppet Master Role

The puppet master compiles and serves configuration catalogs to puppet agent nodes. It also issues orchestration commands to agents. In general, we recommend that you install the master, console, and database roles on separate servers.

Start by installing the master. Typically, the puppet master is installed on a single node. However, under certain circumstances it may be preferable to run another master. For example, you may wish to run another master in order to provide HA or failover protection.

> **Note:** Generally speaking, running multiple masters only becomes necessary when your infrastructure grows to a certain size. What that size is precisely will vary depending on how complex your infrastructure is, the number of classes and resources, etc. in your manifests, and so on. As a general rule of thumb, however, once you get to 800 nodes you will probably want to start separating out the various functions of the master, and once you get to 1200 nodes or so you will likely want to use multiple masters. In any case, you may wish to defer deploying multiple masters if you are just starting out with PE and want to keep your learning environment simple and straightforward.

Make sure that any machine you select for the master conforms to the [hardware system requirements](/pe/latest/install_system_requirements.html#hardware) and, in particular, ensure you have plenty of disk space, especially if you will be running the console and database roles on the same hardware.

#### The Database Support Role

The database support role runs a PosgreSQL server (which provides databases for use by the console) and PuppetDB (which enables exported resources and provides a query API for data generated by Puppet).

The database support role should generally be installed on a dedicated server and be installed before installing the console role. If your infrastructure and needs are modest (around 200 nodes or less), the database role can run on the same server as the puppet master and console roles.

The [installation instructions](/pe/latest/install_basic.html#console-questions) provide complete information on the various options for set up and configuration of the databases.

The PostgreSQL databases and server are vital to the functioning of the console. To keep things secure and robust, you should consult one of the many available hardening guides and security best practices ([such as these guidelines](https://www.owasp.org/index.php/OWASP_Backend_Security_Project_PostgreSQL_Hardening)).

You should not use the PostgreSQL server on the database support role for anything other than Puppet Enterprise.

#### The Console Role

The PE console provides a user interface for working with the Puppet data at your site. It allows users to assign configuration data, approve new node requests, view reports and node status, and issue orchestration commands.

The console role should generally be installed on a dedicated server. If your infrastructure and needs are modest (around 200 nodes or less), the console can run on the same server as the puppet master and database support roles.

When running the console on a separate server, the installer will automatically also install a puppet agent to manage that machine. Be sure to give the agent the same hostname as the console.

#### The Cloud Provisioner

This optional role can create virtual machine instances in environments such as VMWare's Vsphere or Amazon EC2. Whichever environment you are using, the node running the cloud provisioning tools must have ports open to the outside. The required ports are:

* vCenter: 10443 (HTTPS), 10111 (service management), 10109 (linked mode communication), 443 (SSL)
* AWS: 80 and 443 (SSL)
* OpenStack: 5000 (service API), 8773 (EC2 compatibility endpoint), 35357 (admin API)

In addition you must have the following port connections available to your Puppet master server:

* Puppet Master: TCP/8140, TCP/22 (SSH), TCP/443 (SSL)

When selecting the node for the cloud provisioner role, make sure that local firewall rules will allow access to these ports. (For this reason, running cloud provisioning on the same node as the master may not work.)

Refer to the [cloud provisioner configuration guide](/pe/latest/cloudprovisioner_configuring.html) for more details on installing and setting up cloud provisioning tools.


### Run the Install Script

Once you've determined where everything is going to go, you can run the install script. If you have questions about the script, the answer file, etc., remember you can get  detailed instructions on the [installing PE  page](/pe/latest/install_basic.html).

#### Installation Issues and Tips

There are a few common problems users have encountered when installing, mainly related to pre-existing conditions in the environment. The most common include:

* Errors caused by an existing, old version of PostgreSQL on the machine that will run the console database. Be sure to completely uninstall any existing instances of PostgreSQL and the data directory (e.g. `/var/lib/pgsql/9.2/data` on RHEL systems).
* If you experience issues during installation and just want to start over, you can uninstall everything with `puppet-enterprise-uninstaller -pd`. See the [uninstaller documentation](/pe/latest/install_uninstalling.html) for more information. Note that this will not uninstall any pre-existing PostgreSQL instances and related files; if these are causing issues, they will continue to do so on subsequent installation attempts.
* The installer comes with an example answers file, which can save you some time. Don't overlook it!
* The installer creates a log file at `install_log.lastrun.<hostname>`, which can be very useful for debugging install issues.
* Similarly, the installer generates an `answers.lastrun.<hostname>` file, which can help you keep a record of things like the console's hostname or the database users' passwords. *Important:* You will want to delete this file or move it to a secured location after your install to eliminate the plaintext record of these passwords.

Managing Certificates
-----

Once you've gotten all the parts installed where you want them, it's time to get agents connected to their master. This is done by sending certificate signing requests (CSR's) from the agents to a certificate authority (CA). By default, the CA is the same server as the master. In any case, the CA and certificate signing process is a vital part of PE's security infrastructure. Make sure it is well protected.

### Auto-signing, Pre-signing and Request Management

The easiest way to manage node requests is with the request management capabilities built into PE's console. See the [PE Node Request Management manual page](/pe/latest/console_cert_mgmt.html) for details.

If you'd prefer to manage certificates from the command line, refer to [these instructions](/pe/latest/install_basic.html#signing-agent-certificates).

Auto-signing certificates can be useful, but should be done very carefully since it potentially introduces major security liabilities. By default, auto-signing is managed by the `/etc/puppetlabs/puppet/autosign.conf` file, which is empty in a new PE installation. [This reference page](/puppet/latest/reference/config_file_autosign.html) has more information about adding entries to `autosign.conf`. Alternately, you can (but shouldn't) set `autosign = true` in `/etc/puppetlabs/puppet/puppet.conf` to auto-sign all requests.

Note that if your institution prefers or requires you to use externally purchased SSL certs, you can do it, but you should back up your original, PE generated certs first, just in case of unforeseen circumstances. To use external certs you'll need to edit several lines in `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` as follows:

    SSLCertificateFile      <path_to_your_purchased_cert>/cert.pem
    SSLCertificateKeyFile   <path_to_your_purchased_cert>/key.pem
    SSLCertificateChainFile <path_to_your_purchased_cert>/ca_cert.pem
    SSLCACertificateFile    <path_to_your_purchased_cert>/ca_cert.pem

After saving these edits, you'll want to restart the `pe-httpd` daemon. Also, make sure to leave in place the original pe-internal-dashboard cert, private key, and CA certs (at `/opt/puppet/share/puppet-dashboard/certs/`).

What's Next?
-----

At this point you should have a functioning installation of Puppet Enterprise. Your agents should be able to talk to the master and you should be able to see them in the Console. The next chapter will focus on setting up your work environment so you can start classifying nodes and automating your infrastructure.

* * *

- Next: [First Steps: Building Your Work Environment](dg_first_steps.html)


