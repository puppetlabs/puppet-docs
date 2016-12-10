---
layout: default
title: "Installing Puppet: Fedora"
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

{% include pup38_platforms_fedora.markdown %}

Users of out-of-production versions might have vendor packages of Puppet available, but can't use our provided packages.

To install on other operating systems, see the product navigation.

Step 1: Enable the Puppet Package Repository
-----

The newest versions of Puppet can be installed from the [yum.puppetlabs.com](https://yum.puppetlabs.com) package repository.

{% include repo_fedora.markdown %}

### Optionally: Enable Prereleases

To test release candidate (RC) versions of Puppet and related projects, you can enable the prerelease repo, which is disabled by default. Note that RCs can contain unexpected changes, so be careful.

{% include repo_pre_redhat.markdown %}

Step 2: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your Puppet master node, run:

    sudo yum install puppet-server

This installs Puppet and a `systemd` configuration (`/usr/lib/systemd/system/puppetmaster.service`) to run a test-quality Puppet master server.

Do not start the Puppet master service yet.

### Upgrading

> **Note:** Read our [tips on upgrading](./upgrading.html) before upgrading your Puppet deployment.

To upgrade a Puppet master to the latest version of Puppet 3, run:

    sudo puppet resource package puppet-server ensure=latest

After upgrading, restart the Puppet master web server.

Step 3: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo yum install puppet`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppet.service`) for running the puppet agent daemon.

(Note that prior to Puppet 3.4.0, the agent service name on Fedora ≥ 17 was `puppetagent` instead of puppet. This name will continue to work until Puppet 4, but you should use the more consistent `puppet` instead.)

Do not start the `puppet` service yet.

### Upgrading

**Note:** Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

To upgrade a Puppet agent to the latest version of Puppet 3, run:

    $ sudo puppet resource package puppet ensure=latest

After upgrading, restart the `puppet` service.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
