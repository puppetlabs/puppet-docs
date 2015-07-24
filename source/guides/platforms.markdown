---
layout: default
title: Puppet Open Source » Supported Platforms and System Requirements
---

[pe-requirements]: /pe/latest/install_system_requirements.html

Puppet Open Source Supported Platforms
===================

This page lists supported platforms for the open source version of Puppet. For Puppet Enterprise's supported platforms visit the [PE system requirements page][pe-requirements].

Please [contact Puppet Labs](http://puppetlabs.com/contact/) if you are interested in a platform not on this list.

**[See Installing Puppet](/guides/install_puppet/pre_install.html)** for more details about the packages available for your platform(s).


{% include agent_lifecycle.md %}

Linux
-----

### Red Hat Enterprise Linux (and Derivatives)

{% include platforms_redhat_like.markdown %}

### Debian and Ubuntu

{% include platforms_debian_like.markdown %}

### Fedora

{% include platforms_fedora.markdown %}

### Other

- SUSE Linux Enterprise Server, version 11 and higher
- Gentoo Linux
- Mandriva Corporate Server 4
- ArchLinux

BSD
---

- FreeBSD 4.7 and later
- OpenBSD 4.1 and later

Other Unix
----------

- Mac OS X, version 10.7 (Leopard) and higher
- Oracle Solaris, version 10 and higher
- AIX, version 5.3 and higher
- HP-UX

Windows
-------

{% include platforms_windows.markdown %}

Ruby Versions
-----

Puppet requires an [MRI](http://en.wikipedia.org/wiki/Ruby_MRI) [Ruby](http://www.ruby-lang.org/en/) interpreter.
Certain versions of Ruby are tested more thoroughly with Puppet than others, and some versions are not tested at all. Run `ruby --version` to check the version of Ruby on your system.

> Starting with Puppet 4, puppet-agent packages do not rely on the OS's Ruby version, as it bundles its own Ruby environment. You can install puppet-agent alongside any version of Ruby or on systems without Ruby installed.
> Likewise [Puppet Enterprise](/pe/) does not rely on the OS's Ruby version, as it bundles its own Ruby environment. You can install PE alongside any version of Ruby or on systems without Ruby installed.
> ![windows logo](/images/windows-logo-small.jpg) The [Windows installers](http://downloads.puppetlabs.com/windows) provided by Puppet Labs don't rely on the OS's Ruby version, and can be installed alongside any version of Ruby or on systems without Ruby installed.

Ruby version | Puppet 3.x              | Puppet 4.x
-------------|-------------------------------------------
2.2.x        | No                      | Lightly Tested
2.1.x        | Tested (3.5 and higher) | Tested
2.0.x        | Tested (3.2 and higher) | Lightly Tested
1.9.3\*      | Tested                  | Lightly Tested
1.8.7        | Tested                  | No

> \* Ruby 1.9.3-p392 and up only. Unfortunately, Ubuntu Precise ships with 1.9.3-p0. If you're using Precise with Puppet 3.x, we recommend using Puppet Enterprise or installing a third-party Ruby package.

Versions marked as "Tested" are recommended by Puppet Labs and are under automated test coverage. As of Puppet 4, where puppet-agent packages bundle Ruby, versions marked "Lightly Tested" are under reduced automated test coverage (specifically, spec tests only) -- the Ruby version bundled with puppet-agent is the recommended version. Other versions are not recommended and we make no guarantees about their performance with Puppet.

Prerequisites
-----

Puppet has a very small number of external dependencies:

Dependency | Puppet 3.x | Puppet 4.x
-----------|------------|-----------
[Facter][] | Required   | Required
[Hiera][]  | Required   | Required
[rgen][]   | Optional   | Required

Rgen is only needed if you are using Puppet 4 (or Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/latest/reference/lang_future.html)). The official Puppet Labs packages will install it as a dependency.

[Facter]: /facter
[Hiera]: /hiera/latest/installing.html
[rgen]: http://ruby-gen.org/downloads

All other prerequisite Ruby libraries should come with any standard Ruby install.  Should your OS not come with the complete standard library (or you are using a custom Ruby build), these include:

* base64
* cgi
* digest/md5
* etc
* fileutils
* ipaddr
* openssl (>= 0.9.8o if using a 3.x Puppet master or newer)
* strscan
* syslog
* uri
* webrick
* webrick/https
* xmlrpc

