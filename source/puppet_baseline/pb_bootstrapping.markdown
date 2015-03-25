---
layout: default
title: "Baseline Plugin: Bootstrapping"
---

Bootstrapping Puppet Dashboard and the Baseline Plugin
====

<span style="font-size: 2em; font-weight: bold; color: red; background-color: #ff9;">This documentation does not refer to a released product.</span>

<span style="background-color: #ff9;">For documentation of the compliance features released in Puppet Enterprise 1.2, please see [the Puppet Enterprise manual](/pe/).</span>

This chapter describes how to install and configure the `puppet_baseline` plugin and its various dependencies.

#### Navigation

* [Introduction and Workflow](./pb_workflow.html)
* Bootstrapping
* [Interface](./pb_interface.html)
* [Internals](./pb_internals.html)

* * *

Installation Options
------

Currently, Puppet Labs only ships baseline plugin packages for use with Red Hat Enterprise Linux 6 (and compatible) systems. We do not support installing from source.

Baseline functionality will be included in a future version of Puppet Enterprise.

Dependencies
-----

The baseline compliance plugin requires Puppet Dashboard 1.2 (or a pre-release thereof). We recommend installing Dashboard from the package provided alongside the baseline plugin package.

Puppet Dashboard and the baseline compliance plugin require the following system packages:

* ruby
* ruby(abi) 
* rubygems
* rubygem(rake)
* make
* mysql-server

Additionally, the following packages from the [EPEL](http://fedoraproject.org/wiki/EPEL) repository are required:

* ruby-mysql
* puppet 

Additionally, you'll need to install the following library using Ruby's `gem` package command:

* ar-extensions

Installing
-----

After all dependencies are installed, the Dashboard and/or baseline packages can be installed by running:

    rpm -Uvh puppet-dashboard*.rpm

...in the directory where they were downloaded.

### Configuring Puppet Dashboard

[dashboard_bootstrap]: /dashboard/manual/1.2/bootstrapping.html#configuring-dashboard
[dashboard_advanced]: /dashboard/manual/1.2/configuring.html#advanced-features

To complete the installation of Puppet Dashboard, [see the relevant chapter of the manual][dashboard_bootstrap]. Although the provided package will install the software and create the puppet-dashboard user, you will need to manually perform the remaining tasks, including configuring a production web server for Dashboard and arranging for a group of `delayed_job` workers.

Additionally, if you wish to view file contents from the Dashboard interface, you'll need to enable the filebucket viewer as described in [the section about enabling advanced features][dashboard_advanced].

### Configuring the Baseline Plugin

If you are installing the baseline plugin into an already functional Dashboard installation, you'll need to run:

    rake db:migrate RAILS_ENV=production

(If you installed Dashboard at the same time as the plugin, you'll have already run this.)

After that, the baseline plugin will be fully installed and ready to use; the package should have set up the additional cron job the plugin requires. (See [internals](./pb_internals.html) for more details.) You may need to restart Dashboard's web server in order to see the new baseline compliance pages.

The baseline plugin accepts one setting in Dashboard's `settings.yml` file: the `baseline_day_end` setting is used to configure the dividing line between adjacent days.

    baseline_day_end: 2100

The only acceptable value (right now) is a number between 0000 and 2359, which is the hour and minute at which one day ends and the next begins. If not specified, it defaults to 9PM.

### Configuring Agent Nodes

Each puppet agent node will need to be configured to run puppet inspect at least once daily. This can be done with Puppet in the same manifests used to select the resources for audit, by declaring something like the following resource:

{% highlight ruby %}
    cron { 'puppet-inspect':
      ensure  => present,
      command => '/usr/local/bin/puppet inspect',
      user    => 'root',
      hour    => [2, 15],
      minute  => 0,
    }
{% endhighlight %}


If you want to be able to view and diff file contents, you'll also need to ensure that each agent node's puppet.conf file contains `archive_files = true` in its `[main]` or `[agent]` block.

With this, the baseline plugin should be fully operational and ready for normal use; the first compliance reports should appear the next day.


### Writing Compliance Manifests

Once all prerequisites are in place, a sysadmin (or group of sysadmins) familiar with the Puppet language should write a collection of manifests defining the resources to be audited on the site's various computers.

In the simplest case, where you want to audit an identical set of resources on every computer, this can be done strictly in the site manifest by declaring all resources in node `default`. More likely, you'll need to create a more conventional set of classes and modules that can be composed to describe the different kinds of computers at your site.

To mark a resource for auditing, declare its `audit` metaparameter and avoid declaring `ensure` or any other attributes that describe a desired state. The value of `audit` can be one attribute, an array of attributes, or `all`.

{% highlight ruby %}
    file {'hosts':
      path  => '/etc/hosts',
      audit => 'content',
    }
    file {'/etc/sudoers':
      audit => [ensure, content, owner, group, mode, type],
    }
    user {'httpd':
      audit => 'all',
    }
{% endhighlight %}

As with any Puppet site design, you'll need to classify your nodes with a site manifest or an external node classifier to ensure they get the correct catalog. The implementation of a Puppet site design is beyond the scope of this document.

### (Not) Creating Baselines

You do not need to create baselines for your nodes.

Baselines are created automatically for each node that has submitted at least one inspect report during the first run of the baseline plugin's maintenance task. This initial baseline will be identical to the most recent  inspect report, and the same goes for any new nodes when they submit their first inspections. That is to say, **we operate on the assumption that the infrastructure is in a compliant state when the baseline plugin is bootstrapped, and we expect new nodes to be in a compliant state when they are added to the infrastructure.**

Before baselines are created, there's nothing to compare against, and changes to the audited systems can't be reviewed. When viewing a group or a node in the compliance pages, you can tell whether a baseline has been created by checking whether the summary lists "N/A" or "0" in its categories; nodes and groups with no baselines will be reported as "N/A."

* * *

#### Navigation

* [Introduction and Workflow](./pb_workflow.html)
* Bootstrapping
* [Interface](./pb_interface.html)
* [Internals](./pb_internals.html)

