---
layout: default
title: "Experimental Features: Native Facter"
canonical: "/puppet/latest/reference/experiments_cfacter.html"
---

[users_group]: https://groups.google.com/forum/#!forum/puppet-users
[cfacter_readme]: https://github.com/puppetlabs/facter/blob/master/README.md
[cfacter_features]: https://github.com/puppetlabs/facter/blob/master/Extensibility.md

> **Warning:** This document describes an **experimental feature,** which is not officially supported. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise. Acceptance testing for Native Facter has been minimal, and we do not recommend using it in a production environment.

Native Facter is a rewrite of Facter in C++. Native Facter does the same job that Facter does, but with better performance.

Requirements
-----

Native Facter 0.2.0 supports OSX and Linux; Native Facter 0.3.0 will support Windows and Solaris as well.

Installing Native Facter
-----

We don't yet have release packages for Native Facter, but we do have nightly builds available. The project's [README][cfacter_readme] has the most current information about packaging and installation for various systems.

Enabling Native Facter
-----

To enable Native Facter, set `cfacter = true` in the main section of puppet.conf on each of your agent nodes.

Alternately, for one-off tests, you can set `--cfacter` on the command line when running `puppet apply` or `puppet agent --test`.

Native Facter Works Like Facter
-----

We've implemented as much of Facter 2.2 functionality as possible. Native Facter supports all core facts as well as external facts and Ruby custom facts. The [Native Facter extensibility features][cfacter_features] page contains the latest feature information.

### Unsupported Features

For custom facts, the `timeout` property is unsupported. The option is ignored, and fact resolution is not scoped to a particular time limit. Setting this property causes an error.
