---
layout: default
title: "Deprecated extension points and APIs"
---

These APIs and extension points are deprecated, and will be removed in future releases.

{:.section}
## Puppet Faces is a private API

The `Puppet::Face` and `Puppet::Indirector::Face` classes are private APIs, and we don't document or support them. Don't use them. Instead, to develop command line applications that use Puppet's data:

* Pick a popular, well-maintained Ruby framework for CLI apps, such as Thor or Commander.
* Use Puppet's public Ruby APIs to access its settings and data. See the [developer documentation](./yard/frames.html) for information about the classes and methods available for this.
* Distribute your application as a Gem or native package, instead of as a Puppet module.
* To make your command available as a `puppet <NAME>`-style subcommand, name it `puppet-<NAME>` and put it in your `$PATH`. When you call it, you can leave out the hyphen.

{:.section}
## Resource type and provider APIs

As of Puppet 5.0, the [`resource_types` API endpoint](./http_api/http_resource_type.html) has been removed. Instead, use Puppet Server's [`environment_classes` endpoint]({{puppetserver}}/puppet-api/v3/environment_classes.html).

The `Puppet.newtype` method on the top-level `Puppet` module is a proxy for `Puppet::Type.newtype`. The `Puppet.newtype` method will be removed in a future release. Update any custom resource types to use `Puppet::Type.newtype` instead.

{:.section}
## Miscellaneous APIs

The `Puppet::Node::Facts#strip_internal` method has been removed as of Puppet 5.0.

Previously, the `stacktrace` property in HTTP error responses was always empty for security reasons. In Puppet 5, we've removed the `stacktrace` property as it serves no purpose.