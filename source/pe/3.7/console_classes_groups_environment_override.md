---
layout: default
title: "PE 3.7 » Console » Grouping and Classifying Nodes"
subtitle: "Working With Environments"
canonical: "/pe/latest/console_classes_groups_environment_override.html"
---

We recommend the following environment-based workflow for testing new code in the node classifier before pushing it to production. This workflow will help you avoid conflicts that can occur if a node is a member of two different node groups, each with a different environment specified.

1. Create a branch of node groups that are used exclusively for setting an environment. In these node groups, add rules to match the appropriate nodes to this node group/environment. Do not add any classes to these node groups.

2. Set the environment override in all of the node groups created in Step 1 above. This ensures that the environment setting persists even if matching nodes also match other non-ancestor node groups that have different environments specified. To set the environment override:

    1. On the **Classification** page, click the node group that you want to edit.

    2. To access the environment override setting, click **Edit node group metadata** at the upper right.

    3. Under **ENVIRONMENT**, select the **Override all other environments** checkbox.

    4. To commit the change, click the commit button.

    In the **All node groups** view, an **Override** tag is displayed for node groups that      have the environment override set. 
    
3. Create a branch of node groups that are used for classification. This is where you will add classes, along with rules that specify which nodes you want to match. You can leave the environment set to the default `production` environment, or change it to whatever environment you need to validate your classes and parameters against. Do not set the environment override in any of these groups.

4. If you want to set a test parameter in your test environment, make a child group that overrides the value of the production parameter. To move the parameter to production, manually change the parameter in the production group and then delete the child group you were testing in.

5. To add parameters that are only available in the test environment, set the environment of the node group to the test environment so that the node classifier validates your parameters against the test environment.


* * *

- [Next: Using Event Inspector](./console_event-inspector.html)