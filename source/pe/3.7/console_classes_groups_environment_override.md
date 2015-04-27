---
layout: default
title: "PE 3.7 » Console » Grouping and Classifying Nodes"
subtitle: "Working With Environments"
canonical: "/pe/latest/console_classes_groups_environment_override.html"
---


In order to prevent conflicts between node groups, we recommend the idea of “environment groups” and “classification groups”.

"Environment groups" should:

1. Set the environment
2. Have the **Override all other environments** checkbox selected
3. Not include any classes

"Classification groups" should:

1. Include classes
2. **Never** have the **Override all other environments** checkbox selected
3. Use the environment if you want to filter classes and parameters by environment

<a href="./images/console/env_workflow.svg"><img src="./images/console/env_workflow.svg" alt="Environment Workflow" title="Click to enlarge"> (Click to enlarge)</a>

> **Important Note:** This is a design pattern for architecting and laying out node groups to implement the recommended workflow for using environments. The differences illustrated here between environment node groups and classification node groups are purely conventional. The Node Classifier makes no such distinction on a technical level, and does not show them separately. The Node Classifier is only aware of one kind of primitive: a node group. It is up to you to maintain design separation between environment node groups and classification node groups.

### Creating Environment Node Groups

1. Create a set of node groups that are used exclusively for setting an environment. In these node groups, add rules to match the appropriate nodes to this node group/environment. Do not add any classes to these node groups.

2. Set the environment override in all of the node groups created in Step 1 above. This ensures that the environment setting persists even when matching nodes also match other non-ancestor node groups that have different environments specified. To set the environment override:

    1. On the **Classification** page, click the node group that you want to edit.

    2. To access the environment override setting, click **Edit node group metadata** at the upper right.

    3. Under **ENVIRONMENT**, select the **Override all other environments** checkbox.

    4. To commit the change, click the commit button.

    In the **All node groups** view, an **Override** tag is displayed for node groups that      have the environment override set. 
    
### Creating Classification Node Groups

1. Create a set of node groups that are used exclusively for assigning classification to nodes. This is where you will add classes, along with rules that specify which nodes to match. You can leave the environment set to the default `production` environment, or change it to whatever environment you need to validate your classes and parameters against. **Do not set the environment override in any of these groups.**

2. To set a test parameter, make a child group under a production node group. In the child group, set a parameter that overrides the value of the production parameter. To move the parameter to production, manually change the parameter in the production group and then delete the child group you were testing in.

3. To add parameters that are only available in the test environment, set the environment of the classification node group to `test` so that the node classifier validates your parameters against the test environment.


* * *

- [Next: Using Event Inspector](./console_event-inspector.html)