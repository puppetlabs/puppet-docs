---
layout: default
title: "Installing Modules"
canonical: "/puppet/latest/reference/modules_installing.html"
---

[forge]: http://forge.puppetlabs.com
[module_man]: ./man/module.html
[modulepath]: /puppet/latest/reference/configuration.html#modulepath

[publishing]: ./modules_publishing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[documentation]: ./modules_documentation.html

Installing Modules
=====


![Windows note](/images/windows-logo-small.jpg)

* Windows nodes that pull configurations from a Linux or Unix puppet master can use any Forge modules installed on the master. Continue reading to learn how to use the module tool on your puppet master.
* On Windows nodes which compile their own catalogs, you can install a Forge module by downloading and extracting the module's release tarball from the module's page on the Forge (you will also need to download each module listed in the Dependencies tab). Then run the following command in PowerShell or Command Prompt: `puppet module install <path to tarball> --ignore-dependencies`.

**Solaris Note**
To use the puppet module tool on Solaris systems, you must first install gtar.

The [Puppet Forge][forge] is a **repository of pre-existing modules,** written and contributed by users. These modules solve a wide variety of problems so using them can save you time and effort.

The `puppet module` subcommand, which ships with Puppet, is a tool for finding and managing new modules from the Forge. Its interface is similar to several common package managers and makes it easy to **search for and install new modules from the command line.**

* Continue reading to learn how to install and manage modules from the Puppet Forge.
* [See "Module Fundamentals"][fundamentals] to learn how to use and write Puppet modules.
* [See "Publishing Modules"][publishing] to learn how to contribute your own modules to the Forge, including information about the puppet module tool's `build` and `generate` actions.
* [See "Using Plugins"][plugins] for how to arrange plugins (like custom facts and custom resource types) in modules and sync them to agent nodes.
* [See "Documenting Modules"][documentation] for a README template and information on providing directions for your module.


Using the Module Tool
-----

The `puppet module` subcommand has several **actions.** The main actions used for managing modules are:

`install`
: Install a module from the Forge or a release archive.

      # puppet module install puppetlabs-apache --version 0.0.2

`list`
: List installed modules.

      # puppet module list

`search`
: Search the Forge for a module.

      # puppet module search apache

`uninstall`
: Uninstall a puppet module.

      # puppet module uninstall puppetlabs-apache

`upgrade`
: Upgrade a puppet module.

      # puppet module upgrade puppetlabs-apache --version 0.0.3

If you have used a command line package manager tool (like `gem`, `apt-get`, or `yum`) before, these actions will generally do what you expect. You can view a full description of each action with `puppet man module` or by [viewing the man page here][module_man].

### Using the Module Tool Behind a Proxy

In order to use the puppet module tool behind a proxy, you need to set the following:

	export http_proxy=http://10.187.255.9:8080
	export https_proxy=http://10.187.255.9:8080

Alternatively, you can set these two proxy settings inside the `user` config section in the `puppet.conf` file: `http_proxy_host` and `http_proxy_port`. For more information, see [Configuration Reference](/puppet/latest/reference/configuration.html).

**Note:** Make sure to set these two proxy settings in the `user` section only. Otherwise, there can be adverse effects.

Installing Modules
-----

The `puppet module install` action will install a module and all of its dependencies. By default, **it will install into the first directory in Puppet's modulepath.**

* Use the `--version` option to specify a version. You can use an exact version or a requirement string like `>=1.0.3`.
* Use the `--force` option to forcibly install a module or re-install an existing module.
* Use the `--environment` option to install into a different environment.
* Use the `--modulepath` option to manually specify which directory to install into. Note: To avoid duplicating modules installed as dependencies, you may need to specify the modulepath as a list of directories; see [the documentation for setting the modulepath][modulepath] for details.
* Use the `--ignore-dependencies` option to skip installing any modules required by this module.
* Use the `--debug` option to see additional information about what the puppet module tool is doing.



### Installing From the Puppet Forge

To install a module from the Puppet Forge, simply identify the desired module by its full name. **The full name of a Forge module is formatted as "username-modulename."**

    # puppet module install puppetlabs-apache


### Installing From Another Module Repository

The module tool can install modules from other repositories that mimic the Forge's interface. To do this, change the [`module_repository`](/puppet/latest/reference/configuration.html#modulerepository) setting in [`puppet.conf`](./config_file_main.html) or specify a repository on the command line with the `--module_repository` option. The value of this setting should be the base URL of the repository; the default value, which uses the Forge, is `https://forgeapi.puppetlabs.com`.

After setting the repository, follow the instructions above for installing from the Forge.

    # puppet module install --module_repository http://dev-forge.example.com puppetlabs-apache

### Installing From a Release Tarball

To install a module from a release tarball, specify the path to the tarball instead of the module name.

Make sure to use the `--ignore-dependencies` flag if you cannot currently reach the Puppet Forge or are installing modules that have not yet been published to the Forge. This flag will tell the puppet module tool not to try to resolve dependencies by connecting to the Forge. Be aware that in this case you must manually install any dependencies.

    # puppet module install ~/puppetlabs-apache-0.10.0.tar.gz --ignore-dependencies

### Installing PE Supported Modules

PE 3.2 introduces [supported modules](http://forge.puppetlabs.com/supported), which  includes additional fields in the modules' metadata.json file to indicate compatibility with PE versions and OSes. The puppet module tool (PMT) has been updated in PE 3.2 to look for PE version requirements in the metadata.

If you are running PE 3.2, please note that if a version of the module matches the installed version of PE, non-matching versions will be filtered out. The `--force` flag will prevent this filtering, and will either install the most recent version of the module if no version is specified or install the specified version. Note that the `--force` flag will ignore dependencies and checksums, as well as overwrite installed modules with the same modulename. The `--debug` flag will show whether a module is being filtered or not. If no PE version metadata is present in any version, all available versions of the module will be displayed.

*Note:*
It is possible that some community modules may also include this `requirements` metadata.

Finding Modules
-----

Modules can be found by browsing the Forge's [web interface][forge] or by using the module tool's **`search` action.** The search action accepts a single search term and returns a list of modules whose names, descriptions, or keywords match the search term.

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

Use the module tool's **`list` action** to see which modules you have installed (and which directory they're installed in).

* Use the `--tree` option to view the modules arranged by dependency instead of by location on disk.

### Upgrading Modules

Use the module tool's **`upgrade` action** to upgrade an installed module to the latest version. The target module must be identified by its full name.

* Use the `--version` option to specify a version.
* Use the `--ignore-dependencies` option to skip upgrading any modules required by this module.

### Uninstalling Modules

Use the module tool's **`uninstall` action** to remove an installed module. The target module must be identified by its full name:

    # puppet module uninstall apache
    Error: Could not uninstall module 'apache':
      Module 'apache' is not installed
          You may have meant `puppet module uninstall puppetlabs-apache`
    # puppet module uninstall puppetlabs-apache
    Removed /etc/puppet/modules/apache (v0.0.3)

By default, the tool won't uninstall a module which other modules depend on or whose files have been edited since it was installed.

* Use the `--force` option to uninstall even if the module is depended on or has been manually edited.
