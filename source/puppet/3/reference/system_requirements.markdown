---
layout: default
title: "Puppet 3 System Requirements"
---

> To install Puppet 3, see [the Puppet installation guide](/guides/installation.html).

Basic Requirements
-----

Puppet 3 has the following prerequisites:

### Ruby

**All Puppet 3.x releases:**

- MRI Ruby 1.8.7 or Ruby 1.9.3; other interpreters and versions of Ruby are not supported, and may or may not work.

**Puppet 3.2.x and later:**

- As above, plus MRI Ruby 2.0.x.

### Facter

- [Facter](http://www.puppetlabs.com/puppet/related-projects/facter/) 1.6.2 or later

### Hiera

- [Hiera](http://docs.puppetlabs.com/hiera/latest/) 1.0 or later

### Optional: the `rgen` Ruby Gem (Puppet 3.2.0 and later)

If you are using Puppet ≥ 3.2 [with `parser = future` enabled](./lang_future.html), you will need:

- [rgen gem](http://ruby-gen.org/downloads) 0.6.1 or later

Puppet Labs's official packages will install rgen as a dependency, as will the Puppet gem. If you are installing Puppet manually or with unofficial packages, rgen is optional.

Platform Support
-----

Puppet 3 and all of its prerequisites will run on the following platforms:

### Linux

- Red Hat Enterprise Linux, version 5 and higher, with an updated Ruby ≥ 1.8.7, [available from Puppetlabs' yum repositories](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html)
- RHEL-derived distributions (including CentOS, Scientific Linux, and Oracle Linux), version 5 and higher
- Debian, version 5 (Lenny) and higher
- Ubuntu, version 8.04 LTS and higher
- Fedora, version 15 and higher
- SUSE Linux Enterprise Server, version 11 and higher
- Gentoo Linux
- Mandriva Corporate Server 4 <!-- Version not checked recently -->
- ArchLinux

### Other Unix

- Mac OS X, version 10.5 (Leopard) and higher
- Oracle Solaris, version 10 and higher
- AIX, version 5.3 and higher
- FreeBSD 4.7 and later <!-- Version not checked recently -->
- OpenBSD 4.1 and later <!-- Version not checked recently -->
- HP-UX

### Windows

- Windows Server 2003 and 2008
- Windows 7
