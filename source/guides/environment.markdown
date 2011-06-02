---
layout: default
title: Environments
---

Environments
============

Manage your module releases by dividing your site into environments.

* * *

[config]: ./configuring.html
[auth]: ./rest_auth_conf.html

Slice and Dice
--------------

Puppet lets you slice your site up into an arbitrary number of "environments" and serve a different set of modules to each one. This is usually used to manage releases of Puppet modules by testing them against scratch nodes before rolling them out completely, but it introduces a lot of other possibilities, like separating a DMZ environment, splitting coding duties among multiple sysadmins, or dividing the site by hardware type. 

What an Environment Is
----------------------

Every agent node has an environment, and the puppet master gets informed about it whenever that node makes a request. (If you don't specify an environment, the agent has the default "production" environment.) 

The puppet master can then use that environment several ways: 

* If the master's [`puppet.conf`][config] file has a `[config block]` for this agent's environment, those settings will override the master's normal settings when serving that agent. 
* If the values of any settings in `puppet.conf` reference the `$environment` variable (like `modulepath = $confdir/environments/$environment/modules:$confdir/modules`, for example), the agent's environment will be interpolated into them.
* Depending on how [`auth.conf`][auth] is configured, different requests might be allowed or denied. 
* The agent's environment will also be accessible in Puppet manifests as the top-scope `$environment` variable. 

In short: modules and manifests can already do different things for different nodes, but environments let the master tweak its own configuration on the fly, and offer a way to completely swap out the set of available modules for certain nodes. 

Caveats
-------

Before you start, be aware that environments have some limitations, most of which are known bugs or vagaries of implementation rather than design choices.

* Puppet will only read the [`modulepath`](/references/stable/configuration.html#modulepath), [`manifest`](/references/stable/configuration.html#manifest), [`manifestdir`](/references/stable/configuration.html#manifestdir), and [`templatedir`](/references/stable/configuration.html#templatedir) settings from environment config blocks; other settings in any of these blocks will be ignored in favor of settings in the `[master]` or `[main]` blocks. ([Issue 7497](http://projects.puppetlabs.com/issues/7497))
* File serving only works well with environments if you're only serving files from modules; if you've set up custom mount points in `fileserver.conf`, they won't work in your custom environments. (Though hopefully you're only serving files from modules regardless.)
* You can set an agent node's environment from an external node classifier like Puppet Dashboard, but it isn't well-supported: currently, the server-set environment will win during catalog compilation, but the client-set environment will win when downloading files. ([Issue 3910](http://projects.puppetlabs.com/issues/3910))
* Serving custom types and providers from an environment-specific modulepath sometimes fails. ([Issue 4409](http://projects.puppetlabs.com/issues/4409))

Configuring Environments on the Puppet Master
---------------------------------------------

### In `puppet.conf`

As mentioned above, `puppet.conf` lets you use `$environment` as a variable and create config blocks for environments.

    # /etc/puppet/puppet.conf
    [master]
      modulepath = $confdir/environments/$environment/modules:$confdir/modules
      manifest = $confdir/manifests/unknown_environment.pp
    [production]
      manifest = $confdir/manifests/site.pp
    [dev]
      manifest = $confdir/manifests/site.pp

In the `[master]` block, this example dynamically sets the modulepath so Puppet will check a per-environment folder for a module before serving it from the main set. Note that this won't complain about missing directories, so you can create the per-environment folders lazily as you need them. 

The example also logs errors when a non-existent environment is requested by redirecting to a different site manifest; this can keep typos or forgetfulness from silently causing odd configurations. 

### In `auth.conf`

    path /
    auth any
    environment appdev
    allow localhost, customapp.puppetlabs.lan

If you specify an environment in an `auth.conf` ACL, it will only apply to requests in that environment. This can be useful for developing new applications that integrate with Puppet; the example above will leave normal requests functioning normally, but allow an app server to access everything via the REST API. 

### In Manifests

The `$environment` variable should only rarely be necessary, but it's there if you need it. 

Configuring Environments for Agent Nodes
----------------------------------------

To set an environment agent-side, just specify the `environment` setting in either the `[agent]` or `[main]` block of `puppet.conf`. 

    [agent]
      environment = dev

As with any config setting, you can also use a command line option: 

    # puppet agent --environment dev

You can also set an environment via your ENC by including an `environment: dev` (or similar) line in the yaml file, but see the caveat above before doing this. 

Eventually, server-side environments will work properly, but if you need to work around this today, you can do so by managing puppet.conf on agent nodes with a [template](./templating.html). This can take multiple runs to reach the desired configuration for the first time, but it will work. 

Compatibility Notes
-------------------

Environments were introduced in Puppet 0.24.0.
