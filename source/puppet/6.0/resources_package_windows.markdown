---
layout: default
title: "Resource tips and examples: Package on Windows"
---

[package]: ./type.html#package
[source]: ./type.html#package-attribute-source

Puppet's built-in [`package`][package] resource type can manage software packages on Windows.

``` puppet
package { 'mysql':
  ensure          => '5.5.16',
  source          => 'N:\packages\mysql-5.5.16-winx64.msi',
  install_options => ['INSTALLDIR=C:\mysql-5.5'],
}

package { "Git version 1.8.4-preview20130916":
 ensure          => installed,
 source          => 'C:\code\puppetlabs\temp\windowsexample\Git-1.8.4-preview20130916.exe',
 install_options => ['/VERYSILENT']
}
```

The `package` type handles a lot of very different packaging systems on many operating systems, so not all features are relevant everywhere. Here's what you'll want to know before using it on Windows.


## Supported package types: MSI and EXE

Puppet can install and remove two kinds of packages on Windows:

* MSI packages
* Executable installers

Both of these use the default `windows` package provider.

### Alternative providers

If you've set up [Chocolatey](https://chocolatey.org/), there's a Puppet-supported package provider for it.

* [Chocolatey package provider on the Puppet Forge](https://forge.puppet.com/puppetlabs/chocolatey)

## The `source` attribute is required

When managing packages using the `windows` package provider, you **must** specify a package file using [the `source` attribute.][source]

The source can be a local file or a file on a mapped network drive. For MSI installers, you can use a UNC path. Puppet URLs are not currently supported for the `package` type's `source` attribute, although you can use `file` resources to copy packages to the local system. The `source` attribute accepts both forward- and backslashes.


## Package name must be the `DisplayName`

The title (or `name`) of the package must match the value of the package's `DisplayName` property in the registry, which is also the value displayed in the "Add/Remove Programs" or "Programs and Features" control panel.

If the provided name and the installed name don't match, Puppet will believe the package is not installed and try to install it again.

The easiest way to determine a package's `DisplayName` is to:

* Install the package on an example system.
* Run `puppet resource package` to see a list of installed packages.
* Locate the package you just installed, and copy the name that Puppet resource reported for it.

Some packages (Git is a notable example) will change their display names with every version released. See the section below on handling versions and upgrades.

## Handling versions and upgrades

Setting `ensure => latest` (which requires the `upgradeable` feature) doesn't work on Windows, as it doesn't support the sort of central package repositories you see on most Linuxes.

There are two main ways to handle package versions and upgrades on Windows.

### Packages with real versions

Many packages on Windows have version metadata. (To tell whether a given package has good version info, you can install it on a test system and use `puppet resource package` to inspect it.)

To upgrade these packages, replace the `source` file and set `ensure => '<VERSION>'`. (For an example, see the MySQL resource at the top of this page.)

The next time Puppet runs, it will notice that the versions don't match and will install the new package. This should make the installed version match the new version, so Puppet won't attempt to re-install the package until you change the version in the manifest again.

The version you use in `ensure` must exactly match the version string that the package reports when you inspect it with Puppet resource. If it doesn't, Puppet will get confused and repeatedly try to re-install.

### Packages that include version info in their `DisplayName`

Some packages don't embed version metadata; instead, they change their DisplayName property with each release. (The Git packages are a notable example of this.)

To upgrade these packages, replace the `source` file and update the resource's title or `name` to the new DisplayName. (For an example, see the Git resource at the top of this page.)

The next time Puppet runs, it will notice that the names don't match and will install the new package. This should make the installed name match the new name, so Puppet won't attempt to re-install the package until you change the name in the manifest again.

The name you use in the title must exactly match the name that the package reports when you inspect it with Puppet resource. If it doesn't, Puppet will get confused and repeatedly try to re-install.


## Install and uninstall options

The Windows package provider also supports package-specific `install_options` (such as install directory) and `uninstall_options`. These options vary across packages, so see the documentation for the specific package you're installing. Options are specified as an array of strings or hashes.

MSI properties can be specified as an array of strings following the 'property=key' pattern; you should use one string per property. Command line flags to executable installers can be specified as an array of strings, with one string per flag.

Any file path arguments within the `install_options` attribute (such as `INSTALLDIR`) should use backslashes, not forward slashes. Be sure to escape your backslashes appropriately. For more info, see [the page on handling Windows file paths.](./lang_windows_file_paths.html)

It's a good idea to use the hash notation for file path arguments since they might contain spaces, for example:

``` puppet
install_options => [ { 'INSTALLDIR' => ${packagedir} } ]
```

## Errata

### Known issues prior to Puppet 4.1.0

**Hidden Packages Were Not Supported**

Puppet did not manage packages that hide themselves from the list of installed programs. That is, packages that set their `SystemComponent` registry value to 1, like `SQL Server 2008 R2 SP2 Common Files`.

Previously, if you tried to manage a hidden package, Puppet would try to install it every time it ran. As of Puppet 4.1.0, Puppet will recognize those package that are already installed, even if they're hidden.

### Known Issues Prior to Puppet 3.4 / PE 3.2

Prior to Puppet 3.4.0 / Puppet Enterprise 3.2, you couldn't specify package versions in the `ensure` attribute. This meant upgrades worked fine for packages that changed their name with every version (such as Git), but there wasn't an easy way to upgrade packages with stable names (such as MySQL).

To manage MySQL-like packages on older Puppet versions, you can specify the package's PackageCode as the name/title, instead of using the DisplayName. The PackageCode is a GUID that's unique per MSI file. You can use Ruby to find the PackageCode from an MSI:

	require 'win32ole'
	installer = WIN32OLE.new('WindowsInstaller.Installer')
	db = installer.OpenDatabase('<PATH>', 0) # where '<PATH>' is the path to the MSI
	puts db.SummaryInformation.Property(9)

Alternately, you can use Orca to view the package code.
