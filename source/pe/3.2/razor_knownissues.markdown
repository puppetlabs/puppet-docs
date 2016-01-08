---
layout: default
title: " PE 3.2 » Razor » Setup Recommendations and Known Issues"
subtitle: "Setup Information and Known Issues"
canonical: "/pe/latest/razor_knownissues.html"

---
## Important Setup Information

+ Razor has been specifically tested in the following setups/environments: RHEL/CentOS 6.4 
+ The Razor microkernel is 64-bit only. Razor can only provision 64-bit machines.
+ Razor has a minimum RAM requirement of 512MB. 

To successfully use a machine with Razor and install an operating system on it, the machine must:
+ Be supported by the operating system to be installed on it.
+ Be able to successfully boot into the microkernel, which is based on Fedora 19.
+ Be able to successfully boot the iPXE firmware.

#### Using Razor
The repo contains the actual bits that are used when installing a node; the installation instructions are contained in tasks. Razor comes with a few predefined tasks to get you started. They can be found in the `tasks/ directory` in the razor-server repo, and they can all be used by simply mentioning their name in a policy. This includes the `vmware_esxi` installer.

## Known Issues

### Razor client cannot be installed with Ruby < 1.9.2.
A new release of rest-client requires Ruby versions later than 1.9.2. Because the Razor client is dependent on rest-client, it also has that requirement.

### Razor doesn't handle local time jumps 
The Razor server is sensitive to large jumps in the local time, like the one that is experienced by a VM after it has been suspended for some time and then resumed. In that case, the server will stop processing background tasks, such as the creation of repos. To remediate that, restart the server with `service pe-razor-server restart`.

### JSON warning
When you run Razor commands, you might get this warning: "MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."

You can disregard the warning since this situation is completely harmless. However, if you're using Ruby 1.8.7, you can install a separate JSON library, such as json_pure, to prevent the warning from appearing.

### Razor hangs in VirtualBox 4.3.6
We're finding that VirtualBox 4.3.6 gets to the point of downloading the microkernel from the Razor server and hangs at 0% indefinitely. We don't have this problem with VirtualBox 4.2.22. 

### Using Razor on Windows
Windows support is **ALPHA** quality. The purpose of the current Windows installer is to get real world experience with Windows installation automation, and to discover the missing features required to fully support Windows infrastructure. 

### Temp files aren't removed in a timely manner
This is due to Ruby code working as designed, and while it takes longer to remove temporary files than you might expect, the files are eventually removed when the object is finalized.

### The "no_replace" parameter is ignored for the "update-node-metadata" command
This parameter is not currently working.

### Confusing POST error message
If you provide an empty string to the `--iso-url` parameter of the `create-repo` command, the Razor client returns a confusing error message:

	Error from doing POST http://rg-razor.delivery.puppetlabs.net:8080/api/commands/create-repo
	400 Bad Request
	urls only one of url and iso_url can be used

The error is meant to indicate that you cannot supply both those attributes at the same time on a single repo instance.

### Updates might be required for VMware ESXi 5.5 igb files
You might have to update your VMware ESXi 5.5 ISO with updated igb drivers before you can install ESXi with Razor. See this [driver package download page on the VMware site](https://my.vmware.com/web/vmware/details?downloadGroup=DT-ESXI55-INTEL-IGB-42168&productId=353) for the updated igb drivers you need.

* * *

 [Next: Cloud Provisioning Overview](./cloudprovisioner_overview.html)