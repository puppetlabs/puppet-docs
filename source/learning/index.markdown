---
layout: default
title: Learning Puppet
---

Learning Puppet
===============

The web (including this site) is full of guides for how to solve specific problems with Puppet and how to get Puppet running. This is something slightly different. 

* * * 

Start: [Resources and the RAL][ral] &rarr;

Latest: [Ordering][] &rarr;

* * * 

[learningvm]: url
<!-- Chapters: -->
[ral]: ./ral.html
[Manifests]: ./manifests.html
[Ordering]: ./ordering.html

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

* [Learning Puppet VM][learningvm]

Currently, this has been tested with VMWare Fusion on OS X, but it should be usable with other virtualization software; we hope to test it with VirtualBox soon. The root user's password is `puppet`, and you should be able to SSH into it without a problem; for your convenience, the system is configured to write its current IP address to the login screen about ten seconds after it boots. Beyond that, teaching the use of virtualization software is outside the scope of this introduction, but [let me know](mailto:nick.fagerlund@puppetlabs.com) if you run into trouble and we'll try to refine our approach over time.

If you'd rather cook up your own VM than download one from the web, you can imitate it fairly easily: this is a stripped-down CentOS 5.5 system with a hostname of "puppet," [Puppet Enterprise](http://info.puppetlabs.com/puppet-enterprise) installed using all default answers, iptables turned off, and the `pe-puppet` and `pe-httpd` services stopped and disabled. (It also has some nice language modes installed for vim and emacs, but that's not strictly necessary.)

To begin with, you won't need separate agent and master VMs; you'll be running Puppet in its serverless mode on a single machine. When we get to agent/master Puppet, we'll walk through turning on the puppet master and duplicating this system into a new agent node. 

Hit the Gas
-----------

And with that, you're ready to start. 

### Part one: Serverless Puppet

* Begin with [Resources and the RAL][ral], where you'll learn about the fundamental building blocks of system configuration. 
* After that, move on to [Manifests][] and start controlling your system by writing actual Puppet code. 
* Next, in [Ordering][], learn about dependencies and refresh events, manage the relationships between resources, and discover the most useful Puppet design pattern.

And come back soon, because there are a lot more chapters on the way.