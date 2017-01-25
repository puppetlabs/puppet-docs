---
layout: default
title: "Environments: Limitations of environments"
canonical: "/puppet/latest/reference/environments_limitations.html"
---

[env_var]: ./environments.html#referencing-the-environment-in-manifests

Environments solve a lot of problems in a convenient way, but they still have some limitations. Some of these are just features Puppet doesn't have yet, and some of them are outside Puppet's control. We want to fix all of them, but some may take a lot longer than others.

## Some plugins running on the Puppet master are weird

Puppet modules can contain Puppet code, templates, file sources, and Ruby plugin code (in the `lib` directory). Environments work perfectly with most of those, but some plugins do not.

Plugins used by the Puppet master (resource types, report processors, indirector termini) can get mixed up, so that the Puppet master is using the wrong versions of plugins. This issue occurs because of the way Ruby loads code. This environment leakage issue does not affect the agent.

* For **resource types**, you can avoid environment leaks with the the `puppet generate types` command as described in [environment isolation](./environment_isolation.html) documentation.
* For **functions**, this issue occurs only with the legacy `Puppet::Parser::Functions` API. To fix this, rewrite functions with the modern API, which is not affected by environment leakage.
* Report processors and indirector termini are still affected by this problem, and they should probably be in your global Ruby directories rather than in your environments.

## For best performance, you might have to change your deploy process

[configuring_timeout]: ./environments_configuring.html#environmenttimeout

The default value of [the `environment_timeout` setting][configuring_timeout] has to be `0`, because anything else risks frustrating new users. The only problem with that value is that it wastes a lot of effort on your Puppet master.

For best performance, you should set `environment_timeout = unlimited`, but this requires a change to your code deployment process, because you'll need to refresh the Puppet master to make it notice the new code.

For more info, see [the timeout section of the Configuring Environments page.][configuring_timeout]

## Hiera configuration can't be specified per environment

Puppet will only use a global [hiera.yaml](./config_file_hiera.html) file; you can't put per-environment configs in an environment directory.

When using the built-in YAML or JSON backends, it _is_ possible to separate your Hiera data per environment; you will need to interpolate [the `$environment` variable][env_var] into [the `:datadir` setting.]({{hiera}}/configuring.html#yaml-and-json) (e.g. `:datadir: /etc/puppetlabs/code/environments/%{::environment}/hieradata`)

## Exported resources can conflict or cross over

Nodes in one environment can accidentally collect resources that were exported from another environment, which causes problems --- either a compilation error due to identically titled resources, or creation and management of unintended resources.

Right now, the only solution is to run multiple Puppet masters if you heavily use exported resources. We're working on making PuppetDB environment-aware, which will fix the problem in a more permanent way.


