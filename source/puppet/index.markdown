---
layout: default
title: Puppet Documentation Index
toc: false
---

This is the documentation for Puppet, as well as several related tools and applications.

Most of the content here applies equally to Puppet Enterprise and open source releases of Puppet, but make sure you're using the right docs version for your Puppet Enterprise version. If you get lost, check the version note in red text at the top of each page.

Main Docs
-----

Practically speaking, Puppet is a collection of several projects. Here's the documentation for all of the major components that make up a Puppet deployment:

Component     | Latest                             | Other versions
--------------|------------------------------------|--------------------------------------------
Puppet        | [Latest](/puppet/latest/reference) | [Other versions](#puppet-reference-manuals)
Puppet Server | [Latest](/puppetserver/latest)     | [Other versions](/puppetserver)
Facter        | [Latest](/facter/latest)           | [Other versions](/facter)
Hiera         | [Latest](/hiera/latest)            | [Other versions](/hiera)
PuppetDB      | [Latest](/puppetdb/latest)         | [Other versions](/puppetdb)


* * *

Cheat Sheets and Glossary
----------

Small documents for getting help fast.

* [Core Types Cheat Sheet](/puppet_core_types_cheatsheet.pdf) --- A double-sided reference to the most common resource types.
* [Module Cheat Sheet](/module_cheat_sheet.pdf) --- A one-page reference to Puppet module layout, covering classes and defined types, files, templates, and plugins.
* [Glossary](/references/glossary.html)

* * *

Puppet Reference Manuals
-----

A concise reference to Puppet's usage and internals. Use the left sidebar of any reference manual page to navigate between pages.

### Current Versions

* [Puppet 4.3](/puppet/4.3/reference) is included with Puppet Enterprise 2015.3.
* [Puppet 4.2](/puppet/4.2/reference) is included with Puppet Enterprise 2015.2.


### Older Versions

* [Puppet 4.1](/puppet/4.1/reference)
* [Puppet 4.0](/puppet/4.0/reference)
* [Puppet 3.8](/puppet/3.8/reference) is included with Puppet Enterprise 3.8.
* [Puppet 3.7](/puppet/3.7/reference)
* [Puppet 3.6](/puppet/3.6/reference)
* [Puppet 3.5](/puppet/3.5/reference)
* [Puppet 3.0 through 3.4](/puppet/3/reference)
* [Puppet 2.7](/puppet/2.7/reference)

### Other Reference Material

* [Versioned References](/references/) --- Inline reference docs from Puppet's past and present.
* [History of the Puppet Language](/guides/language_history.html) --- A table showing which language features were added and removed in which Puppet versions.


* * *

Puppet Guides
-------------

Learn about different areas of Puppet, problem fixes, and design solutions.

### Installing and Configuring

Get the latest version of Puppet up and running.

* [An Introduction to Puppet](/guides/introduction.html)
* [Installing Puppet 4 for Linux](/puppet/4.0/reference/install_linux.html)
* [Installing Puppet 4 for Windows](/puppet/4.0/reference/install_windows.html)
* Upgrading Puppet from 3.x to 4.x
  * [Upgrading Puppet 3.x Agents](/puppet/4.0/reference/upgrade_agent.html)
  * [Upgrading Puppet 3.x Servers](/puppet/4.0/reference/upgrade_server.html)

### Previous Install Guides

* [The Puppet 3.8 Installation Guide](puppet/3.8/reference/pre_install.html)

### Building and Using Modules

* [Module Fundamentals](/puppet/latest/reference/modules_fundamentals.html) --- Nearly all of your Puppet code should be in modules.
* [Installing Modules from the Puppet Forge](/puppet/latest/reference/modules_installing.html) --- Save time by using pre-existing modules.
* [Publishing Modules on the Puppet Forge](/puppet/latest/reference/modules_publishing.html) --- Preparing your best modules to go public.

### Help With Writing Puppet Code

* [Techniques](/guides/techniques.html) --- Common design patterns, tips, and tricks.
* [Troubleshooting](/guides/troubleshooting.html) --- Avoid common problems and confusions.
* [Style Guide](/guides/style_guide.html) --- Puppet community conventions.
* [Best Practices](/guides/best_practices.html) --- Use Puppet effectively.
* [Templating](/guides/templating.html) --- Template config files using ERB.
* [Virtual Resources](/guides/virtual_resources.html)
* [Exported Resources](/guides/exported_resources.html) --- Share data between hosts.
* [Using the Augeas Resource Type](/guides/augeas.html) --- Safely edit many types of config files.

### Using Optional Features

* [Puppet File Serving](/guides/file_serving.html) --- Files in modules are automatically served; this guide explains how to configure additional custom mount points for serving large files that shouldn't be kept in modules.

### Puppet on Windows

You can manage Windows nodes side by side with your \*nix infrastructure, with Puppet 2.7 and higher (including Puppet Enterprise ≥ 2.5).

* [Overview of Puppet on Windows](/windows/)
* [Troubleshooting Puppet on Windows](/windows/troubleshooting.html)

### Tuning and Scaling

Puppet's default configuration is meant for prototyping and designing a site. Once you're ready for production deployment, learn how to adjust Puppet for peak performance.

* [Running a Production-Grade Puppet Master Server With Passenger](/guides/passenger.html) --- This should be one of your earliest steps in scaling out Puppet.
* [Using Multiple Puppet Masters](/guides/scaling_multiple_masters.html) --- A guide to deployments with multiple Puppet masters.

### Hacking and Extending: Using Puppet's Data

* [Puppet Data Library: Overview](/guides/puppet_data_library.html) --- Puppet automatically gathers reams of data about your infrastructure. Learn where that data is, how to access it, and how to mine it for knowledge.
* [Inventory Service](/guides/inventory_service.html) --- Use Puppet's inventory of nodes at your site in your own custom applications.
* [Reporting](/guides/reporting.html) --- Learn what your nodes are up to.

### Hacking and Extending: APIs and Interfaces

* [External Nodes](/guides/external_nodes.html) --- Specify what your machines do using external data sources.
    * [LDAP Nodes](/guides/ldap_nodes.html) --- A special-case tool for keeping node information in your LDAP directory.

### Hacking and Extending: Ruby Plugins

* [Plugins In Modules](/guides/plugins_in_modules.html) --- Where to put plugins, and how to sync them to clients.
* [Writing Custom Facts](/facter/latest/custom_facts.html)
* [Writing Custom Functions](/guides/custom_functions.html)
* [Writing Custom Types & Providers](/guides/custom_types.html)
* [Complete Resource Example](/guides/complete_resource_example.html) --- More information on custom types & providers
* [Provider Development](/guides/provider_development.html) --- More about providers.

### Developing Puppet

* [Development Life Cycle](/guides/development_lifecycle.html) --- Learn how to contribute code.
* [Puppet Internals](/guides/puppet_internals.html) --- Understand how Puppet works internally.


### Historical Guides

Puppet has gone through some transitional periods, and we've occasionally written short guides to explain major changes in its behavior.

* [Scope and Puppet](/guides/scope_and_puppet.html) --- Understand and banish dynamic lookup warnings with Puppet 2.7.


* * *

Other Resources
---------------

* [Puppet Bug Tracker](https://tickets.puppetlabs.com/browse/PUP)
