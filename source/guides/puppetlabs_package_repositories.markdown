---
title: "Using the Puppet Labs Package Repositories"
layout: default
nav: puppet_general.html
---


Puppet Labs maintains official package repositories for several of the more popular Linux distributions. These repos contain the latest available packages for Puppet, Facter, PuppetDB, Puppet Dashboard, MCollective, and several prerequisites and add-ons for Puppet Labs products.

We also maintain repositories for Puppet Enterprise 2.8.x users. These repos contain additional PE components, as well as modified packages for tools like PuppetDB which will integrate more smoothly with PE's namespaced installation layout. Note these *only* apply to users of PE 2.8. In PE 3.x, PuppetDB and other components are already integrated.

This page explains how to enable these repositories on all of the supported operating systems.

Our repositories will be maintained for the life of the corresponding operating system and available for three months after their end of life date. So if an operating system goes end of life on July 15, our repositories for that operating system will still be available until October 15.

Open Source Repositories
-----

Use these repositories to install open source releases of Puppet, Facter, MCollective, PuppetDB, and more. After enabling the repo, [follow the instructions for installing Puppet](./installation.html).

### For Red Hat Enterprise Linux and Derivatives

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following versions of Red Hat Enterprise Linux and distributions based on it:

{% include platforms_redhat_like.markdown %}

Enabling this repository will let you install Puppet in Enterprise Linux 5 without requiring any other external repositories like EPEL. For Enterprise Linux 6, you will need to [enable the Optional Channel](https://access.redhat.com/site/documentation/en-US/OpenShift_Enterprise/1/html/Client_Tools_Installation_Guide/Installing_Using_the_Red_Hat_Enterprise_Linux_Optional_Channel.html) for the rubygems dependency.

{% include repo_el.markdown %}

### For Debian and Ubuntu

The [apt.puppetlabs.com](https://apt.puppetlabs.com) repository supports the following OS versions:

{% include platforms_debian_like.markdown %}

{% include repo_debian_ubuntu.markdown %}

### For Fedora

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following Fedora versions:

{% include platforms_fedora.markdown %}

{% include repo_fedora.markdown %}

Enabling the Prerelease Repos
-----

Our open source repository packages also install a disabled prerelease repo, which contains release candidate versions of all Puppet Labs products. Enable this if you wish to test upcoming versions early, or if you urgently need a bug fix that has not gone into a final release yet.

### On Debian and Ubuntu

{% include repo_pre_debian_ubuntu.markdown %}

### On Fedora, RHEL, and Derivatives

{% include repo_pre_redhat.markdown %}

Puppet Enterprise 2.8 Repositories
-----

Use these repositories to install PE-compatible versions of PuppetDB and the Ruby development headers. **These repositories should only be used with Puppet Enterprise 2.8 and earlier;** PE 3 includes PuppetDB and the Ruby dev libraries by default.

### For Red Hat Enterprise Linux and Derivatives

The [yum-enterprise.puppetlabs.com](https://yum-enterprise.puppetlabs.com) repository supports versions 5 and 6 of Red Hat Enterprise Linux and distributions based on it, including but not limited to CentOS, Scientific Linux, and Ascendos. It contains additional components and add-ons compatible with Puppet Enterprise's installation layout.

To enable the repository, run the command below that corresponds to your OS version:

#### Enterprise Linux 5

##### i386

    $ sudo rpm -ivh https://yum-enterprise.puppetlabs.com/el/5/extras/i386/puppetlabs-enterprise-release-extras-5-2.noarch.rpm

##### x86_64

    $ sudo rpm -ivh https://yum-enterprise.puppetlabs.com/el/5/extras/x86_64/puppetlabs-enterprise-release-extras-5-2.noarch.rpm

#### Enterprise Linux 6

##### i386

    $ sudo rpm -ivh https://yum-enterprise.puppetlabs.com/el/6/extras/i386/puppetlabs-enterprise-release-extras-6-2.noarch.rpm

##### x86_64

    $ sudo rpm -ivh https://yum-enterprise.puppetlabs.com/el/6/extras/x86_64/puppetlabs-enterprise-release-extras-6-2.noarch.rpm

### For Debian and Ubuntu

The [apt-enterprise.puppetlabs.com](https://apt-enterprise.puppetlabs.com) repository supports Debian 6 ("Squeeze"), Ubuntu 10.04 LTS, and Ubuntu 12.04 LTS.

To enable the repository, run the commands below:

    $ wget http://apt-enterprise.puppetlabs.com/puppetlabs-enterprise-release-extras_1.0-2_all.deb
    $ sudo dpkg -i puppetlabs-enterprise-release-extras_1.0-2_all.deb
    $ sudo apt-get update

