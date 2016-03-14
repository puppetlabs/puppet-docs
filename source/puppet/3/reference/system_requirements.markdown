---
layout: default
title: "Puppet 3 System Requirements"
canonical: "/puppet/latest/reference/system_requirements.html"
---

> To install Puppet 3, see [the Puppet installation guide](http://docs.puppet.com./pre_install.html).

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

- [Hiera](/hiera/latest/) 1.0 or later

### Optional: the `rgen` Ruby Gem (Puppet 3.2.0 and later)

If you are using Puppet ≥ 3.2 [with `parser = future` enabled](./lang_experimental_3_2.html), you will need:

- [rgen gem](http://ruby-gen.org/downloads) 0.6.1 or later

Puppet Labs's official packages will install rgen as a dependency, as will the Puppet gem. If you are installing Puppet manually or with unofficial packages, rgen is optional.

Platform Support
-----

Puppet 3 and all of its prerequisites will run on the following platforms:

### Red Hat Enterprise Linux (and Derivatives)

{% include platforms_redhat_like.markdown %}

### Debian and Ubuntu

{% include platforms_debian_like.markdown %}

### Fedora

{% include platforms_fedora.markdown %}

### Other Linux

On these platforms, Puppet Labs does not build official packages.

- SUSE Linux Enterprise Server, version 11 and higher
- Gentoo Linux
- Mandriva Corporate Server 4
- ArchLinux

### Other Unix

- Mac OS X, version 10.5 (Leopard) and higher
- Oracle Solaris, version 10 and higher
- AIX, version 5.3 and higher
- FreeBSD 4.7 and later
- OpenBSD 4.1 and later
- HP-UX

### Windows

{% include platforms_windows.markdown %}

