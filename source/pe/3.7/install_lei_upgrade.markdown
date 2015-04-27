---
layout: default
title: "PE 3.7 » Installing » Upgrading LEI"
subtitle: "Upgrading Large Environment Installations"
canonical: "/pe/latest/install_multimaster_upgrade.html"
---

Upgrading your large environment installation (LEI) involves a combination of steps that you must perform across your core Puppet Enterprise components, your compile masters, and your ActiveMQ hubs and spokes. 

This doc details the steps you’ll need to take to upgrade your LEI from PE 3.7.0 to 3.7.2.

>### A Note about this Procedure and Load Balancers
>
>In this procedure MASTER.EXAMPLE.COM refers to the Puppet Master/CA server, also known as the master of masters (MoM). 
>
>However, in some cases, you may be [using a load balancer in your LEI](./install_multimaster.html#using-load-balancers-in-a-large-environment-installation). If this is the case, you’ll need to point the agent install script at the correct machines when you upgrade agents on the compile masters, ActiveMQ hubs and spokes, and Puppet agent nodes, as detailed in that section. If you followed those steps, the compile masters will point their upgrade scripts at MASTER.EXAMPLE.COM (or the MoM), and the remaining agents will point at LOADBALANCER.EXAMPLE.COM (which has inherited the `pe_repo` class from the PE Master group). The exact guidance will vary depending on your exact setup. 
  
**To upgrade your large environment installation**:   

### Step 1: Upgrade PE

Follow the [upgrade instructions](./install_upgrading.html#upgrading-a-split-installation) to upgrade the core PE components (the main Puppet master, PuppetDB, and the PE console). 

### Step 2: Upgrade each Puppet compile master.

1. SSH into each Puppet compile master, and stop PE-related services with the following commands:

        puppet resource service pe-puppet ensure=stopped
        puppet resource service pe-puppetserver ensure=stopped
        
2. On each compile master, upgrade the agent by running the agent install script.

   `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash`
   
3. On each compile master, restart PE-related services and run Puppet on the agent with the following commands:

       puppet resource service pe-puppet ensure=running
       puppet resource service pe-puppetserver ensure=running
       puppet agent -t
 
### Step 3: Upgrade each ActiveMQ hub.

1. SSH into each ActiveMQ hub, and stop PE-related services with the following commands:

       puppet resource service pe-puppet ensure=stopped
       puppet resource service pe-activemq ensure=stopped
        
2. On each ActiveMQ hub, upgrade the agent by running the agent install script. 
   
   `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash`
   
3. On each ActiveMQ hub, restart PE-related services and run Puppet on the agent with the following commands:

       puppet resource service pe-puppet ensure=running
       puppet resource service pe-activemq ensure=running
       puppet agent -t

### Step 4: Upgrade each ActiveMQ spoke.

1. SSH into each ActiveMQ spoke, and stop PE-related services with the following commands:

       puppet resource service pe-puppet ensure=stopped
       puppet resource service pe-activemq ensure=stopped
        
2. On each ActiveMQ spoke, upgrade the agent by running the agent install script.

      `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash` 
      
3. One each ActiveMQ spoke, restart PE-related services and run Puppet on the agent with the following commands:

       puppet resource service pe-puppet ensure=running
       puppet resource service pe-activemq ensure=running
       puppet agent -t
        
### Step 5: Upgrade Dashboard Workers

If you've installed additional dashboard workers, upgrade each one.

1. SSH into each additional dashboard worker, and stop PE-related services with the following commands:

       puppet resource service pe-puppet ensure=stopped
       puppet resource service pe-puppet-dashboard-workers ensure=stopped
        
2. On each dashboard worker, upgrade the agent by running the agent install script.

     `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash` 
     
3. On each dashboard worker, restart PE-related services and run Puppet on the agent with the following commands:

       puppet resource service pe-puppet ensure=running
       puppet resource service pe-puppet-dashboard-workers ensure=running
       puppet agent -t
       
### Step 6: Upgrade Puppet Agent Nodes

Follow the [agent upgrade documentation](./install_agents.html) to upgrade the Puppet agent nodes in your LEI. 
