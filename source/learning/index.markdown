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

- **Part one: Serverless Puppet**
    - [Resources and the RAL](/learning/ral.html) --- Learn about the fundamental building blocks of system configuration.
    - [Manifests](/learning/manifests.html) --- Start controlling your system by writing actual Puppet code.
    - [Ordering](/learning/ordering.html) --- Learn about dependencies and refresh events, manage the relationships between resources, and discover the fundamental Puppet design pattern.
    - [Variables, Conditionals, and Facts](/learning/variables.html) --- Make your manifests versatile by reading system information.
    - [Modules and Classes (Part One)](/learning/modules1.html) --- Start building your manifests into self-contained modules.
    - [Templates](/learning/templates.html) --- Use ERB to make your config files as flexible as your Puppet manifests.
    - [Parameterized Classes (Modules, Part Two)](/learning/modules2.html) --- Learn how to pass parameters to classes and make your modules more adaptable.
    - [Defined Types](/learning/definedtypes.html) --- Model repeatable chunks of configuration by grouping basic resources into super-resources.
- **Part two: Master/Agent Puppet**
    - [Preparing an Agent VM](/learning/agentprep.html) --- Prepare your tools for the next few chapters with our step-by-step walkthrough.
    - [Basic Agent/Master Puppet](/learning/agent_master_basic.html) --- Tour the agent/master workflow: sign an agent node's certificate, pick which classes a node will get, and pull and apply a catalog.

Welcome
-------

This is **Learning Puppet.** and it's part of the Puppet documentation. Specifically, it's the first part.

By which I don't mean it's about getting Puppet installed, or making sure your SSL certificates got issued correctly; that's the _other_ first part. To be a little gnomic about it --- because why not --- this series is less about how to use Puppet than it is about how to become a Puppet user. If you've heard good things about Puppet but don't know where to start, this, hopefully, is it.

It's a work in progress, and we'd love to read your feedback at <faq@puppetlabs.com>.

Get Equipped
------------

The most efficient path to learning a new system configuration tool will probably --- hopefully, even --- involve catastrophically misconfiguring some systems.

So to help you learn Puppet, we provide a free virtual machine with Puppet already installed. Experiment fearlessly!

<a href="http://info.puppetlabs.com/download-learning-puppet-VM.html" class="btn">Get the Learning Puppet VM</a>

> ### Login Info
>
> * Log in as `root`, with the password `puppet`.
> * The VM is configured to write its current IP address to the login screen about ten seconds after it boots. If you prefer to use SSH, wait for the IP address to print and you can skip logging in at the console entirely.
> * To view the Puppet Enterprise web console, navigate to **https://(your VM's IP address)** in your web browser. Log in as `puppet@example.com`, with the password `learningpuppet`.
> * **Note:** If you want to create new user accounts in the console, the confirmation emails will contain incorrect links. You can work around this by modifying the links by hand to point to the VM's IP address, or you can fix the links by making sure the console is available at a reliable hostname and [following the instructions for changing the authentication hostname](/pe/latest/trouble_common_problems.html#console-account-confirmation-emails-have-incorrect-links).

If you'd rather cook up your own VM than download one from the web, you can imitate it fairly easily: this is a stripped-down CentOS 5.5 system with a hostname of "learn.localdomain," [Puppet Enterprise](http://puppetlabs.com/puppet/puppet-enterprise/) installed, and `iptables` disabled. (It also has Puppet language modes installed for Vim and Emacs, but that's not strictly necessary.)

To begin with, you won't need separate agent and master VMs; you'll be running Puppet in its serverless mode on a single node. When you reach the agent/master exercises, we'll walk through duplicating the system into a new agent node.

The Learning Puppet VM is available in VMWare .vmx format and the cross-platform OVF format, and has been tested with VMWare Fusion and VirtualBox.

Although teaching the use of virtualization software is outside the scope of this introduction, [let me know](mailto:faq@puppetlabs.com) if you run into trouble, and we'll try to refine our approach over time.

> VM Tips
> -----
>
> ### Importing the VM into VirtualBox
>
> There are several quirks and extra considerations to manage when importing this VM into VirtualBox:
>
> * If you are using VirtualBox with the OVF version of the VM, choose "Import Appliance" from the File menu and browse to the `.ovf` file included with your download; alternately, you can drag the OVF file and drop it onto VirtualBox's main window.
>
>     **Do not** use the "New Virtual Machine Wizard" and select the included `.vmdk` file as the disk; machines created this way will kernel panic during boot.
> * If you find the system hanging during boot at a "registered protocol family 2" message, you may need to go to the VM's "System" settings and check the "Enable IO APIC" option. (Many users are able to leave the IO APIC option disabled; we do not currently know what causes this problem.)
> * The VM should work without modification on 4.x versions of VirtualBox. However, on 3.x versions, it may fail to import, with an error like "Failed to import appliance. Error reading 'filename.ovf': unknown resource type 1 in hardware item, line 95." If you see this error, you can either upgrade your copy of VirtualBox, or work around it by editing the .ovf file and recalculating the sha1 hash, [as described here](http://mattiasgeniar.be/2012/03/31/importing-the-puppet-learning-vm-into-virtualbox-unknown-resource-type-in-hardware-item). Thanks to Mattias for this workaround.
>
> ### Importing the VM into Parallels Desktop
>
> Parallels Desktop 7 on OS X can import the VMX version of this VM, but it requires extra configuration before it can run:
>
> 1. First, convert the VM. Do not start the VM yet.
> 2. Navigate to the Virtual Machine menu, then choose Configure -> Hardware -> Hard Disk 1 and change its location from SATA to IDE (e.g. IDE 0:1).
> 3. You can now start the VM.
>
> If you attempt to start the VM without changing the location of the disk, it will probably kernel panic.
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

