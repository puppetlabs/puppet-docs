---
layout: default
title: "About Puppet Platform and its packages"
---

> **Note:** This document covers the Puppet Platform repository of open source Puppet 5-compatible software packages.
> -   For Puppet 3.8 open source packages, see its [repository documentation](/puppet/3.8/puppet_repositories.html).
> -   For Puppet Enterprise installation tarballs, see its [installation documentation](/pe/latest/install_basic.html).

Puppet maintains official Puppet 5 Platform package repositories for several operating systems and distributions. Puppet 5 Platform has all of the software you need to run a functional Puppet deployment, in versions that are known to work well with each other.

Puppet publishes updates for operating systems starting from the time a package is first published, to 30 days after the end of the operating system's vendor-determined lifespan.

See [The Puppet Enterprise Lifecycle](https://puppet.com/misc/puppet-enterprise-lifecycle) for information about phases of the Puppet Support Lifecycle.

To receive the most up-to-date Puppet software without introducing breaking changes, use the `latest` platform, pin your infrastructure to known versions, and update the pinned version manually when you're ready to update. For example, if you're using the [`puppetlabs-puppet_agent` module](https://forge.puppet.com/puppetlabs/puppet_agent) to manage the installed `puppet-agent` package, use this resource to pin it to version 5.0.0:

```
class { '::puppet_agent':
  collection      => 'latest',
  package_version => '5.0.0',
}
```

If you're upgrading from a 1.x version of `puppet-agent`, just update the `package_version` when you're ready to upgrade to the 5.x series.

## Puppet 5 Platform contents

Puppet 5 Platform contains the following components:

Package                              | Contents
-------------------------------------|----------------------------------------------
[`puppet-agent`](./about_agent.html) | Puppet, [Facter](/facter/), [Hiera](/puppet/latest/hiera_intro.html), [MCollective](/mcollective), `pxp-agent`, root certificates, and prerequisites like [Ruby](https://www.ruby-lang.org/) and [Augeas](http://augeas.net/)
`puppetserver`                       | [Puppet Server](/puppetserver/); depends on `puppet-agent` 5 or greater
`puppetdb`                           | [PuppetDB](/puppetdb/)
`puppetdb-termini`                   | Plugins to let [Puppet Server talk to PuppetDB](/puppetdb/latest/connect_puppet_master.html)


## Using Puppet 5 Platform

The way you access Puppet 5 Platform  depends on your operating system, and its distribution, version, and installation methods. If you use a *nix operating system with a package manager, for example, you access a Puppet Platform by adding it as a package repository.

> **Note:** macOS and Windows support the Puppet agent software only, via the [`puppet-agent` package](/puppet/latest/about_agent.html). macOS `puppet-agent` packages are organized by Puppet Platform; for more information, see [the macOS installation instructions](./install_osx.html).


### Yum-based systems

To enable the Puppet 5 Platform repository:

1. Choose the package based on your operating system and version. The packages are located in the [`yum.puppet.com`](https://yum.puppet.com) repository and named using the following convention:

   `<PLATFORM_NAME>-release-<OS ABBREVIATION>-<OS VERSION>.noarch.rpm`

   For instance, the package for Puppet 5 Platform  on Red Hat Enterprise Linux 7 (RHEL 7) is `puppet5-release-el-7.noarch.rpm`.

2. Use the `rpm` tool as root with the `upgrade` (`-U`) flag, and optionally the `verbose` (`-v`), and `hash` (`-h`) flags:

    `sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm`

#### Enterprise Linux 7

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm

#### Enterprise Linux 6

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-6.noarch.rpm

#### Enterprise Linux 5

    wget https://yum.puppetlabs.com/puppet5/puppet5-release-el-5.noarch.rpm
    sudo rpm -Uvh puppet5-release-el-5.noarch.rpm

> **Note:** For recent versions of Puppet, we no longer ship Puppet master components for RHEL 5. However, we continue to ship new versions of the `puppet-agent` package for RHEL 5 agents.

#### Fedora 25

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-fedora-25.noarch.rpm

#### Fedora 24

    sudo rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-fedora-24.noarch.rpm

### Apt-based systems

To enable the Puppet 5 Platform repository:

1. Choose the package based on your operating system and version. The packages are located in the [`apt.puppet.com`](https://apt.puppet.com) repository and named using the convention `<PLATFORM_VERSION>-release-<VERSION CODE NAME>.deb`

   For instance, the release package for Puppet Platform on Debian 7 "Wheezy" is `puppet5-release-wheezy.deb`. For Ubuntu releases, the code name is the adjective, not the animal.

2. Download the release package and install it as root using the `dpkg` tool and the `install` flag (`-i`):

   ~~~
   wget https://apt.puppetlabs.com/puppet5-release-wheezy.deb
   sudo dpkg -i puppet5-release-wheezy.deb
   ~~~

3. Run `apt-get update` after installing the release package to update the `apt` package lists.

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


### Windows and macOS systems

While the [`puppet-agent` package](./about_agent.html) is the only component of the Puppet Platform available on macOS and Windows, you can still use Puppet Platform to ensure the version of `package-agent` you install is compatible with the rest of your infrastructure.

To download `puppet-agent` for Puppet 5 Platform on macOS:

* [macOS packages](https://downloads.puppetlabs.com/mac/puppet5/)

To download `puppet-agent` for Puppet 5 Platform on Windows:

* [Microsoft Windows packages](http://downloads.puppetlabs.com/windows/puppet5/)


## Verifying Puppet packages

We sign most of our packages, Ruby gems, and release tarballs with GNU Privacy Guard (GPG). This helps prove that the packages originate from Puppet and have not been compromised.

Security-conscious users can use GPG to verify signatures on our packages.

### Automatic verification

Certain operating system and installation methods automatically verify our package signatures.

* If you install Puppet packages via our Yum and Apt repositories, the Puppet Platform release package that enables the repository also installs our release signing key. The Yum and Apt tools automatically verify the integrity of our packages as you install them.
* Our Microsoft Installer (MSI) packages for Windows are signed with a different key, and the Windows installer automatically verifies the signature before installing the package.

In these cases, you don't need to do anything to verify the package signature.

### Manual verification

If you're using Puppet source tarballs or Ruby gems, or installing RPM packages without Yum, you can manually verify the signatures.

#### Importing the public key

Before you can verify signatures, you must import the Puppet public key and verify its fingerprint. This key is certified by several Puppet developers and should be available from the public keyservers.

1. To import the public key, run `gpg --keyserver pgp.mit.edu --recv-key 7F438280EF8D349F`

The `gpg` tool then requests and imports the key:

		gpg: requesting key EF8D349F from hkp server pgp.mit.edu
		gpg: /home/username/.gnupg/trustdb.gpg: trustdb created
		gpg: key EF8D349F: public key "Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>" imported
		gpg: no ultimately trusted keys found
		gpg: Total number processed: 1
		gpg:               imported: 1  (RSA: 1)

The key is also [available via HTTP](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x7F438280EF8D349F).

> **Note:** If this is your first time running the `gpg` tool, it might fail to import the key after creating its configuration file and keyring. This is normal, and you can run the command a second time to import the key into your newly created keyring.

#### Verify the fingerprint

The fingerprint of the Puppet release signing key is `6F6B 1550 9CF8 E59E 6E46  9F32 7F43 8280 EF8D 349F`.

1. To check the key's fingerprint, run `gpg --list-key --fingerprint 7F438280EF8D349F`

2. Ensure the fingerprint listed in the output matches the above value:

		pub   4096R/EF8D349F 2016-08-18 [expires: 2021-08-17]
					Key fingerprint = 6F6B 1550 9CF8 E59E 6E46  9F32 7F43 8280 EF8D 349F
		uid                  Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>
		sub   4096R/656674AE 2016-08-18 [expires: 2021-08-17]

#### Verify a source tarball or gem

To verify a source tarball or Ruby gem, you must download both it and its corresponding `.asc` file. These files are available from <https://downloads.puppetlabs.com/puppet/>.

Next, verify the tarball or gem, replacing `<VERSION>` with the Puppet version number, and `<FILE TYPE>` with `tar.gz` for a tarball or `gem` for a Ruby gem:

    gpg --verify puppet-<VERSION>.<FILE TYPE>.asc puppet-<VERSION>.<FILE TYPE>

The output should confirm that the signature matches:

    gpg: Signature made Mon 19 Sep 2016 04:58:29 PM UTC using RSA key ID EF8D349F
    gpg: Good signature from "Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>"

If you have not taken the necessary steps to build a [trust path](https://www.gnupg.org/gph/en/manual/x334.html), through the web of trust, to one of the signatures on the release key, `gpg` produces a warning similar to the following when you verify the signature:

    Could not find a valid trust path to the key.
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: 6F6B 1550 9CF8 E59E 6E46  9F32 7F43 8280 EF8D 349F

This is normal if you do not have a trust path to the key. If you've verified the fingerprint of the key, GPG has verified the archive's integrity; the warning only means that GPG can't automatically prove the key's ownership.

#### Verify an RPM package

Puppet RPM packages include an embedded signature. To verify it, you must import the Puppet public key to `rpm`, then use `rpm` to check the signature.

1. Retrieve the [Puppet public key](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x1054B7A24BD6EC30) and place it in a file on your node.

2. Run `sudo rpm --import PUBKEY <PUBLIC KEY FILE>` replacing `<PUBLIC KEY FILE>` with the path to the file containing the Puppet public key.

   The `rpm` tool won't output anything if successful.

3. To verify an RPM you've downloaded, run the `rpm` tool with the `checksig` flag (`-K`): `sudo rpm -vK <RPM FILE NAME>`

   This verifies the embedded signature, as signified by the `OK` results in the `rpm` output:
   
   ~~~
    puppet-agent-1.5.1-1.el6.x86_64.rpm:
        Header V4 RSA/SHA512 Signature, key ID ef8d349f: OK
        Header SHA1 digest: OK (95b492a1fff452d029aaeb59598f1c78dbfee0c5)
        V4 RSA/SHA512 Signature, key ID ef8d349f: OK
        MD5 digest: OK (4878909ccdd0af24fa9909790dd63a12)
   ~~~


If you don't import the Puppet public key, you can still verify the package's integrity using `rpm -vK`. However, you won't be able to validate the package's origin:

    puppet-agent-1.5.1-1.el6.x86_64.rpm:
        Header V4 RSA/SHA512 Signature, key ID ef8d349f: NOKEY
        Header SHA1 digest: OK (95b492a1fff452d029aaeb59598f1c78dbfee0c5)
        V4 RSA/SHA512 Signature, key ID ef8d349f: NOKEY
        MD5 digest: OK (4878909ccdd0af24fa9909790dd63a12)

#### Verify an OS X `puppet-agent` package

Puppet signs `puppet-agent` packages for OS X with a developer ID and certificate. To verify the signature, download and mount the `puppet-agent` disk image, then use the `pkgutil` tool with the `--check-signature` flag:

    pkgutil --check-signature /Volumes/puppet-agent-<AGENT-VERSION>-1.osx10.10/puppet-agent-<AGENT-VERSION>-1-installer.pkg

The tool confirms the signature and outputs fingerprints for each certificate in the chain:

    Package "puppet-agent-<AGENT-VERSION>-1-installer.pkg":
       Status: signed by a certificate trusted by Mac OS X
       Certificate Chain:
        1. Developer ID Installer: PUPPET LABS, INC. (VKGLGN2B6Y)
           SHA1 fingerprint: AF 91 BF B7 7E CF 87 9F A8 0A 06 C3 03 5A B4 C7 11 34 0A 6F
           -----------------------------------------------------------------------------
        2. Developer ID Certification Authority
           SHA1 fingerprint: 3B 16 6C 3B 7D C4 B7 51 C9 FE 2A FA B9 13 56 41 E3 88 E1 86
           -----------------------------------------------------------------------------
        3. Apple Root CA
           SHA1 fingerprint: 61 1E 5B 66 2C 59 3A 08 FF 58 D1 4A E2 24 52 D1 98 DF 6C 60


You can also confirm the certificate when installing the package by clicking the lock icon in the top-right corner of the installer:

![Locate and click the lock icon in the OS X package installer window's top-right corner.](./images/os-x-signature-gui-1.png)

This displays details about the `puppet-agent` package's certificate:

![Details about the puppet-agent package's certificate displayed by the OS X package installer.](./images/os-x-signature-gui-2.png)
