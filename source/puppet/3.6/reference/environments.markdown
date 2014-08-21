---
layout: default
title: "Directory Environments"
canonical: "/puppet/latest/reference/environments.html"
---

[manifest_dir]: ./dirs_manifest.html
[manifest_dir_dir]: ./dirs_manifest.html#directory-behavior-vs-single-file
[config_file_envs]: ./environments_classic.html
[config_version]: /references/3.6.latest/configuration.html#configversion
[environmentpath]: /references/3.6.latest/configuration.html#environmentpath
[confdir]: ./dirs_confdir.html
[enc]: /guides/external_nodes.html
[node terminus]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc_environment]: /guides/external_nodes.html#environment
[puppet.conf]: ./config_file_main.html
[env_setting]: /references/3.6.latest/configuration.html#environment
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: /references/3.6.latest/configuration.html#basemodulepath
[manifest_setting]: /references/3.6.latest/configuration.html#manifest
[modulepath_setting]: /references/3.6.latest/configuration.html#modulepath
[config_print]: ./config_print.html
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master
[config_file_envs_sections]: ./environments_classic.html#environment-config-sections
[environment.conf]: ./config_file_environment.html
[environment_timeout]: /references/3.6.latest/configuration.html#environmenttimeout

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

Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the puppet master.][env_var]

Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
