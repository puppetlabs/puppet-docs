---
layout: default
title: "PE 2.5 » Overview » About Puppet Enterprise"
subtitle: "About Puppet Enterprise"
canonical: "/pe/latest/overview_about_pe.html"
---


Thank you for choosing Puppet Enterprise, the best-of-breed distribution for the Puppet family of systems automation tools.

Puppet Enterprise is:

* A full-featured, production-level Puppet stack, ready to scale to thousands of nodes.
* A web-based console UI, for analyzing reports, managing your Puppet systems, and editing resources on the fly.
* Powerful orchestration capabilities built on the MCollective framework.
* Cloud provisioning tools for creating and configuring new VM instances.
* An alternate compliance workflow for auditing changes to unmanaged resources.

This user's guide will help you start using Puppet Enterprise 2.5, and will serve as a reference as you gain more experience with it. It covers PE-specific features, and offers brief introductions to Puppet and MCollective. Use the **navigation at left** to move between the guide's sections and chapters.

> For New Users
> -----
> 
> If you've never used Puppet before and want to evaluate Puppet Enterprise, follow the [Puppet Enterprise quick start guide](./quick_start.html). This walkthrough will guide you through creating a small proof-of-concept deployment and using the core features and workflows of Puppet Enterprise. 

> For Returning Users
> -----
> 
> See the [what's new page](./overview_whats_new.html) for the new features in this release of Puppet Enterprise. You can find detailed release notes for updates within the 2.5.x series in the [appendix of this guide](./appendix.html).


About Puppet
-----

Puppet is the leading open source configuration management tool. It allows system configuration "manifests" to be written in a high-level <abbr title="Domain-Specific Language">DSL</abbr>, and can compose modular chunks of configuration to create a machine's unique configuration. By default, Puppet Enterprise uses a client/server Puppet deployment, where agent nodes fetch configurations from a central puppet master.

About Orchestration
-----

Puppet Enterprise includes distributed task orchestration features. Nodes managed by PE will listen for commands over a message bus, and independently take action when they hear an authorized request. This lets you investigate and command your infrastructure in real time without relying on a central inventory. 

PE's orchestration features are driven by the MCollective framework and the ActiveMQ message server, and are the backbone of the web console's live management features.

> ![windows-only](./images/windows-logo-small.jpg) **NOTE:** Orchestration and live management are not yet supported on Windows nodes.

About the Console
-----

Puppet Enterprise's console is the web front-end for managing your systems. The console can:

* Trigger immediate Puppet runs on an arbitrary subset of your nodes
* Browse and edit resources on your nodes in real time
* Analyze reports to help visualize your infrastructure over time
* Browse inventory data and backed-up file contents from your nodes
* Group similar nodes and control the Puppet classes they receive in their catalogs
* Run advanced tasks powered by MCollective plugins

About the Cloud Provisioning Tools
-----

Puppet Enterprise includes command line tools for building new nodes, which can create new VMware and Amazon EC2 instances, install Puppet Enterprise on any virtual or physical machine, and classify newly provisioned nodes within your Puppet infrastructure. 


Licensing
-----

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master. 

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>. 


* * * 

- [Next: New Features](./overview_whats_new.html)
