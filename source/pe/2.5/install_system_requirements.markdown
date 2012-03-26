---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Installing » System Requirements"
subtitle: "System Requirements"
---

Operating System
-----

Puppet Enterprise 2.0 supports the following systems:

|       Operating system       |  Version          |       Arch        |   Roles   |
|------------------------------|-------------------|-------------------|-----------|
| Red Hat Enterprise Linux     | 5 and 6           | x86 and x86\_64   | all roles |
| CentOS                       | 5 and 6           | x86 and x86\_64   | all roles |
| Ubuntu LTS                   | 10.04             | 32- and 64-bit    | all roles |
| Debian                       | Squeeze (6)       | i386 and amd64    | all roles |
| Oracle Linux                 | 5 and 6           | x86 and x86\_64   | all roles |
| Scientific Linux             | 5 and 6           | x86 and x86\_864  | all roles |
| SUSE Linux Enterprise Server | 11                | x86 and x86\_864  | all roles |
| Solaris                      | 10                | SPARC and x86\_64 | agent     |
| Microsoft Windows            | 2003, 2008, and 7 | x86 and x86\_864  | agent     |

Hardware
-----

Puppet Enterprise's hardware requirements depend on the roles a machine performs. 

* The **puppet master** role should be installed on a robust, dedicated server.
    * Minimum requirements: 2 processor cores, 1 GB RAM, and very accurate timekeeping.
    * Recommended requirements: Physical hardware or Xen or KVM virtual server, with 2-4 processor cores and 4 GB RAM. Performance will vary, but this configuration can generally manage approximately 1,000 agent nodes. 
* The **console** role should usually be installed on a separate server from the puppet master, but can optionally be installed on the same server.
    * Minimum requirements: A machine able to handle moderate web traffic, perform processor-intensive background tasks, and run a disk-intensive MySQL database server. Requirements will vary significantly depending on the size and complexity of your site.
* The **cloud provisioner** role has very modest requirements.
    * Minimum requirements: A system which provides interactive shell access for trusted users.
* The **puppet agent** role has very modest requirements.
    * Minimum requirements: Any hardware able to comfortably run a supported operating system.

* * *

Next: [Installing: Preparing to Install](./install_preparing.html) &rarr;
