---
layout: default
title: "Experimental Features: Native Facter"
canonical: "/puppet/latest/experiments_cfacter.html"
---

[users_group]: https://groups.google.com/forum/#!forum/puppet-users
[cfacter_readme]: https://github.com/puppetlabs/facter/blob/master/README.md
[cfacter_features]: https://github.com/puppetlabs/facter/blob/master/Extensibility.md

> **Warning:** This document describes an **experimental feature,** which is not officially supported. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise. Acceptance testing for Native Facter has been minimal, and we do not recommend using it in a production environment.

Native Facter is a rewrite of Facter in C++. Native Facter does the same job that Facter does, but with better performance.

Native Facter is scheduled to be officially released around the same time as Puppet 4.2. Once released, it will be known as Facter 3.0.

Requirements
-----

Native Facter supports Linux, Windows, Mac OS X, and Solaris. It is installed automatically as part of the `puppet-agent` package.

Enabling Native Facter
-----

To enable Native Facter, set `cfacter = true` in the main section of puppet.conf on each of your agent nodes.

Alternately, for one-off tests, you can set `--cfacter` on the command line when running `puppet apply` or `puppet agent --test`.

Native Facter Works Like Facter
-----

We've implemented as much of Facter 2.x functionality as possible. Native Facter supports all core facts as well as external facts and Ruby custom facts. The [Native Facter extensibility features][cfacter_features] page contains the latest feature information.

### Unsupported Features

For custom facts, the `timeout` property is unsupported. The option is ignored, and fact resolution is not scoped to a particular time limit. Setting this property causes an error.
