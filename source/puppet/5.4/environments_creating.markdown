---
layout: default
title: "Creating Environments"
---

[config_print]: ./config_print.html
[env_conf_path]: ./environments_configuring.html#environmentpath
[enable_dirs]: ./environments_configuring.html
[assign]: ./environments_assigning.html
[about]: ./environments.html
[manifest_dir]: ./dirs_manifest.html
[environment.conf]: ./config_file_environment.html
[modulepath]: ./dirs_modulepath.html
[puppet.conf]: ./config_file_main.html
[basemodulepath]: ./configuration.html#basemodulepath
[default_manifest]: ./configuration.html#defaultmanifest
[disable_per_environment_manifest]: ./configuration.html#disableperenvironmentmanifest
[hiera.yaml]: ./hiera_config_yaml_5.html
[writingenc]: ./nodes_external.html
[environments_r10k]: {{pe}}/r10k_run.html
[environment_code_repository]: {{pe}}/cmgmt_control_repo.html
[Using Environment Data]: {{pe}}/lookup_quick.html#using-environment-data

{:.concept}
## Environment structure

An environment is a branch that gets turned into a directory on your Puppet master. They follow several conventions.

When you create an environment, you give it the following structure:

* It contains a `modules` directory, which becomes part of the environment’s default module path.

* It contains a `manifests` directory, which will be the environment’s default main manifest.

* If you are using Puppet 5, it can optionally contain a `hiera.yaml` file.

* It can optionally contain an `environment.conf` file, which can locally override configuration settings, including `modulepath` and `manifest`.

> Note: Environment names can contain lowercase letters, numbers, and underscores. They must match the following regular expression rule: \A[a-z0-9_]+\Z

> Note: If you are using Hiera/puppet 5, remove the environment_data_provider setting. See link to using environment data for more information.

 Related topics: [Using environment data][Using Environment Data]

{:.concept}
## Environment resources

An environment specifies resources that the Puppet master will use when compiling catalogs for agent nodes. The `modulepath`, the main manifest, hiera data, and the config version script, can all be specified in `environment.conf`.

### The `modulepath`

* The `modulepath` is the list of directories Puppet will load modules from.

* By default, Puppet will load modules first from the environment’s `modules` directory, and second from the master’s `puppet.conf` file’s `basemodulepath` setting, which can be multiple directories.

* If the modules directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`.

Related topics: [The modulepath (default config)][modulepath]

### The main manifest

* The main manifest is Puppet’s starting point for compiling a catalog.

* Unless you say otherwise in `environment.conf`, an environment will use Puppet’s global `default_manifest` setting to determine its main manifest.

* The value of this setting can be an absolute path to a manifest that all environments will share, or a relative path to a file or directory inside each environment.
* The default value of `default_manifest` is `./manifests` -  the environment’s own manifests directory.

* If the file or directory specified by `default_manifest` is empty or absent, Puppet will not fall back to any other manifest. Instead, it behaves as if it is using a blank main manifest. If you specify a value for this setting, the global manifest setting from `puppet.conf` will not be used by an environment.

Related topics: [main manifest][manifest_dir], [environment.conf][environment.conf], [default_manifestsetting][default_manifest], [puppet.conf][puppet.conf].

### Hiera data

* Each environment can use its own Hiera hierarchy and provide its own data.

Related topics: [Hiera: Config file syntax][hiera.yaml].

### The config version script

* Puppet automatically adds a config version to every catalog it compiles, as well as to messages in reports. The version is an arbitrary piece of data that can be used to identify catalogs and events.

* By default, the config version will be the time at which the catalog was compiled (as the number of seconds since January 1, 1970).

### The environment.conf file

* An environment can contain an `environment.conf` file, which can override values for certain settings.

* The `environment.conf` file overrides these settings:
	* `modulepath`
	* `manifest`
	* `config_version`
	* `environment_timeout`

Related topics: [environment.conf][environment.conf]


{:.task}
## Create an environment

Environments are turned on by default. Create an environment by adding a new directory of configuration data.

To create a new environment:

1. Inside your code directory, create a directory called `environments`.
2. Inside the `environments` directory, create a directory with the name of your new environment using the structure: `$codedir/environments/`
3. Create a `modules` directory and a `manifests` directory. These two directories will contain your Puppet code.


### Additional steps

Configure a `modulepath`:

1. Set `modulepath` in its `environment.conf` file (If you set a value for this setting, the global `modulepath` setting from `puppet.conf` will not be used by an environment).

2. Check the `modulepath` by specifying the environment when requesting the setting value:
   `$ sudo puppet config print modulepath --section master --environment test /etc/puppetlabs/code/environments/test/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules`

> Note: In Puppet Enterprise, every environment must include `/opt/puppetlabs/puppet/modules` in its `modulepath`, since PE uses modules in that directory to configure its own infrastructure.


Configure a main manifest:

1. Set manifest in its `environment.conf` file. As with the global `default_manifest` setting, you can specify a relative path (to be resolved within the environment’s directory) or an absolute path.
2. Lock all environments to a single global manifest with the `disable_per_environment_manifest` setting - preventing any environment setting its own main manifest.

To specify an executable script that will determine an environment’s config version:

1. Specify a path to the script in the `config_version` setting in its `environment.conf` file. Puppet runs this script when compiling a catalog for a node in the environment, and uses its output as the config version (if you specify a value here, the global `config_version` setting from `puppet.conf` will not be used by an environment).

> Note: If you’re using a system binary like git `rev-parse`, make sure to specify the absolute path to it. If `config_version` is set to a relative path, Puppet will look for the binary in the environment, not in the system’s PATH.

Related topics: [Deploying environments with r10k][environments_r10k], [Code Manager control repositories] [environment_code_repository], [disable_per_environment_manifest] [disable_per_environment_manifest].


{:.task}
## Assign nodes to environments via an ENC

You can assign agent nodes to environments by using an external node classifier (ENC). By default, all nodes are assigned to a default environment named production.

The interface to set the environment for a node will be different for each ENC. Some ENCs cannot manage environments. When writing an ENC:

1. Ensure that the `environment` key is set in the YAML output that the ENC returns. If the `environment` key isn’t set in the ENC’s YAML output, the Puppet master will use the environment requested by the agent.

> Note: The value from the ENC is authoritative, if it exists. If the ENC doesn’t specify an environment, the node’s config value is used.

Related topics: [writing ENCs][writingenc]

{:.task}
## Assign nodes to environments via the agent’s config file

You can assign agent nodes to environments by using the agent’s config file. By default, all nodes are assigned to a default environment named production.

Configure an agent to use an environment by editing the agent’s `puppet.conf` file:

1. Open the agent's `puppet.conf` file in an editor.
2. Find the `environment` setting in either the agent or main section.
3. Set the value of the `environment` setting to the name of the environment you want the agent to be assigned to.


When that node requests a catalog from the Puppet master, it will request that environment. If you are using an ENC and it specifies an environment for that node, it will override whatever is in the config file.

> Note: Nodes can’t be assigned to unconfigured environments. If a node is assigned to an environment that doesn’t exist —  no directory of that name in any of the environment path directories — the Puppet master will fail to compile its catalog. The one exception to this is if the default production environment doesn’t exist. In this case, the agent will successfully retrieve an empty catalog.


{:.reference}
## Global settings for configuring environments

The settings in the master’s `puppet.conf` file configure how Puppet finds and uses environments.

### `environmentpath`

* `environmentpath` is the list of directories where Puppet will look for environments. The default value for `environmentpath` is `$codedir/environments`.
* If you have more than one directory, separate them by colons and put them in order of precedence. In this example, `temp_environments` will be searched before `environments`:
  `$codedir/temp_environments:$codedir/environments`
* If environments with the same name exist in both paths, Puppet uses the first environment with that name that it encounters.
* Put the `environmentpath` setting in the main section of the `puppet.conf` file.


### `basemodulepath`

* `basemodulepath` lists directories of global modules that all environments can access by default.
* Some modules can be made available to all environments.
* The `basemodulepath` setting configures the global module directories. By default, it includes `$codedir/modules` for user-accessible modules and `/opt/puppetlabs/puppet/modules` for system modules.
* Add additional directories containing global modules by setting your own value for `basemodulepath`.

Related topics: [modulepath][modulepath].


### `default_manifest`

* `default_manifest` specifies the main manifest for any environment that doesn’t set a manifest value in `environment.conf`.
* The default value of `default_manifest` is `./manifests` - the environment’s own manifests directory.
* The value of this setting can be:
	* An absolute path to one manifest that all environments will share
	* A relative path to a file or directory inside each environment’s directory

Related topics: [default_manifest setting][default_manifest].

### `disable_per_environment_manifest`

* `disable_per_environment_manifest` lets you specify that all environments use a shared main manifest.
* When `disable_per_environment_manifest` is set to true, Puppet will use the same global manifest for every environment.
* If an environment specifies a different manifest in `environment.conf`, Puppet will not compile catalogs nodes in that environment, to avoid serving catalogs with potentially wrong contents.
* If this setting is set to true, the `default_manifest` value must be an absolute path.


### `environment_timeout`

* `environment_timeout` sets how often the Puppet master refreshes information about environments. It can be overridden per-environment.
* This setting defaults to 0 (caching disabled), which lowers the performance of your Puppet master but makes it easy for new users to deploy updated Puppet code.
* Once your code deployment process is mature, change this setting to unlimited.


{:.task}
## Configuring `environment_timeout`

`enviroment_timeout` is how often the Puppet master should cache the data it loads from an environment. For best performance, change the settings once you have a mature code deployment process.

1. Set `environment_timeout = unlimited` in `puppet.conf`.
2. Change your code deployment process to refresh the Puppet master whenever you deploy updated code. (For example, set a postrun command in your r10k config or add a step to your continuous integration job.)
* With Puppet Server, refresh environments by calling the `environment-cache` API endpoint. Ensure you have write access to the puppet-admin section of the `puppetserver.conf` file.
* With a Rack Puppet master, restart the web server or the application server. Passenger lets you touch a `restart.txt` file to refresh an application without restarting Apache. See the Passenger docs for details.

The `environment-timeout` setting can be overridden per-environment in `environment.conf`.

> Note: Only use the value 0 or unlimited. Most Puppet masters use a pool of Ruby interpreters, which all have their own cache timers. When these timers are out of sync, agents can be served inconsistent catalogs. To avoid that inconsistency, refresh the Puppet master when deploying.
