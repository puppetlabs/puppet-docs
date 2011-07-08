---
layout: default
title: "Baseline Plugin: Bootstrapping
---

Bootstrapping Puppet Dashboard and the Baseline Plugin
====

This chapter describes how to install and configure the `puppet_baseline` plugin and its various dependencies. 

* * * 

Installation Options
------

Currently, Puppet Labs only ships baseline plugin packages for use with Red Hat Enterprise Linux 6 (and compatible) systems. 

Dependencies
-----

The baseline compliance plugin requires Puppet Dashboard 1.2 (or a pre-release thereof). We recommend installing Dashboard from the package provided alongside the baseline plugin package.

Puppet Dashboard and the baseline compliance plugin require the following system packages:

* ruby
* ruby(abi) <!-- Should this be listed separately? -->
* rubygems
* rubygem(rake)
* make
* mysql-server

Additionally, the following packages from the [EPEL](http://fedoraproject.org/wiki/EPEL) repository are required:

* ruby-mysql
* puppet <!-- Is this still required? It looks like only the baseline plugin wants it. -->

Additionally, you'll need to install the following library using Ruby's `gem` package command:

* ar-extensions

Installing
-----

After all dependencies are installed, the Dashboard and/or baseline packages can be installed by running `rpm -Uvh puppet-dashboard*.rpm` in the directory where they were downloaded. 

### Configuring Puppet Dashboard

[dashboard_bootstrap]: http://docs.puppetlabs.com/dashboard/manual/1.2/bootstrapping.html#configuring-dashboard

For detailed information on completing the installation of Puppet Dashboard, [see the relevant chapter of the manual][dashboard_bootstrap]. Although the provided package will install the software and create the puppet-dashboard user, you will need to manually perform the remaining tasks, including configuring a production web server for Dashboard and arranging for a group of `delayed_job` workers.

### Configuring the Baseline Plugin

If you are installing the baseline plugin into an already functional Dashboard installation, you'll need to run `rake db:migrate RAILS_ENV=production`. (If you're installing Dashboard at the same time, you'll have already run this.)

After that, the baseline plugin will be fully installed and ready to use; the package should have set up the additional cron job the plugin requires. (See [internals](./pb_internals.html) for more details.) You may need to restart Dashboard's web server in order to see the new baseline compliance pages.

The baseline plugin accepts one configuration setting in Dashboard's `settings.yml` file: the `baseline_day_end` setting is used to configure the cut-over point for each day's operations.

    baseline_day_end: 2100

The only acceptable value (right now) is a number between 0000 and 2359, which is the hour and minute at which one day ends and the next begins. If not specified, it defaults to 9PM.

### Configuring Agent Nodes

Each puppet agent node will need to be configured to run puppet inspect at least once daily. This can be done with Puppet in the same manifests used to select the resources for audit, by declaring something like the following resource:

{% highlight ruby %}
    cron { 'inspect':
      ensure => present,
      command => '/usr/local/bin/puppet inspect',
      user => 'root',
      hour => [2, 15],
    }
{% endhighlight %}
<!-- Check that this is right. -->

If you want to be able to view and diff file contents, you'll also need to ensure that each agent node's puppet.conf file contains `archive_files = true` in its `[main]` or `[agent]` block.

With this, the baseline plugin should be fully operational and ready for normal use; the first compliance reports should appear the next day.
<!-- Verify the timing on this. -->
