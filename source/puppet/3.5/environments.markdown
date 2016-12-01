---
layout: default
title: "Directory Environments"
canonical: "/puppet/latest/reference/environments.html"
---

[manifest_dir]: ./dirs_manifest.html
[manifest_dir_dir]: ./dirs_manifest.html#directory-behavior-vs-single-file
[config_file_envs]: ./environments_classic.html
[config_version]: ./configuration.html#configversion
[environmentpath]: ./configuration.html#environmentpath
[confdir]: ./dirs_confdir.html
[enc]: /guides/external_nodes.html
[node terminus]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc_environment]: /guides/external_nodes.html#environment
[puppet.conf]: ./config_file_main.html
[env_setting]: ./configuration.html#environment
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: ./configuration.html#basemodulepath
[manifest_setting]: ./configuration.html#manifest
[modulepath_setting]: ./configuration.html#modulepath
[config_print]: ./config_print.html
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master
[config_file_envs_sections]: ./environments_classic.html#environment-config-sections
[dynamic environments]: ./environments_classic.html#dynamic-environments
[modulepath_duplicates]: ./dirs_modulepath.html#duplicate-or-conflicting-modules-and-content

Environments are isolated groups of puppet agent nodes. A puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)


> Directory Environments vs. Config File Environments
> -----
>
> There are two ways to set up environments on a puppet master: **directory environments,** and [**config file environments.**][config_file_envs] Note that these **are mutually exclusive** --- enabling one will completely disable the other.
>
> This page is about directory environments, which are easier to use and will eventually replace config file environments completely. However, in Puppet 3.5, they cannot:
>
> - Set [`config_version`][config_version] per-environment
> - Change the order of the `modulepath` or remove parts of it
>
> Those features are coming soon, probably in Puppet 3.6.

Enabling Directory Environments
-----

[inpage_enable]: #enabling-directory-environments

In Puppet 3.5.1 and later, directory environments are disabled by default. To enable them, you must:

* Set a value for the `environmentpath` setting in the puppet master's puppet.conf file.
    * Most people should set `environmentpath = $confdir/environments`. See the "About environmentpath" section below for more details.
* Create at least one directory environment; you must have a directory environment for every environment that any nodes are assigned to. At minimum, you must have a `production` environment.
    * Most people should move their `$confdir/manifests` directory to `$confdir/environments/production/manifests`. See the ["Setting Up Environments on a Puppet Master"][inpage_set_up] section below for details.
* Optionally, set the `basemodulepath` setting for global modules that should be available in all environments.
    * Most people are fine with the default value. See the "About basemodulepath" section below for more details.

### Warning: This Will Disable Config File Environments

If directory environments are enabled with the `environmentpath` setting, they will completely disable config file environments. This means:

* Puppet will always ignore the `manifest` setting in puppet.conf.
* Puppet will always ignore the `modulepath` setting in puppet.conf.
* Puppet will always ignore any [environment config sections][config_file_envs_sections] in puppet.conf.
* If a node is assigned to a non-existent environment, the puppet master will fail compilation of its catalog.

Puppet will **always** use environment-specific values for the effective [site manifest][manifest_dir] and [modulepath][]; it will never fall back to a global value if the environment-specific directory is missing.

### About `environmentpath`

The puppet master will only look for environments in certain directories, and only if [the `environmentpath` setting][environmentpath] is set, in the `[main]` section of puppet.conf. The recommended value for `environmentpath` is `$confdir/environments`. ([See here for info on the confdir][confdir].)

If you need to manage environments in multiple directories, you can set `environmentpath` to a colon-separated list of directories. (For example: `$confdir/temporary_environments:$confdir/environments`.) Puppet will search these directories in order, with earlier directories having precedence.

> **Note:** In Puppet 3.5, there is a problem with setting `environmentpath` in the `[master]` section of puppet.conf, which causes `puppet config print` to display wrong info about the effective modulepath or manifest values. You should set it in `[main]` instead.

### About `basemodulepath`

Although environments should contain their own modules, you might want some modules to be available to all environments. (Since the environment's module directory comes first in the modulepath, global modules can be [overridden by duplicates in the environment's directory.][modulepath_duplicates])

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
* It must be located in a directory that the puppet master searches for environments. (By default, that's `$confdir/environments`. [See below for more info about this directory,](./environments.html#the-environmentpath) including how to search additional directories.)

![Diagram: A directory with four directory environments. Each directory environment contains a modules directory and a manifests directory.](./images/environment_directories.jpg)

Once those conditions are met, the environment is fully configured. When serving nodes assigned to that environment, the puppet master will use the modules and the main manifest from that environment.

### Manifests Directory → Main Manifest

An environment's `manifests` directory will be used as the [main manifest][manifest_dir] when compiling catalogs for nodes in that environment. This uses the [directory-as-manifest behavior][manifest_dir_dir].

**If empty or absent:** If a directory environment exists for the active environment, Puppet will not fall back to the default main manifest; instead, it will behave as though you used a totally blank main manifest. The global [`manifest` setting][manifest_setting] won't be used.

### Modules Directory → First Directory in Modulepath

When serving nodes from a directory environment, the effective [modulepath][] will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath], with the environment getting priority.

You can view the effective modulepath by specifying the environment when [requesting the setting value][config_print]:

    $ sudo puppet config print modulepath --section master --environment test
    /etc/puppet/environments/test/modules:/etc/puppet/modules:/usr/share/puppet/modules

**Example:**

If:

* The puppet master is serving a node in the `test` environment...
* ...which is located in the default `$confdir/environments` directory...
* ...and the value of the `basemodulepath` setting is `$confdir/modules:/usr/share/puppet/modules`...
* ...and the [confdir][] is located at `/etc/puppet`...

...then the effective modulepath would be:

`/etc/puppet/environments/test/modules:/etc/puppet/modules:/usr/share/puppet/modules`

That is, modules from the environment will be used first, and modules from the global module directories will be used only if they aren't overridden by a module of the same name in the active environment.

**If empty or absent:** If a directory environment exists for the active environment, Puppet will only use modules from directories in the `basemodulepath`. The global [`modulepath` setting][modulepath_setting] won't be used.

### Allowed Names

Environment names can contain letters, numbers, and underscores. That is, they must match the following regular expression:

`\A[a-z0-9_]+\Z`

Additionally, there are four forbidden environment names:

* `main`
* `master`
* `agent`
* `user`

These names can't be used because they conflict with the primary [config sections](./config_file_main.html#config-sections). **This can be a problem with Git,** because its default branch is named `master`. You may need to rename the `master` branch to something like `production` or `stable` (e.g. `git branch -m master production`).

### No Interaction with Config File Environments

If directory environments are enabled (by setting the `environmentpath` setting; see [Enabling Directory Environments above][inpage_enable]), any config file environments will be completely ignored.

If you previously used [dynamic environments][] and your `modulepath` setting included additional global module directories, you may need to set a value for the `basemodulepath` setting so that your directory environments will include those extra global directories.

### Unconfigured Environments → Catalog Failure

If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories --- the puppet master will fail compilation of its catalog.

> **Note:** This is a change from the initial 3.5.0 release, which would fall back to the global [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings for unconfigured environments.

Assigning Nodes to Environments
-----

By default, all nodes are assigned to a default environment named `production`.

There are two ways to assign nodes to a different environment:

* Via your [ENC][] or [node terminus][]
* Via each agent node's puppet.conf

The value from the ENC is authoritative, if it exists. If the ENC doesn't specify an environment, the node's config value is used.

### Via an ENC

The interface to set the environment for a node will be different for each ENC. Some ENCs cannot manage environments.

When writing an ENC, simply ensure that the `environment:` key is set in the YAML output that the ENC returns. [See the documentation on writing ENCs for details.][enc_environment]

If the environment key isn't set in the ENC's YAML output, the puppet master will just use the environment requested by the agent.

### Via the Agent's Config File

In [puppet.conf][] on each agent node, you can set [the `environment` setting][env_setting] in either the `agent` or `main` config section. When that node requests a catalog from the puppet master, it will request that environment.

If you are using an ENC and it specifies an environment for that node, it will override whatever is in the config file.

Referencing the Environment in Manifests
-----

[inpage_env_var]: #referencing-the-environment-in-manifests

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the puppet master.][env_var]

Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
