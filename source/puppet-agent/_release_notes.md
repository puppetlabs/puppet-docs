## Release Notes

### 1.3.0

Released November 17, 2015.

* Introduces `pxp-agent`.
* Updates [Puppet](/puppet/4.3/reference/release_notes.html#puppet-430), [Facter](/facter/3.1/release_notes.html#facter-312), and [Hiera](/hiera/latest/release_notes.html#hiera-304).
* [Updates vendored Ruby gems on Windows](https://tickets.puppetlabs.com/browse/PA-69) and [registers non-MCollective vendored gems](https://tickets.puppetlabs.com/browse/PA-25) on all platforms.
* Adds [more certificates](https://tickets.puppetlabs.com/browse/PA-73) to enable Forge access on non-Windows platforms.
* Resolves [a daemonization issue on AIX](https://tickets.puppetlabs.com/browse/PA-67) that made the service appear to be inoperative when running.
* [Moves `dmidecode`](https://tickets.puppetlabs.com/browse/PA-2) to `/opt/puppetlabs/puppet/bin`.

### 1.2.7

Released October 29, 2015.

The Puppet Enterprise 2015.2.3 repositories include puppet-agent packages for AIX and Solaris 11.

* Updates Ruby on Windows, [Puppet](/puppet/4.2/reference/release_notes.html#puppet-423), [Facter](/facter/3.1/release_notes.html#facter-311), and [Hiera](/hiera/latest/release_notes.html#hiera-304).
* [Moves the OS X bill of materials](https://tickets.puppetlabs.com/browse/PA-21) to `/usr/local/share` on all supported OS X platforms to ensure future compatibility with OS X 10.11 (El Capitan)
* [Adds a root certificate](https://tickets.puppetlabs.com/browse/PA-20) in Enterprise Linux 4 to enable Forge access.
* [Resolves a security issue](https://tickets.puppetlabs.com/browse/PA-27) in Windows.

### 1.2.6

Released October 12, 2015.

This release contains no component fixes or updates. It only resolves a packaging issue that could leave the `puppet` and `mcollective` services stopped and unregistered after a package upgrade from an earlier `puppet-agent` release.

### 1.2.5

Released October 1, 2015.

* Updates [MCollective](/mcollective/releasenotes.html#changes-since-284) to fix an issue when trying to start `mcollectived` on Solaris 10.
* Changes the package file names on OS X to use major and minor OS versions (such as `puppet-agent-1.2.5-1.osx10.10.dmg`) instead of codenames (such as `puppet-agent-1.2.5-1.yosemite.dmg`).

### 1.2.4

Released September 14, 2015.

* Updates [Puppet](/puppet/4.2/reference/release_notes.html#puppet-422), [Facter](/facter/3.1/release_notes.html#facter-310), and [MCollective](/mcollective/releasenotes.html#changes-since-283).

There was no `puppet-agent` 1.2.3 release.

### 1.2.2

Released July 22, 2015.

* Resolves bugs in [Facter](/facter/3.0/release_notes.html#facter-302) and [Puppet](/puppet/4.2/reference/release_notes.html#puppet-421).

### 1.2.1

Released June 25, 2015.

* Fixes a regression in [Facter](/facter/3.0/release_notes.html#facter-301).

### 1.2.0

Released June 24, 2015.

* Updates [Puppet](/puppet/4.2/reference/release_notes.html#puppet-420) and [Facter](/facter/3.0/release_notes.html#facter-300).

### 1.1.x and earlier

For details on earlier `puppet-agent` releases, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).