---
layout: default
title: "About Puppet Collections and Packages"
canonical: "/puppet/latest/reference/puppet_collections.html"
---

{% include puppet-collections/_puppet_collections_intro.md %}

## Puppet Collection contents

Puppet Collection 1 contains the following components:

{% include puppet-collections/_puppet_collection_1_contents.md %}

## Using Puppet Collections

{% include puppet-collections/_puppet_collections_using.md %}

### Yum-based systems

{% include puppet-collections/_puppet_collection_1_yum.md %}

{% include puppet-collections/_puppet_collection_1_el7.md %}

{% include puppet-collections/_puppet_collection_1_el6.md %}

{% include puppet-collections/_puppet_collection_1_el5.md %}

{% include puppet-collections/_puppet_collection_1_f22.md %}

{% include puppet-collections/_puppet_collection_1_f21.md %}

### Apt-based systems

{% include puppet-collections/_puppet_collection_1_apt.md %}

{% include puppet-collections/_puppet_collection_1_u1504.md %}

{% include puppet-collections/_puppet_collection_1_u1404.md %}

{% include puppet-collections/_puppet_collection_1_u1204.md %}

{% include puppet-collections/_puppet_collection_1_d8.md %}

{% include puppet-collections/_puppet_collection_1_d7.md %}

{% include puppet-collections/_puppet_collection_1_d6.md %}

### OS X systems

{% include puppet-collections/_puppet_collection_1_osx.md %}

{% include puppet-collections/_puppet_collection_1_osx1011.md %}

{% include puppet-collections/_puppet_collection_1_osx1010.md %}

{% include puppet-collections/_puppet_collection_1_osx1009.md %}

## Verifying Puppet packages

At Puppet Labs, we sign most of our packages, Ruby gems, and release tarballs with GNU Privacy Guard (GPG). This helps prove that the packages originate from Puppet Labs and have not been compromised.

Security-conscious users can use GPG to verify signatures on our packages.

### Automatic Verification

Certain operating system and installation methods automatically verify our package signatures.

* If you install Puppet Labs packages via our Yum and Apt repositories, the Puppet Collection release package that enables the repository also installs our release signing key. The Yum and Apt tools automatically verify the integrity of our packages as you install them.
* Our Microsoft Installer (MSI) packages for Windows are signed with a different key, and the Windows installer automatically verifies the signature before installing the package.

In these cases, you don't need to do anything to verify the package signature.

### Manual Verification

If you're using Puppet source tarballs or installing packages without Apt or Yum, you can manually verify the signatures.

#### Import the release signing key

Before you can verify signatures, you must import the Puppet Labs public key and verify its fingerprint. This key is certified by several Puppet developers and should be available from the public keyservers.

To import the release signing key, run:

    gpg --recv-key 1054b7a24bd6ec30

The `gpg` tool then requests and imports the key:

    gpg: requesting key 4BD6EC30 from hkp server keys.gnupg.net
    gpg: /home/username/.gnupg/trustdb.gpg: trustdb created
    gpg: key 4BD6EC30: public key "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>" imported
    gpg: no ultimately trusted keys found
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)

The key is also [available via HTTP](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x1054B7A24BD6EC30).

> **Note:** If this is your first time running the `gpg` tool, it might fail to import the key after creating its configuration file and keyring. This is normal, and you can run the command a second time to import the key into your newly created keyring.

#### Verify the fingerprint

The fingerprint of the Puppet Labs release signing key is **`47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30`**. Run the following:

    gpg --list-key --fingerprint 1054b7a24bd6ec30

Then, ensure the fingerprint listed in the output matches the above value:

    pub   4096R/4BD6EC30 2010-07-10 [expires: 2016-07-08]
          Key fingerprint = 47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30
    uid                  Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>

#### Verify a source tarball or gem

To verify a source tarball or Ruby gem, you must download both it and its corresponding `.asc` file. These files are available from <https://downloads.puppetlabs.com/puppet/>.

Next, verify the tarball or gem by running the following, replacing `<VERSION>` with the Puppet version number, and `<FILE TYPE>` with `tar.gz` for a tarball or `gem` for a Ruby gem:

    gpg --verify puppet-<VERSION>.<FILE TYPE>.asc puppet-<VERSION>.<FILE TYPE>

The output should confirm that the signature matches:

    gpg: Signature made Mon Nov 30 10:47:39 2015 PST using RSA key ID 4BD6EC30
    gpg: Good signature from "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>"

If you have not taken the necessary steps to build a [trust path](https://www.gnupg.org/gph/en/manual/x334.html), through the web of trust, to one of the signatures on the release key, `gpg` produces a warning similar to the following when you verify the signature:

    Could not find a valid trust path to the key.
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: 47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30

This is normal if you do not have a trust path to the key. If you've verified the fingerprint of the key as described above, GPG has verified the archive's integrity; the warning only means that GPG can't automatically prove the key's ownership.

#### Verify an RPM package

Puppet RPM packages include an embedded signature. To verify it, you must import the Puppet Labs public key to `rpm`, then use `rpm` to check the signature.

First, retrieve the [Puppet Labs public key](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x1054B7A24BD6EC30) and place it in a file on your node.

Next, run the following, replacing `<PUBLIC KEY FILE>` with the path to the file containing the Puppet Labs public key:

    sudo rpm --import PUBKEY <PUBLIC KEY FILE>

The `rpm` tool won't output anything if successful.

Then to verify an RPM you've downloaded, run the `rpm` tool with the `checksig` flag (`-K`):

    sudo rpm -vK <RPM FILE NAME>

This verifies the embedded signature, as signified by the `OK` results in the `rpm` output:

~~~
puppetlabs-release-pc1-fedora-22.noarch.rpm:
    Header V4 RSA/SHA1 Signature, key ID 4bd6ec30: OK
    Header SHA1 digest: OK (403bb336706e52f1eca63424a55b7f123e644b2b)
    V4 RSA/SHA1 Signature, key ID 4bd6ec30: OK
    MD5 digest: OK (97a9c407a8a7ee9f8689c79bab97250e)
~~~

If you don't import the Puppet Labs public key, you can still verify the package's integrity using `rpm -vK`. However, you won't be able to validate the package's origin:

~~~
puppetlabs-release-pc1-fedora-22.noarch.rpm:
    Header V4 RSA/SHA1 Signature, key ID 4bd6ec30: NOKEY
    Header SHA1 digest: OK (403bb336706e52f1eca63424a55b7f123e644b2b)
    V4 RSA/SHA1 Signature, key ID 4bd6ec30: NOKEY
    MD5 digest: OK (97a9c407a8a7ee9f8689c79bab97250e)
~~~