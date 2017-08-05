---
layout: default
title: "Installing the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_install.html"
description: "Installing the Puppet Development Kit, the shortest path to developing better Puppet code."
---


**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**


Install the Puppet Development Kit (PDK) as your first step in creating and testing Puppet modules.

{:.section}
### Before you begin

PDK is a stand-alone development kit and does not require a pre-existing installation of Puppet.

If you used an early release version of PDK, we recommend you uninstall it before installing PDK 1.0. Use your platform's package manager to uninstall any PDK versions earlier than 1.0, and then install the updated 1.0 package.

By default, PDK installs to:

* Linux and OS X systems: `/opt/puppetlabs/pdk/`
* Windows systems: `C:\Program Files\Puppet Labs\DevelopmentKit`

{:.reference}
### Supported operating systems

| Operating system | Version(s) | Arch | PkgType |
| ---------------- | ---------- | ---- | ------- |
| Red Hat Enterprise Linux | 6, 7 | x86_64 | RPM |
| CentOS | 6, 7 | x86_64 | RPM |
| Oracle Linux | 6, 7 | x86_64 | RPM |
| Scientific Linux | 6, 7 | x86_64 | RPM |
| SUSE Linux Enterprise Server | 11, 12 | x86_64 | N/A |
| Ubuntu | 14.04. 16.04 | x86_64 | DEB |
| Windows (Consumer OS) | 7, 8.1, 10 | x86_64 | MSI |
| Windows Server (Server OS) | 2008r2, 2012, 2012r2, 2012r2 Core, and 2016 | x86_64 | MSI |
| Mac OS X | 10.11, 10.12 | x86_64 | N/A |


{:.task}
## Download PDK

Download the appropriate Puppet Development Kit (PDK) package for your platform.

1. Download the PDK package from [PDK downloads site](https://puppet.com/download-puppet-development-kit).

{:.task}
## Install PDK on Linux-based systems 

1. Install the `pdk` package using the command appropriate to your system:

   * On RPM-based (Red Hat, SLES) systems, run `sudo rpm -ivh pdk-<version>-<platform>.rpm`
   * On Debian-based (Debian, Ubuntu) systems: `sudo dpkg -i pdk-<version>-<platform>.rpm`

1. Open a new terminal to re-source your shell profile and make PDK available to your PATH.

{:.task}
## Install PDK on OS X

1. Double click on the downloaded package to install.
1. Open a new terminal to re-source your shell profile and make PDK available to your PATH.

{:.task}
## Install PDK on Windows

1. Double click on the downloaded package to install.
1. Open a new terminal or Powershell window to re-source your profile and make PDK available to your PATH.
 

