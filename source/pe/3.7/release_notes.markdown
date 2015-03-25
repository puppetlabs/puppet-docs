---
layout: default
title: "PE 3.7 » Release Notes"
subtitle: "Puppet Enterprise 3.7 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about new features and general improvements in the latest Puppet Enterprise (PE) release.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [Security and Bug Fixes](./release_notes_security.html).

## New Features in PE 3.7.2

### RBAC Can Query an Entire Base DN For Users and Groups

Previously, RBAC required an RDN (relative distinguished name) for user and group queries to an external directory. An RDN is no longer required. This means that you can search an entire base DN (distinguished name) for a user or group.

For more information, see [Connecting Puppet Enterprise with LDAP Services](./rbac_ldap.html).

### `jruby_max_active_instances` Now Available

This new setting enables you to tune the number of JRuby instances you're running. Doing so helps you control the amount of heap space your infrastructure uses. See [this known issue](./release_notes_known_issues.html#running-pe-puppetserver-on-a-server-with-more-than-four-cores-might-require-tuning) for more information and suggestions for using this setting.

## New Features in PE 3.7.1

### SLES 12 Support (all components)

This release provides full support for SLES 12 on all PE components, including the Puppet master.

For more information, see the [system requirements](./install_system_requirements.html).

### Node Classifier Improvements

The default sync time for the node classifier has been changed from 15 minutes to 3 minutes to be the same as the default refresh time for the environment cache. This means that, by default, the node classifier now retrieves new classes from the master every 3 minutes. For more information, see the [Getting Started With Classification](./console_classes_groups.html#adding-classes-that-apply-to-all-nodes) page.

In addition, PE 3.7.1 has a **Refresh** button in the **Classes** page that allows you to manually retrieve new classes from the master without waiting for the 3 minute sync period. The timestamp to the left of the **Refresh** button shows the time that has elapsed since the last sync.

### Improvements to the Windows User Experience

Puppet 3.7.3 provided Windows users with two useful new facts, as well as a fix to the PATH variable that are now available to PE users.

These are the new facts:

* [`$system32`](/facter/latest/core_facts.html#system32) is the path to the **native** system32 directory, regardless of Ruby and system architecture. This means that inside a 32-bit Puppet/Ruby on Windows x64, this fact typically resolves to `c:\windows\sysnative`. On a 64-bit Puppet/Ruby on Windows x64, this fact typically resolves to `c:\windows\system32`. In other words, this always gets the `system32` directory with binaries that are the same bitness as the current OS.
* [`$rubyplatform`](/facter/latest/core_facts.html#rubyplatform) reports the value of Ruby's `RUBY_PLATFORM` constant.

For details on these improvements, see the [Puppet 3.7.3 Release Notes](/puppet/3.7/reference/release_notes.html#puppet-373).

In addition, all of the **Windows versions of Puppet Enterprise supported modules** have been updated to support 64-bit as well as 32-bit Ruby runtime. For more information about supported modules, see the [Supported Modules page in the Forge documentation](https://forge.puppetlabs.com/supported).

**Scheduled tasks** have also been improved for this release in the following ways:

* An error message will notify you when the task scheduler is disabled. Previously, the Win32-taskscheduler gem 0.2.2 crashed.
* The Windows scheduled task (scheduled_task) provider was generating spurious messages during Puppet runs that suggested that scheduled task resources were being reapplied during each run even when the task was present and its associated resource had not been modified. This has been fixed. For more information, see the information on [scheduled tasks on Windows](/puppet/3.7/reference/resources_scheduled_task_windows.html) in the **Puppet** documentation.

## New Features in 3.7.0

### Next-Generation Puppet Server

PE 3.7.0 introduces the Puppet server, built on a JVM stack, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack.

For users upgrading from an earlier version of PE, there are a few things you'll notice after upgrading due to changes in the underlying architecture of the Puppet server.

[About the Puppet Server](./install_upgrading_puppet_server_notes.html) details some items that are intentionally different between the Puppet server and the Apache/Passenger stack; you may also be interested in the PE [Known Issues Related to Puppet Server](./release_notes_known_issues.html#puppet-server-known-issues), where we've listed a handful of issues that we expect to fix in future releases.

[Graphing Puppet Server Metrics](./puppet_server_metrics.html) provides instructions on setting up a Graphite server running Grafana to track Puppet server performance metrics.

### Adding Puppet Masters to a PE Deployment

This release supports the ability to add additional Puppet masters to large PE deployments managing more than 1500 agent nodes. Using additional Puppet masters in such scenarios will provide quicker, more efficient compilation times as multiple masters can share the load of requests when agent nodes run.

For instructions on adding additional Puppet masters, refer to [Additional Puppet Master Installation](./install_multimaster.html).

### Node Manager

PE 3.7.0 introduces the rules-based node classifier, which is the first part of the Node Manager app that was announced in September. The node classifier provides a powerful and flexible new way to organize and configure your nodes. We’ve built a robust, API-driven backend service and an intuitive new GUI that encourages a modern, cattle-not-pets approach to managing your infrastructure. Classes are now assigned at the group level, and nodes are dynamically matched to groups based on user-defined rules.

For a detailed overview of the new node classifier, refer to the [PE user's guide](./console_classes_groups.html).

### Role-Based Access Control

With RBAC, PE nodes can now be segmented so that tasks can be safely delegated to the right people. For example, RBAC allows segmenting of infrastructure across application teams so that they can manage their own servers without affecting other applications. Plus, to ease the administration of users and authentication, RBAC connects directly with standard directory services including Microsoft Active Directory and OpenLDAP.

For detailed information to get started with RBAC, see the [PE user's guide](./rbac_intro.html).

### Adding MCollective Hub and Spokes

PE 3.7.0 provides the ability to add additional ActiveMQ hubs and spokes to large PE deployments managing more than 1500 agent nodes. Building out your ActiveMQ brokers will provide efficient load balancing of network connections for relaying MCollective messages through your PE infrastructure.

For instructions on adding additional ActiveMQ Hubs and Spokes, refer to [Additional ActiveMQ Hub and Spoke Installation](./install_add_activemq.html).

### Upgrades to Directory Environments

PE 3.7.0 introduces full support for directory environments, which will be enabled by default.

Environments are isolated groups of Puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. Directory environments let you add a new environment by simply adding a new directory of config data.

For your reference, we've provided some notes on what you may experience during upgrades from a previous version of PE. See [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

Before getting started, visit the Puppet docs to read up on the [Structure of an  Environment](/puppet/3.7/reference/environments_creating.html#structure-of-an-environment), [Global Settings for Configuring Environments](/puppet/3.7/latest/reference/environments_configuring.html#global-settings-for-configuring-environments), and [creating directory environments](/puppet/3.7/reference/environments_creating.html).

#### A Note about `environment_timeout` in PE 3.7.0

The [environment_timeout](/puppet/3.7/reference/environments_configuring.html#environmenttimeout) defaults to 3 minutes. This means that code changes you make might not appear until after that timeout has been reached. In addition it's possible that back to back runs of Puppet could flip between the new code and the old code until the `environment_timeout` is reached.

#### Factor 2.2

PE 3.7.0 includes Factor 2.2. This provides a number of improvements that are detailed in the [Factor 2.2 release notes](./facter/2.2/release_notes.html). However, it also resulted in some changes to the behavior of facts, which are detailed in the [known issues](/release_notes_known_issues.html).

### Support Script Improvements

PE 3.7.0 includes several improvements to the support script, which is bundle in the PE tarball. Check out the [Getting Support page](./overview_getting_support.html#the-pe-support-script) for more information about the support script.

### SLES 10 Support (agent only)

This release provides support for SLES 10 for agent only installation.

For more information, see the [system requirements](./install_system_requirements.html).

### Enhanced Security For Using HTTP CA API Endpoints

To use the Puppet master's `certificate_status` API endpoint, you now need to add your client to the whitelist in [`ca.conf`](/puppetserver/1.0/configuration.html#caconf). After you add your client to the whitelist, restart Puppet Server using `service pe-puppetserver restart`.
