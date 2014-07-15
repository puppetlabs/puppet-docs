---
layout: default
title: "PE 3.3 » Overview » About Puppet Enterprise"
subtitle: "About Puppet Enterprise"
canonical: "/pe/latest/overview_about_pe.html"
---


Thank you for choosing Puppet Enterprise (PE), IT automation software that allows system administrators to programmatically provision, configure, and manage servers, network devices and storage, in the data center or in the cloud.

This user's guide will help you start using Puppet Enterprise 3.3, and will serve as a reference as you gain more experience. It covers PE-specific features and offers brief introductions to Puppet and the orchestration engine. Use the **navigation at left** to move between the guide's sections and chapters.

> For New Users
> -----
>
> If you've never used Puppet before and want to evaluate Puppet Enterprise, follow the [Puppet Enterprise quick start guide](./quick_start.html). This walkthrough will guide you through creating a small proof-of-concept deployment while demonstrating the core features and workflows of Puppet Enterprise.

> For Returning Users
> -----
>
> See the [release notes](./release_notes.html). Here you can find detailed information about [new features](./release_notes.html#new-features) in the 3.3.x series.

About Puppet Enterprise
-----

Puppet Enterprise is a comprehensive tool for enterprise systems configuration management. Specifically, PE offers:

* Configuration management tools that let sysadmins define a desired state for their infrastructure and then automatically enforce that state.
* A web-based console UI for analyzing events, managing your Puppet systems and users, and editing resources on the fly.
* Powerful orchestration capabilities.
* Cloud provisioning tools for creating and configuring new VM instances.

Puppet Enterprise consists of a complete stack of Puppet Labs' technologies, which are automatically installed and connected. Specifically, PE 3.3 includes all of the following Puppet Labs software:

 * Puppet 3.6.2
 * PuppetDB 1.6.2
 * Facter 1.7.5
 * MCollective 2.5.1
 * Hiera 1.3.3
 * Dashboard 2.1.6

The "What Gets Installed Where" page includes a [list of all the major packages that comprise PE 3.3](./install_what_and_where.html#puppet-enterprise-components).

About Puppet
-----

Puppet is the leading open source configuration management tool. It allows system configuration "manifests" to be written in a high-level <abbr title="Domain-Specific Language">DSL</abbr> and can compose modular chunks of configuration to create a machine's unique configuration. By default, Puppet Enterprise uses a client/server Puppet deployment, where agent nodes fetch configurations from a central puppet master.

About Orchestration
-----

Puppet Enterprise includes distributed task orchestration features. Nodes managed by PE will listen for commands over a message bus and independently take action when they hear an authorized request. This lets you investigate and command your infrastructure in real time without relying on a central inventory.

About the Puppet Enterprise Console
-----

PE's console is the web front-end for managing your systems. The console can:

* Trigger immediate puppet runs on an arbitrary subset of your nodes
* Browse and compare resources on your nodes in real time
* Analyze events and reports to help you visualize your infrastructure over time
* Browse inventory data and backed-up file contents from your nodes
* Group similar nodes and control the Puppet classes they receive in their catalogs
* Run advanced orchestration tasks

About the Cloud Provisioning Tools
-----

PE includes command line tools for building new nodes, which can create new VMware, Google Compute Engine, Openstack, and Amazon EC2 instances, install PE on any virtual or physical machine, and classify newly provisioned nodes within your Puppet infrastructure.


Licensing
-----

PE can be evaluated with a complimentary ten node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master.

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>.


* * *

- [Next: Release Notes](./release_notes.html)
