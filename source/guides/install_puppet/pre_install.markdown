---
layout: default
title: "Installing Puppet: Pre-Install Tasks"
---


[peinstall]: /pe/latest/install_basic.html
[sysreqs]: /puppet/latest/reference/system_requirements.html
[ruby]: /puppet/latest/reference/system_requirements.html#basic-requirements

> This document covers open source releases of Puppet. [See here for instructions on installing Puppet Enterprise.][peinstall]

Before you install Puppet, you should do the following tasks.

## Decide on a Deployment Type

Decide on a deployment type before installing:

### Agent/Master Puppet

Most people should use agent/master Puppet. Although it requires a central server, it's more convenient when updating configurations and can more easily take advantage of reporting and external data sources.

In agent/master Puppet, you run a central puppet master server (or servers) that hosts and compiles all of your configuration data. Other nodes run the puppet agent service, which periodically pulls their configurations from the master. Each agent will only get its own configuration, and will be unable to see how other nodes are configured.

You must decide in advance which server will be the master; install Puppet on it before installing on any agents. The master should be a dedicated machine with a fast processor, lots of RAM, and a fast disk.

### Standalone Puppet

If you can't allocate a puppet master server, are managing only a few nodes, or are managing a really large number of nodes, you may want a standalone Puppet deployment.

In standalone Puppet, every node periodically uses the puppet apply command to compile and apply its own configuration, using a full set of Puppet modules and manifests. In other words, each node requires the same files and data that the puppet master requires in agent/master Puppet.

You will need to come up with your own solution for distributing updated manifests, modules, and data to each node.

## Check OS Versions and System Requirements

See the [system requirements][sysreqs] for the version of Puppet you are installing, and consider the following:

- Your puppet master(s) should be robust dedicated servers that can handle the amount of agents they'll need to serve.
- Any computers running an OS version with official packages will have an easier install path.
- Any computers running an unsupported OS may still be able to run Puppet, as long as the version of Ruby is suitable and the prerequisites are installed. See the [list of supported Ruby versions and prerequisites.][ruby] You'll also need to follow a more complex install path.

## Check Your Network Configuration

In an agent/master deployment, you must prepare your network for Puppet's traffic.

* **Firewalls:** The puppet master server must allow incoming connections on port 8140, and agent nodes must be able to connect to the master on that port.
* **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. (Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must write an `/etc/hosts` file on each node.)
    * **Note:** The default puppet master hostname is `puppet`. Your agent nodes can be ready sooner if this hostname resolves to your puppet master.

## Check Timekeeping on Your Puppet Master Server

The puppet master server that will be acting as the certificate authority should have its system time set accurately. You should probably use NTP.

(If it doesn't, it may mistakenly issue agent certificates from the distant past or future, which other nodes will treat as expired.)

## Next: Install Puppet

Once these tasks are complete, you can install Puppet. Pick the link appropriate to the operating system(s) you'll be installing on:

* [Red Hat Enterprise Linux (and Derivatives)](./install_puppet/install_el.html)
* [Debian and Ubuntu](./install_puppet/install_debian_ubuntu.html)
* [Fedora](./install_puppet/install_fedora.html)
* [Mac OS X](./install_puppet/install_osx.html)
* [Microsoft Windows](./install_puppet/install_windows.html)
* [On Misc \*nix With Gems](./install_puppet/install_gem.html) (for otherwise unsupported systems)
* [On Misc \*nix With a Tarball](./install_puppet/install_tarball.html) (for otherwise unsupported systems)

After installing, you'll want to do the [post-install tasks](./post_install.html)
