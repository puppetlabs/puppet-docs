---
layout: default
title: "PE 3.8 » Console » Grouping and Classifying Nodes"
subtitle: "Getting Started With Classification"
canonical: "/pe/latest/console_classes_groups_getting_started.html"
---

[puppet]: ./puppet_overview.html
[puppet_assign]: ./puppet_assign_configurations.html
[lang_classes]: /puppet/3.8/reference/lang_classes.html
[learn]: /learning/
[forge]: http://forge.puppetlabs.com
[modules]: /puppet/3.7/reference/modules_fundamentals.html
[topscope]: /puppet/3.7/reference/lang_scope.html#top-scope
[environment]: /guides/environment.html

## What is Classification?

In Puppet Enterprise (PE), you configure your nodes by assigning classes (such as the `apache` class or `ntp` class) and variables to them. This is called *classification*. Classes are blocks of Puppet code that are distributed in the form of modules. You can create your own classes, or you can take advantage of the many classes that have already been created by the amazing Puppet community. To reduce the potential for new bugs and save yourself some time by using the existing classes, see the modules on the [Puppet Forge][forge].

You could assign classes to individual nodes one at a time, but chances are, each of your classes needs to be applied to more than one node &#8212; possibly hundreds or thousands of nodes! This is where node groups and rules come in. Node groups and rules are a powerful and scalable way to automate the classification of your nodes and save you a lot of manual work.

The main steps involved in dynamically classifying nodes are:

1. Create node groups
2. Create rules to dynamically add and remove nodes from node groups
3. Assign classes to node groups

*Nodes* can match the rules of many node groups, and they receive classes, class parameters, and variables from all the node groups that they match. *Node groups* exist in a hierarchy of parent and child node groups, and inherit classes, class parameters and variables from all ancestor groups. You can override the classification settings of ancestor groups by setting new class parameter and variable values in a child group.

## Organizing Node Groups

A logical approach to organizing your node groups in PE is to start with high-level node groups that reflect the business requirements of your organization. For example, let’s say that a large portion of your infrastructure consists of web servers. There will be some classes, such as the `apache` class, that need to be applied to all of your web servers. You can create a node group called **web servers** and add any classes that need to be applied to all web servers.

Next, you identify that there are subsets of web servers that have common characteristics but differ from other subsets, such as development web servers testing out a newer version of Apache than the production servers. You can create a **dev web** child node group under the **web servers** node group. Nodes that match the **dev web** node group will get all of the classes in the parent node group in addition to the classes assigned to the **dev web** node group.


Additional resources:

* If you are new to Puppet and have not written Puppet code before, [the Learning Puppet tutorial][learn] will help you with the basics of Puppet code, and writing classes and modules.

* For a complete description of Puppet Enterprise's configuration data sources, see  [Assigning Configurations to Nodes][puppet_assign].

* * *

- [Next: Grouping and Classifying Nodes](./console_classes_groups.html)
