---
layout: default
title: "Creating Directory Environments"
---

[manifest_dir_dir]: ./dirs_manifest.html#directory-behavior-vs-single-file
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

Once you have [enabled directory environments][enable_dirs], you can:

* Create environments (as described on this page)
* [Assign environments to your nodes][assign]

For more info about what environments do, see [About Directory Environments.][about]


Structure of an Environment
-----

A directory environment is just a directory that follows a few conventions:

* The directory name is the environment name.
* It must be located on the Puppet master server(s) in one of the `environmentpath` directories, usually `$confdir/environments`. (See [the `environmentpath` section of the configuring environments page.][env_conf_path])
* It should contain a `modules` directory. If present, it will become part of the environment's default `modulepath`.
* It should contain a `manifests` directory, which will be the environment's default [main manifest.][manifest_dir]
* It may contain [an `environment.conf` file][environment.conf], which can locally override several settings, including `modulepath` and `manifest`.

![Diagram: A directory with four directory environments. Each directory environment contains a modules directory, a manifests directory, and an environment.conf file.](./images/environment_directories.jpg)

Puppet Enterprise Requirements
-----

[inpage_pe]: #puppet-enterprise-requirements

With Puppet Enterprise 3.3, **every** environment must meet two extra requirements.

### Filebucket Resource in Main Manifest

The [main manifest][manifest_dir] **must** contain the following snippet of Puppet code, which PE uses to back up file contents:

~~~ ruby
    # Define filebucket 'main':
    filebucket { 'main':
      server => '<YOUR SERVER HERE>',
      path   => false,
    }

    # Make filebucket 'main' the default backup location for all File resources:
    File { backup => 'main' }
~~~

You can accomplish this in one of two ways:

* Copy this code from the `/etc/puppetlabs/puppet/manifests/site.pp` file into some file in the `<ENVIRONMENT>/manifests` directory.
* If you aren't using the main manifest to assign configurations, you can set `manifest = $confdir/manifests` in [environment.conf][], to make all environments use the default site.pp as their main manifest.

### Modulepath Includes `/opt/puppet/share/puppet/modules`

The [modulepath][] **must** include the `/opt/puppet/share/puppet/modules` directory, since PE uses modules in that directory to configure orchestration and other features.

* If you **upgraded** to PE 3.3 instead of doing a fresh install, make sure to set `basemodulepath = $confdir/modules:/opt/puppet/share/puppet/modules` in [puppet.conf][]. This will include the system modules in the **default** modulepath for every environment.
* If you use [environment.conf][] to override the modulepath (see below), make sure it includes either `$basemodulepath` or `/opt/puppet/share/puppet/modules`.


Allowed Environment Names
-----

Environment names can contain lowercase letters, numbers, and underscores. That is, they must match the following regular expression:

`\A[a-z0-9_]+\Z`

Additionally, there are four forbidden environment names:

* `main`
* `master`
* `agent`
* `user`

These names can't be used because they conflict with the primary [config sections](./config_file_main.html#config-sections). **This can be a problem with Git,** because its default branch is named `master`. You may need to rename the `master` branch to something like `production` or `stable` (e.g. `git branch -m master production`).


What Environments Provide
-----

An environment can define three resources the Puppet master will use when compiling catalogs for agent nodes:

* The modulepath
* The main manifest
* The config version script


### The Modulepath

The **modulepath** is the list of directories Puppet will load modules from. See [the reference page on the modulepath][modulepath] for more details about how Puppet uses it.

#### The Default Modulepath

**By default,** the effective modulepath for a given environment will be:

    <MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath

That is, Puppet will add the environment's `modules` directory to the value of the [`basemodulepath` setting][basemodulepath] from [puppet.conf][], with the environment's modules getting priority. If the `modules` directory is empty or absent, Puppet will only use modules from directories in the `basemodulepath`.

#### Configuring the Modulepath

You can configure a different modulepath for an environment by setting `modulepath` in its [environment.conf][] file. Note that the global `modulepath` setting from [puppet.conf][] will never be used by a directory environment.

**Note:** If you are using Puppet Enterprise 3.3, you **must** ensure that `/opt/puppet/share/puppet/modules` is included in the modulepath. ([See above.][inpage_pe])

#### Checking the Modulepath

You can view an environment's effective modulepath by specifying the environment when [requesting the setting value][config_print]:

    $ sudo puppet config print modulepath --section master --environment test
    /etc/puppet/environments/test/modules:/etc/puppet/modules:/usr/share/puppet/modules


### The Main Manifest

The **main manifest** is Puppet's starting point for compiling a catalog. See [the reference page on the main manifest][manifest_dir] for more details.

#### The Default Main Manifest

**By default,** an environment's `manifests` directory is that environment's main manifest. Note that this uses the [directory-as-manifest behavior][manifest_dir_dir].

If the `manifests` directory is empty or absent, Puppet will **not** fall back to the default main manifest; instead, it will behave as though you used a totally blank main manifest.

#### Configuring the Main Manifest

You can configure a different main manifest for an environment by setting `manifest` in its [environment.conf][] file. This lets you use a global main manifest for all environments, or just specify a different manifests directory inside the environment. Note that the global `manifest` setting from [puppet.conf][] will never be used by a directory environment.

**Note:** If you are using Puppet Enterprise 3.3, you **must** ensure that the default filebucket resource is included in the main manifest. ([See above.][inpage_pe])

### The Config Version Script

Puppet automatically adds a **config version** to every catalog it compiles, as well as to messages in reports. The version is an arbitrary piece of data that can be used to identify catalogs and events.

#### The Default Config Version

By default, the config version will be the **time** at which the catalog was compiled (as the number of seconds since January 1, 1970).

#### Configuring the Config Version

You can specify an executable script that will determine an environment's config version by setting `config_version` in its [environment.conf][] file. Puppet will run this script when compiling a catalog for a node in the environment, and use its output as the config version. Note that the global `config_version` setting from [puppet.conf][] will never be used by a directory environment.


The `environment.conf` File
-----

An environment can contain an `environment.conf` file, which can override values for the following settings:

* `modulepath`
* `manifest`
* `config_version`
* `environment_timeout`

See [the page on `environment.conf` for more details.][environment.conf]

