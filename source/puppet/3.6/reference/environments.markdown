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


Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the puppet master.][env_var]

Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
