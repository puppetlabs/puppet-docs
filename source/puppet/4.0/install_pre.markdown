---
layout: default
title: "Installing Puppet: Pre-Install Tasks"
---

[peinstall]: /pe/latest/install_basic.html
[sysreqs]: ./system_requirements.html
[ruby]: ./system_requirements.html#basic-requirements
[architecture]: /puppet/latest/architecture.html

> **Note:** This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

Before you install Puppet, you should do the following tasks.

## Decide on a Deployment Type

Puppet usually uses an agent/master (client/server) architecture, but it can also run in a self-contained architecture. Your choice determines which packages you'll be installing and what extra configuration you'll need to do.

[Learn more about Puppet's architectures here.][architecture]

## Designate Servers

If you choose the standard agent/master architecture, you'll need to decide which server(s) will act as the Puppet master.

You should completely install and configure Puppet on any Puppet masters before installing on any agents. The master must be running some kind of \*nix. Windows machines can't be masters.

A Puppet master should be a dedicated machine with a fast processor, lots of RAM, and a fast disk. It must also be reachable at a reliable hostname.

> Note: Agents default to contacting the master at the hostname `puppet`. If you make sure this hostname resolves to the master, you can skip changing [the `server` setting][server_setting] and reduce your setup time.


## Check OS Versions and System Requirements

See the [system requirements][sysreqs] for the version of Puppet you are installing, and consider the following:

* Your Puppet master(s) should be able to handle the number of agents they'll need to serve.
* Systems we provide official packages for will have an easier install path.
* Systems we don't provide packages for _might_ still be able to run Puppet, as long as the version of Ruby is suitable and the prerequisites are installed. See the [list of supported Ruby versions and prerequisites.][ruby] You'll also need to follow a more complex install path.

## Check Your Network Configuration

In an agent/master deployment, you must prepare your network for Puppet's traffic.

* **Firewalls:** The Puppet master must allow incoming connections on port 8140, and agents must be able to connect to the master on that port.
* **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. (Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must write an `/etc/hosts` file on each node.)
    * **Note:** The default Puppet master hostname is `puppet`. Your agents can be ready sooner if this hostname resolves to your Puppet master.

## Check Timekeeping on Your Puppet Master

The time must be set accurately on the Puppet master that will be acting as the certificate authority. You should probably use NTP.

(If the time is wrong, it might mistakenly issue agent certificates from the distant past or future, which other nodes will treat as expired.)

## Next: Install Puppet

Once these tasks are complete, you can install Puppet.

* [Installing on *nix](./install_linux.html)
* [Installing on Windows](./install_windows.html)
