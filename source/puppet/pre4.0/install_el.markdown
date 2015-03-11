---
layout: default
title: "Installing Puppet: Red Hat Enterprise Linux (and Derivatives)"
---

[peinstall]: /pe/latest/install_basic.html
[puppet enterprise]: /pe/latest/

> **Note:** This is for a pre-release version.

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html) TODO dunno if we're porting this page over.

other things:

- don't upgrade existing systems like this, you should only be doing test systems.
- need a link here to the "what gets installed where" page
- need a link to the "where'd all my stuff go" page


Supported Versions
-----

Currently, the preview of Puppet 4.0 and Puppet Server 2.0 only support RHEL 7, CentOS 7, and derived distros.

We'll be releasing preview packages for other systems as we get closer to a final release.

Step 1: Enable Dependencies (RHEL Only)
-----

TODO I think this stays true. Talk to haus or melissa.

CentOS and other community forks have several packages Puppet depends on in their main repos, but RHEL itself is split into channels. If you're installing Puppet on RHEL, you'll want to make sure the "optional" channel is enabled. [Instructions are available here.](https://access.redhat.com/documentation/en-US/Red_Hat_Subscription_Management/1/html/RHSM/supplementary-repos.html)

Step 2: Enable Nightly Puppet Labs Package Repositories for Agent and Server
-----

These packages aren't in the final release repos yet. They're just in nightlies.

There are two repos you need to enable: `puppet-agent` on all nodes, and `puppetserver` on the puppet master server(s).

Follow the instructions here:

/guides/puppetlabs_package_repositories.html#using-the-nightly-repos

Either get the most recent pinned nightly repo (by commit), or `puppet-agent-latest` and the like.


Step 3: Install `puppetserver` on the Puppet Master Server
-----

(Skip this step for a standalone deployment.)

On your puppet master node(s), run `sudo yum install puppetserver`. This will install Puppet Server, which will install the `puppet-agent` package as a dependency.

Do not start the `puppetserver` service yet.

Step 4: Install Puppet on Agent Nodes
-----

On your other nodes, run `sudo yum install puppet-agent`. This will install the Puppet software, lay down some default config files, and install a service configuration for running puppet agent.

TODO link to "what gets installed where"

Do not start the `puppet` service yet.

Step 5: Make sure the puppet executables are in your PATH
-----

The binaries go in /opt/puppetlabs/bin/, and that's not in your path by default. Either add it for all users that need to interact with puppet, or symlink the binaries into /usr/bin or something, or else just refer to them by full name all the time.

the service configs will work fine regardless what you do, so `service puppet start` won't break if you skip this step.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
