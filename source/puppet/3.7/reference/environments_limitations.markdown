---
layout: default
title: "Environments: Limitations of Environments"
canonical: "/puppet/latest/reference/environments_limitations.html"
---

[env_var]: ./environments.html#referencing-the-environment-in-manifests

Environments solve a lot of problems in a convenient way, but they still have some limitations. Some of these are just features Puppet doesn't have yet, and some of them are outside Puppet's control. We want to fix all of them, but some may take a lot longer than others.

## Plugins Running on the Puppet Master are Weird

Puppet modules can contain Puppet code, templates, file sources, and Ruby plugin code (in the `lib` directory). Environments work perfectly with most of those, but there's a lingering problem with plugins.

The short version is: any plugins destined for the _agent node_ (e.g. custom facts and custom resource providers) will work fine, but plugins to be used by the _puppet master_ (functions, resource types, report processers, indirector termini) can get mixed up, and you won't be able to control which version the puppet master is using. So if you need to do testing while developing custom resource types or functions, you may need to spin up a second puppet master, since environments won't be reliable.

This has to do with the way Ruby loads code, and we're not sure if it can be fixed given Puppet's current architecture. (Some of us think this would require separate Ruby puppet master processes for each environment, which isn't currently practical with the way Rack manages Puppet.)

If you're interested in the issue, it's being tracked as [PUP-731](https://tickets.puppetlabs.com/browse/PUP-731).

## Changing an Environment With a Long Timeout Requires a Service Restart

The Puppet master loads an environment's data the first time it gets a request for that environment, then caches that data. Cached environments will time out and be discarded after a while, after which they'll be loaded on request again.

This sounds simple, but in practice it's complicated, because your Puppet master service usually runs multiple Ruby interpreters to handle parallel requests. (Puppet Server uses multiple JRuby interpreters, and Apache with Passenger uses multiple MRI Ruby processes.)

In short, it goes like this:

* Each Ruby interpreter keeps its own separate timeout counter for each environment. Each of these timers starts at a different time, since environments load on demand.
* When you change an environment's files, the interpreter whose timeout counter started first will get the updated files before the others. So there's a period where some interpreters have new manifests and others still have the stale ones cached.
* When an agent makes a catalog request, there's no way to predict which interpreter will respond to it. (Puppet Server is more unpredictable than Passenger, since it distributes work more evenly among its interpreters.)
* So if an agent checks in twice during the interval of potential inconsistency, it might churn back and forth between the stale and new versions of its environment.
* Currently, the only way to make every interpreter drop its environment cache is to restart the Puppet master service.

Thus: whenever you change any environment whose timeout is more than a few minutes, you should restart your Puppet master service, especially if you're running Puppet Server. (Note that Puppet Enterprise 3.7 uses Puppet Server.)

For a future version of Puppet Server, we're working on a faster way to signal that code has changed. See [SERVER-92](https://tickets.puppetlabs.com/browse/SERVER-92) and its associated tickets for more info.


## Hiera Configuration Can't be Specified Per Environment

Puppet will only use a global [hiera.yaml](./config_file_hiera.html) file; you can't put per-environment configs in an environment directory.

When using the built-in YAML or JSON backends, it _is_ possible to separate your Hiera data per environment; you will need to interpolate [the `$environment` variable][env_var] into [the `:datadir` setting.](/hiera/latest/configuring.html#yaml-and-json) (e.g. `:datadir: /etc/puppet/environments/%{::environment}/hieradata`)

## Exported Resources Can Conflict or Cross Over

Nodes in one environment can accidentally collect resources that were exported from another environment, which causes problems --- either a compilation error due to identically titled resources, or creation and management of unintended resources.

Right now, the only solution is to run multiple puppet masters if you heavily use exported resources. We're working on making PuppetDB environment-aware, which will fix the problem in a more permanent way.


