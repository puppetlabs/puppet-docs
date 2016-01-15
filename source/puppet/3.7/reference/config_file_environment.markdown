---
layout: default
title: "Config Files: environment.conf"
canonical: "/puppet/latest/reference/config_file_environment.html"
---

[directory environments]: ./environments.html
[environmentpath]: ./environments.html#about-environmentpath
[modulepath]: ./configuration.html#modulepath
[puppet.conf]: ./config_file_main.html
[basemodulepath]: ./configuration.html#basemodulepath
[main manifest]: ./dirs_manifest.html
[configuring_timeout]: ./environments_configuring.html#environmenttimeout

When using [directory environments][], each environment may contain an `environment.conf` file. This file can override several settings whenever the Puppet master is serving nodes assigned to that environment.

## Location

Each environment.conf file should be stored in a [directory environment][directory environments]. It should be at the top level of its home environment, next to the `manifests` and `modules` directories.

For example: if your [`environmentpath` setting][environmentpath] is set to `$confdir/environments`, the environment.conf file for the `test` environment should be located at `$confdir/environments/test/environment.conf`.

## Example

    # /etc/puppetlabs/puppet/environments/test/environment.conf

    # Puppet Enterprise requires $basemodulepath; see note below under "modulepath".
    modulepath = site:dist:modules:$basemodulepath

    # Use our custom script to get a git commit for the current state of the code:
    config_version = get_environment_commit.sh

## Format

The environment.conf file uses the same INI-like format as [puppet.conf][], with one exception: it cannot contain config sections like `[main]`. All settings in environment.conf must be outside any config section.

### Relative Paths in Values

Most of the allowed settings accept **file paths** or **lists of paths** as their values.

If any of these paths are **relative paths** --- that is, they start _without_ a leading slash or drive letter --- they will be resolved relative to that environment's main directory.

For example:

* Environment directory: `/etc/puppetlabs/puppet/environments/test`
* Relative setting in environment.conf: `config_version = get_environment_commit.sh`
* Equivalent value for setting: `config_version = /etc/puppetlabs/puppet/environments/test/get_environment_commit.sh`

### Interpolation in Values

The settings in environment.conf can use the values of other settings as variables (e.g., `$confdir`). Additionally, the `config_version` setting can use the special `$environment` variable, which gets replaced with the name of the active environment. As of Puppet 3.7.1, you can interpolate `$environment` only into the `config_version` setting.

The most useful variables to interpolate into environment.conf settings are:

* `$basemodulepath` --- useful for including the default module directories in the `modulepath` setting. Puppet Enterprise users should usually include this in the value of `modulepath`, since PE uses modules in the `basemodulepath` to configure orchestration and other features.
* `$environment` --- useful as a command line argument to your `config_version` script. *You can interpolate this variable only in the `config_version` setting.*
* `$confdir` --- useful for locating files.

Allowed Settings
-----

{% partial ./_environment_conf_settings.md %}

### `modulepath`

The list of directories Puppet will load modules from. See [the reference page on the modulepath][modulepath] for more details about how Puppet uses it.

If this setting isn't set, the modulepath for the environment will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath] from [puppet.conf][], with the environment's modules getting priority. If the `modules` directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`. A directory environment will never use the global `modulepath` from [puppet.conf][].

[pe_reqs]: ./environments_creating.html#puppet-enterprise-requirements

### `manifest`

The [main manifest][] the Puppet master will use when compiling catalogs for this environment. This can be one file or a directory of manifests to be evaluated in alphabetical order. Puppet manages this path as a directory if one exists or if the path ends with a / or .

If this setting isn't set, Puppet will use the environment's `manifests` directory as the main manifest, even if it is empty or absent. A directory environment will never use the global `manifest` from [puppet.conf][].

### `parser`

Whether to use the 3.x parser (`current`) or the 4.x parser (`future`). If present, this will override the value of `parser` from [puppet.conf][].

This is useful when preparing for a migration to Puppet 4: you can switch a limited test environment to using the Puppet 4 version of the Puppet language, and catch any failures or behavior changes without affecting your main production environments.

More info: [full description of the `parser` setting.](./configuration.html#parser)

### `config_version`

A script Puppet can run to determine the configuration version.

Puppet automatically adds a **config version** to every catalog it compiles, as well as to messages in reports. The version is an arbitrary piece of data that can be used to identify catalogs and events.

You can specify an executable script that will determine an environment's config version by setting `config_version` in its environment.conf file. Puppet will run this script when compiling a catalog for a node in the environment, and use its output as the config version.

**Note:** If you're using a system binary like `git rev-parse`, make sure to specify the absolute path to it! If `config_version` is set to a relative path, Puppet will look for the binary _in the environment,_ not in the system's `PATH`.

If this setting isn't set, the config version will be the **time** at which the catalog was compiled (as the number of seconds since January 1, 1970). A directory environment will never use the global `config_version` from [puppet.conf][].

### `environment_timeout`

How long the Puppet master should cache the data it loads from an environment. If present, this will override the value of `environment_timeout` from [puppet.conf][].

* Unless you have a specific reason, we recommend only setting `environment_timeout` globally, in puppet.conf.
* We also don't recommend using any value other than `0` or `unlimited`.

For more information about configuring the environment timeout, [see the timeout section of the Configuring Environments page.][configuring_timeout]
