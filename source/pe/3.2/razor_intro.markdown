---
layout: default
title: " PE 3.2 » Razor » Overview"
subtitle: "Bare Metal Provisioning with Razor"
canonical: "/pe/latest/razor_intro.html"

---
Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. It's aimed at solving the problem of how to bring new computers into a state that your existing configuration management system, Puppet Enterprise, can then take over. 


##High-level Overview

Razor's policy based bare metal provisioning enables you to automate more phases of the IT infrastructure lifecycle.  With Razor, you can automatically discover bare-metal hardware, dynamically configure operating systems and/or hypervisors and hand nodes off to Puppet Enterprise for workload configuration. In addition, you can build complex lifecycles; for example, you can set Razor to perform a secure wipe upon decommissioning machines.

Razor policies contain the provisioning setup. 

<graphic 1>

Tags -- Boolean expressions that use node facts and metadata -- are used to match nodes and policies. When a match is identified, the policy's tasks are applied to the node. 

<graphic 2>

The process for provisioning with Razor roughly follows these steps:

+ [Set Up a Virtual Environment for Razor](./razor_prereqs)
+ [Install and set up a Razor server and Razor client](./razor_install.html)
+ [Create Razor objects and provision machines](./razor_using.html)


In addition to the above processes, learn more about:

+ [Razor objects](./razor_objects.html)
+ [Razor broker typess](./razor_brokertypes.html)
+ [Write Razor tasks](./razor_tasks.html)
+ [Razor command reference](./razor_reference.html)

 
###Razor As Tech Preview

This is a Tech Preview release of Razor. This means you are getting early access to Razor technology so you can test the functionality and provide feedback. However, this Tech Preview version of Razor is not intended for production use because Puppet Labs cannot guarantee Razor's stability. As Razor is further developed, functionality might be added, removed or changed in a way that is not backward compatible with this Tech Preview version.

For more information about Tech Preview software from Puppet Labs, see <link to be written>.



[Next: Set Up a Virtual Environment for Razor](./razor_prereqs)