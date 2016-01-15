---
layout: default
title: "Configuring Directory Environments"
---

[manifest_dir]: ./dirs_manifest.html
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

Before you can use directory environments, you have to configure Puppet to enable them. After enabling them, you can:

* [Create environments][create_environment]
* [Assign environments to your nodes][assign]

For more info about what environments do, see [About Directory Environments.][about]

Enabling Directory Environments in Puppet Enterprise
-----

Directory environments are disabled by default in Puppet Enterprise 3.3. To enable them, you must:

* Edit the config file
* Create at least one directory environment

### Edit puppet.conf

Make sure the following settings are present in your [puppet.conf][] file:

    [main]
        environmentpath = $confdir/environments
        basemodulepath = $confdir/modules:/opt/puppet/share/puppet/modules

The `environmentpath` setting can also be set to [another value of your choice][inpage_environmentpath].

The `basemodulepath` setting is already present in fresh installations of Puppet Enterprise 3.3, but if you upgraded from a previous version of PE, you must set it manually.

**The basemodulepath must include the `/opt/puppet/share/puppet/modules` directory.** Puppet Enterprise uses modules from this directory to configure orchestration and other features. You can also specify other directories with global modules that should be available in all environments; see the section below about settings for more details.

Once you edit puppet.conf, directory environments will be enabled and config file environments will be disabled.

### Create a Directory Environment

You must have a directory environment for **every** environment that **any** nodes are assigned to. **At minimum, you must have a `production` environment.** Nodes assigned to nonexistent environments cannot fetch their catalogs.

To create your first environment:

* Create a directory named `/etc/puppetlabs/puppet/environments/production` (as well as the `environments` directory, if you haven't already).
* **Copy** your `/etc/puppetlabs/puppet/manifests` directory to `/etc/puppetlabs/puppet/environments/production/manifests`.

Once the `production` environment is created, you can add modules, additional [main manifest][manifest_dir] files, and an [environment.conf][] file to it.

**Note:** In Puppet Enterprise 3.3, there are two statements that **must** exist in every environment's main manifest: a `filebucket` resource, and a `File` resource default.

* See [the page on creating directory environments][create_environment] for full details.

Enabling Directory Environments in Open Source Puppet
-----

Directory environments are disabled by default. To enable them, you must:

* Edit the config file
* Create at least one directory environment

### Edit puppet.conf

To enable directory environments, set `environmentpath = $confdir/environments` (or [the value of your choice][inpage_environmentpath]) in the puppet master's [puppet.conf][] (in the `[main]` or `[master]` section).

Optionally, you can also use the `basemodulepath` setting to specify global modules that should be available in all environments. Most people are fine with the default value; see the section below about settings for more details.

Once you edit puppet.conf, directory environments will be enabled and config file environments will be disabled.

### Create a Directory Environment

You must have a directory environment for **every** environment that **any** nodes are assigned to. **At minimum, you must have a `production` environment.** Nodes assigned to nonexistent environments cannot fetch their catalogs.

To create your first environment, create a directory named `production` in your environmentpath. Once it is created, you can add modules, a [main manifest,][manifest_dir] and an [environment.conf][] file to it.

* See [the page on creating directory environments][create_environment] for full details.



Global Settings for Configuring Environments
-----

Puppet uses three settings from [puppet.conf][] to configure the behavior of directory environments:

* [`environmentpath`][environmentpath] is the list of directories where Puppet will look for environments.
* [`basemodulepath`][basemodulepath] lists directories of global modules that all environments can access by default.
* [`environment_timeout`][environment_timeout] sets how often the Puppet will refresh information about environments. It can be overridden per-environment.

### `environmentpath`

[inpage_environmentpath]: #about-environmentpath

The puppet master will only look for environments in certain directories, listed by [the `environmentpath` setting][environmentpath] in puppet.conf. The recommended value for `environmentpath` is `$confdir/environments`. ([See here for info on the confdir][confdir].)

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



### `environment_timeout`

The puppet master loads environments on request, and it caches data associated with them to give faster service to other nodes in that environment. Cached environments will time out and be discarded after a while, after which they'll be loaded on request again.

You can configure environment cache timeouts with [the `environment_timeout` setting.][environment_timeout] This can be set globally in [puppet.conf][], and can also be overridden per-environment in [environment.conf][]. See [the description of the `environment_timeout` setting][environment_timeout] for details on allowed values. The default cache timeout is **three minutes.**

Most users should be fine with the default. To get more performance from your puppet master, you may want to tune the timeout for your most heavily used environments. Getting the most benefit involves a tradeoff between speed, memory usage, and responsiveness to changed files. The general best practice is:

- Long-lived, slowly changing, relatively homogenous, highly populated environments (like `production`) will give the most benefit from longer timeouts. You might be able to set this to hours, or `unlimited` if you're content to let cache stick around until your Rack server kills a given puppet master process.
- Rapidly changing dev environments should have short timeouts: a few seconds, or `0` if you don't want to wait.
- Sparsely populated environments should have short-ish timeouts, which are just long enough to help out if a cluster of nodes all hit the master at once, but won't clog your RAM with a bunch of rarely used data. Three minutes is fine.
- Extremely heterogeneous environments --- where you have a lot of modules and each node uses a different tiny subset --- will sometimes perform _worse_ with a long timeout. (This can cause excessive memory usage and garbage collection without giving back any performance boost.) Give these short timeouts of 5-10 seconds.

