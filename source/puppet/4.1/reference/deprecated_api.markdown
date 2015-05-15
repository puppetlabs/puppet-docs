---
layout: default
title: "Deprecated Extension Points and APIs"
---


The following APIs and extension points are deprecated, and will be removed in Puppet 5.0.


Resource Type and Provider APIs
-----


### `Puppet.newtype`

This method on the top-level `Puppet` module was just a proxy for `Puppet::Type.newtype`. It will be removed in Puppet 5.0. Update any custom resource types to use `Puppet::Type.newtype` instead.


Miscellaneous APIs
-----


### `Puppet::Node::Facts#strip_internal`

This method currently does nothing, and will be removed in Puppet 5.0.

