---
layout: default
title: "Installing the Puppet Development Kit"
canonical: "/pdk/pdk_install.html"
description: "Installing the Puppet Development Kit, the shortest path to developing better Puppet code."
---

Download and install the Puppet Development Kit to get started developing and testing Puppet modules.

## Installing PDK
 
To install the PDK, determine what platform it is going to be installed on: Windows, OS X, Red Hat, Ubuntu, etc.
 
[TODO: update this when support is finalized. These platforms are taken from [SDK-28](https://tickets.puppetlabs.com/browse/SDK-28) and describe the preliminary platform support goals. Due to the scoping constraints, the platforms may include as little as Red Hat, Ubuntu, OS X, and Windows only.]

PDK is supported on:


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
| Mac OS X | 10.10, 10.11 | x86_64 | N/A |
  
### Prerequisites

TODO: TK

### On Linux-based or OS X Platforms

Pre-install tasks include: referencing the `Puppet Collections and packages` doc to add the platform-specific [Puppet Collections](https://docs.puppet.com/puppet/latest/puppet_collections.html).

from Bryan: [5:03 PM] Bryan Jen: so it won't be part of a collection AFAIK
[5:03 PM] Bryan Jen: however
[5:05 PM] Bryan Jen: the install per-platform
[5:05 PM] Bryan Jen: will be similar to this:
 
### On Windows Platforms:
Provide link to the puppet-pdk MSI on the [Puppet downloads site](downloads.puppetlabs.com).
 
## Installation steps
 
### On Linux-based systems [Reference](https://docs.puppet.com/puppet/4.10/install_linux.html)
Yum – sudo yum install puppet-pdk
Apt – sudo apt-get install puppet-pdk


### On Windows

[Reference](https://docs.puppet.com/puppet/4.10/install_windows.html)
  Download MSI from the downloads.puppetlabs.com/windows url and double-click to install



## Troubleshooting
  [TBD]
 

