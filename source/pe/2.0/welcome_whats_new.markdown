---
layout: pe2experimental
title: "PE 2.0 » Welcome » What's New"
---


What's New in Puppet Enterprise 2.0?
========

Live Management
-----

PE's web console now lets you edit and command your infrastructure in real time. Visit the console's live management tab to:

* Browse resources on your nodes in real-time
* Clone resources to make a group of nodes resemble a known good node
* Trigger puppet runs on an arbitrary set of nodes
* Run advanced MCollective tasks from your browser

Live management works out of the box, without writing any Puppet code.

<!-- TODO add a screenshot -->

The Cloud Provisioner
-----

The cloud provisioner is a new command-line tool for building new nodes. Among other things, it can create a new machine instance, install PE on it, and assign it to a node group in a single command.

New Version of Puppet
-----

Puppet Enterprise is now built around Puppet 2.7, which made several significant improvements and changes to the Puppet core:

* Puppet can now manage network devices with the vlan, interface, and router resource types. 
* There's a new API for creating subcommands called Faces, and Puppet ships with prebuilt subcommands that expose core subsystems at the command line.
* Error messages have been generally improved, including the infamous OpenSSL "Hostname was not match" error.
* Service init scripts are now assumed to have status commands; use `hasstatus => false` to emulate the behavior from 2.6 and earlier.
* Dynamically scoped variable lookup now causes warnings to be logged. If you're getting these warnings, you should begin [switching to fully qualified variable names and parameterized classes](/guides/scope_and_puppet.html) to eliminate dynamic scoping in your manifests.

See the [Puppet release notes][releasenotes] for more details.

[releasenotes]: http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes


Some Renaming and Renovation
-----

What was Puppet Dashboard is now just "the console." We've also moved around some implementation details, which might affect you if you've written scripts to extend Puppet Enterprise 1.2; see the [upgrading guide](./install_upgrading.html) for more details. 

