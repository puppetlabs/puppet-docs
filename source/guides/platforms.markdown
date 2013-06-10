---
layout: legacy
title: Supported Platforms
---

[pe2requirements]: /pe/latest/install_system_requirements.html

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

Puppet requires an [MRI](http://en.wikipedia.org/wiki/Ruby_MRI) [Ruby](http://www.ruby-lang.org/en/) interpreter.
Certain versions of Ruby work better with Puppet than others, and some versions are not supported at all. Run `ruby --version` to check the version of Ruby on your system.

> [Puppet Enterprise](/pe/) does not rely on the OS's Ruby version, as it maintains its own Ruby environment. You can install PE alongside any version of Ruby or on systems without Ruby installed.

> ![windows logo](/images/windows-logo-small.jpg) The [Windows installers](http://downloads.puppetlabs.com/windows) provided by Puppet Labs don't rely on the OS's Ruby version, and can be installed alongside any version of Ruby or on systems without Ruby installed.

Ruby version | Puppet 2.6 | Puppet 2.7 | Puppet 3.x
-------------|------------|------------|-----------
1.8.5\*      | Supported  | Supported  | No
1.8.7        | Supported  | Supported  | Supported
1.9.3\*\*    | No         | No         | Supported
1.9.2        | No         | No         | No
1.9.1        | No         | No         | No
1.9.0        | No         | No         | No
1.8.6        | No         | No         | No
1.8.1        | No         | No         | No

> \* Note that although Ruby 1.8.5 is fully supported on Puppet 2.6 and 2.7, Ruby 1.8.7 generally gives better performance and memory use. To support the large installed base of RHEL5 systems which ship with Ruby 1.8.5, Puppet Labs packages a drop-in replacement Ruby 1.8.7 package. Read the ['Enterprise Linux and Derivatives' section of the Installing Puppet guide](http://docs.puppetlabs.com/guides/installation.html#enterprise-linux-and-derivatives) to learn how to install these packages.
>
> \*\* Ruby 1.9.3-p0 has bugs that cause a number of known issues with Puppet, and you should use a different release. To the best of our knowledge, these issues were fixed in the second public release of Ruby 1.9.3 (p125), and we are positive they are resolved in p392 (which ships with Fedora 18). Unfortunately, Ubuntu Precise ships with p0 for some reason, and there's not a lot we can do about it. If you're using Precise, we recommend using Puppet Enterprise or installing a third-party Ruby package.

Versions marked as "Supported" are recommended by Puppet Labs and are under extensive automated test coverage. Other versions are not recommended and we make no guarantees about their performance with Puppet.

Prerequisites
-----

Puppet has a very small number of external dependencies:

Dependency | Puppet 2.x | Puppet 3.x
-----------|------------|-----------
[Facter][] | Required   | Required
[Hiera][]  | Optional   | Required
[rgen][]   |            | Optional

Rgen is only needed if you are using Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/latest/reference/lang_future.html). The official Puppet Labs packages will install it as a dependency.

[Facter]: http://www.puppetlabs.com/projects/facter/index.html
[Hiera]: https://github.com/puppetlabs/hiera
[rgen]: http://ruby-gen.org/downloads

All other prerequisite Ruby libraries should come with any standard Ruby 1.8.5+ install.  Should your OS not come with the complete standard library (or you are using a custom Ruby build), these include:

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

