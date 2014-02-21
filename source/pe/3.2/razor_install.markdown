---
layout: default
title: " PE 3.2 » Razor » Install Razor"
subtitle: "Install and Set Up Razor"
canonical: "/pe/latest/razor_install.html"

---

A Razor module is included in your Puppet Enterprise 3.2 installation. To install and configure a Razor server, you must set up your environment, and then classify the pe_razor node. When PE runs and applies this Razor classification, the Razor server and a PostgreSQL database are installed and configured.   

In addition to the Razor server, there's also a Razor client that's installed as a Ruby gem on any machine you want to use for interacting with Razor. 
 
**Important** - Because Razor is a Tech Preview, we highly recommend that you set it up in a completely isolated virtual test environment. This environment must have access to the internet. See [Set Up a Virtual Environment for Razor](./razor_prereqs.html) for details.
	 
**Before You Begin**

+ Do not install Razor on the puppet master.
+ The default port for Razor is 8080. This is also the default port for PuppetDB, so you cannot have PuppetDB and Razor installed on the same system.
+ Razor has been specifically validated on RHEL/CentOS 6.4, but should work on all 6.x versions.

Install the Razor Server
-------------

The actual Razor software is stored in an external location. When you classify a node with the pe_razor module, the software is downloaded. This process can take several minutes. 

1. On the puppet master, classify a non-privileged node with the following manifest:

		node <AGENT_CERT> {
  			include pe_razor    
		}

2. On the puppet agent, execute this command:

		puppet agent -t


####Load iPXE Software

You must set your machines to PXE boot. Without PXE booting, Razor has no way to interact with a system. This is OK if the node has already been enrolled with Razor and is installed, but it will prevent any changes on the server (for example, an attempt to reinstall the system) from having any effect on the node. Razor relies on "seeing" when a machine boots and starts all its interactions with a node during a node's boot.

Razor provides a specific iPXE boot image to ensure the version you use has been tested with Razor. 

1. Download the iPXE boot image [undionly-20140116.kpxe](http://links.puppetlabs.com/pe-razor-ipxe-firmare-3.2).
2. Copy the image to /var/lib/tftpboot. You can use this command:

		cp undionly-20140116.kpxe /var/lib/tftpboot
	
3. Download the iPXE bootstrap script from the Razor server to the /var/lib/tftpboot directory with the following command. 
	**Note** - Make sure you don't use localhost as the name of the Razor host.

		wget http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api/microkernel/bootstrap?nic_max=1 -O /var/lib/tftpboot/bootstrap.ipxe
		
		
####Verify the Razor Server 

Test the new Razor configuration with the following command:

	wget http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api -O test.out
	
The command should execute successfully, and the output JSON file "test.out" should contain a list of available Razor commands.


Install and Set Up the Razor Client
-------------

The Razor client is installed as a Ruby gem.

1. Install the client with this command:

		gem install razor-client
		
2. You can verify that the Razor client is installed by printing Razor help:

		razor -u http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api

3. You'll likely get this warning message about JSON: "MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."  This message is harmless, but you can get rid of it with this command:

		gem install json_pure

		

[Next: Provision with Razor](./razor_using.html)
