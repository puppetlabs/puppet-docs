---
layout: default
title: "Directory Environments"
canonical: "/puppet/latest/reference/environments.html"
---

[manifest_dir]: ./dirs_manifest.html
[manifest_dir_dir]: ./dirs_manifest.html#directory-behavior-vs-single-file
[config_file_envs]: ./environments_classic.html
[config_version]: /references/3.7.latest/configuration.html#configversion
[environmentpath]: /references/3.7.latest/configuration.html#environmentpath
[confdir]: ./dirs_confdir.html
[enc]: /guides/external_nodes.html
[node terminus]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc_environment]: /guides/external_nodes.html#environment
[puppet.conf]: ./config_file_main.html
[env_setting]: /references/3.7.latest/configuration.html#environment
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: /references/3.7.latest/configuration.html#basemodulepath
[manifest_setting]: /references/3.7.latest/configuration.html#manifest
[modulepath_setting]: /references/3.7.latest/configuration.html#modulepath
[config_print]: ./config_print.html
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master
[config_file_envs_sections]: ./environments_classic.html#environment-config-sections
[environment.conf]: ./config_file_environment.html
[environment_timeout]: /references/3.7.latest/configuration.html#environmenttimeout

Environments are isolated groups of puppet agent nodes. A puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)


> Directory Environments vs. Config File Environments
> -----
>
> There are two ways to set up environments on a puppet master: **directory environments,** and [**config file environments.**][config_file_envs] Note that these **are mutually exclusive** --- enabling one will completely disable the other.
>
> This page is about directory environments, which are easier to use and will eventually replace config file environments completely.

Things to Know About Directory Environments
---

### They Disable Config File Environments

If directory environments are enabled, they will completely disable config file environments. This means:

* Puppet will always ignore the `manifest`, `modulepath`, and `config_version` settings in puppet.conf.
* Puppet will always ignore any [environment config sections][config_file_envs_sections] in puppet.conf.

Instead, the effective [site manifest][manifest_dir] and [modulepath][] will always come from the active environment.

### Unconfigured Environments Aren't Allowed

If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories --- the puppet master will fail compilation of its catalog.


Enabling Directory Environments
-----

Directory environments are disabled by default. To enable them, you must:

* Set `environmentpath = $confdir/environments` in the puppet master's [puppet.conf][] (in the `[master]` or `[main]` section).
    * You can also set other values for `environmentpath`. See the "About environmentpath" section below for more details.
* Create at least one directory environment. See the ["Setting Up Environments on a Puppet Master"][inpage_set_up] section below for details.
    * You must have a directory environment for every environment that any nodes are assigned to. At minimum, you must have a `production` environment. (You can make one quickly by moving your `$confdir/manifests` directory to `$confdir/environments/production/manifests`.)
* Optionally, set the `basemodulepath` setting for global modules that should be available in all environments.
    * Most people are fine with the default value. See the "About basemodulepath" section below for more details.

Once you do this, directory environments will be enabled and config file environments will be disabled.

### About `environmentpath`

[inpage_environmentpath]: #about-environmentpath

The puppet master will only look for environments in certain directories, listed by [the `environmentpath` setting][environmentpath] in puppet.conf. The recommended value for `environmentpath` is `$confdir/environments`. ([See here for info on the confdir][confdir].)

If you need to manage environments in multiple directories, you can set `environmentpath` to a colon-separated list of directories. (For example: `$confdir/temporary_environments:$confdir/environments`.) Puppet will search these directories in order, with earlier directories having precedence.

### About `basemodulepath`

Although environments should contain their own modules, you might want some modules to be available to all environments.

[The `basemodulepath` setting][basemodulepath] configures the global module directories. By default, it includes `$confdir/modules`, which is good enough for most users. The default may also include another directory for "system" modules, depending on your OS and Puppet distribution:

OS and Distro             | Default basemodulepath
--------------------------|----------------------------------------------------
\*nix (Puppet Enterprise) | `$confdir/modules:/opt/puppet/share/puppet/modules`
\*nix (open source)       | `$confdir/modules:/usr/share/puppet/modules`
Windows (PE and foss)     | `$confdir\modules`

To add additional directories containing global modules, you can set your own value for `basemodulepath`. See [the page on the modulepath][modulepath] for more details about how Puppet loads modules from the modulepath.


Setting Up Environments on a Puppet Master
-----

[inpage_set_up]: #setting-up-environments-on-a-puppet-master

A directory environment is just a directory that follows a few conventions:

* The directory name is the environment name.
* It should contain a `modules` directory and a `manifests` directory. (These are allowed to be empty or absent; see sections below for details.)
* It may contain [an `environment.conf` file][environment.conf], which can locally override several settings.
* It must be located in a directory where the puppet master searches for environments. (The recommended directory is `$confdir/environments`. See [About `environmentpath`][inpage_environmentpath] above.)

Once those conditions are met, the environment is fully configured. When serving nodes assigned to that environment, the puppet master will use the modules and the main manifest from that environment.

![Diagram: A directory with four directory environments. Each directory environment contains a modules directory, a manifests directory, and an environment.conf file.](./images/environment_directories.jpg)

### Manifests Directory → Main Manifest

An environment's `manifests` directory will be used as the [main manifest][manifest_dir] when compiling catalogs for nodes in that environment. This uses the [directory-as-manifest behavior][manifest_dir_dir].

If the `manifests` directory is empty or absent, Puppet will not fall back to the default main manifest; instead, it will behave as though you used a totally blank main manifest.

You can use a different main manifest by setting `manifest` in `environment.conf`. (See below.) The global `manifest` setting from puppet.conf won't be used.

### Modules Directory → First Directory in Modulepath

When serving nodes from a directory environment, the effective [modulepath][] will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath], with the environment getting priority.

If the `modules` directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`.

You can configure a different modulepath for the environment by setting `modulepath` in `environment.conf`. (See below.) The global `modulepath` setting from puppet.conf won't be used.

For details on how Puppet loads modules from modulepath directories, see [the reference page about the modulepath.][modulepath]

> #### Checking the Modulepath
>
> You can view an environment's effective modulepath by specifying the environment when [requesting the setting value][config_print]:
>
>     $ sudo puppet config print modulepath --section master --environment test
>     /etc/puppet/environments/test/modules:/etc/puppet/modules:/usr/share/puppet/modules

### The `environment.conf` File

An environment can contain an `environment.conf` file, which can override values for the following settings:

* [`modulepath`][modulepath_setting] --- **Note:** if you're using Puppet Enterprise, you must always include either `$basemodulepath` or `/opt/puppet/share/puppet/modules` in the modulepath, since PE uses the modules in `/opt` to configure orchestration and other features.
* [`manifest`][manifest_setting]
* [`config_version`][config_version]
* [`environment_timeout`][environment_timeout]

See [the page on `environment.conf` for more details.][environment.conf]

### Allowed Names

Environment names can contain letters, numbers, and underscores. That is, they must match the following regular expression:

`\A[a-z0-9_]+\Z`

Additionally, there are four forbidden environment names:

* `main`
* `master`
* `agent`
* `user`

These names can't be used because they conflict with the primary [config sections](./config_file_main.html#config-sections). **This can be a problem with Git,** because its default branch is named `master`. You may need to rename the `master` branch to something like `production` or `stable` (e.g. `git branch -m master production`).

Assigning Nodes to Environments
-----

By default, all nodes are assigned to a default environment named `production`.

There are two ways to assign nodes to a different environment:

* Via your [ENC][] or [node terminus][]
* Via each agent node's puppet.conf

The value from the ENC is authoritative, if it exists. If the ENC doesn't specify an environment, the node's config value is used.

Note that nodes can't be assigned to unconfigured environments. If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories --- the puppet master will fail compilation of its catalog.

### Via an ENC

The interface to set the environment for a node will be different for each ENC. Some ENCs cannot manage environments.

When writing an ENC, simply ensure that the `environment:` key is set in the YAML output that the ENC returns. [See the documentation on writing ENCs for details.][enc_environment]

If the environment key isn't set in the ENC's YAML output, the puppet master will just use the environment requested by the agent.

### Via the Agent's Config File

In [puppet.conf][] on each agent node, you can set [the `environment` setting][env_setting] in either the `agent` or `main` config section. When that node requests a catalog from the puppet master, it will request that environment.

If you are using an ENC and it specifies an environment for that node, it will override whatever is in the config file.

Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the puppet master.][env_var]

Tuning Environment Caching
-----

The puppet master loads environments on request, and it caches data associated with them to give faster service to other nodes in that environment. Cached environments will time out and be discarded after a while, after which they'll be loaded on request again.

You can configure environment cache timeouts with the `environment_timeout` setting. This can be set globally in [puppet.conf][], and can also be overridden per-environment in [environment.conf][]. See [the description of the `environment_timeout` setting][environment_timeout] for details on allowed values. The default cache timeout is five seconds, which doesn't give much of a performance boost but also won't surprise you by ignoring their file changes.

To get more performance from your puppet master, you may want to tune the timeout for your most heavily used environments. Getting the most benefit involves a tradeoff between speed, memory usage, and responsiveness to changed files. The general best practice is:

- Long-lived, slowly changing, relatively homogenous, highly populated environments (like `production`) will give the most benefit from longer timeouts. You might be able to set this to hours, or `unlimited` if you're content to let cache stick around until your Rack server kills a given puppet master process.
- Rapidly changing dev environments should have short timeouts: a few seconds, or `0` if you don't want to wait.
- Sparsely populated environments should have short-ish timeouts, which are just long enough to help out if a cluster of nodes all hit the master at once, but won't clog your RAM with a bunch of rarely used data. Five to ten seconds is fine.
- Extremely heterogeneous environments --- where you have a lot of modules and each node uses a different tiny subset --- will sometimes perform _worse_ with a long timeout. (This can cause excessive memory usage and garbage collection without giving back any performance boost.) Leave these with short timeouts of 5-10 seconds.


Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
