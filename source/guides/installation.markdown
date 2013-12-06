---
layout: default
nav: puppet_general.html
title: Installing Puppet
---


[bestpractice]: /guides/best_practices.html
[downloads]: http://downloads.puppetlabs.com/puppet/
[releasenotes]: http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes
[configuring]: /guides/configuring.html
[ruby]: /guides/platforms.html#ruby-versions
[platforms]: /guides/platforms.html
[passenger]: /guides/passenger.html
[scaling]: /guides/passenger.html
[hiera]: https://github.com/puppetlabs/hiera
[dashboard]: /dashboard/manual/1.2/
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[forge]: http://forge.puppetlabs.com/
[modules]: /puppet/latest/reference/modules_fundamentals.html
[after]: #post-install

[pe]: http://puppetlabs.com/puppet/puppet-enterprise/
[comparison]: http://puppetlabs.com/puppet/compare/
[pefaq]: http://puppetlabs.com/puppet/faq/
[pedownload]: http://info.puppetlabs.com/download-pe.html
[pemanual]: /pe/latest/
[peinstall]: /pe/latest/install_basic.html

[epel]: http://fedoraproject.org/wiki/EPEL
[epelinstall]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F
[launchd]: http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
[launchctl]: http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/launchctl.1.html

{% capture after %}[Continue reading here][after] and follow any necessary post-install steps. {% endcapture %}

Installing Puppet
=====

> This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

Pre-Install
-----

Check the following before you install Puppet.

### OS/Ruby Version

* See the [supported platforms][platforms] guide.
* If your OS is older than the supported versions, you may still be able to run Puppet if you install an updated version of Ruby. See the [list of supported Ruby versions][ruby].

### Deployment Type

Decide on a deployment type before installing:

Agent/master
: Agent nodes pull their configurations from a puppet master server. Admins must manage node certificates, but will only have to maintain manifests and modules on the puppet master server(s), and can more easily take advantage of features like reporting and external data sources.

  You must decide in advance which server will be the master; install Puppet on it before installing on any agents. The master should be a dedicated machine with a fast processor, lots of RAM, and a fast disk.

Standalone
: Every node compiles its own configuration from manifests. Admins must regularly sync Puppet manifests and modules to every node.

### Network

In an agent/master deployment, you must prepare your network for Puppet's traffic.

* **Firewalls:** The puppet master server must allow incoming connections on port 8140, and agent nodes must be able to connect to the master on that port.
* **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must write an `/etc/hosts` file on each node.

> **Note:** The default master hostname is `puppet`. Your agent nodes will be ready sooner if this hostname resolves to your puppet master.


Installing Puppet
-----

The best way to install Puppet varies by operating system. Use the links below to skip to your OS's instructions.

- <a href="#red-hat-enterprise-linux-and-derivatives">Red Hat Enterprise Linux (and Derivatives)</a>
- <a href="#debian-and-ubuntu">Debian and Ubuntu</a>
- <a href="#fedora">Fedora</a>
- <a href="#mac-os-x">Mac OS X</a>
- <a href="#windows">Windows</a>
- <a href="#installing-from-gems-not-recommended">Installing from Gems (Not Recommended)</a>
- <a href="#installing-from-a-tarball-not-recommended">Installing from a Tarball (Not Recommended)</a>
- <a href="#running-directly-from-source-not-recommended">Running Directly from Source (Not Recommended)</a>

* * *

### Red Hat Enterprise Linux (and Derivatives)

These instructions apply to the following Enterprise Linux (EL) versions:

{% include platforms_redhat_like.markdown %}

Users of out-of-production EL systems (i.e. RHEL 4) may need to compile their own copy of Ruby before installing, or use an older snapshot of EPEL.

#### 1. Choose a Package Source

Enterprise Linux users can install from Puppet Labs' official repo, or from [EPEL][].

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [yum.puppetlabs.com](http://yum.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-red-hat-enterprise-linux-and-derivatives).

##### Using EPEL

The [Extra Packages for Enterprise Linux (EPEL)][epel] repo includes Puppet and its prerequisites. These packages are usually older Puppet versions with security patches. <!-- dated --> As of April 2012, EPEL was shipping a Puppet version from the prior, maintenance-only release series.

To install Puppet from EPEL, follow [EPEL's own instructions][epelinstall] for enabling their repository on all of your target systems.


#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo yum install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

For a standalone deployment, install this same package on all nodes.


#### 4. Configure and Enable

{{ after }}

* * *

### Debian and Ubuntu

These instructions apply to currently supported versions of Debian, Ubuntu, and derived Linux distributions, including:

{% include platforms_debian_like.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.

#### 1. Choose a Package Source

Debian and Ubuntu systems can install Puppet from Puppet Labs' official repo, or from the OS vendor's default repo.

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [apt.puppetlabs.com](http://apt.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-debian-and-ubuntu).

##### Using Vendor Packages

Debian and Ubuntu distributions include Puppet in their default package repos. No extra steps are necessary to enable it.

Older OS versions will have outdated Puppet versions, which are updated only with security patches. As a general guideline to how current OS packages tend to be, we found the following when checking versions in April 2012:

* Debian unstable's Puppet was current.
* Debian testing's Puppet was nearly current (one point release behind the current version).
* Debian stable's Puppet was more than 18 months old, with additional security patches.
* The latest Ubuntu's Puppet was nearly current (one point release behind).
* The prior (non-LTS) Ubuntu's Puppet was nine months old, with additional security patches.
* The prior LTS Ubuntu's Puppet was more than two years old, with additional security patches.


#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run one of the following:

* `sudo apt-get install puppetmaster` --- This will install Puppet, its prerequisites, and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.
* `sudo apt-get install puppetmaster-passenger` --- (May not be available for all OS versions.) This will automatically configure a production-capacity web server for the Puppet master, using Passenger and Apache. In this configuration, do not use the puppetmaster init script; instead, control the puppet master by turning the Apache web server on and off or by disabling the puppet master vhost.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo apt-get install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

For a standalone deployment, run `sudo apt-get install puppet-common` on all nodes instead. This will install Puppet without the agent init script.

#### 4. Configure and Enable

{{ after }}

* * *

### Fedora

These instructions apply to the currently supported Fedora releases, which are:

{% include platforms_fedora.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.

#### 1. Choose a Package Source

Fedora systems can install Puppet from Puppet Labs' official repo, or from the OS vendor's default repo.

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [yum.puppetlabs.com](http://yum.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-fedora).

##### Using Vendor Packages

Fedora includes Puppet in its default package repos. No extra steps are necessary to enable it.

These packages are usually older Puppet versions with security patches. <!-- dated --> As of April 2012, both current releases of Fedora had Puppet versions from the prior, maintenance-only release series.

#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppetmaster.service`) for running a test-quality puppet master server.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo yum install puppet`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppet.service`) for running the puppet agent daemon. (Note that prior to Puppet 3.4.0, the agent service name on Fedora ≥ 17 was `puppetagent` instead of puppet. This name will continue to work until Puppet 4, but you should use the more consistent `puppet` instead.)

For a standalone deployment, install this same package on all nodes.

#### 4. Configure and Enable

{{ after }}

* * *


### Mac OS X

#### 1. Download the Package

OS X users should install Puppet with official Puppet Labs packages. [Download them here](http://downloads.puppetlabs.com/mac/). You will need:

* The most recent Facter package
* The most recent Hiera package
* The most recent Puppet package

#### 2. Install Facter

Mount the Facter disk image, and run the installer package it contains.

#### 3. Install Hiera

Mount the Hiera disk image, and run the installer package it contains.

#### 4. Install Puppet

Mount the Puppet disk image, and run the installer package it contains.

#### 5. Configure and Enable

The OS X packages are currently fairly minimal, and do not create launchd jobs, users, or default configuration or manifest files. You will have to:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* If you intend to run the puppet agent daemon regularly, or if you intend to automatically run puppet apply at a set interval, you must create and register your own launchd services. [See the post-installation instructions](#with-launchd) for a model.

{{ after }}

* * *

### Windows

[See the Windows installation instructions](/windows/installing.html).

* * *

### Installing from Gems (Not Recommended)

[fromgems]: #installing-from-gems

On \*nix platforms without native packages available, you can install Puppet with Ruby's `gem` package manager.

#### 1. Ensure Prerequisites are Installed

Use your OS's package tools to install both Ruby and RubyGems. In some cases, you may need to compile and install these yourself.

On Linux platforms, you should also ensure that the LSB tools are installed; at a minimum, we recommend installing `lsb_release`. See your OS's documentation for details about its LSB tools.

#### 2. Install Puppet

To install Puppet and Facter, run:

    $ sudo gem install puppet

#### 3. Configure and Enable

{% capture example_init %}([Red Hat](https://github.com/puppetlabs/puppet/blob/master/ext/redhat), [Debian](https://github.com/puppetlabs/puppet/blob/master/ext/debian), [SUSE](https://github.com/puppetlabs/puppet/blob/master/ext/suse), [systemd](https://github.com/puppetlabs/puppet/blob/master/ext/systemd), [FreeBSD](https://github.com/puppetlabs/puppet/blob/master/ext/freebsd), [Gentoo](https://github.com/puppetlabs/puppet/blob/master/ext/gentoo), [Solaris](https://github.com/puppetlabs/puppet/blob/master/ext/solaris)){% endcapture %}

Installing with gem requires some additional steps:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* Create and install init scripts for the puppet agent and/or puppet master services. See the `ext/` directory in the Puppet source for example init scripts {{ example_init }}.
* Manually create an `/etc/puppet/puppet.conf` file.
* Locate the Puppet source on disk, and manually copy the `auth.conf` file from the `/conf` directory to `/etc/puppet/auth.conf`.
* If you get the error `require: no such file to load` when trying to run Puppet, define the RUBYOPT environment variable as advised in the [post-install instructions](http://docs.rubygems.org/read/chapter/3#page70) of the RubyGems User Guide.

{{ after }}



* * *

### Installing from a Tarball (Not Recommended)

[fromsource]: #installing-from-a-tarball

This is almost never recommended, but may be necessary in some cases.

#### 1. Ensure Prerequisites are Installed

Use your OS's package tools to install Ruby. In some cases, you may need to compile and install it yourself.

On Linux platforms, you should also ensure that the LSB tools are installed; at a minimum, we recommend installing `lsb_release`. See your OS's documentation for details about its LSB tools.

If you wish to use Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/3/reference/lang_experimental_3_2.html), you should also install the `rgen` gem.

#### 2. Download Puppet and Facter

* Download Puppet [here][downloads].
* Download Facter [here](http://downloads.puppetlabs.com/facter/).

#### 3. Install Facter

Unarchive the Facter tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

#### 4. Install Puppet

Unarchive the Puppet tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

#### 5. Configure and Enable

Installing from a tarball requires some additional steps:

* Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
* Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.
* Create and install init scripts for the puppet agent and/or puppet master services. See the `ext/` directory in the Puppet source for example init scripts {{ example_init }}.
* Manually create an `/etc/puppet/puppet.conf` file.

{{ after }}

* * *

### Running Directly from Source (Not Recommended)

This is recommended only for developers and testers.

See [Running Puppet from Source](/guides/from_source.html).



<!--
### OpenSuSE

### ArchLinux

### Solaris

### AIX

### HPUX

### BSDs
 -->




* * *

Post-Install
-----

Perform the following tasks after you finish installing Puppet.

### Configure Puppet

Puppet's main configuration file is found at `/etc/puppet/puppet.conf`. See [Configuring Puppet][configuring] for more details.

Most users should specify the following settings:

#### On Agent Nodes

Settings for agent nodes should go in the `[agent]` or `[main]` block of `puppet.conf`.

* [`server`](/references/latest/configuration.html#server): The hostname of your puppet master server. Defaults to `puppet`.
* [`report`](/references/latest/configuration.html#report): Most users should set this to `true`.
* [`pluginsync`](/references/latest/configuration.html#pluginsync): Most users should set this to `true`.
* [`certname`](/references/latest/configuration.html#certname): The sitewide unique identifier for this node. Defaults to the node's fully qualified domain name, which is usually fine.

#### On Puppet Masters

Settings for puppet master servers should go in the `[master]` or `[main]` block of `puppet.conf`.

> **Note:** puppet masters are usually also agent nodes; settings in `[main]` will be available to both services, and settings in the `[master]` and `[agent]` blocks will override the settings in `[main]`.

* [`dns_alt_names`](/references/latest/configuration.html#dnsaltnames): A list of valid hostnames for the master, which will be embedded in its certificate. Defaults to the puppet master's `certname` and `puppet`, which is usually fine. If you are using a non-default setting, set it **before** starting the puppet master for the first time.

#### On Standalone Nodes

Settings for standalone puppet nodes should go in the `[main]` block of `puppet.conf`.

Puppet's default settings are generally appropriate for standalone nodes. No additional configuration is necessary unless you intend to use centralized reporting or an [external node classifier](/guides/external_nodes.html).


### Start and Enable the Puppet Services

Some packages do not automatically start the puppet services after installing the software. You may need to start them manually in order to use Puppet.

#### With Init Scripts / Service Configs

Most packages create init scripts or service configuration files called `puppet` and `puppetmaster`, which run the puppet agent and puppet master services.

You can start and permanently enable these services using Puppet:

    $ sudo puppet resource service puppet ensure=running enable=true
    $ sudo puppet resource service puppetmaster ensure=running enable=true

> **Note:** On Fedora prior to Puppet 3.4.0, the agent service name was `puppetagent` instead of puppet.

> **Note:** If you have configured puppet master to use a production web server, do not use the default init script; instead, start and stop the web server that is managing the puppet master service.

#### With Cron

Standalone deployments do not use services with init scripts; instead, they require a cron task to regularly run puppet apply on a main manifest (usually the same `/etc/puppet/manifests/site.pp` manifest that puppet master uses). You can create this cron job with Puppet:

    $ sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/usr/bin/puppet apply $(puppet apply --configprint manifest)'

In an agent/master deployment, you may wish to run puppet agent with cron rather than its init script; this can sometimes perform better and use less memory. You can create this cron job with Puppet:

    $ sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

#### With Launchd

Apple [recommends you use launchd][launchd] to manage the execution of services and daemons. You can define a launchd service with XML property lists (plists), and manage it with the [`launchctl`][launchctl] command line utility. If you'd like to use launchd to manage execution of your puppet master or agent, download the following files and copy each into `/Library/LaunchDaemons/`:

  - [com.puppetlabs.puppetmaster.plist](files/com.puppetlabs.puppetmaster.plist) (to manage launch of a puppet master)
  - [com.puppetlabs.puppet.plist](files/com.puppetlabs.puppet.plist) (to manage launch of a puppet agent)

Set the correct owner and permissions on the files. Both must be owned by the root user and both must be writable only by the root user:

    $ sudo chown root:wheel /Library/LaunchDaemons/com.puppetlabs.puppet.plist
    $ sudo chmod 644 /Library/LaunchDaemons/com.puppetlabs.puppet.plist
    $ sudo chown root:wheel /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist
    $ sudo chmod 644 /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist

Make launchd aware of the new services:

    $ sudo launchctl load -w /Library/LaunchDaemons/com.puppetlabs.puppet.plist
    $ sudo launchctl load -w /Library/LaunchDaemons/com.puppetlabs.puppetmaster.plist

Note that the files we provide here are responsible only for initial launch of a puppet master or puppet agent at system start. How frequently each conducts a run is determined by Puppet's configuration, not the plists.

See the OS X `launchctl` man page for more information on how to stop, start, and manage launchd jobs.

### Sign Node Certificates

In an agent/master deployment, an admin must approve a certificate request for each agent node before that node can fetch configurations. Agent nodes will request certificates the first time they attempt to run.

* Periodically log into the puppet master server and run `sudo puppet cert list` to view outstanding requests.
* Run `sudo puppet cert sign <NAME>` to sign a request, or `sudo puppet cert sign --all` to sign all pending requests.

An agent node whose request has been signed on the master will run normally on its next attempt.


### Change Puppet Master's Web Server

In an agent/master deployment, you **must** [configure the puppet master to run under a scalable web server][scaling] after you have done some reasonable testing. The default web server is simpler to configure and better for testing, but **cannot** support real-life workloads.

A replacement web server can be configured at any time, and does not affect the configuration of agent nodes.


Next
----

Now that you have installed and configured Puppet:

### Learn to Use Puppet

If you have not used Puppet before, you should read the [Learning Puppet](/learning/) series and experiment, either with the Learning Puppet VM or with your own machines. This series will introduce the concepts underpinning Puppet, and will guide you through the process of writing Puppet code, using modules, and classifying nodes.


### Install Optional Software

You can extend and improve Puppet with other software:

* [Puppet Dashboard][dashboard] is an open-source report analyzer, node classifier, and web GUI for Puppet.
* [The stdlib module][stdlib] adds extra functions, an easier way to write custom facts, and more.
* For Puppet 2.6 and 2.7, the [Hiera][] data lookup tool can help you separate your data from your Puppet manifests and write cleaner code. <!-- (Puppet 3.0 and higher install Hiera as a dependency.) -->
* User-submitted modules that solve common problems are available at the [Puppet Forge][forge]. Search here first before writing a new Puppet module from scratch; you can often find something that matches your need or can be quickly hacked to do so.

