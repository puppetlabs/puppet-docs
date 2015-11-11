### Release Notes

* **1.3.0**, Nov. 12, 2015: Introduces `pxp-agent` and updates [Puppet](/puppet/4.3/reference/release_notes.html#puppet-430), [Facter](/facter/3.1/release_notes.html#facter-312), and [Hiera](/hiera/latest/release_notes.html#hiera-304). Also [updates vendored Ruby gems on Windows](https://tickets.puppetlabs.com/browse/PA-69) and [registers non-MCollective vendored gems](https://tickets.puppetlabs.com/browse/PA-25) on all platforms, adds [more certificates](https://tickets.puppetlabs.com/browse/PA-73) to enable Forge access on non-Windows platforms, resolves [a daemonization issue on AIX](https://tickets.puppetlabs.com/browse/PA-67) that made the service appear to be inoperative when running, and [moves `dmidecode`](https://tickets.puppetlabs.com/browse/PA-2) to `/opt/puppetlabs/puppet/bin`.
* **1.2.7**, Oct. 29, 2015: Updates Ruby on Windows, [Puppet](/puppet/4.2/reference/release_notes.html#puppet-423), [Facter](/facter/3.1/release_notes.html#facter-311), and [Hiera](/hiera/latest/release_notes.html#hiera-304). This version also [moves the OS X bill of materials](https://tickets.puppetlabs.com/browse/PA-21) to `/usr/local/share` on all supported OS X platforms to ensure future compatibility with OS X 10.11 (El Capitan), [adds a root certificate](https://tickets.puppetlabs.com/browse/PA-20) in Enterprise Linux 4 to enable Forge access, and [resolves a security issue](https://tickets.puppetlabs.com/browse/PA-27) in Windows.

    Puppet Enterprise 2015.2.3 will also offer packages for AIX and Solaris 11.
* **1.2.6**, Oct. 12, 2015: Contains no component fixes or updates. It only resolves a packaging issue that could leave the `puppet` and `mcollective` services stopped and unregistered after a package upgrade from an earlier `puppet-agent` release.
* **1.2.5**, Oct. 1, 2015: Updates [MCollective](/mcollective/releasenotes.html#changes-since-284) to fix an issue when trying to start `mcollectived` on Solaris 10. It also changes the package file names on OS X to use major and minor OS versions (such as `puppet-agent-1.2.5-1.osx10.10.dmg`) instead of codenames (such as `puppet-agent-1.2.5-1.yosemite.dmg`).
* **1.2.4**, Sept. 14, 2015: Updates [Puppet](/puppet/4.2/reference/release_notes.html#puppet-422), [Facter](/facter/3.1/release_notes.html#facter-310), and [MCollective](/mcollective/releasenotes.html#changes-since-283).
* **1.2.3**: _Not released._
* **1.2.2**, July 22, 2015: Resolves bugs in [Facter](/facter/3.0/release_notes.html#facter-302) and [Puppet](/puppet/4.2/reference/release_notes.html#puppet-421).
* **1.2.1**, June 25, 2015: Fixes a regression in [Facter](/facter/3.0/release_notes.html#facter-301).
* **1.2.0**, June 24, 2015: Updates [Puppet](/puppet/4.2/reference/release_notes.html#puppet-420) and [Facter](/facter/3.0/release_notes.html#facter-300).

For details on earlier `puppet-agent` releases, see the [puppet-announce Google Group](https://groups.google.com/forum/#!forum/puppet-announce).
