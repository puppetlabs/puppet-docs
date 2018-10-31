---
layout: default
title: "Environments: Limitations of Environments"
canonical: "/puppet/latest/reference/environments_limitations.html"
---

[env_var]: ./environments.html#referencing-the-environment-in-manifests

Environments solve a lot of problems in a convenient way, but they still have some limitations. Some of these are just features Puppet doesn't have yet, and some of them are outside Puppet's control. We want to fix all of them, but some may take a lot longer than others.

## Plugins Running on the Puppet Master are Weird

Puppet modules can contain Puppet code, templates, file sources, and Ruby plugin code (in the `lib` directory). Environments work perfectly with most of those, but there's a lingering problem with plugins.

The short version is: any plugins destined for the _agent node_ (e.g. custom facts and custom resource providers) will work fine, but plugins to be used by the _Puppet master_ (functions, resource types, report processers, indirector termini) can get mixed up, and you won't be able to control which version the Puppet master is using. So if you need to do testing while developing custom resource types or functions, you may need to spin up a second Puppet master, since environments won't be reliable.

This has to do with the way Ruby loads code, and we're not sure if it can be fixed given Puppet's current architecture. (Some of us think this would require separate Ruby Puppet master processes for each environment, which isn't currently practical with the way Rack manages Puppet.)

If you're interested in the issue, it's being tracked as [PUP-731](https://tickets.puppetlabs.com/browse/PUP-731).

## For Best Performance, You Might Have to Change Your Deploy Process

[configuring_timeout]: ./environments_configuring.html#environmenttimeout

The default value of [the `environment_timeout` setting][configuring_timeout] has to be `0`, because anything else risks frustrating new users. The only problem with that value is that it wastes a lot of effort on your Puppet master.

For best performance, you should set `environment_timeout = unlimited`, but this requires a change to your code deployment process, because you'll need to refresh the Puppet master to make it notice the new code.

For more info, see [the timeout section of the Configuring Environments page.][configuring_timeout]

## Hiera Configuration Can't be Specified Per Environment

Puppet will only use a global [hiera.yaml](./config_file_hiera.html) file; you can't put per-environment configs in an environment directory.

When using the built-in YAML or JSON backends, it _is_ possible to separate your Hiera data per environment; you will need to interpolate [the `$environment` variable][env_var] into [the `:datadir` setting.]({{hiera}}/configuring.html#yaml-and-json) (e.g. `:datadir: /etc/puppet/environments/%{::environment}/hieradata`)

## Exported Resources Can Conflict or Cross Over

Nodes in one environment can accidentally collect resources that were exported from another environment, which causes problems --- either a compilation error due to identically titled resources, or creation and management of unintended resources.

Right now, the only solution is to run multiple Puppet masters if you heavily use exported resources. We're working on making PuppetDB environment-aware, which will fix the problem in a more permanent way.


