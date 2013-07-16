---
layout: default
title: "PE 2.5 » Advanced Configuration » Installing Additional Components"
subtitle: "Installing Additional Components"
canonical: "/pe/latest/cloudprovisioner_configuring.html"
---

Several optional components of PE can be installed manually.

Installing Cloud Provisioner
-----

You can install PE's cloud provisioning tools on any node by running the `puppet-enterprise-upgrader` script included in the installation tarball. This script will give you a chance to install the cloud provisioning tools. Using the upgrader script for the version of PE that is already installed should have no ill effect on the node's configuration. 

Installing the Ruby Development Libraries
-----

Puppet Enterprise ships its own copy of Ruby. If you need to install the Ruby development libraries, the installer tarball includes packages for them, which can be installed manually.

The installation method will depend on your operating system's package management tools, but in each case, you must first navigate to the directory containing the packages for your operating system and architecture, which will be inside the `packages` subdirectory of the unarchived Puppet Enterprise tarball.

For systems using apt and dpkg (Ubuntu and Debian), run the following commands: 

    $ sudo dpkg -i *ruby*dev* 

    $ sudo apt-get install --fix-broken

For systems using rpm and yum (Red Hat Enterprise Linux, CentOS, and Oracle Linux), run the following commands: 

    $ sudo yum localinstall --nogpgcheck *ruby*dev* 


* * * 

- [Next: Orchestration Overview](./orchestration_overview.html)
