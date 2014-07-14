---
layout: default
title: "PE 3.3 » Overview » What's New"
subtitle: "New Features in PE 3.3"
canonical: "/pe/latest/overview_whats_new.html"
---

### Version 3.3.0

Puppet Enterprise (PE) version 3.3.0 is a feature and maintenance release. It adds new features and improvements, fixes bugs, and addresses security issues. Specifically, the 3.3.0 release includes the following major changes and additions (a comprehensive list of updates, changes and additions can be found in the [release notes](appendix.html#release-notes)):

#### Puppet Enterprise Installer Improvements

This release replaces the PE installer script with a web-based interface meant to simplify—and provide better clarity into—the PE installation experience. For a complete overview and instructions on installing PE, refer to [Installing Puppet Enterprise](./install_basic.html).

Users who do not wish to perform the web-based installation can still use a pre-configured answers file for an [automated installation](./install_automated.html).  

#### Manifest Ordering

Puppet Enterprise is now using a new `ordering` setting in the Puppet core that allows you to configure how unrelated resources should be ordered when applying a catalog. By default, `ordering` will be set to `manifest` in PE. 

The following values are allowed for the `ordering` setting:

* `manifest`: (default) uses the order in which the resources were declared in their manifest files.
* `title-hash`: orders resources randomly, but will use the same order across runs and across nodes; this is default in previous versions of Puppet.
* `random`: orders resources randomly and change their order with each run. This can work like a fuzzer for shaking out undeclared dependencies.

Regardless of this setting's value, Puppet will always obey explicit dependencies set with the `before`/`require`/`notify`/`subscribe` metaparameters and the `->`/`~>` chaining arrows; this setting only affects the relative ordering of *unrelated* resources.

For more information, and instructions on changing the `ordering` setting, refer to the [Puppet Modules and Manifest Page](./puppet_modules_manifests.html#about-manifest-ordering).

#### Directory Environments and Deprecation Warnings

[dir_environments]: http://docs.puppetlabs.com/puppet/latest/reference/environments.html
[config_envir]: http://docs.puppetlabs.com/puppet/latest/reference/environments_classic.html

The latest version of the Puppet core (Puppet 3.6) introduced [directory environments][dir_environments], an evolution of dynamic environments. Over time both Puppet open source and Puppet Enterprise will make more extensive use of this pattern. 

Environments are isolated groups of puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)

In this release of PE, please note that if you define environment blocks or use any of the `modulepath`, `manifest`, and `config_version` settings in `puppet.conf`, you will see deprecation warnings intended to prepare you for these changes. Configuring PE to use *no* environments will also produce deprecation warnings. 

Please note that [config-file environments][config_envir] are also deprecated.

Once PE has fully moved to directory environments, the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.

> **Note**: executing puppet commands will raise the `modulepath` deprecation warning. 

For more details the deprecation warnings, check the [release notes](appendix.html#release-notes).

The Puppet 3.6 documentation has a comprehensive overview on working with [directory environments][dir_environments], but please note that this feature may have variations in functionality once fully integrated in Puppet Enterprise.

#### New Puppet Enterprise Supported Modules

This release adds two modules to the list of Puppet Enterprise supported modules: NTFS ACL and vcsrepo. Visit the [supported modules](https://forge.puppetlabs.com/supported) page to learn more, or check out the Read Me for [NTFS ACL](https://forge.puppetlabs.com/puppetlabs/acl) and [VCS Repo](https://forge.puppetlabs.com/puppetlabs/vcsrepo).

#### Puppet Module Tool (PMT) Improvements

The PMT has been updated to deprecate the Modulefile in favor of metadata.json. To help ease the transition, the module tool will automatically generate metadata.json based on a Modulefile if it finds one. If neither Modulefile nor metadata.json is available, it will kick off an interview and generate metadata.json based on your responses. 

If you create your new module using the PMT, the PMT will use your interview responses to build metadata.json for you. 

If you are still using a Modulefile, you will receive a deprecation warning. This is only a warning. For more information about the deprecation of Modulefile, see [Publishing Modules on the Puppet Forge](http://docs.puppetlabs.com/puppet/3.6/reference/modules_publishing.html). 

#### Support for Red Hat Enterprise Linux 7

This release provides full support for RHEL 7 for all applicable PE features and capabilities, including puppet master and puppet agent support. For more information, see the [system requirements](./install_sytem_requirements.html).

#### Support for Ubuntu 14 LTS

This release provides full support for Ubuntu 14.04 LTS for all applicable PE features and capabilities, including puppet master and puppet agent support. For more information, see the [system requirements](./install_sytem_requirements.html).

#### Support for Mac OS X (Agent Only)

The puppet agent can now be installed on nodes running Mac OS X Mavericks (10.9). Other components (e.g., master) are not supported. For more information, see the [system requirements](./install_sytem_requirements.html) and the [agent installation instructions](./install_agents.html).

#### Additional OS Support for Simplified Agent Install

This release increases the number of PE supported operating systems than can install agents via package management tools, making the installation process faster and simpler. For details, visit the [PE installation page](./install_basic.html).

#### Console Data Export

Every node list view in the console now includes a link to export the table data in CSV format, so that you can include the data in a spreadsheet or other tool. [to do: add info if this also becomes part of EI] 

#### Support for stdlib 4

This version of PE is fully compatible with version 4.x of stdlib. 

#### Security Patches

A handful of vulnerabilities have been addressed in PE 3.3.0. For details, check the [release notes](appendix.html#release-notes).

#### Component Package Upgrades

Several of the "under the hood" constituent parts of Puppet Enterprise have been updated in version 3.3. Most notably these include:

* Puppet (3.6.2)
* PuppetDB (1.6.4)
* Facter (1.7.5)
* MCollective (2.5.2)
* Hiera (1.3.4)


Visit the [What Gets Installed page](./install_what_and_where.html#puppet-enterprise-components) for a comprehensive list of packages installed by PE.

* * *

[Next: Getting Support](./overview_getting_support.html)
