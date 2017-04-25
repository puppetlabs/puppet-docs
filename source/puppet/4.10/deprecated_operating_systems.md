---
layout: default
title: "Deprecated operating systems"
toc: false
---

Open source Puppet ships `puppet-agent` packages for a variety of platforms, but some systems have been deprecated since we began shipping them, and we will no longer be providing packages for those systems. 

Deprecations in Puppet 4.x:

* Fedora 22 reached end of life (EOL) on July 19, 2016. We stopped shipping `puppet-agent` packages for Fedora 22 as of Puppet 4.8.

* Running 32-bit Puppet agent on a 64-bit Windows system was deprecated on December 31, 2016. 

* Microsoft ended support for Windows Server 2003 and 2003 R2 on July 14, 2015. These operating system versions will not receive further security updates from Microsoft, and Puppet no longer supports them. For more information and help migrating from Windows Server 2003 and 2003 R2, see [Microsoft's end-of-life page.](https://www.microsoft.com/en-us/server-cloud/products/windows-server-2003/)

  [Puppet 4.2](/puppet/4.2/) is the final version compatible with Server 2003 and 2003 R2. As of Puppet 4.3, the Puppet agent package fails to install on Windows Server 2003 and 2003 R2.

* Ubuntu 12.04 reached EOL April 2017, and Puppet 4.10 is the last version we will ship packages for it.


Upcoming deprecations:

* Fedora 23 - Reached EOL by Fedora December 12, 2016.

* Windows Vista - As of April 11, 2017, Microsoft's "Extended Support" ends.

You can see Puppet's [system requirements](./system_requirements.html) to see systems we're currently publishing packages for.

