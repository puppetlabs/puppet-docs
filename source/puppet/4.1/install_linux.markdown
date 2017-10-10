---
layout: default
title: "Installing Puppet: Linux"
---

[master_settings]: /puppet/latest/config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: /puppet/latest/config_important_settings.html#settings-for-agents-all-nodes
[where]: ./whered_it_go.html
[dns_alt_names]: /puppet/latest/configuration.html#dnsaltnames
[server_heap]: /puppetserver/latest/install_from_packages.html#memory-allocation
[puppetserver_confd]: /puppetserver/latest/configuration.html
[modules]: /puppet/latest/modules_fundamentals.html
[main manifest]: /puppet/latest/dirs_manifest.html
[environments]: /puppet/latest/environments.html

## Read the Pre-Install Tasks

Before installing Puppet, make sure you've read the [pre-install tasks.](./install_pre.html)

> **Note:** Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]

## Review Supported Versions and Requirements

Most Linux systems including CentOS, Redhat, Ubuntu, and Debian have packages. We have not yet released a Mac OS X package. For a complete list of supported platforms, view the [system requirements page.](./system_requirements.html)

## Install a Release Package to Enable Puppet Labs Package Repositories

Release packages configure your system to download and install appropriate versions of the puppetserver and puppet-agent packages.

### Installing Release Packages on yum/RPM Systems

First, choose the package based on your specific operating system and version. The packages are all named using the following convention:

    puppetlabs-release-COLLECTION-OS-VERSION.noarch.rpm

For instance, the package for Puppet Collection 1 on Red Hat Enterprise Linux 7 is `puppetlabs-release-pc1-rhel-7.noarch.rpm`.

Second, install the package with `rpm -Uhv PACKAGENAME`:

    [root@localhost ~]# rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    Retrieving https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    Preparing...                          ################################# [100%]
    Updating / installing...
    1:puppetlabs-release-pc1-0.9.2-1.el################################# [100%]

### Installing Release Packages apt/dpkg Systems

First, choose the package based on your specific operating system and version. The packages are all named using the following convention:

    puppetlabs-release-COLLECTION-VERSION.deb

For instance, the package for Puppet Collection 1 on Debian 7 is `puppetlabs-release-pc1-wheezy.deb`.

Second, download the package and install it:

    sudo wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb
    sudo dpkg -i puppetlabs-release-pc1-wheezy.deb

Finally, make sure to run `apt-get update` after installing the package.

## Make Sure You'll Be Able to Run the Puppet Executables

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your PATH by default.

This doesn't matter for Puppet services (so `service puppet start` will work fine), but if you're running any interactive `puppet` commands, you'll need to either add them to your PATH or refer to them by full name.

See [our page about moved files and directories][where] for more info.

## Install Puppet Server

(You can skip this step for a standalone deployment.)

### Install the `puppetserver` Package

#### For RPM-based systems using yum

On your Puppet masters, run `sudo yum install puppetserver`. This installs Puppet Server, which will install the `puppet-agent` package as a dependency.

#### For dpkg-based systems using apt-get

On your Puppet masters, run `apt-get install puppetserver`. This installs Puppet Server, which will install the `puppet-agent` package as a dependency.

**Do not** start the `puppetserver` service yet.

### Configure Critical Master Settings

At a minimum, you need to:

* Make sure [the `dns_alt_names` setting][dns_alt_names] in `/etc/puppetlabs/puppet/puppet.conf` includes any DNS names that your agent nodes will use when contacting the server.
* Make sure the [Java heap size][server_heap] is appropriate for your hardware and for the amount of traffic the service will be handling.

### Configure Other Master Settings

You may want to do some other tweaking and configuration before getting Puppet Server online.

* [Relevant puppet.conf settings][master_settings]
* [Puppet Server conf.d settings][puppetserver_confd]

### Deploy Puppet Content

In this version of Puppet, you should deploy your [modules][] and your [main manifest][] to `/etc/puppetlabs/code/environments` ([more about environments][environments]).

The default environment for nodes that aren't assigned elsewhere is called `production`, and the packages have automatically created that directory for you.

You can deploy new content at any time while Puppet Server is running, but you'll probably want to have something ready before you start.

### Start the `puppetserver` Service

Use your normal system tools to do this, usually by running `sudo service puppetserver start`.

If you want to run Puppet Server in the foreground and watch the log messages scroll by, you can run `/opt/puppetlabs/bin/puppetserver foreground`, with or without the `--debug` option.

## Install Puppet on Agent Nodes

### Install the `puppet-agent` Package

#### For RPM-based systems using yum

On your Puppet agents, run `sudo yum install puppet-agent`.

#### For dpkg-based systems using apt-get

On your Puppet agents, run `apt-get install puppet-agent`.

**Do not** start the `puppet` service yet.

### Configure Critical Agent Settings

You probably want to set the `server` setting to your master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

For other settings you might want to change, see [the list of agent-related settings.][agent_settings]

### Start the `puppet` Service

You can do this with Puppet by running `sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`.

If you want to watch an agent run happen in the foreground, you can run `sudo /opt/puppetlabs/bin/puppet agent --test`.

### Sign Certificates (on the CA Master)

As each agent runs for the first time, it will submit a certificate signing request (CSR) to the CA Puppet master. You'll need to log into that server to check for certs and sign them.

* Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
* Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

After an agent node's cert is signed, it will regularly fetch and apply configurations from the Puppet master server.
