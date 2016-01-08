---
layout: default
title: "Installing Puppet: Red Hat Enterprise Linux (and Derivatives)"
---

[peinstall]: /pe/latest/install_basic.html
[install-latest]: /puppet/latest/reference/install_pre.html
[puppet enterprise]: /pe/latest/

> **Note:** This document covers open source releases of Puppet version 3.8 and lower. You might also want instructions for [installing Puppet Enterprise][peinstall] or [installing Puppet 4.0 or newer.][install-latest]

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include platforms_redhat_like.markdown %}

To install on other operating systems, see the pages linked in the navigation sidebar.

Step 1: Enable Dependencies (RHEL Only)
-----

CentOS and other community forks have several packages Puppet depends on in their main repos, but RHEL itself is split into channels. If you're installing Puppet on RHEL, you'll want to make sure the "optional" channel is enabled. [Instructions are available here.](https://access.redhat.com/documentation/en-US/Red_Hat_Subscription_Management/1/html/RHSM/supplementary-repos.html)

Step 2: Enable the Puppet Labs Package Repository
-----

The newest versions of Puppet can be installed from the [yum.puppetlabs.com](https://yum.puppetlabs.com) package repository.

{% include repo_el.markdown %}

### Optionally: Enable Prereleases

If you want to be able to test release candidate (RC) versions of Puppet and related projects, you can turn on the prerelease repo, which is disabled by default. Note that RCs may contain unexpected changes, so be careful.

{% include repo_pre_redhat.markdown %}

Step 3: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your puppet master node(s), run `sudo yum install puppetserver`. This will install Puppet and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.

> **Note:** Puppet 3.8 is compatible with Puppet Server 1.1. Puppet Server 2 and newer require Puppet 4.

Do not start the puppet master service yet.

### Upgrading

**Note:** Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

To upgrade to the latest version of Puppet, you can run:

    $ sudo puppet resource package puppet-server ensure=latest

You'll need to restart the puppet master web server after upgrading.

Step 4: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo yum install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

Do not start the `puppet` service yet.

### Upgrading

**Note:** Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

To upgrade to the latest version of Puppet, you can run:

    $ sudo puppet resource package puppet ensure=latest

You'll need to restart the `puppet` service after upgrading.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
