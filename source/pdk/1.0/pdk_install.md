---
layout: default
title: "Installing the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_install.html"
description: "Installing the Puppet Development Kit, the shortest path to developing better Puppet code."
---

[troubleshoot]: ./pdk_troubleshooting.html

Install Puppet Development Kit (PDK) as your first step in creating and testing Puppet modules.

PDK is a stand-alone development kit and does not require Puppet installation.

If you used an early release version of PDK, uninstall it before installing PDK 1.0. Use your platform's package manager to uninstall any PDK versions earlier than 1.0, and then install the updated 1.0 package.

By default, PDK installs to the following location:

* On Linux and OS X systems: `/opt/puppetlabs/pdk/`
* On Windows systems: `C:\Program Files\Puppet Labs\DevelopmentKit`

{:.reference}
### Requirements and limitations

PDK supports the following operating systems.

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

On Windows, PowerShell 4.0 or greater is recommended, 2.0 or greater is supported.

PDK functions, such as creating classes, testing, and validation, are supported only on modules created with PDK.

Modules created with PDK are supported with all Puppet and Ruby version combinations currently under maintenance. See open source [Puppet](https://docs.puppet.com/puppet/latest/about_agent.html) and [Puppet Enterprise](https://puppet.com/misc/puppet-enterprise-lifecycle) lifecycle pages for details.

{:.task}
## Install PDK on Linux-based systems

Download and install the PDK package for Linux-based systems.

1. Download the PDK package from [PDK downloads site](https://puppet.com/download-puppet-development-kit).
1. Install the `pdk` package using the command appropriate to your system:
   * On RPM-based (Red Hat, SLES) systems, run `sudo rpm -ivh pdk-<version>-<platform>.rpm`
   * On Debian-based (Debian, Ubuntu) systems, run `sudo dpkg -i pdk-<version>-<platform>.deb`
1. Open a terminal to re-source your shell profile and make PDK available to your PATH.


{:.task}
## Install PDK on OS X

Download and install the PDK package for Mac OS X systems.

1. Download the PDK package from [PDK downloads site](https://puppet.com/download-puppet-development-kit).
1. Double click on the downloaded package to install.
2. Open a terminal to re-source your shell profile and make PDK available to your PATH.

{:.task}
## Install PDK on Windows

Download and install the PDK package for Windows systems.

1. Download the PDK package from [PDK downloads site](https://puppet.com/download-puppet-development-kit).
1. Double click on the downloaded package to install.
1. Open a Powershell window to re-source your profile and make PDK available to your PATH.

On PowerShell 4.0 or later, PDK loads automatically and the `pdk` command is available to the prompt. On PowerShell 2.0 or 3.0, you'll need to add the PowerShell module to your profile.

> If you encounter execution policy restriction errors when you try to run `pdk` commands, see [PDK troubleshooting][troubleshoot] for help.

{:.task}
### Add the PDK module to PowerShell 2.0 or 3.0

PowerShell versions 2.0 and 3.0 cannot automatically discover and load the PDK PowerShell module. Add the module to your PowerShell profile to load it.

1. Add the following line to your PowerShell profile:

   ``` powershell
   `Import-Module -Name "$($env:ProgramFiles)\WindowsPowerShell\Modules\PuppetDevelopmentKit"`
   ```

2. Close and open PowerShell to re-source your profile.

PDK will now automatically load every time you open PowerShell. 

{:.concept}
## Setting up PDK behind a proxy

If you are using PDK behind a proxy, you must set environment variables before running PDK commands to allow it to communicate.

You can either set these variables on the command line before each working session or add them to your system configuration, which varies depending on the operating system.

On Linux-based or OS X systems, run:

```
export http_proxy="http://user:password@proxy.domain.com:port"
export https_proxy="http://user:password@proxy.domain.com:port"
```

On Windows systems, run:

```
$env:http_proxy="http://user:password@proxy.domain.com:port"
$env:https_proxy="http://user:password@proxy.domain.com:port"
```
