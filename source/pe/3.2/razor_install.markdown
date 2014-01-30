---
layout: default
title: " PE 3.2 » Razor » Installation"
subtitle: "Install and Set Up Razor"
canonical: "/pe/latest/razor_install.html"

---

Razor is contained in a Razor module that's included in your Puppet Enterprise 3.2 installation. To install and configure a Razor server, you must set up your environment,  and then classify a node as `pe_razor`. When PE runs and applies this Razor classification, the Razor server and a PostgreSQL database are installed and configured.   

In addition to the Razor server, there's also a Razor client that's installed as a Ruby gem on any machine you want to use for interacting with Razor. 
 
**Note** - Because Razor is a technical preview, we strongly recommend that you set it up in a completely virtual, completely isolated test environment. This environment must have access to the internet.


Prerequisites
-------------

These steps enable you to set up and configure your environment for use with Razor. 

+ Install PE in your virtual environment
+ Install and configure dnsmasq DHCP/TFTP service
+ Manage SELinux settings to enable PXE Boot
+ Load iPXE Firmware
+ Edit the dnsmasq configuration file to enable PXE boot

####Install PE in Your Virtual Environment

In your virtual testing environment, set up a puppet master running a standard install of Puppet Enterprise 3.2. For information about installing PE 3.2, see [Installing Puppet Enterprise](./install_basic.html).

####Install and Configure dnsmasq DHCP/TFTP Service

The installation that's described here, particularly these prerequisites, are one way to configure the environment where you'll run your Razor server. We're providing explicit instructions for this setup because it has been tested and is relatively straightforward.


1.Install dnsmasq from YUM with this command:

	`yum install dnsmasq.x86.64`

2. Create the directory /var/lib/tftpboot if it doesn't already exist.
3. Change the permission for /var/lib/tftpboot with this command:
	
	`chmod 644 /var/lib/tftpboot`
	
####Manage SELinux Settings to Enable PXE Boot

1. Disable SELinux by changing the following setting in the file /etc/sysconfig/selinux:

		SELINUX=disabled
 
	**Note** - Disabling SELinux is highly insecure and should only be done for testing  purposes. 
	
	Another option is to craft an enforcement rule for SELinux that will enable PXE boot but will not completely disable SElinux. 
	
2. Restart the computer and log in again. 

####Load iPXE Firmware

Razor provides a specific iPXE boot image to ensure the version you use has been tested with Razor. 

1. Download the iPXE boot image [undionly.kpxe.firmware](http://www.google.com/url?q=http%3A%2F%2Flinks.puppetlabs.com%2Fpe-razor-ipxe-firmare-3.2&sa=D&sntz=1&usg=AFQjCNHLO0bOHl6_AnXoqAtnfQ0SeuCumw).
2. Copy the image to /var/lib/tftpboot. You can use this command:

		cp unidonly.kpxe /var/lib/tftpboot
	
3. Download the iPXE bootstrap script from the Razor server to the /var/lib/tftpboot directory with this command:

		wget http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api/microkernel/bootstrap?nic_max=1 -O /var/lib/tftpboot/bootstrap.ipxe
	

####Edit the dnsmasq Configuration File to Enable PXE Boot

1. Edit the file /etc/dnsmasq.conf, by adding the following line at the bottom of the file:

		conf-dir=/etc/dnsmasq.d

2. Save and close the file.
3. Create the file /etc/dnsmasq.d/razor and add the following configuration information:

		# This works for dnsmasq 2.45
		# iPXE sets option 175, mark it for network IPXEBOOT
		dhcp-match=IPXEBOOT,175
		dhcp-boot=net:IPXEBOOT,bootstrap.ipxe
		dhcp-boot=undionly.kpxe
		# TFTP setup
		enable-tftp
		tftp-root=/var/lib/tftpboot

4. Start the “dnsmasq” service:

		service dnsmasq start
	 

Install the Razor Server
-------------

The actual Razor software is stored in an external location. When you classify a node with the pe_razor module, the software is downloaded. This process can take several minutes. 

1. On the puppet master, classify a non-privileged node with the following manifest:

		node <AGENT_CERT> {
  			include pe_razor    
		}

2. On the puppet agent, execute this command:

		puppet agent -t


####Verify the Razor Server 

Test the new Razor configuration with the following command:

	wget http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api -O test.out



Install and Set Up the Razor Client
-------------

The Razor client is installed as a Ruby gem.

1. Install the client with this command:

		gem install razor-client
		
2. You can verify that the Razor client is installed by printing Razor help:

		razor -u http://<RAZOR_HOST_NAME>:<RAZOR_PORT>/api

3. You'll likely get a message about JSON. You can get rid of it with this command:

		gem install json_pure

		

[Next: Provision with Razor](./razor_using.html)
