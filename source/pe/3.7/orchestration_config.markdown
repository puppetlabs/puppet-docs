---
layout: default
title: "PE 3.7 » Orchestration » Configuration"
subtitle: "Configuring Orchestration"
canonical: "/pe/latest/orchestration_config.html"
---

The Puppet Enterprise (PE) orchestration engine can be configured to enable new actions, modify existing actions, restrict actions, and prevent run failures on non-PE nodes.

Disabling Orchestration on Some Nodes
-----

By default, Puppet Enterprise enables and configures orchestration on all agent nodes. This is generally desirable, but the Puppet code that manages this will not work on non-PE agent nodes, and will cause Puppet run failures on them.

Since the Puppet master server supports managing non-PE agent nodes (including things like network devices), you should disable orchestration when adding non-PE nodes.

To disable orchestration for a node, in the PE console, create a rule in the `mcollective` group that excludes the node. This will prevent PE from attempting to enable orchestration on that node. [See here for instructions on including nodes in node groups in the console.][group]

[group]: ./console_classes_groups_getting_started.html#adding-nodes-to-a-node-group


Adding Actions
-----

[See the "Adding Actions" page of this manual.](./orchestration_adding_actions.html)

Changing the Port Used by MCollective/ActiveMQ
------

You can change the port that MCollective/ActiveMQ uses with a simple variable change in the console. 

1. In the **Classification** page, click the `mcollective` group. 
2. Click **Variables**. 
3. In the __key__ field, add `fact_stomp_port`, and in the __value__ field, add the port number you want to use.
4. Click **Add variable** and then click the commit button.

Configuring Orchestration Plugins
-----

Some MCollective agent plugins, including the [default set included with Puppet Enterprise](./orchestration_actions.html), have settings that can be configured.

Since the main orchestration configuration file is managed by Puppet Enterprise, you must [put these settings in separate plugin config files, as described in the "Adding Actions" page of this manual.](./orchestration_adding_actions.html#step-4-configure-the-plugin-optional)

Restricting Orchestration Actions
-----

[See the "Policy Files" heading in the "Adding Actions" page of this manual.][policy]

[policy]: orchestration_adding_actions.html#policy-files

Unsupported Features
-----

### Adding New Orchestration Users and Integrating Applications

Adding new orchestration users is not supported in Puppet Enterprise 3.0. Future versions of PE may change the orchestration engine's authentication backend, which will block additional orchestration users from working until they are updated to use the new backend. We plan to include an easy method to add new orchestration users in a future version of PE.

In the meantime, if you need to add a new orchestration user in order to integrate an application with Puppet Enterprise, you can:

* Obtain client credentials and a config file [as described in the standard MCollective deployment guide][config_client].
* Write a Puppet module to distribute the new client's public key into the `${pe_mcollective::params::mco_etc}/ssl/clients/` directory. This class must use `include pe_mcollective` to ensure that the directory can be located.
* Assign that Puppet class to the `mcollective` group in the PE console.

Again, this process is _unsupported_ and may require additional work during a future upgrade.

[config_client]: /mcollective/deploy/standard.html#step-5-configure-clients

### Configuring Subcollectives

[subcollectives]: /mcollective/reference/basic/subcollectives.html

Using multiple orchestration [subcollectives][] with Puppet Enterprise is not currently supported, and requires modifying PE's internal modules. If you enable this feature, your changes will be reverted by future PE upgrades, and you will need to re-apply your changes after upgrading.

If you choose to enable this unsupported feature, you will need to modify, at minimum, the `/opt/puppet/share/puppet/modules/pe_mcollective/templates/server.cfg.erb` and `/opt/puppet/share/puppet/modules/pe_mcollective/templates/activemq.xml.erb` files on your Puppet master server(s). Any such modifications will be reverted during a future PE upgrade.


Configuring Performance
-----

### ActiveMQ Heap Usage (Puppet Master Server Only)

The Puppet master node runs an ActiveMQ server to route orchestration commands. By default, its process uses a Java heap size of 512 MB; this is the best value for mid-sized deployments, but can be a problem when building small proof-of-concept deployments on memory-starved VMs.

You can set a new heap size by doing the following:

1. In the PE console, click **Classification**.
2. Click the `puppet_master` group.
3. Click __Variables__. In the __key__ field, add `activemq_heap_mb`, and in the __value__ field add a new heap size to use (in MB).
4. Click **Add variable** and then click the commit button.

You can later delete the variable to revert to the default setting.

### Registration Interval

[register]: /mcollective/configure/server.html#node-registration

By default, all agent nodes will send dummy registration messages over the orchestration middleware every ten minutes. [We use these as a heartbeat to work around weaknesses in the underlying Stomp network protocol.][register]

Most users shouldn't need to change this behavior, but you can adjust the frequency of the heartbeat messages as follows:

1. In the PE console, click **Classification**.
2. Click the `mcollective` group.
3. Click __Variables__. In the __key__ field, add `mcollective_registerinterval`, and in the __value__ field add a new interval (in seconds).
4. Click **Add variable** and then click the commit button.

You can later delete the variable to revert to the default setting.

### Orchestration SSL

By default, the orchestration engine uses SSL to encrypt all orchestration messages. You can disable this in order to investigate problems, but should **never** disable it in a production deployment where business-critical orchestration commands are being run.

To disable SSL:

1. In the PE console, click **Classification**.
2. Click the `mcollective` group.
3. Click __Variables__. In the __key__ field, add `mcollective_enable_stopmp_ssl`, and in the __value__ field add `false`.
4. Click **Add variable** and then click the commit button.

You can later delete the variable to revert to the default setting.


<!--
Scaling: Multiple Orchestration Message Brokers
-----

$::activemq_brokers

should be comma-sep'd list (NO SPACES), can be set as a console variable.
Must set it individually on EACH activemq server, with that server's own name excluded. the module doesn't use special smarts to reject the local one.

Still need to know what classes to apply, etc., as well as how to comply with the reference architecture.

-->

* * *

- [Next: Cloud Provisioning: Overview](./cloudprovisioner_overview.html)
