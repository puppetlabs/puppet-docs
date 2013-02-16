---
layout: default
title: "PE Deployment Guide"
subtitle: "Introduction and Installation"
---

Introduction
-----

You've just downloaded a shiny new tarball containing Puppet Enterprise (PE) and are wondering to yourself, "now what?" This guide will help you answer that question. Based on the collective decades of experience of Puppet Labs' professional services engineers and support staff, this guide will help you discover the best practices for initially deploying Puppet Enterprise in your infrastructure. It will also help you avoid common errors and pitfalls, and will point to detailed instructions for completing typical and important tasks you'll encounter during deployment. 

Because there is so much variation in the infrastructures where PE is used, we will focus on some standard things most sysadmins typically manage. Hopefully, learning how to automate basic services such as NTP will provide you with the knowledge you need to understand how and why PE's automation is so powerful.  Armed with this knowledge, you'll be ready to take care of more specialized needs -- such as automating the configuration of application servers -- and you'll be able to take your infrastructure to the next level of performance, reliability and visibility.

The guide will be released in chapters. 

 * This first chapter covers initial architecture decisions you'll need to make, and other best practices for installation and preparation. 

 * The next chapter will look at setting up your work environment with version control, best practices for hardening your installation, and managing users and security. Then we'll look at strategies for starting the process of automating your infrastructure by working our way through automating a basic service, MOTD.

 * The third chapter gets to the meat of the matter by demonstrating how and why automation can help you do your job better and faster. It will demonstrate setting up automation for some example services, configurations, and other things that a typical admin might want to first start managing with PE. This chapter will cover using the console and writing manifests, and will recommend some modules to help you get automation up and running quickly. We'll also discuss some methods for testing your work before going live.

 * The fourth chapter will discuss some of the regular maintenance tasks  and troubleshooting tips you'll want to know about to keep things humming along smoothly. 

 * The final chapter will discuss different resources for reporting so you can stay on top of performance metrics and discover issues early before they become problems.

So warm up your keyboard, grab a fresh cup of coffee and let's get PE up and running.

Installing PE
-----
First of all, if you are entirely new to PE and puppet, we strongly recommend you work your way through our [Quick Start Guide](http://docs.puppetlabs.com/pe/2.7/quick_start.html), if you haven't done so already. It will familiarize you with basic concepts and components and give you a jump on creating a solid deployment and making good decisions.

The [installing PE  page](http://docs.puppetlabs.com/pe/2.7/install_basic.html) provides detailed instructions for downloading and installing PE.  If you haven't yet downloaded a fresh production copy of PE, that page also provides links and instructions for how to choose the version of PE best suited for your environment. Once you have a copy and are ready to install, the first major decision involves where and how to set up the various roles that make up PE.

### Before Starting the install

Having a few things set up correctly in advance will make installation and deployment much easier. Specifically:
 
 * Make sure that networking on the node chosen for the puppet master is working correctly and reliably.
 
 * Similarly, make sure your firewalls are properly configured and are not blocking any of [PE's needed ports](http://docs.puppetlabs.com/pe/2.6/install_system_requirements.html#firewall-configuration). Remember to check that any loop-back ports are also open.
 
 * Make sure the system clocks on all the nodes you've selected are correct. They don't need to be exactly synchronized, just all within a minute or two of each other. You'll likely be setting up NTP management as one of the first services you manage with PE. 
 
 * Initially, you will want to start with a small number of carefully chosen nodes. Choose nodes that are not mission critical and select simple, easy to manage services. Many admins will start with dev and test machines. Eventually, you'll deploy puppet throughout your infrastructure, but because puppet is so powerful, you'll want to start out slowly and carefully while you get comfortable with the tools. In the next chapter, we'll talk about some approaches to selecting initial nodes for management.
 
#### Hostnames and DNS

Finally, you need to get hostnames and DNS resolving correctly for the nodes you want to manage, especially the master. Sanity check DNS by pinging the master and agents at the expected names. You should do this from a representative sample of the nodes you are expecting to manage so you can be sure that DNS is resolving correctly throughout your ecosystem and not being influenced by something like, for example, DNS Views. 

While PE can be set up to use, for example, aliases, doing so can be complex and messy. Having hostnames in DNS the way you want them before you start installing will spare you from this pain. This is particularly true for the hostname of the machine that will take the master role. Agents need to be able to reach the master over SSL with a valid DNS name. Changing the name of the puppet master host after the fact can add some complexity and pain, in no small part because all the previously generated agent certificates will now have the wrong name and so be unable to connect to the master. 

At some point in the not too distant future, you will want to review and regularize the way your organization creates host names and IP tables. 

If you need some help troubleshooting DNS, please refer to [these requirements](http://docs.puppetlabs.com/pe/2.7/trouble_common_problems.html#is-dns-wrong) in the Puppet Enterprise User's Guide. Additionally, this [troubleshooting thread](https://ask.puppetlabs.com/question/25/how-can-i-troubleshoot-problems-with-puppets-ssl-layer/) on our ask.puppetlabs site has tons more useful information.
 
### What Goes Where

PE gives you a lot of flexibility in choosing where its various components can be installed. These components play various roles and include: the Puppet Agent, the Puppet Master, the Console Server, the Cloud Provisioner and any supporting database(s).
    
#### The Puppet Master

Start by installing the master. Typically, the puppet master (which may or may not include the console, see below)  is installed on a single node. However, under certain circumstances it may be preferable to run another master. For example, you may wish to run another master in order to provide HA or failover protection. 

>Generally speaking, running multiple masters only becomes necessary when your infrastructure grows to a certain size. What that size is precisely will vary depending on how complex your infrastructure is, the number of classes and resources, etc. in your manifests, and so on. As a general rule of thumb, however, once you get to 800 nodes you will probably want to start separating out the various functions of the master, and once you get to 1200 nodes or so you will likely want to use multiple masters. In any case, you may wish to defer deploying multiple masters if you just starting out with PE and want to keep your learning environment simple and straightforward. When you're ready to set up multiple masters, see [Using Multiple Puppet Masters](http://docs.puppetlabs.com/guides/scaling_multiple_masters.html). 

Make sure that any machine you select for the master conforms to the [hardware system requirements](http://docs.puppetlabs.com/pe/2.7/install_system_requirements.html#hardware) and, in particular, ensure you have plenty of disk space, especially if you will be running the console on the same hardware.

While it is also possible to run masterless, this is rarely done with PE. Once you have worked with Puppet at greater length, you can evaluate some of the discussions around running masterless ([Masterless Puppet](http://jamescun.com/2012/12/14/masterless-puppet.html)).
    
    
#### The Puppet Agent. 
This one is easy. The puppet agent will get installed on every node in your infrastructure that you want to manage with PE, including the master and any other nodes that run other PE roles. Don't be shy about installing it on existing infrastructure.
    
####The Console
If your infrastructure and needs are modest (around 200 nodes or less), the console can run on the same server as the puppet master. When running the console on a separate server, you should also install a puppet agent to manage that machine. Be sure to give the agent the same hostname as the console.
    
####The Cloud Provisioner
This optional role can create virtual machine instances in environments such as VMWare's Vsphere or Amazon EC2. Whichever environment you are using, the node running the cloud provisioning tools must have ports open to the outside. The required ports are: 

* vCenter: 10443 (HTTPS), 10111 (service management), 10109 (linked mode communication), 443 (SSL)
* AWS: 80 and 443 (SSL)
* OpenStack: 5000 (service API), 8773 (EC2 compatibility endpoint), 35357 (admin API)
	
In addition you must have the following port connections available to your Puppet master server:

* Puppet Master: TCP/8140, TCP/22 (SSH), TCP/443 (SSL)

When selecting the node for the cloud provisioner role, make sure that local firewall rules will allow access to these ports. (For this reason, running cloud provisioning on the same node as the master may not work.)

Refer to the [cloud provisioner configuration guide](http://docs.puppetlabs.com/pe/2.7/cloudprovisioner_configuring.html) for more details on installing and setting up cloud provisioning tools.
    
####Database Servers
The console requires several mySQL databases and users, and of course a mySQL server. The installer will create, configure and install these wherever you direct it to. The [installation instructions](http://docs.puppetlabs.com/pe/2.7/install_basic.html#console-questions) provide complete information on the various options for set up and configuration of the databases. 

The mySQL database and server are vital to the functioning of the console. To keep things secure and robust, you should consult one of the many available hardening guides and security best practices ([such as these guidelines, for example](http://dev.mysql.com/doc/refman/5.0/en/security-guidelines.html)).

It probably goes without saying that you should not use this mySQL server instance for anything but the console.

#### Run the Install Script
Once you've determined where everything is going to go, you can run the install script. If you have questions about the script, the answer file, etc., remember you can get  detailed instructions on the [installing PE  page](http://docs.puppetlabs.com/pe/2.7/install_basic.html).

#### Installation Issues and Tips
There are a few common problems users have encountered when installing, mainly related to pre-existing conditions in the environment. The most common include:

* Errors caused by an existing, old version of MySQL. Be sure to completely uninstall any existing instances of MySQL and the data directory (e.g. `/var/lib/mysql` on RHEL systems).

* If you experience issues during installation and just want to start over, you can uninstall everything with `puppet-enterprise-uninstaller -pd`. See the [uninstaller documentation](http://docs.puppetlabs.com/pe/2.7/install_uninstalling.html) for more information. Note that this will not uninstall any pre-existing mySQL instances and related files; if these are causing issues, they will continue to do so on subsequent installation attempts.

* The installer comes with an example answers file. Don't overlook it!

* The installer creates a log file, `install_log.lastrun.<hostname>` which can be very useful for debugging install issues.

* Similarly, the installer generates an `answers.lastrun.<hostname>` file that can help prompt your memory for things like, say, the console's hostname or the mySQL password.  
*Important* You will want to delete this file or move it to a secured location after your install to eliminate the plaintext record of these passwords.
    
### Managing Certificates
Once you've gotten all the parts installed where you want them, it's time to get agents connected to their master. This is done by sending certificate signing requests (CSR's) from the agents to a certificate authority (CA). By default, the CA is the same server as the master. In any case, the CA and certificate signing process is a vital part of PE's security infrastructure. Make sure it is well protected.

### Auto-signing, Pre-signing and Request Management
The easiest way to manage node requests is with the request management capabilities built into PE's console. See the [PE Node Request Management manual page](http://docs.puppetlabs.com/pe/2.7/console_cert_mgmt.html) for details.

If you'd prefer to manage certificates from the command line, refer to [these instructions](http://docs.puppetlabs.com/pe/2.7/install_basic.html#signing-agent-certificates).
    
Autosigning certificates can be useful, but should be done very carefully since it potentially introduces major security liabilities. By default, auto-sign is turned off. You can edit puppet.conf to turn it on, and you can gain some finer-grained control by leaving it off but editing `autosign.conf`. [This guide](http://docs.puppetlabs.com/guides/configuring.html#autosignconf) has more information.    

Note that if your institution prefers or requires you to use externally purchased SSL certs, you can do it, but you should back up your original, PE generated certs first, just in case of unforeseen circumstances. To use external certs you'll need to edit several lines in `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf` as follows:

    SSLCertificateFile      <path_to_your_purchased_cert>/cert.pem
    SSLCertificateKeyFile   <path_to_your_purchased_cert>/key.pem
    SSLCertificateChainFile <path_to_your_purchased_cert>/ca_cert.pem
    SSLCACertificateFile    <path_to_your_purchased_cert>/ca_cert.pem

After saving these edits, you'll want to restart the `pe-httpd` daemon. Also, make sure to leave in place the original pe-internal-dashboard cert, private key, and CA certs (at /opt/puppet/share/puppet-dashboard/certs/).

### What's Next?

At this point you should have a functioning installation of Puppet Enterprise. Your agents should be able to talk to the master and you should be able to see them in the Console. The next chapter will focus on setting up your work environment so you can start classifying nodes and automating your infrastructure.

* * * 

- Next: First Steps: Building Your Work Environment (Coming Soon)


