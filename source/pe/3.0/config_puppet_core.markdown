---
layout: default
title: "PE 3.0 » Puppet » Configuration & Troubleshooting"
subtitle: "Configuration & Troubleshooting"
---

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
