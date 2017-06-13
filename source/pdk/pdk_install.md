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
----------------|:---------------:|:------------------:|-------------------------
pdk | Command line tool for doing stuff [TODO: like what stuff]    | <# cell data #>
rspec-puppet | Tests the behavior of Puppet when it compiles your manifests into a catalogue of Puppet resources.    | <# cell data #>
puppet-lint | Checks your Puppet code against the recommendations in the Puppet Language style guide    | <# cell data #>
puppet-syntax | Checks for correct syntax in Puppet manifests, templates, and Hiera YAML.    | <# cell data #>
metadata-json-lint | Validates and lints metadata.json files in Puppet modules against style guidelines from the Puppet module metadata recommendations.    | <# cell data #>
rspec-puppet-facts | Adds a method for running rspec-puppet tests against the facts for your supported operating systems.    | <# cell data #>
puppetlabs_spec_helper | Provides classes, methods, and Rake tasks to help with spec testing Puppet code. | <# cell data #>


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

[TODO are we assuming they already have Puppet installed? Do they need Puppet installed on the workstation they are working on?]


## Preinstall tasks

[TK] This should be a list of stuff that the user needs to do before they can install PDK, IF this is the appropriate place for such instructions. For example, enabling the repository (if applicable).

### On Linux
Enable the package repository to your respective Linux platform. 

[TODO: add information like this... https://docs.puppet.com/puppet/3.8/install_debian_ubuntu.html#step-1-enable-the-puppet-package-repository

The exact url may change, but the steps/concept shouldnt.]

### Windows Platforms

[TODO: ANYTHING NEEDED?]


## Install PDK

Download the appropriate Puppet Development Kit package for your platform and install it.

[TODO: I don't know yet how similar these tasks will be, but I assume they will need to be separate topics.]

TODO [Reference](https://docs.puppet.com/puppet/4.10/install_linux.html)

TODO: Do our users need to do Step 1 from the above referenced page (highlighted text below? If so, for Linux only? Linux + OS X?)

>Confirm that you can run Puppet executables.
>
>The location for Puppet’s executables is /opt/puppetlabs/bin/, which is not in your PATH environment variable by default.
>
>The executable path doesn’t matter for Puppet services — for instance, service puppet start works regardless of the PATH — but if you’re running interactive puppet commands, you must either add their location to your PATH or execute them using their full path.
>
>To quickly add the executable location to your PATH for your current terminal session, use the command export PATH=/opt/puppetlabs/bin:$PATH. You can also add this location wherever you configure your PATH, such as your .profile or .bashrc configuration files.
>
>For more information, see details about files and directories moved in Puppet 4.

### On Linux-based systems 

1. Install the `puppet-pdk` package on your [TODO: where do they need to install pdk? the machine they are working on only? other machines?] Puppet agent nodes using the command appropriate to your system:

   * Apt: `sudo apt-get install puppet-pdk`
   * Yum: `sudo yum install puppet-pdk`

### On OS X

1. Download the PDK package from [TODO link to the puppet-pdk package for OS X on the Puppet downloads site](downloads.puppetlabs.com).
2. Double click on the downloaded package to install.

### On Windows

[Reference](https://docs.puppet.com/puppet/4.10/install_windows.html)
1. Download the PDK package from [TODO link to the puppet-pdk MSI on the Puppet downloads site](downloads.puppetlabs.com).
2. Double click on the downloaded package to install.



## Troubleshooting
  [TBD]
 

