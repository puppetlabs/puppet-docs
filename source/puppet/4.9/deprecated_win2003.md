---
layout: default
title: "Windows 2003 support is removed"
toc: false
---

Microsoft ended support for Windows Server 2003 and 2003 R2 on July 14, 2015. These operating system versions will not receive further security updates from Microsoft, and Puppet no longer supports them. For more information and help migrating from Windows Server 2003 and 2003 R2, see [Microsoft's end-of-life page.](https://www.microsoft.com/en-us/server-cloud/products/windows-server-2003/)

[Puppet 4.2](/puppet/4.2/) is the final version compatible with Server 2003 and 2003 R2. As of Puppet 4.3, the Puppet agent package fails to install on Windows Server 2003 and 2003 R2.

* Running 32-bit Puppet agent on a 64-bit Windows system was deprecated on December 31, 2016.