---
layout: default
title: "PE 3.7 » Installing » Additional ActiveMQ Hub and Spokes"
subtitle: "Additional ActiveMQ Hub and Spoke Installation"
canonical: "/pe/latest/install_add_activemq.html"
---

The following guide provides instructions for adding additional ActiveMQ hubs and spokes to large Puppet Enterprise deployments managing more than 1500 agent nodes. Building out your ActiveMQ brokers will provide efficient load balancing of network connections for relaying MCollective messages through your PE infrastructure.

Adding ActiveMQ hubs and spokes can be done in addition to, or independent from, adding [additional Puppet masters](./install_multimaster.html) to large deployments.

For more information about MCollective, refer to the [MCollective docs](/mcollective/index.html) and, more specifically, [ActiveMQ clustering](/mcollective/reference/integration/activemq_clusters.html#activemq-clustering).
 
Please be sure to review these procedures before beginning, as performing these steps out of order can cause problems for your configuration. 

In addition, please note the following about this guide:

- These instructions reference a split installation (separate servers for the Puppet master, PE console and PuppetDB), which is the recommended installation type for managing more than 500 agent nodes.
- It’s assumed all servers are running the same OS and architecture.
- The following hostnames are used:
   - **Puppet master**: `master.example.com`.
   - **PE console**: `console.example.com`.
   - **ActiveMQ hub**: `activemq-hub.example.com`.
   - **ActiveMQ broker 1**: `activemq.spoke1.example.com`.
   - **ActiveMQ broker 2**: `activemq.spoke2.example.com`.
   - **PE agent**: `agent.example.com`.

> **Important**: Ensure time is synced across all your nodes. 

Note that you can add as many ActiveMQ hubs and spokes and PE agents as necessary; simply repeat the appropriate steps. 

### Step 1: Install Puppet Enterprise

1. Follow the [PE split installation documentation](./install_pe_split.html) to install PE.
2. Log in to the console. 
3. Continue to [Step 2: Install Puppet Agent on Nodes](#step-2-install-puppet-agent-on-nodes).


### Step 2: Install Puppet Agent on Nodes

In this step, you'll install the Puppet agent on `activemq-hub.example.com`, `activemq.spoke1.example.com`, `activemq.spoke2.example.com`, and `agent.example.com`. You must perform this step so that each machine has a Puppet agent installed. 

**To install the Puppet agent**:

1. SSH into each node and `curl -k https://<MASTER.EXAMPLE.COM>:8140/packages/current/install.bash | sudo bash -s agent:ca_server=<MASTER.EXAMPLE.COM>`.

   This will install and configure the Puppet agent on the nodes.

2. From the console, locate and sign the certificate request and sign the request for each node. 

3. Continue to [Step 3: Create the ActiveMQ Hub Group](#step-3-create-the-activemq-hub-group). 

### Step 3: Create the ActiveMQ Hub Group 

In this step, you'll use the PE console to create the ActiveMQ Hub group.

[classification_selector]: ./images/quick/classification_selector.png

**To create the ActiveMQ Hub group**:

1. From the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]
   
2. From the __Classification__ page, in the **Node group name** field, name the ActiveMQ Hub group (e.g., `PE ActiveMQ Hub`). 
3. From the __Parent name__ drop-down menu, select **PE Infrastructure**.
4. Click __Add group__.
5. Select the __PE ActiveMQ Hub__ group.
6. In the __Node name__ field, enter `activemq-hub.example.com`.
7. Click __Pin node__.
8. Click the __Classes__ tab.
9. In the __class name__ field, add `puppet_enterprise::profile::amq::hub`.
10. Click __Add class__ , and then __Commit changes__. 
11. Run Puppet on `activemq-hub.example.com`.

    a. From the console, navigate to __Live Management__.
   
    b. Select the __Control Puppet__ tab.
   
    c. Select `activemq-hub.example.com`.
   
    d. Select __runonce__.
   
    e. Click __Run__.

12. Continue to [Step 4: Add Additional Spokes to ActiveMQ Broker Group](#step-4-add-additional-spokes-to-activemq-broker-group). 

### Step 4: Add Additional Spokes to ActiveMQ Broker Group

In this step, you'll use the PE console to add `activemq.spoke1.example.com` and `activemq.spoke2.example.com` to the __PE ActiveMQ Broker__ group, which is configured during the installation of PE.

> **Important**: For fresh installations of PE 3.7.0, node groups in the classifier are created and configured during the installation process. For upgrades, these groups are created but no classes are added to them. This is done to help prevent errors during the upgrade process. If you’re performing these steps after an upgrade to 3.7.0, refer to [the PE Master group preconfiguration docs](./console_classes_groups_preconfigured_groups.html#the-pe-master-group) for a list of classes to add to ensure your new groups are properly classified.

**To add additional spokes to PE ActiveMQ Broker group**:  

1. From the __Classification__ page, click the __PE ActiveMQ Broker__ group.
2. Ensure you've selected the __Rules__ tab.
3. In the __Node name__ field, enter `activemq.spoke1.example.com` and `activemq.spoke2.example.com`. 
4. Click __Pin node__ , and then __Commit change__.
5. Run Puppet on `activemq.spoke1.example.com` and `activemq.spoke2.example.com`.

   a. From the console, navigate to __Live Management__.
   
   b. Select the __Control Puppet__ tab.
   
   c. Select the node(s) to run Puppet on.
   
   d. Select __runonce__.
   
   e. Click __Run__.

6. After each spoke's Puppet run completes, run Puppet on `activemq-hub.example.com`.

   > **Note**: The Puppet master (e.g., `master.example.com`) is, by default, already an MCollective broker. If needed, you can unpin it from the __PE ActiveMQ Broker__ group. 
   
7. Continue to [Step 5: Configure MCollective to Communicate With Additional Spokes](#step-5-configure-mcollective-to-communicate-with-additional-spokes).

### Step 5: Configure MCollective to Communicate With Additional Spokes

In this step, you'll use the the PE console to configure connections between your ActiveMQ spokes and MCollective. 

1. From the __Classification__ page, click the __PE MCollective__ group. 
2. Click the __Classes__ tab.
3. Under __Class: puppet_enterprise::profile::mcollective::agent__, from the __Parameter__ drop-down list, select __activemq_brokers__.
4. In the value field, set value to ["master.example.com", "activemq.spoke1.example.com", "activemq.spoke2.example.com"]
5. Click __Add parameter__, and then __Commit change__.
6. Run Puppet on the ActiveMQ hub and spokes (including the Puppet master) and on any PE agents, or wait for a scheduled run.
7. Continue to [Step 6: Verify Connections](#step-6-verify-connections). 

> Note: Depending on the scale of your infrastructure and security requirements, the __activemq_brokers__ parameter might need to be set for nodes in each data center, location, or subnet you have.

### Step 6: Verify Connections 

You're just about finished! The following steps will help you verify all connections have been correctly established. 

1. To verify the __MCollective__ group is correctly set up, go to `master.example.com` and run `su peadmin` and then `mco ping`.

   You should see the ActiveMQ hub and spokes (including the Puppet master) and any PE agents listed. 
   
2. To verify the ActiveMQ hub's connections are correctly established, go to `activemq-hub.example.com` and run `netstat -an | grep '61616'`.

   You should see that the ActiveMQ hub has connections set up between the ActiveMQ broker nodes. 
   
> **Tip**: if you need to increase the number of processes the `pe-activemq` user can open/process, refer to [Increasing the ulimit for the `pe-activemq` User](./trouble_orchestration.html#increasing-the-ulimit-for-the-pe-activemq-user) for instructions. 


