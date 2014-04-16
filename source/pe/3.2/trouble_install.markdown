---
layout: default
title: "PE 3.2 » Troubleshooting » Installation"
subtitle: "Troubleshooting Installer Issues"
canonical: "/pe/latest/trouble_install.html"
---

Common Installer Problems
-----

Here are some common problems that can cause an install to go awry.

### Upgrades from 3.2.0 Can Cause Issues with Multi-Platform Agent Packages

Users upgrading from PE 3.2.0 to a later version of 3.x (including 3.2.2) will see errors when attempting to download agent packages for platforms other than the master. After adding `pe_repo` classes to the master for desired agent packages, errors will be seen on the subsequent puppet run as PE attempts to access the requisite packages. The issue is caused by an incorrectly set parameter of the `pe_repo` class. It can be fixed as follows:

1. In the console, navigate to the node page for each master node where you wish to add agent packages.
2. On the master's node page, click "Edit" and then, for the `pe_repo` parameter, click "Edit parameters"    
3. Next to the `base_path` parameter, click "Reset value"
4. Save the parameter change and update the node.

Once this has been done, you should now be able to add new agent platforms without issue. 

### A Note about Changes to `puppet.conf` that Can Cause Issues During Upgrades 

If you manage `puppet.conf` with Puppet or a third-party tool like Git or r10k, you may encounter errors after upgrading based on the following changes. Please assess these changes before upgrading.  

* **`node_terminus` Changes**

   In PE versions earlier than 3.2, node classification was configured with `node_terminus=exec`, located in `/etc/puppetlabs/puppet/puppet.conf`. This caused the puppet master to execute a custom shell script (`/etc/puppetlabs/puppet-dashboard/external_node`) which ran a curl command to retrieve data from the console. 

   PE 3.2 changes node classification in `puppet.conf`; the new configuration is `node_terminus=console`. The `external_node` script is no longer available; thus, `node_terminus=exec` no longer works. 

   With this change, we have improved security, as the puppet master can now verify the console. The console certificate name is `pe-internal-dashboard`. The puppet master now finds the console by reading the contents of /`etc/puppetlabs/puppet/console.conf`, which provides the following:

      [main]
      server=<console hostname>
      port=<console port>
      certificate_name=pe-internal-dashboard

   This file tells the puppet master where to locate the console and what name it should expect the console to have. If you want to change the location of the console, you can edit `console.conf`, but **DO NOT** change the `certificate_name` setting. 

   The rules for certificate-based authorization to the console are found in `/etc/puppetlabs/console-auth/certificate_authorization.yml` on the console node. By default, this file allows the puppet master read-write access to the console (based on it's certificate name) to request node data and submit report data. 

* **Reports Changes**

   Report submission to the console no longer happens using `reports=https`. PE 3.2 changed the setting in `puppet.conf` to `reports=console`. This change works in the same way as the `node_terminus` changes described above.

### Installing Without Internet Connectivity

By default, the master node hosts a repo that contains packages used for agent installation. In order to obtain these packages, the install script will attempt to connect to the internet in order to access a Puppet Labs-maintained repo on Amazon S3. If the script cannot access the remote repo (due to a firewall issue, IT policy, etc.), the agent tarball will not be downloaded and you will see error messages in the first and subsequent puppet runs on the master. These do not mean the installation failed, only the retrieval of the tarball.

Depending on your particular deployment there are three ways you can resolve this issue. In each case, you will need to procure the agent tarball beforehand. 

* If you already have a package management/distribution system, you can use it to install agents by adding the agent packages to your repo. In this case, you can disable the PE-hosted repo feature altogether by removing the `pe-repo` class from your master.

* If you would like to use PE-provided repo, you can copy the agent tarball into `/opt/staging/pe_repo` so the master won't attempt to download it. This will prevent the error message from recurring on subsequent puppet runs.

* Lastly, if your deployment has multiple masters and you don't wish to copy the agent tarball to each one, you can specify a path to the agent tarball. This can be done with an [answer file](./install_automated.html), by setting `q_tarball_server` to an accessible server containing the tarball, or by [using the console](./console_classes_groups.html#editing-class-parameters-on-nodes) to set the `base_path` parameter of the `pe_repo` class to an accessible server containing the tarball.


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


* * * 

- [Next: Troubleshooting Connections & Communications ](./trouble_comms.html)
