---
layout: default
title: " PE 3.2 » Razor » Overview"
subtitle: "Bare Metal Provisioning with Razor"
canonical: "/pe/latest/razor_intro.html"

---
[razor-1]: ./images/razor/razor-1.png
[razor-2]: ./images/razor/razor-2.png
[razor-3]: ./images/razor/razor-3.png
[razor-4]: ./images/razor/razor-4.png
[razor-5]: ./images/razor/razor-5.png

Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. Razor makes it easy to provision a node with no previously installed operating system and bring it under the management of Puppet Enterprise. 

##High-level Overview

Razor's policy-based bare-metal provisioning enables you to inventory and manage the lifecycle of your physical machines. With Razor, you can automatically discover bare-metal hardware, dynamically configure operating systems and/or hypervisors and hand nodes off to Puppet Enterprise for workload configuration. 

Razor policies use discovered characteristic of the underlying hardware and on user-provided data to make provisioning decisions. The following steps show a high-level view of provisioning a node with Razor.

**1 - Razor identifies a new node**

![bare node][razor-1]

**2 - The node is tagged**

![tags applied][razor-2]

**3 - The node tags match a Razor policy**

![tags compared to policies][razor-3]

**4 - Policies pull together all the provisioning elements**

![policies][razor-4]

**5 - The node is provisioned with the designated OS and managed with PE**

![policy applied][razor-5]


Provisioning with Razor roughly entails these steps:

+ [Set Up a Virtual Environment for Razor](./razor_prereqs)
+ [Install and set up a Razor server and Razor client](./razor_install.html)
+ [Create Razor objects and provision machines](./razor_using.html)

See [Setup Information and Known Issues](./razor_knownissues.html) for specific information about this release.


In addition to the above processes, learn more about:

+ [Razor broker typess](./razor_brokertypes.html)
+ [Razor tasks](./razor_tasks.html)
+ [Razor tags](./razor_tags.html)
+ [Razor command reference](./razor_reference.html)

 
###Razor As Tech Preview

This is a Tech Preview release of Razor. This means you are getting early access to Razor technology so you can test the functionality and provide feedback. However, this Tech Preview version of Razor is not intended for production use because Puppet Labs cannot guarantee Razor's stability. As Razor is further developed, functionality might be added, removed or changed in a way that is not backward compatible with this Tech Preview version.

For more information about Tech Preview software from Puppet Labs, see [Tech Preview](
http://puppetlabs.com/services/tech-preview).



[Next: Set Up a Virtual Environment for Razor](./razor_prereqs)