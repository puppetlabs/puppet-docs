---
layout: default
title: "PE 2.0 » Cloud Provisioning » Overview"
canonical: "/pe/latest/cloudprovisioner_overview.html"
---

* * *

&larr; [Orchestration: Usage and Examples](./orchestration_usage.html) --- [Index](./) --- [Cloud Provisioning: Configuring and Troubleshooting](./cloudprovisioner_configuring.html) &rarr;

* * *

A Cloud Provisioning Overview
=============================

Puppet Enterprise ships with command-line tools for provisioning new nodes. You can use these tools to:

* Create and destroy virtual machine instances on VMware vSphere and Amazon EC2
* Classify new nodes (virtual or physical) in the console
* Automatically install and configure PE on new nodes (virtual or physical)

When used together, these tools provide a quick and efficient workflow for adding nodes to your Puppet Enterprise environment.

See the chapters on [VMware](./cloudprovisioner_vmware.html) and [AWS](./cloudprovisioner_aws.html) provisioning for details about creating and destroying virtual machines. After that, the chapter on [classifying nodes and installing PE](./cloudprovisioner_classifying_installing.html) covers actions that work on any new machine, virtual or physical.

Tools
-----

PE's provisioning tools are based around the `node, node_vmware,` and `node_aws` subcommands. Each of these subcommands have a selection of available **actions** (such as `list` and `start`). You can get information about a subcommand or its actions with the `puppet help` and `puppet man` commands.

The VMware and AWS subcommands are only used for provisioning, but `node` is a pre-existing Puppet subcommand with several provisioning actions added to it. The `node` actions used in the provisioning process are:

- `classify`
- `init`
- `install`

You may also find the `clean` action useful when decommissioning nodes.

The VMware and AWS provisioning tools are powered by [Fog, the Ruby cloud services library](https://github.com/fog/fog). Fog is automatically installed on any machine receiving the cloud provisioner role.

Prerequisites
-------------

The cloud provisioning tools ship with Puppet Enterprise 2.0 and later.

### Services

The following services and credentials are required:

For VMware you will need:

- VMware vSphere 4.0 and later
- VMware vCenter

For Amazon Web Services you will need:

- An existing Amazon account with support for EC2

Installing
----------

Cloud provisioning can be installed on any puppet master or agent node.

The Puppet Enterprise installer and upgrader ask whether to install cloud provisioning during installation; answer 'yes' to enable cloud provisioning actions on a given node.

If you're using an answer file to install Puppet Enterprise, this
capability can be installed by setting the `q_puppet_cloud_install` option to `y`.

    q_puppet_cloud_install=y

* * *

&larr; [Orchestration: Usage and Examples](./orchestration_usage.html) --- [Index](./) --- [Cloud Provisioning: Configuring and Troubleshooting](./cloudprovisioner_configuring.html) &rarr;

* * *

