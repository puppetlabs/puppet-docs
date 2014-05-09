---
layout: default
title: "PE 3.1 » Troubleshooting » Installation"
subtitle: "Troubleshooting Installer Issues"
canonical: "/pe/latest/trouble_install.html"
---

Common Installer Problems
-----

Here are some common problems that can cause an install to go awry.

### Is DNS Wrong?

If name resolution at your site isn't quite behaving right, PE's installer can go haywire.

* Puppet agent has to be able to reach the puppet master server at one of its valid DNS names. (Specifically, the name you identified as the master's hostname during the installer interview.)
* The puppet master also has to be able to reach **itself** at the puppet master hostname you chose during installation.
* If you've split the master and console roles onto different servers, they have to be able to talk to each other as well.

### Are the Security Settings Wrong?

The installer fails in a similar way when the system's firewall or security group is restricting the ports Puppet uses.

* Puppet communicates on **ports 8140, 61613, and 443.** If you are installing the puppet master and the console on the same server, it must accept inbound traffic on all three ports. If you've split the two roles, the master must accept inbound traffic on 8140 and 61613 and the console must accept inbound traffic on 8140 and 443.
* If your puppet master has multiple network interfaces, make sure it is allowing traffic via the IP address that its valid DNS names resolve to, not just via an internal interface.

### Did You Try to Install the Console Before the Puppet Master?

If you are installing the console and the puppet master on separate servers and tried to install the console first, the installer may fail.

### How Do I Recover From a Failed Install?

First, fix any configuration problem that may have caused the install to fail. See above for a list of the most common errors.

Next, run the uninstaller script. [See the uninstallation instructions in this guide](./install_uninstalling.html) for full details.

After you have run the uninstaller, you can safely run the installer again.

###  Problems with PE when upgrading your OS
 
Upgrading your OS while PE is installed can cause problems with PE. To perform an OS upgrade, you'll need to uninstall PE, perform the OS upgrade, and then reinstall PE as follows:

1. Back up your databases and other PE files.

2. Perform a complete [uninstall](/pe/3.1/install_uninstalling.html) (including the -pd uninstaller option).

3. Upgrade your OS.

4. [Install PE](/pe/3.1/install_basic.html).

5. Restore your backup.


* * * 

- [Next: Troubleshooting Connections & Communications ](./trouble_comms.html)
