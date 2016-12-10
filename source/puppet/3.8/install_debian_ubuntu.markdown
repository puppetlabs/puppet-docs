---
layout: default
title: "Installing Puppet: Debian and Ubuntu"
---

[peinstall]: {{pe}}/install_basic.html
[install-latest]: /puppet/latest/reference/install_pre.html
[puppet enterprise]: {{pe}}/

> #### **Note:** This document covers *open source* releases of Puppet version 3.8 and lower. For current versions, you should see instructions for [installing the latest version of Puppet][install-latest] or [installing Puppet Enterprise][peinstall].

First
-----

Before installing Puppet, review the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include pup38_platforms_debian_like.markdown %}

Users of out-of-production versions might have vendor packages of Puppet available, but can't use our provided packages.

To install on other operating systems, see the product navigation.

Step 1: Enable the Puppet Package Repository
-----

The newest versions of Puppet can be installed from the [apt.puppetlabs.com](https://apt.puppetlabs.com) package repository.

{% include repo_debian_ubuntu.markdown %}

### Optionally: Enable Prereleases

To test release candidate (RC) versions of Puppet and related projects, you can enable the prerelease repo, which is disabled by default. Note that RCs can contain unexpected changes, so be careful.

{% include repo_pre_debian_ubuntu.markdown %}

Step 2: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your Puppet master, run:

    sudo apt-get install puppetserver

This installs Puppet, its prerequisites, and [Puppet Server](/puppetserver/), a JVM-based Puppet master server that's ready for production.

> **Note:** Puppet 3.8 is compatible with [Puppet Server 1.1](/puppetserver/1.1/). [Puppet Server 2 and newer](/puppetserver/latest/) require [Puppet 4](/puppet/latest/).

Do not start Puppet Server yet.

### Upgrading

> **Note:** Read our [tips on upgrading](./upgrading.html) before upgrading your Puppet deployment.

To upgrade a Puppet master to the latest version of Puppet 3, run:

    sudo apt-get update
    sudo puppet resource package puppetmaster ensure=latest

After upgrading, restart Puppet Server.

Step 3: Install Puppet on Agent Nodes
-----

On your Puppet agents, run:

    sudo apt-get install puppet

This installs Puppet and an init script (`/etc/init.d/puppet`) that runs the Puppet agent daemon.

Do not start the `puppet` service yet.

### Upgrading

> **Note:** Read our [tips on upgrading](./upgrading.html) before upgrading your Puppet deployment.

To upgrade a Puppet agent to the latest version of Puppet 3, run:

    sudo apt-get update
    sudo puppet resource package puppet ensure=latest

After upgrading, restart the `puppet` service.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
