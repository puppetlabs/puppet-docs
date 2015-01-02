---
layout: default
title: "PE 3.7.1 » Installing » Adding Dashboard Workers"
subtitle: "Adding Dashboard Workers to Your PE Deployment"
canonical: "/pe/latest/install_add_dashboard_workers.html"
---

PE 3.7.x includes the class `puppet_enterprise::profile::console::workers`, which allows you to deploy standalone *dashboard worker* nodes to speed up report processing for the PE console.

It's fairly trivial to take advantage of this functionality. You simply need to install the PE agent on nodes you want to act as dashboard workers, and then use the PE console to classify those nodes. 

> **Note**: If you are performing this procedure after upgrading to PE 3.7.1, you'll need to set some parameters in the `puppet_enterprise` class in the **PE Infrastructure** node group. Check the [preconfigured PE Infrastructure Node Group](./console_classes_groups_preconfigured_groups.html#the-pe-infrastructure-node-group) for details. 

### Step 1: Set up nodes

Install PE Agent on Nodes

Follow the [agent install instructions](./install_agents.html) to set up the PE agent on the machines you want to become your dashboard worker node group. 

The nodes in the dashboard worker group should be running the same OS/architecture as the node assigned the PE console component. 

### Step 2: Set up the dashbboard worker group in the PE console

1. In the PE console, create the dashboard worker group. 

   a. From the console, click **Classification** in the navigation bar.
   
   b. In the **Node group name** field, name your group (e.g., **PE Dashboard Workers**).
   
   c. From the **Parent** name drop-down list, select **PE Infrastructure**.
   
   d. Click **Add group**.
   
   e. Click the **Commit change** button.
   
2. Select **PE Dashboard Workers** from the list of node groups. 

3. Click the **Classes** tab.

4. In the **Class name** field, enter `puppet_enterprise::profile::console::workers`, and then click **Add class**. 

5. From the **Parameter** drop-down list, select **database_password**, and in the **Value** field, enter the password for the PE console database.

6. Click **Add parameter**.

7. Click the **Commit changes** button. 

8. Click the **Matching nodes** tab. 

9. Under **Certname**, in the **Node name** field, enter the FQDN for each node you want to add to the group, and click **Pin node**. 

   **Note**: You will need to enter each node individually.

10. Click the **Commit changes** button.

11. Use **Live Management** to run Puppet on the nodes in the **PE Dashboard Workers** group. 

> That's it! You now have a fleet of dashboard workers!
