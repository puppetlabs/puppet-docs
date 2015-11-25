---
title: "Using the Puppet Labs Package Repositories"
layout: default
nav: /_includes/puppet_general.html
---

Puppet Labs maintains official package repositories for several of the more popular Linux distributions. To make the repos more predictable, we version them as "Puppet Collections" --- each collection has all of the software you need to run a functional Puppet deployment, in versions that are known to work well with each other. Each collection is opt-in, so if you’re running `ensure => latest`, you’ll get the latest in the collection you’re using. Whenever we make significant breaking changes that introduce incompatibilities between versions of our software, we make a new collection so that you can do major upgrades at your convenience.

Puppet Labs also maintains package repositories for older versions of PuppetDB, MCollective, Puppet Server, and several pre-requisites and add-ons for Puppet Labs products. You can also enable package repositories for older Puppet 3.x and Facter 2.x.

This page explains how to enable these repositories on their supported operating systems.

Our repositories will be maintained for the life of the corresponding operating system and available for one month after their end-of-life date.

## Using Puppet Collections

Puppet Collections are numbered with integers, beginning with PC1. The higher the integer, the newer the collection.

### Yum-based Systems

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following versions of Red Hat Enterprise Linux and distributions based on it:

{% include pup40_platforms_redhat_like.markdown %}

{% include pup43_platforms_fedora.markdown %}

To enable the repository, run the command below that corresponds to your OS version:

#### Enterprise Linux 7

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

#### Enterprise Linux 6

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm

#### Enterprise Linux 5

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-5.noarch.rpm

> **Note:** For recent versions of Puppet, we only ship new versions of the `puppet-agent` package for RHEL 5.

#### Fedora 22

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-22.noarch.rpm

#### Fedora 21

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-21.noarch.rpm

#### Fedora 20

    sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-20.noarch.rpm

> **Note:** For recent versions of Puppet, we no longer ship packages for Fedora 20.

### Apt-based Systems

The [apt.puppetlabs.com](https://apt.puppetlabs.com) repository supports the following OS versions:

{% include pup40_platforms_debian_like.markdown %}

To enable the repository:

1. Download the "puppetlabs-release-pc1" package for your OS version.
    * You can see a full list of these packages on the front page of <https://apt.puppetlabs.com/>. They are all named `puppetlabs-release-pc1-<CODE NAME>.deb`. (For Ubuntu releases, the code name is the adjective, not the animal.)
    * Architecture is handled automatically; there is only one package per OS version.
2. Install the package by running `dpkg -i <PACKAGE NAME>`.
3. Run `apt-get update` to get the new list of available packages.

For example, to enable the repository for Ubuntu 12.04 Precise Pangolin:

~~~ bash
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-precise.deb
sudo dpkg -i puppetlabs-release-pc1-precise.deb
sudo apt-get update
~~~

To enable the repository for Ubuntu 14.04 Trusty Tahr:

~~~ bash
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb
sudo apt-get update
~~~

## Pre-4.0 Open Source Repositories

Use these repositories to install specific older versions of open source releases of Puppet, Facter, MCollective, PuppetDB, and more. After enabling the repo, [follow the instructions for installing Puppet 3.8 and older](/puppet/3.8/reference/pre_install.html).

### Yum-based Systems Repository

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following versions of Red Hat Enterprise Linux and distributions based on it:

{% include platforms_redhat_like.markdown %}

Enabling this repository will let you install Puppet in Enterprise Linux 5 without requiring any other external repositories like EPEL. For Enterprise Linux 6, we recommend that you enable the [Optional Channel](https://access.redhat.com/site/documentation/en-US/OpenShift_Enterprise/2/html/Client_Tools_Installation_Guide/Installing_Using_the_Red_Hat_Enterprise_Linux_Optional_Channel.html) for dependencies.

{% include repo_el.markdown %}

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following Fedora versions:

{% include platforms_fedora.markdown %}

{% include repo_fedora.markdown %}

### Apt-based Systems Repository

The [apt.puppetlabs.com](https://apt.puppetlabs.com) repository supports the following OS versions:

{% include platforms_debian_like.markdown %}

{% include repo_debian_ubuntu.markdown %}

## Using the Nightly Repos

We provide automatic nightly repositories, and you can use them to test pre-release builds. These repos are available at <https://nightlies.puppetlabs.com/>.

The nightly repos require that you also have the standard Puppet Labs repos enabled.

### Nightly?

Our automated systems will only create new "nightly" repos for builds that pass our acceptance testing on the most popular platforms. This means there will sometimes be a skipped day.

### Contents of a Nightly Repo

Each nightly repo contains **a single product.** We make nightly repos for Puppet Server, Puppet Agent, and PuppetDB. We also have nightly packages for Puppet 3.x and Facter 2.x.

### Latest vs. Specific Commit

There are two kinds of nightly repo for each product:

* The "-latest" repo stays around forever, and always contains the latest build. It will have new packages every day or two. These repos are good for persistent canary systems.
* The other repos are all named after a specific Git commit. They contain a single build, so you can reliably install the same version on many systems. These repos are good for testing a specific build you're interested in; for example, if you want to help test an impending release announced on the puppet-users list.

    We delete single-commit repositories a week or two after we create them, so if you want to keep the packages available, import them into your local repository.

### Enabling Nightly Repos on Yum-based Systems

1. Enable the main Puppet Labs repos, as described above.
2. In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.
3. Click through to your repository's `repo_configs/rpm` directory, and identify the `.repo` file that applies to your operating system. This looks like `pl-puppet-<COMMIT>-el-7-x86_64.repo`.
4. Download the `.repo` file into the system's `/etc/yum.repos.d/` directory. For example:

    ~~~ bash
    cd /etc/yum.repos.d
    sudo wget https://nightlies.puppetlabs.com/puppet/30e4febe85e24c278a2830530965871dc3c0eec1/repo_configs/rpm/pl-puppet-30e4febe85e24c278a2830530965871dc3c0eec1-el-7-x86_64.repo
    ~~~
5. Upgrade or install the product as usual.

### Enabling Nightly Repos on Apt-based Systems

1. Enable the main Puppet Labs repos, as described above.
2. In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.
3. Click through to your repository's `repo_configs/deb` directory, and identify the `.list` file that applies to your operating system. This looks like `pl-puppet-<COMMIT>-precise.list`.
4. Download the `.list` file into the system's `/etc/apt/sources.list.d/` directory. For example:

    ~~~ bash
    cd /etc/apt/sources.list.d
    sudo wget https://nightlies.puppetlabs.com/puppet/30e4febe85e24c278a2830530965871dc3c0eec1/repo_configs/deb/pl-puppet-30e4febe85e24c278a2830530965871dc3c0eec1-precise.list
    ~~~
5. Run `sudo apt-get update`.
6. Upgrade or install the product as usual.
