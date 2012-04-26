---
layout: default
title: Supported Platforms
---

Supported Platforms
===================

For information about Puppet Enterprise's system requirements, [see here][pe2requirements].

[pe2requirements]: /pe/2.5/install_system_requirements.html

Puppet 2.6 and 2.7 can run on the following platforms: 

Linux
-----

-   Red Hat Enterprise Linux, version 4 and higher
-   CentOS, version 4 and higher
-   Scientific Linux, version 4 and higher
-   Oracle Linux, version 4 and higher
-   Debian, version 5 (Lenny) and higher
-   Ubuntu, version 8.04 LTS and higher
-   Fedora, version 15 and higher
-   SUSE Linux Enterprise Server, version 11 and higher
-   Gentoo Linux
-   Mandriva Corporate Server 4 <!-- Version not checked recently -->
-   ArchLinux

BSD
---

-   FreeBSD 4.7 and later <!-- Version not checked recently -->
-   OpenBSD 4.1 and later <!-- Version not checked recently -->

Other Unix
----------

-   Mac OS X, version 10.4 (Tiger) and higher
-   Oracle Solaris, version 10 and higher
-   AIX, version 5.3 and higher
-   HP-UX

Windows
-------

-   Windows Server 2003 and 2008 (Puppet version 2.7.6 and higher)

Ruby Versions
-----

Puppet requires [Ruby](http://www.ruby-lang.org/en/). Certain versions of Ruby work better with Puppet than others.

* [Puppet Enterprise](/pe/) does not rely on the OS's Ruby version, as it maintains its own Ruby environment. You can install PE alongside any version of Ruby or on systems without Ruby installed.
* Ruby 1.8.7 and 1.8.5 are fully supported with Puppet 2.6 and 2.7, and Puppet Labs runs automated tests on both of these versions.
* Ruby 1.9.3 and higher are supported with Puppet 2.7, and Puppet Labs runs automated tests on version 1.9.3. 
* Ruby 1.8.6, 1.9.0, and 1.9.1 have significant compatibility issues with Puppet, and there are no plans to make Puppet work with these versions.
* Ruby 1.9.2 may work with Puppet 2.7, but Puppet Labs does not perform automated testing on it.

Please [contact Puppet Labs](http://puppetlabs.com/contact/) if you are interested in a platform not on this list.


