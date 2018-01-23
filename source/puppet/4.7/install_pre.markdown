---
layout: default
title: "Installing Puppet: Pre-install tasks"
canonical: "/puppet/latest/install_pre.html"
---

[peinstall]: {{pe}}/install_basic.html
[sysreqs]: ./system_requirements.html
[ruby]: ./system_requirements.html#basic-requirements
[architecture]: /puppet/latest/architecture.html
[puppetdb]: {{puppetdb}}/
[server_setting]: ./configuration.html#server

> **Note:** This document covers open source releases of Puppet. For instructions on installing Puppet Enterprise, see [its installation documentation][peinstall].

Before you install Puppet, you should do the following tasks.

## Decide on a deployment type

Puppet usually uses an agent/master (client/server) architecture, but it can also run in a self-contained architecture. Your choice determines which packages you'll be installing, and what extra configuration you'll need to do.

Additionally, you should consider using [PuppetDB][], which enables extra Puppet features and makes it easy to query and analyze Puppet's data about your infrastructure.

[Learn more about Puppet's architectures here.][architecture]

## Designate servers

If you choose the standard agent/master architecture, you'll need to decide which server(s) will act as the Puppet master (and the [PuppetDB][] server, if you choose to use it).

You should completely install and configure Puppet on any Puppet masters and PuppetDB servers before installing on any agent nodes. The master must be running some kind of \*nix. Windows machines can't be masters.

A Puppet master should be a dedicated machine. It must also be reachable at a reliable hostname. See the [system requirements](system_requirements.html) for minimum hardware requirements.

> Note: Agent nodes will default to contacting the master at the hostname `puppet`. If you make sure this hostname resolves to the master, you can skip changing [the `server` setting][server_setting] and reduce your setup time.


## Check OS versions and system requirements

See the [system requirements][sysreqs] for the version of Puppet you are installing, and consider the following:

* Your Puppet master(s) should be able to handle the amount of agents they'll need to serve.
* Systems we provide official packages for will have an easier install path.
* Systems we don't provide packages for _might_ still be able to run Puppet, as long as the version of Ruby is suitable and the prerequisites are installed. See the [list of supported Ruby versions and prerequisites.][ruby] You'll also need to follow a more complex install path.

## Check your network configuration

In an agent/master deployment, you must prepare your network for Puppet's traffic.

* **Firewalls:** The Puppet master server must allow incoming connections on port 8140, and agent nodes must be able to connect to the master on that port.
* **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. (Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must write an `/etc/hosts` file on each node.)
    * **Note:** The default Puppet master hostname is `puppet`. Your agent nodes can be ready sooner if this hostname resolves to your Puppet master.

## Check timekeeping on your Puppet master server

The time must be set accurately on the Puppet master server that will be acting as the certificate authority. You should probably use NTP.

(If the time is wrong, it might mistakenly issue agent certificates from the distant past or future, which other nodes will treat as expired.)

## Next: Install Puppet

Once these tasks are complete, you can install Puppet.

Install Puppet Server before installing Puppet on your agent nodes.

* [Installing Puppet Server]({{puppetserver}}/install_from_packages.html)

If you're using PuppetDB, install it once Puppet Server is up and running.

* [Installing PuppetDB]({{puppetdb}}/install_via_module.html)

Once Puppet Server is installed and configured, you can install agents:

* [Installing Puppet Agent on Linux](./install_linux.html)
* [Installing Puppet Agent on Windows](./install_windows.html)
* [Installing Puppet Agent on Mac OS X](./install_osx.html)
