---
layout: default
title: Environments
canonical: "/puppet/latest/reference/environments.html"
---

Environments
============

Manage your module releases by dividing your site into environments.

* * *

[config]: ./configuring.html
[auth]: ./rest_auth_conf.html
[enc]: ./external_nodes.html

Slice and Dice
--------------

Puppet lets you slice your site up into an arbitrary number of "environments" and serve a different set of modules to each one. This is usually used to manage releases of Puppet modules by testing them against scratch nodes before rolling them out completely, but it introduces a lot of other possibilities, like separating a DMZ environment, splitting coding duties among multiple sysadmins, or dividing the site by hardware type.

What an Environment Is
----------------------

Every agent node is configured to have an environment, which is simply a short label specified in puppet.conf's [`environment` setting](/references/latest/configuration.html#environment). Whenever that node makes a request, the puppet master gets informed of its environment. (If you don't specify an environment, the agent has the default "production" environment.)

The puppet master can then use that environment several ways:

* If the master's [`puppet.conf`][config] file has a `[config block]` for this agent's environment, those settings will override the master's normal settings when serving that agent.
* If the values of any settings in `puppet.conf` reference the `$environment` variable (like `modulepath = $confdir/environments/$environment/modules:$confdir/modules`, for example), the agent's environment will be interpolated into them.
* Depending on how [`auth.conf`][auth] is configured, different requests might be allowed or denied.
* The agent's environment will also be accessible in Puppet manifests as the top-scope `$environment` variable.

In short: **environments let the master tweak its own configuration on the fly, and offer a way to completely swap out the set of available modules for certain nodes.**

Naming Environments
-----

Environment names should only contain alphanumeric characters and underscores, and are case-sensitive.

There are four forbidden environment names:

* `main`
* `master`
* `agent`
* `user`

These names are already taken by the primary [config blocks](./configuring.html#config-blocks). If you are using Git branches for your environment names, this may mean you'll need to rename the master branch to something like `production` or `stable`.

Caveats
-------

Before you start, be aware that environments have some limitations, most of which are known bugs or vagaries of implementation rather than design choices.

* Puppet will only read the [`modulepath`](/references/stable/configuration.html#modulepath), [`manifest`](/references/stable/configuration.html#manifest), [`manifestdir`](/references/stable/configuration.html#manifestdir), and [`templatedir`](/references/stable/configuration.html#templatedir) settings from environment config blocks; other settings in any of these blocks will be ignored in favor of settings in the `[master]` or `[main]` blocks. ([Issue 7497](http://projects.puppetlabs.com/issues/7497))
* File serving only works well with environments if you're only serving files from modules; if you've set up custom mount points in `fileserver.conf`, they won't work in your custom environments. (Though hopefully you're only serving files from modules anyway.)
* Prior to Puppet 3, environments set by [external node classifiers][enc] were not authoritative. If you are using Puppet 2.7 or earlier, you must set the environment in the agent node's config file.
* Serving custom ruby code via pluginsync, including custom types, providers, facts and functions is not currently functional on a per-environment basis. You can still use custom ruby code to to extend puppet, but it should be identical for all environments. Non-identical custom code across modules can result in unpredictable behavior. See the following open issues for more information:
    * [Issue 4409](http://projects.puppetlabs.com/issues/4409)
    * [Issue 12173](http://projects.puppetlabs.com/issues/12173)
    * [Issue 17210](http://projects.puppetlabs.com/issues/17210)

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

The example also redirects requests for a non-existent environment to a different site manifest, which will log an error and fail compilation; this can keep typos or forgetfulness from silently causing odd configurations.

### In `auth.conf`

    path /
    auth true
    environment appdev
    allow localhost, customapp.example.com

If you specify an environment in an [`auth.conf`][auth] ACL, it will only apply to requests in that environment. This can be useful for developing new applications that integrate with Puppet; the example above will leave normal requests functioning normally, but allow an app server to access everything via the HTTP API.

### In Manifests

The `$environment` variable should only rarely be necessary, but it's there if you need it.

Configuring Environments for Agent Nodes
----------------------------------------

### In an ENC

Your [external node classifier][enc] can set an environment for a node by setting a value for the `environment` key. In Puppet 3 and later, the environment set by the ENC will **override** the environment from the agent node's config file. If no environment is provided by the ENC, the value from the node's config file will be used.

> **Note:** In Puppet 2.7 and earlier, ENC-set environments are not authoritative, and using them results in nodes using a mixture of two environments --- the ENC environment wins during compilation, and the agent environment wins during file downloads. If you need to centrally control your nodes environments, you should upgrade to Puppet 3 as soon as is practical.
>
> As a temporary workaround, you can manage nodes' puppet.conf files with a template and set the environment based on the ENC's value; this will allow nodes to use a consistent environment on their second (and subsequent) Puppet runs.

> **Note:** If your puppet master is running Puppet 3 but was once running Puppet 2.6, its [auth.conf file][auth] may be missing a rule required for ENC environments. Ensure that the following rule exists somewhere near the top of your auth.conf file:
>
>     # allow nodes to retrieve their own node definition
>     path ~ ^/node/([^/]+)$
>     method find
>     allow $1
>
> Puppet masters which have only run 2.7 and later should already have this rule in their auth.conf files.

### On the Agent Node

To set an environment agent-side, just specify the `environment` setting in either the `[agent]` or `[main]` block of `puppet.conf`.

    [agent]
      environment = dev

Note that in Puppet 3 and later, this value will only be used if the ENC does not override it.

As with any config setting, you can also temporarily set it with a command line option:

    # puppet agent --environment dev


Compatibility Notes
-------------------

Environments were introduced in Puppet 0.24.0.
