---
layout: default
title: Learning Puppet
---

Learning Puppet
===============

The web (including this site) is full of guides for how to solve specific problems with Puppet and how to get Puppet running. This is something slightly different.

* * *

Start: [Resources and the RAL][ral] &rarr;

Latest: [Templates][] and [Modules (Part Two)][modules2] &rarr;

* * *

[learningvm]: http://info.puppetlabs.com/learning-puppet-vm.html
<!-- Chapters: -->
[ral]: ./ral.html
[Manifests]: ./manifests.html
[Ordering]: ./ordering.html
[variables]: ./variables.html
[modules1]: ./modules1.html
[templates]: ./templates.html
[modules2]: ./modules2.html

Welcome
-------

This is **Learning Puppet,** and it's part of the Puppet documentation. Specifically, it's the first part.

By which I don't mean it's about getting Puppet installed, or making sure your SSL certificates got issued correctly; that's the _other_ first part. To be a little gnomic about it --- because why not --- this series is less about how to use Puppet than it is about how to become a Puppet user. If you've heard good things about Puppet but don't know where to start, this, hopefully, is it.

It's a work in progress, and I'd love to read your feedback at <nick.fagerlund@puppetlabs.com>.

Get Equipped
------------

You can't make a knowledge omelette without breaking... stuff. Possibly eggs, maybe your system's entire configuration! Such is life.

So to learn Puppet effectively, you need a virtual machine you can experiment on fearlessly. And to learn Puppet _fast,_ you want a virtual machine with Puppet already installed, so you don't have to learn to debug SSL problems before you know how to classify a node.

In short, you want _this_ virtual machine:

<a href="http://info.puppetlabs.com/learning-puppet-vm" class="btn">Get the Learning Puppet VM</a>

The root user's password is `puppet`, and for your convenience, the system is configured to write its current IP address to the login screen about ten seconds after it boots.

If you'd rather cook up your own VM than download one from the web, you can imitate it fairly easily: this is a stripped-down CentOS 5.5 system with a hostname of "learn.puppet.demo," [Puppet Enterprise](http://info.puppetlabs.com/puppet-enterprise) installed using all default answers, iptables turned off, and the `pe-puppet` and `pe-httpd` services stopped and disabled. (It also has Puppet language modes installed for Vim and Emacs, but that's not strictly necessary.)

To begin with, you won't need separate agent and master VMs; you'll be running Puppet in its serverless mode on a single machine. When we get to agent/master Puppet, we'll walk through turning on the puppet master and duplicating this system into a new agent node.

Get Equipped (for users of vagrantup.com)
-----------------------------------------

centos5_64.box is a CentOS 5.5 64 bit vagrant box with Puppet 2.6.6 installed and ready to provision using the Puppet provisioner in Vagrant.

<pre>
$ gem install vagrant
$ vagrant box add puppet-centos-55-64 http://puppetlabs.s3.amazonaws.com/pub/centos5_64.box
$ vagrant init puppet-centos-55-64
$ vagrant up
</pre>

### Compatibility Notes

The Learning Puppet VM is available in VMWare .vmx format and the cross-platform OVF format, and has been tested with VMWare Fusion and VirtualBox. 

Getting the VM working with VMWare is fairly simple, but some extra effort is necessary on VirtualBox --- the IP address it prints isn't externally reachable, and by default you'll be unable to SSH to the VM. You can enable SSH by turning on port forwarding, but since several examples (and the eventual agent/master exercises) will require more network access than simply port 22, it's wiser to configure two network interfaces: 

* Before starting the VM, modify its network settings to add "Host Only" network access on adapter 2.
* Next, run `ifconfig` on your host machine and confirm the subnet assigned to the `vboxnet0` interface. (By default, this is 192.168.56.x, and your host machine's IP address is 192.168.56.1.) 
* Once the VM is running, log in on its console and run `ifconfig eth1 192.168.56.2` (or some other IP address compatible with the relevant subnet); this should let you ping and SSH the box from your host machine, and you can add an entry to your host machine's `/etc/hosts` file to make things more convenient. 

Beyond this, teaching the use of virtualization software is outside the scope of this introduction, but [let me know](mailto:nick.fagerlund@puppetlabs.com) if you run into trouble, and we'll try to refine our approach over time.


Hit the Gas
-----------

And with that, you're ready to start.

### Part one: Serverless Puppet

* Begin with [Resources and the RAL][ral], where you'll learn about the fundamental building blocks of system configuration.
* After that, move on to [Manifests][] and start controlling your system by writing actual Puppet code.
* Next, in [Ordering][], learn about dependencies and refresh events, manage the relationships between resources, and discover the most useful Puppet design pattern.
* In [Variables, Conditionals, and Facts][variables], make your manifests versatile by reading system information.
* In [Modules and Classes (Part One)][modules1], take the first step to a knowable and elegant site design and start turning your manifests into self-contained modules. 
* In [Templates][], use ERB to make your config files as flexible as your Puppet manifests.
* In [Modules and (Parameterized) Classes (Part Two)][modules2], learn how to pass parameters to classes and make your modules more adaptable.

And come back soon, because there are more chapters on the way.
