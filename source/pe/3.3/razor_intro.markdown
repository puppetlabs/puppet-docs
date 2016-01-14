---
layout: default
title: " PE 3.3 » Razor » Overview"
subtitle: "Bare-Metal Provisioning with Razor"
canonical: "/pe/latest/razor_intro.html"

---
[razor-1]: ./images/razor/razor-1.png
[razor-2]: ./images/razor/razor-2.png
[razor-3]: ./images/razor/razor-3.png
[razor-4]: ./images/razor/razor-4.png
[razor-5]: ./images/razor/razor-5.png


## Introducing Razor

Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. Razor makes it easy to provision a node with no previously installed operating system and bring it under the management of Puppet Enterprise (PE). 

Razor's policy-based bare-metal provisioning lets you inventory and manage the lifecycle of your physical machines. With Razor, you can automatically discover bare-metal hardware, dynamically configure operating systems and/or hypervisors, and hand nodes off to PE for workload configuration. 

Razor policies use discovered characteristics of the underlying hardware and user-provided data to make provisioning decisions. 

#### Razor As Tech Preview

This is a Tech Preview release of Razor. This means you are getting early access to Razor technology so you can test the functionality and provide feedback. However, this Tech Preview version of Razor is not intended for production use because Puppet Labs cannot guarantee Razor's stability. As Razor is further developed, functionality might be added, removed or changed in a way that is not backward compatible with this Tech Preview version.

For details about Tech Preview software from Puppet Labs, visit [Tech Preview Features Support Scope](http://puppetlabs.com/services/tech-preview).


## How Razor Works
The following steps provide a high-level view of the process for provisioning a node with Razor.

### Razor identifies a new node

![bare node][razor-1]

When a new node appears, Razor discovers its characteristics by booting it with the Razor microkernel and inventorying its facts.

### The node is tagged

![tags applied][razor-2]

The node is tagged based on its characteristics. Tags contain a match condition &#8212; a Boolean expression that has access to the node's facts and determines whether the tag should be applied to the node or not.

### The node tags match a Razor policy

![tags compared to policies][razor-3]

Node tags are compared to tags in the policy table. The first policy with tags that match the node's tags is applied to the node.

### Policies pull together all the provisioning elements

![policies][razor-4]


### The node is provisioned with the designated OS and managed with PE

![policy applied][razor-5]

The node is now installed and managed by Puppet Enterprise.

### Getting Started With Razor

Provisioning with Razor generally entails these steps:

+ [Set up a virtual environment for Razor](./razor_prereqs.html)
+ [Install and set up a Razor server and Razor client](./razor_install.html)
+ [Create Razor objects and provision machines](./razor_using.html)

See [Setup Information and Known Issues](./razor_knownissues.html) for specific information about this release.


In addition to the above processes, you can learn more about:

+ [Razor broker types](./razor_brokertypes.html)
+ [Razor tasks](./razor_tasks.html)
+ [Razor tags](./razor_tags.html)
+ [Razor command reference](./razor_reference.html)


 * * *


[Next: Set Up a Virtual Environment for Razor](./razor_prereqs.html)