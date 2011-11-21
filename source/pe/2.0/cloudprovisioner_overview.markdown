---
layout: pe2experimental
title: "PE 2.0 » Cloud Provisioning » Overview"
---

An Overview of PE Cloud Provisioning
====================================

Puppet Enterprise provides you with the capability to provision,
configure and manage VMware virtual machines and Amazon Web Services
EC2 instances.  It allows you to create and bootstrap virtual machines,
classify those machines in your Puppet Enterprise environment,
install Puppet Enterprise on them and automatically add them to your
console.

* * *

Overview
--------

Puppet Enterprise cloud provisioning extends Puppet by adding new actions for
creating and puppetizing new machines using VMware vSphere and Amazon
Web Service's EC2.

It provides you with an easy command line interface to:

* Create a new VMware virtual machine or Amazon EC2 instance
* Classify the new virtual machine or instance in the Puppet Enterprise
  console
* Automatically install Puppet Enterprise and integrate with your
  existing Puppet infrastructure.

This provides you with a quick and efficient workflow for adding nodes
to your Puppet Enterprise environment.

Prerequisites
-------------

Cloud provisioning ships with Puppet Enterprise 2.0 and later.

### Services

The following services and credentials are required:

For VMware you will need:

- VMware vSphere 4.0 and later
- VMware vCenter

For Amazon Web Services you will need:

- An existing Amazon account with support for EC2

Installing
----------

Cloud provisioning can be installed on any Puppet master or node.
You will be prompted during the Puppet Enterprise installation to
install cloud provisioning. Answer 'yes' to ensure it is installed.

If you're using an answer file to install Puppet Enterprise this
capability can be installed by setting the `q_puppet_cloud_install` option to `y`.

    q_puppet_cloud_install=y

You can then provision from the command line of any configured
Puppet Enterprise Master or agent.

