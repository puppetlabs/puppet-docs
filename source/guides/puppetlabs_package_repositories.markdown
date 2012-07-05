---
title: "Using the Puppet Labs Package Repositories"
layout: legacy
---

Puppet Labs maintains official package repositories for several of the more popular Linux distributions. These repos contain the latest available packages for Puppet, Facter, PuppetDB, Puppet Dashboard, MCollective, and several prerequisites and add-ons for Puppet Labs products. 

We also maintain repositories for Puppet Enterprise users. These repos contain additional PE components, as well as modified packages for tools like PuppetDB which will integrate more smoothly with PE's namespaced installation layout.

This page explains how to enable these repositories on all of the supported operating systems.

Open Source Repositories
-----

Use these repositories to install open source releases of Puppet, Facter, MCollective, PuppetDB, and more. After enabling the repo, [follow the instructions for installing Puppet](./installation.html).

### For Red Hat Enterprise Linux and Derivatives

The [yum.puppetlabs.com](http://yum.puppetlabs.com) repository supports versions 5 and 6 of Red Hat Enterprise Linux and distributions based on it, including but not limited to CentOS, Scientific Linux, and Ascendos. Enabling this repository will let you install Puppet without requiring any other external repositories like EPEL.

To enable the repository, run the command below that corresponds to your OS version:

#### Enterprise Linux 5

    $ sudo rpm -ivh http://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-1.noarch.rpm

#### Enterprise Linux 6

    $ sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-1.noarch.rpm

### For Debian and Ubuntu

The [apt.puppetlabs.com](http://apt.puppetlabs.com) repository supports the following OS versions:

* Debian 6 "Squeeze" (current stable release)
* Debian 5 "Lenny" (previous stable release)
* Debian "Wheezy" (current testing distribution)
* Debian "Sid" (current unstable distribution)
* Ubuntu 12.04 LTS "Precise Pangolin"
* Ubuntu 10.04 LTS "Lucid Lynx" (also supported by [Puppet Enterprise][peinstall])
* Ubuntu 8.04 LTS "Hardy Heron"
* Ubuntu 11.10 "Oneiric Ocelot"
* Ubuntu 11.04 "Natty Narwhal"
* Ubuntu 10.10 "Maverick Meerkat"

To enable the repository:

1. Download the "puppetlabs-release" package for your OS version. 
    * You can see a full list of these packages on the front page of <http://apt.puppetlabs.com/>. They are all named `puppetlabs-release-<CODE NAME>.deb`.
2. Install the package by running `dpkg -i <PACKAGE NAME>`. 

For example, to enable the repository for Ubuntu 12.04 Precise Pangolin:

    $ wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    $ sudo dpkg -i puppetlabs-release-precise.deb

### For Fedora

The [yum.puppetlabs.com](http://yum.puppetlabs.com) repository supports Fedora 15 and 16. To enable the repository, run the command below that corresponds to your OS version:

#### Fedora 15

    $ sudo rpm -ivh http://yum.puppetlabs.com/fedora/f15/products/i386/puppetlabs-release-15-1.noarch.rpm

#### Fedora 16

    $ sudo rpm -ivh http://yum.puppetlabs.com/fedora/f16/products/i386/puppetlabs-release-16-1.noarch.rpm

Puppet Enterprise Repositories
-----

Use these repositories to install PE-compatible versions of PuppetDB and the Ruby development headers.

### For Red Hat Enterprise Linux and Derivatives

The [yum-enterprise.puppetlabs.com](http://yum-enterprise.puppetlabs.com) repository supports versions 5 and 6 of Red Hat Enterprise Linux and distributions based on it, including but not limited to CentOS, Scientific Linux, and Ascendos. It contains additional components and add-ons compatible with Puppet Enterprise's installation layout. 

To enable the repository, run the command below that corresponds to your OS version:

#### Enterprise Linux 5

    $ sudo rpm -ivh http://yum-enterprise.puppetlabs.com/el/5/extras/i386/puppetlabs-enterprise-release-extras-5-2.noarch.rpm

#### Enterprise Linux 6

    $ sudo rpm -ivh http://yum-enterprise.puppetlabs.com/el/6/extras/i386/puppetlabs-enterprise-release-extras-6-2.noarch.rpm

### For Debian and Ubuntu

The [apt-enterprise.puppetlabs.com](http://apt-enterprise.puppetlabs.com) repository supports Debian 6 ("Squeeze"), Ubuntu 10.04 LTS, and Ubuntu 12.04 LTS. 

To enable the repository, run the commands below:

    $ wget http://apt-enterprise.puppetlabs.com/puppetlabs-enterprise-release-extras_1.0-1_all.deb
    $ sudo dpkg -i puppetlabs-enterprise-release-extras_1.0-1_all.deb

