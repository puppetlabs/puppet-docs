---
layout: default
title: " PE 3.2 » Razor » Setup Recommendations and Known Issues"
subtitle: "Setup Recommendations and Known Issues"
canonical: "/pe/latest/razor_knownissues.html"

---
##Recommended Setup

Razor has been tested in the following setups/environments:

+ RHEL/CentOS 6.4 

Razor supports 64-bit systems only. This means that you can only provision 64-bit machines with Razor as well.


##Known Issues

**Razor doesn't handle local time jumps** The Razor server is sensitive to large jumps in the local time, like the one that is experienced by a VM after it has been suspended for some time and then resumed. In that case, the server will stop processing background tasks, such as the creation of repos. To remediate that, restart the server by issuing the command `service pe-razor-server restart`.

**JSON warning** When you run Razor commands, you might get this warning: "MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."

This situation is completely harmless. However, if you're using Ruby 1.8.7, you can install a separate JSON library, such as json_pure, to make the warning go away.

**Razor hangs in VirtualBox 4.3.6** We are finding that VirtualBox 4.3.6 gets to the point of downloading the microkernel from the Razor server and hangs at 0% indefinitely. We don't have this problem  with VirtualBox 4.2.22. 

**Using Razor on Windows** Windows support is ALPHA quality. The purpose of the current Windows installer is to get real world experience with Windows installation automation, and to discover the missing features required to truly support the Windows world.