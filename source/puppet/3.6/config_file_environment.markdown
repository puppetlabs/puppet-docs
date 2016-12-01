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


When using [directory environments][], each environment may contain an `environment.conf` file. This file can override several settings whenever the puppet master is serving nodes assigned to that environment.

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

The settings in environment.conf can the values of other settings as variables (e.g. `$confdir`). Additionally, they can use the special `$environment` variable, which gets replaced with the name of the active environment.

The most useful variables to interpolate into environment.conf settings are:

* `$basemodulepath` --- useful for including the default module directories in the `modulepath` setting. Puppet Enterprise users should usually include this in the value of `modulepath`, since PE uses modules in the `basemodulepath` to configure orchestration and other features.
* `$environment` --- useful for locating files, or as a command line argument to your `config_version` script.
* `$confdir` --- useful for locating files.

Allowed Settings
-----

In this version of Puppet, the environment.conf file is only allowed to override four settings:

* `modulepath`
* `manifest`
* `config_version`
* `environment_timeout`

### `modulepath`

The list of directories Puppet will load modules from. See [the reference page on the modulepath][modulepath] for more details about how Puppet uses it.

If this setting isn't set, the modulepath for the environment will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath] from [puppet.conf][], with the environment's modules getting priority. If the `modules` directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`. A directory environment will never use the global `modulepath` from [puppet.conf][].

**Note:** If you are using Puppet Enterprise 3.3, you **must** ensure that `/opt/puppet/share/puppet/modules` is included in the modulepath. ([See the note on the Creating Directory Environments page.][pe_reqs])

[pe_reqs]: ./environments_creating.html#puppet-enterprise-requirements

### `manifest`

The [main manifest][] the Puppet master will use when compiling catalogs for this environment. This can be one file or a directory of manifests to be evaluated in alphabetical order. Puppet manages this path as a directory if one exists or if the path ends with a / or .

If this setting isn't set, Puppet will use the environment's `manifests` directory as the main manifest, even if it is empty or absent. A directory environment will never use the global `manifest` from [puppet.conf][].

**Note:** If you are using Puppet Enterprise 3.3, you **must** ensure that the default filebucket resource is included in the main manifest. ([See the note on the Creating Directory Environments page.][pe_reqs])

### `config_version`

A script Puppet can run to determine the configuration version.

Puppet automatically adds a **config version** to every catalog it compiles, as well as to messages in reports. The version is an arbitrary piece of data that can be used to identify catalogs and events.

You can specify an executable script that will determine an environment's config version by setting `config_version` in its environment.conf file. Puppet will run this script when compiling a catalog for a node in the environment, and use its output as the config version.

If this setting isn't set, the config version will be the **time** at which the catalog was compiled (as the number of seconds since January 1, 1970). A directory environment will never use the global `config_version` from [puppet.conf][].

### `environment_timeout`

The time to live for a cached environment. This setting can be a time interval in seconds (30 or 30s), minutes (30m), hours (6h), days (2d), or years (5y). This setting can also be set to unlimited, which causes the environment to be cached until the master is restarted.

If this setting isn't set, Puppet will use the global `environment_timeout` from [puppet.conf][]. The default cache timeout is **three minutes.**

Most users should be fine with the default. To get more performance from your puppet master, you may want to tune the timeout for your most heavily used environments. Getting the most benefit involves a tradeoff between speed, memory usage, and responsiveness to changed files. The general best practice is:

- Long-lived, slowly changing, relatively homogenous, highly populated environments (like `production`) will give the most benefit from longer timeouts. You might be able to set this to hours, or `unlimited` if you're content to let cache stick around until your Rack server kills a given puppet master process.
- Rapidly changing dev environments should have short timeouts: a few seconds, or `0` if you don't want to wait.
- Sparsely populated environments should have short-ish timeouts, which are just long enough to help out if a cluster of nodes all hit the master at once, but won't clog your RAM with a bunch of rarely used data. Three minutes is fine.
- Extremely heterogeneous environments --- where you have a lot of modules and each node uses a different tiny subset --- will sometimes perform _worse_ with a long timeout. (This can cause excessive memory usage and garbage collection without giving back any performance boost.) Give these short timeouts of 5-10 seconds.
