---
title: "PuppetDB 0.9 » Using PuppetDB"
layout: default
canonical: "/puppetdb/latest/using.html"
---


Currently, the main use for PuppetDB is to enable advanced features in Puppet. We expect additional applications to be built on it as PuppetDB becomes more widespread.

If you wish to build applications on PuppetDB, see the navigation sidebar for the API spec. 

Checking Node Status
-----

The PuppetDB plugins [installed on your puppet master(s)](./connect_puppet.html) include a `status` action for the `node` face. On your puppet master, run:

    $ sudo puppet node status <node> 

This will tell you whether the node is active, when its last catalog was submitted, and when its last facts were submitted. 

Using Exported Resources
-----

PuppetDB lets you use exported resources, which allows your nodes to publish information to be used by other nodes. 

[See here for more about using exported resources.](/guides/exported_resources.html)

Using the Inventory Service
-----

PuppetDB provides better performance for Puppet's inventory service.

[See here for more about using the inventory service and building applications on it.](/guides/inventory_service.html) If you are using Puppet Enterprise's console, or Puppet Dashboard with inventory support turned on, you will not need to change your configuration --- inventory information will be coming from PuppetDB as soon as [the puppet master is connected to it](./connect_puppet.html).
