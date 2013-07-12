---
layout: default
title: "PE 2.0 » Welcome » Getting Started"
canonical: "/pe/latest/overview_about_pe.html"
---

* * *

[Index](./) --- [Welcome: Components and Roles](./welcome_roles.html) &rarr;

* * *


Getting Started
===============

Thank you for choosing Puppet Enterprise, the best-of-breed distribution for the Puppet family of systems automation tools.

About This Guide
-----

This guide will help you start using Puppet Enterprise 2.0, and will serve as a reference as you gain more experience with it. It covers PE-specific features, and offers brief introductions to Puppet and MCollective. Use the **navigation to the right** to move between the guide's sections and chapters.

### New Users

If you've never used Puppet before and have just installed Puppet Enterprise, you should [read about](./console_live.html) and experiment with the console's no-code-needed live management features, then follow the tutorial in the "[Puppet For New PE Users](./puppet_overview.html)" section to build your first Puppet module. To get even more out of PE, we recommend the [Learning Puppet][lp] series and the [MCollective documentation][mco]. 

[lp]: /learning/
[mco]: /mcollective/index.html

About Puppet Enterprise
-----

Puppet Enterprise starts with a full-featured, production-scale Puppet stack, then enhances it with the MCollective orchestration framework; a web-based console UI for managing Puppet and editing your systems on the fly; and a cloud provisioning tool for creating and configuring new VM instances.

### Licensing

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master. 

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>. 

About Puppet
-----

Puppet is the leading open source configuration management tool. It allows system configuration "manifests" to be written in a high-level <abbr title="Domain-Specific Language">DSL</abbr>, and can compose modular chunks of configuration to create a machine's unique catalog. Puppet Enterprise implements a client/server Puppet environment, where agent nodes request catalogs from a central puppet master.

About Orchestration
-----

Puppet Enterprise now ships with distributed task orchestration features. Nodes managed by PE will listen for commands over a message bus, and independently take action when they hear an authorized request. This lets you investigate and command your infrastructure in real time without relying on a central inventory. 

PE's orchestration features are driven by the MCollective framework and the ActiveMQ message server, and are the backbone of the web console's live management features.

About the Console
-----

Puppet Enterprise's console is the web front-end for managing your systems. The console can:

* Trigger immediate Puppet runs on an arbitrary subset of your nodes
* Browse and edit resources on your nodes in real time
* Analyze reports to help visualize your infrastructure over time
* Browse inventory data and backed-up file contents from your nodes
* Group similar nodes and control the Puppet classes they receive in their catalogs
* Run advanced tasks powered by MCollective plugins

About the Cloud Provisioner
-----

The cloud provisioner is a command line tool for building new nodes. It can create new VMware and Amazon EC2 instances, install Puppet Enterprise on any virtual or physical machine, and classify newly provisioned nodes within your Puppet infrastructure. 

* * *

[Index](./) --- [Welcome: Components and Roles](./welcome_roles.html) &rarr;

* * *

