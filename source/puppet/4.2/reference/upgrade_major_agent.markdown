---
layout: default
title: "Puppet 3.x to 4.x Agent Upgrades"
canonical: "/puppet/latest/reference/upgrade_major_agent.html"
---

[Hiera]: /hiera/
[MCollective]: /mcollective/
[`puppet_agent`]: https://forge.puppetlabs.com/puppetlabs/puppet_agent
[moved]: ./whered_it_go.html

Due to the many changes in Puppet 4, the upgrade process for Puppet 3 agents can get complicated. For instance, you'll need to move configurations and credentials for Puppet and [MCollective][].

However, since Puppet agent primarily does what Puppet Server tells it to do, it's relatively easier to upgrade.

## Decide How to Upgrade Your Nodes

We provide a module called [`puppet_agent`][] to simplify upgrades from Puppet 3 to 4.

If you're running Puppet on Windows or [any supported Linux operating system](./system_requirements.html#platforms-with-packages), this module can automatically upgrade Puppet, MCollective, and all of their dependencies on agent nodes.

[//]: # (The Forge page says the module only supports Red Hat or CentOS. The module's [`metadata.json`](https://github.com/puppetlabs/puppetlabs-puppet_agent/blob/master/metadata.json) file lists support with RH, CentOS, Debian, Ubuntu, and SLES. The 4.2 supported OS list doesn't include SLES. Can we get these to line up?)

If you're running Puppet on other operating systems, you can't upgrade them with the module. You'll need to either upgrade your agents manually or automate the process yourself.

This document guides you step-by-step through both methods.

## Upgrade with the `puppet_agent` Module

> **Note**: This module only works on Windows and supported Linux distributions. If your agents run any other operating systems, skip to ["Upgrade Manually or Build Your Own Automation"](#upgrade-manually-or-build-your-own-automation).

The `puppet_agent` module does these things for you:

- Enables the Puppet Collection 1 (PC1) repo, if applicable.
- Installs the latest version of the `puppet-agent` package, which replaces the installed versions of Puppet and [MCollective][].
- Copies Puppet's SSL files to their new location.
- Copies your old `puppet.conf` to Puppet 4's [new location](https://docs.puppetlabs.com/puppet/4.0/reference/whered_it_go.html), then cleans out old settings that we either removed in Puppet 4 or needed to revert to their default values.
- Copies your MCollective server and client configuration files to their new locations, and adds [the new plugin path](/mcollective/deploy/plugins.html) to the `libdir` setting.
- Ensures the Puppet and MCollective services are running.

`puppet_agent` is completely inert on nodes already running Puppet 4---its only purpose is to help you upgrade from Puppet 3.

### Install the Module on Puppet Servers

* If you manage your Puppet code manually, you can use install it with `puppet module install puppetlabs/puppet_agent --environment <ENVIRONMENT>`    
* If you manage your code with [r10k](/pe/latest/r10k.html), add the module and its dependencies to your Puppetfile. 
* If you manage your code some other way, install `puppet_agent` as you would any other module.

### Assign the `puppet_agent` Class to Nodes

However you classify nodes---whether in the [main mainfest][./dirs_manifest.html], with an [external node classifier](/guides/external_nodes.html) or [Hiera][], or some other solution---remember to classify your agents with `puppet_agent`.

You can also [configure the module](https://forge.puppetlabs.com/puppetlabs/puppet_agent/readme#usage) to control which services start or to force a different architecture on Windows.

As with any major configuration deployment, carefully control and monitor the rollout. Assign the class in a dev or test environment to ensure it works as expected on systems similar to your production environment, then roll it out to your live agents in phases and monitor the upgraded agents for issues.

## Upgrade Manually or Build your Own Automation

To upgrade agents without the `puppet_agent` module, you can either install the upgrades manually or design your own upgrade automation.

### Install the New Version of Puppet

Follow the installation instructions for [Linux](./install_linux.html#download-the-windows-puppet-package) or [Windows](./install_windows.html#install-puppet-on-agent-nodes).

### Migrate SSL Files (\*nix Only)

On \*nix systems, we [moved][] the default [`confdir`](./dirs_confdir.html) to `/etc/puppetlabs/puppet` in Puppet 4. Since the default [`ssldir`](./dirs_ssldir.html) is `$confdir/ssl`, its location changes during the upgrade.

In Puppet 3, the default `ssldir` is `/etc/puppet/ssl`; some systems might also use  `/var/lib/puppet/ssl`.

Locate your [`ssldir`](./dirs_ssldir.html) in `/etc/puppet/puppet.conf`, then move that directory's contents to `/etc/puppetlabs/puppet/ssl` without changing the files' permissions:

`cp -rp /var/lib/puppet/ssl /etc/puppetlabs/puppet/ssl`

### Reconcile `puppet.conf`

On \*nix systems, we [moved][] [`puppet.conf`](./config_file_main.html) from `/etc/puppet/puppet.conf` to `/etc/puppetlabs/puppet/puppet.conf`. You need to either edit the new `puppet.conf` file or copy your old version. (We didn't change `puppet.conf`'s location on Windows.)

Examine `puppet.conf` regardless of OS and determine whether:

* It includes any modified settings you care about.
* It excludes any settings that were [removed in Puppet 4.0](/puppet/3.8/reference/deprecated_settings.html). Notably, if you set `stringify_facts=false` [before upgrading](./upgrade_major_pre.html), you can remove this setting.

### Start Service or Update Cron Job

We also [moved][] Puppet binaries to `/opt/puppetlabs/bin` in Puppet 4. If you run Puppet as a service, it should be configured to launch at boot using `/opt/puppetlabs/bin/puppet resource`:

`/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`

On Windows, you can use the same command but omit the `/opt/puppetlabs/bin/` prefix.

If you use a cron job to periodically run `puppet agent -t` on your \*nix systems, edit the job and update the `puppet` binary's path to `/opt/puppetlabs/bin/puppet`.

### Reconcile MCollective Config Files (\*nix Only)

On \*nix systems, we [moved][] MCollective's configuration files from `/etc/mcollective` to `/etc/puppetlabs/mcollective`.

Edit the new configuration files to port over any settings you need from the old configuration files. Note that the default plugin and library directories also changed; you should update your settings to use both the new directories and any other directories you wish to use.