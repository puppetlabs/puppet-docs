---
layout: default
title: "API >> Mapping Rake Tasks to REST APIs"
subtitle: "Mapping to the Node Classifier and RBAC APIs"
canonical: "/pe/latest/nc_mapping.html"
---

The Node Classifier's REST API is a more flexible alternative to the [Console Rake API](./console_rake_api.html). This page provides a mapping between the Console Rake API and the Node Classifier REST endpoints that most closely replicate their functionality.

Rake				                   | REST				| Description
------------------------------------------ | ----------------- | --------------------
`node:add[name,groups,classes,onexists]`| No equivalent | Creates a group with a rule that matches the host name of the node being added. The node is pinned to the group.	**This rake task has been deprecated.** In PE3.7, nodes are included in node groups when they match a node group's rules. They are then classified with the classes in the node group. See [Adding Nodes to a Node Group](./console_classes_groups_getting_started.html#adding-nodes-to-a-node-group).
