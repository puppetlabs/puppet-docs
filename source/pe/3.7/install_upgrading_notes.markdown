---
layout: default
title: "PE 3.8 » Installing » Upgrading (Important Notes and Warnings)"
subtitle: "Upgrading Puppet Enterprise: Notes and Warnings"
canonical: "/pe/latest/install_upgrading_notes.html"
---

> **IMPORTANT**: **READ BEFORE UPGRADING**: If you are upgrading from PE 3.3 and you use the PE console for node classification, follow the steps in the [node classification migration process doc](./install_upgrade_migration_tool.html) to perform your upgrade to PE 3.8.

>**Note**: A complete list of known issues is provided in the [PE 3.7.1 release notes](./release_notes_known_issues.html). Please review this list before upgrading.

## Upgrading to the Puppet Server (on the Puppet Master)

PE 3.7.0 introduces the Puppet server, running the Puppet Master, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack. However, due to this change in the underlying architecture of the Puppet master, there are a few changes you'll notice after upgrading that we'd like to point out. Refer to [About the Puppet Server](./install_upgrading_puppet_server_notes.html) for more information.

### Updating Puppet Master Gems

See the [known issue about Ruby gems and upgrades](./release_notes_known_issues.html#updating-puppet-master-gems) in the release notes.

## Upgrading to Directory Environments

Directory environments are enabled by default in PE 3.7.0. Before upgrading be sure to read [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

>**Warnings**: If you enabled directory environments in PE 3.3.x and are upgrading to PE 3.7.0, ensure there is no `default_manifest` parameter in `puppet.conf` **before** upgrading. Upgrades will fail if this change is not made.
>
> If you enabled directory environents in PE 3.3.x and are upgrading to PE 3.7.0, ensure that the `basemodulepath` parameter in `puppet.conf` is set in the `[main]` section and not in the `[master]` section *before* upgrading. Upgrades will fail if this change is not made.

## Upgrading to the Node Classifier

PE 3.7.0 introduces the new node classifier, which replaces previous versions of the PE console node classifier and changes the way you classify agent nodes.

If you are upgrading and you use the PE console for node classification, follow the steps in the [node classification migration process doc](./install_upgrade_migration_tool.html) **BEFORE** performing your upgrade. The steps in the migration process doc provide a smooth upgrade path from PE 3.3.2 to PE 3.8.

Please note that factors such as the size of your deployment and the complexity of your classifications will determine how much time and/or planning you will need before upgrading to PE 3.7.0.

For more information about the node classifier, refer to [Getting Started With Classification](./console_classes_groups_getting_started.html).

## A Note about RBAC, Node Classifier, and External PostgreSQL

If you are using an external PostgreSQL instance that is not managed by PE, please note the following:

1. You will need to create databases for RBAC, activity service, and the node classifier before upgrading. Instructions on creating these databases are documented in the web-based installation instructions for both [monolithic](./install_pe_mono.html) and [split](./install_pe_split.html) installs.
2. You will need to have the [citext extension](http://www.postgresql.org/docs/9.2/static/citext.html) enabled on the RBAC database.

### About the Agent-specified Group

If you have agent nodes that specify their own environments, those nodes will be pinned, not only to a group named for that node, but also to the "agent-specified" group in the node classifier.  While this is done to ensure your agent nodes can still have an agent-specified environment, we recommend moving to a model where classification of nodes is performed by the node classifier.

For example, if you have an agent node for which the `[agent]` section of `puppet.conf` contains `environment=development`, we recommend you use the node classifier to change its group environment to "development" and then unpin it from the "agent-specified" group.

### Classifying PE Groups

For fresh installations of PE 3.8, node groups in the classifier are created and configured during the installation process. For upgrades, if these groups do not exist, or do not contain any classes, they will be created and configured but no nodes will be pinned to them. This helps prevent errors during the upgrade process, but you must manually pin the correct nodes to each group after upgrading. 

The [preconfigured groups doc](./console_classes_groups_preconfigured_groups.html) has a list of groups and their classes that get installed on fresh upgrades, and it also clarifies what nodes should be pinned to the groups.

If these groups do exist during upgrade and contain all the classes documented in the preconfigured groups doc, they will not be modified during the upgrade process.

If these groups do exist and only contain **some** of the documented classes, or contain other **unknown classes**, they will not be modified, and the upgrade process will fail. Before upgrading, please ensure that either you have no classes in the PE groups or that they match the preconfigured groups doc.

After upgrading you must pin nodes to the new PE groups. We recommend that you perform the manual pinning in this order:

1. The PE Certificate Authority node group (typically the same as your Puppet master)
2. The PE Master node group
3. The PuppetDB node group
4. The PE Console node group
5. The PE ActiveMQ Broker node group (typically your Puppet master)

If you pin the node groups in this order, you do not need to stop/restart Puppet.
The MCollective node group is configured during upgrade, so you do not need to perform any classification or pinning with this group.

**To add a class to a node group:**

1. On the **Classification** page, click the node group that you want to add the class to, and then click **Classes**.

2. Under **Add new class**, click the **Class name** field.

   A list of classes appears. These are the classes that the Puppet master knows about and are available in the environment that you have set for the node group. The list filters as you type. Filtering is not limited to the start of a class name, you can also type substrings from anywhere within the class name. Select the class when it appears in the list.

3. Click **Add class** and then click the commit change button.

## Upgrading to Role-Based Access Control (RBAC)

After upgrading to PE 3.7, you will need to set up your directory service and users and groups. Note that when you upgrade, PE doesn't migrate any existing users. In addition, PE doesn't preserve your username and password. You'll now log in with "admin" as your username.

For more information about RBAC, refer to [Working with Role-Based Access Control](./rbac_intro.html).

## Upgrading to 3.8 with a Modified `auth.conf` File

The [`auth.conf`](/puppet/latest/reference/config_file_auth.html) file manages access to Puppet's HTTPS API. This file is located at `/etc/puppetlabs/puppet/auth.conf` on the Puppet master.

If we find a modified `auth.conf` during the 3.8 upgrade process, we will attempt to create a diff between your modified version and the 3.8 version (reliant on the presence of a diff executable on your Puppet master server). You may need to modify your `auth.conf` to address the differences, as this file is not managed by PE. We recommend that you consider and address the changes, as some functionality (e.g., console services) may not be available after upgrade if the endpoints aren't authorized.

Here are some notable changes that have been made to the endpoints in `auth.conf`:

- The `/v2.0/environments` endpoint was added (3.3).

- The `certificate_status` endpoint was removed (3.7.2).

- The `resource_type` endpoint was modified to allow `classifier_client_certname` (pe-internal-classifier) and `console_client_certname` (pe-internal-dashboard) (3.7.0).

You will need to acknowledge you're aware of the differences when prompted by the upgrader, or pass in an answer file with `q_exit_and_update_auth_conf` in it when running the upgrade.

## `q_database_host` Cannot be an Alt Name For Upgrades to 3.7.0

PostgreSQL does not support alt names when set to `verify_full`. If you are upgrading to 3.7 with an answer file, make sure `q_database_host` is set as the Puppet agent certname for the database node and not set as an alt name.

## Before Upgrading, Correct Invalid Entries in `autosign.conf`

Any entries in `/etc/puppetlabs/puppet/autosign.conf` that don't conform to the [autosign requirements](/puppet/3.7/reference/ssl_autosign.html#the-autosignconf-file) will cause the upgrade to fail to configure the PE console. Please correct any invalid entries before upgrading to PE 3.7.0.

## You Might Need to Upgrade puppetlabs-inifile to Version 1.1.0 or Later

PE will automatically update your version of puppetlabs-inifile as part of the upgrade process. However, if you encounter the following error message on your PuppetDB node, then you need to manually upgrade the puppetlabs-inifile module to version 1.1.0 or higher.

	Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Invalid parameter quote_char on Ini_subsetting['-Xmx'] on node master
	Warning: Not using cache on failed catalog
	Error: Could not retrieve catalog; skipping run
