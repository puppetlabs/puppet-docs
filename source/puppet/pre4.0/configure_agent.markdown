---
layout: default
title: "Installing Puppet: Post-Install: Configure Puppet Agent"
---

[peinstall]: /pe/latest/install_basic.html
[hiera_include]: /hiera/latest/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude
[hiera]: /hiera/latest/
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[dns_alt_names]: /references/latest/configuration.html#dnsaltnames
[about_settings]: /puppet/latest/reference/config_about_settings.html
[manifest]: /puppet/latest/reference/dirs_manifest.html
[install_modules]: /puppet/latest/reference/modules_installing.html
[directory environments]: /puppet/latest/reference/environments.html
[modulepath]: /puppet/latest/reference/dirs_modulepath.html
[rack]: http://rack.github.io/
[multi_masters]: /guides/scaling_multiple_masters.html
[puppet classes]: /puppet/latest/reference/lang_classes.html
[modules_fundamentals]: /puppet/latest/reference/modules_fundamentals.html
[node definitions]: /puppet/latest/reference/lang_node_definitions.html
[external node classifier]: /guides/external_nodes.html
[ssldir]: /puppet/latest/reference/dirs_ssldir.html


After installing Puppet on a normal puppet agent node, you'll need to:

* Configure Puppet
* Start the puppet agent service (or configure a cron job)
* Sign the new node's certificate
* Classify (assign configurations to) the new node


## Configure Puppet

You will probably need to configure some settings in each agent's [puppet.conf][] file.

At the least, you'll want to make sure the `server` setting points to your preferred DNS name for your Puppet Server node. The default value is `server = puppet`.

See [the list of agent-related settings][agent_settings] for details. You may also want to read about [how Puppet loads settings][about_settings] and [the syntax of the puppet.conf file][puppet.conf].

[agent_settings]: /puppet/latest/reference/config_important_settings.html#settings-for-agents-all-nodes


## Start the Puppet Agent Service

If the puppet agent service isn't already running, you should now start it and configure it to start on boot. Alternately, you may want to run puppet agent via a cron job instead, or run puppet apply with a cron job for a standalone deployment.

### Starting the Service

The name of the puppet agent service may vary by platform. On Windows and most \*nix platforms, it will be `puppet`; on OS X, it is `com.puppetlabs.puppet`.

You can start and enable the service by running:

    $ sudo puppet resource service <NAME> ensure=running enable=true

(Although on Windows you would omit the `sudo`.)

### Creating a Cron Job

You may want to run puppet agent with cron rather than its init script; this can sometimes perform better and use less memory. You can create this cron job with Puppet:

    $ sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

(On Windows nodes, you should just run the service.)

If you are creating a standalone deployment, you can create a similar cron job to run puppet apply instead of puppet agent:

    $ sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/usr/bin/puppet apply $(puppet apply --configprint manifest)'


## Sign the New Node's Certificate

In an agent/master deployment, an admin must approve a certificate request for each agent node before that node can fetch configurations. Agent nodes will request certificates the first time they attempt to run.

* Periodically log into the CA puppet master server and run `sudo puppet cert list` to view outstanding requests.
* Run `sudo puppet cert sign <NAME>` to sign a request, or `sudo puppet cert sign --all` to sign all pending requests.

An agent node whose request has been signed on the master will run normally on its next attempt.

## Classify the Node

At this point, the new agent node will fetch and apply configurations from the puppet master server. It's up to you to make sure the configurations it fetches will actually do something. You can do this by assigning [Puppet classes][] to the node.

Classes are made available by Puppet modules; you'll need to [install some on the puppet master][install_modules] or [write your own][modules_fundamentals]. Once you have classes available, you can:

* Use [node definitions][] in the [main manifest][manifest] to determine which nodes receive which classes.
* Use an [external node classifier][] to assign classes to nodes.
* Use [Hiera][] to classify your nodes via [the `hiera_include` function][hiera_include].

