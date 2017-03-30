---
layout: default
title: "Installing Puppet agent: macOS"
---

[server_install]: {{puppetserver}}/install_from_packages.html
[where]: ./whered_it_go.html
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[Puppet Collection]: ./puppet_collections.html

These instructions cover installing Puppet agent on macOS machines.

1. Make sure you're ready.

Before installing Puppet agent, read the [pre-install tasks](./install_pre.html) and [install Puppet Server][server_install].

> **Note:** If you've used older Puppet versions, Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]

2. Download the macOS [`puppet-agent` package](https://downloads.puppetlabs.com/mac/) specific to your version of macOS.
   
   The `puppet-agent` package bundles all of Puppet's prerequisites, so you don't need to download anything else to install Puppet on an agent node.

   OS X packages are named according to their `puppet-agent` version and compatible OS X version:

    `puppet-agent-<PACKAGE VERSION>.osx<OS X VERSION>.dmg`

   For example:

    `puppet-agent-1.3.2.osx10.11.dmg`

   To see which versions of Puppet and its related tools and components are in a given `puppet-agent` release, as well as release notes for each release, [see About Puppet agent](./about_agent.html).

   > **Previous package names**
   >
   > We used some different naming schemes in the puppet-agent 1.2 series before settling on the current convention in 1.2.5.
   >
   > * 1.2.0 through 1.2.2: `puppet-agent-<VERSION>-osx-<OS X VERSION>-<ARCH>.dmg`. Redundant; OS X only runs on x86_64.
   > * 1.2.4: `puppet-agent-<VERSION>-<OS X CODE NAME>.dmg`. This was too hard for automated tooling to deal with, because OS X's built-in CLI tools don't report the code name.

3. Make sure you can run Puppet executables.

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your `PATH` environment variable by default.

This doesn't matter for Puppet services, so enabling or disabling Puppet agent with `launchctl` works fine. However, if you're running any interactive `puppet` commands, you need to either add the location to your `PATH` or refer to the executables by their full locations.

For more information, see [our page about files and directories moved in Puppet 4][where].

4. Install Puppet

   There are three ways to install Puppet on OS X:

   * With the GUI installer.
   * On the command line.
   * With Puppet (if upgrading).

   Regardless which you choose, installing the package will start the `puppet` and `mcollective` services. You can later disable these services with `launchctl` or with `sudo puppet resource service <NAME> ensure=stopped enable=false`.

   Installing with the GUI:

   1. Double-click the `puppet-agent` disk image you downloaded. This mounts it at `/Volumes/<DMG NAME>`.
      A Finder window appears showing the disk's contents: a single `puppet-agent-<VERSION>-installer.pkg` file. 

   2. Double-click the package file, and follow the installer prompts to install it. When installation finishes, Puppet agent and MCollective will be running.

   3. After installing, unmount and delete the disk image.

   Installing on the command line:

   Alternately, you can use the `hdiutil` and `installer` commands to mount the disk image and install the package from the command line.

   1. Mount the disk image by running `sudo hdiutil mount <DMG FILE>`.

   2. Locate the `.pkg` file in the mounted volume and install it by running `sudo installer -pkg /Volumes/<IMAGE>/<PKG FILE> -target /`.

      When installation finishes, Puppet agent and MCollective will be running.

   3. After installing, run `sudo hdiutil unmount /Volumes/<IMAGE>` to unmount the disk image.

   4. Optionally, you can then delete the `.dmg` file.

   Upgrading with Puppet:

   Puppet includes a `package` resource provider for macOS that can install `.pkg` files from a disk image. If you already have Puppet installed, you can use the `puppet resource` command to upgrade with fewer steps.

   1. Locate the disk image you downloaded, and note both the filename and its full path on disk. Then, run:

      `sudo puppet resource package "<NAME>.dmg" ensure=present source=<FULL PATH TO DMG>`

5. Configure critical agent settings

   You probably want to set the `server` setting to your master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

   For other settings you might want to change, see [the list of agent-related settings.][agent_settings]

6. Sign certificates (on the CA master)

   As each agent runs for the first time, it will submit a certificate signing request (CSR) to the certificate authority (CA) Puppet master. You'll need to log into that server to check for certs and sign them.

   * Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
   * Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

   After an agent's certificate is signed, it regularly fetches and applies configurations from the Puppet master.
