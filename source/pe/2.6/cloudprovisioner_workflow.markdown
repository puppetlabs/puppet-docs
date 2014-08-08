---
layout: default
title: "PE 2.6  » Cloud Provisioning » Sample Workflow"
subtitle: "A Day in the Life of a Puppet-Powered Cloud Sysadmin"
canonical: "/pe/latest/cloudprovisioner_workflow.html"
---

Tom is a sysadmin for CloudWidget.com, a company that provides web-based application services. They use a three-tier application architecture with the following types of nodes:

 1. A web front-end load balancer
 2. A pool of application servers behind the load balancer
 3. A database server that serves the application servers
 
 All of these nodes are virtual machines running on a VMware ESX server. The nodes are all currently being managed with Puppet Enterprise. Using PE, the application servers have all been assigned to a group which applies a class `cloudwidget_appserv`.

CloudWidget is growing rapidly and so Tom is not surprised when he checks his inbox and finds several messages from users complaining about sluggish performance. He checks his monitoring tool and sure enough the load is too high on his application servers and performance is suffering. It's time to add a new node to the application server pool to help better distribute the load.

Tom grabs a cup of coffee and fires up his terminal. He starts by creating a new virtualized node with `puppet node_vmware create`. This gives him a new node with the following characteristics:

*  The node has a complete OS already installed
*  The node includes whatever is contained in the VMware template he specified as an option of the `create` action.
*  The node does not have Puppet installed on it yet.
*  The node is not yet configured to function as a CloudWidget application server.

When Tom first configured Puppet, he set up his workstation with the ability to remotely sign certificates. He did this by creating a certifcate/key pair and then modifying the CA's `auth.conf` to allow that certificate to perform authentication tasks. (To find out more about how to do this, see the [auth.conf documentation](/guides/rest_auth_conf.html) and the [REST API guide](/guides/rest_api#the-master-rest-api).)

This allows Tom to use `puppet node init` to complete the process of getting the new node up and running. `Puppet node init` is a wrapper command that will `install` Puppet, `classify` the node, and sign the certificate (`puppet certicate sign` or `puppet cert sign`). "Classifying" the node tells Puppet which configuration groups and classes should be applied to the node. In this case, applying the `cloudwidget_appserv` class configures the node with all the settings, files and database hooks needed to create a fully configured, ready-to-run app server tailored to the CloudWidget environment.

Note: if Tom had not done the prep work needed for remote signing of certificates he could run the `puppet node install`, `puppet node classify` and `puppet cert sign` commands separately.

Now Tom needs to run Puppet on the new node in order to apply the configuration. He could wait 30 minutes for Puppet to run automatically, but instead he SSH's into the machine and runs Puppet interactively with `puppet agent --test`.

At this point we have:

* A new virtual machine node with Puppet installed
* The node has a signed certificate and is an authorized member of the CloudWidget deployment
* Puppet has fully configured the node with all of the bits and pieces needed to go live and start doing real work as a fully functioning CloudWidget application server.

The CloudWidget infrastructure is now scaled and running at acceptable loads. Tom leans back and takes a sip of his coffee. It's still hot.


* * * 

- [Next: Troubleshooting Cloud Provisioner](./cloudprovisioner_troubleshooting.html) 
