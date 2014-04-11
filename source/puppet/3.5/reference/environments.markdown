---
layout: default
title: "Directory Environments"
canonical: "/puppet/latest/reference/environments.html"
---

[manifest_dir]: ./dirs_manifest.html
[manifest_dir_dir]: ./dirs_manifest.html#directory-behavior-vs-single-file
[config_file_envs]: ./environments_classic.html
[config_version]: /references/3.5.latest/configuration.html#configversion
[environmentpath]: /references/3.5.latest/configuration.html#environmentpath
[confdir]: ./dirs_confdir.html
[enc]: /guides/external_nodes.html
[node terminus]: ./subsystem_catalog_compilation.html#step-1-retrieve-the-node-object
[enc_environment]: /guides/external_nodes.html#environment
[puppet.conf]: ./config_file_main.html
[env_setting]: /references/3.5.latest/configuration.html#environment
[modulepath]: ./dirs_modulepath.html
[basemodulepath]: /references/3.5.latest/configuration.html#basemodulepath
[manifest_setting]: /references/3.5.latest/configuration.html#manifest
[modulepath_setting]: /references/3.5.latest/configuration.html#modulepath
[config_print]: ./config_print.html
[env_var]: ./lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master
[config_file_envs_sections]: ./environments_classic.html#environment-config-sections
[v1 api]: /references/3.5.latest/developer/file.http_api_index.html#V1_API_Services
[http_api]: /references/3.5.latest/developer/file.http_api_index.html
[auth.conf file]: ./config_file_auth.html

Environments are isolated groups of puppet agent nodes. A puppet master server can serve each environment with completely different [main manifests][manifest_dir] and [modulepaths][modulepath].

This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)


> Directory Environments vs. Config File Environments
> -----
>
> There are two ways to set up environments on a puppet master: **directory environments,** and [**config file environments.**][config_file_envs]
>
> This page is about directory environments, which are easier to use and will eventually replace config file environments completely. However, in Puppet 3.5, they cannot:
>
> - Set [`config_version`][config_version] per-environment
> - Change the order of the `modulepath` or remove parts of it
>
> Those features are coming in Puppet 3.6.

Setting Up Environments on a Puppet Master
-----

A directory environment is just a directory that follows a few conventions:

* The directory name is the environment name.
* It should contain a `modules` directory and a `manifests` directory. (These are allowed to be empty or absent; see sections below for details.)
* It must be located in a directory that the puppet master searches for environments. (By default, that's `$confdir/environments`. [See below for more info about this directory,](./environments.html#the-environmentpath) including how to search additional directories.)

<!-- TODO replace the following with an image -->

    $confdir
     \- environments
         |- production
         |   |- modules
         |   |   |- apache
         |   |   |- stdlib
         |   |   \- ...
         |   \- manifests
         |       \- site.pp
         |- test
         |   |- modules
         |   |   \- ...
         |   \- manifests
         |       \- site.pp
      ...

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

### The `environmentpath`

The puppet master will only look for environments in certain directories. By default, it will only search `$confdir/environments`. ([See here for info on the confdir][confdir].)

If you need to keep environments in multiple directories, you can configure them with [the `environmentpath` setting][environmentpath]. Its value should be a colon-separated list of directories. (For example: `$confdir/temporary_environments:$confdir/environments`.) Puppet will search these directories in order, with earlier directories having precedence.

### Interaction with Config File Environments

If you've accidentally configured the same environment in multiple ways (see [the page on config file environments][config_file_envs]), the precedence goes like this:

Config sections → directory environments → dynamic (`$environment`) environments

If an [environment config section][config_file_envs_sections] exists for the active environment, Puppet will **ignore the directory environment** it would have otherwise used. This means it will use the standard [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings to serve nodes in that environment. If values for those settings are specified in the environment config section, those will be used; otherwise, Puppet will use the global values.

If the global values for the [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings use the `$environment` variable, they will only be used when a directory environment **doesn't** exist for the active environment.

### Unconfigured Environments

If a node is assigned to an environment which doesn't exist --- that is, there is no directory of that name in any of the `environmentpath` directories and a [config file environment][config_file_envs] isn't configured --- the puppet master will use the global [`manifest`][manifest_setting] and [`modulepath`][modulepath_setting] settings to serve that node.


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

Internals: Environments in Puppet's HTTPS Requests
-----

Puppet's agent and master applications communicate via an HTTP API. All of the URLs used today by puppet agent (the [v1 API][]) start with an environment. See the [HTTP API reference][http_api] for details.

For some endpoints, making a request "in" an environment is meaningless; for others, it influences which modules and manifests the configuration data will come from. Regardless, the API dictates that an environment always be included.

Endpoints where the requested environment can be overridden by the ENC/node terminus:

- [Catalog](/references/3.5.latest/developer/file.http_catalog.html) --- For this endpoint, the environment is just a request, as described above in the section on assigning nodes to environments; if the ENC specifies an environment for the node, it will override the environment in the request.

Endpoints where the requested environment is always used:

- [File content](/references/3.5.latest/developer/file.http_file_content.html) and [file metadata](/references/3.5.latest/developer/file.http_file_metadata.html) --- Files in modules, including plugins like custom facts and resource types, will always be served from the requested environment. Puppet agent has to account for this when fetching files; it does so by fetching its node object (see "node" below), then resetting the environment it will request to whatever the ENC specified and using that new environment for all subsequent requests. (Since custom facts might influence the decision of the ENC, the agent will repeat this process up to three times before giving up.)
- [Resource type](/references/3.5.latest/developer/file.http_resource_type.html) --- Puppet agent doesn't use this; it's just for extensions. The puppet master will always respond with information for the requested environment.

Endpoints where environment makes no difference:

- [File Bucket File](/references/3.5.latest/developer/file.http_file_bucket_file.html) --- There's only one filebucket.)
- [Report](/references/3.5.latest/developer/file.http_report.html) --- Reports already contain environment info, and each report handler can decide what, if anything, to do with it.)
- [Facts](/references/3.5.latest/developer/file.http_facts.html) --- Puppet agent doesn't actually use this endpoint. When used as the inventory service, environment has no effect.)
- [Node](/references/3.5.latest/developer/file.http_node.html) --- Puppet agent uses this to learn whether the master's ENC has overridden its preferred environment. Theoretically, a node terminus could use the environment of the first node object request to decide whether to override the environment, but we're not aware of anyone doing that and there wouldn't seem to be much point to it.)
- [Status](/references/3.5.latest/developer/file.http_status.html)
- [Certificate](/references/3.5.latest/developer/file.http_certificate.html), [certificate signing request](/references/3.5.latest/developer/file.http_certificate_request.html), [certificate status](/references/3.5.latest/developer/file.http_certificate_status.html), and [certificate revocation list](/references/3.5.latest/developer/file.http_certificate_revocation_list.html) --- The CA doesn't differ by environment.)

### Controlling HTTPS Access Based on Environment

The puppet master's [auth.conf file][] can use the environment of a request to help decide whether to authorize a request. This generally isn't necessary or useful, but it's there if the need arises. See the [auth.conf documentation][auth.conf file] for details.

Querying Environment Info via the Master's HTTP API
-----

If you are extending Puppet and need a way to query information about the available environments, you can do this via the [environments endpoint.][env_endpoint] (This endpoint uses the new [v2 HTTP API.][v2_api])

This _only works for directory environments._ When you query environments via the API, any [config file environments][config_file_envs] will be omitted.

For more details, see [the reference page about the environments endpoint.][env_endpoint]

[v2_api]: /references/3.5.latest/developer/file.http_api_index.html#V2_HTTP_API
[env_endpoint]: /references/3.5.latest/developer/file.http_environments.html

Limitations of Environments
-----

### Plugins Running on the Puppet Master are Weird

Puppet modules can contain Puppet code, templates, file sources, and Ruby plugin code (in the `lib` directory). Environments work perfectly with most of those, but there's a lingering problem with plugins.

The short version is: any plugins destined for the _agent node_ (e.g. custom facts and custom resource providers) will work fine, but plugins to be used by the _puppet master_ (functions, resource types, report processers, indirector termini) can get mixed up, and you won't be able to control which version the puppet master is using. So if you need to do testing while developing custom resource types or functions, you may need to spin up a second puppet master, since environments won't be reliable.

This has to do with the way Ruby loads code, and we're not sure if it can be fixed given Puppet's current architecture. (Some of us think this would require separate Ruby puppet master processes for each environment, which isn't currently practical with the way Rack manages Puppet.)

If you're interested in the issue, it's being tracked as [PUP-731](https://tickets.puppetlabs.com/browse/PUP-731).

### Hiera Configuration Can't be Specified Per Environment

Puppet will only use a global [hiera.yaml](./config_file_hiera.html) file; you can't put per-environment configs in an environment directory.

When using the built-in YAML or JSON backends, it _is_ possible to separate your Hiera data per environment; you will need to interpolate [the `$environment` variable][inpage_env_var] into [the `:datadir` setting.](/hiera/latest/configuring.html#yaml-and-json) (e.g. `:datadir: /etc/puppet/environments/%{::environment}/hieradata`)

### Most Extensions Aren't Environment-Aware

As of today, most extensions to Puppet (including PuppetDB and the Puppet Enterprise console) don't receive, store, or control information about Puppet's use of environments.

We're in the process of working on this; one of the most important steps was adding the ability to query the master for environment info, as mentioned above.

### Exported Resources Can Conflict or Cross Over

Nodes in one environment can accidentally collect resources that were exported from another environment, which causes problems --- either a compilation error due to identically titled resources, or creation and management of unintended resources.

Right now, the only solution is to run multiple puppet masters if you heavily use exported resources. We're working on making PuppetDB environment-aware, which will fix the problem in a more permanent way.


Suggestions for Use
-----

The main uses for environments tend to fall into a few categories. A single group of admins might use several of them for different purposes.

### Permanent Test Environments

In this pattern, you have a relatively stable group of test nodes in a permanent `test` environment, where all changes must succeed before they can be merged into your production code.

The test nodes probably closely resemble the whole production infrastructure in miniature. They might be short-lived cloud instances, or longer-lived VMs in a private cloud. They'll probably stay in the `test` environment for their whole lifespan.

### Temporary Test Environments

In this pattern, developers and admins can create temporary environments to test out a single change or group of changes. This usually means doing a fresh checkout from your version control into the `$confdir/environments` directory, where it will be detected as a new environment. These environments might have descriptive names, or might just use the commit IDs from the version of the code they're based on.

Temporary environments are good for testing individual changes, especially if you need to iterate quickly while developing them. Since it's easy to create many of them, you don't have to worry about coordinating with other developers and admins the way you would with a monolithic `test` environment; everyone can have a personal environment for their current development work.

Once you're done with a temporary environment, you can delete it. Usually, the nodes in a temporary environment will be short-lived cloud instances or VMs, which can be destroyed when the environment ends; otherwise, you'll need to move the nodes back into a stable environment.

### Divided Infrastructure

If parts of your infrastructure are managed by different teams that don't need to coordinate their code, it may make sense to split them into environments.
