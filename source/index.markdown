---
layout: default
title: Puppet Labs Documentation
---

Puppet Labs Documentation
=========================

Welcome to the Puppet Labs documentation site. The documentation posted here is also available as a (very large, and frequently updated) PDF, which can be found on our [downloads page](http://www.puppetlabs.com/resources/downloads/).

* * *

MCollective
-----------

The [Marionette Collective documentation](./mcollective/index.html) lives in its own section of the site.

Drive-Thru
----------

Small documents for getting help fast.

* <a href="./puppet_core_types_cheatsheet.pdf"><img src="./images/puppet_core_types_cheatsheet_thumbnail.png" style="float: right; margin: 4px;"></a> Core Types Cheat Sheet --- available in [single-page flavor](./puppet_core_types_cheatsheet.pdf) (double-sided), [extra breathing room flavor](./puppet_core_types_cheatsheet_expanded.pdf) (six pages), and [plain web page](http://projects.puppetlabs.com/projects/puppet/wiki/Core_Types_Cheat_Sheet/) flavor
* [Frequently Asked Questions](./guides/faq.html)

Learning Puppet
---------------

Learn to use Puppet! New users: start here.

* [Introduction and Index](./learning/)
* [Resources and the RAL](./learning/ral.html) --- learn about resources, the molecules of system configuration
* [Manifests](./learning/manifests.html) --- start writing and applying Puppet code
* [Ordering](./learning/ordering.html) --- learn to join resources that depend on each other

Reference Shelf
---------------

Get detailed information about config files, APIs, and the Puppet language.

* [REST API](./guides/rest_api.html) --- reference of api accessible resources
* [Puppet Language Guide](./guides/language_guide.html) --- all the language details
* [Puppet Manpages](./man/) --- detailed help for each Puppet application
* [REST Access Control](./guides/rest_auth_conf.html) --- secure API access with `auth.conf`

### Automatically Generated References

Complete and up-to-date references for Puppet's resource types, functions, metaparameters, configuration options, indirection termini, and reports, served piping hot directly from the source code.

* [Resource Types](./references/latest/type.html) --- all default types
* [Functions](./references/latest/function.html) --- all built in functions
* [Metaparameters](./references/latest/metaparameter.html) --- all type-independent resource attributes
* [Configuration](./references/latest/configuration.html) --- all configuration file settings
* [Report](./references/latest/report.html) --- all available report handlers

These references are automatically generated from the inline documentation in Puppet's source code. References generated from each version of Puppet are archived here:

* [Versioned References](references/) --- inline reference docs from Puppet's past and present

Puppet Guides
-------------

Learn about different areas of Puppet, fix problems, and design solutions.

### Components

Learn more about major working parts of the Puppet system.

* [Puppet commands: master, agent, apply, resource, and more](./guides/tools.html) --- components of the system

### Installing and Configuring

Get Puppet up and running at your site.

* [An Introduction to Puppet](./guides/introduction.html)
* [Supported Platforms](./guides/platforms.html)
* [Installing Puppet](./guides/installation.html) --- from packages, source, or gems
* [Configuring Puppet](./guides/configuring.html) --- includes server setup & testing

### Tuning and Scaling

Puppet's default configuration is meant for prototyping and designing a site. Once you're ready for production deployment, learn how to adjust Puppet for peak performance.

* [Scaling Puppet](./guides/scaling.html) --- general tips & tricks
* [Scaling With Passenger](./guides/passenger.html) --- for Puppet 0.24.6 and later
* [Scaling With Mongrel](./guides/mongrel.html) --- for older versions of Puppet

### Basic Features and Use

* [Techniques](./guides/techniques.html) --- common design patterns, tips, and tricks
* [Troubleshooting](./guides/troubleshooting.html) --- avoid common problems and confusions
* [Puppet Modules](./guides/modules.html) --- modules make it easy to organize and share content
* [Puppet File Serving](./guides/file_serving.html) --- serving files with Puppet
* [Style Guide](./guides/style_guide.html) --- Puppet community conventions
* [Best Practices](./guides/best_practices.html) --- use Puppet effectively

### Advanced Features

Go beyond basic manifests.

* [Templating](./guides/templating.html) --- template out config files using ERB
* [Virtual Resources](./guides/virtual_resources.html)
* [Exported Resources](./guides/exported_resources.html) --- share data between hosts
* [Environments](./guides/environment.html) --- separate dev, stage, & production
* [Reporting](./guides/reporting.html) --- learn what your nodes are up to

#### Puppet Dashboard

Install and use Puppet's optional web interface.

* [Installing Dashboard](./guides/installing_dashboard.html)
* [Using Dashboard](./guides/using_dashboard.html)

### Hacking and Extending

Build your own tools and workflows on top of Puppet.

#### Using APIs and Interfaces

* [External Nodes](./guides/external_nodes.html) --- specify what your machines do using external data sources
* [Inventory Service](./guides/inventory_service.html) --- use Puppet's inventory of nodes at your site in your own custom applications

#### Using Ruby Plugins

* [Plugins In Modules](./guides/plugins_in_modules.html) --- where to put plugins, how to sync to clients
* [Writing Custom Facts](./guides/custom_facts.html)
* [Writing Custom Functions](./guides/custom_functions.html)
* [Writing Custom Types & Providers](./guides/custom_types.html)
* [Complete Resource Example](./guides/complete_resource_example.html) --- more information on custom types & providers
* [Provider Development](./guides/provider_development.html) --- more about providers

#### Developing Puppet

* [Running Puppet from Source](./guides/from_source.html) --- preview the leading edge
* [Development Life Cycle](./guides/development_lifecycle.html) --- learn how to contribute code

Other Resources
---------------

* [Puppet Wiki & Bug Tracker](http://projects.puppetlabs.com/)
* [Puppet Patterns (Recipes)](http://puppetlabs.com/trac/puppet/wiki/Recipes)

Help Improve This Document
--------------------------

This document belongs to the community and is licensed under the Creative Commons. You can help improve it!

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/us/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/us/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/us/">Creative Commons Attribution-Share Alike 3.0 United States License</a>.

To contribute ideas, problems, or suggestions, simply use the [Contribute](./contribute.html) link.  If you would like to submit your own content, the process is easy.  You can fork the project on <A HREF="http://github.com/puppetlabs/puppet-docs">github</A>, make changes, and send us a pull request.  See the README files in the project for more information.

Documentation Version
---------------------

This release of the documentation was generated from revision {% gitrevision 'master' %} of the puppet-docs repo on {{ 'now' | date: "%B %d, %Y" }}.
<!-- Note that HEAD is unreliable here because the releases branch ends up having orphaned commits. -->
