---
layout: default
title: "Installing Puppet: Pre-Install Tasks"
canonical: "/puppet/latest/install_pre.html"
---

[peinstall]: {{pe}}/install_basic.html
[sysreqs]: ./system_requirements.html
[ruby]: ./system_requirements.html#requirements-and-prerequisites
[architecture]: ./architecture.html
[puppetdb]: {{puppetdb}}/
[server_setting]: ./configuration.html#server

> **Note:** This document covers open source releases of Puppet. For instructions on installing Puppet Enterprise, see [its installation documentation][peinstall].

Before you install Puppet, you should do the following tasks.

## Decide on a deployment type

Puppet usually uses an agent/master (client/server) architecture, but it can also run in a self-contained architecture. Your choice determines which packages you need to install and what additional configuration you'll need to do. Puppet's documentation includes [an overview of Puppet's architecture][architecture] that can help you decide.

Additionally, consider using [PuppetDB][], which enables extra Puppet features and makes it easy to query and analyze Puppet's data about your infrastructure.

## Designate servers

If you choose the standard agent/master architecture, you'll need to decide which servers will act as the Puppet master (and the [PuppetDB][] server, if you choose to use it). In most installations, the Puppet master should run [Puppet Server]({{puppetserver}}), a high-performance implementation of the Puppet master service.

You should completely install and configure Puppet or Puppet Server on your Puppet masters, and PuppetDB if you choose to use it, before installing Puppet on any agents. The master must run some form of \*nix; Windows and OS X systems can't run the master service.

## Check OS versions and system requirements

The Puppet master service performs best on a dedicated server with multiple fast processor cores, lots of RAM, and a fast disk. The Puppet agent service, on the other hand, can run on nearly any system. Review Puppet's [system requirements][sysreqs] and consider the following:

-   Your Puppet masters should have the necessary resources to handle the number of agents they need to serve.
-   It's easier to install Puppet on operating systems for which we provide official packages.
-   Systems we don't provide packages for _might_ be able to run Puppet, as long as [Puppet's prerequisites, including Ruby][ruby], are installed. Puppet is also more difficult to install and maintain on these systems.

## Check your network configuration

In an agent/master deployment, your network must be prepared for Puppet's traffic.

-   **Firewalls:** The Puppet master must allow incoming connections on port 8140, and agents must be able to connect to the master on that port.
-   **Name resolution:** Every node must have a unique hostname, and you **must** configure both forward _and_ reverse DNS resolution correctly on every node. (Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must configure the `hosts` file on each agent.)

    > **Note:** By default, the Puppet agent service attempts to contact a master at the hostname `puppet`. If you resolve this hostname on your network to the master, you can skip changing [the `server` setting][server_setting] and reduce your setup time.

## Check timekeeping on your Puppet master

The time must be set accurately on the Puppet master that will act as the infrastructure's certificate authority. You can configure agents and masters to synchronize their clocks via the [Network Time Protocol](http://www.ntp.org) (NTP). Consult your operating system's documentation to install and configure NTP synchronization on your nodes.

If the time on the master falls out of sync with agents, it might mistakenly issue agent certificates from the distant past or future that other nodes will treat as expired.

## Next: Install Puppet

Once these tasks are complete, you can install Puppet.

Install Puppet Server before installing Puppet on your agents.

-   [Installing Puppet Server]({{puppetserver}}/install_from_packages.html)

If you're using PuppetDB, install it once Puppet Server is up and running.

-   [Installing PuppetDB]({{puppetdb}}/install_via_module.html)

Once Puppet Server is installed and configured, you can install agents.

-   [Installing Puppet agent on Linux](./install_linux.html)
-   [Installing Puppet agent on Windows](./install_windows.html)
-   [Installing Puppet agent on OS X](./install_osx.html)
