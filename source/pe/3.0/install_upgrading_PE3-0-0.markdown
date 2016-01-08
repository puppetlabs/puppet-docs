---
layout: default
title: "PE 3.0 » Installing » Upgrading"
subtitle: "Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---


Summary
-----

Upgrading from an existing Puppet Enterprise deployment to PE 3.0 is currently only supported for puppet *agent* nodes running PE 2.5.3 or later. All other nodes must be migrated by installing the 3.0 master, console, database and cloud provisioner (if applicable) roles on a new node (or nodes, if you have separated roles), pointing your existing agents at that new node and then upgrading them to 3.0. A complete upgrade solution will be in place no later than August 15, 2013. If you wish to upgrade now, the instructions below should help.

If you'd prefer to wait until the complete solution is available, we nonetheless recommend that you set up some isolated test environments which duplicate existing parts of your infrastructure. This will help to familiarize you with the new features and functions of PE 3.0, and to get an idea of how your particular environment will need to be adapted.


> ![windows logo](./images/windows-logo-small.jpg) To upgrade Windows nodes, simply download and run the new MSI package as described in [Installing Windows Agents](./install_windows.html).


### Important Notes and Warnings

- Upgrading is now handled by the installer, which will detect whether or not a previous version of PE is installed and will then run in "install" or "upgrade" mode as appropriate.

- Upgrading is currently only supported for agents. If you attempt to upgrade an existing master, console, database support, or cloud provisioner node, the installer will quit with an error.

- PE 3 uses Ruby 1.9 which is stricter about character encoding than the previous version used in PE 2.8. If your manifests contain non-ASCII characters they may fail to compile or behave unpredictably. When upgrading, make sure manifests contain only ASCII characters. For more information see the [release notes](./appendix.html#puppet-code-issues-with-utf-8-encoding).

- On AIX 5.3, as in PE 2.8.2, puppet agents still depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading by running:

        rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

    If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed and you can proceed with the upgrade (you can verify the installation with  `rpm -q readline`).

Downloading PE
-----

If you haven't done so already, you will need a Puppet Enterprise tarball appropriate for your system(s). See the [Installing PE][downloading] section of this guide for information on downloading Puppet Enterprise tarballs.

[downloading]: ./install_basic.html#downloading-pe


Migrating a Deployment
-----

Follow these steps to migrate your 2.8.x deployment to 3.0. For the purpose of this description, we will assume you are using a "monolithic" architecture wherein the console, database support, and master roles are all running on the same node. If your deployment uses separate roles, the steps are largely similar, except that you should remember to install the roles in this order:

 1. Master
 2. Database support
 3. Console

Further, we assume that all of the components (agents, master, console, etc.) in your 2.8.x deployment are correctly configured and communicating with each other, and that live management is up and running with all nodes connected.

**Note** PE 3 uses Ruby 1.9 which is stricter about character encoding than the previous version used in PE 2.8. If your manifests contain non-ASCII characters they may fail to compile or behave unpredictably. When upgrading, make sure manifests contain only ASCII characters. For more information see the [release notes](./appendix.html#known-issues)

### Create a New PE 3.0 Master
Start by installing a new master/console/database on a fresh node (do *not* use an existing 2.8.x node) as described in the [basic install instructions](./install_basic.html).

### Move Certificates from the Old Master to the New

Next, you will move and/or create new credentials as follows (substituting the correct FQDN for your 2.8 master):

#### Copy CA and Agents' Certificates
First, we'll migrate the CA and agents' certificates from the old 2.8 master to the new 3.0 master.

On the new, 3.0 master run:

    cp -a /etc/puppetlabs/puppet/ssl /etc/puppetlabs/puppet/ssl.orig
    rm -r /etc/puppetlabs/puppet/ssl/*
    scp -r root@<2.8.x.master>:/etc/puppetlabs/puppet/ssl/* /etc/puppetlabs/puppet/ssl/

#### Generate a New Cert for the 3.0 Master
Because the new master's certificate that was initially generated during installation was signed by the now retired CA, we need to generate a new certifcate for the new master, which will get signed by the CA we copied in the previous step.


On the new, 3.0 master, run:

    puppet cert clean pe-internal-broker
    puppet cert generate 3-0master.domain --dns_alt_names=3-0master,3-0master.domain,puppet,puppet.domain
    puppet cert generate pe-internal-broker --dns_alt_names=3-0master,3-0master.domain,puppet,puppet.domain,stomp

#### Copy Console Certificates
Next, for the internal certificates used by the console, we also need migrate over the certificates signed by the 2.8 CA.

On the new, 3.0 master, run:

    scp root@2.8.x.master:/opt/puppet/share/puppet-dashboard/certs/* /opt/puppet/share/puppet-dashboard/certs/

#### Create New PuppetDB Certificates
Again, we need to replace the certificate generated during installtion with a certificate signed by the 2.8 CA.

On the new, 3.0 master, run:

    rm -r /etc/puppetlabs/puppetdb/ssl/*
    /opt/puppet/sbin/puppetdb-ssl-setup -f

#### Restart Services
To get the PE services to refresh their cached certificates, we need to restart them.

On the new, 3.0 master, run `service <service name> restart` for these services: `pe-puppet`, `pe-httpd`, and `pe-puppetdb`.

### Point 2.8.x Agents at the New 3.0 Master

#### Update `puppet.conf`

If your deployment uses a DNS CNAME to refer to the master, you'll need to update its DNS entry to reflect the new master. Otherwise, if you use FQDN's to refer to the master, you'll need to update the agents' configuration as follows.

On each agent, update the `/etc/puppetlabs/puppet/puppet.conf` file to point to the new, 3.0 master. Specifically, you will make two changes:

    [main]
        archive_file_server=<fqdn of 3.0 master>
    [agent]
        server=<fqdn of 3.0 master>


#### Remove Prior Installer Facts

On all agents, remove the facts file generated by the previous installation:

    rm /etc/puppetlabs/facter/facts.d/puppet_enterprise_installer.txt

#### Update Agent Catalogs

Trigger puppet runs on each agent with `puppet agent -t` until a message is displayed which warns that the 2.8 agent cannot communicate via live management with a 3.0 master:

    notice: In order for the Puppet Enterprise 3 master to communicate with an agent using MCollective, the agent must also be version 3.
    The mynode node is running Puppet Enterprise version 2.8.1 so it cannot communicate with the PE 3 master either via the Console's Live     Management view or via the MCO command line tool
    To fix this, upgrade the agent to Puppet Enterprise 3.
    ...

Next, verify that all the agents have reported by checking to see if they're listed in the console.

### Upgrade Agents to 3.0

Now that the agents are successfully pointed at the 3.0 master, they can be upgraded to 3.0 as well. This is done by running  `puppet-enterprise-installer` on each agent after the 3.0 tarball has been copied onto them and unpacked. The installer will detect that this is an upgrade, and proceed  to ask the usual install questions regarding vendor packages, symlinks, etc.

The installer should do a puppet run at the end of installation, but if the new agents are not yet available in live management, you can get them connected by waiting a minute or two and then running `puppet agent -t` one more time.

At this point you should have a fully functioning PE 3.0 deployment with a new master, console, and db support and upgraded agents connected to the new master and console.


Checking For Updates
-----

[Check here][updateslink] to find out what the latest maintenance release of Puppet Enterprise is. You can run `puppet --version` at the command line to see the version of PE you are currently running.


[updateslink]: http://info.puppetlabs.com/download-pe.html

**Note: By default, the puppet master will check for updates whenever the `pe-httpd` service restarts.** As part of the check, it passes some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable checking can be found in the [answer file reference](./install_answer_file_reference.html#puppet-master-answers).

* * *


- [Next: Uninstalling](./install_uninstalling.html)
