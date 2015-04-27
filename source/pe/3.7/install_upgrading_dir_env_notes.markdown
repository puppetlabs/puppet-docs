---
layout: default
title: "PE 3.7 » Installing » Upgrading (Directory Environments)"
subtitle: "Important Information about Upgrades to PE 3.7 and Directory Environments"
canonical: "/pe/latest/install_upgrading_dir_env_notes.html"
---

Puppet Enterprise 3.7.0 introduces full support for directory environments, which will be enabled by default when you upgrade. 

Environments are isolated groups of Puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. Directory environments let you add a new environment by simply adding a new directory of config data. For example, directory environments will allow you to efficiently create directories for nodes in production, nodes in testing, and nodes in development. 

In this release, the default `production` environment replaces the global `manifest`/`modulepath`/`config_version` settings. More specifically, though, you must have a directory environment for every environment that any nodes are assigned to. Nodes assigned to nonexistent environments cannot fetch their catalogs. 

Before you get started, you may want to read up on the [Structure of an Environment](puppet/3.7/reference/environments_creating.html#structure-of-an-environment) and [Global Settings for Configuring Environments](puppet/3.7/reference/environments_configuring.html#global-settings-for-configuring-environments).

The following document provides a detailed look at the changes you may encounter after upgrading. 

For your reference, the Puppet docs provide more information about [creating directory environments](/puppet/3.7/reference/environments_creating.html). 

>**Warning**: If you enabled directory environments in PE 3.3.x and are upgrading to PE 3.7.0, ensure there is no `default_manifest` parameter in `puppet.conf` **before** upgrading. Upgrades will fail if this change is not made. 


### Scenario 1: Upgrading from Dynamic and/or Config File (Static) Environments

>**Note**: In the following examples, `<path to environments>` is usually `/etc/puppetlabs/puppet/environments`, but if you have a customized PE installation, it may be different. 

#### You've used dynamic environments

- If:
   - your `$modulepath` is `/<path to environments>/$environment/modules:<one or more non-dynamic modulepaths>`
   - and your `$manifest` setting is either `/<path to environments>/$environment/<path to manifests>`, a non-dynamic path (e.g., `/etc/puppetlabs/puppet/manifests/site.pp`), or is unset, 
   
   you can expect the following:

   - the `$environmentpath` setting in the `[main]` section of `puppet.conf` will be `/<path to environments>`.
   - the `$basemodulepath` setting in the `[main]` section of `puppet.conf` will be `<one or more non-dynamic modulepaths>`.
   - the `$default_manifest` setting in the `[main]` section of `puppet.conf` will be `/<path to manifests>`.

   OR

- If your `$modulepath`, `$config_version`, and/or your `$manifest` settings are something other than what is indicated above, an `environment.conf` file will be created in each environment's directory and will contain the correct `$modulepath` and `$manifest` settings for directory environments. (Note that if this cannot be accurately determined, the `environment.conf` will be created at `/etc/puppetlabs/puppet/environments/<name of environment>/environment.conf`.)

> **Required user action**: After upgrading, add `environment.conf` in your code management systems, and update any tooling that manages `puppet.conf` to reflect these changes.  
  
#### You've used static (config file) environments

In this case, you can expect the following:

1. An `environment.conf` file is created for each existing environment at `/<PATH TO ENVIRONMENTS>/<NAME OF STATIC ENVIRONMENT>/environment.conf`. The `environment.conf` file contains the settings that were used for the `$modulepath`, `$manifest`, and `$config_version` for each environment found in `puppet.conf`.

   > **Important**: `$config_version` must be an absolute path; a relative path will cause the upgrader to abort.

2. `puppet.conf` is updated so that the `$environmentpath` setting in the `[main]` section contains `/etc/puppetlabs/puppet/environments` (unless `$environmentpath` was configured due to dynamic environments, as described above).
 
### Scenario 2: Upgrading from the Default Settings	

In this case, you can expect the following:

- the `$environmentpath` setting in the `[main]` section of `puppet.conf` is `/etc/puppetlabs/puppet/environments` to enable directory environments.
- the `$basemodulepath` setting in the `[main]` section of `puppet.conf` is `/opt/puppet/share/puppet/modules` to allow PE to continue to function.
- the `$default_manifest` setting in the `[main]` section of `puppet.conf` is `/etc/puppetlabs/puppet/manifests/site.pp`.
- `puppet.conf` is updated so that the `$environmentpath` setting in the `[main]` section contains `/etc/puppetlabs/puppet/environments`.
- an environment called `production` is created, and provided with an `environment.conf` file.
 
> **Required user action**: After upgrading, add `environment.conf` in your code management systems, and update any tooling that manages `puppet.conf` to reflect these changes.

> **Tip**: If you've been using the default settings, and would like to use environments other than `production`, follow the link at the beginning of this page for information about creating environments. 






