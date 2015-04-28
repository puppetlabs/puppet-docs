---
layout: default
title: " PE 3.8 » Razor » Overview"
subtitle: "Bare-Metal Provisioning with Razor"
canonical: "/pe/latest/razor_intro.html"

---
[razor-1]: ./images/razor/razor-1.png
[razor-2]: ./images/razor/razor-2.png
[razor-3]: ./images/razor/razor-3.png
[razor-4]: ./images/razor/razor-4.png
[razor-5]: ./images/razor/razor-5.png


##Introducing Razor

Razor is an advanced provisioning application that can deploy bare metal systems. Razor makes it easy to provision a node with no previously installed operating system and bring it under the management of Puppet Enterprise (PE).

Razor's policy-based bare-metal provisioning lets you inventory and manage the lifecycle of your physical machines. With Razor, you can automatically discover bare-metal hardware, dynamically configure operating systems and/or hypervisors, and hand nodes off to PE for workload configuration.

Razor policies use discovered characteristics of the underlying hardware and user-provided data to make provisioning decisions.

>**Note**: Be aware that Razor is designed to take over provisioning for your infrastructure, so if you're planning on deploying it into an existing environment, you should read and understand the [caveats](./razor_brownfield.html) first.

##How Razor Works
The following steps provide a high-level view of the process for provisioning a node with Razor.

###Razor identifies a new node

![bare node][razor-1]

When a new node appears, Razor discovers its characteristics by booting it with the Razor microkernel and using Facter to inventory its facts.

###The node is tagged

![tags applied][razor-2]

The node is tagged based on its characteristics. Tags contain a match condition &#8212; a Boolean expression that has access to the node's facts and determines whether the tag should be applied to the node or not.

###The node tags match a Razor policy

![tags compared to policies][razor-3]

Node tags are compared to tags in the policy table. The first policy with tags that match the node's tags is applied to the node.

###Policies pull together all the provisioning elements

![policies][razor-4]


###The node is provisioned with the designated OS and managed with PE

![policy applied][razor-5]

The node is now installed and managed by Puppet Enterprise.

###Getting Started With Razor

Provisioning with Razor generally entails these steps:

+ [Set up a Razor environment](./razor_prereqs.html)
+ [Install and set up a Razor server and Razor client](./razor_install.html)
+ [Learn About Razor Objects](./razor_objects.html)
+ [Create Razor objects and provision a node](./razor_using.html)

The Razor documentation also covers these topics:

+ [Safety Tips for Provisioning in a Brownfield Environment](./razor_brownfield.html)
+ [Make Razor API Calls Secure](./razor_secure_apis.html)
+ [Setting Up and Installing Windows on Nodes](./razor_windows_install.html)
+ [Writing Broker Types](./razor_brokertypes.html)
+ [Razor Command Reference](./razor_reference.html)



 * * *


[Next: Set Up a Razor Environment](./razor_prereqs.html)
