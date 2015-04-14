---
layout: default
title: "Installing Puppet: Linux"
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


First
-----

Before installing Puppet, make sure you've read the [pre-install tasks.](./install_pre.html)

> **Note:** Puppet 4 changed the locations for a lot of the most important files and directories. [See this page for a summary of the changes.][where]


Supported Versions and Requirements
-----
Most Linux systems including CentOS, Redhat, Ubuntu, and Debian have packages. At this time, Mac OS X package for Puppet agent has not been released. For a complete list of supported platforms, view the [system requirements page.](sysreqs)


Step 1: Install a Release Package to Enable Puppet Labs Package Repositories
-----

Release packages configure your system to download and install appropriate versions of the puppetserver and puppet-agent packages. 

## Yum-Based

1. Choose the package based on your specific operating system and version:

	The packages are all named with a similar convention of puppetlabs-release-COLLECTION-OS-VERSION.rpm to help you find the correct one. You can find the correct package by searching for your platform name and version at the end of the filename. 
	
 is 

2. Install the package with `rpm -Uhv PACKAGENAME`

		[root@dcc5krb9mp7wfrh ~]# rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
		Retrieving http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
		Preparing...                          ################################# [100%]
		Updating / installing...
		1:puppetlabs-release-pc1-0.9.2-1.el################################# [100%]
    

## apt-based
   
1. Choose the package based on your specific operating system and version:
** Explain the package naming convention (puppetlabs-release-COLLECTION-OS-VERSION.rpm) **
`puppetlabs-release-pc1-squeeze.deb`

		root@ksq268o6gv15bwo:~# wget http://apt.puppetlabs.com/puppetlabs-release-pc1-squeeze.deb
		root@ksq268o6gv15bwo:~# dpkg -i puppetlabs-release-pc1-squeeze.deb
		root@ksq268o6gv15bwo:~# apt-get update

Step 2: Make Sure You'll Be Able to Run the Puppet Executables
-----

The new location for Puppet's executables is `/opt/puppetlabs/bin/`, which is not in your PATH by default.

This doesn't matter for the service configs (so `service puppet start` will work fine), but if you're running any interactive `puppet` commands, you'll need to either add them to your PATH or refer to them by full name.

See [our page about moved files and directories][where] for more info.

Step 3: Install Puppet Server
-----

(Skip this step for a standalone deployment.)

### A: Install the `puppetserver` Package

#### For RPM-based systems using yum
On your Puppet master node(s), run `sudo yum install puppetserver`. This installs Puppet Server, which will install the `puppet-agent` package as a dependency.

#### For dpkg-based systems using apt-get
On your Puppet master node(s), run `apt-get install puppetserver`. This installs Puppet Server, which will install the `puppet-agent` package as a dependency.


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

#### For RPM-based systems using yum
On your Puppet agent node(s), run `sudo yum install puppet-agent`. 

#### For dpkg-based systems using apt-get
On your Puppet agent node(s), run `apt-get install puppet-agent`.

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

