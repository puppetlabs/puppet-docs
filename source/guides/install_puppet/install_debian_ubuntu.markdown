---
layout: default
title: "Installing Puppet: Debian and Ubuntu"
---

[peinstall]: /pe/latest/install_basic.html
[puppet enterprise]: /pe/latest/

> This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include platforms_debian_like.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.

To install on other operating systems, see the pages linked in the navigation sidebar.

Step 1: Enable the Puppet Labs Package Repository
-----

The newest versions of Puppet can be installed from the [apt.puppetlabs.com](http://apt.puppetlabs.com) package repository.

{% include repo_debian_ubuntu.markdown %}

### Optionally: Enable Prereleases

If you want to be able to test release candidate (RC) versions of Puppet and related projects, you can turn on the prerelease repo, which is disabled by default. Note that RCs may contain unexpected changes, so be careful.

{% include repo_pre_debian_ubuntu.markdown %}

Step 2: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your puppet master node, run one of the following:

* `sudo apt-get install puppetmaster-passenger` --- We recommend this one, as it will save you a step in the post-install tasks. It will install Puppet and its prerequisites, and automatically configure a production-capacity web server.
* `sudo apt-get install puppetmaster` --- This will install Puppet, its prerequisites, and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.

Step 3: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo apt-get install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

Next
----

At this point, Puppet is installed on all of your nodes, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
