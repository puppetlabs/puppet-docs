---
layout: default
title: "Installing Puppet Agent: Linux"
canonical: "/puppet/latest/install_linux.html"
---

[master_settings]: ./config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[where]: ./whered_it_go.html
[dns_alt_names]: /puppet/latest/configuration.html#dnsaltnames
[server_heap]: /puppetserver/2.2/install_from_packages.html#memory-allocation
[puppetserver_confd]: /puppetserver/2.2/configuration.html
[server_install]: /puppetserver/2.2/install_from_packages.html
[modules]: ./modules_fundamentals.html
[main manifest]: ./dirs_manifest.html
[environments]: ./environments.html
[Puppet Collection]: ./puppet_collections.html
[`puppet-agent`]: ./about_agent.html

## Make sure you're ready

Before installing Puppet on any agent nodes, make sure you've read the [pre-install tasks](./install_pre.html) and [installed Puppet Server][server_install].

> **Note:** Puppet 4 changed the locations for many of the most important files and directories. If you're familiar with Puppet 3 and earlier, read [a summary of the changes][where] and refer to the [full specification of Puppet directories](https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md).

## Review supported versions and requirements

Most Linux systems (including CentOS, Redhat, Ubuntu, and Debian) have official Puppet agent packages. For a complete list of supported platforms, view the [system requirements page.](./system_requirements.html)

## Install a release package to enable Puppet Collection repositories

Release packages configure your system to download and install appropriate versions of the `puppetserver` and [`puppet-agent`][] packages. These packages are grouped into a [Puppet Collection][] repository comprised of compatible versions of Puppet tools.

{% include puppet-collections/_puppet_collections_intro.md %}

{% include puppet-collections/_puppet_collection_1_contents.md %}

### Installing release packages on Yum-based systems

{% include puppet-collections/_puppet_collection_1_yum.md %}

> **Note:** We only provide the `puppet-agent` package for recent versions of Puppet on RHEL 5, and to install it you must first download the package as `rpm` on RHEL 5 doesn't support installing packages from a URL.

### Installing release packages on Apt-based systems

{% include puppet-collections/_puppet_collection_1_apt.md %}

## Confirm you can run Puppet executables

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your `PATH` environment variable by default.

This doesn't matter for Puppet services --- for instance, `service puppet start` works regardless of the `PATH` --- but if you're running interactive `puppet` commands, you must either add their location to your `PATH` or execute them using their full path.

To quickly add this location to your `PATH` for your current terminal session, use the command `export PATH=/opt/puppetlabs/bin:$PATH`. You can also add this location wherever you configure your `PATH`, such as your `.profile` or `.bashrc` configuration files.

For more information, see [our page about files and directories moved in Puppet 4][where].

## Install the `puppet-agent` package

### For Yum-based systems

On your Puppet agent nodes, run `sudo yum install puppet-agent`.

### For Apt-based systems

On your Puppet agent nodes, run `sudo apt-get install puppet-agent`.

**Do not** start the `puppet` service yet.

## Configure critical agent settings

You probably want to set the `server` setting to your Puppet master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

For other settings you might want to change, see [the list of agent-related settings][agent_settings].

## Start the `puppet` service

To start the Puppet service, run `sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`.

To manually launch and watch a Puppet run, run `sudo /opt/puppetlabs/bin/puppet agent --test`.

## Sign certificates on the CA master

As each Puppet agent runs for the first time, it submits a certificate signing request (CSR) to the certificate authority (CA) Puppet master. You must log into that server to check for and sign certificates. On the Puppet master:

1. Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
1. Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

After an agent's certificate is signed, it regularly fetches and applies configuration catalogs from the Puppet master.