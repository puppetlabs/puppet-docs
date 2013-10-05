---
layout: default
title: "Installing Modules"
---

[forge]: http://forge.puppetlabs.com
[module_man]: /man/module.html
[modulepath]: /references/stable/configuration.html#modulepath

[publishing]: ./modules_publishing.html
[fundamentals]: ./modules_fundamentals.html
[plugins]: /guides/plugins_in_modules.html
[documentation]: ./modules_documentation.html

Installing Modules
=====

<span class="versionnote">This reference applies to Puppet 2.7.14 and later and Puppet Enterprise 2.5 and later. Earlier versions will not behave identically.</span>

> ![Windows note](/images/windows-logo-small.jpg) The puppet module tool does not currently work on Windows.
> 
> * Windows nodes which pull configurations from a Linux or Unix puppet master can use any Forge modules installed on the master. Continue reading to learn how to use the module tool on your puppet master.
> * On Windows nodes which compile their own catalogs, you can install a Forge module by downloading and extracting the module's release tarball, renaming the module directory to remove the user name prefix, and moving it into place in Puppet's [modulepath][].

The [Puppet Forge][forge] is a **repository of pre-existing modules,** written and contributed by users. These modules solve a wide variety of problems so using them can save you time and effort. 

The `puppet module` subcommand, which ships with Puppet, is a tool for finding and managing new modules from the Forge. Its interface is similar to several common package managers, and makes it easy to **search for and install new modules from the command line.**

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

Installing Modules
-----

The `puppet module install` action will install a module and all of its dependencies. By default, **it will install into the first directory in Puppet's modulepath.**

* Use the `--version` option to specify a version. You can use an exact version or a requirement string like `>=1.0.3`. 
* Use the `--force` option to forcibly re-install an existing module.
* Use the `--environment` option to install into a different environment.
* Use the `--modulepath` option to manually specify which directory to install into. Note: To avoid duplicating modules installed as dependencies, you may need to specify the modulepath as a list of directories; see [the documentation for setting the modulepath][modulepath] for details.
* Use the `--ignore-dependencies` option to skip installing any modules required by this module. 

<!-- TODO: change this if the behavior of --dir/--target-dir changes; for now, we aren't mentioning it -->

### Installing From the Puppet Forge

To install a module from the Puppet Forge, simply identify the desired module by its full name. **The full name of a Forge module is formatted as "username-modulename."**

    # puppet module install puppetlabs-apache

### Installing From Another Module Repository

The module tool can install modules from other repositories that mimic the Forge's interface. To do this, change the [`module_repository`](/references/2.7.latest/configuration.html#modulerepository) setting in [`puppet.conf`](/guides/configuring.html) or specify a repository on the command line with the `--module_repository` option. The value of this setting should be the base URL of the repository; the default value, which uses the Forge, is `http://forge.puppetlabs.com`.

After setting the repository, follow the instructions above for installing from the Forge. 

    # puppet module install --module_repository http://dev-forge.example.com puppetlabs-apache

### Installing From a Release Tarball

At this time, the module subcommand cannot properly install from local tarball files. [Follow issue #13542](http://projects.puppetlabs.com/issues/13542) for more details about the progress of this feature.

{% comment %} Uncomment this when we finally fix the bug. 
To install a module from a release tarball, specify the path to the tarball instead of the module name:

    # puppet module install ~/pmtacceptance-apache-0.0.1.tar.gz

This is useful when installing modules downloaded directly from the developer's site, or local modules which haven't yet been published to the forge. 
{% endcomment %}

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
