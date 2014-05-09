---
layout: default
title: "Installing Puppet: Red Hat Enterprise Linux (and Derivatives)"
---

[peinstall]: /pe/latest/install_basic.html
[puppet enterprise]: /pe/latest/

> This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

{% include platforms_redhat_like.markdown %}

To install on other operating systems, see the pages linked in the navigation sidebar.

Step 1: Enable Dependencies (RHEL Only)
-----

CentOS and other community forks have several packages Puppet depends on in their main repos, but RHEL itself is split into channels. If you're installing Puppet on RHEL, you'll want to make sure the "optional" channel is enabled. [Instructions are available here.](https://access.redhat.com/site/documentation/en-US/OpenShift_Enterprise/1/html/Client_Tools_Installation_Guide/Installing_Using_the_Red_Hat_Enterprise_Linux_Optional_Channel.html)

Step 2: Enable the Puppet Labs Package Repository
-----

The newest versions of Puppet can be installed from the [yum.puppetlabs.com](http://yum.puppetlabs.com) package repository.

{% include repo_el.markdown %}

### Optionally: Enable Prereleases

If you want to be able to test release candidate (RC) versions of Puppet and related projects, you can turn on the prerelease repo, which is disabled by default. Note that RCs may contain unexpected changes, so be careful.

{% include repo_pre_redhat.markdown %}

Step 3: Install Puppet on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your puppet master node(s), run `sudo yum install puppet-server`. This will install Puppet and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.

Step 4: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo yum install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

Next
----

At this point, Puppet is installed on all of your nodes, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
