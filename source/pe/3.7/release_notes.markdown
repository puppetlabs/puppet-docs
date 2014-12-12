---
layout: default
title: "PE 3.7.1 » Release Notes"
subtitle: "Puppet Enterprise 3.7.0 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about new features in the latest Puppet Enterprise (PE) release. 

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security Fixes](./release_notes_security.html). 

## New Features in 3.7.1

### SLES 12 Support (all components)

This release provides full support for SLES 12 on all PE components, including the Puppet master.

For more information, see the [system requirements](./install_system_requirements.html).

## New Features in 3.7.0

### Next-Generation Puppet Server

PE 3.7.0 introduces the Puppet server, built on a JVM stack, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack.

For users upgrading from an earlier version of PE, there are a few things you'll notice after upgrading due to changes in the underlying architecture of the Puppet server.

[About the Puppet Server](./install_upgrading_puppet_server_notes.html) details some items that are intentionally different between the Puppet server and the Apache/Passenger stack; you may also be interested in the PE [Known Issues Related to Puppet Server](#known-issues-related-to-puppet-server), where we've listed a handful of issues that we expect to fix in future releases.

[Graphing Puppet Server Metrics](./puppet_server_metrics.html) provides instructions on setting up a Graphite server running Grafana to track Puppet server performance metrics.

### Adding Puppet Masters to a PE Deployment

This release supports the ability to add additional Puppet masters to large PE deployments managing more than 1500 agent nodes. Using additional Puppet masters in such scenarios will provide quicker, more efficient compilation times as multiple masters can share the load of requests when agent nodes run.

For instructions on adding additional Puppet masters, refer to [Additional Puppet Master Installation](./install_multimaster.html).

### Node Manager

PE 3.7.0 introduces the rules-based node classifier, which is the first part of the Node Manager app that was announced in September. The node classifier provides a powerful and flexible new way to organize and configure your nodes. We’ve built a robust, API-driven backend service and an intuitive new GUI that encourages a modern, cattle-not-pets approach to managing your infrastructure. Classes are now assigned at the group level, and nodes are dynamically matched to groups based on user-defined rules.

For a detailed overview of the new node classifier, refer to the [PE user's guide](./console_classes_groups_getting_started.html).

### Role-Based Access Control

With RBAC, PE nodes can now be segmented so that tasks can be safely delegated to the right people. For example, RBAC allows segmenting of infrastructure across application teams so that they can manage their own servers without affecting other applications. Plus, to ease the administration of users and authentication, RBAC connects directly with standard directory services including Microsoft Active Directory and OpenLDAP.

For detailed information to get started with RBAC, see the [PE user's guide](./rbac_intro.html).

### Adding MCollective Hub and Spokes

PE 3.7.0 provides the ability to add additional ActiveMQ hubs and spokes to large PE deployments managing more than 1500 agent nodes. Building out your ActiveMQ brokers will provide efficient load balancing of network connections for relaying MCollective messages through your PE infrastructure.

For instructions on adding additional ActiveMQ Hubs and Spokes, refer to [Additional ActiveMQ Hub and Spoke Installation](./install_add_activemq.html).

### Upgrades to Directory Environments

PE 3.7.0 introduces full support for directory environments, which will be enabled by default.

Environments are isolated groups of puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. Directory environments let you add a new environment by simply adding a new directory of config data.

For your reference, we've provided some notes on what you may experience during upgrades from a previous version of PE. See [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

Before getting started, visit the Puppet docs to read up on the [Structure of an  Environment](puppet/3.7/reference/environments_creating.html#structure-of-an-environment), [Global Settings for Configuring Environments](puppet/3.7/latest/reference/environments_configuring.html#global-settings-for-configuring-environments), and [creating directory environments](/puppet/3.7/reference/environments_creating.html).

#### A Note about `environment_timeout` in PE 3.7.0

The [environment_timeout](puppet/3.7/reference/environments_configuring.html#environmenttimeout) defaults to 3 minutes. This means that code changes you make might not appear until after that timeout has been reached. In addition it's possible that back to back runs of Puppet could flip between the new code and the old code until the `environment_timeout` is reached.

### Support Script Improvements

PE 3.7.0 includes several improvements to the support script, which is bundle in the PE tarball. Check out the [Getting Support page](./overview_getting_support.html#the-pe-support-script) for more information about the support script.

### SLES 10 Support (agent only)

This release provides support for SLES 10 for agent only installation.

For more information, see the [system requirements](./install_system_requirements.html).


