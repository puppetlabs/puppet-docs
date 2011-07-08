Bootstrapping Puppet Dashboard and the Baseline Compliance Plugin
====

The Puppet baseline compliance plugin is an add-on to Puppet Dashboard that enables a compliance workflow for auditing ad-hoc system changes. 

Currently, Puppet Labs only ships baseline plugin packages for use with Red Hat Enterprise Linux 6 (and compatible) systems. 

Dependencies
-----

The baseline compliance plugin requires Puppet Dashboard 1.2 or a similar pre-release version. We recommend installing Dashboard from the package provided by Puppet Labs alongside the baseline plugin package.

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

### Bootstrapping the Baseline Plugin

If you are installing the baseline plugin into an already functional Dashboard installation, you'll need to run `rake db:migrate RAILS_ENV=production`. (If you're installing Dashboard at the same time, you'll have already run this.)

After properly configuring Dashboard, you'll need to create a cron job to run the `puppet:plugin:baseline:daily` rake task at least once a day. 

<!-- Insert example cron entry, remembering to include that RAILS_ENV=production -->

### Configuring Agent Nodes

Each puppet agent node will need to be configured to run puppet inspect at least once daily. This can be done with Puppet, by declaring something like the following resource:

{% highlight ruby %}
    cron { 'inspect':
      ensure => present,
      command => '/usr/local/bin/puppet inspect',
      user => 'root',
      hour => [2, 15],
    }
{% endhighlight %}
<!-- Check that this is right. -->

If you want to be able to view and diff file contents, you'll also need to ensure that each agent node's puppet.conf file contains `archive_files = true` in its main or agent block.