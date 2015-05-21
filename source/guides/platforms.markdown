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

Puppet 3.x can run on the following platforms:

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
Certain versions of Ruby work better with Puppet than others, and some versions are not supported at all. Run `ruby --version` to check the version of Ruby on your system.

> [Puppet Enterprise](/pe/) does not rely on the OS's Ruby version, as it maintains its own Ruby environment. You can install PE alongside any version of Ruby or on systems without Ruby installed.

> ![windows logo](/images/windows-logo-small.jpg) The [Windows installers](http://downloads.puppetlabs.com/windows) provided by Puppet Labs don't rely on the OS's Ruby version, and can be installed alongside any version of Ruby or on systems without Ruby installed.

Ruby version | Puppet 3.x
-------------|-----------
2.1.x        | Supported (3.5 and higher)
2.0.x        | Supported (3.2 and higher)
1.9.3\*      | Supported
1.9.2        | No
1.9.1        | No
1.9.0        | No
1.8.7        |  Supported

> \* Ruby 1.9.3-p0 has bugs that cause a number of known issues with Puppet, and you should use a different release. To the best of our knowledge, these issues were fixed in the second public release of Ruby 1.9.3 (p125), and we are positive they are resolved in p392 (which shipped with Fedora 18). Unfortunately, Ubuntu Precise ships with p0 for some reason, and there's not a lot we can do about it. If you're using Precise with puppet 3.x, we recommend using Puppet Enterprise or installing a third-party Ruby package.

Versions marked as "Supported" are recommended by Puppet Labs and are under extensive automated test coverage. Other versions are not recommended and we make no guarantees about their performance with Puppet.

Prerequisites
-----

Puppet has a very small number of external dependencies:

Dependency | Puppet 3.x
-----------|-----------
[Facter][] | Required
[Hiera][]  | Required
[rgen][]   | Optional

Rgen is only needed if you are using Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/latest/reference/lang_future.html). The official Puppet Labs packages will install it as a dependency.

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

