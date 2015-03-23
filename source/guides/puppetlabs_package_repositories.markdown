---
title: "Using the Puppet Labs Package Repositories"
layout: default
nav: /_includes/puppet_general.html
---


Puppet Labs maintains official package repositories for several of the more popular Linux distributions. These repos contain the latest available packages for Puppet, Facter, PuppetDB, Puppet Dashboard, MCollective, and several prerequisites and add-ons for Puppet Labs products.

We also maintain repositories for Puppet Enterprise 2.8.x users. These repos contain additional PE components, as well as modified packages for tools like PuppetDB which will integrate more smoothly with PE's namespaced installation layout. Note these *only* apply to users of PE 2.8. In PE 3.x, PuppetDB and other components are already integrated.

This page explains how to enable these repositories on all of the supported operating systems.

Our repositories will be maintained for the life of the corresponding operating system and available for three months after their end of life date. So if an operating system goes end of life on July 15, our repositories for that operating system will still be available until October 15.

Open Source Repositories
-----

Use these repositories to install open source releases of Puppet, Facter, MCollective, PuppetDB, and more. After enabling the repo, [follow the instructions for installing Puppet](/guides/install_puppet/pre_install.html).

### For Red Hat Enterprise Linux and Derivatives

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following versions of Red Hat Enterprise Linux and distributions based on it:

{% include platforms_redhat_like.markdown %}

Enabling this repository will let you install Puppet in Enterprise Linux 5 without requiring any other external repositories like EPEL. For Enterprise Linux 6, we recommend that you enable the [Optional Channel](https://access.redhat.com/site/documentation/en-US/OpenShift_Enterprise/2/html/Client_Tools_Installation_Guide/Installing_Using_the_Red_Hat_Enterprise_Linux_Optional_Channel.html) for dependencies.

{% include repo_el.markdown %}

### For Debian and Ubuntu

The [apt.puppetlabs.com](https://apt.puppetlabs.com) repository supports the following OS versions:

{% include platforms_debian_like.markdown %}

{% include repo_debian_ubuntu.markdown %}

### For Fedora

The [yum.puppetlabs.com](https://yum.puppetlabs.com) repository supports the following Fedora versions:

{% include platforms_fedora.markdown %}

{% include repo_fedora.markdown %}


Using the Nightly Repos
-----

We provide automatic nightly repositories, and you can use them to test pre-release builds. These repos are available at <http://nightlies.puppetlabs.com/>.

The nightly repos require that you also have the standard Puppet Labs repos enabled.

### Nightly?

Our automated systems will only create new "nightly" repos for builds that pass our acceptance testing on the most popular platforms. This means there will sometimes be a skipped day.

### Contents of a Nightly Repo

Each nightly repo only contains **a single product.** Currently, we only make nightly repos for Puppet, Facter, and PuppetDB.

### Latest vs. Specific Commit

There are two kinds of nightly repo for each product:

* The "-latest" repo stays around forever, and always contains the latest build. It will have new packages every day or two. These repos are good for persistent canary systems.
* The other repos are all named after a specific Git commit. They contain a single build, so you can reliably install the same version on many systems. These repos are good for testing a specific build you're interested in; for example, if you want to help test an impending release announced on the puppet-users list.

    A single-commit repo will get deleted a week or two after it is created, so if you want to keep the packages available, you should import them into your local repository.

### Enabling Nightly Repos on Yum-based Systems

1. Make sure you've enabled the main Puppet Labs repos, as described above.
2. In a web browser, go to <http://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.
3. Click through to your repository's `repo_configs/rpm` directory, and identify the `.repo` file that applies to your operating system; this will usually be something like `pl-puppet-<COMMIT>-el-7-x86_64.repo`.
4. Download that `.repo` file into the system's `/etc/yum.repos.d/` directory. For example:

        $ cd /etc/yum.repos.d
        $ sudo wget http://nightlies.puppetlabs.com/puppet/30e4febe85e24c278a2830530965871dc3c0eec1/repo_configs/rpm/pl-puppet-30e4febe85e24c278a2830530965871dc3c0eec1-el-7-x86_64.repo
5. Upgrade or install the product as usual.

### Enabling Nightly Repos on Apt-based Systems

1. Make sure you've enabled the main Puppet Labs repos, as described above.
2. In a web browser, go to <http://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.
3. Click through to your repository's `repo_configs/deb` directory, and identify the `.list` file that applies to your operating system; this will usually be something like `pl-puppet-<COMMIT>-precise.list`.
4. Download that `.list` file into the system's `/etc/apt/sources.list.d/` directory. For example:

        $ cd /etc/apt/sources.list.d
        $ sudo wget http://nightlies.puppetlabs.com/puppet/30e4febe85e24c278a2830530965871dc3c0eec1/repo_configs/deb/pl-puppet-30e4febe85e24c278a2830530965871dc3c0eec1-precise.list
5. Be sure to run `sudo apt-get update`.
6. Upgrade or install the product as usual.

Using the Prerelease Repos
-----

Our open source repository packages also install a disabled prerelease repo, which contains release candidate versions of all Puppet Labs products. Enable this if you wish to test upcoming versions early, or if you urgently need a bug fix that has not gone into a final release yet.

> **Note:** We plan to phase out the prerelease repos in favor of the new and more flexible nightly repos. (See above.) The nightlies are nicer because they're single-serve; for example, you can enable a specific new version of Puppet without inviting in pre-release versions of everything.

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

