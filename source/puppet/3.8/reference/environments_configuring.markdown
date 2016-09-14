---
layout: default
title: "Configuring Directory Environments"
---

[environmentpath]: ./configuration.html#environmentpath
[confdir]: ./dirs_confdir.html
[puppet.conf]: ./config_file_main.html
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: ./configuration.html#basemodulepath
[environment.conf]: ./config_file_environment.html
[environment_timeout]: ./configuration.html#environmenttimeout
[create_environment]: ./environments_creating.html
[about]: ./environments.html
[assign]: ./environments_assigning.html
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[main manifest]: ./dirs_manifest.html


Before you can use directory environments, you have to configure Puppet to enable them.

For performance reasons, many users will also want to [set `environment_timeout` to `unlimited`][inpage_timeout] and refresh the Puppet master when deploying code.

After enabling environments, you can:

* [Create environments][create_environment]
* [Assign environments to your nodes][assign]

For more info about what environments do, see [About Directory Environments.][about]

Enabling Directory Environments in Puppet Enterprise
-----

Directory environments are enabled by default in PE 3.7. If you are using an earlier version of PE, you will need to [enable them](/puppet/3.6/reference/environments_configuring.html#enabling-directory-environments-in-puppet-enterprise).

Enabling Directory Environments in Open Source Puppet
-----

Directory environments are disabled by default. To enable them, you must:

* Edit the config file
* Create at least one directory environment

### Edit puppet.conf

To enable directory environments, set `environmentpath = $confdir/environments` (or [the value of your choice][inpage_environmentpath]) in the Puppet master's [puppet.conf][] (in the `[main]` or `[master]` section).

Optionally, you can also:

* Use the `basemodulepath` setting to specify global modules that should be available in all environments. Most people are fine with the default value.
* Use the `default_manifest` setting to either change the default per-environment manifest or set a global manifest to be used by all environments.

See the section below about settings for more details.

Once you edit puppet.conf, directory environments will be enabled and config file environments will be disabled.

### Create a Directory Environment

You must have a directory environment for **every** environment that **any** nodes are assigned to. At minimum, you should have a `production` environment. Nodes assigned to nonexistent environments cannot fetch their catalogs.

To create your first environment, create a directory named `production` in your environmentpath. (If a `production` directory doesn't exist, the Puppet master will try to create one when it starts up.) Once it is created, you can add modules, a [main manifest,][main manifest] and an [environment.conf][] file to it.

* See [the page on creating directory environments][create_environment] for full details.

### Restart the Puppet Master

Restart the web server that manages your Puppet master, to make sure the Puppet master picks up its changed configuration.


Global Settings for Configuring Environments
-----

Puppet uses five settings in [puppet.conf][] to configure the behavior of directory environments:

* [`environmentpath`][environmentpath] is the list of directories where Puppet will look for environments.
* [`basemodulepath`][basemodulepath] lists directories of global modules that all environments can access by default.
* [`default_manifest`][default_manifest] specifies the main manifest for any environment that doesn't set a `manifest` value in [environment.conf][].
* [`disable_per_environment_manifest`][disable_per_environment_manifest] lets you specify that **all** environments should use a shared main manifest. This requires `default_manifest` to be set to an absolute path.
* [`environment_timeout`][environment_timeout] sets how often the Puppet will refresh information about environments. It can be overridden per-environment.

### `environmentpath`

[inpage_environmentpath]: #about-environmentpath

The Puppet master will only look for environments in certain directories, listed by [the `environmentpath` setting][environmentpath] in puppet.conf. The recommended value for `environmentpath` is `$confdir/environments`. ([See here for info on the confdir][confdir].)

If `environmentpath` isn't set, directory environments will be disabled completely.

If you need to manage environments in multiple directories, you can set `environmentpath` to a colon-separated list of directories. (For example: `$confdir/temporary_environments:$confdir/environments`.) When looking for an environment, Puppet will search these directories in order, with earlier directories having precedence.

Note that if multiple copies a given environment exist in the `environmentpath`, Puppet will use the first one. It won't use any contents of the other copies.

The `environmentpath` setting should usually be set in the `[main]` section of [puppet.conf][].

### `basemodulepath`

Although environments should contain their own modules, you might want some modules to be available to all environments.

[The `basemodulepath` setting][basemodulepath] configures the global module directories. By default, it includes `$confdir/modules`, which is good enough for most users. The default may also include another directory for "system" modules, depending on your OS and Puppet distribution:

OS and Distro             | Default basemodulepath
--------------------------|----------------------------------------------------
\*nix (Puppet Enterprise) | `$confdir/modules:/opt/puppet/share/puppet/modules`
\*nix (open source)       | `$confdir/modules:/usr/share/puppet/modules`
Windows (PE and foss)     | `$confdir\modules`

> **Note:** In Puppet Enterprise 3.3, the `basemodulepath` must **always** include the `/opt/puppet/share/puppet/modules` directory.
>
> If you **upgraded** to Puppet Enterprise 3.3 from a previous version of PE, the default `basemodulepath` may not be set in your [puppet.conf][] file. You will need to add `basemodulepath = $confdir/modules:/opt/puppet/share/puppet/modules` to the `[main]` section of your puppet.conf before using directory environments.

To add additional directories containing global modules, you can set your own value for `basemodulepath`. See [the page on the modulepath][modulepath] for more details about how Puppet loads modules from the modulepath.

### `default_manifest`

[(See also: Full description of `default_manifest` setting.)](./configuration.html#defaultmanifest)

The default [main manifest][] to use for environments that don't specify one in [environment.conf][].

The default value of `default_manifest` is `./manifests` --- that is, the environment's own `manifests` directory. (In Puppet versions prior to 3.7, this wasn't configurable.)

The value of this setting can be:

* An absolute path to one manifest that all environments will share
* A relative path to a file or directory inside each environment's directory

### `disable_per_environment_manifest`

Setting `disable_per_environment_manifest = true` will cause Puppet to use the same global manifest for every environment. If an environment specifies a different manifest in [environment.conf][], Puppet will refuse to compile catalogs nodes in that environment (to avoid serving catalogs with potentially wrong contents).

This requires `default_manifest` to be an absolute path.

### `environment_timeout`

[inpage_timeout]: #environmenttimeout
[puppetserver.conf]: {{puppetserver}}/configuration.html#puppetserverconf
[environment-cache]: {{puppetserver}}/admin-api/v1/environment-cache.html

[(See also: Full description of `environment_timeout` setting.)](./configuration.html#environmenttimeout)

How long the Puppet master should cache the data it loads from an environment. For performance reasons, we recommend changing this setting once you have a mature code deployment process.

This setting defaults to `0` (caching disabled), which lowers the performance of your Puppet master but makes it easy for new users to deploy updated Puppet code.

> **Note:** This default changed in Puppet 3.7.5. In 3.7.0 through 3.7.4, it was `3m`.

For best performance, you should:

* Set `environment_timeout = unlimited` in puppet.conf.
* Change your code deployment process to refresh the Puppet master whenever you deploy updated code. (For example, set a `postrun` command in your r10k config or add a step to your CI job.)
    * With Puppet Server, refresh environments by [calling the `environment-cache` API endpoint.][environment-cache] You may need to allow access in [puppetserver.conf][]'s `puppet-admin` section.
    * With a Rack Puppet master, restart the web server or the
      application server. Passenger lets you touch a `restart.txt` file to
      refresh an application without restarting Apache; see the Passenger docs
      for details.

This setting can be overridden per-environment in [environment.conf][], but most users should avoid doing that.

> **Note:** We don't recommend using any value other than `0` or `unlimited`, since most Puppet masters use a pool of Ruby interpreters which all have their own cache timers. When these timers drift out of sync, agents can be served inconsistent catalogs. To avoid that inconsistency, you have to refresh your Puppet master when deploying anyway, which means there's no benefit to not using `unlimited`.
