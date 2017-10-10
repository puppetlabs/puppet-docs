---
layout: default
title: Puppet documentation index
toc: false
---

This is the documentation for Puppet, and its related tools and applications.

Most of the content here applies equally to Puppet Enterprise and open source releases of Puppet, but make sure you're using the right docs version for your Puppet Enterprise version. If you get lost, check the version note in red text at the top of each page.

## Main docs


Practically speaking, Puppet is a collection of several projects. Here's the documentation for all of the major components that make up a Puppet deployment:

Component     | Latest                                     | Other versions
--------------|--------------------------------------------|--------------------------------------------
Puppet        | [Latest](/puppet/latest)                   | [Other versions](#puppet-reference-manuals)
Puppet Server | [Latest](/puppetserver/latest)             | [Other versions](/puppetserver)
Facter        | [Latest](/facter/latest)                   | [Other versions](/facter)
Hiera         | [Latest](/puppet/latest/hiera_intro.html)  | [Other versions](/hiera)
PuppetDB      | [Latest](/puppetdb/latest)                 | [Other versions](/puppetdb)


* * *

## Cheat sheets and glossary


Small documents for getting help fast.

* [Core types cheat sheet](/puppet_core_types_cheatsheet.pdf) --- A double-sided reference to the most common resource types.
* [Module cheat sheet](/module_cheat_sheet.pdf) --- A one-page reference to Puppet module layout, covering classes and defined types, files, templates, and plugins.
* [Glossary](/references/glossary.html)

* * *

## Puppet reference manuals

A concise reference to Puppet's usage and internals. Use the left sidebar of any reference manual page to navigate between pages.

<ul>
{% assign this_doc = "puppet" %}

{% assign real_name = site.document_names[this_doc] %}
{% for base_url in site.document_version_order[this_doc] %}
{% if site.document_version_index[this_doc].latest == base_url %}{% assign past_latest = true %}{% endif %}
<li>
<a href="{{base_url}}">{{real_name}} {{site.document_list[base_url].version}}</a>
{% unless past_latest %}(not yet released){% endunless %}
{% if site.document_list[base_url].my_versions.pe != "latest" %}(Included in Puppet Enterprise {{site.document_list[base_url].my_versions.pe}}){% endif %}
</li>
{% endfor %}
</ul>

> **Note:** The "Puppet 3" manual covers versions 3.0 through 3.4.

### Other reference material

* [Versioned references](/references/) --- Inline reference docs from Puppet's past and present.
* [History of the Puppet language](/puppet/latest/language_history.html) --- A table showing which language features were added and removed in which Puppet versions.


* * *

## Puppet guides

Learn about different areas of Puppet, problem fixes, and design solutions.

### Installing and configuring

Get the latest version of Puppet up and running.

* [Overview of Puppet's architecture](/puppet/latest/architecture.html)
* [Installing Puppet 5 for Linux](/puppet/latest/install_linux.html)
* [Installing Puppet 5 for Windows](/puppet/latest/install_windows.html)
* Upgrading Puppet from 3.x
  * [Upgrading Puppet 3.x Agents](/puppet/latest/upgrade_agent.html)
  * [Upgrading Puppet 3.x Servers](/puppet/latest/upgrade_server.html)

### Previous install guides

* [The Puppet 3.8 installation guide](puppet/3.8/pre_install.html)

### Building and using modules

* [Module fundamentals](/puppet/latest/modules_fundamentals.html) --- Nearly all of your Puppet code should be in modules.
* [Installing modules from the Puppet Forge](/puppet/latest/modules_installing.html) --- Save time by using pre-existing modules.
* [Publishing modules on the Puppet Forge](/puppet/latest/modules_publishing.html) --- Preparing your best modules to go public.
* [Developing modules with the Puppet Development Kit](/pdk/latest/pdk.html)

### Help with writing Puppet code

* [Style guide](/guides/style_guide.html) --- Puppet Language community conventions.

### Using optional features

* [Puppet file serving](/puppet/latest/file_serving.html) --- Files in modules are automatically served; this explains how to configure additional custom mount points for serving large files that shouldn't be kept in modules.

### Puppet on Windows

With a *nix based Puppet master, you can manage Windows nodes side by side with your \*nix infrastructure or run Puppet masterless on Windows.

* [Installing Puppet 5 for Windows](/puppet/latest/install_windows.html)
* [Basic tasks and concepts in Windows](/pe/latest/windows_basic_tasks.html)
* [Troubleshooting Puppet on Windows](/pe/latest/troubleshooting_windows.html)

### Tuning and scaling

Puppet's default configuration is meant for prototyping and designing a site. Once you're ready for production deployment, learn how to adjust Puppet for peak performance.

* [Running a Production-Grade Puppet Master Server With Passenger](/puppet/latest/passenger.html) --- This should be one of your earliest steps in scaling out Puppet.
* [Using Multiple Puppet Masters](/guides/scaling_multiple_masters.html) --- A guide to deployments with multiple Puppet masters.


### Hacking and extending: APIs and interfaces

* [External Nodes](/guides/external_nodes.html) --- Specify what your machines do using external data sources.
    * [LDAP Nodes](/guides/ldap_nodes.html) --- A special-case tool for keeping node information in your LDAP directory.

### Hacking and extending: Ruby plugins

* [Plugins in modules](/puppet/latest/reference/plugins_in_modules.html) --- Where to put plugins, and how to sync them to clients.
* [Writing custom facts](/facter/latest/custom_facts.html)
* [Writing custom functions](/guides/custom_functions.html)
* [Writing custom types & providers](/guides/custom_types.html)
* [Complete resource example](/puppet/latest/complete_resource_example.html) --- More information on custom types & providers
* [Provider development](/guides/provider_development.html) --- More about providers.


* * *

## Other resources

* [Puppet project ticket tracker](https://tickets.puppetlabs.com/browse/PUP)
