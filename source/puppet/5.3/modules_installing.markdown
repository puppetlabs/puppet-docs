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
[pdk]: {{pdk}}/pdk.html


Install, upgrade, list, and uninstall Forge modules from the command line with the `puppet module` command.

The `puppet module` command provides an interface for managing modules from the Puppet Forge. Its interface is similar to other common package managers, such as `gem`, `apt-get`, or `yum`. You can use install, upgrade, uninstall, list, and search for modules the `puppet module` command to search for, install, and manage modules.

> **Important:** If you are using [Code Manager][code_mgr] or [r10k][r10k], do not use the `puppet module` command. With code management, you must install modules with a Puppetfile. Code management purges modules that were installed with the `puppet module` command. See the [Puppetfile][puppetfile] documentation for instructions.

> **Solaris Note:** To use `puppet module` commands on Solaris systems, you must first install gtar.

{:.section}
### Using `puppet module` behind a proxy

To use the `puppet module` command behind a proxy, set the following, replacing `<PROXY IP>` and `<PROXY PORT>` with the proxy's IP address and port.

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

{:.concept}
## Finding Forge modules

The Puppet Forge houses thousands of modules, which you can find by browsing the Forge on the web or by using the `puppet module search` command.

Some Forge modules are Puppet **supported** or **approved** modules.

Puppet approved modules pass our specific quality and usability requirements. We recommend these modules, but they are not supported as part of a Puppet Enterprise license agreement. Puppet supported modules have been tested with Puppet Enterprise and are fully supported.

If there are no supported or approved modules that meet your needs, evaluate available modules by module score, compatibility, documentation, last release date, and number of downloads.

> To whitelist the Forge to interact with it, the IP is 52.10.130.237. This IP is subject to change without notice.

Related topics:

* [Approved modules][approved]
* [Supported modules][supported]
* [Module score][score]

{:.section}
### Searching modules from the command line

The `puppet module search` command accepts a single search term and returns a list of modules whose names, descriptions, or keywords match the search term.

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

When you've identified the module you want, you can then install it.

{:.concept}
## Installing modules from the command line

The `puppet module install` command installs a module and all of its dependencies. You can install modules from the Forge, a module repository, or a release tarball. 

By default, this command installs modules into the first directory in the Puppet [modulepath][], `$codedir/environments/production/modules` by default.

For example, to install the `puppetlabs-apache` module, run:

```bash
puppet module install puppetlabs-apache
```

This command accepts the following options:

Option   | Description
----------------|:---------------
`--target-dir` | Specifies a different directory for installation.
`--environment` | Installs the module into the specified environment.
`--modulepath` | Specifies a modulepath, instead of using an environment's default modulepath.
`--version` | Specifies the module version to install. You can use an exact version or a requirement string like `>=1.0.3`.
`--force` | Forcibly installs a module or re-install an existing module. Does **not** install dependencies.
`--ignore-dependencies` | Does not install any modules required by this module.
`--debug` | Displays additional information about what the `puppet module` command is doing.

> **Note: Invalid Version Warnings**
>
> If any installed module has an invalid version number (anything other than major.minor.patch), Puppet issues the following warning whenever you install a module:
>
> `Warning: module (/Users/youtheuser/.puppet/modules/module) has an invalid version number (0.1). The version has been set to 0.0.0. If you are the maintainer for this module, please update the metadata.json with a valid Semantic Version (http://semver.org).`
>
> Despite the warning, Puppet still downloads your module and does not permanently change the offending module's metadata. The version is changed only in memory during the run of the program, in order to calculate dependencies for the modules you're installing.

Related topics:

* [About the modulepath][modulepath]
* [About the codedir][codedir]

{:.section}
### Install modules from the Puppet Forge

To install a module from the Puppet Forge, use the `puppet module install` command with the full name of the module you want.

The full name of a Forge module is formatted as username-modulename. For example, to instal `puppetlabs-apache`:

``` bash
puppet module install puppetlabs-apache
```

{:.section}
### Installing from another module repository

The `puppet module` command can install modules from other repositories that mimic the Forge's interface. You can change the module repository for one installation, or you can change your default repository.

The normal default module repository is the Forge, so the default `module_repository` value is `https://forgeapi.puppetlabs.com`.

* To change the default module repository, edit the `module_repository` setting in `puppet.conf` to the base URL of the repository you want to use.

* To change the repository for a single module installation only, specify the base URL of the repository when you install the module. Use the `--module_repository` option to set this. For example:

``` bash
puppet module install --module_repository http://dev-forge.example.com puppetlabs-apache
```

Related topics:

* [The `module_repository` setting](./configuration.html#modulerepository)

{:.section}
### Installing from a release tarball

To install a module from a release tarball, specify the path to the tarball instead of the module name.

If you cannot connect to the Puppet Forge, or you are installing modules that have not yet been published to the Forge, use the `--ignore-dependencies` flag. In this case, you must manually install any dependencies.

``` bash
sudo puppet module install ~/puppetlabs-apache-0.10.0.tar.gz --ignore-dependencies
```

> **Note:** You can manually install modules without the `puppet module` command. If you do, you must name your module's directory appropriately. Module directory names can only contain letters, numbers, and underscores. Dashes and periods are **not valid** and cause errors when attempting to use the module.

{:.concept}
## Managing modules

The `puppet module` command can also list, upgrade, and uninstall modules.

{:.section}
### Listing installed modules

Use the `puppet module list` command to see which modules you have installed and which directory they're installed in.

To view the modules arranged by dependency instead of location on disk, use the `--tree` option.

{:.section}
### Upgrading modules

Use the `puppet module upgrade`command to upgrade an installed module to the latest version.

You must identify the target module by its full name, in the `username-modulename` format. The `puppet module upgrade` command has several options available:

* Use the `--version` option to specify a version.
* Use the `--ignore-changes` option to upgrade the module while ignoring and overwriting any local changes that might have been made.
* Use the `--ignore-dependencies` option to skip upgrading any modules required by this module.

{:.concept}
### Uninstalling modules

Use the `puppet module uninstall` command to remove an installed module.

You must identify the target module by its full name, in the `username-modulename` format.

By default, the tool won't uninstall a module that other modules depend on, or whose files have been edited since it was installed.

* To force an uninstall even if the module is a dependency or has been manually edited, use the `--force` option.
* To uninstall the module while ignoring and overwriting any local changes, use the `--ignore-changes` option.

{:.concept}
## Installing and upgrading Puppet Enterprise modules

Some premium Puppet modules are available only to Puppet Enterprise users. Generally, you manage these modules in the same way you would manage other modules, but you must have a valid PE license on the machine on which you download the module.

To install or upgrade a [Puppet Enterprise module](/forge/puppetenterprisemodules) with the `puppet module` command, you must:

* Be logged in as the root user.
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.

> **Note**: If you use `librarian-puppet` to manage Puppet Enterprise modules, you must first install the module, and then commit the module to your version control repository.

{:.task}
#### Install PE modules on nodes without internet

If you need to install a PE-only module on a node with no internet, you can download the module on a connected machine, and then move the module package to the disconnected node.

1. Run `puppet module install puppetlabs-<MODULE>` on a licensed node with internet access.
2. Run `puppet module build` to build a package from the newly installed module.
3. Move the *.tar.gz wherever you choose.
4. Run `puppet module install` against the tar.gz.
5. Manually install the module's dependencies. Without internet access, the `puppet module` command cannot install dependencies automatically.

{:.reference}
## Reference: `puppet module` actions

The `puppet module` command manages modules with several actions, including install, uninstall, list, and search.

View a full description of each action with `puppet man module` or by viewing the man page online.

{:.section}
#### `install`

Installs a module from either the Forge or a release archive.

``` bash
sudo puppet module install puppetlabs-apache --version 0.0.2
```

Accepts the following options:

Option   | Description
----------------|:---------------
`--target-dir` | Specifies a different directory for installation.
`--environment` | Installs the module into the specified environment.
`--modulepath` | Specifies a modulepath, instead of using an environment's default modulepath.
`--version` | Specifies the module version to install. You can use an exact version or a requirement string like `>=1.0.3`.
`--force` | Forcibly installs a module or re-install an existing module. Does **not** install dependencies.
`--ignore-dependencies` | Does not install any modules required by this module.
`--debug` | Displays additional information about what the `puppet module` command is doing.

{:.section}
#### `list`

Lists installed modules.

``` bash
sudo puppet module list
```

{:.section}
#### `search`

Searches the Forge for a module.

``` bash
sudo puppet module search apache
```

{:.section}
#### `uninstall`

Uninstalls a Puppet module.

``` bash
sudo puppet module uninstall puppetlabs-apache
```

{:.section}
#### `upgrade`

Upgrades a Puppet module.

``` bash
sudo puppet module upgrade puppetlabs-apache --version 0.0.3
```

{:.concept}
## Troubleshooting Puppet Enterprise module errors

If you get an error when installing a Puppet Enterprise module, check for common issues.

When installing or upgrading a PE-only module, you might get the following error:

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


