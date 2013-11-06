---
layout: default
title: "PE 3.1 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/appendix.html"
---


This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.1.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.1.0 (10/15/2013)

#### Event Inspector

Puppet Enterprise (PE) event inspector is a new reporting tool that provides multiple, dynamic ways to view the state of your infrastructure, providing both broad and specific insight into how Puppet is managing configurations. By providing information about events from the perspective of classes and resources, event inspector lets you quickly and easily find the source of configuration failures. For more information, see the [event inspector page](console_event-inspector.html).

#### Discoverable Classes & Parameters

New UI and functionality in PE's console now allow you to easily add classes and parameters in the production environment by selecting them from an auto-generated list. The list also displays available documentation for the class, making it easier to know what a class does and why. For more information, see the [console documentation on classification](console_classes_groups.html#viewing-the-known-classes).

#### Red Hat Enterprise Linux 4 Support

The puppet agent can now be installed on nodes running RHEL 4. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

#### License Availability

The console UI now displays how many licenses you are currently using and how many are available, so you'll know exactly how much capacity you have to expand your deployment.  The [console navigation page](console_navigating.html) has more information. 

#### Support for Google Compute Engine

PE's cloud provisioner now supports Google Compute Engine virtual infrastructure. For more information, see the [GCE cloud provisioner page](cloudprovisioner_gce.html).

#### Geppetto Integration

Geppetto is an integrated development environment (IDE) for Puppet. It is integrated with PE and provides a toolset for developing puppet modules and manifests that includes syntax highlighting, error tracing/debugging, and code completion features. For more information, visit the [Geppetto Documentation](./geppetto/4.0/index.html) or the [puppet modules and manifests page](puppet_modules_manifests.html).

#### Windows Reboot Capabilities

PE now includes a module that adds a type and provider for managing reboots on Windows nodes. You can now create manifests that can restart windows nodes after package updates or whenever any other resource is applied. For more information, see the [module documentation](https://forge.puppetlabs.com/puppetlabs/reboot).

#### Component Updates

Several of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3 (patch level 448)
* Augeas 1.1.0
* Puppet 3.3.1
* Facter 1.7.3.1
* Hiera 1.2.21
* Passenger 4.0.18
* Dashboard 2.0.12
* Java 1.7.0.19

#### Account Lockout

Security against brute force attacks has been improved by adding an account lockout mechanism. User accounts will be locked after ten failed login attempts. Accounts can only be unlocked by an admin user.

#### Removal of Upgrade Database Staging Directory

The upgrade process has been simplified by removing the need to provide a staging directory for transferring data between the old MySQL databases used by 2.8.x and new PostgreSQL databases used in 3.x. Data is now piped directly between the old and new databases.

#### Support for SELinux
PE 3.1 includes new SELinux bindings for pe-ruby on EL5 and EL6. These bindings allow you to manage SELinux attributes of files and the `seboolean` and `semodule` types. These bindings are available on a preview basis and are not installed by default. They are included in the installation tarball in a package named `pe-ruby-selinux`.

#### Security Fixes

*[CVE-2013-4287 Algorithmic Complexity Vulnerability In RubyGems 2.0.7 And Older](http://puppetlabs.com/security/cve/cve-2013-4287/)*

Assessed Risk Level: low. 
RubyGems validates versions with a regular expression that is vulnerable to attackers causing denial of service through CPU consumption. This is resolved in PE 3.1.

*[CVE-2013-4957 YAML vulnerability in Puppet dashboard's report handling](http://puppetlabs.com/security/cve/cve-2013-4957/)*

Assessed Risk Level: medium. 
Systems that rely on YAML to create report-specific types were found to be at risk of arbitrary code execution vulnerabilities. This vulnerability has been fixed in PE 3.1.

*[CVE-2013-4965 User account not locked after numerous invalid login attempts](http://puppetlabs.com/security/cve/cve-2013-4965/)*

Assessed Risk Level: low. 
A user's account was not locked out after the user submitted a large number of invalid login attempts, leaving the account vulnerable to brute force attack. This has been fixed in PE 3.1;  now the account is locked after 10 failed attempts.



* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
