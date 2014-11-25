---
layout: default
title: "PE 3.7 » Console » Grouping and Classifying Nodes"
subtitle: "Making Changes in the Node Classifier"
canonical: "/pe/latest/console_classes_groups_making_changes.html"
---


[environment_override]: ./console_classes_groups_environment_override.html

## Deleting Nodes

There are three options for deleting a node: 
<dl>
<dt>Hide</dt>
<dd>Removes the node from the node list view. To hide a node: 
<ol>
<li>On the <strong>Nodes</strong> page, click the node.</li>
<li>Click <strong>Hide</strong>.</li>
</ol>
</dd>
<dt>Delete</dt>
<dd>Removes all reports and information for the node from the console. The node no longer appears in the list of nodes on the <strong>Nodes</strong> page, but it continues to appear in <strong>Matching nodes</strong> until it is <a href="/puppetdb/2.2/maintain_and_tune.html#deactivate-decommissioned-nodes">purged from PuppetDB</a>. The node will reappear as a new node on the <strong>Nodes</strong> page if it submits a new Puppet run report. To delete a node:
<ol>
<li>On the <strong>Nodes</strong> page, click the node.</li>
<li>Click <strong>Delete</strong>.</li>
</ol>
</dd>
<dt>Deactivate</dt>
<dd>Completely deactivates the node and frees up the license assigned to the node. Any deactivated node will be reactivated if PuppetDB receives new catalogs or facts for it. For details, see <a href="./node_deactivation.html">Deactivating a PE agent node</a>.</dd>
</dl>

## Editing Node Groups

You can change the following node group details:

- the name of the node group
- the environment that the node group assigns to matching nodes
- the [environment override][environment_override] setting
- the node group’s parent node group
- the description of the node group

**To edit a node group:**

1. In the top navigation bar, click **Classification**.
2. To go to the node group details, click the node group that you want to edit.
3. At the top right of the page, click **Edit node group metadata**.
4. When you are ready to commit changes, click the commit button.

## Deleting Node Groups

**To delete a node group:**

1. In the top navigation bar, click **Classification**.

2. Click the node group that you want to delete.

3. At the top right of the page, click **Remove node group**.

    > **Note:** A node group can only be deleted if it has no children.

## Editing Rules

**To edit an existing rule:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the rule that you want to edit.

3. In **Rules**, find the rule that you want to edit.

4. In the row for that rule, click **Edit** and make the changes.

5. When you are ready to commit changes, click the commit button.

## Removing Nodes From a Node Group

Nodes are automatically removed from a node group when they no longer match the rules that have been declared in the node group. You need to either edit or delete the rule that was used to include the node in the node group. If the node has been pinned to the node group, you can remove it from the node group by unpinning it.

**To delete a rule:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the rule that you want to edit.

3. In **Rules**, find the rule that you want to edit.

4. To delete the rule, click **Remove**. 

   You can also click **Remove all** if you want to delete all rules for this node group. The rule stays in the list with a line through it until you commit your changes.

5. When you are ready to commit changes, click the commit button.

    > **Note:** When a node no longer matches the rules of a node group, it is no longer classified with the classes assigned in that node group. However, the resources that were installed by those classes are not removed from the node. For example, if a node group has the `apache` class that installs the Apache package on matching nodes, the Apache package is not removed from the node even when the node no longer matches the node group rules. 

**To unpin a node:**

1. In **Rules**, find the node that you want to unpin. You will find the pinned nodes under the list of rules. 

2. To unpin the node, click **Unpin**. 

   You can also unpin all pinned nodes by clicking **Unpin all pinned nodes**. The node stays in the list with a line through it until you commit your changes.

3. When you are ready to commit changes, click the commit button.


## Removing Classes From a Node Group

**To remove a class from a node group:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the class that you want to remove.

3. In **Classes**, find the class that you want to remove.

4. To remove the class, at the bottom of the list of parameters, click **Remove this class**. 

   You can also click **Remove all classes** if you want to remove all classes for this node group. The class stays in the list with a line through it until you commit your changes.

5. When you are ready to commit changes, click the commit button.

**Note:** If a class appears in the list but is crossed out, the class has been deleted from Puppet.

## Editing Parameters

**To edit the parameters of a class:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the parameter that you want to change.

3. In **Classes**, find the class and parameter.

4. To edit the parameter, click **Edit** and select another parameter or change the value of the parameter. 

5. When you are ready to commit changes, click the commit button.

## Deleting Parameters

**To delete a parameter that has been set for a class:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the parameter that you want to delete.

3. In **Classes**, find the class and parameter.

4. To delete the parameter, click **Remove**. The parameter stays in the list with a line through it until you commit your changes. 

5. When you are ready to commit changes, click the commit button.

## Editing Variables

**To edit a variable that has been set in a node group:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the variable that you want to change.

3. In **Variables**, find the variable.

4. To edit the variable, click **Edit** and make your changes.

5. When you are ready to commit changes, click the commit button.

## Deleting Variables

**To delete a variable that has been set in a node group:**

1. In the top navigation bar, click **Classification**.

2. Click the node group containing the variable that you want to change.

3. In **Variables**, find the variable.

4. To delete the variable, click **Remove**. 

   You can also click **Remove all variables** if you want to remove all variables for this node group.The variable stays in the list with a line through it until you commit your changes.

5. When you are ready to commit changes, click the commit button.


* * *

- [Next: Preconfigured Node Groups](./console_classes_groups_preconfigured_groups.html)
