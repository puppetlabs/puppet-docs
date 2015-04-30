---
layout: default
title: "Installing Modules"
canonical: "/puppet/latest/reference/modules_installing.html"
---

[forge]: http://forge.puppetlabs.com
[module_man]: /references/3.6.latest/man/module.html
[modulepath]: /references/stable/configuration.html#modulepath

[publishing]: ./modules_publishing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[documentation]: ./modules_documentation.html

Installing Modules
=====


`Windows note`

* Windows nodes that pull configurations from a Linux or Unix Puppet master can use any Forge modules installed on the master. Continue reading to learn how to use the module tool on your Puppet master.
* If you use `puppet apply` on Windows, you can install a Forge module by downloading and extracting the module's release tarball from the module's page on the Forge (you will also need to download each module listed under 'dependencies' in the metadata.json). Then run the following command in PowerShell or Command Prompt: `puppet module install <PATH TO TARBALL> --ignore-dependencies`.

`Solaris Note`

* To use the Puppet module tool on Solaris systems, you must first install gTar.

The [Puppet Forge][forge] is a **repository of pre-existing modules,** written and contributed by users. These modules solve a wide variety of problems, from configuring NTP to managing Apache, and using these modules can save you time and effort.

The `puppet module` subcommand, which ships with Puppet, is a tool for finding and managing new modules from the Forge. Its interface is similar to several common package managers, and makes it easy to **search for and install new modules from the command line.**

* Continue reading to learn how to install and manage modules from the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] to learn how to use and write Puppet modules.
* [See "Publishing Modules"][publishing] to learn how to contribute your own modules to the Forge, including information about the Puppet module tool's `build` and `generate` actions.
* [See "Using Plugins"][plugins] for how to arrange plugins like custom facts and custom resource types, in modules and then sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.


Using the Module Tool
-----

The `puppet module` subcommand has several *actions.* The main actions used for managing modules are:

`install`
: Install a module from the Forge or a release archive.

      # puppet module install puppetlabs-apache

`list`
: List installed modules.

      # puppet module list

`search`
: Search the Forge for a module.

      # puppet module search apache

`uninstall`
: Uninstall a Puppet module.

      # puppet module uninstall puppetlabs-apache

`upgrade`
: Upgrade a Puppet module.

      # puppet module upgrade puppetlabs-apache

If you have used a command line package manager tool (like `gem`, `apt-get`, or `yum`) before, these actions will generally do what you expect. You can view a full description of each action with `puppet man module` or by [viewing the man page here][module_man].

###Using the Module Tool Behind a Proxy

In order to use the Puppet module tool behind a proxy, you need to set the following:

	export http_proxy=http://10.187.255.9:8080 
	export https_proxy=http://10.187.255.9:8080
	
Alternatively, you can set these two proxy settings inside the `user` config section in the `puppet.conf` file: `http_proxy_host` and `http_proxy_port`. For more information, see [Configuration Reference](/references/latest/configuration.html).

>**Note:** Make sure to set these two proxy settings in the `user` section only. Otherwise, there can be adverse effects. 


Installing Modules
-----

The `puppet module install` action will install a module and all of its dependencies. 

### Modulepath

#### On a fresh installation of Puppet Enterprise 3.8

If you have freshly installed Puppet Enterprise (PE) 3.8, using `puppet module install` will, by default, install your modules in /etc/puppetlabs/puppet/environments/production/modules. 

You can change the default location via the [modulepath](https://docs.puppetlabs.com/puppet/3.8/reference/dirs_modulepath.html#configuring-the-modulepath), which will vary depending on whether you are using different environments.

#### On an upgrade of PE 3.8

If you have upgraded to PE 3.8 from an earlier version of PE, using `puppet module install` will, by default, install your modules in /etc/puppetlabs/puppet/modules. **However** if you specified a different default path in your earlier version of PE, the upgrader will respect that. 

>**A note about installing**
>
>As of Puppet 3.6, if any module in either your /etc/puppetlabs/puppet/modules or /etc/puppetlabs/puppet/environments/production directory has incorrect versioning (anything other than major.minor.patch), attempting to install the module (or upgrade it) will result in the following warning. 
>
>~~~ 
>Warning: module (/Users/youtheuser/.puppet/modules/module) has an invalid version number (0.1). The version has been set to 0.0.0. If you are the maintainer for this module, please update the metadata.json with a valid Semantic Version (http://semver.org).
~~~
>
>Despite the warning, your module will still be downloaded. The metadata of the offending module will not be altered. The versioning information has only been changed in memory during the run of the program.

### Options for `puppet module install`

The most useful and common options used with `puppet module install` are listed below. For a full list, run `puppet help module install`.

* Use the `--version` option to specify a version. You can use an exact version or use a requirement string with single quotes, like '>=1.0.3'.
*  Use the `--force` option to forcibly install a module or reinstall an existing module (**Note:** Using this option does not install dependencies).
* Use the `--environment` option to install into a different environment.
* Use the `--modulepath` option to manually specify which directory to install into. **Note:** To avoid duplicating modules installed as dependencies, you might need to specify the modulepath as a list of directories; see [the documentation for setting the modulepath][modulepath] for details.
* Use the `--ignore-dependencies` option to skip installing any modules required by this module.
* Use the `--debug` option to see additional information about what the Puppet module tool (PMT) is doing.

### Installing From the Puppet Forge

To install a module from the Puppet Forge, simply identify the desired module by its full name. **The full name of a Forge module is formatted as "username-modulename."**

    # puppet module install puppetlabs-apache

### Installing From Another Module Repository

The module tool can install modules from other repositories that mimic the Forge's interface. To do this, change the [`module_repository`](/references/latest/configuration.html#modulerepository) setting in [`puppet.conf`](/puppet/3.8/reference/config_file_main.html) or specify a repository on the command line with the `--module_repository` option. The value of this setting should be the base URL of the repository; the default value, which uses the Forge, is `http://forge.puppetlabs.com`.

After setting the repository, follow the instructions above for installing from the Forge.

    # puppet module install --module_repository http://dev-forge.example.com puppetlabs-apache

### Installing From a Release Tarball

To install a module from a release tarball, specify the path to the tarball instead of the module name.

Make sure to use the `--ignore-dependencies` flag if you cannot currently reach the Puppet Forge or are installing modules that have not yet been published to the Forge. This flag will tell the PMT not to try to resolve dependencies by connecting to the Forge. Be aware that in this case you must manually install any dependencies.

    # puppet module install ~/puppetlabs-apache-0.10.0.tar.gz --ignore-dependencies

### Installing Puppet Enterprise Modules

Puppet Enterprise 3.8 supports modules built exclusively for you, the PE user. To install a [Puppet Enterprise module](https://docs.puppetlabs.com/forge/puppetenterprisemodules) you must:

* Be logged in as the root user.
* Use the [Puppet module tool](#using-the-module-tool).
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.
    
Once you've run `puppet module install puppetlabs-modulename` you can move the installed module to the directory, server, or version control system (VCS) repository of your choice. 

You might also choose to run `puppet module install puppetlabs-modulename` and then  run `puppet module build` to build the newly-installed module so you can move the pkg/*.tar.gz wherever you choose. Once the tar.gz file is moved, run `puppet module install` against it. As long as the node you've moved it to has internet access, this second run of `puppet module install` will bring in any publicly available dependencies, such as puppetlabs-stdlib.

Finding Modules
-----

Modules can be found by browsing the Forge's [web interface][forge] or by using the module tool's *`search` action.* The search action accepts a single search term and returns a list of modules whose names, descriptions, or keywords match the search term.

    $ puppet module search apache
    Searching http://forge.puppetlabs.com ...
    NAME                           DESCRIPTION            AUTHOR          KEYWORDS
    puppetlabs-apache              This is a generic ...  @puppetlabs     apache web
    puppetlabs-passenger           Module to manage P...  @puppetlabs     apache
    DavidSchmitt-apache            Manages apache, mo...  @DavidSchmitt   apache
    jamtur01-httpauth              Puppet HTTP Authen...  @jamtur01       apache
    jamtur01-apachemodules         Puppet Apache Modu...  @jamtur01       apache
    adobe-hadoop                   Puppet module to d...  @adobe          apache
    adobe-hbase                    Puppet module to d...  @adobe          apache
    adobe-zookeeper                Puppet module to d...  @adobe          apache
    adobe-highavailability         Puppet module to c...  @adobe          apache mon
    adobe-mon                      Puppet module to d...  @adobe          apache mon
    puppetmanaged-webserver        Apache webserver m...  @puppetmanaged  apache
    ghoneycutt-apache              Manages apache ser...  @ghoneycutt     apache web
    ghoneycutt-sites               This module manage...  @ghoneycutt     apache web
    fliplap-apache_modules_sles11  Exactly the same a...  @fliplap
    mstanislav-puppet_yum          Puppet 2.              @mstanislav     apache
    mstanislav-apache_yum          Puppet 2.              @mstanislav     apache
    jonhadfield-wordpress          Puppet module to s...  @jonhadfield    apache php
    saz-php                        Manage cli, apache...  @saz            apache php
    pmtacceptance-apache           This is a dummy ap...  @pmtacceptance  apache php
    pmtacceptance-php              This is a dummy ph...  @pmtacceptance  apache php

Once you've identified the module you need, you can install it by name as described above.


Managing Modules
-----

### Listing Installed Modules

Use the module tool's *`list` action* to see which modules you have installed (and which directory they're installed in).

* Use the `--tree` option to view the modules arranged by dependency instead of by location on disk.

### Upgrading Modules

Use the module tool's *`upgrade` action* to upgrade an installed module to the latest version. The target module must be identified by its full name.

* Use the `--version` option to specify a version.
* Use the `--ignore-changes` option to upgrade the module while ignoring and overwriting any local changes that may have been made.
* Use the `--ignore-dependencies` option to skip upgrading any modules required by this module.

### Managing Puppet Enterprise Modules

If you want to manage a Puppet Enterprise module with [librarian-puppet](https://github.com/rodjek/librarian-puppet) or [r10k](https://github.com/puppetlabs/r10k), you must [install the module](#installing-puppet-enterprise-modules) and then commit the module to your version control repository. 

When it comes time to upgrade your Puppet Enterprise module, much like with installation, you must:

* Be logged in as the root user.
* Use the [Puppet module tool](#using-the-module-tool).
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.

### Uninstalling Modules

Use the module tool's *`uninstall` action* to remove an installed module. The target module must be identified by its full name:

    # puppet module uninstall apache
    Error: Could not uninstall module 'apache':
      Module 'apache' is not installed
          You may have meant `puppet module uninstall puppetlabs-apache`
    # puppet module uninstall puppetlabs-apache
    Removed /etc/puppetlabs/puppet/environments/production/modules/apache (v0.0.3)

By default, the tool won't uninstall a module that other modules depend on or whose files have been edited since it was installed.

* Use the `--force` option to uninstall even if the module is depended on or has been manually edited.
* Use the `--ignore-changes` option to uninstall the module while ignoring and overwriting any local changes that may have been made.

### Errors

####Upgrade/Uninstall

The PMT from Puppet 3.6 has a known issue wherein modules that were published to the Puppet Forge that had not performed the [migration steps](/puppet/latest/reference/modules_publishing.html#build-your-module) before publishing will have erroneous checksum information. These checksums will cause errors that prevent you from upgrading or uninstalling the module.

If you see an error similar to the following when upgrading or uninstalling,you can workaround it by upgrading or uninstalling using the `--ignore-changes` option.

~~~
Notice: Preparing to upgrade 'puppetlabs-motd' ...
Notice: Found 'puppetlabs-motd' (v1.0.0) in /etc/puppetlabs/puppet/environments/production/modules ...
Error: Could not upgrade module 'puppetlabs-motd' (v1.0.0 -> latest)
  Installed module has had changes made locally
~~~

####Puppet Enterprise Modules

When you try to [install](#installing-puppet-enterprise-modules) or [upgrade](#managing-puppet-enterprise-modules) a Puppet Enterprise module, you might receive the following error:

~~~
 # puppet module install puppetlabs-mssql
Notice: Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Error: Request to Puppet Forge failed.
  The server being queried was https://forgeapi.puppetlabs.com/v3/releases?module=puppetlabs-mssql&module_groups=base+pe_only
  The HTTP response we received was '403 Forbidden'
  The message we received said 'You must have a valid Puppet Enterprise license on this node in order to download puppetlabs-mssql. If you have a Puppet Enterprise license, please see https://docs.puppetlabs.com/forge/puppetenterprisemodules for more information.'
~~~

Check to see if you’re doing one of these things:

1. Are you logged in as the root user? If not, log in as root and try again.
2. Are you using either the `puppet module install` or `puppet module upgrade` command? If not, you must use the Puppet module subcommands to install or upgrade Puppet Enterprise modules.
3. Does the node you're on have a valid Puppet Enterprise license? If not, switch to a node that has a valid PE license on it.
4. Are you running Puppet Enterprise 3.8? If not, you will not be able to download Puppet Enterprise modules until you upgrade.
5. Do you have access to the internet on the node? If not, you need to switch to a node that has access to the internet.
