---
layout: default
title: "Installing modules"
---

[forge]: https://forge.puppet.com
[module_man]: ./man/module.html
[modulepath]: ./dirs_modulepath.html
[codedir]: ./dirs_codedir.html


[publishing]: ./modules_publishing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: ./plugins_in_modules.html
[documentation]: ./modules_documentation.html
[errors]: {{pe}}/troubleshooting_windows.html#error-messages
[metadata.json]: ./modules_metadata.html

[code_mgr]: {{pe}}/code_mgr.html
[r10k]: {{pe}}/r10k.html
[puppetfile]: {{pe}}/cmgmt_puppetfile.html

[approved]: https://forge.puppet.com/approved
[supported]: https://forge.puppet.com/supported
[score]: /forge/assessingmodulequality.html
[environment]: ./environments.html

This page explains how to install and manage modules using the `puppet module` command.

* [See "Module Fundamentals"][fundamentals] to learn how to use and write Puppet modules.
* [See "Publishing Modules"][publishing] to learn how to contribute your own modules to the Forge, including information about the Puppet module tool's `build` and `generate` actions.
* [See "Module Metadata"][metadata.json] for information about the metadata.json file.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and how to sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and best practices for documenting your module.

## About `puppet module`

The [Puppet Forge][forge] is a repository of modules written both by Puppet and by the Puppet user community. These modules solve a wide variety of problems, and using them can save you time and effort.

The `puppet module` tool provides a command line interface for managing modules from the Forge. Its interface is similar to several common package managers (such as `gem`, `apt-get`, or `yum`). You can use the `puppet module` command to search for, install, and manage modules.

> **Important:** If you are using [Code Manager][code_mgr] or [r10k][r10k], do not use the `puppet module` command to install or manage modules. Instead, use a [Puppetfile][puppetfile] to manage modules in your environments. In particular, note that Code Manager purges modules that were installed to the live code directory with the `puppet module` command.


> **Solaris Note:** To use `puppet module` commands on Solaris systems, you must first install gtar.

### Using `puppet module` behind a proxy

To use the `puppet module` command behind a proxy, set the following, replacing `<PROXY IP>` and `<PROXY PORT>` with the proxy's IP address and port:

```
export http_proxy=http://<PROXY IP>:<PROXY PORT>
export https_proxy=http://<PROXY IP>:<PROXY PORT>
```

For instance, with an HTTP proxy at 192.168.0.10 on port 8080, set:

```
export http_proxy=http://192.168.0.10:8080
export https_proxy=http://192.168.0.10:8080
```

Alternatively, you can set these two proxy settings inside the `[user]` config section in the `puppet.conf` file: `http_proxy_host` and `http_proxy_port`. For more information, see [the configuration reference](./configuration.html#httpproxyhost).

> **Important:** Make sure to set these two proxy settings in the `user` section only. Otherwise, there can be adverse effects.

## Finding Forge modules

You can find modules by browsing the [Puppet Forge][forge] on the web or by using the module tool's [`search`](#search-modules-from-the-command-line) action.

The Forge houses thousands of modules, including Puppet **supported** or **approved** modules. Puppet [approved][approved] modules pass our specific quality and usability requirements. These modules are recommended by Puppet, but are not supported as part of a Puppet Enterprise license agreement. Puppet [supported][supported] modules have been tested with Puppet Enterprise and are fully supported by Puppet. If there are no supported or approved modules for what you want to do, evaluate available modules by [score][score], compatibility, documentation, last release date, and number of downloads.

### Search modules from the command line

The search action accepts a single search term and returns a list of modules whose names, descriptions, or keywords match the search term.

```
$ puppet module search apache
Searching http://forge.puppetlabs.com ...
NAME                           DESCRIPTION            AUTHOR          KEYWORDS
puppetlabs-apache              This is a generic ...  @puppetlabs     apache web
puppetlabs-passenger           Module to manage P...  @puppetlabs     apache
DavidSchmitt-apache            Manages apache, mo...  @DavidSchmitt   apache
jamtur01-httpauth              Puppet HTTP Authen...  @jamtur01       apache
jamtur01-apachemodules         Puppet Apache Modu...  @jamtur01       apache
adobe-hadoop                   Puppet module to d...  @adobe          apache
```

Once you've identified the module you want, you can install it.

## Installing modules

The `puppet module install` action installs a module and all of its dependencies. By default, it installs into the first directory in Puppet's [modulepath][], which defaults to `$codedir/environments/production/modules`. (See also: [more about the modulepath][modulepath] and [how to find the codedir][codedir].)

```bash
sudo puppet module install puppetlabs-apache
```

This command accepts the following options:

* Use the `--target-dir` option to specify a different directory for installation. Relatedly:
    * Use the `--environment` option to install into a different [environment][]. (Each environment has its own modulepath, which is used to calculate dependencies and choose a default value for `--target-dir`.)
    * Use the `--modulepath` option to manually specify a modulepath, instead of using an environment's.
* Use the `--version` option to specify a version of the module. You can use an exact version or a requirement string like `>=1.0.3`.
* Use the `--force` option to forcibly install a module or re-install an existing module. (**Note:** Does not install dependencies.)
* Use the `--ignore-dependencies` option to skip installing any modules required by this module.
* Use the `--debug` option to see additional information about what the Puppet module tool is doing.

> **Note: Invalid Version Warnings**
>
> If any installed module has an invalid version number (anything other than major.minor.patch), Puppet issues the following warning whenever you install a module:
>
> `Warning: module (/Users/youtheuser/.puppet/modules/module) has an invalid version number (0.1). The version has been set to 0.0.0. If you are the maintainer for this module, please update the metadata.json with a valid Semantic Version (http://semver.org).`
>
> Despite the warning, Puppet still downloads your module and does not permanently change the offending module's metadata. The version is only changed in memory during the run of the program, in order to calculate dependencies for the modules you're installing.

### Install from the Puppet Forge

To install a module from the Puppet Forge, identify the module you want by its full name. The full name of a Forge module is formatted as username-modulename.

``` bash
sudo puppet module install puppetlabs-apache
```

### Install from another module repository

The module tool can install modules from other repositories that mimic the Forge's interface. To do this, change the [`module_repository`](./configuration.html#modulerepository) setting in [`puppet.conf`](./config_file_main.html) or specify a repository on the command line with the `--module_repository` option. The value of this setting should be the base URL of the repository; the default value, which uses the Forge, is `https://forgeapi.puppetlabs.com`.

After setting the repository, follow the instructions above for installing from the Forge.

``` bash
sudo puppet module install --module_repository http://dev-forge.example.com puppetlabs-apache
```

### Install from a release tarball

To install a module from a release tarball, specify the path to the tarball instead of the module name.

If you cannot connect to the Puppet Forge, or you are installing modules that have not yet been published to the Forge, use the `--ignore-dependencies` flag. In this case, you must manually install any dependencies.

``` bash
sudo puppet module install ~/puppetlabs-apache-0.10.0.tar.gz --ignore-dependencies
```

> **Note:** You can manually install modules without the `puppet module` tool. If you do, you must name your module's directory appropriately. Module directory names can only contain letters, numbers, and underscores. Dashes and periods are **not valid** and cause errors when attempting to use the module.

### Install Puppet Enterprise modules

We publish some premium modules exclusively for Puppet Enterprise users. To install a [Puppet Enterprise module](/forge/puppetenterprisemodules) you must:

* Be logged in as the root user.
* Use the [Puppet module tool](#about-puppet-module) (unless you are using a [Puppetfile][puppetfile].
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.

After you've run `puppet module install puppetlabs-<MODULE>` you can move the installed module to the directory, server, or version control system repository of your choice.

If you need to install a PE-only module on a PE node that doesn't have internet access, move the package:

1. Run `puppet module install puppetlabs-<MODULE>` on a licensed node with internet access.
2. Run `puppet module build` to build the newly-installed module.
3. Move the *.tar.gz wherever you choose.
4. Run `puppet module install` against the tar.gz.

As mentioned in the instructions for [installing from a tarball](#install-from-a-release-tarball), when installing on a node without internet access, you must manually install any dependencies.

## Managing modules

### List installed modules

Use the module tool's `list` action to see which modules you have installed (and which directory they're installed in).

* Use the `--tree` option to view the modules arranged by dependency instead of by location on disk.

### Upgrade modules

Use the module tool's `upgrade` action to upgrade an installed module to the latest version. You must identify the target module by its full name (username-modulename).

* Use the `--version` option to specify a version.
* Use the `--ignore-changes` option to upgrade the module while ignoring and overwriting any local changes that might have been made.
* Use the `--ignore-dependencies` option to skip upgrading any modules required by this module.

### Uninstall modules

Use the module tool's `uninstall` action to remove an installed module. You must identify the target module by its full name  (username-modulename).

```
$ sudo puppet module uninstall apache
Error: Could not uninstall module 'apache':
  Module 'apache' is not installed
      You may have meant `puppet module uninstall puppetlabs-apache`
$ sudo puppet module uninstall puppetlabs-apache
Removed /etc/puppetlabs/code/modules/apache (v0.0.3)
```

By default, the tool won't uninstall a module that other modules depend on, or whose files have been edited since it was installed.

* Use the `--force` option to uninstall even if the module is depended upon or has been manually edited.
* Use the `--ignore-changes` option to uninstall the module while ignoring and overwriting any local changes that might have been made.

### Managing Puppet Enterprise modules

If you manage Puppet Enterprise modules with [librarian-puppet](https://github.com/rodjek/librarian-puppet), you must first [install the module](#install-puppet-enterprise-modules), and then commit the module to your version control repository.

To upgrade your Puppet Enterprise module, as with installation, you must:

* Be logged in as the root user.
* Use the [Puppet module tool](#about-puppet-module).
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.

## Reference: `puppet module` actions

View a full description of each action with `puppet man module` or by [viewing the man page online][module_man]. The main actions of the `puppet module` command are:

#### `install`

Installs a module from either the Forge or a release archive.

``` bash
sudo puppet module install puppetlabs-apache --version 0.0.2
```

Accepts the following options:

* `--target-dir`: Specify a different directory for installation.
* `--environment`: Install into a different [environment][].
* `--modulepath`: Specify a different modulepath.
* `--version`: Specify a version of the module. Accepts an exact version or a requirement string like `>=1.0.3`.
* `--force`: Forcibly install a module or re-install an existing module. (**Note:** Does not install dependencies.)
* `--ignore-dependencies`: Skips installing any modules required by this module.
* `--debug`: Displays additional information about what `puppet module` is doing.

#### `list`

Lists installed modules.

``` bash
sudo puppet module list
```

#### `search`

Searches the Forge for a module.

``` bash
sudo puppet module search apache
```

#### `uninstall`

Uninstalls a Puppet module.

``` bash
sudo puppet module uninstall puppetlabs-apache
```

#### `upgrade`

Upgrades a Puppet module.

``` bash
sudo puppet module upgrade puppetlabs-apache --version 0.0.3
```

## Common errors

### Puppet Enterprise module errors

When installing or upgrading a Puppet Enterprise module, you might receive an error like the following:

```
Error: Request to Puppet Forge failed.
  The server being queried was https://forgeapi.puppetlabs.com/v3/releases?module=puppetlabs-f5&module_groups=base+pe_only
  The HTTP response we received was '403 Forbidden'
  The message we received said 'You must have a valid Puppet Enterprise license on this node in order to download puppetlabs-f5. If you have a Puppet Enterprise license, please see https://docs.puppetlabs.com/pe/latest/modules_installing.html#puppet-enterprise-modules for more information.'
```

If you aren't a Puppet Enterprise user, you won't be able to use this module unless you purchase [Puppet Enterprise](https://puppetlabs.com/puppet/puppet-enterprise).

If you are a Puppet Enterprise user, check the following:

1. Are you logged in as the root user? If not, log in as root and try again.
2. Are you using either the `puppet module install` or `puppet module upgrade` command? If not, you must use the Puppet module subcommands to install or upgrade Puppet Enterprise modules.
3. Does the node you're on have a valid Puppet Enterprise license? If not, switch to a node that has a valid PE license on it.
4. Are you running a version of Puppet Enterprise that supports this module? If not, you might need to upgrade.
5. Do you have access to the internet on the node? If not, you need to switch to a node that has access to the internet.
6. If you are using r10k, is it running from `/opt/puppetlabs/bin/r10k`? If not, run r10k  from that location.


