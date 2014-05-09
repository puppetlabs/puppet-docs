---
layout: default
title: "Installing Puppet: Fedora"
---

[peinstall]: /pe/latest/install_basic.html
[puppet enterprise]: /pe/latest/

> This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include platforms_fedora.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.


Step 1: Enable the Puppet Labs Package Repository
-----

The newest versions of Puppet can be installed from the [yum.puppetlabs.com](http://yum.puppetlabs.com) package repository.

{% include repo_fedora.markdown %}

### Optionally: Enable Prereleases

If you want to be able to test release candidate (RC) versions of Puppet and related projects, you can turn on the prerelease repo, which is disabled by default. Note that RCs may contain unexpected changes, so be careful.

{% include repo_pre_redhat.markdown %}

Step 2: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppetmaster.service`) for running a test-quality puppet master server.

Step 3: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo yum install puppet`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppet.service`) for running the puppet agent daemon.

(Note that prior to Puppet 3.4.0, the agent service name on Fedora ≥ 17 was `puppetagent` instead of puppet. This name will continue to work until Puppet 4, but you should use the more consistent `puppet` instead.)


Next
----

At this point, Puppet is installed on all of your nodes, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
