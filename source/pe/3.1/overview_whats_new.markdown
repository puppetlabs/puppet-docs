---
layout: default
title: "PE 3.1 » Overview » What's New"
subtitle: "New Features in PE 3.1"
canonical: "/pe/latest/release_notes.html"
---

### Version 3.1.3

PE 3.1.3 is a security release that patches a vulnerability. For details, check the [release notes](appendix.html#release-notes).

### Version 3.1.2

PE 3.1.2 is a maintenance release that patches a security vulnerability and fixes several minor bugs. For details, check the [release notes](appendix.html#release-notes).

### Version 3.1.1

PE 3.1.1 is a maintenance release that patches several security vulnerabilities. For details, check the [release notes](appendix.html#release-notes).

### Version 3.1.0

Puppet Enterprise (PE) version 3.1.0 is a feature and maintenance release. It adds new features, fixes bugs, and addresses security issues. Specifically, the 3.1.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes):

* *Event Inspector*

Event inspector is a new reporting tool that provides multiple, dynamic ways to view the state of your infrastructure, providing both broad and specific insight into how Puppet is managing configurations. By providing information about events from the perspective of nodes, classes, and resources, event inspector lets you quickly and easily find the source of configuration failures. For more information, see the [event inspector page](console_event-inspector.html).

* *Discoverable Classes & Parameters*

New UI and functionality in PE's console now allows you to easily add classes and parameters in the production environment by selecting them from an auto-generated list. The list also displays available documentation for the class, making it easier to know what a class does and why. For more information, see the [console documentation on classification](console_classes_groups.html#viewing-the-known-classes).

 * *Red Hat Enterprise Linux 4 Support*

The puppet agent can now be installed on nodes running RHEL 4. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

* *License Availability*

The console UI now displays how many licenses you are currently using and how many are available, so you'll know exactly how much capacity you have to expand your deployment. In addition, the "active license" count is now determined by the number of active nodes known to puppetdb rather than by the number of un-revoked certs. The [console navigation page](console_navigating.html) has more information. 

* *Support for Google Compute Engine*

PE's cloud provisioner now supports Google Compute Engine virtual infrastructure. For more information, see the [GCE cloud provisioner page](cloudprovisioner_gce.html).

* *Geppetto Integration*

Geppetto is an integrated development environment (IDE) for Puppet. It provides a toolset for developing puppet modules and manifests that includes syntax highlighting, error tracing/debugging, and code completion features. Geppetto also adds PE integration by parsing PuppetDB error reporting to show you where in your code an error occurred. This allows you to quickly find and fix the problems that are causing configuration failures.The [puppet modules and manifests page](puppet_modules_manifests.html) and the [Geppetto manual](/geppetto/4.0/index.html) have more information.

* *Windows Reboot Capabilities*

PE now includes a module that adds a type and provider for managing reboots on Windows nodes. You can now create manifests that can restart windows nodes after package updates or whenever any other resource is applied. Two forms of reboot are supported, a default mode for reboots required after puppet installs a package, and a second mode for managing pending reboots that must be processed before further packages can be installed. For more information, see the [module documentation](https://forge.puppetlabs.com/puppetlabs/reboot).

*  *Account Lockout*

Security against brute force attacks has been improved by adding an account lockout mechanism. User accounts will be locked after ten failed login attempts. This occurs whether the user is using the console or basic auth on the command line to attempt login. Accounts can only be unlocked by an admin user.

* *Security Patches*

A number of vulnerabilities have been addressed in PE 3.1.0. For details, check the [release notes](appendix.html#release-notes).


* * *

- [Next: Getting Support](./overview_getting_support.html)
