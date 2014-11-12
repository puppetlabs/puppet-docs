---
layout: default
title: "PE 3.7 » Cloud Provisioning » Overview"
subtitle: "A High Level Look at Puppet's Cloud Provisioning Tools"
canonical: "/pe/latest/cloudprovisioner_overview.html"
---

Puppet Enterprise includes a suite of command-line tools you can use for provisioning new virtual nodes when building or maintaining cloud computing infrastructures based on VMware vSphere, Amazon EC2 and Google Compute Engine. You can use these tools to:

* Create and destroy virtual machine instances
* Classify new nodes (virtual or physical) in the PE console
* Automatically install and configure PE on new nodes (virtual or physical)

When used together, these tools provide quick and efficient workflows for adding and maintaining fully configured, ready-to-run virtual nodes in your Puppet Enterprise-managed cloud environment.

See the sections on [VMware](./cloudprovisioner_vmware.html), [AWS](./cloudprovisioner_aws.html), and [GCE](./cloudprovisioner_gce.html) provisioning for details about creating and destroying virtual machines in these environments. Beyond that, the section on [classifying nodes and installing PE](./cloudprovisioner_classifying_installing.html) covers actions that work on any new machine, virtual or physical, in a cloud environment. To get an idea of a typical workflow in a cloud provisioning environment, see the [workflow](./cloudprovisioner_workflow.html) section.

The cloud provisioning tools can be added during an installation of Puppet Enterprise. If you have already installed PE and you want to install the cloud provisioning tools, simply run the upgrader again.

**Note for Puppet users** Most of the information in these sections applies to Puppet as well as PE. However, provisioning on VMWare is only supported by Puppet Enterprise. 

Tools
-----

PE's provisioning tools are built on the `node`, `node_vmware`, `node_aws`, and `node_gce` subcommands. Each of these subcommands has a selection of available **actions** (such as `list` and `start`) that are used to complete specific provisioning tasks. You can get detailed information about a subcommand and its actions by running `puppet help` and `puppet man`.

The VMware, AWS, and GCE subcommands are only used for cloud provisioning tasks. `Node`, on the other hand, is a general purpose Puppet subcommand that includes several provisioning-specific actions. These are:

- `classify`
- `init`
- `install`

The `clean` action may also be useful when decommissioning nodes.

The cloud provisioning tools except for GCE are powered by [Fog, the Ruby cloud services library](https://github.com/fog/fog). Fog is automatically installed on any machine receiving the cloud provisioner component.

* * *

- [Next: Installing and Configuring Cloud Provisioner](./cloudprovisioner_configuring.html)
