---
layout: default
title: "Deprecated Extension Points and APIs"
---


The following APIs and extension points are deprecated, and will be removed in Puppet 5.0.

## Puppet Faces is a private API

(This isn't actually a deprecation, since we don't have a specific plan to remove the Faces APIs. But we needed a place to mention this on the record, and this section seems like the best long-term bet.)

The `Puppet::Face` and `Puppet::Indirector::Face` classes are private APIs, and we won't be documenting or supporting them. Please don't use them. If you want to develop CLI applications that use Puppet's data, you should:

* Pick a popular, well-maintained Ruby framework for CLI apps, like Thor or Commander.
* Use Puppet's public Ruby APIs to access its settings and data. See the [developer documentation](./yard/frames.html) for comprehensive info about the classes and methods available for this.
* Distribute your application as a Gem or native package, not as a Puppet module.
* If you _really_ want your command to be available as a `puppet <NAME>`-style subcommand, you can name it `puppet-<NAME>` and make sure it's in your `$PATH` --- there's a secret feature that lets you leave out the hyphen.

## Resource type and provider APIs

### `Puppet.newtype`

This method on the top-level `Puppet` module was just a proxy for `Puppet::Type.newtype`. It will be removed in Puppet 5.0. Update any custom resource types to use `Puppet::Type.newtype` instead.


## Miscellaneous APIs

### `Puppet::Node::Facts#strip_internal`

This method currently does nothing, and will be removed in Puppet 5.0.

