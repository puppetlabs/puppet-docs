---
layout: default
title: "PE 3.7 » Troubleshooting » Installation"
subtitle: "Troubleshooting Installer Issues"
canonical: "/pe/latest/trouble_install.html"
---

Common Installer Problems
-----

Here are some common problems that can cause an install to go awry.

### Upgrades from 3.2.0 Can Cause Issues with Multi-Platform Agent Packages

Users upgrading from PE 3.2.0 to a later version of 3.x (including 3.2.3) will see errors when attempting to download agent packages for platforms other than the master. After adding `pe_repo` classes to the master for desired agent packages, errors will be seen on the subsequent Puppet run as PE attempts to access the requisite packages. The issue is caused by an incorrectly set parameter of the `pe_repo` class. It can be fixed as follows:

1. In the console, navigate to the node page for each master node where you wish to add agent packages.
2. On the master's node page, click __Edit__ and then, for the `pe_repo` parameter, click __Edit parameters__
3. Next to the `base_path` parameter, click __Reset value__
4. Save the parameter change and update the node.

Once this has been done, you should now be able to add new agent platforms without issue.

### A Note about Changes to `puppet.conf` that Can Cause Issues During Upgrades

If you manage `puppet.conf` with Puppet or a third-party tool like Git or r10k, you may encounter errors after upgrading based on the following changes. Please assess these changes before upgrading.

* **`node_terminus` Changes**

   In PE versions earlier than 3.2, node classification was configured with `node_terminus=exec`, located in `/etc/puppetlabs/puppet/puppet.conf`. This caused the Puppet master to execute a custom shell script (`/etc/puppetlabs/puppet-dashboard/external_node`) which ran a curl command to retrieve data from the console.

   PE 3.2 changed node classification in `puppet.conf`; the new configuration is `node_terminus=console`. The `external_node` script is no longer available; thus, `node_terminus=exec` no longer works.

   With this change, we improved security, as the Puppet master can now verify the console. The console certificate name is `pe-internal-dashboard`. The Puppet master now finds the console by reading the contents of /`etc/puppetlabs/puppet/console.conf`, which provides the following:

      [main]
      server=<console hostname>
      port=<console port>
      certificate_name=pe-internal-dashboard

   This file tells the Puppet master where to locate the console and what name it should expect the console to have. If you want to change the location of the console, you can edit `console.conf`, but **DO NOT** change the `certificate_name` setting.

   The rules for certificate-based authorization to the console are found in `/etc/puppetlabs/console-auth/certificate_authorization.yml` on the console node. By default, this file allows the Puppet master read-write access to the console (based on it's certificate name) to request node data and submit report data.

* **Reports Changes**

   Report submission to the console no longer happens using `reports=https`. PE 3.2 changed the setting in `puppet.conf` to `reports=console`. This change works in the same way as the `node_terminus` changes described above.

### Is DNS Wrong?

If name resolution at your site isn't quite behaving right, PE's installer can go haywire.

* Puppet agent has to be able to reach the Puppet master server at one of its valid DNS names. (Specifically, the name you identified as the master's hostname during the installer interview.)
* The Puppet master also has to be able to reach **itself** at the Puppet master hostname you chose during installation.
* If you've split the master and console components onto different servers, they have to be able to talk to each other as well.

### Are the Security Settings Wrong?

The installer fails in a similar way when the system's firewall or security group is restricting the ports Puppet uses.

* Puppet communicates on **ports 8140, 61613, and 443.** If you are installing the Puppet master and the console on the same server, it must accept inbound traffic on all three ports. If you've split the two components, the master must accept inbound traffic on 8140 and 61613 and the console must accept inbound traffic on 8140 and 443.
* If your Puppet master has multiple network interfaces, make sure it is allowing traffic via the IP address that its valid DNS names resolve to, not just via an internal interface.

### Did You Try to Install the Console Before the Puppet Master?

If you are installing the console and the Puppet master on separate servers and tried to install the console first, the installer may fail.

### Do You Need to Install Agents But Have No Internet Access?

Refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](./install_agents.html#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

### How Do I Recover From a Failed Install?

First, fix any configuration problem that may have caused the install to fail. See above for a list of the most common errors.

Next, run the uninstaller script. [See the uninstallation instructions in this guide](./install_uninstalling.html) for full details.

After you have run the uninstaller, you can safely run the installer again.

###  Problems with PE when upgrading your OS

Upgrading your OS while PE is installed can cause problems with PE. To perform an OS upgrade, you'll need to uninstall PE, perform the OS upgrade, and then reinstall PE as follows:

1. [Back up](/pe/latest/install_upgrading.html#before-upgrading-back-up-your-databases-and-other-pe-files) your databases and other PE files.

2. Perform a complete [uninstall](/pe/latest/install_uninstalling.html) (including the -pd uninstaller option).

3. Upgrade your OS.

4. [Install PE](/pe/latest/install_basic.html).

5. Restore your backup.


* * *

- [Next: Troubleshooting Connections & Communications ](./trouble_comms.html)
