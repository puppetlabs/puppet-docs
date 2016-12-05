---
layout: default
built_from_commit: 44f2fdad9d3a565123ceae69c267403981e0141a
title: 'Resource Type: package'
canonical: /puppet/latest/reference/types/package.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-07-07 12:39:53 -0500

package
-----

* [Attributes](#package-attributes)
* [Providers](#package-providers)
* [Provider Features](#package-provider-features)

<h3 id="package-description">Description</h3>

Manage packages.  There is a basic dichotomy in package
support right now:  Some package types (e.g., yum and apt) can
retrieve their own package files, while others (e.g., rpm and sun)
cannot.  For those package formats that cannot retrieve their own files,
you can use the `source` parameter to point to the correct file.

Puppet will automatically guess the packaging format that you are
using based on the platform you are on, but you can override it
using the `provider` parameter; each provider defines what it
requires in order to function, and you must meet those requirements
to use a given provider.

You can declare multiple package resources with the same `name`, as long
as they specify different providers and have unique titles.

Note that you must use the _title_ to make a reference to a package
resource; `Package[<NAME>]` is not a synonym for `Package[<TITLE>]` like
it is for many other resource types.

**Autorequires:** If Puppet is managing the files specified as a
package's `adminfile`, `responsefile`, or `source`, the package
resource will autorequire those files.

<h3 id="package-attributes">Attributes</h3>

<pre><code>package { 'resource title':
  <a href="#package-attribute-provider">provider</a>             =&gt; <em># <strong>(namevar)</strong> The specific backend to use for this `package...</em>
  <a href="#package-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The package name.  This is the name that the...</em>
  <a href="#package-attribute-ensure">ensure</a>               =&gt; <em># What state the package should be in. On...</em>
  <a href="#package-attribute-adminfile">adminfile</a>            =&gt; <em># A file containing package defaults for...</em>
  <a href="#package-attribute-allow_virtual">allow_virtual</a>        =&gt; <em># Specifies if virtual package names are allowed...</em>
  <a href="#package-attribute-allowcdrom">allowcdrom</a>           =&gt; <em># Tells apt to allow cdrom sources in the...</em>
  <a href="#package-attribute-category">category</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-configfiles">configfiles</a>          =&gt; <em># Whether to keep or replace modified config files </em>
  <a href="#package-attribute-description">description</a>          =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-flavor">flavor</a>               =&gt; <em># OpenBSD supports 'flavors', which are further...</em>
  <a href="#package-attribute-install_options">install_options</a>      =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-instance">instance</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-package_settings">package_settings</a>     =&gt; <em># Settings that can change the contents or...</em>
  <a href="#package-attribute-platform">platform</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-reinstall_on_refresh">reinstall_on_refresh</a> =&gt; <em># Whether this resource should respond to refresh...</em>
  <a href="#package-attribute-responsefile">responsefile</a>         =&gt; <em># A file containing any necessary answers to...</em>
  <a href="#package-attribute-root">root</a>                 =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-source">source</a>               =&gt; <em># Where to find the package file. This is only...</em>
  <a href="#package-attribute-status">status</a>               =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-uninstall_options">uninstall_options</a>    =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-vendor">vendor</a>               =&gt; <em># A read-only parameter set by the...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="package-attribute-provider">provider</h4>

_(**Secondary namevar:** This resource type allows you to manage multiple resources with the same name as long as their providers are different.)_

The specific backend to use for this `package`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#package-provider-aix)
* [`appdmg`](#package-provider-appdmg)
* [`apple`](#package-provider-apple)
* [`apt`](#package-provider-apt)
* [`aptitude`](#package-provider-aptitude)
* [`aptrpm`](#package-provider-aptrpm)
* [`blastwave`](#package-provider-blastwave)
* [`dnf`](#package-provider-dnf)
* [`dpkg`](#package-provider-dpkg)
* [`fink`](#package-provider-fink)
* [`freebsd`](#package-provider-freebsd)
* [`gem`](#package-provider-gem)
* [`hpux`](#package-provider-hpux)
* [`macports`](#package-provider-macports)
* [`nim`](#package-provider-nim)
* [`openbsd`](#package-provider-openbsd)
* [`opkg`](#package-provider-opkg)
* [`pacman`](#package-provider-pacman)
* [`pip3`](#package-provider-pip3)
* [`pip`](#package-provider-pip)
* [`pkg`](#package-provider-pkg)
* [`pkgdmg`](#package-provider-pkgdmg)
* [`pkgin`](#package-provider-pkgin)
* [`pkgng`](#package-provider-pkgng)
* [`pkgutil`](#package-provider-pkgutil)
* [`portage`](#package-provider-portage)
* [`ports`](#package-provider-ports)
* [`portupgrade`](#package-provider-portupgrade)
* [`puppet_gem`](#package-provider-puppet_gem)
* [`rpm`](#package-provider-rpm)
* [`rug`](#package-provider-rug)
* [`sun`](#package-provider-sun)
* [`sunfreeware`](#package-provider-sunfreeware)
* [`up2date`](#package-provider-up2date)
* [`urpmi`](#package-provider-urpmi)
* [`windows`](#package-provider-windows)
* [`yum`](#package-provider-yum)
* [`zypper`](#package-provider-zypper)

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The package name.  This is the name that the packaging
system uses internally, which is sometimes (especially on Solaris)
a name that is basically useless to humans.  If a package goes by
several names, you can use a single title and then set the name
conditionally:

    # In the 'openssl' class
    $ssl = $operatingsystem ? {
      solaris => SMCossl,
      default => openssl
    }

    package { 'openssl':
      ensure => installed,
      name   => $ssl,
    }

    . etc. .

    $ssh = $operatingsystem ? {
      solaris => SMCossh,
      default => openssh
    }

    package { 'openssh':
      ensure  => installed,
      name    => $ssh,
      require => Package['openssl'],
    }

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What state the package should be in. On packaging systems that can
retrieve new packages on their own, you can choose which package to
retrieve by specifying a version number or `latest` as the ensure
value. On packaging systems that manage configuration files separately
from "normal" system files, you can uninstall config files by
specifying `purged` as the ensure value. This defaults to `installed`.

Version numbers must match the full version to install, including
release if the provider uses a release moniker. Ranges or semver
patterns are not accepted except for the `gem` package provider. For
example, to install the bash package from the rpm
`bash-4.1.2-29.el6.x86_64.rpm`, use the string `'4.1.2-29.el6'`.

Valid values are `present` (also called `installed`), `absent`, `purged`, `held`, `latest`. Values can match `/./`.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-adminfile">adminfile</h4>

A file containing package defaults for installing packages.

This attribute is only used on Solaris. Its value should be a path to a
local file stored on the target system. Solaris's package tools expect
either an absolute file path or a relative path to a file in
`/var/sadm/install/admin`.

The value of `adminfile` will be passed directly to the `pkgadd` or
`pkgrm` command with the `-a <ADMINFILE>` option.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allow_virtual">allow_virtual</h4>

Specifies if virtual package names are allowed for install and uninstall.

Valid values are `true`, `false`, `yes`, `no`.

Requires features virtual_packages.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allowcdrom">allowcdrom</h4>

Tells apt to allow cdrom sources in the sources.list file.
Normally apt will bail if you try this.

Valid values are `true`, `false`.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-category">category</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-configfiles">configfiles</h4>

Whether to keep or replace modified config files when installing or
upgrading a package. This only affects the `apt` and `dpkg` providers.
Defaults to `keep`.

Valid values are `keep`, `replace`.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-description">description</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-flavor">flavor</h4>

OpenBSD supports 'flavors', which are further specifications for
which type of package you want.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-install_options">install_options</h4>

An array of additional options to pass when installing a package. These
options are package-specific, and should be documented by the software
vendor.  One commonly implemented option is `INSTALLDIR`:

    package { 'mysql':
      ensure          => installed,
      source          => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => [ '/S', { 'INSTALLDIR' => 'C:\mysql-5.5' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the install command.

With Windows packages, note that file paths in an install option must
use backslashes. (Since install options are passed directly to the
installation command, forward slashes won't be automatically converted
like they are in `file` resources.) Note also that backslashes in
double-quoted strings _must_ be escaped and backslashes in single-quoted
strings _can_ be escaped.



Requires features install_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-instance">instance</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-package_settings">package_settings</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Settings that can change the contents or configuration of a package.

The formatting and effects of package_settings are provider-specific; any
provider that implements them must explain how to use them in its
documentation. (Our general expectation is that if a package is
installed but its settings are out of sync, the provider should
re-install that package with the desired settings.)

An example of how package_settings could be used is FreeBSD's port build
options --- a future version of the provider could accept a hash of options,
and would reinstall the port if the installed version lacked the correct
settings.

    package { 'www/apache22':
      package_settings => { 'SUEXEC' => false }
    }

Again, check the documentation of your platform's package provider to see
the actual usage.



Requires features package_settings.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-platform">platform</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-reinstall_on_refresh">reinstall_on_refresh</h4>

Whether this resource should respond to refresh events (via `subscribe`,
`notify`, or the `~>` arrow) by reinstalling the package. Only works for
providers that support the `reinstallable` feature.

This is useful for source-based distributions, where you may want to
recompile a package if the build options change.

If you use this, be careful of notifying classes when you want to restart
services. If the class also contains a refreshable package, doing so could
cause unnecessary re-installs.

Defaults to `false`.

Valid values are `true`, `false`.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-responsefile">responsefile</h4>

A file containing any necessary answers to questions asked by
the package.  This is currently used on Solaris and Debian.  The
value will be validated according to system rules, but it should
generally be a fully qualified path.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-root">root</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-source">source</h4>

Where to find the package file. This is only used by providers that don't
automatically download packages from a central repository. (For example:
the `yum` and `apt` providers ignore this attribute, but the `rpm` and
`dpkg` providers require it.)

Different providers accept different values for `source`. Most providers
accept paths to local files stored on the target system. Some providers
may also accept URLs or network drive paths. Puppet will not
automatically retrieve source files for you, and usually just passes the
value of `source` to the package installation command.

You can use a `file` resource if you need to manually copy package files
to the target system.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-status">status</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-uninstall_options">uninstall_options</h4>

An array of additional options to pass when uninstalling a package. These
options are package-specific, and should be documented by the software
vendor.  For example:

    package { 'VMware Tools':
      ensure            => absent,
      uninstall_options => [ { 'REMOVE' => 'Sync,VSS' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the uninstall
command.

On Windows, this is the **only** place in Puppet where backslash
separators should be used.  Note that backslashes in double-quoted
strings _must_ be double-escaped and backslashes in single-quoted
strings _may_ be double-escaped.



Requires features uninstall_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-vendor">vendor</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))


<h3 id="package-providers">Providers</h3>

<h4 id="package-provider-aix">aix</h4>

Installation from an AIX software directory, using the AIX `installp`
command.  The `source` parameter is required for this provider, and should
be set to the absolute path (on the puppet agent machine) of a directory
containing one or more BFF package files.

The `installp` command will generate a table of contents file (named `.toc`)
in this directory, and the `name` parameter (or resource title) that you
specify for your `package` resource must match a package name that exists
in the `.toc` file.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/bin/lslpp`, `/usr/sbin/installp`.
* Default for `operatingsystem` == `aix`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-appdmg">appdmg</h4>

Package management which copies application bundles to a target.

* Required binaries: `/usr/bin/curl`, `/usr/bin/ditto`, `/usr/bin/hdiutil`.
* Supported features: `installable`.

<h4 id="package-provider-apple">apple</h4>

Package management based on OS X's builtin packaging system.  This is
essentially the simplest and least functional package system in existence --
it only supports installation; no deletion or upgrades.  The provider will
automatically add the `.pkg` extension, so leave that off when specifying
the package name.

* Required binaries: `/usr/sbin/installer`.
* Supported features: `installable`.

<h4 id="package-provider-apt">apt</h4>

Package management via `apt-get`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to apt-get.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/apt-cache`, `/usr/bin/apt-get`, `/usr/bin/debconf-set-selections`.
* Default for `osfamily` == `debian`.
* Supported features: `holdable`, `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-aptitude">aptitude</h4>

Package management via `aptitude`.

* Required binaries: `/usr/bin/apt-cache`, `/usr/bin/aptitude`.
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-aptrpm">aptrpm</h4>

Package management via `apt-get` ported to `rpm`.

* Required binaries: `apt-cache`, `apt-get`, `rpm`.
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-blastwave">blastwave</h4>

Package management using Blastwave.org's `pkg-get` command on Solaris.

* Required binaries: `pkg-get`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-dnf">dnf</h4>

Support via `dnf`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to dnf.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `dnf`, `rpm`.
* Default for `operatingsystem` == `fedora` and `operatingsystemmajrelease` == `22, 23`.
* Supported features: `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`.

<h4 id="package-provider-dpkg">dpkg</h4>

Package management via `dpkg`.  Because this only uses `dpkg`
and not `apt`, you must specify the source of any packages you want
to manage.

* Required binaries: `/usr/bin/dpkg-deb`, `/usr/bin/dpkg-query`, `/usr/bin/dpkg`.
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-fink">fink</h4>

Package management via `fink`.

* Required binaries: `/sw/bin/apt-cache`, `/sw/bin/apt-get`, `/sw/bin/dpkg-query`, `/sw/bin/fink`.
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-freebsd">freebsd</h4>

The specific form of package management on FreeBSD.  This is an
extremely quirky packaging system, in that it freely mixes between
ports and packages.  Apparently all of the tools are written in Ruby,
so there are plans to rewrite this support to directly use those
libraries.

* Required binaries: `/usr/sbin/pkg_add`, `/usr/sbin/pkg_delete`, `/usr/sbin/pkg_info`.
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-gem">gem</h4>

Ruby Gem support.  If a URL is passed via `source`, then that URL is used as the
remote gem repository; if a source is present but is not a valid URL, it will be
interpreted as the path to a local gem file.  If source is not present at all,
the gem will be installed from the default gem repositories.

This provider supports the `install_options` and `uninstall_options` attributes,
which allow command-line flags to be passed to the gem command.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `gem`.
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-hpux">hpux</h4>

HP-UX's packaging system.

* Required binaries: `/usr/sbin/swinstall`, `/usr/sbin/swlist`, `/usr/sbin/swremove`.
* Default for `operatingsystem` == `hp-ux`.
* Supported features: `installable`, `uninstallable`.

<h4 id="package-provider-macports">macports</h4>

Package management using MacPorts on OS X.

Supports MacPorts versions and revisions, but not variants.
Variant preferences may be specified using
[the MacPorts variants.conf file](http://guide.macports.org/chunked/internals.configuration-files.html#internals.configuration-files.variants-conf).

When specifying a version in the Puppet DSL, only specify the version, not the revision.
Revisions are only used internally for ensuring the latest version/revision of a port.

* Required binaries: `/opt/local/bin/port`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-nim">nim</h4>

Installation from an AIX NIM LPP source.  The `source` parameter is required
for this provider, and should specify the name of a NIM `lpp_source` resource
that is visible to the puppet agent machine.  This provider supports the
management of both BFF/installp and RPM packages.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/bin/lslpp`, `/usr/sbin/nimclient`, `rpm`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-openbsd">openbsd</h4>

OpenBSD's form of `pkg_add` support.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to pkg_add and pkg_delete.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `pkg_add`, `pkg_delete`, `pkg_info`.
* Default for `operatingsystem` == `openbsd`.
* Supported features: `install_options`, `installable`, `purgeable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-opkg">opkg</h4>

Opkg packaging support. Common on OpenWrt and OpenEmbedded platforms

* Required binaries: `opkg`.
* Default for `operatingsystem` == `openwrt`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-pacman">pacman</h4>

Support for the Package Manager Utility (pacman) used in Archlinux.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pacman.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pacman`.
* Default for `operatingsystem` == `archlinux, manjarolinux`.
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `virtual_packages`.

<h4 id="package-provider-pip">pip</h4>

Python packages via `pip`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pip3">pip3</h4>

Python packages via `pip3`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip3.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pkg">pkg</h4>

OpenSolaris image packaging system. See pkg(5) for more information

* Required binaries: `/usr/bin/pkg`.
* Default for `kernelrelease` == `5.11` and `osfamily` == `solaris`.
* Supported features: `holdable`, `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pkgdmg">pkgdmg</h4>

Package management based on Apple's Installer.app and DiskUtility.app.

This provider works by checking the contents of a DMG image for Apple pkg or
mpkg files. Any number of pkg or mpkg files may exist in the root directory
of the DMG file system, and Puppet will install all of them. Subdirectories
are not checked for packages.

This provider can also accept plain .pkg (but not .mpkg) files in addition
to .dmg files.

Notes:

* The `source` attribute is mandatory. It must be either a local disk path
  or an HTTP, HTTPS, or FTP URL to the package.
* The `name` of the resource must be the filename (without path) of the DMG file.
* When installing the packages from a DMG, this provider writes a file to
  disk at `/var/db/.puppet_pkgdmg_installed_NAME`. If that file is present,
  Puppet assumes all packages from that DMG are already installed.
* This provider is not versionable and uses DMG filenames to determine
  whether a package has been installed. Thus, to install new a version of a
  package, you must create a new DMG with a different filename.

* Required binaries: `/usr/bin/curl`, `/usr/bin/hdiutil`, `/usr/sbin/installer`.
* Default for `operatingsystem` == `darwin`.
* Supported features: `installable`.

<h4 id="package-provider-pkgin">pkgin</h4>

Package management using pkgin, a binary package manager for pkgsrc.

* Required binaries: `pkgin`.
* Default for `operatingsystem` == `dragonfly, smartos, netbsd`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pkgng">pkgng</h4>

A PkgNG provider for FreeBSD and DragonFly.

* Required binaries: `/usr/local/sbin/pkg`.
* Default for `operatingsystem` == `freebsd`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pkgutil">pkgutil</h4>

Package management using Peter Bonivart's ``pkgutil`` command on Solaris.

* Required binaries: `pkgutil`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-portage">portage</h4>

Provides packaging support for Gentoo's portage system.

* Required binaries: `/usr/bin/eix-update`, `/usr/bin/eix`, `/usr/bin/emerge`.
* Default for `operatingsystem` == `gentoo`.
* Supported features: `installable`, `reinstallable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-ports">ports</h4>

Support for FreeBSD's ports.  Note that this, too, mixes packages and ports.

* Required binaries: `/usr/local/sbin/pkg_deinstall`, `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portversion`, `/usr/sbin/pkg_info`.
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-portupgrade">portupgrade</h4>

Support for FreeBSD's ports using the portupgrade ports management software.
Use the port's full origin as the resource name. eg (ports-mgmt/portupgrade)
for the portupgrade port.

* Required binaries: `/usr/local/sbin/pkg_deinstall`, `/usr/local/sbin/portinstall`, `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portversion`, `/usr/sbin/pkg_info`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-puppet_gem">puppet_gem</h4>

Puppet Ruby Gem support. This provider is useful for managing
gems needed by the ruby provided in the puppet-agent package.

* Required binaries: `/opt/puppetlabs/puppet/bin/gem`.
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-rpm">rpm</h4>

RPM packaging support; should work anywhere with a working `rpm`
binary.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to rpm.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `rpm`.
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`.

<h4 id="package-provider-rug">rug</h4>

Support for suse `rug` package manager.

* Required binaries: `/usr/bin/rug`, `rpm`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-sun">sun</h4>

Sun's packaging system.  Requires that you specify the source for
the packages you're managing.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pkgadd.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pkginfo`, `/usr/sbin/pkgadd`, `/usr/sbin/pkgrm`.
* Default for `osfamily` == `solaris`.
* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-sunfreeware">sunfreeware</h4>

Package management using sunfreeware.com's `pkg-get` command on Solaris.
At this point, support is exactly the same as `blastwave` support and
has not actually been tested.

* Required binaries: `pkg-get`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-up2date">up2date</h4>

Support for Red Hat's proprietary `up2date` package update
mechanism.

* Required binaries: `/usr/sbin/up2date-nox`.
* Default for `lsbdistrelease` == `2.1, 3, 4` and `osfamily` == `redhat`.
* Supported features: `installable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-urpmi">urpmi</h4>

Support via `urpmi`.

* Required binaries: `rpm`, `urpme`, `urpmi`, `urpmq`.
* Default for `operatingsystem` == `mandriva, mandrake`.
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-windows">windows</h4>

Windows package management.

This provider supports either MSI or self-extracting executable installers.

This provider requires a `source` attribute when installing the package.
It accepts paths to local files, mapped drives, or UNC paths.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to the installer.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

If the executable requires special arguments to perform a silent install or
uninstall, then the appropriate arguments should be specified using the
`install_options` or `uninstall_options` attributes, respectively.  Puppet
will automatically quote any option that contains spaces.

* Default for `operatingsystem` == `windows`.
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `versionable`.

<h4 id="package-provider-yum">yum</h4>

Support via `yum`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to yum.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `rpm`, `yum`.
* Default for `osfamily` == `redhat`.
* Supported features: `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`.

<h4 id="package-provider-zypper">zypper</h4>

Support for SuSE `zypper` package manager. Found in SLES10sp2+ and SLES11.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to zypper.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/zypper`.
* Default for `operatingsystem` == `suse, sles, sled, opensuse`.
* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`.

<h3 id="package-provider-features">Provider Features</h3>

Available features:

* `holdable` --- The provider is capable of placing packages on hold such that they are not automatically upgraded as a result of other package dependencies unless explicit action is taken by a user or another package. Held is considered a superset of installed.
* `install_options` --- The provider accepts options to be passed to the installer command.
* `installable` --- The provider can install packages.
* `package_settings` --- The provider accepts package_settings to be ensured for the given package. The meaning and format of these settings is provider-specific.
* `purgeable` --- The provider can purge packages.  This generally means that all traces of the package are removed, including existing configuration files.  This feature is thus destructive and should be used with the utmost care.
* `reinstallable` --- The provider can reinstall packages.
* `uninstall_options` --- The provider accepts options to be passed to the uninstaller command.
* `uninstallable` --- The provider can uninstall packages.
* `upgradeable` --- The provider can upgrade to the latest version of a package.  This feature is used by specifying `latest` as the desired value for the package.
* `versionable` --- The provider is capable of interrogating the package database for installed version(s), and can select which out of a set of available versions of a package to install if asked.
* `virtual_packages` --- The provider accepts virtual package names for install and uninstall.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>holdable</th>
      <th>install options</th>
      <th>installable</th>
      <th>package settings</th>
      <th>purgeable</th>
      <th>reinstallable</th>
      <th>uninstall options</th>
      <th>uninstallable</th>
      <th>upgradeable</th>
      <th>versionable</th>
      <th>virtual packages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>appdmg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apple</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apt</td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptitude</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptrpm</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>blastwave</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>dnf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>dpkg</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>fink</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpux</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>macports</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>nim</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>opkg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pacman</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>pip</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pip3</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkg</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgdmg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgin</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgng</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgutil</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portage</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>ports</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portupgrade</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>puppet_gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>rpm</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>rug</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sun</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sunfreeware</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>up2date</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>urpmi</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>yum</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>zypper</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2016-07-07 12:39:53 -0500