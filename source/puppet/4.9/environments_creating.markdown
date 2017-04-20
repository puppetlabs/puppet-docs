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

For more info about what environments do, see [About Directory Environments.][about]


## Structure of an environment


An environment is just a directory that follows a few conventions:

* The directory name is the environment name.
* It must be located on the Puppet master server(s) in one of the `environmentpath` directories, usually `$codedir/environments`. (See [the `environmentpath` section of the configuring environments page.][env_conf_path])
* It should contain a `modules` directory. If present, it will become part of the environment's default `modulepath`.
* It should contain a `manifests` directory, which will be the environment's default [main manifest.][manifest_dir]
* It can contain a [`hiera.yaml` (v5) file][hiera.yaml] to configure data lookup.
* It can contain [an `environment.conf` file][environment.conf], which can locally override several settings, including `modulepath` and `manifest`.

![Diagram: A directory with four environments. Each environment contains a modules directory, a manifests directory, and an environment.conf file.](./images/environment_directories.svg)

## Allowed environment names


Environment names can contain lowercase letters, numbers, and underscores. That is, they must match the following regular expression:

`\A[a-z0-9_]+\Z`


## What environments provide


An environment can define three resources the Puppet master will use when compiling catalogs for agent nodes:

* The modulepath.
* The main manifest.
* Hiera data.
* The config version script.


### The modulepath

The **modulepath** is the list of directories Puppet will load modules from. See [the reference page on the modulepath][modulepath] for more details about how Puppet uses it.

#### The default modulepath

**By default,** the effective modulepath for a given environment will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath] from [puppet.conf][], with the environment's modules getting priority. If the `modules` directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`.

#### Configuring the modulepath

You can configure a different modulepath for an environment by setting `modulepath` in its [environment.conf][] file. Note that the global `modulepath` setting from [puppet.conf][] will never be used by an environment.

> **Note:** In Puppet Enterprise, **every** environment **must** include `/opt/puppetlabs/puppet/modules` in its modulepath, since PE uses modules in that directory to configure its own infrastructure.
>
> Environments already get this directory by default, since it's part of the default value of `basemodulepath`. Don't remove it from the `basemodulepath` setting, and if you override the modulepath in [environment.conf][], ensure your custom modulepath includes either `$basemodulepath` or `/opt/puppetlabs/puppet/modules`.

#### Checking the modulepath

You can view an environment's effective modulepath by specifying the environment when [requesting the setting value][config_print]:

    $ sudo puppet config print modulepath --section master --environment test
    /etc/puppetlabs/code/environments/test/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules


### The main manifest

The **main manifest** is Puppet's starting point for compiling a catalog. See [the reference page on the main manifest][manifest_dir] for more details.

#### The default main manifest

Unless you say otherwise in [environment.conf][], an environment will use Puppet's global [`default_manifest` setting][default_manifest] to determine its main manifest.

The value of this setting can be an **absolute path** to a manifest that all environments will share, or a **relative path** to a file or directory inside each environment.

The default value of `default_manifest` is `./manifests` --- that is, the environment's own `manifests` directory.

If the file or directory specified by `default_manifest` is empty or absent, Puppet will **not** fall back to any other manifest; instead, it will behave as though you used a totally blank main manifest. Note that the global `manifest` setting from [puppet.conf][] will never be used by an environment.


#### Configuring the main manifest

You can configure a different main manifest for an environment by setting `manifest` in its [environment.conf][] file.

As with the global `default_manifest` setting, you can specify a relative path (to be resolved within the environment's directory) or an absolute path.

#### Locking the main manifest

If you want to prevent any environment from setting its own main manifest, you can lock all environments to a single global manifest with [the `disable_per_environment_manifest` setting.][disable_per_environment_manifest] For details, see [the docs for this setting.][disable_per_environment_manifest]

### Hiera data

Each environment can use its own Hiera hierarchy and provide its own data. For more information, see the page about [Hiera's three config layers](./hiera_layers.html).

### The config version script

Puppet automatically adds a **config version** to every catalog it compiles, as well as to messages in reports. The version is an arbitrary piece of data that can be used to identify catalogs and events.

#### The default config version

By default, the config version will be the **time** at which the catalog was compiled (as the number of seconds since January 1, 1970).

#### Configuring the config version

You can specify an executable script that will determine an environment's config version by setting `config_version` in its [environment.conf][] file. Puppet will run this script when compiling a catalog for a node in the environment, and use its output as the config version. Note that the global `config_version` setting from [puppet.conf][] will never be used by an environment.

**Note:** If you're using a system binary like `git rev-parse`, make sure to specify the absolute path to it! If `config_version` is set to a relative path, Puppet will look for the binary _in the environment,_ not in the system's `PATH`.


## The `environment.conf` File

An environment can contain an `environment.conf` file, which can override values for certain settings.

{% partial ./_environment_conf_settings.md %}

See [the page on `environment.conf` for more details.][environment.conf]

