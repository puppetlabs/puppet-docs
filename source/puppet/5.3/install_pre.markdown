---
layout: default
title: "Installing Puppet: Pre-install tasks"
---

[peinstall]: {{pe}}/install_basic.html
[sysreqs]: ./system_requirements.html
[ruby]: ./system_requirements.html#basic-requirements
[architecture]: /puppet/latest/architecture.html
[puppetdb]: {{puppetdb}}/
[server_setting]: ./configuration.html#server


To ease your Puppet installation, complete these tasks before installing Puppet agent.

> **Note:** This document covers open source releases of Puppet. For instructions on installing Puppet Enterprise, see [its installation documentation][peinstall].

1. Decide on a deployment type.

   Puppet usually uses an agent/master (client/server) architecture, but it can also run in a self-contained architecture. Your choice determines which packages you install, and what extra configuration you need to do.

   Additionally, consider using [PuppetDB][], which enables extra Puppet features and makes it easy to query and analyze Puppet's data about your infrastructure.

   [Learn more about Puppet's architectures here.][architecture]

2. If you choose the standard agent/master architecture, you need to decide which server(s) acts as the Puppet master (and the [PuppetDB][] server, if you choose to use it).

   Completely install and configure Puppet on any Puppet masters and PuppetDB servers before installing on any agent nodes. The master must be running some kind of \*nix. Windows machines can't be masters.

   A Puppet master is a dedicated machine, so it must be reachable at a reliable hostname. Agent nodes default to contacting the master at the hostname `puppet`. If you make sure this hostname resolves to the master, you can skip changing [the `server` setting][server_setting] and reduce your setup time.

3. Check OS versions and system requirements.

   See the [system requirements][sysreqs] for the version of Puppet you are installing, and consider the following:

   * Your Puppet master(s) should be able to handle the amount of agents they'll need to serve.
   * Systems we provide official packages for have an easier install path.
   * Systems we don't provide packages for might still be able to run Puppet, as long as the version of Ruby is suitable and the prerequisites are installed, but it means a more complex and often time consuming install path.

4. Check your network configuration.

   In an agent/master deployment, you must prepare your network for Puppet's traffic.

   * **Firewalls:** The Puppet master server must allow incoming connections on port 8140, and agent nodes must be able to connect to the master on that port.
   * **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. If your site lacks DNS, you must write an `/etc/hosts` file on each node.
     * **Note:** The default Puppet master hostname is `puppet`. Your agent nodes can be ready sooner if this hostname resolves to your Puppet master.

5. Set timekeeping on your Puppet master server.

   The time must be set accurately on the Puppet master server that acts as the certificate authority. If the time is wrong, it can mistakenly issue agent certificates from the distant past or future, which other nodes treat as expired. There are modules in the forge, such as the ntp module that can help you with this.


Install Puppet Server before installing Puppet on your agent nodes. If you're using PuppetDB, install it once Puppet Server is up and running. Once you have completed these steps and configured your master, you can install Puppet agent.

* [Installing Puppet agent on Linux](./install_linux.html)
* [Installing Puppet agent on Windows](./install_windows.html)
* [Installing Puppet agent on macOS](./install_osx.html)
