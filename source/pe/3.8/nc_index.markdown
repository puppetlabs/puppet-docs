---
title: "Node Classifier 1.0 >> API >> v1 >> Endpoints"
layout: default
subtitle: "Node Classifier Endpoints"
canonical: "/pe/latest/nc_index.html"
---

# Node Classifier v1 API Endpoints

This page lists the endpoints for the node classifier v1 API. For general information about forming HTTP requests to the API, see the [forming requests](./nc_forming_requests.html) page.

## Groups

The `groups` endpoint is used to create, read, update, and delete groups.
A group belongs to an environment, applies classes (possibly with parameters), and matches nodes based on rules.
Because groups are so central to the classification process, this endpoint is where most of the action is.

>See the [`groups` endpoint](./nc_groups.html) page for detailed information. To validate a group object without modifying the database in any way, use the [`validate` endpoint](./nc_validate.html). To translate a rule condition into the equivalent PuppetDB query, use the [`rules` endpoint](./nc_rules.html). To erase all node groups and replace them with an imported list of groups, use the [`import-hierarchy` endpoint](./nc_import-hierarchy.html).

## Classes

The `classes` endpoint is used to retrieve a list of known classes within a given environment.
The output from this endpoint is especially useful for creating new node groups, which usually contain a reference to one or more classes.

The node classifier gets its information about classes from Puppet, so this endpoint should not be used to create, update, or delete them.

>See the [`classes` endpoint](./nc_classes.html) page for detailed information. To manually update the list of available classes from the Puppet master, use the [`update-classes` endpoint](./nc_update_classes.html).

## Classification

The `classified` endpoint takes a node name and a set of facts and returns information about how that node should be classified.
The output can help you test your classification rules.

>See the [`classification` endpoint](./nc_classification.html) page for detailed information.

## Environments

The `environments` endpoint returns information about environments.
The output will either tell you which environments are available or whether a named environment exists.
The output can be helpful when creating new node groups, which must be associated with an environment.

The node classifier gets its information about environments from Puppet, so this endpoint should not be used to create, update, or delete them.

>See the [`environments` endpoint](./nc_environments.html) page for detailed information.

## Nodes

The `nodes` endpoint returns the check-in history for a given node or for all nodes.

>See the [nodes endpoint](./nc_nodes.html) page for more detailed information.
