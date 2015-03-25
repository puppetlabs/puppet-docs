---
layout: default
title: "PE 3.7 » Orchestration » Configuration"
subtitle: "Configuring Orchestration"
canonical: "/pe/latest/orchestration_config.html"
---

The Puppet Enterprise (PE) orchestration engine can be configured to enable new actions, modify existing actions, restrict actions, and prevent run failures on non-PE nodes.

Disabling Orchestration on Some Nodes
-----

By default, PE enables and configures orchestration on all agent nodes. This is generally desirable, but the Puppet code that manages this will not work on non-PE agent nodes, and will cause Puppet run failures on them.

Since the Puppet master server supports managing non-PE agent nodes (including things like network devices), you should disable orchestration on non-PE nodes.

To disable orchestration for a node, in the PE console, create a rule in the `PE MCollective` group that excludes the node. This will prevent PE from attempting to enable orchestration on that node. [See here for instructions on including nodes in node groups in the console.][group]

[group]: ./console_classes_groups.html#adding-nodes-to-a-node-group


Adding Actions
-----

[See the "Adding Actions" page of this manual.](./orchestration_adding_actions.html)

Changing the Port Used by MCollective/ActiveMQ
------

You can change the port that MCollective/ActiveMQ uses with a simple variable change in the console. 

1. In the **Classification** page, click the `PE MCollective` group.
2. Click **Variables**. 
3. In the __key__ field, add `fact_stomp_port`, and in the __value__ field, add the port number you want to use.
4. Click **Add variable** and then click the commit button.

Configuring Orchestration Plugins
-----

Some MCollective agent plugins, including the [default set included with Puppet Enterprise](./orchestration_actions.html), have settings that can be configured.

Since the main orchestration configuration file is managed by PE, you must [put these settings in separate plugin config files, as described in the "Adding Actions" page of this manual.](./orchestration_adding_actions.html#step-4-configure-the-plugin-optional)

Restricting Orchestration Actions
-----

[See the "Policy Files" heading in the "Adding Actions" page of this manual.][policy]

[policy]: orchestration_adding_actions.html#policy-files

Unsupported Features
-----

### Adding New Orchestration Users and Integrating Applications

Adding new orchestration users is not supported in Puppet Enterprise 3.0. Future versions of PE may change the orchestration engine's authentication backend, which will block additional orchestration users from working until they are updated to use the new backend. We plan to include an easy method to add new orchestration users in a future version of PE.

In the meantime, if you need to add a new orchestration user in order to integrate an application with PE, you can:

* Obtain client credentials and a config file [as described in the standard MCollective deployment guide][config_client].
* Write a Puppet module to distribute the new client's public key into the `${pe_mcollective::params::mco_etc}/ssl/clients/` directory. This class must use `include pe_mcollective` to ensure that the directory can be located.
* Assign that Puppet class to the `PE MCollective` group in the PE console.

Again, this process is _unsupported_ and may require additional work during a future upgrade.

[config_client]: /mcollective/deploy/standard.html#step-5-configure-clients

### Configuring Subcollectives

[subcollectives]: /mcollective/reference/basic/subcollectives.html

Using multiple orchestration [subcollectives][] with PE is not currently supported, and requires modifying PE's internal modules. If you enable this feature, your changes will be reverted by future PE upgrades, and you will need to re-apply your changes after upgrading.

If you choose to enable this unsupported feature, you will need to modify, at minimum, the `/opt/puppet/share/puppet/modules/pe_mcollective/templates/server.cfg.erb` and `/opt/puppet/share/puppet/modules/pe_mcollective/templates/activemq.xml.erb` files on your Puppet master server(s). Any such modifications will be reverted during a future PE upgrade.



- [Next: Cloud Provisioning: Overview](./cloudprovisioner_overview.html)
