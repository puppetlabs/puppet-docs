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

The PDK package includes testing tools, a complete module skeleton, and command line tools that help get you started creating and testing Puppet modules.

Specifically, the package includes:
[TODO: what exactly gets installed when you install the PDK package?]
[TODO: are we versioning this? what versions of things are included in this version?] [TODO: When do we update the PDK package and how do users get updates?]

Tool   | Description      | Version
----------------|:---------------:|-------------------------
pdk | Command line tool for doing stuff [TODO: like what stuff]
rspec-puppet | Tests the behavior of Puppet when it compiles your manifests into a catalogue of Puppet resources.
puppet-lint | Checks your Puppet code against the recommendations in the Puppet Language style guide
puppet-syntax | Checks for correct syntax in Puppet manifests, templates, and Hiera YAML.
metadata-json-lint | Validates and lints metadata.json files in Puppet modules against style guidelines from the Puppet module metadata recommendations.
rspec-puppet-facts | Adds a method for running rspec-puppet tests against the facts for your supported operating systems.
puppetlabs_spec_helper | Provides classes, methods, and Rake tasks to help with spec testing Puppet code.


PDK 1.0 is supported on: [TODO: update this table when support is finalized. These platforms are taken from [SDK-28](https://tickets.puppetlabs.com/browse/SDK-28) and describe the preliminary platform support goals. Due to the scoping constraints, the platforms may include as little as Red Hat, Ubuntu, OS X, and Windows only.]

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

[TODO what are the requirements and dependencies? What does the user need to have already set up?]
[TODO are we assuming they already have Puppet installed? Do they need Puppet installed on the workstation they are working on?]

* prereq
* prereq
* prereq

## Preinstall tasks

[TK] [TODO: This should be a list of stuff that the user needs to do before they can install PDK, IF this is the appropriate place for such instructions. I have already added Enable the repository below.

## Enable the repository on Linux-based systems [TODO: is Linux-based correct? Unix-like?] 

[TODO PLEASE tech review this section for accuracy; I swiped it from Platform docs.]

To download and install the PDK, you'll first need to enable the package repository to your respective Linux platform. 

### Yum-based systems

To enable the PDK [TODO is that right, or does it live in another repo?] repository:

1. Choose the package based on your operating system and version. The packages are located in the [`yum.puppet.com`](https://yum.puppet.com) [TODO: is this where the packages will live?] repository and named using the following convention:

   `<PLATFORM_NAME>-release-<OS ABBREVIATION>-<OS VERSION>.noarch.rpm` [TODO: what do the package names look like?]

   For instance, the package for Puppet 5 Platform on Red Hat Enterprise Linux 7 (RHEL 7) is `puppet5-release-el-7.noarch.rpm`.

2. Use the `rpm` tool as root with the `upgrade` (`-U`) flag, and optionally the `verbose` (`-v`), and `hash` (`-h`) flags:

    `sudo rpm -Uvh https://yum.puppetlabs.com/puppet5-release-el-7.noarch.rpm`

[TODO: I'm inclined to remove specific links in the page as show below. Opinions welcome. If yes, these will need updating to correct links before release.]

#### Enterprise Linux 7

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm

#### Enterprise Linux 6

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-6.noarch.rpm

#### Enterprise Linux 5

    wget https://yum.puppetlabs.com/puppet5/puppet5-release-el-5.noarch.rpm
    sudo rpm -Uvh puppet5-release-el-5.noarch.rpm
[TODO: I guess this Linux version specifically require wget AND rpm commands?]

#### Fedora 25

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-fedora-25.noarch.rpm

#### Fedora 24

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-fedora-24.noarch.rpm

### Apt-based systems

To enable the PDK repository:

1. Choose the package based on your operating system and version. The packages are located in the [`apt.puppet.com`](https://apt.puppet.com) [TODO need to know where these live] repository and named using the convention `<PLATFORM_VERSION>-release-<VERSION CODE NAME>.deb` [TODO and need to know the naming convention]

   For instance, the release package for Puppet Platform on Debian 7 "Wheezy" is `puppet5-release-wheezy.deb`. For Ubuntu releases, the code name is the adjective, not the animal.

2. Download the release package and install it as root using the `dpkg` tool and the `install` flag (`-i`):

```
wget https://apt.puppetlabs.com/puppet5-release-wheezy.deb
sudo dpkg -i puppet5-release-wheezy.deb
```

3. Run `apt-get update` after installing the release package to update the `apt` package lists.

[TODO Again, still deciding whether we keep all of these specific links/commands.]

#### Ubuntu 16.04 Xenial Xerus

    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update

#### Ubuntu 14.04 Trusty Tahr

    wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
    sudo dpkg -i puppet5-release-trusty.deb
    sudo apt-get update

#### Debian 8 Jessie

    wget https://apt.puppetlabs.com/puppet5-release-jessie.deb
    sudo dpkg -i puppet5-release-jessie.deb
    sudo apt-get update

#### Debian 7 Wheezy

    wget https://apt.puppetlabs.com/puppet5-release-wheezy.deb
    sudo dpkg -i puppet5-release-wheezy.deb
    sudo apt-get update

### Windows Platforms

[TODO: ANY PREINSTALL NEEDED?]

### OS X

[TODO: ANY PREINSTALL NEEDED?]

## Install PDK

Download the appropriate Puppet Development Kit package for your platform and install it.

[TODO: I don't know yet how similar these tasks will be, but I assume they will need to be separate topics.]

TODO [Reference](https://docs.puppet.com/puppet/4.10/install_linux.html)

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
 

