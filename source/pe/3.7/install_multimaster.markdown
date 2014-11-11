---
layout: default
title: "PE 3.7 » Installing » Additional Puppet Masters"
subtitle: "Additional Puppet Master Installation"
canonical: "/pe/latest/install_multimaster.html"
---

The following guide provides instructions for adding additional Puppet masters to large Puppet Enterprise deployments managing more than 1500 agent nodes. Using additional Puppet masters in such scenarios will provide quicker, more efficient compilation times as multiple masters can share request load when agent nodes run. 
 
Please be sure to review these procedures before beginning, as performing these steps out of order can cause problems for your configurations. 

In addition, please note the following about this guide:

- These instructions reference a split installation (separate servers for the Puppet master, PE console, and PuppetDB), which is the recommended installation type for managing more than 500 agent nodes.
- It’s assumed all servers are running the same OS and architecture.
- The following hostnames are used:
   - **Puppet master**: `master.example.com`.
   - **PE console**: `console.example.com`.
   - **PuppetDB**: `puppetdb.example.com`.
   - **Additional Puppet master**: `add.master.example.com`.

> **Prerequisite**: You need to be able to resolve hostnames between machines. 

### Step 1: Install Puppet Enterprise

1. Follow the [PE split installation documentation](./install_pe_split.html) to install PE.
2. Log in to the console. 
3. Continue to [Step 2: Install Additional Puppet Master Node](#step-2-install-additional-puppet-master-node).

### Step 2: Install Additional Puppet Master Node

In this step, you will install the additional Puppet agent on `add.master.example.com`. You must perform this step to install the Puppet agent one the new Puppet master node. 

**Warning**: This machine (e.g., the new Puppet master) should NOT already have a Puppet agent installed. 

**To install the additional Puppet master agent**:

1. SSH into `add.master.example.com` and run `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash -s main:dns_alt_names=<COMMA-SEPARATED LIST OF ALT NAMES FOR THE PUPPET MASTER> environmentpath=</etc/puppetlabs/puppet/environments OR YOUR MASTER'S ENVIRONMENT PATH>`. 

   **Note**: The `dns_alt_names` value should be set to a comma-separated list of any alternative names that may be used by Puppet agents to connect to the master. The installation uses "puppet" by default.

   This will install and configure the PE agent on `add.master.example.com`. 

2. From the command line of `master.example.com`, run `puppet cert --allow-dns-alt-names sign add.<MASTER.EXAMPLE.COM>`. 

   **Note**: You cannot use the console to sign certs for nodes with DNS alt names. 

3. From the command line on `add.master.example.com`, run `puppet agent -t`. 

4. Continue to [Step 3: Classify the New Puppet Master Node](#step-3-classify-the-new-puppet-master-node). 

### Step 3: Classify the New Puppet Master Node

[classification_selector]: ./images/quick/classification_selector.png

In this step, you will use the PE console to classify `add.master.example.com` so that it can function as a Puppet master.

**Important**: For fresh installations of PE 3.7.0, node groups in the classifier are created and configured during the installation process. For upgrades, these groups are created but no classes are added to them. This is done to help prevent errors during the upgrade process. If you’re performing these steps after an upgrade to 3.7.0, refer to [the PE Master group preconfiguration docs](./console_classes_groups_preconfigured_groups.html#the-pe-master-group) for a list of classes to add to the PE Master group to ensure your new Puppet master is properly classified.

**To classify the new master node**: 

1. From the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]

2. From the __Classification page__, select the __PE Master__ group.
3. From the __Rules__ tab, in the __Node name__ field, enter `add.master.example.com`.
4. Click __Pin node__. 
5. Click __Commit 1 change__. 
6. Continue to [Step 4: Run Puppet on Selected Nodes](#step-4-run-puppet-on-selected-nodes)

### Step 4: Run Puppet on Selected Nodes

In this step, you will need to run Puppet in the order specified so that certificate information for the new Puppet master can be added to PuppetDB's certificate whitelist. You will need to run Puppet on the PE console node for the RBAC whitelist as well.  

>**Important**: The following Puppet runs **MUST** be done in the order listed in the following steps. The new Puppet master (`add.master.example.com`) must complete a full Puppet run before you run Puppet on the PuppetDB and console nodes. 

**To run Puppet on selected nodes**: 

1. From the console, navigate to __Live Management__.
2. Select the __Control Puppet__ tab.
3. On the left-hand side of the __Live Management__ page, ensure no nodes are selected; click __Select none__.
4. From the node list, select **only** `add.master.example.com`. 
5. Select __runonce__.
6. Click __Run__ and wait until the run completes.

   **Tip**: To determine when the run is complete, click **return to action list**, then click **status**, then click **run**. The **message** parameter will indicate if PE is currently applying a catalog or is running. 


7. Repeat steps 3 - 6 to run Puppet only on `puppetDB.example.com`.
8. Repeat steps 3 - 6 to run Puppet only on `console.example.com`.

> **Done!** `add.master.example.com` is now a Puppet master node. To start using it, you will first need to add it to your load balancer. 

### A Note About Load Balancers

Load balancing is a critical need for PE deployments using multiple Puppet masters. Unfortunately, load balancer integration is beyond the scope of this document. However, when configuring load balancers with your PE masters, you need to ensure traffic can pass through port **8140**---this is the port that handles Puppet master and CA traffic.  

### A Note About File Syncing

In a multi-master environment, you want to make sure your manifests, modules, and any Hiera data are properly synced between Puppet masters.  Depending on your security and infrastructure needs, there are a range of options for setting up file syncing between your Puppet masters. We recommend choosing from one of the following methods: 

- [r10K](https://forge.puppetlabs.com/zack/r10k)
- Network File Systems (NFS)
- Remote Sync (rysnc)



