---
layout: pe2experimental
title: "PE 2.0 » Welcome » What's New"
---

* * *

&larr; [Welcome: Components and Roles](./welcome_roles.html) --- [Index](./) --- [Welcome: Known Issues](./welcome_known_issues.html) &rarr;

* * *


What's New in Puppet Enterprise 2.0?
========

New Features
-----

### Live Management!

PE's web console now lets you edit and command your infrastructure in real time. Visit the console's live management tab to:

* Browse resources on your nodes in real-time
* Clone resources to make a group of nodes resemble a known good node
* Trigger puppet runs on an arbitrary set of nodes
* Run advanced MCollective tasks from your browser

Live management works out of the box, without writing any Puppet code.

### Cloud Provisioning!

PE 2 ships with new command-line tools for building new nodes. From the comfort of your terminal, you can create new machine instances, install PE on any node, and assign new nodes to your existing console groups.

### More Secure Console!

PE's web console is now served over SSL, and requires a login for access. 

### New Version of Puppet!

Puppet Enterprise is now built around Puppet 2.7, which made several significant improvements and changes to the Puppet core:

* Puppet can now manage network devices with the vlan, interface, and router resource types. 
* There's a new API for creating subcommands called Faces, and Puppet ships with prebuilt subcommands that expose core subsystems at the command line.
* Error messages have been generally improved, including the infamous OpenSSL "Hostname was not match" error.
* Service init scripts are now assumed to have status commands; use `hasstatus => false` to emulate the behavior from 2.6 and earlier.
* Dynamically scoped variable lookup now causes warnings to be logged. If you're getting these warnings, you should begin [switching to fully qualified variable names and parameterized classes](/guides/scope_and_puppet.html) to eliminate dynamic scoping in your manifests.

See the [Puppet release notes][releasenotes] for more details.

[releasenotes]: http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes


Renaming, Refactoring, and Renovation
-----

### Dashboard is Now Console

What was Puppet Dashboard is now just "the console."

### Changes to Orchestration Features

* Orchestration is enabled by default for all PE nodes. 
* Orchestration tasks can now be invoked directly from the console, with the "advanced tasks" section of the live management page. PE's orchestration framework also powers the other live management features.
* The `mco` user account on the puppet master is gone, in favor of a new `peadmin` user. This user can still invoke orchestration tasks across your nodes, but it will also gain more general purpose capabilities in future versions.
* PE now includes the `puppetral` plugin, which lets you use Puppet's Resource Abstraction Layer (RAL) in orchestration tasks.
* For performance reasons, the default message security scheme has changed from AES to PSK.
* The network connection over which messages are sent is now encrypted using SSL.

### Improved and Simplified Install Experience

The installer asks fewer and smarter questions. 

### Built-in Puppet Modules Have Been Renamed

The `mcollectivepe`, `accounts`, and `baselines` modules from PE 1.2 were renamed (to `pe_mcollective, pe_accounts,` and `pe_compliance`, respectively) to avoid namespace conflicts and make their origin more clear. The PE upgrader can install wrapper modules to preserve functionality if you used any of these modules by their previous names.


* * *

&larr; [Welcome: Components and Roles](./welcome_roles.html) --- [Index](./) --- [Welcome: Known Issues](./welcome_known_issues.html) &rarr;

* * *

