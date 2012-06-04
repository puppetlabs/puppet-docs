---
layout: legacy
title: "Baseline Plugin: Index"
---

Puppet Dashboard Baseline Plugin Manual
=====

<span style="font-size: 2em; font-weight: bold; color: red; background-color: #ff9;">This documentation does not refer to a released product.</span> 

<span style="background-color: #ff9;">For documentation of the compliance features released in Puppet Enterprise 1.2, please see [the Puppet Enterprise manual](/pe/).</span>

The `puppet_baseline` plugin for Puppet Dashboard uses Puppet to implement an alternate audit-based workflow for change management. This manual describes its installation, configuration, and use. 

Working with compliance features requires a puppet master server running Puppet 2.6.5 or later, as well as a Puppet Dashboard 1.2 server with the baseline compliance plugin installed and filebucket access configured. 

**This documentation relates to a commercial add-on that is not publicly available at this time.** Baseline compliance functionality will be available in a future version of Puppet Enterprise. 

Chapters
--------

* [Introduction and Workflow](./pb_workflow.html)
* [Bootstrapping](./pb_bootstrapping.html)
* [Interface](./pb_interface.html)
* [Internals](./pb_internals.html)
