---
layout: default
title: "PE 3.7 » Installing » Upgrading (Important Notes and Warnings)"
subtitle: "Upgrading Puppet Enterprise: Notes and Warnings"
canonical: "/pe/latest/install_upgrading_notes.html"
---

>**Important**: A complete list of known issues is provided in the [PE 3.7.1 release notes](./release_notes_known_issues.html). Please review this list before upgrading. 

### Upgrading to the Puppet Server (on the Puppet Master)

PE 3.7.0 introduces the Puppet server, running the Puppet Master, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack. However, due to this change in the underlying architecture of the Puppet master, there are a few changes you'll notice after upgrading that we'd like to point out. Refer to [About the Puppet Server](./install_upgrading_puppet_server_notes.html) for more information.

### Upgrading to Directory Environments

Directory environments are enabled by default in PE 3.7.0. Before upgrading be sure to read [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

>**Warnings**: If you enabled directory environments in PE 3.3.x and are upgrading to PE 3.7.0, ensure there is no `default_manifest` parameter in `puppet.conf` **before** upgrading. Upgrades will fail if this change is not made.
>
> If you enabled directory environents in PE 3.3.x and are upgrading to PE 3.7.0, ensure that the `basemodulepath` parameter in `puppet.conf` is set in the `[main]` section and not in the `[master]` section *before* upgrading. Upgrades will fail if this change is not made. 

### Upgrading to the Node Classifier

PE 3.7.0 introduces the new node classifier, which replaces previous versions of the PE console node classifier and changes the way you classify agent nodes.

During the upgrade process, each agent node---including any node you've grouped and classified in previous versions---will be pinned to its own group; meaning that if you have an agent node named `agent1.example.com`, after the upgrade, that node will belong to a group called `agent1.example.com` (and, possibly, the [agent-specified group](#about-the-agent-specified-group)). Since node groups will not be maintained during the upgrade process, you will need to use the new node classifier to regroup your nodes. 

In addition, as part of the upgrade process, all nodes will be assigned, by default, to the "production" environment.

Please note that factors such as the size of your deployment and the complexity of your classifications will determine how much time and/or planning you will need before upgrading to PE 3.7.0.  

For more information about the node classifier, refer to [Grouping and Classifying Nodes](./console_classes_groups.html).

#### About the Agent-specified Group

If you have agent nodes that specify their own environments, those nodes will be pinned, not only to a group named for that node, but also to the "agent-specified" group in the node classifier.  While this is done to ensure your agent nodes can still have an agent-specified environment, we recommend moving to a model where classification of nodes is performed by the node classifier.

For example, if you have an agent node for which the `[agent]` section of `puppet.conf` contains `environment=development`, we recommend you use the node classifier to change its group environment to "development" and then unpin it from the "agent-specified" group.

#### Classifying PE Groups

For fresh installations of PE 3.7.0, node groups in the classifier are created and configured during the installation process. For upgrades, these groups are created but no classes are added to them. This is done to help prevent errors during upgrade process.

The [preconfigured groups doc](./console_classes_groups_preconfigured_groups.html) has a list of groups and their classes that get installed on fresh upgrades.

### Upgrading to Role-Based Access Control (RBAC)

After upgrading to PE 3.7.0, you will need to set up your directory service and users and groups. Note that when you upgrade, PE doesn't migrate any existing users. In addition, PE doesn't preserve your username and password. You'll now log in with "admin" as your username.

For more information about RBAC, refer to [Working with Role-Based Access Control](./rbac_intro.html).


### Before Upgrading, Back Up Your Databases and Other PE Files

   We recommend that you back up the following databases and PE files.

   On a monolithic (all-in-one) install, the databases and PE files will all be located on the same node as the Puppet master.

   - `/etc/puppetlabs/`
   - `/opt/puppet/share/puppet-dashboard/certs`
   - [The console and console_auth databases](./maintain_console-db.html#database-backups)
   - [The PuppetDB database](/puppetdb/1.6/migrate.html#exporting-data-from-an-existing-puppetdb-database)

   On a split install, the databases and PE files will be located across the various components assigned to your servers.

   - `/etc/puppetlabs/`: different versions of this directory can be found on the server assigned to the Puppet master component, the server assigned to the console component, and the server assigned to the database support component (i.e., PuppetDB and PostgreSQL). You should back up each version.
   - `/opt/puppet/share/puppet-dashboard/certs`: located on the server assigned to the console component.
   - The console and console_auth databases: located on the server assigned to the database support component.
   - The PuppetDB database: located on the server assigned to the database support component.

### A Note about RBAC, Node Classifier, and External PostgreSQL

If you are using an external PostgreSQL instance that is not managed by PE, please note the following:

1. You will need to create databases for RBAC, activity service, and the node classifier before upgrading. Instructions on creating these databases are documented in the web-based installation instructions for both [monolithic](./install_pe_mono.html) and [split](./install_pe_split.html) installs. 
2. You will need to have the [citext extension](http://www.postgresql.org/docs/9.2/static/citext.html) enabled on the RBAC database.

### `q_database_host` Cannot be an Alt Name For Upgrades to 3.7.0 

PostgreSQL does not support alt names when set to `verify_full`. If you are upgrading to 3.7 with an answer file, make sure `q_database_host` is set as the Puppet agent certname for the database node and not set as an alt name.

### Before Upgrading, Correct Invalid Entries in `autosign.conf`

Any entries in `/etc/puppetlabs/puppet/autosign.conf` that don't conform to the [autosign requirements](/puppet/3.7/reference/ssl_autosign.html#the-autosignconf-file) will cause the upgrade to fail to configure the PE console. Please correct any invalid entries before upgrading to PE 3.7.0.

### You Might Need to Upgrade puppetlabs-inifile to Version 1.1.0 or Later

PE will automatically update your version of puppetlabs-inifile as part of the upgrade process. However, if you encounter the following error message on your PuppetDB node, then you need to manually upgrade the puppetlabs-inifile module to version 1.1.0 or higher.

	Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Invalid parameter quote_char on Ini_subsetting['-Xmx'] on node master
	Warning: Not using cache on failed catalog
	Error: Could not retrieve catalog; skipping run
