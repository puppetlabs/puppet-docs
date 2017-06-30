---
layout: default
title: "Deprecated Language Features"
---


The following features of the Puppet language are deprecated, and will be removed in Puppet 5.0.


## Non-Strict Variables

#### Now

By default, you can access the value of a variable that was never assigned. The value of an unassigned variable is `undef`.

If you set the `strict_variables` setting to true, Puppet will instead raise an error if you try to access an unassigned variable.

#### Detecting and Updating

Enable `strict_variables` on your Puppet master, run as normal for a while, and look for compilation errors.

