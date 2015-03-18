---
layout: default
title: "Installing Puppet: Red Hat Enterprise Linux (and Derivatives)"
---

[nightly_yum]: /guides/puppetlabs_package_repositories.html#enabling-nightly-repos-on-yum-based-systems
[nightly]: /guides/puppetlabs_package_repositories.html#using-the-nightly-repos
[master_settings]: /puppet/latest/reference/config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: /puppet/latest/reference/config_important_settings.html#settings-for-agents-all-nodes
[current_install]: /guides/install_puppet/pre_install.html
[where]: ./whered_it_go.html
[dns_alt_names]: /references/latest/configuration.html#dnsaltnames
[server_heap]: /puppetserver/latest/install_from_packages.html#memory-allocation
[puppetserver_confd]: /puppetserver/latest/configuration.html
[modules]: /puppet/latest/reference/modules_fundamentals.html
[main manifest]: /puppet/latest/reference/dirs_manifest.html
[environments]: /puppet/latest/reference/environments.html


> **Note:** This page is for a pre-release version of Puppet. For current versions, see [the current install guide.][current_install]

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./install_pre.html)

**Since this is a pre-release version, you might not want to upgrade your existing systems yet.** Install on test systems first.

> **Note:** Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]


Supported Versions
-----

Currently, the previews of Puppet 4.0 and Puppet Server 2.0 only support RHEL 7, CentOS 7, and derived distros.

We'll be releasing preview packages for other systems as we get closer to a final release.


Step 1: Enable Nightly Puppet Labs Package Repositories
-----

Right now, we're shipping the 4.0 release candidates in our [nightly repos.][nightly] The packages aren't available in release repos yet, and once they are, they'll be in a new separated repo system that makes updates more predictable and conscious.

[Follow the instructions here to enable the nightly repos.][nightly_yum] Note: Unlike with older nightlies, you **do not** have to enable the core Puppet Labs repos.

There are two repos you must enable:

* `puppet-agent` on all nodes
* `puppetserver` on the puppet master server(s)

With both of them, you can choose whether to pin your systems to a stable commit, or use the `-latest` shortcut to allow further upgrades.

Step 2: Make Sure You'll Be Able to Run the Puppet Executables
-----

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your PATH by default.

This doesn't matter for the service configs (so `service puppet start` will work fine), but if you're running any interactive `puppet` commands, you'll need to either add them to your PATH or refer to them by full name.

See [our page about moved files and directories][where] for more info.

Step 3: Install Puppet Server
-----

(Skip this step for a standalone deployment.)

### A: Install the `puppetserver` Package

On your Puppet master node(s), run `sudo yum install puppetserver`. This installs Puppet Server, which will install the `puppet-agent` package as a dependency.

**Do not** start the `puppetserver` service yet.

### B: Configure Critical Master Settings

At a minimum, you need to:

* Make sure [the `dns_alt_names` setting][dns_alt_names] in `/etc/puppetlabs/puppet/puppet.conf` includes any DNS names that your agent nodes will use when contacting the server.
* Make sure the [Java heap size][server_heap] is appropriate for your hardware and for the amount of traffic the service will be handling.

### C: Configure Other Master Settings


You may want to do some other tweaking and configuration before getting Puppet Server online.

* [Relevant puppet.conf settings][master_settings]
* [Puppet Server conf.d settings][puppetserver_confd]

### D: Deploy Puppet Content

In this version of Puppet, you should deploy your [modules][] and your [main manifest][] to `/etc/puppetlabs/code/environments` ([more about environments][environments]).

The default environment for nodes that aren't assigned elsewhere is called `production`, and the packages have automatically created that directory for you.

You can deploy new content at any time while Puppet Server is running, but you'll probably want to have something ready before you start.

### F: Start the `puppetserver` Service

Use your normal system tools to do this, usually by running `sudo service puppetserver start`.

If you want to run Puppet Server in the foreground and watch the log messages scroll by, you can run `/opt/puppetlabs/bin/puppetserver foreground`, with or without the `--debug` option.


Step 4: Install Puppet on Agent Nodes
-----

### A: Install the `puppet-agent` Package

On every node you'll be managing with Puppet, run `sudo yum install puppet-agent`. This will install the Puppet software, lay down some default config files, and install a service configuration for running puppet agent.

**Do not** start the `puppet` service yet.

### B: Configure Critical Agent Settings

You probably want to set the `server` setting to your master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

For other settings you might want to change, see [the list of agent-related settings.][agent_settings]

### C: Start the `puppet` Service

You can do this with Puppet by running `sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`.

If you want to watch an agent run happen in the foreground, you can run `sudo /opt/puppetlabs/bin/puppet agent --test`.

### D: Sign Certificates (on the CA Master)

As each agent runs for the first time, it will submit a certificate signing request (CSR) to the CA Puppet master. You'll need to log into that server to check for certs and sign them.

* Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
* Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

After an agent node's cert is signed, it will regularly fetch and apply configurations from the Puppet master server.

