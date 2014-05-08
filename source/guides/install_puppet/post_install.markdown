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

