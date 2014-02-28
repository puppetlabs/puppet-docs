---
layout: default
title: "Experimental Features: The Data Binder"
canonical: "/puppet/latest/reference/experiments_binder.html"
---

[binder_arm]: https://github.com/puppetlabs/armatures/blob/master/arm-9.data_in_modules/index.md
[future]: ./experiments_future.html

> **Warning:** This document describes an **experimental feature,** which is not officially supported and is not considered ready for production. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise.

> **Status:** The redesigned data binder is available in Puppet 3.3.0 and later.
>
> Based on the feedback from users so far, we've decided that the current design for the data binder is a dead end. We do _not_ plan to enable the functionality you can test today in a future Puppet release. However, we are still researching and investigating more more powerful ways to look up and interact with data in Puppet, and the lessons we learned from the current implementation will inform future efforts.
>
> Currently, we recommend _against_ enabling the data binder in a production deployment. As of Puppet 3.4, it still carries a massive performance penalty in catalog compilation (as it requires the [future parser][future]); additionally, it adds significant complexity to your configuration using a _very_ non-final user interface.


Enabling the Data Binder
-----

To enable the data binder:

* Make sure you are using Puppet 3.3.0 or later.
* On your puppet master(s), [follow the instructions for enabling the future parser][future].
* On your puppet master(s), set `binder = true` in the `[master]` or `[main]` block of puppet.conf.


Using the Data Binder
-----

To experiment with the data binder, you will need to [follow the examples available in the "ARM-9" feature proposal][binder_arm].

The [feature proposal][binder_arm] is the only documentation available for the redesigned data binder. Since we've deemed the current interface a dead end, we do not plan to invest in more user-centric documentation.
