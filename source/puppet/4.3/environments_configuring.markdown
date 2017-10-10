---
layout: default
title: "Configuring Environments"
canonical: "/puppet/latest/environments_configuring.html"
---

[environmentpath]: ./configuration.html#environmentpath
[codedir]: ./dirs_codedir.html
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

Global Settings for Configuring Environments
-----

Puppet uses five settings in [puppet.conf][] to configure the behavior of environments:

* [`environmentpath`][environmentpath] is the list of directories where Puppet will look for environments.
* [`basemodulepath`][basemodulepath] lists directories of global modules that all environments can access by default.
* [`default_manifest`][default_manifest] specifies the main manifest for any environment that doesn't set a `manifest` value in [environment.conf][].
* [`disable_per_environment_manifest`][disable_per_environment_manifest] lets you specify that **all** environments should use a shared main manifest. This requires `default_manifest` to be set to an absolute path.
* [`environment_timeout`][environment_timeout] sets how often the Puppet will refresh information about environments. It can be overridden per-environment.

## `environmentpath`

[inpage_environmentpath]: #about-environmentpath

The Puppet master will only look for environments in certain directories, listed by [the `environmentpath` setting][environmentpath] in puppet.conf. The default value for `environmentpath` is `$codedir/environments`. ([See here for info on the codedir][codedir].)

If you need to manage environments in multiple directories, you can set `environmentpath` to a colon-separated list of directories. (For example: `$codedir/temporary_environments:$codedir/environments`.) When looking for an environment, Puppet will search these directories in order, with earlier directories having precedence.

Note that if multiple copies of a given environment exist in the `environmentpath`, Puppet will use the first one. It won't use any content from the other copies.

The `environmentpath` setting should usually be set in the `[main]` section of [puppet.conf][].

## `basemodulepath`

Although environments should contain their own modules, you might want some modules to be available to all environments.

[The `basemodulepath` setting][basemodulepath] configures the global module directories. By default, it includes `$codedir/modules` for user-accessible modules and `/opt/puppetlabs/puppet/modules` for system modules.

To add additional directories containing global modules, you can set your own value for `basemodulepath`. See [the page on the modulepath][modulepath] for more details.

> **Note:** In Puppet Enterprise, the `basemodulepath` must *always* include the system module directory.


## `default_manifest`

[(See also: Full description of `default_manifest` setting.)](./configuration.html#defaultmanifest)

The default [main manifest][] to use for environments that don't specify a manifest in [environment.conf][].

The default value of `default_manifest` is `./manifests` --- that is, the environment's own `manifests` directory. (In Puppet versions prior to 3.7, this wasn't configurable.)

The value of this setting can be:

* An absolute path to one manifest that all environments will share
* A relative path to a file or directory inside each environment's directory

## `disable_per_environment_manifest`

Setting `disable_per_environment_manifest = true` will cause Puppet to use the same global manifest for every environment. If an environment specifies a different manifest in [environment.conf][], Puppet will refuse to compile catalogs nodes in that environment (to avoid serving catalogs with potentially wrong contents).

This requires `default_manifest` to be an absolute path.

## `environment_timeout`

[inpage_timeout]: #environmenttimeout
[auth.conf]: {{puppetserver}}/config_file_auth.html
[environment-cache]: /puppetserver/latest/admin-api/v1/environment-cache.html

[(See also: Full description of `environment_timeout` setting.)](./configuration.html#environmenttimeout)

How long the Puppet master should cache the data it loads from an environment. For performance reasons, we recommend changing this setting once you have a mature code deployment process.

This setting defaults to `0` (caching disabled), which lowers the performance of your Puppet master but makes it easy for new users to deploy updated Puppet code.

For best performance, you should:

* Set `environment_timeout = unlimited` in puppet.conf.
* Change your code deployment process to refresh the Puppet master whenever you deploy updated code. (For example, set a `postrun` command in your r10k config or add a step to your CI job.)
    * With Puppet Server, refresh environments by [calling the `environment-cache` API endpoint.][environment-cache] You may need to allow access in Puppet Server's [auth.conf][] file.
    * With a Rack Puppet master, restart the web server or the
      application server. Passenger lets you touch a `restart.txt` file to
      refresh an application without restarting Apache; see the [Passenger docs](/guides/passenger.html)
      for details.

This setting can be overridden per-environment in [environment.conf][], but most users should avoid doing that.

> **Note:** We don't recommend using any value other than `0` or `unlimited`, since most Puppet masters use a pool of Ruby interpreters which all have their own cache timers. When these timers drift out of sync, agents can be served inconsistent catalogs. To avoid that inconsistency, you have to refresh your Puppet master when deploying anyway, which means there's no benefit to not using `unlimited`.
