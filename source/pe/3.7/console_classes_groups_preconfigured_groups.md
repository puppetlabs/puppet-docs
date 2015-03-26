---
layout: default
title: "PE 3.8 » Console » Grouping and Classifying Nodes"
subtitle: "Preconfigured Node Groups"
canonical: "/pe/latest/console_classes_groups_preconfigured_groups.html"
---

[puppet]: ./puppet_overview.html
[puppet_assign]: ./puppet_assign_configurations.html
[lang_classes]: /puppet/3.7/reference/lang_classes.html
[learn]: /learning/
[forge]: http://forge.puppetlabs.com
[modules]: /puppet/3.7/reference/modules_fundamentals.html
[topscope]: /puppet/3.7/reference/lang_scope.html#top-scope
[environment]: /guides/environment.html

During installation, Puppet Enterprise (PE) automatically creates a number of preconfigured node groups for managing your deployment. In a new install, these node groups will come with some classes that are required.

> **Note:** If you're upgrading, only the **MCollective** node group will come with classes, so you will need to add the classes and parameters shown on this page, in the order in which they appear. Make sure that you add all of these classes and parameters and commit them by clicking the commit button **before** you do a Puppet run. Failure to classify **all** of the node groups before running Puppet on the master will cause problems.
>
> For important information regarding the data types and syntax that can be used when specifying parameter values, see the note in [Setting Class Parameters](./console_classes_groups.html#setting-class-parameters). Check the default parameter values in your preconfigured node groups and make sure they comply with the permitted data types and syntax.
>
> For more information on preconfigured node groups when upgrading from an earlier version of Puppet Enterprise (PE), see the [upgrading documentation](./install_upgrading_notes.html#classifying-pe-groups).

>**Note:** In general, you should not remove these node groups or delete classes from them.

The default settings for each node group are shown below.

## The Default Node Group

### Role
This node group is used for assigning classes to all nodes. For example, you can use it to assign the `ntp` class to all nodes.

### Classes
No default classes.

> **Note:** If you are using agent-specified environments, any classes in the **default** node group must be removed before you can set the environment.

### Matching nodes
All nodes.

### Notes
* You can add and remove classes, parameters, and variables.
* You cannot modify the rule.

## The PE Infrastructure Node Group

### Role
This node group is the parent to all of the node groups listed below (all preconfigured node groups except for the Default node group). It holds shared data that member nodes in child node groups need to know. This includes the hostnames and ports of  various services (such as master and PuppetDB) and database info (except for passwords).

> **WARNING:** NEVER REMOVE THE PE INFRASTRUCTURE GROUP.
>
> Removal of the PE Infrastructure node group will disrupt communication between all of your PE Infrastructure nodes (Master, PuppetDB, and Console).
>
> It is very important to correctly configure the `puppet_enterprise` class in this node group. The parameters set in this class affect the behavior of all other preconfigured node groups on this page that use classes starting with `puppet_enterprise::profile`. Incorrect configuration of this class could potentially cause a PE service outage.
>
> If you are upgrading from PE 3.3, or need to set up these preconfigured node groups for any other reason, you must configure the PE Infrastructure node group first before any other of the preconfigured node groups (except for the PE MCollective or Default node groups). Failure to do so will cause a disconnection between the Masters, Database, and Console services, and manual intervention will be required to restore PE Infrastructure functionality.

### Classes
* `puppet_enterprise` (sets the default parameters for child node groups)

> **Note:** If you are upgrading, you will need to add the following parameters to the `puppet_enterprise` class:
>
> * `mcollective_middleware_hosts = ["<YOUR HOST>"]` (This value must be an array, even if there is only one value, e.g. `mcollective_middleware_hosts = ["master.testing.net"]`)
> * `database_host = "<YOUR HOST>"`
> * `puppetdb_host = "<YOUR HOST>"`
> * `database_port = "<YOUR PORT NUMBER>"` (Only required if you have changed the port number from the default. The default port number is 5432.)
> * `database_ssl = true` (Set to `true` if you're using the PE-installed postgres, and `false` if you're using your own postgres.)
> * `puppet_master_host = "<YOUR HOST>"`
> * `certificate_authority_host = "<YOUR HOST>"`
> * `console_port =	"<YOUR PORT NUMBER>"` (Only required if you have changed the port number from the default. The default port number is 443.)
> * `puppetdb_database_name = "pe-puppetdb"`
> * `puppetdb_database_user = "pe-puppetdb"`
> * `puppetdb_port = "<YOUR PORT NUMBER>"` (Only required if you have changed the port number from the default. The default port number is 8081.)
> * `console_host =	"<YOUR HOST>"`
>
> **Note:** In a monolithic install, `<YOUR HOST>` is your Puppet master's certname. You can find the certname with the `puppet config print certname` command. In a split install, `<YOUR HOST>` is the certname of the server on which you installed the component.


### Matching Nodes
There are no nodes pinned to this node group.

## The PE Certificate Authority Node Group

### Role
This node group is used to manage the certificate authority.

### Classes
* `puppet_enterprise::profile::certificate_authority` (manages the certificate authority on the first master node)

### Matching Nodes
The master node is pinned to this node group.

### Notes
You should *not* add additional nodes to this node group.

## The MCollective Node Group

### Role
This node group is used to enable PE's [orchestration engine](./orchestration_overview.html) on all matching nodes.

### Classes
* `puppet_enterprise::profile::mcollective::agent` (manages the MCollective server)

### Matching Nodes
All nodes.

### Notes
* You may have some nodes, such as non-root nodes or network devices, that **should not** have orchestration enabled. You can create a rule in this node group to exclude these nodes from orchestration.

## The PE Master Node Group

### Role
This node group is used to manage Puppet masters and [add additional compile masters](./install_multimaster.html#step-3-classify-the-new-puppet-master-node).

### Classes
* `puppet_enterprise::profile::master` (manages the master service)
* `puppet_enterprise::profile::mcollective::peadmin` (manages the peadmin MCollective client)
* `puppet_enterprise::profile::master::mcollective` (manages keys used by MCollective)

### Matching Nodes
The master node is pinned to this node group.

## The PE PuppetDB Node Group

### Role
This node group is used to manage the database service.

### Classes
* `puppet_enterprise::profile::puppetdb` (manages the PuppetDB service)

### Matching Nodes
The PuppetDB server node is pinned to this node group.

### Notes
* You should *not* add additional nodes to this node group.

## The PE Console Node Group

### Role
This node group is used to manage the console.

### Classes
* `puppet_enterprise::profile::console` (manages the console, node classifier and RBAC)
* `puppet_enterprise::profile::mcollective::console` (manages the Puppet dashboard MCollective client used by live management)
* `pe_console_prune` (manages a cron job to periodically prune the console reports database)
* `puppet_enterprise::license` (manages the PE license file for the status indicator)

### Matching Nodes
The console server node is pinned to this node group.

### Notes
* You should *not* add additional nodes to this node group.



## The PE ActiveMQ Broker Node Group

### Role
This node group is used to manage the ActiveMQ broker and [add additional ActiveMQ brokers](./install_add_activemq.html#step-3-create-the-activemq-hub-group).

### Classes
* `puppet_enterprise::profile::amq::broker` (manages the ActiveMQ MCollective broker)

### Matching Nodes
The master node is pinned to this node group.


* * *

- [Next: How Does Inheritance Work?](./console_classes_groups_inheritance.html)
