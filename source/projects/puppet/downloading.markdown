Downloading Puppet
==================

* The stable version is `{STABLEVERSION}`
* The latest development version is `{DEVVERSION}`

* * *

Version Information
-------------------

There are [release notes](http://reductivelabs.com/trac/puppet/wiki/ReleaseNotes) that
detail the major feature and language changes between versions. We
recommend you read this if upgrading Puppet from an earlier
version.

There is also a
[list of planned and released versions with their numbers](http://reductivelabs.com/trac/puppet/wiki/Development/CodeNames).

Tarball
-------

### Puppet

Stable
: [Puppet 0.25.1 (tar+gzip)](http://reductivelabs.com/downloads/puppet/puppet-0.25.1.tar.gz)
  Package signature -- 1356 kb

Latest
: [Puppet 0.25.1 (tar+gzip)](http://reductivelabs.com/downloads/puppet/puppet-0.25.1.tar.gz)
  Package signature -- 1356 kb

### Facter

Stable
: [Facter 1.5.7 (tar+gzip)](http://reductivelabs.com/downloads/facter/facter-1.5.7.tar.gz)
  Package signature -- 78 kb

Latest
: [Facter 1.5.7 (tar+gzip)](http://reductivelabs.com/downloads/facter/facter-1.5.7.tar.gz)
  Package signature -- 78 kb

RubyGems
--------

### Puppet

Stable
: [Puppet 0.25.1 (Ruby Gem)](http://reductivelabs.com/downloads/gems/puppet-0.25.1.gem)
  Package signature -- 1356 kb

Latest
: [Puppet 0.25.1 (Ruby Gem)](http://reductivelabs.com/downloads/gems/puppet-0.25.1.gem)
  Package signature -- 1356 kb

### Facter

Stable
: [Facter 1.5.7 (Ruby Gem)](http://reductivelabs.com/downloads/gems/facter-1.5.7.gem)
  Package signature -- 75 kb

: Latest
  [Facter 1.5.7 (Ruby Gem)](http://reductivelabs.com/downloads/gems/facter-1.5.7.gem)
  Package signature -- 75 kb

System Packages
---------------

### Apple Mac OS X Packages

Apple Mac OS X packages are hosted at
[explanatorygap.net](https://sites.google.com/a/explanatorygap.net/puppet/),
as are instructions for building pkgs from the source repository.
Please contact Nigel Kersten there for issues with Puppet/Facter
packages on Mac OS X.

Alternatively, OS X packages are available through
[MacPorts](http://www.macports.org/).

### ArchLinux Packages

ArchLinux now contains packages for Puppet and Facter. You can find
[ArchLinux Puppet](http://aur.archlinux.org/packages.php?ID=15496)
and
[ArchLinux Facter](http://aur.archlinux.org/packages.php?ID=15495)
packages in the ArchLinux AUR.

### Debian Packages

[Debian](http://www.debian.org/) packages are available from the
[Debian Packages](http://packages.debian.org/src:puppet) site.

### FreeBSD Packages

Puppet is included in [FreeBSD](http://www.freebsd.org/)'s ports
tree, and packages are available in the appropriate
[FreeBSD ports collection](http://www.freebsd.org/cgi/cvsweb.cgi/ports/sysutils/puppet/).

### Gentoo Packages

Thanks to José González Gómez, Puppet is now officially in
[Portage](http://packages.gentoo.org/package/app-admin/puppet).

### Mandriva Packages

[Mandriva](http://www.mandriva.com/) packages are available from
the Mandriva contrib repository.

### NetBSD Packages

Puppet is included in [NetBSD](http://www.netbsd.org/)'s ports
tree, and packages are available in the appropriate
[NetBSD ports collection](http://cvsweb.netbsd.org/bsdweb.cgi/pkgsrc/sysutils/puppet/).

### OpenBSD Packages

Puppet is included in [OpenBSD](http://www.openbsd.org/)'s ports
tree, and packages are available in the appropriate packages
directory on OpenBSD [mirrors](http://www.openbsd.org/ftp.html).
Some unofficial (but more recent) packages are provided as is for a
limited set of OpenBSD releases and architectures on
[openbsd.glei.ch](http://openbsd.glei.ch).

### RPM Packages

Puppet is available in [RPM](http://www.rpm.org) form as part of
[Fedora](http://fedoraproject.org/get-fedora) and
[EPEL](http://fedoraproject.org/wiki/EPEL). A simple yum install
puppet or yum install puppet-server on such systems should be all
you need. [EPEL](http://fedoraproject.org/wiki/EPEL) users should
be aware that EPEL only moves packages from testing to stable
repositories very infrequently - if you are on RHEL or CentOS, you
might have to enable the epel-testing repository to get the very
latest version of puppet.

### SuSE Packages

Martin Vuk has set up the SuSE build service to create Puppet and
Facter
[SuSE packages](http://software.opensuse.org/download/system:management/).
Older versions of Puppet can still be retrieved from
[Martin's old yum repository](http://lmmri.fri.uni-lj.si/suse/).

### Solaris & OpenSolaris

There are [OpenSolaris](http://opensolaris.org/) pkgs from Code
Nursery, plus SysV packages for regular
[Solaris](http://www.sun.com/software/solaris) from
[Blastwave](http://www.blastwave.org/) and
[OpenCSW](http://www.opencsw.org/). More details on our
[Solaris & OpenSolaris](http://reductivelabs.comhttp://reductivelabs.com/trac/puppet/wiki/PuppetSolaris)
page.

### Ubuntu Packages

[Ubuntu](http://www.ubuntu.org/) packages are available from the
[Ubuntu Packages](http://packages.ubuntu.com/search?suite=all&searchon=names&keywords=puppet)
site.

Installing From Source
----------------------

If you're interested in developing your own extensions for Puppet,
or you'd like to contribute to the project -- or even if you just
prefer to build straight from the tree -- we've got a
[public Git repository](git://github.com/reductivelabs/puppet) for
the project. Use git clone git://github.com/reductivelabs/puppet to
check out the code, then run sudo ./install.rb from within the
resulting repository. If you don't have git installed, you can
browse to a
[online Git repository](http://github.com/reductivelabs/puppet/)
instead.

You can also find some instructions for running
[Puppet from source](/guides/from_source.html).

Exploring the Attic
-------------------

If you're looking for older versions of Puppet and Facter, or just want
to nose around, there's various arcane stuff in the
[downloads directory](http://reductivelabs.com/downloads/).

Verifying Puppet Downloads
--------------------------

The releases for Puppet are OpenPGP-signed, which provides
authentication that the released tarball has not been tampered with
and really originated from the Puppet developers. This signature
does not ensure that the Reductive Labs servers themselves have not
been compromised, however if there is an intrusion, then we will
revoke the key and publish that revocation certificate as quickly
as possible.

### Import the release signing key

To have a cryptographic verification of the release, you will want
to import the Reductive Labs public key after verifying its
integrity. This key is certified by several of the puppet
developers, and should be available from the public keyservers. You
can import it by doing the following:

    $ gpg --recv-key 8347A27F
    gpg: requesting key 8347A27F from hkp server pool.sks-keyservers.net
    gpg: key 8347A27F: public key "Reductive Labs Release Key <info@reductivelabs.com>" imported
    gpg: no ultimately trusted keys found
    gpg: Total number processed: 1
    gpg:               imported: 1  (RSA: 1)
{:shell}

### Verifying the fingerprint

You should be able to verify the fingerprint like this:

    $ gpg --list-key --fingerprint 8347A27F
    pub   4096R/8347A27F 2008-09-02 [expires: 2009-09-02]
    Key fingerprint = 9C6C 5452 4691 2EE7 00FB  5682 FFAC 8658 8347 A27F
    uid       [  full  ] Reductive Labs Release Key <info@reductivelabs.com>
{:shell}

You can also verify the fingerprints by doing this:

    $ gpg --list-sigs 8347A27F
{:shell}

### Verifying the puppet releases

Once you have properly verified this key, you can now use it to
cryptographically verify the package integrity by doing the
following:

Using GnuPG, verifying the release signature on a puppet tarball
would look something like this:

    $ gpg --verify puppet-0.25.2.tar.gz.sign puppet-0.25.2.tar.gz
    gpg: Signature made Mon Oct  9 23:48:38 2000 PDT using DSA key ID 8347A27F
    gpg: Good signature from "Reductive Labs Release Key <info@reductivelabs.com>"
{:shell}

If you have not taken the necessary steps to build a trust path,
through the web of trust, to one of the signatures on the release
key, you will see a warning similar to the following when you
verify the signature:

    Could not find a valid trust path to the key.
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
{:shell}

This is normal if you do not have a trust path to the key, do not
be alarmed if you see this, the archive integrity is still
verified, you just have no trust path to certify that the people
signing the release key are who they say they are.

The current Reductive Labs Release OpenPGP key is:

[http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0xFFAC86588347A27F](http://pool.sks-keyservers.net:11371/pks/lookup?op=get&search=0xFFAC86588347A27F)

This is the key:

    -----BEGIN PGP PUBLIC KEY BLOCK-----
    Version: GnuPG v1.4.9 (GNU/Linux)
    
    mQINBEr+DxIBEADFFFotx3lUGwOTvUu2jrJjD4DNBGKHBAkxyC9vf8UhWBIWN0Pm
    yU/6Ior7qbYBNdorEdMHswvq3wdoioBeR3c0LJMlYLzRb7LG+2c1sRE2VC1QLbGe
    DJuFMGscDIbF2GAb61lxk4S5qhKvL8ttqUwcQ/ZyUDaraaTHF9bJgdsIZ3Kt9dDO
    SNunfmMM5yw/Nt5D6/guotJJRO24v3fb9mioA9kKhE1WOqDPK0OfVcK+k4cZ2TPJ
    i8NngZQRd5P/KxMH043BC/GnetSpC2zWQ29AuWXvkFVIoRorme2trNVIajU4cr7G
    THwbAb4IdFoxkAD3NC+oB/jz25zgaRxbA19QunYC69CPTkTGl2st3+4TjM4xMcYH
    dr9oK7pq19d4SiXNU/qLPlCuK6z2QtcryiiXgi1ki/IkpO8b2Q3Cwc0oUW6Q8G2X
    CaVkouM5/qJliNx9IA7WbK+4V3imcmJ+pbujQhKjxnuxd0Zt6vRUWZ7z9/2ybgyC
    GM0pCZZ46bA3dddx84/9u8qI8Uv5Dg46fKppF2v1Ctv7ot0lJIhYMioTXG6deFDT
    VqvSJ3fH6apkpDrweoc3ixI1sZ2eSmTLZKnIv2uWB2p7HJZj8aPvUPgRWqfIM/J/
    APIckFrLZ7BfIcfGs/Eq1iPzDBGfLWGEhbx8ZzEJ4k3q8ykjHpJ4sxz0LQARAQAB
    tDNSZWR1Y3RpdmUgTGFicyBSZWxlYXNlIEtleSA8aW5mb0ByZWR1Y3RpdmVsYWJz
    LmNvbT6JAjwEEwECACYFAkr+DxICGwMFCQPCZwAGCwkIBwMCBBUCCAMEFgIDAQIe
    AQIXgAAKCRD/rIZYg0eif4upD/4kQPPFz44FUfawhNVcOsp2tFLX3fN6GVrdqGt4
    x2gRv92DOI/8rLvfTBA4JRT7sKgFDfAZ7FPISNZf/7Swo9PbUc4UU0T/FP+bsj5w
    tC+g2FuKfNSJqoQvG3XU6iRGmQpLkxpnzioJTJy682Fp7jUZPiZKxRqq467fG3cd
    vrkNMT8SKt5gEnweVwn9wOOAEu36M7KNRM24tky40m4xdZHyXgk5QeZ22K0TVX3U
    fIXIiNRvnkcdneHZabOase+g6jjaJuQ6JKTSC3Mf30HNWP5C26azDaCSME0GVr4a
    O3MbzzKvVt7sbv+TVDGmsGFxT6lTuLOkOMoPudFDKKnmMXGxOtBUwSYDbHK+81/E
    v/7dSX3bx4mHZAQt7S6cVg3PVIQeKs6vQwpPE3c58cymnL39zpviGILhCJKxWdBY
    Kugv+DoDi1aYiPXhS3EgMssTS6mwpEfsD2C9zD9cUjICmIgP/nqYJqYigd0lwpfD
    HjkHyGAC4hxFp5M+zNR/ByUQBaLdcu1sfHrpzBLnGh4kCqKN3K7If+Cq1yj76qrp
    Q9/8QINkLTESQ5AGQWbuQ54YFG3+KWQTpFAHSlwlLnmrH5nKHWllq1fdW3vzIjFp
    TpZGT+lTTzzk1BmVsTvI03AG7MOV0g7FQ95t0SZkDkQBMWcxiD48I262jxV8NQCR
    5WceRw==
    =3YhS
    -----END PGP PUBLIC KEY BLOCK-----
