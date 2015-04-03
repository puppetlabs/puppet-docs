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

During installation, Puppet Enterprise (PE) automatically creates a number of preconfigured node groups. Some of these node groups come with required classification already added and some of them come with rules or pinned nodes. This page provides details of how each of these preconfigured node groups look when you do a new install of PE.


>**Note:** In general, you should not remove these node groups or delete classes from them.
> 
> For important information regarding the data types and syntax that can be used when specifying parameter values, see the note in [Setting Class Parameters](./console_classes_groups.html#setting-class-parameters). Check the default parameter values in your preconfigured node groups and make sure they comply with the permitted data types and syntax. 
> 
> For more information on preconfigured node groups when upgrading from an earlier version of Puppet Enterprise (PE), see the [upgrading documentation](./install_upgrading_notes.html#classifying-pe-groups).


## The Default Node Group

This node group is used for assigning classes to all nodes. For example, you can use it to assign the `ntp` class to all nodes.

#### Classes
No default classes.

> **Note:** If you are using agent-specified environments, any classes in the **default** node group must be removed before you can set the environment. 

#### Matching nodes
All nodes.

#### Notes
* You can add and remove classes, parameters, and variables.
* You cannot modify the preconfigured rule that matches all nodes.

## PE Infrastructure-Related Node Groups

These are the groups that PE uses to manage its own configuration. They should remain in these default states, unless you are adjusting parameters as directed by documentation or Support, or pinning new nodes for documented functions like creating compile masters. Custom classes should not be added to these groups, as they are reserved for internal use. Use of these node groups is optional but highly recommended.

### The PE Infrastructure Node Group

This node group is the parent to all of the infrastructure-related node groups listed in this section. It holds shared data that nodes matching this group's child node groups need to know. This includes the hostnames and ports of  various services (such as master and PuppetDB) and database info (except for passwords).

> **WARNING:** NEVER REMOVE THE PE INFRASTRUCTURE GROUP.
>
> Removal of the PE Infrastructure node group will disrupt communication between all of your PE Infrastructure nodes (Master, PuppetDB, and Console).
>
> It is very important to correctly configure the `puppet_enterprise` class in this node group. The parameters set in this class affect the behavior of all other preconfigured node groups on this page that use classes starting with `puppet_enterprise::profile`. Incorrect configuration of this class could potentially cause a PE service outage.
(JOSH: Are we still allowing users to remove classes from these groups? Or ar we making them non-removable?)
>
> If you need to set up these preconfigured node groups for any reason, you must configure the PE Infrastructure node group first before any other of the preconfigured node groups (except for the PE MCollective node groups). Failure to do so will cause a disconnection between the Masters, Database, and Console services, and manual intervention will be required to restore PE Infrastructure functionality.

#### Classes
* `puppet_enterprise` (sets the default parameters for child node groups)

> Parameters:
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


#### Matching Nodes
Nodes are not pinned to this node group. The PE Infrastructure node group is the parent to other infrastructure node groups, such as PE Master, and is only used to set classification that all child node groups need to inherit. You should never pin nodes directly to this node group.

### The PE Certificate Authority Node Group

This node group is used to manage the certificate authority.

#### Classes
* `puppet_enterprise::profile::certificate_authority` (manages the certificate authority on the first master node)

#### Matching Nodes
On a new install, the Master node is pinned to this node group. If you are upgrading, you will need to pin the Master node yourself.

#### Notes
You should *not* add additional nodes to this node group.

### The PE MCollective Node Group

This node group is used to enable PE's [orchestration engine](./orchestration_overview.html) on all matching nodes.

#### Classes
* `puppet_enterprise::profile::mcollective::agent` (manages the MCollective server)

#### Matching Nodes
All nodes. 

#### Notes
* You may have some nodes, such as non-root nodes or network devices, that **should not** have orchestration enabled. You can create a rule in this node group to exclude these nodes from orchestration.

### The PE Master Node Group

This node group is used to manage Puppet masters and [add additional compile masters](./install_multimaster.html#step-3-classify-the-new-puppet-master-node).

#### Classes
* `puppet_enterprise::profile::master` (manages the master service)
* `puppet_enterprise::profile::mcollective::peadmin` (manages the peadmin MCollective client)
* `puppet_enterprise::profile::master::mcollective` (manages keys used by MCollective)

#### Matching Nodes
On a new install, the Master node is pinned to this node group. If you are upgrading, you will need to pin the Master node yourself.

### The PE PuppetDB Node Group

This node group is used to manage the database service.

#### Classes
* `puppet_enterprise::profile::puppetdb` (manages the PuppetDB service)

#### Matching Nodes
On a new install, the PuppetDB server node is pinned to this node group. If you are upgrading, you will need to pin the PuppetDB server node yourself.

#### Notes
* You should *not* add additional nodes to this node group. 

### The PE Console Node Group

This node group is used to manage the console.

#### Classes
* `puppet_enterprise::profile::console` (manages the console, node classifier and RBAC)
* `puppet_enterprise::profile::mcollective::console` (manages the Puppet dashboard MCollective client used by live management)
* `pe_console_prune` (manages a cron job to periodically prune the console reports database)
* `puppet_enterprise::license` (manages the PE license file for the status indicator)

#### Matching Nodes
On a new install, the Console server node is pinned to this node group. If you are upgrading, you will need to pin the Console server node yourself.

#### Notes
* You should *not* add additional nodes to this node group. (TODO: Update based on the question above for Josh)


### The PE ActiveMQ Broker Node Group

This node group is used to manage the ActiveMQ broker and [add additional ActiveMQ brokers](./install_add_activemq.html#step-3-create-the-activemq-hub-group).

#### Classes
* `puppet_enterprise::profile::amq::broker` (manages the ActiveMQ MCollective broker)

#### Matching Nodes
On a new install, the Master server node is pinned to this node group. If you are upgrading, you will need to pin the Master server node yourself.

### The Agent Node Group

This node group is used by PE to manage the configuration of Puppet agents (currently the only thing being managed is [symlinks](./install_basic.html#puppet-enterprise-binaries-and-symlinks)).

#### Classes
* `puppet_enterprise::profile::agent` (manages your PE agent configuration)

#### Matching Nodes
All nodes being managed by PE are pinned to this node group by default.

## Environment Node Groups

These two node groups, the **Production Environment** node group and the **Agent-Specified Environment** node group, are used for the sole purpose of setting environments. They should not contain any classification. In these node groups, the **Environment Override** option is selected so that the environment is forced for any matching nodes, even if those nodes match another node group that has a different environment set. This is a workflow that we highly encourage because it avoids the environment conflicts that can happen when you unintentionally have nodes that match multiple node groups with conflicting environments set (only an issue when the node groups in question are in different branches of the inheritance tree). See the [Environments Workflow page](./console_classes_groups_environment_override.html) for more information about working with environments.

For example, if you have nodes that should always be in the production environment, ensure that they match the **Production Environment** node group by creating a rule that matches the node in the **Production Environment** node group, or by manually pinning the nodes to the **Production Environment** node group. Similarly, do the same in the **Agent-Specified Environment** node group for any nodes that need to always have the agent-specified environment. **Always make sure that the Environment Override button remains selected in both of these environment node groups.** 

### The Agent-Specified Environment Node Group

Normally, the environment that the node classifier sets for a node overrides any environment that you set in the node's puppet.conf file (the agent-specified environment). However, sometimes you may want to ignore the environments that have been set in the node classifier, and use the agent-specified environment, for testing for example. The **Agent-Specified Environment** node group forces the environment that has been specified in the puppet.conf file, ignoring any environments that have been set by the node classifier. If you want to use the agent-specified environment for a node, you should pin the node to this node group, or create a rule in the node group that matches the node. (TODO: What do we want to do about selecting the agent-specified environment from the environment metadata in http://docs.puppetlabs.com/pe/latest/console_classes_groups.html#creating-new-node-groups? What do we want to say about putting nodes in this group versus using the agent-specified dropdown)

#### Classes
You should never add any classes to this group. This group should only be used to set the agent-specified environment for matching nodes.

#### Matching Nodes 
Create rules to match nodes that should be assigned the agent-specified environment. Alternatively, you can manually pin the nodes to the group.

#### Notes

The **Environment Override** option should be selected in the node group metadata section.

### The Production Environment Node Group

Use this node group when you have nodes that should always be assigned the production environment. 

#### Classes
You should never add any classes to this group. This group should only be used to set the production environment for matching nodes.

#### Matching Nodes 
Create rules to match nodes that should be assigned the production environment. Alternatively, you can manually pin the nodes to the group.

#### Notes

The **Environment Override** option should be selected in the node group metadata section.

* * *

- [Next: How Does Inheritance Work?](./console_classes_groups_inheritance.html)
