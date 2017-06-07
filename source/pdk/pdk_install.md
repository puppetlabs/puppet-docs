---
layout: default
title: "Installing the Puppet Development Kit"
canonical: "/pdk/pdk_install.html"
description: "Installing the Puppet Development Kit, the shortest path to developing better Puppet code."
---

Download and install the Puppet Development Kit to get started developing and testing Puppet modules.

{:.concept}
## Installing PDK

The PDK package includes testing tools, a complete module skeleton, and command line tools that help get you started creating and testing Puppet modules.

Specifically, the package includes:
[TODO: what exactly gets installed when you install the PDK package?]
[TODO: are we versioning this? what versions of things are included in this version?] [TODO: When do we update the PDK package and how do users get updates?]

[TODO: Jean, make a table]

* the pdk command line tool
* rspec-puppet
* puppet-lint
* puppet-syntax
* metadata-json-lint
* rspec-puppet-facts
* puppetlabs_spec_helper
* A complete module skeleton

PDK [TODO are we versioning this?] is supported on: [TODO: update this table when support is finalized. These platforms are taken from [SDK-28](https://tickets.puppetlabs.com/browse/SDK-28) and describe the preliminary platform support goals. Due to the scoping constraints, the platforms may include as little as Red Hat, Ubuntu, OS X, and Windows only.]

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


## Prerequisites

[TODO this should be a list of stuff the user should already have done or have set up.]
Before you begin [TODO: prereqs TK]:

* prereq
* prereq
* prereq

[TODO are we assuming they already have Puppet installed? Do they need Puppet installed on the workstation they are coding from?]


### Preinstall on Linux

Enable the package repository to your respective Linux platform: Like this... https://docs.puppet.com/puppet/3.8/install_debian_ubuntu.html#step-1-enable-the-puppet-package-repository

The exact url may change, but the steps/concept shouldnt.


## Preinstall tasks

[TK] This should be a list of stuff that the user needs to do before they can install PDK. For example, enabling the repository (if applicable).

For Linux:
1) Enable the package repository to your respective Linux platform: Like this... https://docs.puppet.com/puppet/3.8/install_debian_ubuntu.html#step-1-enable-the-puppet-package-repository

The exact url may change, but the steps/concept shouldnt.


### Install PDK on Linux-based or OS X
 
### Windows Platforms:


### Install PDK

For installation instructions, 
1. Figure out what platform you are on.
2. Download the correct package for your platform.
3. Do the thing to install.

[TODO: I don't know yet how similar these tasks will be, but I assume they will need to be separate topics.]

To install the PDK, determine what platform it is going to be installed on: Windows, OS X, Red Hat, Ubuntu, etc.


## Installation steps
 
### On Linux-based systems [Reference](https://docs.puppet.com/puppet/4.10/install_linux.html)
Yum – sudo yum install puppet-pdk
Apt – sudo apt-get install puppet-pdk

2) Install PDK

This is where the respective linux platform install commands will need to be differentiated.

e.g. sudo apt-get install puppet-pdk or sudo yum install puppet-pdk

For Windows/OSX:

1) Download the pkg or msi
2) double-click to install

### On Windows

[Reference](https://docs.puppet.com/puppet/4.10/install_windows.html)
1. Download the PDK package from [TODO link to the puppet-pdk MSI on the Puppet downloads site](downloads.puppetlabs.com).
2. Double click on the downloaded package to install.



## Troubleshooting
  [TBD]
 

