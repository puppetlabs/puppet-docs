---
layout: default
title: "Installing Puppet Agent: Linux"
canonical: "/puppet/latest/install_linux.html"
---

[master_settings]: ./config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[where]: ./whered_it_go.html
[dns_alt_names]: ./configuration.html#dnsaltnames
[server_heap]: {{puppetserver}}/install_from_packages.html#memory-allocation
[puppetserver_confd]: {{puppetserver}}/configuration.html
[server_install]: {{puppetserver}}/install_from_packages.html
[modules]: ./modules_fundamentals.html
[main manifest]: ./dirs_manifest.html
[environments]: ./environments.html
[puppet_collections]: ./puppet_collections.html
[puppet_agent]: ./about_agent.html
[server_setting]: ./configuration.html#server
[system_requirements]: ./system_requirements.html

> **Note:** These instructions describe how to install the open source Puppet agent software on Linux distributions for which Puppet provides official packages.
>
> -   To install the Puppet Enterprise agent on supported operating systems, see [its documentation]({{pe}}/install_agents.html).
> -   To install the open source agent on Linux distributions that don't have official packages, review [Puppet's prerequisites](./system_requirements.html#platforms-without-packages).
> -   To install the open source agent on Windows operating systems, see the [Windows installation instructions](./install_windows.html).
> -   To install the open source agent on OS X, see the [OS X installation instructions](./install_osx.html).
> -   To install open source Puppet Server on a Puppet master, see [its documentation][server_install].

## Make sure you're ready

Before installing Puppet agent on any nodes, complete the [pre-install tasks](./install_pre.html) and [install Puppet Server][server_install] on your designated Puppet master.

> **Note:** Puppet 4 changes the locations for many of the most important files and directories. If you're familiar with Puppet 3 and earlier, read [a summary of the changes][where] and refer to the [full specification of Puppet directories](https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md).

## Review system requirements

The agent service requires few resources and runs on many systems. For details, see Puppet's [system requirements][system_requirements].

## Install a release package to enable Puppet Collection repositories

For most Linux distributions (including CentOS, Red Hat, Ubuntu, and Debian), you can install official Puppet agent packages directly from Puppet.

Release packages configure your system to download and install appropriate versions of the Puppet packages, including the [`puppet-agent`][puppet_agent] package. These packages are grouped into a [Puppet Collection][puppet_collections] repository comprised of compatible versions of Puppet tools.

> **Note:** Your distribution's repositories might provide their own Puppet packages, which often install older versions of the Puppet agent service. To install the latest version of Puppet and receive updates as soon as we release them, use a Puppet Collection repository.

{% include puppet-collections/_puppet_collections_intro.md %}

{% include puppet-collections/_puppet_collection_1_contents.md %}

### Installing release packages on Yum-based systems

{% include puppet-collections/_puppet_collection_1_yum.md %}

> **Note:** To install the release package on Red Hat Enterprise Linux 5, you must download it first. The `rpm` package manager on RHEL 5 doesn't support installing packages from a URL.

### Installing release packages on Apt-based systems

{% include puppet-collections/_puppet_collection_1_apt.md %}

## Confirm that you can run Puppet executables

Since version 4, Puppet's executables are installed to `/opt/puppetlabs/bin/`, which is not in the default `PATH` environment variable.

This doesn't matter for Puppet services --- for instance, the `service puppet start` command works regardless of the `PATH` --- but if you're running interactive `puppet` commands, you must either add their location to your `PATH` or execute them using their full path.

To quickly add this location to your `PATH` for your current terminal session only, run `export PATH=/opt/puppetlabs/bin:$PATH`. You can also add this location wherever you configure your `PATH`, such as your `.profile` or `.bashrc` configuration files.

For more information, review the [list of files and directories moved in Puppet 4][where].

## Install the `puppet-agent` package

Use your operating system's package manager to install the `puppet-agent` package. After installing the package, **do not** start the `puppet` service until you [configure critical settings](#configure-critical-agent-settings).

### For Yum-based systems

On each node, run:

    sudo yum install puppet-agent

### For Apt-based systems

On each node, run:

    sudo apt-get install puppet-agent

## Configure critical agent settings

Set the agent's [`server` setting][server_setting] to your Puppet master's hostname. The default value is `server = puppet`, so if your master's hostname is already `puppet`, you can skip this step.

See the [list of agent-related settings][agent_settings] for more configuration options.

## Start the `puppet` service

To start the `puppet` service, run:

    sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

By default, the service performs a Puppet run every 30 minutes. To manually launch and watch a Puppet run, run:

    sudo /opt/puppetlabs/bin/puppet agent --test

## Sign certificates on the CA master

As each agent attempts its first run, it submits a certificate signing request (CSR) to the certificate authority (CA) Puppet master. The CA master must sign these certificates before it can manage the agents.

To do this:

1.  Log into the CA Puppet master.

2.  View outstanding requests by running:

        sudo puppet cert list

3.  Sign a request by running:

        sudo puppet cert sign <NAME>

    Once the Puppet master signs an agent's certificate, the agent regularly fetches and applies configuration catalogs from the master.

> **Note:** The Puppet documentation includes a [detailed description of Puppet's agent/master communications](./subsystem_agent_master_comm.html).
