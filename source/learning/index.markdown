---
layout: default
title: Learning Puppet
---

Learning Puppet
===============

The web (including this site) is full of guides for how to solve specific problems with Puppet and how to get Puppet running. This is something slightly different.

* * *

Latest: [Preparing an Agent VM](./agentprep.html) and [Basic Agent/Master Puppet](./agent_master_basic.html) &rarr;

* * *

[learningvm]: http://info.puppetlabs.com/download-learning-puppet-VM.html.html
<!-- Chapters: -->
[ral]: ./ral.html
[Manifests]: ./manifests.html
[Ordering]: ./ordering.html
[variables]: ./variables.html
[modules1]: ./modules1.html
[templates]: ./templates.html
[modules2]: ./modules2.html
[definedtypes]: ./definedtypes.html

Contents
--------

{% include learning_nav.markdown %}

Welcome
-------

This is **Learning Puppet.** and it's part of the Puppet documentation. Specifically, it's the first part.

By which I don't mean it's about getting Puppet installed, or making sure your SSL certificates got issued correctly; that's the _other_ first part. To be a little gnomic about it --- because why not --- this series is less about how to use Puppet than it is about how to become a Puppet user. If you've heard good things about Puppet but don't know where to start, this, hopefully, is it.

It's a work in progress, and I'd love to read your feedback at <nick.fagerlund@puppetlabs.com>.

Get Equipped
------------

You can't make a knowledge omelette without breaking... stuff. Possibly eggs, maybe your system's entire configuration! Such is life.

So to learn Puppet effectively, you need a virtual machine you can experiment on fearlessly. And to learn Puppet _fast,_ you want a virtual machine with Puppet already installed, so you don't have to learn to debug SSL problems before you know how to classify a node.

In short, you want _this_ virtual machine:

<a href="http://info.puppetlabs.com/download-learning-puppet-VM.html" class="btn">Get the Learning Puppet VM</a>

The root user's password is `puppet`, and for your convenience, the system is configured to write its current IP address to the login screen about ten seconds after it boots.

If you'd rather cook up your own VM than download one from the web, you can imitate it fairly easily: this is a stripped-down CentOS 5.5 system with a hostname of "learn.puppet.demo," [Puppet Enterprise](http://info.puppetlabs.com/puppet-enterprise) installed using all default answers, iptables turned off, and the `pe-puppet` and `pe-httpd` services stopped and disabled. (It also has Puppet language modes installed for Vim and Emacs, but that's not strictly necessary.)

To begin with, you won't need separate agent and master VMs; you'll be running Puppet in its serverless mode on a single node. When we get to agent/master Puppet, we'll walk through turning on the puppet master and duplicating this system into a new agent node.

The Learning Puppet VM is available in VMWare .vmx format and the cross-platform OVF format, and has been tested with VMWare Fusion and VirtualBox. 

Although teaching the use of virtualization software is outside the scope of this introduction, [let me know](mailto:nick.fagerlund@puppetlabs.com) if you run into trouble, and we'll try to refine our approach over time.

> VM Tips
> -----
> 
> ### Importing the VM into VirtualBox
> 
> If you are using VirtualBox with the OVF version of the VM, choose "Import Appliance" from the File menu and browse to the `.ovf` file included with your download; alternately, you can drag the OVF file and drop it onto VirtualBox's main window.
>
> **Do not** use the "New Virtual Machine Wizard" and select the included `.vmdk` file as the disk; machines created this way will kernel panic during boot.
> 
> ### Configuring Virtual Networking
> 
> #### With VMware
> 
> If you are using a VMware virtualization product, you can leave the VM's networking in its default NAT mode. This will let it contact your host computer, any other VMs being run in NAT mode, the local network, and the outside internet; the only restriction is that computers outside your host computer can't initiate connections with it. If you eventually need other computers to be able to contact your VM, you can change its networking mode to Bridged.
> 
> #### With VirtualBox
> 
> VirtualBox's NAT mode is severely limited, and will not work with the later agent/master lessons. **You should change the VM's network mode to Bridged Adapter before starting the VM for the first time.** 
> 
> ![How to open a VirtualBox VM's network settings](./images/vbox_network.png)
> 
> ![A VirtualBox VM's network settings being changed to bridged](./images/vbox_network_bridged.png)
> 
> If for some reason you cannot expose the VM as a peer on your local network, or you are not on a network with working DHCP, you must configure the VM to have **two** network adapters: one in NAT mode (for accessing the local network and the internet) and one in Host Only Adapter mode (for accessing the host computer and other VMs). You will also have to either assign an IP address to the host-only adapter manually, or configure VirtualBox's DHCP server.
> 
> [See here for more information about VirtualBox's networking modes][vbnetworking], and [see here for more about VirtualBox's DHCP server][vbdhcp].
> 
> [vbnetworking]: http://www.virtualbox.org/manual/ch06.html
> [vbdhcp]: http://www.virtualbox.org/manual/ch08.html#vboxmanage-dhcpserver
> 
> To manually assign an IP address to a host-only adapter:
> 
> * Find the host computer's IP address by looking in VirtualBox's preferences --- go to the "Network" section, double-click on the host-only network you're using, go to the "Adapter" tab, and note the IP address in the "IPv4 Address" field.
> * Once your VM is running, log in on its console and run `ifconfig eth1 <NEW IP ADDRESS>`, where `<NEW IP ADDRESS>` is an unclaimed IP address on the host-only network's subnet. 
> 


Hit the Gas
-----------

And with that, [you're ready to start](./ral.html).

