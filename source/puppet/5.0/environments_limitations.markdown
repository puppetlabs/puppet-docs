---
layout: default
title: "Environments: Limitations of environments"
---

[env_var]: ./environments.html#referencing-the-environment-in-manifests

Environments solve a lot of problems in a convenient way, but they still have some limitations. Some of these are just features Puppet doesn't have yet, and some of them are outside Puppet's control. We want to fix all of them, but some will take a lot longer than others.

## Some plugins running on the Puppet master are weird

Puppet modules can contain Puppet code, templates, file sources, and Ruby plugin code (in the `lib` directory). Most of these work fine in environments, but plugins can be subject to an *environment leakage* problem.

This problem occurs when different versions of Ruby files, such as resource types, exist in multiple environments. When these files are loaded, the first version loaded is treated as global, so subsequent requests in other environments get that first loaded version. You can learn more about this problem in the [environment isolation](./environment_isolation.html#preventing-resource-types-leaks-in-multiple-environments) page.

This environment leakage issue does not affect the agent, as agents are only in one environment at any given time.

* For **resource types**, you can avoid environment leaks with the the `puppet generate types` command as described in [environment isolation](./environment_isolation.html#enable-environment-isolation-in-open-source-puppet) documentation. This command generates resource type metadata files to ensure that each environment uses the right version of each type.
* For **functions**, this issue occurs only with the legacy `Puppet::Parser::Functions` API. To fix this, rewrite functions with [the modern functions API](./functions_ruby_overview.html), which is not affected by environment leakage. You can include helper code in the function definition, but if helper code is more complex, it should be packaged as a gem and installed for all environments.
* Report processors and indirector termini are still affected by this problem, and they should probably be in your global Ruby directories rather than in your environments. If they are in your environments, you must ensure they all have the same content.

## For best performance, you might have to change your deploy process

[configuring_timeout]: ./environments_configuring.html#environmenttimeout

The default value of [the `environment_timeout` setting][configuring_timeout] has to be `0`, because anything else risks frustrating new users. The only problem with that value is that it wastes a lot of effort on your Puppet master.

For best performance, you should set `environment_timeout = unlimited`, but this requires a change to your code deployment process, because you'll need to refresh the Puppet master to make it notice the new code.

For more info, see [the timeout section of the Configuring Environments page.][configuring_timeout]

## Exported resources can conflict or cross over

Nodes in one environment can accidentally collect resources that were exported from another environment, which causes problems --- either a compilation error due to identically titled resources, or creation and management of unintended resources.

Right now, the only solution is to run multiple Puppet masters if you heavily use exported resources. We're working on making PuppetDB environment-aware, which will fix the problem in a more permanent way.


