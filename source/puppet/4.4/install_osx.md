---
layout: default
title: "Installing Puppet Agent: OS X"
canonical: "/puppet/latest/install_osx.html"
---

[server_install]: {{puppetserver}}/install_from_packages.html
[where]: ./whered_it_go.html
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[puppet_collections]: ./puppet_collections.html
[server_setting]: ./configuration.html#server

> **Note:** These instructions describe how to install the open source Puppet agent software on OS X.
>
> -   To install the Puppet Enterprise agent on supported operating systems, see [its documentation]({{pe}}/install_agents.html).
> -   To install the open source agent on Linux distributions that don't have official packages, review [Puppet's prerequisites](./system_requirements.html#platforms-without-packages).
> -   To install the open source agent on Windows operating systems, see the [Windows installation instructions](./install_windows.html).
> -   To install the open source agent on Linux distributions, see the [Linux installation instructions](./install_linux.html).
> -   To install open source Puppet Server on a Puppet master, see [its documentation][server_install].

## Make sure you're ready

Before installing Puppet agent on any nodes, complete the [pre-install tasks](./install_pre.html) and [install Puppet Server][server_install] on your designated Puppet master.

> **Note:** Puppet 4 changes the locations for many of the most important files and directories. If you're familiar with Puppet 3 and earlier, read [a summary of the changes][where] and refer to the [full specification of Puppet directories](https://github.com/puppetlabs/puppet-specifications/blob/master/file_paths.md).

## Review supported versions

Puppet agent is distributed in a package that includes all of Puppet's prerequisites. You don't need to download anything else to install Puppet agent on a node. These packages are tied to a [Puppet Collection][puppet_collections] (PC), which is a set of Puppet 4 software designed and tested to work well together.

{% include pup44_platforms_osx.markdown %}

## Download the OS X `puppet-agent` package

{% include puppet-collections/_puppet_collection_1_osx.md %}

{% include puppet-collections/_puppet_collection_1_osx1011.md %}
{% include puppet-collections/_puppet_collection_1_osx1010.md %}
{% include puppet-collections/_puppet_collection_1_osx1009.md %}

You can also download older versions of Puppet from [downloads.puppetlabs.com](https://downloads.puppetlabs.com/mac/). Browse to `<OS X VERSION>/PC1/x86_64` for the most recently released packages. For example, the path to the PC1 package for OS X 10.11 is `https://downloads.puppetlabs.com/mac/10.11/PC1/x86_64`.

### Choosing a package

Packages are named according to their `puppet-agent` version and compatible OS X version. They also contain a release number --- typically `1` --- that represents the iteration of that version's package.

    puppet-agent-<PACKAGE VERSION>-<RELEASE NUMBER>.osx<OS X VERSION>.dmg

For example, the filename for the first release of the `puppet-agent` 1.4.2 package on OS X 10.11 is:

    puppet-agent-1.4.2-1.osx10.11.dmg

To see which versions of Puppet, its related tools, and required components are in a given `puppet-agent` release, as well as release notes for each release, see [About Puppet agent](./about_agent.html).

> #### Previous package names
>
> We used different naming schemes in the `puppet-agent` 1.2 series before settling on the current convention used since 1.2.5.
>
> -   **1.2.0 through 1.2.2:** `puppet-agent-<PACKAGE VERSION>-osx-<OS X VERSION>-<ARCH>.dmg`. Redundant; OS X only runs on x86_64.
> -   **1.2.4:** `puppet-agent-<PACKAGE VERSION>-<OS X CODE NAME>.dmg`. This was too hard for automated tooling to deal with, because OS X's built-in CLI tools don't report the code name.

## Make sure you can run Puppet executables

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your `PATH` environment variable by default.

This doesn't matter for Puppet services, so enabling or disabling Puppet agent with `launchctl` works fine. However, to run interactive `puppet` commands, either add the location to your `PATH` or refer to the executables by their full locations.

For more information, see [our page about files and directories moved in Puppet 4][where].

## Install Puppet

There are three ways to install Puppet on OS X:

-   [With the GUI installer.](#installing-with-the-gui)
-   [On the command line.](#installing-on-the-command-line)
-   [With Puppet](#upgrading-with-puppet) (if upgrading).

Regardless of which method you choose, the `puppet` and `mcollective` services launch automatically once they're installed. You can disable these services with `launchctl` or by running:

    sudo puppet resource service <SERVICE NAME> ensure=stopped enable=false

### Installing with the GUI

To install Puppet with a graphic user interface:

1.  Double-click the `puppet-agent` disk image you downloaded.

    OS X verifies the image, and then mounts it at `/Volumes/<DMG NAME>`. A Finder window then appears showing the image's contents: a single `puppet-agent-<PACKAGE VERSION>-<RELEASE NUMBER>-installer.pkg` file.

2.  Double-click the package file, and then follow the installer prompts.

    Once the installation is complete, the `puppet` and `mcollective` services launch automatically.

3.  Unmount the disk image. You can then delete the image.

### Installing on the command line

You can use the `hdiutil` and `installer` commands to mount the disk image, and then install the package from the command line.

1.  Mount the disk image by running:

        sudo hdiutil mount <DMG FILE>

2.  Locate the `.pkg` file in the mounted volume and install it by running:

        sudo installer -pkg /Volumes/<IMAGE>/<PKG FILE> -target /

        Once the installation is complete, the `puppet` and `mcollective` services launch automatically.

3.  Unmount the disk image by running:

        sudo hdiutil unmount /Volumes/<IMAGE>

    You can then delete the disk image.

### Upgrading with Puppet

If you already have Puppet installed, you can use the `puppet resource` command to upgrade with fewer steps.

1.  Locate the `puppet-agent` disk image you downloaded, and note both the filename and its full path on disk.

2.  Have Puppet install the package by running:

        sudo puppet resource package "<IMAGE NAME>.dmg" ensure=present source=<FULL PATH TO IMAGE>

## Configure critical agent settings

Set the agent's [`server` setting][server_setting] to your Puppet master's hostname. The default value is `server = puppet`, so if your master's hostname is already `puppet`, you can skip this step.

See the [list of agent-related settings][agent_settings] for more configuration options.

## Test Puppet agent

By default, the `puppet` service performs a Puppet run every 30 minutes. To manually launch and watch a Puppet run, run:

    sudo puppet agent --test

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
