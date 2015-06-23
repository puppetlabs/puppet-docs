---
layout: default
title: "Windows 2003 Support is Deprecated"
toc: false
---


Microsoft's end of support deadline for Windows Server 2003 and 2003R2 is July 14, 2015. This is the end of OS security updates for these versions, and Puppet Labs will stop supporting them once Microsoft does. [Microsoft's page about the Server 2003 end-of-life has more info.](http://www.microsoft.com/en-us/server-cloud/products/windows-server-2003/)

Our plan is that the Puppet 4.x series will continue to work with Windows 2003 and 2003R2, but the installer and upgrader will issue deprecation warnings.

Once Puppet 5 is released, Windows 2003/2003R2 will be officially unsupported; we won't prevent Puppet from installing or running, but we might remove 2003-specific functionality, and we will be removing all 2003-specific information from Puppet 5's documentation.

