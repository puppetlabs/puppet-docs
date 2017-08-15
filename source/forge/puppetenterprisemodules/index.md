---
layout: default
title: "Puppet Enterprise Modules"
canonical: "/forge/puppetenterprisemodules/index.html"
---

# Puppet Enterprise modules

Puppet Enterprise modules are modules built by Puppet specifically for use with Puppet Enterprise (PE). These modules were launched with PE 3.7, and quickly and give PE users expanded functionality.

## Installing Puppet Enterprise modules

To install a Puppet Enterprise module you must:

* Use Puppet Enterprise 3.7 or higher.
* Be logged in as the root user on your Puppet master node.
* Use the [`puppet module` command](https://docs.puppet.com/puppet/latest/modules_installing.html).
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module.

Install the module by running `puppet module install puppetlabs-modulename`.

~~~
 # puppet module install puppetlabs-mssql
Notice: Preparing to install into /etc/puppetlabs/puppet/environments/production/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/etc/puppetlabs/puppet/environments/production/modules
└─┬ puppetlabs-mssql (v1.0.0)
  ├── puppetlabs-acl (v1.0.3)
  └── puppetlabs-stdlib (v4.3.2)
~~~

By default, your Puppet Enterprise module is installed in either `/etc/puppetlabs/puppet/environments/production/modules` for fresh installations of PE 3.7 and higher, or `/etc/puppetlabs/puppet/modules` for upgraded installations.

## Managing Puppet Enterprise modules

Once you've installed the module you can move the installed module to the directory, server, or version control system (VCS) repository of your choice. 

If you are using [librarian-puppet](https://github.com/rodjek/librarian-puppet) or [r10k](https://github.com/adrienthebo/r10k), you must install the module with the PMT before committing it to your version control repository.

### Upgrading Puppet Enterprise modules

Upgrading a Puppet Enterprise module looks a lot like installing. You must:

* Use Puppet Enterprise 3.7 or higher.
* Be logged in as the root user on your Puppet master node.
* Use the [`puppet module` command](https://docs.puppet.com/puppet/latest/modules_installing.html).
* Install the module on a properly licensed Puppet node.
* Have internet access on the node you are using to download the module. 

If these conditions are met, you upgrade the module by running `puppet module upgrade puppetlabs-modulename`.

### Uninstalling Puppet Enterprise modules

You can uninstall a Puppet Enterprise module just like any other module by running `puppet module uninstall puppetlabs-modulename`.

~~~
 # puppet module uninstall puppetlabs-mssql
Removed /etc/puppetlabs/puppet/environments/production/modules/mssql (v1.0.0)
~~~

## Feedback and contributing

If you run into an issue with a Puppet Enterprise module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you are having problems getting a Puppet Enterprise module up and running, please contact [Support](https://puppet.com/support-services/customer-support). 