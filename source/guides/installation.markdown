---
layout: default
title: Installing Puppet
---

{% capture yum5package %}http://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-1.noarch.rpm{% endcapture %}
{% capture aptpackage %}http://apt.puppetlabs.com/puppetlabs-release_1.0-2_all.deb{% endcapture %}
{% capture yum6package %}http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-1.noarch.rpm{% endcapture %}

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
[modules]: /puppet/2.7/reference/modules_fundamentals.html
[after]: #after-installing

[pe]: http://puppetlabs.com/puppet/puppet-enterprise/
[comparison]: http://puppetlabs.com/puppet/compare/
[pefaq]: http://puppetlabs.com/puppet/faq/
[pedownload]: http://info.puppetlabs.com/download-pe.html
[pemanual]: /pe/2.5/
[peinstall]: /pe/2.5/install_basic.html

[epel]: http://fedoraproject.org/wiki/EPEL
[epelinstall]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F

{% capture after %}[Continue reading here][after] and follow any necessary post-install steps. {% endcapture %}

Installing Puppet
=====


Summary
-----

* Install Puppet with packages built for your operating system, using the system's package management tools.

    > Don't install Puppet with `gem` or from source unless you have a specific reason to, or are on a system without native packages. Both of these methods leave the user to create any required init scripts as well as the Puppet user and group.

* Puppet Labs provides packages for Enterprise Linux variants, Debian, Ubuntu, Fedora, and Windows. See below for links and instructions.
* Your system may already have Puppet packages available, or they may be included in a popular third-party repository. These packages are likely to be slightly out of date compared to the official Puppet Labs packages, but there are valid reasons to prefer them. 

    > To see how current your OS vendor's packages are, see the [Puppet release notes][releasenotes]. This page identifies the **current** and **maintenance** branches of Puppet, and has a list of all released Puppet versions along with the changes they introduced. 

* If you need production-ready puppet master performance out of the box, professional support, additional compliance and live management features, or an improved console with role-based access control, consider installing [Puppet Enterprise][pe]. See the PE [comparison][] and [FAQ][pefaq] for more info, [download PE here][pedownload], and see the [PE user's guide here][pemanual].

    > You should also try PE if you're trying Puppet for the first time or are managing a very small site, simply because A: it's much easier to get started with, and B: it's completely free for up to ten managed nodes. Check out the [PE quick start guide](/pe/2.5/quick_start.html) if you're brand new to Puppet.

* Puppet requires Ruby. Ruby releases tend to pack big changes into little version number differences. Your OS's default version of Ruby will probably work, but some older versions are unreliable, especially for puppet master servers. [See here for more details][ruby].
* If you are using a puppet master server, you **must** swap out the default web server after you have done some minimal testing. Use [Passenger + Apache][passenger] or some other scalable combination. The default server cannot handle concurrent connections; it is only suitable for testing with your first ten or so nodes, and will fail badly beyond that.
    


Preparing to Install
-----

### Check Platform Support and Ruby Version

* Check the [supported platforms][platforms] to ensure that your OS version is supported by the current versions of Puppet.
* On the same page, see the [list of supported Ruby versions][ruby] to ensure that your system's Ruby version will suffice. On extremely old operating systems, you may need to install an updated version of Ruby from a third-party package repository, or, in extreme cases, compile a new version of Ruby yourself.

### Choose a Deployment Type

Puppet can run in a standalone arrangement or in an agent/master arrangement. 

* In a standalone arrangement, every node runs the same software. The site's admins are responsible for syncing up-to-date Puppet manifests and modules to every node, and should create a cron task to run `puppet apply <MAIN SITE MANIFEST>` on a regular basis. 
* In an agent/master arrangement, a large number of **agent nodes** run the puppet agent service; they contact a smaller number of **puppet master servers** to receive their configurations. The site's admins are responsible for keeping the manifests and modules on the puppet master server(s) up to date, classifying nodes so that they receive the correct configurations, and signing node certificates.

This document assumes a site with only one puppet master. See [Using Multiple Puppet Masters](/guides/scaling_multiple_masters.html) for details on scaling to more than one master server.

If you will be using Puppet in an agent/master arrangement, you must decide in advance which server will be your Puppet master; it will need additional packages and configuration. Puppet masters should be robust, dedicated servers. Install puppet on the puppet master server **before** installing on any agent nodes.


### Prepare Your Network

If you will be using Puppet in an agent/master arrangement, you must prepare your network for Puppet's traffic.

* **Firewalls:** Ensure that the puppet master server allows incoming TCP connections on port 8140, and that all agent nodes can initiate connections on port 8140. 
* **Name resolution:** Ensure that your site's forward and reverse DNS are configured correctly:
    * Every node must have a unique hostname. 
    * Your puppet master server must be reachable by hostname from all agent nodes. Run `ping <PUPPET MASTER'S HOSTNAME>` to test the name resolution. 
    * Given any node's IP address, it should be possible to determine its hostname via reverse DNS. Puppet can largely function without this, but it will log warnings when new nodes connect to the master for the first time, and some facts on your systems may be incorrect. **Having reverse lookup configured incorrectly is worse than lacking it,** and will cause wider failures. 
    * Your puppet master server should be reachable at the default hostnames of `puppet` and `puppet.<DOMAIN>`. This will simplify [configuration of agent nodes](#configure-puppet). 
    
    If your site does not use a DNS server, name lookup and reverse lookup can be accomplished with `/etc/hosts` files distributed to every node on the network. (Ironically, Puppet [is the best way to manage this file](/references/latest/type.html#host), but you can ensure during provisioning that at least the puppet master's host entries are present.)
    
    Complete instructions for configuring DNS are beyond the scope of this guide.

Finding Packages and Installing Puppet
-----

> Note: [See here for instructions on installing Puppet Enterprise.][peinstall]

Whenever possible, you should install Puppet with reliable native packages built for your operating system.

### Enterprise Linux Variants

Users of Enterprise Linux (EL) variants, including Red Hat Enterprise Linux, CentOS, Scientific Linux, and Ascendos, can install Puppet from:

* Puppet Labs' official package repository
* The [EPEL][] project's package repositories
* [Puppet Enterprise][peinstall]

All of these sources support EL 5 and 6 releases. No known repositories supply current Puppet packages for EL 4 and prior; users of out-of-production EL systems may need to compile their own copy of Ruby and [install Puppet from gem or source](#appendix-other-installation-methods).

#### Puppet Labs' EL Packages

Puppet Labs provides a set of official package repositories for EL systems at [yum.puppetlabs.com](http://yum.puppetlabs.com). These repositories allow you to install Puppet and its prerequisites without enabling any other external repositories, and they contain the most up-to-date packages available. Most EL users should install from these official packages.

To install Puppet from the official repository:

1. Enable the Puppet Labs repositories on all of your target systems. 
    * On EL 5 systems, run `rpm -ivh {{ yum5package }}`
    * On EL 6 systems, run `rpm -ivh {{ yum6package }}`
2. On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet, its prerequisites, and the init script for running a test-quality puppet master server. Use the `/etc/init.d/puppetmaster` init script to control the puppet master service.
3. On your other nodes, run `sudo yum install puppet`. This will install Puppet, its prerequisites, and the init script for running the puppet agent daemon. Use the `/etc/init.d/puppet` init script to control the puppet agent service. If you will be using Puppet in a masterless configuration, install this package on all nodes.
4. {{ after }}


#### EPEL's Puppet Packages

The [Extra Packages for Enterprise Linux][epel] (EPEL) project maintains a large set of additional packages for EL systems, including Puppet and its prerequisites. These packages are considered reliable and have up-to-date security patches, although they often lag behind the official Puppet Labs packages in features. <!-- dated --> As of April 2012, EPEL was shipping the most recent version in the maintenance-only 2.6.x series rather than a release in the current 2.7.x series. Use the EPEL packages if you:

* Have already enabled EPEL on your systems, and
* Do not need the absolute latest version of Puppet

To install Puppet from EPEL:

1. Enable the EPEL repositories on all of your target systems. ([Official instructions][epelinstall].)
2. On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet, its prerequisites, and the init script for running a test-quality puppet master server. Use the `/etc/init.d/puppetmaster` init script to control the puppet master service.
3. On your other nodes, run `sudo yum install puppet`. This will install Puppet, its prerequisites, and the init script for running the puppet agent daemon. Use the `/etc/init.d/puppet` init script to control the puppet agent service. 
4. {{ after }}

### Debian and Ubuntu

Users of Debian, Ubuntu, and derived Linux distributions can install Puppet from: 

* Puppet Labs' official package repository
* Their distribution's default package repositories
* [Puppet Enterprise][peinstall]

Older OS releases will tend to include older Puppet packages, possibly one to two major versions behind the current release series. We suggest using the official Puppet Labs repo if you are using an older version of Debian or Ubuntu.

#### Puppet Labs' Debian/Ubuntu Packages

Puppet Labs provides a set of official package repositories for Debian and Ubuntu systems at [yum.puppetlabs.com](http://yum.puppetlabs.com). These repositories allow you to install Puppet and its prerequisites without enabling any other external repositories, and they contain the most up-to-date packages available.

The official repo supports the following OS versions:

* Debian 6 "Squeeze" (current stable release)
* Debian 5 "Lenny" (previous stable release)
* Debian "Wheezy" (current testing distribution)
* Debian "Sid" (current unstable distribution)
* Ubuntu 12.04 LTS "Precise Pangolin"
* Ubuntu 11.10 "Oneiric Ocelot"
* Ubuntu 11.04 "Natty Narwhal"
* Ubuntu 10.10 "Maverick Meerkat"
* Ubuntu 10.04 LTS "Lucid Lynx"
* Ubuntu 8.04 LTS "Hardy Heron"

To install Puppet from the official repository:

1. Enable the Puppet Labs repositories on all of your target systems:

        wget {{ aptpackage }}
        dpkg -i puppetlabs-release_1.0-2_all.deb
2. On your puppet master node, run `sudo apt-get install puppetmaster`. This will install Puppet, its prerequisites, and the init script for running a test-quality puppet master server. Use the `/etc/init.d/puppetmaster` init script to control the puppet master service.
3. On your other nodes, run `sudo apt-get install puppet`. This will install Puppet, its prerequisites, and the init script for running the puppet agent daemon. Use the `/etc/init.d/puppet` init script to control the puppet agent service.
    * Alternately, if you will be using Puppet in a masterless configuration, run `sudo apt-get install puppet-common` on all nodes. This will install Puppet without the agent init script. 
4. {{ after }}

#### Default Debian/Ubuntu Puppet Packages

Debian, Ubuntu, and most related distributions include Puppet in the default set of packages. Older OS versions will tend to ship outdated Puppet versions, updating only with conservative security patches. <!-- dated --> As of April 2012:

* Debian stable was shipping a version of Puppet more than 18 months old, with additional security patches.
* Debian testing's Puppet version was one point release behind the current version.
* Debian unstable included the current version of Puppet. 
* Ubuntu's upcoming LTS release's Puppet version was one point release behind the current version.
* Ubuntu's two current non-LTS releases included versions of Puppet that were nine and fifteen months old, with additional security patches.
* Ubuntu's most recent LTS release included a version of Puppet that was more than two years old, with additional security patches.

Thus, users of older OS releases may want to use Puppet's official packages instead of the OS's packages. 

To install Puppet from your OS's default repository:

1. On your puppet master node, run `sudo apt-get install puppetmaster`. This will install Puppet, its prerequisites, and the init script for running a test-quality puppet master server. Use the `/etc/init.d/puppetmaster` init script to control the puppet master service.
    * Alternately, some newer Debian and Ubuntu versions include a `puppetmaster-passenger` package, which installs a production-ready puppet master server by installing Passenger and Apache and automatically creating an appropriate vhost definition. With this package, you control the puppet master by turning the Apache web server on and off or by disabling the puppet master vhost. 
2. On your other nodes, run `sudo apt-get install puppet`. This will install Puppet, its prerequisites, and the init script for running the puppet agent daemon. Use the `/etc/init.d/puppet` init script to control the puppet agent service.
    * Alternately, if you will be using Puppet in a masterless configuration, run `sudo apt-get install puppet-common` on all nodes. This will install Puppet without the agent init script. 
3. {{ after }}


### Fedora


As with Debian and Ubuntu, the older supported release of Fedora will have an older version of Puppet. <!-- dated --> As of April 2012, the current release's Puppet version was approximately one year old, and the previous release's Puppet version was approximately two years old. 


### Mac OS X

### Windows

### Other \*nix Systems

#### Solaris

#### AIX

#### HPUX

#### BSDs






After Installing
-----


### Configure Puppet

The main configuration file used by puppet agent, puppet master, and puppet apply is found at `/etc/puppet/puppet.conf`. (When running as a user other than root, it can be found at `~/.puppet/puppet.conf`.)

See [Configuring Puppet][configuring] for more information about configuration. At a minimum, however, you will probably want to make the following configuration changes before running Puppet:

#### On Agent Nodes

Settings for agent nodes should go in the `[agent]` or `[main]` block of `puppet.conf`.

* **Server:** If the public-facing hostname of your puppet master server(s) isn't the default of `puppet`, you should specify the master's hostname in the [`server`](/references/latest/configuration.html#server) setting. (Note: This is why we recommend making the puppet master reachable at the hostname `puppet`.)
* **Report:** Set [`report`](/references/latest/configuration.html#report) to `true` if you want your agents to send reports to the master. (You almost definitely do.)
* **Pluginsync:** Almost all users should set [`pluginsync`](/references/latest/configuration.html#pluginsync) to `true` on their agent nodes. 
* **Certname:** The "certname" is the sitewide unique identifier that will be embedded  in each agent node's certificate. It defaults to the node's fully qualified domain name; if you need to use something other than a hostname as the unique identifier, specify each node's name in its [`certname`](/references/latest/configuration.html#certname) setting.

#### On Puppet Master Servers

Settings for puppet master servers should go in the `[master]` or `[main]` block of `puppet.conf`.

> Note that puppet masters are usually also agent nodes; settings in `[main]` will be available to both services, and settings in the `[master]` and `[agent]` blocks will override the settings in `[main]`.

* **DNS alt names:** Agent nodes will only trust the puppet master if the hostname at which they contact it is embedded in the master's SSL certificate. By default, the master's certificate will contain:

    * The master's `certname`
    * `puppet`
    * `puppet.<DOMAIN>`
    
    (Note: This is why we recommend making the puppet master reachable at the hostname `puppet`.)
    
    If the hostname you are using as the public-facing address of the puppet master is not in this list of defaults, you must specify a comma-separated list of valid hostnames in the [`dns_alt_names`](/references/latest/configuration.html#dns_alt_names) setting.

    The puppet master's certificate is automatically generated the first time the puppet master service is started. If you have accidentally generated a certificate that lacks the required DNS names, you must:
    
    * Stop the puppet master service
    * Set `dns_alt_names` correctly
    * Run `sudo puppet cert clean <PUPPET MASTER'S CERTNAME>`
    * Run `sudo puppet master --no-daemonize --verbose`, then hit ctrl-C after a message like `notice: Starting Puppet master version 2.7.12` appears
    * Re-start the puppet master service
    
    You can check the current DNS names in the puppet master's certificate by running `sudo puppet cert list --all | grep <PUPPET MASTER'S CERTNAME>`.
* **Web server:** If you are running Puppet in an agent/master arrangement, you **must** [configure the puppet master to run under a scalable web server][scaling] after you have done some minimal testing. The default puppet master init scripts use Ruby's built-in WEBrick server, which is simpler to configure but cannot support real-life workloads. 

    This is a complex setting that requires a separate guide to explain. See [Scaling with Passenger][passenger] for the most widely-used approach to changing the web server.
    
    Changing the web server does not require any change to the configurations of agent nodes, and can thus be done at any time.

#### On Standalone Puppet Nodes

Settings for standalone puppet nodes should go in the `[user]` or `[main]` block of `puppet.conf`.

Puppet's default settings are generally appropriate for standalone nodes. No additional configuration is necessary unless you intend to use centralized reporting or an [external node classifier](/guides/external_nodes.html).

### Start and Enable the Puppet Services

Some packages do not automatically start the puppet services after installing the software. You may need to start them manually in order to use Puppet.

#### Puppet Agent

Most packages create an init script called `puppet` in `/etc/init.d`. 

* Run `sudo /etc/init.d/puppet status` (or the equivalent command on your system) to check whether puppet agent is running.
* Run `sudo /etc/init.d/puppet start` (or the equivalent command on your system) to start puppet agent.
* See documentation for your operating system for information on configuring a service to start at boot. 

> **Note:** Depending on your OS's version of Ruby, long-running processes like puppet agent may be unreliable or prone to excessive memory usage. If you are concerned about this, you can:
> 
> 1. Configure the puppet agent service to never be running.
> 2. Create a cron job that runs `puppet agent --test` as root every 30 minutes. 
> 
> See documentation for your operating system for information on creating cron jobs.

#### Puppet Master

Most packages create an init script called `puppetmaster` in `/etc/init.d`. This script starts and stops a WEBrick-based puppet master server, which can be used for testing. 

* Run `sudo /etc/init.d/puppetmaster status` (or the equivalent command on your system) to check whether puppet master is running.
* Run `sudo /etc/init.d/puppetmaster start` (or the equivalent command on your system) to start puppet master.

> **Note:** If you have configured puppet master to use a production-ready web server, do not use the default init script; instead, start and stop the web server that is managing the puppet master service. (When using Passenger and Apache, you would start and stop the puppet master by starting and stopping the `httpd` or `apache2` service.)

#### Puppet Apply

If you are running a masterless standalone deployment of Puppet, you will need to create a cron task on every node that runs the following command as root every 30 minutes (or desired interval):

    puppet apply $(puppet --configprint manifest)

(See documentation for your operating system for information on creating cron jobs.)

This command will make Puppet compile and apply catalogs from the **site manifest,** much the same way the puppet master service does. This will make it easier to switch between standalone and agent/master arrangements in the future.

The location of the site manifest defaults to `/etc/puppet/manifests/site.pp`. It can be configured with the [`manifest`](/references/latest/configuration.html#manifest) setting in the `[main]` block of `puppet.conf`.

### Sign Node Certificates

If you are running Puppet in an agent/master arrangement, an admin must approve a certificate request for each agent node before that node is allowed to fetch configurations from the puppet master. 

* Agent nodes will request certificates the first time puppet runs.
* Admins should periodically log into the puppet master server and run `sudo puppet cert list` to view outstanding requests; use `sudo puppet cert sign <NAME>` to sign a request, or `sudo puppet cert sign --all` to sign all pending requests.
* Agent nodes will fetch and use their signed certificate the next time puppet runs.

### Install Optional Software

You can extend and improve Puppet with other software:

* [Puppet Dashboard][dashboard] is an open-source report analyzer, node classifier, and web GUI for Puppet.
* [The stdlib module][stdlib] adds extra functions, an easier way to write custom facts, and more.
* The [Hiera][] data lookup tool helps you separate your data from your Puppet manifests and write cleaner code. 
* User-submitted modules that solve common problems are available at the [Puppet Forge][forge]. Search here first before writing a new Puppet module from scratch; you can often find something that suits your needs or can be quickly hacked to do so.

### Learn to Use Puppet

If you have not used Puppet before, you should read the [Learning Puppet](/learning/) series and experiment with the Learning Puppet VM. This series will introduce the concepts underpinning Puppet, and will guide you through the process of writing Puppet code, using modules, and classifying nodes. 

If you would prefer to dive directly in without reading a full introduction:

* Read the [Puppet Best Practices guide][bestpractice]; it is short and will keep you from making life harder for yourself.
* Open the [language guide](/guides/language_guide.html) and the [type reference](/references/latest/type.html) in your web browser; keep them open indefinitely and refer to them often.
* Start messing around by [**declaring resources**](/guides/language_guide.html#resources) in the **site manifest.** This file is usually located at `/etc/puppet/manifests/site.pp`, and can be changed with the `manifest` setting in `puppet.conf`. Puppet master and puppet apply both start with this file when compiling configurations.
* Run `sudo puppet agent --test` or `sudo puppet apply <PATH TO MANIFEST>` to see your resources take effect.
* Next, group resources into [classes](/guides/language_guide.html#classes) and store them in [modules][]. Edit `site.pp` to **declare classes** with the `include` keyword instead of declaring bare resources. Test with puppet agent or puppet apply as above.
* Next, group the class declarations into [node definitions](/guides/language_guide#nodes) in `site.pp` so that different nodes receive different configurations. (Node definitions work the same way for puppet master and puppet apply.)





Appendix: Other Installation Methods
-----

In almost all cases, we recommend installing Puppet from packages built for your operating system. However, there are a few other options available:

### Installing from Gems

This is recommended only for platforms that do not have native packages available.

Puppet can be installed with Ruby's `gem` package manager. To install Puppet and Facter, simply run:

    # sudo gem install puppet

> Note that this does not leave you with a fully functional Puppet installation. To make Puppet usable, you must first: 

* Create a `puppet` user and group, using your operating system's user management tools.
* Create and install init scripts for the puppet agent and/or puppet master services. To find examples to modify, locate the Puppet source on disk and see the scripts included in the `conf/` directory.
* Manually create an `/etc/puppet/puppet.conf` file, and use it to [configure Puppet][configuring] as needed.
* Locate the Puppet source on disk, and manually copy the `auth.conf` file from the `/conf` directory to `/etc/puppet/auth.conf`.
* If you get the error `require: no such file to load`, define the RUBYOPT environment variable as advised in the [post-install instructions](http://docs.rubygems.org/read/chapter/3#page70) of the RubyGems User Guide.

### Installing from Source

This is recommended only for developers and testers. 

See [Installing Puppet from Source](/guides/from_source.html).

### Installing from a Tarball

This is almost never recommended, but may be necessary in some rare cases.

* Download a source archive of Puppet [here][downloads]. The file name will be in the format `puppet-<VERSION>.tar.gz`. 
* Unarchive the tarball, navigate to the directory, and run:

        # sudo ruby install.rb
* Manually create a `puppet` user and group.
* Manually create and install init scripts for the puppet agent and/or puppet master services. To find examples to modify, see the scripts included in the `conf/` directory.
* Manually create an `/etc/puppet/puppet.conf` file, and use it to [configure Puppet][configuring] as needed.
* Manually copy the `auth.conf` file from the source's `/conf` directory to `/etc/puppet/auth.conf`.









* * * 




Before Starting
---------------

You will need to install Puppet on both [managed nodes](./tools.html#puppet-agent-or-puppetd)
and the central [Puppet master server(s)](./tools.html#puppet-master-or-puppetmasterd)
in order to run puppet in client server mode.
If you will just be running [Puppet standalone](./tools.html#puppet-apply-or-puppet)
you don't need a Puppet master server and installation on just one machine will suffice.


For most platforms, you can install 'puppet' via your package
manager of choice.  For a few platforms, you will need to install
using the [tarball](http://www.puppetlabs.com/downloads/puppet/) or
[RubyGems](http://www.puppetlabs.com/downloads/gems/).

INFO: For instructions on installing puppet using a distribution-specific package manager, consult your operating system documentation.  Volunteer contributed operating system packages can also be found on the [downloads page](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet)


OS Packages
-----------

If installing from a distribution maintained package, such as those listed on the [Downloading Puppet Wiki Page](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet) all OS prerequisites should be handled by your package manager.  See the Wiki for information on how to enable repositories for your particular OS.  Usually the latest stable version is available as a package.  If you would like to do puppet-development or see the latest versions, however, you will want to install from source.





Learning and Configuring Puppet
------------------

