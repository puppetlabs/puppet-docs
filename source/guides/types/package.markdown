package
=======

* * *

Manage packages. There is a basic dichotomy in package support
right now: Some package types (e.g., yum and apt) can retrieve
their own package files, while others (e.g., rpm and sun) cannot.
For those package formats that cannot retrieve their own files, you
can use the `source` parameter to point to the correct file.

Puppet will automatically guess the packaging format that you are
using based on the platform you are on, but you can override it
using the `provider` parameter; each provider defines what it
requires in order to function, and you must meet those requirements
to use a given provider.

### Features

-   **installable**: The provider can install packages.
-   **purgeable**: The provider can purge packages. This generally
    means that all traces of the package are removed, including
    existing configuration files. This feature is thus destructive and
    should be used with the utmost care.
-   **uninstallable**: The provider can uninstall packages.
-   **upgradeable**: The provider can upgrade to the latest version
    of a package. This feature is used by specifying `latest` as the
    desired value for the package.
-   **versionable**: The provider is capable of interrogating the
    package database for installed version(s), and can select which out
    of a set of available versions of a package to install if asked.

=========== =========== ========= ============= ===========
=========== Provider installable purgeable uninstallable
upgradeable versionable =========== =========== =========
============= =========== =========== appdmg **X** apple **X** apt
**X** **X** **X** **X** **X** aptitude **X** **X** **X** **X**
**X** aptrpm **X** **X** **X** **X** **X** blastwave **X** **X**
**X** darwinport **X** **X** **X** dpkg **X** **X** **X** **X**
fink **X** **X** **X** **X** **X** freebsd **X** **X** gem **X**
**X** **X** **X** hpux **X** **X** openbsd **X** **X** pkgdmg **X**
portage **X** **X** **X** **X** ports **X** **X** **X** rpm **X**
**X** **X** **X** rug **X** **X** **X** **X** sun **X** **X** **X**
sunfreeware **X** **X** **X** up2date **X** **X** **X** urpmi **X**
**X** **X** **X** yum **X** **X** **X** **X** **X** ===========
=========== ========= ============= =========== ===========

### Parameters

#### adminfile

A file containing package defaults for installing packages. This is
currently only used on Solaris. The value will be validated
according to system rules, which in the case of Solaris means that
it should either be a fully qualified path or it should be in
/var/sadm/install/admin.

#### allowcdrom

Tells apt to allow cdrom sources in the sources.list file. Normally
apt will bail if you try this. Valid values are `true`, `false`.

#### category

A read-only parameter set by the package.

#### configfiles

Whether configfiles should be kept or replaced. Most packages types
do not support this parameter. Valid values are `keep`, `replace`.

#### description

A read-only parameter set by the package.

#### ensure

What state the package should be in. *latest* only makes sense for
those packaging formats that can retrieve new packages on their own
and will throw an error on those that cannot. For those packaging
systems that allow you to specify package versions, specify them
here. Similarly, *purged* is only useful for packaging systems that
support the notion of managing configuration files separately from
'normal' system files. Valid values are `present` (also called
`installed`), `absent`, `purged`, `latest`. Values can match
`/./`.

#### instance

A read-only parameter set by the package.

#### name

-   **namevar**

The package name. This is the name that the packaging system uses
internally, which is sometimes (especially on Solaris) a name that
is basically useless to humans. If you want to abstract package
installation, then you can use aliases to provide a common name to
packages:

    # In the 'openssl' class
    $ssl = $operatingsystem ? {
        solaris => SMCossl,
        default => openssl
    }
    
    # It is not an error to set an alias to the same value as the
    # object name.
    package { $ssl:
        ensure => installed,
        alias => openssl
    }
    
    . etc. .
    
    $ssh = $operatingsystem ? {
        solaris => SMCossh,
        default => openssh
    }
    
    # Use the alias to specify a dependency, rather than
    # having another selector to figure it out again.
    package { $ssh:
        ensure => installed,
        alias => openssh,
        require => Package[openssl]
    }

#### platform

A read-only parameter set by the package.

#### provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **appdmg**: Package management which copies application bundles
    to a target. Required binaries: `/usr/bin/hdiutil`,
    `/usr/bin/curl`, `/usr/bin/ditto`. Supported features:
    `installable`.
-   **apple**: Package management based on OS X's builtin packaging system. This is
    :   essentially the simplest and least functional package system in
        existence --it only supports installation; no deletion or upgrades.
        The provider will automatically add the `.pkg` extension, so leave
        that off when specifying the package name. Required binaries:
        `/usr/sbin/installer`. Supported features: `installable`.


-   **apt**: Package management via `apt-get`. Required binaries:
    `/usr/bin/apt-cache`, `/usr/bin/debconf-set-selections`,
    `/usr/bin/apt-get`. Default for `operatingsystem` ==
    `debianubuntu`. Supported features: `installable`, `purgeable`,
    `uninstallable`, `upgradeable`, `versionable`.
-   **aptitude**: Package management via `aptitude`. Required
    binaries: `/usr/bin/apt-cache`, `/usr/bin/aptitude`. Supported
    features: `installable`, `purgeable`, `uninstallable`,
    `upgradeable`, `versionable`.
-   **aptrpm**: Package management via `apt-get` ported to `rpm`.
    Required binaries: `apt-cache`, `rpm`, `apt-get`. Supported
    features: `installable`, `purgeable`, `uninstallable`,
    `upgradeable`, `versionable`.
-   **blastwave**: Package management using Blastwave.org's
    `pkg-get` command on Solaris. Required binaries: `pkg-get`.
    Supported features: `installable`, `uninstallable`, `upgradeable`.
-   **darwinport**: Package management using DarwinPorts on OS X.
    Required binaries: `/opt/local/bin/port`. Supported features:
    `installable`, `uninstallable`, `upgradeable`.
-   **dpkg**: Package management via `dpkg`. Because this only uses `dpkg`
    :   and not `apt`, you must specify the source of any packages you
        want to manage. Required binaries: `/usr/bin/dpkg-deb`,
        `/usr/bin/dpkg-query`, `/usr/bin/dpkg`. Supported features:
        `installable`, `purgeable`, `uninstallable`, `upgradeable`.


-   **fink**: Package management via `fink`. Required binaries:
    `/sw/bin/apt-cache`, `/sw/bin/fink`, `/sw/bin/dpkg-query`,
    `/sw/bin/apt-get`. Supported features: `installable`, `purgeable`,
    `uninstallable`, `upgradeable`, `versionable`.
-   **freebsd**: The specific form of package management on FreeBSD. This is an
    :   extremely quirky packaging system, in that it freely mixes
        between ports and packages. Apparently all of the tools are written
        in Ruby, so there are plans to rewrite this support to directly use
        those libraries. Required binaries: `/usr/sbin/pkg_info`,
        `/usr/sbin/pkg_add`, `/usr/sbin/pkg_delete`. Supported features:
        `installable`, `uninstallable`.


-   **gem**: Ruby Gem support. If a URL is passed via `source`, then that URL is used as the
    :   remote gem repository; if a source is present but is not a
        valid URL, it will be interpreted as the path to a local gem file.
        If source is not present at all, the gem will be installed from the
        default gem repositories. Required binaries: `gem`. Supported
        features: `installable`, `uninstallable`, `upgradeable`,
        `versionable`.


-   **hpux**: HP-UX's packaging system. Required binaries:
    `/usr/sbin/swremove`, `/usr/sbin/swinstall`, `/usr/sbin/swlist`.
    Default for `operatingsystem` == `hp-ux`. Supported features:
    `installable`, `uninstallable`.
-   **openbsd**: OpenBSD's form of `pkg_add` support. Required
    binaries: `pkg_info`, `pkg_add`, `pkg_delete`. Default for
    `operatingsystem` == `openbsd`. Supported features: `installable`,
    `uninstallable`.
-   **pkgdmg**: Package management based on Apple's Installer.app
    and DiskUtility.app. This package works by checking the contents of
    a DMG image for Apple pkg or mpkg files. Any number of pkg or mpkg
    files may exist in the root directory of the DMG file system. Sub
    directories are not checked for packages. See \`the wiki docs
    </trac/puppet/wiki/DmgPackages\>\` for more detail. Required
    binaries: `/usr/sbin/installer`, `/usr/bin/hdiutil`,
    `/usr/bin/curl`. Default for `operatingsystem` == `darwin`.
    Supported features: `installable`.
-   **portage**: Provides packaging support for Gentoo's portage
    system. Required binaries: `/usr/bin/update-eix`,
    `/usr/bin/emerge`, `/usr/bin/eix`. Default for `operatingsystem` ==
    `gentoo`. Supported features: `installable`, `uninstallable`,
    `upgradeable`, `versionable`.
-   **ports**: Support for FreeBSD's ports. Again, this still mixes
    packages and ports. Required binaries:
    `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`,
    `/usr/sbin/pkg_info`, `/usr/local/sbin/portupgrade`. Default for
    `operatingsystem` == `freebsd`. Supported features: `installable`,
    `uninstallable`, `upgradeable`.
-   **rpm**: RPM packaging support; should work anywhere with a working `rpm`
    :   binary. Required binaries: `rpm`. Supported features:
        `installable`, `uninstallable`, `upgradeable`, `versionable`.


-   **rug**: Support for suse `rug` package manager. Required
    binaries: `/usr/bin/rug`, `rpm`. Default for `operatingsystem` ==
    `susesles`. Supported features: `installable`, `uninstallable`,
    `upgradeable`, `versionable`.
-   **sun**: Sun's packaging system. Requires that you specify the source for
    :   the packages you're managing. Required binaries:
        `/usr/bin/pkginfo`, `/usr/sbin/pkgadd`, `/usr/sbin/pkgrm`. Default
        for `operatingsystem` == `solaris`. Supported features:
        `installable`, `uninstallable`, `upgradeable`.


-   **sunfreeware**: Package management using sunfreeware.com's `pkg-get` command on Solaris.
    :   At this point, support is exactly the same as `blastwave`
        support and has not actually been tested. Required binaries:
        `pkg-get`. Supported features: `installable`, `uninstallable`,
        `upgradeable`.


-   **up2date**: Support for Red Hat's proprietary `up2date` package update
    :   mechanism. Required binaries: `/usr/sbin/up2date-nox`. Default
        for `lsbdistrelease` == `2.134` and `operatingsystem` ==
        `redhatoelovm`. Supported features: `installable`, `uninstallable`,
        `upgradeable`.


-   **urpmi**: Support via `urpmi`. Required binaries: `rpm`,
    `urpmi`, `urpmq`. Default for `operatingsystem` ==
    `mandrivamandrake`. Supported features: `installable`,
    `uninstallable`, `upgradeable`, `versionable`.
-   **yum**: Support via `yum`. Required binaries: `yum`, `rpm`,
    `python`. Default for `operatingsystem` == `fedoracentosredhat`.
    Supported features: `installable`, `purgeable`, `uninstallable`,
    `upgradeable`, `versionable`.


#### responsefile

A file containing any necessary answers to questions asked by the
package. This is currently used on Solaris and Debian. The value
will be validated according to system rules, but it should
generally be a fully qualified path.

#### root

A read-only parameter set by the package.

#### source

Where to find the actual package. This must be a local file (or on
a network file system) or a URL that your specific packaging type
understands; Puppet will not retrieve files for you.

#### status

A read-only parameter set by the package.

#### type

Deprecated form of `provider`.

#### vendor

A read-only parameter set by the package.


* * * * *

