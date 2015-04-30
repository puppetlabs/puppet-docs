---
layout: default
title: "PE 3.8 » Installing » Upgrading LEI"
subtitle: "Upgrading Large Environment Installations"
canonical: "/pe/latest/install_multimaster_upgrade.html"
---

Upgrading your large environment installation (LEI) involves a combination of steps that you must perform across your core Puppet Enterprise (PE) components, your compile masters, and your ActiveMQ hubs and spokes. 

This doc details the steps you’ll need to take to upgrade your LEI from PE 3.7.2 to 3.8.0.
 
>#### A note about load balancers
>
>In this procedure MASTER.EXAMPLE.COM refers to the Puppet Master/CA server, also known as the master of masters (MoM). 
>
>However, in some cases, you may be using a load balancer in your LEI. If this is the case, you’ll need to point the agent install script at the correct machines when you upgrade agents on the compile masters, ActiveMQ hubs and spokes, and Puppet agent nodes, as detailed in [the load balancer documentation](./install_multimaster.html#using-load-balancers-in-a-large-environment-installation). If you followed those steps, the compile masters will point their upgrade scripts at MASTER.EXAMPLE.COM (or the MoM), and the remaining agents will point at LOADBALANCER.EXAMPLE.COM (which has inherited the `pe_repo` class from the PE Master group). The exact instructions will vary depending on your setup. 
  
**To upgrade your large environment installation**:   

### Step 1: Upgrade PE

Follow the [upgrade instructions](./install_upgrading.html#upgrading-a-split-installation) to upgrade the core PE components (the main Puppet master, PuppetDB, and the PE console). 

### Step 2: Upgrade Each Puppet Compile Master

SSH into each Puppet compile master, and run the following command:   

  `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/upgrade.bash | sudo bash`

### Step 3: Upgrade Each ActiveMQ Hub

SSH into each ActiveMQ hub, and run the following command:   

  `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/upgrade.bash | sudo bash`

### Step 4: Upgrade Each ActiveMQ Spoke

SSH into each ActiveMQ spoke, and run the following command:   

  `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/upgrade.bash | sudo bash`
        
### Step 5: Upgrade Dashboard Workers

If you've installed additional dashboard workers, upgrade each one.

SSH into each additional dashboard worker, and run the following command:   

  `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/upgrade.bash | sudo bash`
       
### Step 6: Upgrade Puppet Agent Nodes

Follow the [agent upgrade documentation](./install_agents.html) to upgrade the Puppet agent nodes in your LEI. 
