---
layout: legacy
title: Supported Platforms
---

[pe2requirements]: /pe/2.5/install_system_requirements.html

Supported Platforms
===================

For information about Puppet Enterprise's system requirements, [see here][pe2requirements].

Please [contact Puppet Labs](http://puppetlabs.com/contact/) if you are interested in a platform not on this list.

**[See Installing Puppet](/guides/installation.html)** for more details about the packages available for your platform(s).

Puppet 2.6, 2.7, and 3 can run on the following platforms: 

Linux
-----

- Red Hat Enterprise Linux, version 4 and higher
- CentOS, version 4 and higher
- Scientific Linux, version 4 and higher
- Oracle Linux, version 4 and higher
- Debian, version 5 (Lenny) and higher
- Ubuntu, version 8.04 LTS and higher
- Fedora, version 15 and higher
- SUSE Linux Enterprise Server, version 11 and higher
- Gentoo Linux
- Mandriva Corporate Server 4 <!-- Version not checked recently -->
- ArchLinux

BSD
---

- FreeBSD 4.7 and later <!-- Version not checked recently -->
- OpenBSD 4.1 and later <!-- Version not checked recently -->

Other Unix
----------

- Mac OS X, version 10.5 (Leopard) and higher (Puppet 2.7 and earlier also support 10.4)
- Oracle Solaris, version 10 and higher
- AIX, version 5.3 and higher
- HP-UX

Windows
-------

- Windows Server 2003 and 2008 (Puppet version 2.7.6 and higher)
- Windows 7 (Puppet version 2.7.6 and higher)

Ruby Versions
-----

Puppet requires [Ruby](http://www.ruby-lang.org/en/). Certain versions of Ruby work better with Puppet than others. Run `ruby --version` to check the version of Ruby on your system.

> [Puppet Enterprise](/pe/) does not rely on the OS's Ruby version, as it maintains its own Ruby environment. You can install PE alongside any version of Ruby or on systems without Ruby installed.

> ![windows logo](/images/windows-logo-small.jpg) The [Windows installers](http://downloads.puppetlabs.com/windows) provided by Puppet Labs don't rely on the OS's Ruby version, and can be installed alongside any version of Ruby or on systems without Ruby installed.

Ruby version | Puppet 2.6 | Puppet 2.7 | Puppet 3.x
-------------|------------|------------|-----------
1.8.5\*      | Supported  | Supported  | No
1.8.7        | Supported  | Supported  | Supported
1.9.3        | No         | No         | Supported
1.9.2        | No         | No         | No
1.9.1        | No         | No         | No
1.9.0        | No         | No         | No
1.8.6        | No         | No         | No
1.8.1        | No         | No         | No

> \* Note that although Ruby 1.8.5 is fully supported, Ruby 1.8.7 generally gives better performance and memory use.

Versions marked as "Supported" are recommended by Puppet Labs and are under extensive automated test coverage. Other versions are not recommended, and we make no guarantees about their performance with Puppet; however:

* Ruby 1.8.6 and 1.8.1 have occasionally been known to work for agent nodes, but should never be used on a puppet master server.
* Ruby 1.9.2 may work with Puppet 3.0, but there are several known issues, and Puppet Labs does not perform automated testing on it.
* Ruby 1.9.2 and 1.9.3 have major known issues with Puppet 2.7, and should be avoided. They will not work at all with Puppet 2.6.
* Ruby 1.9.0 and 1.9.1 should always be avoided with all Puppet versions past and future.


Prerequisites
-----

Puppet has a very small number of external dependencies, which are also developed by Puppet Labs:

Dependency | Puppet 2.x | Puppet 3.x
-----------|------------|-----------
[Facter][] | Required   | Required
[Hiera][]  | Optional   | Required

[Facter]: http://www.puppetlabs.com/projects/facter/index.html
[Hiera]: https://github.com/puppetlabs/hiera

All other prerequisite Ruby libraries should come with any standard Ruby 1.8.2+ install.  Should your OS not come with the complete standard library (or you are using a custom Ruby build), these include:

* base64
* cgi
* digest/md5
* etc
* fileutils
* ipaddr
* openssl
* strscan
* syslog
* uri
* webrick
* webrick/https
* xmlrpc

