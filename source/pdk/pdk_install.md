---
layout: default
title: "Installing the Puppet Development Kit"
canonical: "/pdk/pdk_install.html"
description: "Installing the Puppet Development Kit, the shortest path to developing better Puppet code."
---


**Note: this page is a draft in progress and is neither technically reviewed nor edited. Do not rely on information in this draft.**

Download and install the Puppet Development Kit to get started developing and testing Puppet modules.

{:.concept}
## Installing PDK

Install the Puppet Development Kit as your first step in creating and testing Puppet modules.

The PDK package includes testing tools, a complete module skeleton, and command line tools to enable you to more easily create and test Puppet modules.

Specifically, the package includes the following tools:

Tool   | Description
----------------|-------------------------
pdk | Command line tool for generating and testing modules
rspec-puppet | Tests the behavior of Puppet when it compiles your manifests into a catalog of Puppet resources.
puppet-lint | Checks your Puppet code against the recommendations in the Puppet Language style guide.
puppet-syntax | Checks for correct syntax in Puppet manifests, templates, and Hiera YAML.
metadata-json-lint | Validates and lints `metadata.json` files in modules against  Puppet's module metadatastyle guidelines.
rspec-puppet-facts | Adds support for running rspec-puppet tests against the facts for your supported operating systems.
puppetlabs_spec_helper | Provides classes, methods, and Rake tasks to help with spec testing Puppet code.

PDK 1.0 is supported on:

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

{:.section}
### Before you begin

PDK is a stand-alone development kit and does not require a pre-existing installation of Puppet. On Linux-based systems, you must enable the repository before you can download and install the package.

If you used an early release version of PDK, we recommend you uninstall it before installing PDK 1.0. Use your platform's package manager to uninstall any PDK versions earlier than 1.0, and then install the updated 1.0 package.

{:.task}
## Enable the PDK repository on Linux

Before you can download and install the PDK, enable the package repository to your respective Linux platform. 

{:.task}
### Enable PDK repo on Yum-based systems

Before you can install the PDK package, enable the repository on your Yum-based system.

1. Choose the package based on your operating system and version.

   Packages are located in the [`yum.puppet.com/pdk`](https://yum.puppet.com/pdk) repository and are named using the PDK package name and version, followed by the OS abbreviation and version.

   For instance, the PDK package for Red Hat Enterprise Linux 7 (RHEL 7) is `pdk-1.0.0.-1.el7.x86_64.rpm`.

2. Install with `rpm` as root with the `upgrade` (`-U`) flag, and optionally the `verbose` (`-v`), and `hash` (`-h`) flags.

   For example:

   `sudo rpm -Uvh https://yum.puppet.com/pdk/pdk-1.0.0.-1.el7.x86_64.rpm`

{:.task}
### Enable PDK repo on Apt-based systems

Before you can install the PDK package, enable the repository on your Apt-based system.

1. Choose the package based on your operating system and version.

   The packages are located in the [`apt.puppet.com/pdk`](https://apt.puppet.com/pdk) and are named using the PDK package name and version, followed by the OS abbreviation and version.

   For instance, the release package for Puppet Platform on Debian 7 "Wheezy" is `pdk-1.0.0-wheezy.deb`. For Ubuntu releases, the code name is the adjective, not the animal.

2. Download the PDK package and install it as root using `dpkg` and the `install` flag (`-i`):

```
wget https://apt.puppetlabs.com/pdk-1.0.0-wheezy.deb
sudo dpkg -i pdk-1.0.0-wheezy.deb
```

3. Run `apt-get update` after installing the release package to update the `apt` package lists.

{:.task}
## Install PDK

Download the appropriate Puppet Development Kit package for your platform and install it.

### On Linux-based systems 

1. Confirm that you can run Puppet executables. [TODO: do users need to do this? Do we assume they have already done it, because they installed Puppet already or anything? Or is this step irrelevant to PDK?]

   The location for Puppet’s executables is /opt/puppetlabs/bin/, which is not in your PATH environment variable by default.

   The executable path doesn’t matter for Puppet services — for instance, service puppet start works regardless of the PATH — but if you’re running interactive puppet commands, you must either add their location to your PATH or execute them using their full path.

   To quickly add the executable location to your PATH for your current terminal session, use the command export PATH=/opt/puppetlabs/bin:$PATH. You can also add this location wherever you configure your PATH, such as your .profile or .bashrc configuration files.

1. Install the `puppet-pdk` package [TODO: where do they need to install pdk? the machine they are working on only? other machines?] using the command appropriate to your system:

   * Apt: `sudo apt-get install puppet-pdk`
   * Yum: `sudo yum install puppet-pdk`

### On OS X

1. Download the PDK package from [TODO link to the puppet-pdk package for OS X on the Puppet downloads site](downloads.puppetlabs.com).
2. Double click on the downloaded package to install.

### On Windows

1. Download the PDK package from [TODO link to the puppet-pdk MSI on the Puppet downloads site](downloads.puppetlabs.com).
2. Double click on the downloaded package to install.

## Troubleshooting
  [TBD]
 

