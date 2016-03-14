---
layout: default
title: " PE 3.3 » Razor » Set Up a Virtual Environment for Razor"
subtitle: "Install and Set Up a Virtual Environment for Testing Razor"
canonical: "/pe/latest/razor_prereqs.html"

---

Razor is a powerful tool created to automatically discover bare-metal hardware and dynamically configure operating systems and/or hypervisors. With this power comes the responsibility to test Razor carefully. Razor is also currently a [Tech Preview release](http://puppetlabs.com/services/tech-preview). For these reasons, we highly recommend that you install and test Razor in a completely isolated test environment. 

The following sections provide the steps for a basic setup that you can use to evaluate Razor. The setup steps below use dnsmasq; however, you can use any DHCP and TFTP service with Razor. 

>**Warning**: Proceed with caution. We recommend testing on a completely isolated test environment because running a second DCHCP server on your company's network could bring down the network. In addition, running a second DHCP server that will boot into the Razor microkernel and register with the server has a bigger risk. In such a case, if someone has established a policy that node matches, a simple reboot could cause Razor to replace a server with a fresh OS install. 

### Before You Begin

Things you should know before you set up provisioning:

+ Razor has been specifically validated on RHEL/CentOS 6.4, but it should work on all 6.x versions. See the [CentOS site](http://isoredirect.centos.org/centos/6/isos/x86_64/) for options.
+ The Razor microkernel is 64-bit only. Razor can only provision 64-bit machines.

## Install Overview

Below are the essential steps to create a virtual test environment. Each of these steps is described in more detail in the following sections.

1. Install PE in your virtual environment.
2. Install and configure DHCP/DNS/TFTP service.
	We've chosen dnsmasq for this example setup.
3. Configure SELinux to enable PXE boot.
	**Note**: you'll download iPXE software in the steps for installing and setting up Razor.
4. Optional: If you installed dnsmasq, then configure dnsmasq for PXE booting and TFTP

When you finish this section, go on to [Install and Set Up Razor](./razor_install.html). 

### Install PE in Your Virtual Environment

In your virtual testing environment, set up a puppet master running a standard install of Puppet Enterprise 3.3. For more information, see [Installing Puppet Enterprise](./install_basic.html).

**Note**: We're finding that VirtualBox 4.3.6 gets to the point of downloading the microkernel from the Razor server and hangs at 0% indefinitely. We don't have this problem with VirtualBox 4.2.22. 


### Install and Configure dnsmasq DHCP/TFTP Service

The installation that's described here, particularly these prerequisites, are one way to configure your Razor test environment. We're providing explicit instructions for this setup because it's been tested and is relatively straightforward. 

As stated in the **Warning** above, to avoid breaking your company network or inadvertently overwriting machines or servers on your network, you should be working with a completely isolated test environment. 


1. Use YUM to install dnsmasq:

		yum install dnsmasq
	
2. If it doesn't already exist, create the directory `/var/lib/tftpboot` .
3. Change the permissions for `/var/lib/tftpboot`:

		chmod 655 /var/lib/tftpboot
	
### Temporarily Disable SELinux to Enable PXE Boot

1. Disable SELinux by changing the following setting in the file `/etc/sysconfig/selinux`:

		SELINUX=disabled
 
	**Note**: Disabling SELinux is highly insecure and should only be done for testing  purposes. 
	
	Another option is to craft an enforcement rule for SELinux that will enable PXE boot but will not completely disable SElinux. 
	
2. Restart the computer and log in again. 

### Edit the dnsmasq Configuration File to Enable PXE Boot

1. Edit the file `/etc/dnsmasq.conf`, by adding the following line at the bottom of the file:

		conf-dir=/etc/dnsmasq.d

2. Write and exit the file.
3. Create the file `/etc/dnsmasq.d/razor` and add the following configuration information:

		# This works for dnsmasq 2.45
		# iPXE sets option 175, mark it for network IPXEBOOT
		dhcp-match=IPXEBOOT,175
		dhcp-boot=net:IPXEBOOT,bootstrap.ipxe
		dhcp-boot=undionly.kpxe
		# TFTP setup
		enable-tftp
		tftp-root=/var/lib/tftpboot

4. Enable dnsmasq on boot:

		chkconfig dnsmasq on

5. Start the dnsmasq service:

		service dnsmasq start	
		

* * *


[Next: Install and Set Up Razor](./razor_install.html)