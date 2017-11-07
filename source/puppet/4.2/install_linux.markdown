---
layout: default
title: "Installing Puppet Agent: Linux"
canonical: "/puppet/latest/install_linux.html"
---

[master_settings]: ./config_important_settings.html#settings-for-puppet-master-servers
[agent_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[where]: ./whered_it_go.html
[dns_alt_names]: /puppet/latest/configuration.html#dnsaltnames
[server_heap]: /puppetserver/2.1/install_from_packages.html#memory-allocation
[puppetserver_confd]: /puppetserver/2.1/configuration.html
[server_install]: /puppetserver/2.1/install_from_packages.html
[modules]: ./modules_fundamentals.html
[main manifest]: ./dirs_manifest.html
[environments]: ./environments.html


## Make Sure You're Ready

Before installing Puppet on any agent nodes, make sure you've read the [pre-install tasks](./install_pre.html) and [installed Puppet Server][server_install].

> **Note:** If you've used older Puppet versions, Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]


## Review Supported Versions and Requirements

Most Linux systems (including CentOS, Redhat, Ubuntu, and Debian) have official Puppet agent packages. For a complete list of supported platforms, view the [system requirements page.](./system_requirements.html)


## Install a Release Package to Enable Puppet Labs Package Repositories

Release packages configure your system to download and install appropriate versions of the puppetserver and puppet-agent packages.

### Installing Release Packages on yum/RPM Systems

First, choose the package based on your specific operating system and version. The packages are all named using the following convention:

`puppetlabs-release-COLLECTION-OS-VERSION.noarch.rpm`

For instance, the package for Puppet Collection 1 on Red Hat Enterprise Linux 7 is `puppetlabs-release-pc1-rhel-7.noarch.rpm`.

Second, install the package with `rpm -Uhv PACKAGENAME`:

		[root@localhost ~]# rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
		Retrieving https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
		Preparing...                          ################################# [100%]
		Updating / installing...
		1:puppetlabs-release-pc1-0.9.2-1.el################################# [100%]


### Installing Release Packages apt/dpkg Systems

First, choose the package based on your specific operating system and version. The packages are all named using the following convention:

`puppetlabs-release-COLLECTION-VERSION.deb`

For instance, the package for Puppet Collection 1 on Debian 7 is `puppetlabs-release-pc1-wheezy.deb`.

Second, download the package and install it:

        # wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb
        # dpkg -i puppetlabs-release-pc1-wheezy.deb

Finally, make sure to run `apt-get update` after installing the package.

## Make Sure You'll Be Able to Run the Puppet Executables

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your PATH by default.

This doesn't matter for Puppet services (so `service puppet start` will work fine), but if you're running any interactive `puppet` commands, you'll need to either add them to your PATH or refer to them by full name.

To quickly add this to your PATH, use the command `export PATH=/opt/puppetlabs/bin:$PATH`.

See [our page about moved files and directories][where] for more info.


## Install the `puppet-agent` Package

### For RPM-based systems using yum
On your Puppet agent node(s), run `sudo yum install puppet-agent`.

### For dpkg-based systems using apt-get
On your Puppet agent node(s), run `apt-get install puppet-agent`.

**Do not** start the `puppet` service yet.

## Configure Critical Agent Settings

You probably want to set the `server` setting to your master's hostname. The default value is `server = puppet`, so if your master is reachable at that address, you can skip this.

For other settings you might want to change, see [the list of agent-related settings.][agent_settings]

## Start the `puppet` Service

You can do this with Puppet by running `sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true`.

If you want to watch an agent run happen in the foreground, you can run `sudo /opt/puppetlabs/bin/puppet agent --test`.

## Sign Certificates (on the CA Master)

As each agent runs for the first time, it will submit a certificate signing request (CSR) to the CA Puppet master. You'll need to log into that server to check for certs and sign them.

* Run `sudo /opt/puppetlabs/bin/puppet cert list` to see any outstanding requests.
* Run `sudo /opt/puppetlabs/bin/puppet cert sign <NAME>` to sign a request.

After an agent node's cert is signed, it will regularly fetch and apply configurations from the Puppet master server.
