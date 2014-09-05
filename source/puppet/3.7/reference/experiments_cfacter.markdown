---
layout: default
title: "Experimental Features: Native Facter"
canonical: "/puppet/latest/reference/experiments_cfacter.html"
---

[users_group]: https://groups.google.com/forum/#!forum/puppet-users

> **Warning:** This document describes an **experimental feature,** which is not officially supported and is not considered ready for production. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise.

Native Facter is a complete rebuild of Facter in C++ instead of Ruby. Native Facter does the same job that Facter does, but with better performance.

> **Status:** In Puppet 3.7, Native Facter is experimental: acceptance testing has been minimal, and we don’t recommend using it in a production environment. 

Requirements
-----

Native Facter 0.2.0 is supported on OSX and Linux. We plan to support Windows and Solaris in a future build.

Installing Native Facter
-----
We don't yet have packages available for Native Facter, so to try it out, you'll need to build the package and then install it. The project's [readme](https://github.com/puppetlabs/cfacter#native-facter) has the most current information about packaging and installation for various systems.

Enabling Native Facter
-----

To enable Native Facter, set `cfacter = true` in the main section of puppet.conf on each of your agent nodes.

Alternately, for one-off tests, you can set `--cfacter` on the command line when running `puppet apply` or `puppet agent --test`.

Native Facter Works Like Facter
-----

We've implemented as much of Facter 2.0 functionality as possible. Native Facter supports all core facts as well as external facts and Ruby custom facts.

### Unsupported Features

For custom facts, the `timeout` property is unsupported. The option is ignored, and fact resolution is not scoped to a particular time limit. Setting this property causes an error.
