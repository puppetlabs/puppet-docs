---
layout: default
title: "PE 3.0 » Puppet » Modules and Manifests"
subtitle: "Puppet Modules and Manifests"
---


Puppet configures nodes by reading and applying **manifests** written by sysadmins. Manifests contain **classes,** which are chunks of code that configure a specific aspect or feature of a machine.

One or more classes can be stored in a **module,** which is a self-contained bundle of Puppet code. Pre-existing modules can be downloaded from the [Puppet Forge](http://forge.puppetlabs.com), and most users use a combination of pre-built modules and modules they wrote themselves.

A Fast Introduction to Using Modules
-----

This user's guide includes a pair of interactive quick start guides, which walk you through installing, using, hacking, and creating Puppet modules.

* [Quick Start: Using PE](./quick_start.html)
* [Quick Start: Writing Modules](./quick_writing.html)

A More Detailed Introduction to Using Modules
-----

The Puppet Enterprise Deployment Guide includes detailed walkthroughs of how to choose modules and compose them into complete configurations.

* [Deployment Guide ch. 3: Automating Your Infrastructure](/guides/deployment_guide/dg_define_infrastructure.html)

A Leisurely Introduction to Writing Puppet Code
-----

For a more complete introduction to Puppet resources, manifests, classes, modules, defined types, facts, variables, and more, read the Learning Puppet series.

* [Learning Puppet](/learning/)

Detailed Documentation
-----

The Puppet reference manual contains more information about using modules and the Puppet language.

* [Installing and Managing Modules](/puppet/3/reference/modules_installing.html)
* [Module Fundamentals](/puppet/3/reference/modules_fundamentals.html)
* [The Puppet Language Reference](/puppet/3/reference/lang_summary.html)

Printable References
-----

These two cheat sheets are useful when writing your own modules or hacking existing modules.

* [Module Layout Cheat Sheet](/module_cheat_sheet.pdf)
* [Core Resource Type Cheat Sheet](/puppet_core_types_cheatsheet.pdf)

* * *

- [Next: Puppet Data Library](./puppet_data_library.html)