---
layout: pe2experimental
title: "PE 2.0 » Welcome » Getting Started"
---


Getting Started
===============

Thank you for choosing Puppet Enterprise, the best-of-breed distribution for the Puppet family of systems automation tools.

About This Guide
-----

This guide will help you install and use Puppet Enterprise 2.0, with a focus on PE-specific features. If you've never used Puppet or MCollective before, you can start using PE today with the console's live management features; to get even more out of PE, we recommend the [Learning Puppet][lp] series and the [MCollective documentation][mco]. 

[lp]: http://docs.puppetlabs.com/learning/
[mco]: http://docs.puppetlabs.com/mcollective/index.html

About Puppet Enterprise
-----

Puppet Enterprise starts with a full-featured, production-scale Puppet stack, then enhances it with the MCollective orchestration framework; a web-based console UI for managing Puppet and editing your systems on the fly; and a cloud provisioning tool for creating and configuring new VM instances.

About Puppet
-----

Puppet is the leading open source configuration management tool. It allows system configuration "manifests" to be written in a high-level <abbr title="Domain-Specific Language">DSL</abbr>, and can compose modular chunks of configuration to create a machine's unique catalog. Puppet Enterprise implements a client/server Puppet environment, where agent nodes request catalogs from a central puppet master.

About MCollective
-----

MCollective is a distributed task-running framework. It allows nodes to listen for commands over a message bus, and independently take action when they hear an authorized request. This lets you investigate and command your infrastructure in real time without relying on a central inventory. 

Puppet Enterprise configures MCollective with the enterprise-grade ActiveMQ message server, and enables authorized admins to to issue MCollective commands from the puppet master server. MCollective is the backbone of the web console's live management features.

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

<!-- TODO something about cloud provisioner. -->
