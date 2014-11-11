---
layout: default
title: "PE 3.7 » Console » Grouping and Classifying Nodes"
subtitle: "Overriding an Environment"
canonical: "/pe/latest/console_classes_groups_environment_override.html"
---

If a node is classified in more than one node group and the node groups have different environments, a conflict will occur if one node group is not the ancestor of the other node group. To resolve this, you can enable the environment override setting. This will force the nodes that match the node group into that node group’s environment, even if the nodes also match other groups that specify different environments. (**Note:** You cannot set the environment override in more than one of the conflicting groups. This will cause an error.)

1. On the **Classification** page, click the node group that you want to edit.

2. To access the environment override setting, click **Edit node group metadata** at the upper right.

3. Under **ENVIRONMENT**, select the **Override all other environments** checkbox.

4. To commit the change, click the commit button.

In the **All node groups** view, an **Override** tag is displayed for node groups that have the environment override set. 

* * *

- [Next: Using Event Inspector](./console_event-inspector.html)