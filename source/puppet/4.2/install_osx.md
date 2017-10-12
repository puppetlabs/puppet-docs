---
layout: default
title: "Installing Puppet Agent: Mac OS X"
canonical: "/puppet/latest/install_osx.html"
---

[server_install]: /puppetserver/2.1/install_from_packages.html
[where]: ./whered_it_go.html
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes


## Make Sure You're Ready

Before installing Puppet on any agent nodes, make sure you've read the [pre-install tasks](./install_pre.html) and [installed Puppet Server][server_install].

> **Note:** If you've used older Puppet versions, Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]


## Review Supported Versions

{% include pup40_platforms_osx.markdown %}

To install on other operating systems, see the pages linked in the navigation sidebar.

## Download the OS X `puppet-agent` Package

OS X `puppet-agent` packages are available here:

- [10.10 Yosemite](https://downloads.puppetlabs.com/mac/10.10/PC1/x86_64/)
- [10.9 Mavericks](https://downloads.puppetlabs.com/mac/10.9/PC1/x86_64/)
- [all](https://downloads.puppetlabs.com/mac/) (Includes older Puppet versions; browse to `<OS X VERSION>/PC1/x86_64` for current packages.)

These packages are tied to Puppet Collection 1, which is the set of Puppet Labs software designed to work well with Puppet 4. The `puppet-agent` package bundles all of Puppet's prerequisites, so you don't need to download anything else to install Puppet on an agent node.

### Choosing Your Package

The OS X packages are named with their `puppet-agent` version and OS X version:

`puppet-agent-<PACKAGE VERSION>.osx<OS X VERSION>.dmg`

For example:

`puppet-agent-1.2.5.osx10.10.dmg`

To see which versions of Puppet, Facter, etc. are in a given `puppet-agent` release, [see the docs page about `puppet-agent` versions.](./about_agent.html)

> #### Previous Package Names
>
> We used some different naming schemes in the puppet-agent 1.2 series before settling on the current convention in 1.2.5.
>
> - 1.2.0 through 1.2.2: `puppet-agent-<VERSION>-osx-<OS X VERSION>-<ARCH>.dmg`. Redundant; OS X only runs on x86_64.
> - 1.2.4: `puppet-agent-<VERSION>-<OS X CODE NAME>.dmg`. This was too hard for automated tooling to deal with, because OS X's built-in CLI tools don't report the code name.

## Make Sure You'll Be Able to Run the Puppet Executables

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your PATH by default.

This doesn't matter for Puppet services (so enabling or disabling Puppet agent with `launchctl` will work fine), but if you're running any interactive `puppet` commands, you'll need to either add them to your PATH or refer to them by full name.

See [our page about moved files and directories][where] for more info.


## Install Puppet

There are three ways to install Puppet on OS X:

* With the GUI installer.
* On the command line.
* With Puppet (if upgrading).

Regardless which you choose, installing the package will start the `puppet` and `mcollective` services. You can later disable these services with `launchctl` or with `sudo puppet resource service <NAME> ensure=stopped enable=false`.

### Installing with the GUI

Double-click the `puppet-agent` disk image you downloaded; this will mount it at `/Volumes/<DMG NAME>`.

A Finder window should appear showing the disk's contents, which will be a single `puppet-agent-<VERSION>-installer.pkg` file. Double-click the package file, and follow the installer prompts to install it. When installation finishes, Puppet agent and MCollective will be running.

After installing, unmount and delete the disk image.

### Installing on the Command Line

Alternately, you can use the `hdiutil` and `installer` commands to mount the disk image and install the package.

First, mount the disk image with:

    sudo hdiutil mount <DMG FILE>

Next, locate the `.pkg` file in the mounted volume and install it with:

    sudo installer -pkg /Volumes/<IMAGE>/<PKG FILE> -target /

When installation finishes, Puppet agent and MCollective will be running.

After installing, unmount the disk image with:

    sudo hdiutil unmount /Volumes/<IMAGE>

You can then delete the `.dmg` file.

### Upgrading with Puppet

Puppet includes a `package` resource provider for OS X that can install `.pkg` files from a disk image. If you already have Puppet installed, you can use the `puppet resource` command to upgrade with fewer steps.

Locate the disk image you downloaded, and note both the filename and its full path on disk. Then, run:

    sudo puppet resource package "<NAME>.dmg" ensure=present source=<FULL PATH TO DMG>

## Configure Critical Agent Settings

You probably want to set the `server` setting to your master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

For other settings you might want to change, see [the list of agent-related settings.][agent_settings]

## Sign Certificates (on the CA Master)

As each agent runs for the first time, it will submit a certificate signing request (CSR) to the CA Puppet master. You'll need to log into that server to check for certs and sign them.

* Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
* Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

After an agent node's cert is signed, it will regularly fetch and apply configurations from the Puppet master server.
