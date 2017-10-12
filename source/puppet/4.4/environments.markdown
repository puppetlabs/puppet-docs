---
layout: default
title: "About Environments"
canonical: "/puppet/latest/environments.html"
---


[manifest_dir]: ./dirs_manifest.html
[modulepath]: ./dirs_modulepath.html
[assign]: ./environments_assigning.html
[env_var]: ./lang_facts_and_builtin_vars.html#puppet-master-variables
[dir_env_create]: ./environments_creating.html

Environments are isolated groups of Puppet agent nodes. A Puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate Puppet master for testing, but using environments is often easier.)

Assigning Nodes to Environments
-----

You can assign agent nodes to environments using either the agent's config file, or an external node classifier (ENC). If you are using Puppet Enterprise (PE), you can use the PE console to set environments.

For details, see [the page on assigning nodes to environments.][assign]

Referencing the Environment in Manifests
-----

In Puppet manifests, you can get the name of the current environment by using the `$environment` variable, which is [set by the Puppet master.][env_var]


About Environments
-----

You can add a new environment by simply adding a new directory of config data. To start using environments, do the following:

* [Create your environments][dir_env_create]
* [Assign nodes to their environments][assign]

### Unconfigured Environments Aren't Allowed

If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories --- the Puppet master will fail compilation of its catalog.

Other Information About Environments
-----

This section of the Puppet reference manual has several other pages about environments:

- [Suggestions for Use](./environments_suggestions.html) --- common patterns and best practices for using environments.
- [Limitations of Environments](./environments_limitations.html) --- environments mostly work, but they can be a bit wobbly in several situations.
- [Environments and Puppet's HTTPS Interface](./environments_https.html) --- this page explains how environment information is embedded in Puppet's HTTPS requests, and how you can query environment data in order to build Puppet extensions.
