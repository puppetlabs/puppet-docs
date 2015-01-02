---
layout: default
title: "About Environments"
canonical: "/puppet/latest/reference/environments.html"
---


[manifest_dir]: ./dirs_manifest.html
[modulepath]: ./dirs_modulepath.html
[config_file_envs]: ./environments_classic.html
[config_file_envs_sections]: ./environments_classic.html#environment-config-sections
[assign]: ./environments_assigning.html
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master
[dir_env_configure]: ./environments_configuring.html
[dir_env_create]: ./environments_creating.html

Environments are isolated groups of Puppet agent nodes. A Puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate Puppet master for testing, but using environments is often easier.)


Directory Environments vs. Config File Environments
-----

There are two ways to set up environments on a Puppet master: [**directory environments,**][dir_env_configure] and [**config file environments.**][config_file_envs] Note that these **are mutually exclusive** --- enabling one will completely disable the other.

Directory environments are easier to use and will eventually replace config file environments completely.

Assigning Nodes to Environments
-----

You can assign agent nodes to environments using either the agent's config file or an external node classifier (ENC).

For details, see [the page on assigning nodes to environments.][assign]

Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the Puppet master.][env_var]


About Directory Environments
-----

Directory environments let you add a new environment by simply adding a new directory of config data. Here's what you'll need to know to start using them:

### Puppet Must Be Configured to Use Them

Since directory environments are a major change to how Puppet loads code and serves configurations, they aren't enabled by default yet. (They will become the only way to manage environments in Puppet 4.0.)

To start using directory environments, do the following:

* [Configure the Puppet master to use directory environments][dir_env_configure]
* [Create your environments][dir_env_create]
* [Assign nodes to their environments][assign]

### Unconfigured Environments Aren't Allowed

If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories --- the Puppet master will fail compilation of its catalog.

### They Disable Config File Environments

If directory environments are enabled, they will completely disable config file environments. This means:

* Puppet will always ignore the `manifest`, `modulepath`, and `config_version` settings in puppet.conf.
* Puppet will always ignore any [environment config sections][config_file_envs_sections] in puppet.conf.

Instead, the effective [site manifest][manifest_dir] and [modulepath][] will always come from the active environment.

About Config File Environments
-----

To use config file environments, see [the reference page on config file environments.][config_file_envs]


Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
