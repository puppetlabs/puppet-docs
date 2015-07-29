---
layout: default
title: "Quick Start » NTP"
subtitle: "NTP Quick Start Guide"
canonical: "/puppet/latest/quick_start_ntp.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Open Source Puppet NTP Quick Start Guide. This document provides instructions for getting started managing an NTP service using the Puppet Labs NTP module.

The clocks on your servers are not inherently accurate. They need to synchronize with something to let them know what the right time is. NTP is a protocol designed to synchronize the clocks of computers over a network. NTP uses Coordinated Universal Time (UTC) to synchronize computer clock times to a millisecond---and sometimes to a fraction of a millisecond.

Your entire datacenter, from the network to the applications, depends on accurate time for many different things, such as security services, certificate validation, and file sharing across nodes.

NTP is one of the most crucial, yet easiest, services to configure and manage with Puppet. Using the Puppet Labs NTP module, you can:

* ensure time is correctly synced across all the servers in your infrastructure.
* ensure time is correctly synced across your configuration management tools.
* roll out updates quickly if you need to change or specify your own internal NTP server pool.

Using this guide, you will:

* [install the `puppetlabs-ntp` module](#install-the-puppetlabs-ntp-module).
* [add classes to the default node in your main manifest](#use-the-main-manifest-to-add-classes-from-the-ntp-module).
* view the status of your NTP service.
* [use multiple nodes to configure NTP for different permissions](#use-multiple-nodes-to-configure-ntp-for-different-permissions).

## Install Puppet and the Puppet Agent

If you haven't already done so, you'll need to get Puppet and the Puppet agent installed. See the [system requirements][sys_req] for supported platforms.

1. [Download and verify the appropriate tarball][downloads].
2. Refer to the [installation overview][install_overview] to determine how you want to install Puppet, and follow the instructions provided.
3. Refer to the [agent installation instructions][agent_install] to determine how you want to install your Puppet agent(s), and follow the instructions provided.

>**Note**: You can add the NTP service to as many agents as needed. For ease of explanation, we will only be using one.

## Install the puppetlabs-ntp Module

The puppetlabs-ntp module is part of the [supported modules](http://forge.puppetlabs.com/supported) program; these modules are supported, tested, and maintained by Puppet Labs. You can learn more about the puppetlabs-ntp module by visiting [http://forge.puppetlabs.com/puppetlabs/ntp](http://forge.puppetlabs.com/puppetlabs/ntp).

**To install the puppetlabs-ntp module**:

From the Puppet master, run `puppet module install puppetlabs-ntp`.

You should see output similar to the following:

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/environments/production/modules
        └── puppetlabs-ntp (v3.1.2)

> That's it! You've just installed the puppetlabs-ntp module.

## Use the Main Manifest to Add Classes from the NTP Module

[classification_selector]: ./images/quick/classification_selector.png

The NTP module contains several **classes**. [Classes](../puppet/3/reference/lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet configures nodes. The NTP module contains the following classes:

* `ntp`: the main class; this class includes all other classes (including the classes in this list).
* `ntp::install`: this class handles the installation packages.
* `ntp::config`: this class handles the configuration file.
* `ntp::service`: this class handles the service.

We're going to add the `ntp` class to the default node. Depending on your needs or infrastructure, you may have a different group that you'll assign NTP to, but these same instructions would apply.

**To create the NTP class:**

1. From the CLI of the Puppet master, navigate to the main manifest: `cd /etc/puppetlabs/code/environments/production/manifests`.
2. Use your text editor to open `site.pp`. 
3. Add the following Puppet code to `site.pp`:

        node default {        									 
     		class { 'ntp':       									 
    		servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu']
    	    }						
		}

>**Note**: If you already have a default node, do not copy `node default` into it.
> To select other time servers, visit [http://www.pool.ntp.org/](http://www.pool.ntp.org/).

4. From the CLI of your Puppet agent, trigger a Puppet run with `puppet agent -t`.

> That's it! You've successfully configured Puppet to use NTP.

**To check if the NTP service is running**, run `puppet resource service ntpd` from the CLI of your Puppet agent. The output should be:

        service { 'ntpd':
  		ensure => 'running',
 		enable => 'true',
		}

## Use Multiple Nodes to Configure NTP for Different Permissions

While you will be using the default node throughout this Quick Start Guide, it is possible to use multiple nodes in the main manifest to configure NTP in different ways.
In the example below, 
* There are two ntp servers in the organization that are allowed to talk to outside time servers ("kermit" and "grover"). Other ntp servers get their time data from these two servers.

* One of the primary ntp servers is very cautiously configured — it can’t afford outages, so it’s not allowed to automatically update its ntp server package without testing ("kermit"). The other servers are more permissively configured.

* There are a number of other ntp servers that will use our two primary servers ("snuffie," "bigbird," and "hooper").

* There are a number of VMWare guest operating systems that need to have VMWare Tools installed.


		 node "kermit.example.com" {
		  class { "ntp":
		    servers    => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
		    autoupdate => false,
			restrict   => [],
			enable     => true,
	     }
	    }

	     node "grover.example.com" {
	      class { "ntp":
		   servers    => [ 'kermit.example.com','0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst'],
		   autoupdate => true,
		   restrict   => [],
		   enable     => true,
	     }
	    }

	     node "snuffie.example.com", "bigbird.example.com", "hooper.example.com" {
	      class { "ntp":
		   servers    => [ 'grover.example.com', 'kermit.example.com'],
		   autoupdate => true,
		   enable     => true,
	     }
	    }
	   
In this fashion, it is possible to create multiple nodes to suit your needs.

## Other Resources

For more information about working with the puppetlabs-ntp module, check out our [How to Manage NTP](http://puppetlabs.com/webinars/how-manage-ntp) webinar.

Puppet Labs offers many opportunities for learning and training, from formal certification courses to guided online lessons. We've noted a few below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* [Learning Puppet](http://docs.puppetlabs.com/learning/) is a series of exercises on various core topics about deploying and using Puppet.
* The Puppet Labs workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).

----------

Next: [DNS Quick Start Guide](./quick_start_dns.html)
