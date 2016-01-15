---
layout: default
title: "Config-file Environments"
canonical: "/puppet/latest/reference/environments_classic.html"
---

[config_sections]: ./config_file_main.html#config-sections
[manifest_dir]: ./dirs_manifest.html
[modulepath]: ./dirs_modulepath.html
[config_version]: ./configuration.html#configversion
[puppet.conf]: ./config_file_main.html
[manifest_setting]: ./configuration.html#manifest
[modulepath_setting]: ./configuration.html#modulepath
[directory_environments]: ./environments.html
[dir_envs_enable]: ./environments.html#enabling-directory-environments
[enc]: /guides/external_nodes.html
[node terminus]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc_environment]: /guides/external_nodes.html#environment
[env_setting]: ./configuration.html#environment
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master

> Config File Environments Are Deprecated
> -----
>
> If your puppet.conf file:
>
> * Contains any environment config blocks
> * Sets global values for the `manifest`, `modulepath`, or `config_version` settings
>
> ...then the puppet master will log deprecation warnings. (Interpolating the `$environment` variable won't log warnings, since it's benign without the global settings and is useful in `environment.conf` files.)
>
> In a future version of Puppet (probably Puppet 4), [directory environments][directory_environments] will always be enabled, and the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.
>
> When you have time, you should read up on [directory environments][directory_environments] and start using them.

Environments are isolated groups of puppet agent nodes. A puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)

> Directory Environments vs. Config File Environments
> -----
>
> There are two ways to set up environments on a puppet master: [**directory environments,**][directory_environments] and **config file environments.**
>
> This page is about config file environments, which are deprecated and are more complex to use. You should consider moving to directory environments soon.

Setting Up Environments on a Puppet Master
-----

Puppet's config file provides two ways to configure environments: per-environment **config sections,** and interpolation of the `$environment` variable in settings values (AKA **dynamic environments**).

### Environment Config Sections

The [puppet.conf file][puppet.conf] has four primary [config sections][config_sections]. The puppet master application will usually use settings from the `master` section, and will fall back to the `main` section for settings that aren't defined in `master`.

You can also make additional config sections for environments. If available, Puppet will use settings from an environment config section when serving nodes assigned to that environment. If an environment-specific section doesn't exist or doesn't set values for some settings, Puppet will fall back to the `master` and then `main` sections as normal.

    [main]
      server = puppet.example.com
      certname = puppetmaster1.example.com
      trusted_node_data = true
    [master]
      dns_alt_names = puppetmaster1.example.com,puppetmaster1,puppet.example.com,puppet
      autosign = false
    [test]
      modulepath = $confdir/environments/test/modules:$confdir/modules:/usr/share/puppet/modules
      manifest = $confdir/environments/test/manifests
      config_version = /usr/bin/git --git-dir $confdir/environments/test/.git rev-parse HEAD

In this example, the `test` environment has its own separate values for the `modulepath`, `manifest`, and `config_version` settings, and Puppet will use those when serving nodes in that environment. When serving nodes in other environments, the puppet master will use the global values for those settings, which in this example are left to their defaults.

#### Usable Settings

Only certain settings can be used in an environment config section. Although Puppet will allow you to set any settings there, it will only actually read and use a few of them. Those usable settings are:

- [`modulepath`][modulepath_setting]
- [`manifest`][manifest_setting]
- [`config_version`][config_version]

The `templatedir` setting will also work, but we recommend against using the old-style global template directory.

### Dynamic Environments

Alternately, you can use the global values for the `modulepath` and `manifest` settings (via the `master` or `main` section), but set their values to use the special `$environment` variable. (Note that if an environment config section exists for the active environment, it will get priority.)

When getting values for settings, Puppet will replace `$environment` with the name of the active environment. This allows you to mimic [directory environments][directory_environments]:

    [master]
      manifest = $confdir/environments/$environment/manifests
      modulepath = $confdir/environments/$environment/modules

In this example, you could create a directory for each environment in the `$confdir/environments` directory.

When using dynamic environments, there's not a very good way to set `config_version`. Possibly due to the timing of how settings are loaded, interpolation of `$environment` in that setting doesn't seem to work. In a future version of Puppet, directory environments will provide a cleaner way to do this.

Similarly, you shouldn't interpolate `$environment` into any other settings besides `manifest` and `modulepath`; the results are likely to be unpredictable.

### Allowed Names

Environment names can contain letters, numbers, and underscores. That is, they must match the following regular expression:

`\A[a-z0-9_]+\Z`

Additionally, there are four forbidden environment names:

* `main`
* `master`
* `agent`
* `user`

These names can't be used because they conflict with the primary [config sections][config_sections]. **This can be a problem with Git,** because its default branch is named `master`. You may need to rename the `master` branch to something like `production` or `stable` (e.g. `git branch -m master production`).

### No Interaction with Directory Environments

If directory environments are enabled (by setting the `environmentpath` setting; see [Enabling Directory Environments][dir_envs_enable]), any config file environments will be completely ignored.

If you've accidentally configured the same environment in multiple ways (see [the page on directory environments][directory_environments]), the precedence goes like this:

Config sections → directory environments → dynamic (`$environment`) environments

If an environment config section exists for the active environment, Puppet will **ignore the directory environment** it would have otherwise used. This means it will use the standard [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings to serve nodes in that environment. If values for those settings are specified in the environment config section, those will be used; otherwise, Puppet will use the global values.

If the global values for the [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings use the `$environment` variable, they will only be used when a directory environment **doesn't** exist for the active environment.

Similarly, if the global `manifest` or `modulepath` use `$environment`, any config section environments will override them.

### Unconfigured Environments → Global Settings

If a node is assigned to an environment for which a config section doesn't exist, or if the config section does not specify a value for one or more settings, the puppet master will use the global [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings to serve that node.

If the values of the `manifest` or `modulepath` settings point to any files or directories that don't exist (due to interpolating `$environment` for an unexpected environment name), Puppet will act as though those directories were empty.


Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the puppet master.][env_var]

Tuning Environment Caching
-----

With config file environments, there's very little performance to be gained by tuning the `environment_timeout` setting. It can be ignored until you're ready to switch to directory environments.


Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
