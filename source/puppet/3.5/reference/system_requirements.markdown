---
layout: default
title: "Puppet 3 System Requirements"
canonical: "/puppet/latest/reference/system_requirements.html"
---

> To install Puppet 3, see [the Puppet installation guide](/guides/installation.html).

Basic Requirements
-----

Puppet 3 has the following prerequisites:

### Ruby

Use one of the following versions of MRI (standard) Ruby:

* 1.8.7
* 1.9.3
* 2.0.x
* 2.1.x --- **Note:** We run spec tests for Ruby 2.1, but since none of our tested platforms ship with it yet, we don't run acceptance tests on it. This means we think it's good, but it might have problems we don't know about yet.

Other interpreters and versions of Ruby are not covered by our tests, and may or may not work.

### Facter

- [Facter](http://www.puppetlabs.com/puppet/related-projects/facter/) 1.7.0 or later

### Hiera

- [Hiera](http://docs.puppetlabs.com/hiera/latest/) 1.0 or later

### Optional: the `rgen` Ruby Gem

If you are using Puppet [with `parser = future` enabled](./experiments_future.html), you will need:

- [rgen gem](http://ruby-gen.org/downloads) 0.6.1 or later

Puppet Labs's official packages will install rgen as a dependency, as will the Puppet gem. If you are installing Puppet manually or with unofficial packages, rgen is optional.

Platform Support
-----

Puppet 3.5 and all of its prerequisites will run on the following platforms:

### Linux

- Red Hat Enterprise Linux, versions 5 through 7 (note that RHEL 5 requires an [updated Ruby ≥ 1.8.7 from our yum repo](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html))
- RHEL-derived distributions (including CentOS, Scientific Linux, and Oracle Linux), versions 5 through 7
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
