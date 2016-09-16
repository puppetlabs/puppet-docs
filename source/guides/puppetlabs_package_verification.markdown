---
title: "Verifying Signatures for Puppet Labs Packages"
layout: default
nav: /_includes/puppet_general.html
---



At Puppet Labs, we sign most of our packages and release tarballs with GPG. This helps prove that the packages really originate from Puppet Labs and have not been tampered with.

Security conscious users can use GPG to verify signatures on our packages.

## Automatic Verification

You may already be automatically verifying our package signatures.

* If you install Puppet Labs' packages via [our Yum and Apt repositories][repos], you get automatic verification. The release package that [enables the repository][repos] will also install our release signing key, and the Yum and Apt tools will automatically verify the integrity of our packages when you install them.
* Our MSI packages for Windows are signed with a different key, and the Windows MSI installer will automatically verify the signature for you. If it successfully installs, the signature was verified.

In these cases, you don't need to do any extra work.

[repos]: ./puppetlabs_package_repositories.html

## Unsigned Packages

At this time, we do not sign our [OS X packages](http://downloads.puppetlabs.com/mac/) or our RubyGems.

## Manual Verification

If you are using Puppet Labs' source tarballs, or are installing our RPM packages without Yum, you may need to manually verify the signatures.

### Import the Release Signing Key

Before you can verify signatures, you must import the Puppet Labs public key and verify its fingerprint. This key is certified by several of the Puppet developers, and should be available from the public keyservers.

To import the release signing key, run:

    $ gpg --recv-key 7F438280EF8D349F
    gpg: requesting key EF8D349F from hkp server pool.sks-keyservers.net
    gpg: key EF8D349F: public key "Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>" imported
    gpg: no ultimately trusted keys found
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)

The key is also [available here](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0x7F438280EF8D349F).

### Verify the Fingerprint

The fingerprint of the Puppet Labs release signing key is **`47B3 20EB 4C7C 375A A9DA  E1A0 1054 B7A2 4BD6 EC30`**. Run the following and ensure the fingerprints match:

    $ gpg --list-key --fingerprint 7F438280EF8D349F
      pub   4096R/EF8D349F 2016-08-18 [expires: 2021-08-17]
            Key fingerprint = 6F6B 1550 9CF8 E59E 6E46  9F32 7F43 8280 EF8D 349F
      uid                  Puppet, Inc. Release Key (Puppet, Inc. Release Key) <release@puppet.com>
      sub   4096R/656674AE 2016-08-18 [expires: 2021-08-17]

### Verify a Source Tarball

To verify a source tarball, you must download both the tarball itself and the corresponding `.asc` file. Then, run:

    $ gpg --verify puppet-3.2.2.tar.gz.asc puppet-3.2.2.tar.gz
      gpg: Signature made Tue 18 Jun 2013 10:05:25 AM PDT using RSA key ID EF8D349F
      gpg: Good signature from "Puppet, Inc. Release Key (Puppet, Inc. Release Key) "

If you have not taken the necessary steps to build a trust path, through the web of trust, to one of the signatures on the release key, you will see a warning similar to the following when you verify the signature:

    Could not find a valid trust path to the key.
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.

This is normal if you do not have a trust path to the key. If you've verified the fingerprint of the key as described above, the archive integrity is still verified; the warning only means that GPG can't automatically prove the ownership of the key itself.

### Verify an RPM

To verify an RPM, run `rpm -vK <PACKAGE>`. This will verify the signature embedded in the package.
