---
layout: default
title: "About Puppet Collections and packages"
canonical: "/puppet/latest/reference/puppet_collections.html"
---

{% include puppet-collections/_puppet_collections_intro.md %}

## Puppet collection contents

Puppet Collection 1 contains the following components:

{% include puppet-collections/_puppet_collection_1_contents.md %}

## Using Puppet collections

{% include puppet-collections/_puppet_collections_using.md %}

### Yum-based systems

{% include puppet-collections/_puppet_collection_1_yum.md %}

{% include puppet-collections/_puppet_collection_1_el7.md %}

{% include puppet-collections/_puppet_collection_1_el6.md %}

{% include puppet-collections/_puppet_collection_1_el5.md %}

{% include puppet-collections/_puppet_collection_1_f23.md %}

{% include puppet-collections/_puppet_collection_1_f22.md %}

### Apt-based systems

{% include puppet-collections/_puppet_collection_1_apt.md %}

{% include puppet-collections/_puppet_collection_1_u1604.md %}

{% include puppet-collections/_puppet_collection_1_u1510.md %}

{% include puppet-collections/_puppet_collection_1_u1404.md %}

{% include puppet-collections/_puppet_collection_1_u1204.md %}

{% include puppet-collections/_puppet_collection_1_d8.md %}

{% include puppet-collections/_puppet_collection_1_d7.md %}

### OS X systems

{% include puppet-collections/_puppet_collection_1_osx.md %}

{% include puppet-collections/_puppet_collection_1_osx1011.md %}

{% include puppet-collections/_puppet_collection_1_osx1010.md %}

{% include puppet-collections/_puppet_collection_1_osx1009.md %}

## Verifying Puppet packages

We sign most of our packages, Ruby gems, and release tarballs with GNU Privacy Guard (GPG). This helps prove that the packages originate from Puppet and have not been compromised.

Security-conscious users can use GPG to verify signatures on our packages.

### Automatic verification

Certain operating system and installation methods automatically verify our package signatures.

-   If you install Puppet packages via our Yum and Apt repositories, the Puppet Collection release package that enables the repository also installs our release signing key. The Yum and Apt tools automatically verify the integrity of our packages as you install them.
-   Our Microsoft Installer (MSI) packages for Windows are signed with a different key, and the Windows installer automatically verifies the signature before installing the package.

In these cases, you don't need to do anything to verify the package signature.

### Manual verification

If you're using Puppet source tarballs or Ruby gems, or installing RPM packages without Yum, you can manually verify the signatures.

#### Import the release signing key

Before you can verify signatures, you must import the Puppet public key and verify its fingerprint. This key is certified by several Puppet developers and should be available from the public keyservers.

To import the release signing key, run:

{% include puppet-collections/_rsk_import_command.md %}

The `gpg` tool then requests and imports the key:

{% include puppet-collections/_rsk_import_key.md %}

The key is also [available via HTTP](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x1054B7A24BD6EC30).

> **Note:** If this is your first time running the `gpg` tool, it might fail to import the key after creating its configuration file and keyring. This is normal, and you can run the command a second time to import the key into your newly created keyring.

#### Verify the fingerprint

The fingerprint of the Puppet release signing key is:

{% include puppet-collections/_rsk_fingerprint.md %}

To check the key's fingerprint, run the following:

{% include puppet-collections/_rsk_fingerprint_command.md %}

Then, ensure the fingerprint listed in the output matches the above value:

{% include puppet-collections/_rsk_fingerprint_command_output.md %}

#### Verify a source tarball or gem

To verify a source tarball or Ruby gem, you must download both it and its corresponding `.asc` file. These files are available from <https://downloads.puppetlabs.com/puppet/>.

Next, verify the tarball or gem by running the following, replacing `<VERSION>` with the Puppet version number, and `<FILE TYPE>` with `tar.gz` for a tarball or `gem` for a Ruby gem:

    gpg --verify puppet-<VERSION>.<FILE TYPE>.asc puppet-<VERSION>.<FILE TYPE>

The output should confirm that the signature matches:

{% include puppet-collection/_rsk_gpg_command_output.md %}

If you have not taken the necessary steps to build a [trust path](https://www.gnupg.org/gph/en/manual/x334.html), through the web of trust, to one of the signatures on the release key, `gpg` produces a warning similar to the following when you verify the signature:

{% include puppet-collection/_rsk_gpg_command_warning.md %}

This is normal if you do not have a trust path to the key. If you've verified the fingerprint of the key as described above, GPG has verified the archive's integrity; the warning only means that GPG can't automatically prove the key's ownership.

#### Verify an RPM package

Puppet RPM packages include an embedded signature. To verify it, you must import the Puppet public key to `rpm`, then use `rpm` to check the signature.

First, retrieve the [Puppet public key](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x1054B7A24BD6EC30) and place it in a file on your node.

Next, run the following, replacing `<PUBLIC KEY FILE>` with the path to the file containing the Puppet public key:

    sudo rpm --import PUBKEY <PUBLIC KEY FILE>

The `rpm` tool won't output anything if successful.

Then to verify an RPM you've downloaded, run the `rpm` tool with the `checksig` flag (`-K`):

    sudo rpm -vK <RPM FILE NAME>

This verifies the embedded signature, as signified by the `OK` results in the `rpm` output:

{% include puppet-collections/_rpm_command_output.md %}

If you don't import the Puppet public key, you can still verify the package's integrity using `rpm -vK`. However, you won't be able to validate the package's origin:

{% include puppet-collections/_rpm_command_output_without_import.md %}

#### Verify an OS X `puppet-agent` package

Puppet signs `puppet-agent` packages for OS X with a developer ID and certificate. To verify the signature, download and mount the `puppet-agent` disk image, then use the `pkgutil` tool with the `--check-signature` flag:

    pkgutil --check-signature /Volumes/puppet-agent-<AGENT-VERSION>-1.osx10.10/puppet-agent-<AGENT-VERSION>-1-installer.pkg

The tool confirms the signature and outputs fingerprints for each certificate in the chain:

{% include puppet-collections/_pkgutil_command_output.md %}

You can also confirm the certificate when installing the package by clicking the lock icon in the top-right corner of the installer:

![Locate and click the lock icon in the OS X package installer window's top-right corner.](./images/os-x-signature-gui-1.png)

This displays details about the `puppet-agent` package's certificate:

![Details about the puppet-agent package's certificate displayed by the OS X package installer.](./images/os-x-signature-gui-2.png)

## Nightly repositories
<!-- We should keep information about nightly repos on the /latest/ version of Puppet only. It's not relevant for older versions.-->

We provide automatically built [nightly repositories](https://nightlies.puppetlabs.com/) for *nix operating systems containing packages of **pre-release software not intended for production use**. The nightly repositories require that you also have the standard Puppet Collection repository enabled.

### Nightly?

Our automated systems create new "nightly" repositories for builds that pass our acceptance testing on the most popular platforms. This means we might not technically release builds nightly. However, they still represent bleeding-edge Puppet builds **that are not intended for production use.**

### Nightly repository contents

Each nightly repo contains a single product. We make nightly repositories for Puppet Server, Puppet Agent (including its related tools), and PuppetDB.

### Latest vs. specific commit

There are two kinds of nightly repository for each product:

-   The "-latest" repository stays around forever and always contains the latest build. We publish new packages to this repository every day or two, and are good for persistent canary systems.

-   The other repositories are all named after a specific git commit. They contain a single build, so you can reliably install the same version on many systems. These repositories are useful when testing a specific build, such to help Puppet test an impending release announced on the [puppet-users mailing list](https://groups.google.com/forum/#!forum/puppet-users).

    We delete single-commit repositories a week or two after we create them, so if you want to keep the packages available, import them into your local repository.

### Enabling nightly repositories on Yum-based systems

1.  Enable the main Puppet Collection repository, as described [above](#yum-based-systems).

2.  In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.

3.  Click through to your repository's `repo_configs/rpm` directory, and identify the `.repo` file that applies to your operating system. This looks like `pl-puppet-agent-<COMMIT>-el-7-x86_64.repo`.

4.  Download the `.repo` file into the system's `/etc/yum.repos.d/` directory. For example, to install the RHEL 7 puppet-agent nightly repository for commit 732e883, run:

    ``` bash
    cd /etc/yum.repos.d
    sudo wget https://nightlies.puppetlabs.com/puppet-agent/732e883733fe5e5989afe330e3c5cea00b678d1e/repo_configs/rpm/pl-puppet-agent-732e883733fe5e5989afe330e3c5cea00b678d1e-el-7-x86_64.repo
    ```

5.  Upgrade or install the product.

### Enabling nightly repositories on Apt-based systems

1.  Enable the main Puppet Collection repository, as described [above](#apt-based-systems).

2.  In a web browser, go to <https://nightlies.puppetlabs.com/>. Choose the repository you want; this will be either `<PRODUCT>-latest`, or `<PRODUCT>/<COMMIT>`.

3.  Click through to your repository's `repo_configs/deb` directory, and identify the `.list` file that applies to your operating system. This looks like `pl-puppet-agent-<COMMIT>-xenial.list`.

4.  Download the `.list` file into the system's `/etc/apt/sources.list.d/` directory. For example, to install the Ubuntu 16.04 (Xenial) puppet-agent nightly repository for commit 732e883, run:

    ``` bash
    cd /etc/apt/sources.list.d
    sudo wget https://nightlies.puppetlabs.com/puppet-agent/732e883733fe5e5989afe330e3c5cea00b678d1e/repo_configs/deb/pl-puppet-agent-732e883733fe5e5989afe330e3c5cea00b678d1e-xenial.list
    ```

5. Run `sudo apt-get update`.

6. Upgrade or install the product.
