---
layout: default
title: "PE 3.8 » Installing » Upgrading » PE 3.3 to PE 3.8 Migration Tool"
subtitle: "Instructions for Migrating a Split Installation From PE 3.3 to PE 3.8"
canonical: "/pe/latest/install_upgrade_migration_split.html"
---

Follow these instructions if you have a split installation (the master, console, and PuppetDB components are installed on different servers). 

To upgrade from PE 3.3 to PE 3.8 using the migration tool, you must follow the steps below in the order shown.

## Step 1: Gather Database Connection Details

The migration tool will require database connection details stored on your PE console server. This information is stored in the console database configuration file. The default path for this file is `/etc/puppetlabs/puppet-dashboard/database.yml`.

SSH to the console server, and review the contents of the console database configuration file.

Sample output:

{% highlight yaml %}
user@console: sudo cat /etc/puppetlabs/puppet-dashboard/database.yml
common: &common
    database: 'console'
    username: 'console'
    password: 'gL2YvqUiMHQkIna1RPzNZg'
    host: 'wheezy.localdomain'
    port: 5432
    adapter: postgresql

development:
    <<: *common

production:
    <<: *common

test:
    database: console_test
    <<: *common
{% endhighlight %}

Take note of the entries for `database`, `username`, `password`, `host`, and `port`. These values will be used in [Step 5 - Export your Classification Data](#step-5-export-your-classification-data).

## Step 2: Download the PE 3.8 Tarball on Your PE 3.3.2 PuppetDB Server

The migration tool is a package that is included in the PE 3.8 tarball. On the node that will be your PuppetDB server, [download](https://puppetlabs.com/download-puppet-enterprise) the appropriate tarball and GPG signagure (.asc) for your operating system and unpack the tarball. For more information about downloading the tarball, see [Downloading Puppet Enterprise](./install_upgrading.html#download-pe).

The package is located in `<TARBALL>/packages/<YOUR_OPERATING_SYSTEM>`. Depending on your operating system, it will be named either `pe-nc-migration-tool.deb` or `pe-nc-migration-tool.rpm`.

## Step 3: Back Up Your PE 3.3 Installation

Before going any further, back up the following databases and PE files. On a split install, the databases and PE files will be located across the various servers that have been designated as PE component servers.

   - `/etc/puppetlabs`: different versions of this directory can be found on the server assigned to the Puppet master component, the server assigned to the console component, and the server assigned to the database support component (i.e., PuppetDB and PostgreSQL). You should back up each version.
   - `/opt/puppet/share/puppet-dashboard/certs`: located on the server assigned to the console component.
   - [The console and console_auth databases](./maintain_console-db.html#database-backups): located on the server assigned to the database support component.
   - [The PuppetDB database](/puppetdb/2.3/migrate.html#exporting-data-from-an-existing-puppetdb-database): located on the server assigned to the database support component.

## Step 4: Install the Migration Tool on the PuppetDB Host

To install on Red Hat or SLES-based systems:

`rpm -Uvh <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.rpm`

To install on Debian-based systems:
    
`dpkg -i <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.deb`

## Step 5: Export Your Classification Data

Before upgrading, you need to export your node classification data from PE 3.3. The migration tool's export command gathers up your PE 3.3 classification data and exports it as a JSON file. Specifically, the following items get exported.

For nodes: 

* The node name
* The node description
* Classification information (which variables, classes, and parameters are assigned to the node)
* Parent groups

For node groups:

* The group name
* The group description
* Member nodes
* Classification information
* Parent groups (which variables, classes, and parameters are assigned to the node)

The format for using the migration tool is `nc_migrate <ACTION> <OPTION> <TARGET>`. To view a list of options, type `/opt/puppet/bin/nc_migrate --help`.

To run the migration tool and export your classification data:

1. Type the export command and supply the values required to connect to your postgres database. These are the values that you recorded from the console database configuration file in [Step 1](#step-1-gather-database-connection-details). Specify them as follows:
    
    {% highlight yaml %}	
/opt/puppet/bin/nc_migrate export 	    	--db-name <value for database> \
					   	 					--db-user <value for username> \
					   		 				--db-password <value for password> \
					    					--db-host <value for host> \
					    					--db-port <value for port> \
{% endhighlight %}					    					

    **Note:** These database values take precedence over any values specified using the `--database` option. 

2. Once the database configuration has been acquired, the migration tool connects to the console database and exports your classification data to a JSON file called `dashboard-classification-export.json` in the current directory. To specify a different output file name and location, include the `--output` option when you run the export command (e.g. `/opt/puppet/bin/nc_migrate export --output <NEW FILE PATH>`.)


## Step 6: Convert Your PE 3.3 Classification Data

In this step, the tool is essentially mapping your exported classification data to a node group hierarchy that is compatible with PE 3.8. The tool first checks the exported classification data for PE 3.8 compatibility problems. If compatibility problems exist, you will have a chance to resolve the problems and export your data again. 

1. To start the migration process, on the PuppetDB server, run the migration tool with the `convert` command and supply the exported configuration file:

     `/opt/puppet/bin/nc_migrate convert --input ./dashboard-classification-export.json`

2. If any of your exported classification data is incompatible with PE 3.8 node classification, the migration tool will print errors. After reviewing any errors, you can choose to:

    1. Exit, resolve the conflicts in the PE 3.3 console, and then return to step 5. (Recommended)

    2. Ignore the conflicts and upgrade to PE 3.8 without using the migration tool. (Not recommended). If you choose to ignore the conflicts, disregard the remaining instructions on this page and switch to the instructions in [Upgrading Puppet Enterprise](./install_upgrading.html).

        **WARNING:** If you choose to ignore conflicts and upgrade without the migration tool, all PE 3.3 groups are discarded. In this case, classification is retained in PE 3.8 by creating an individual node group for each node and pinning the node to the node group.

    Unsupported configurations that will cause conflicts are:

    * A node or node group with multiple parent groups
    * A node that matches a node group but does not match all of the node group’s ancestors
    * A node that has classification applied to it directly as well as through node groups

    If any of the above configurations are found, the data conversion process is aborted. For information on resolving each of these conflicts, see [Resolving Conflicts](./install_upgrade_migration_tool_conflicts.html). 

3. If the conversion process is successful, the converted node group hierarchy and classification data is output to a JSON file called `dashboard-classification-export` in the current directory. To specify a different output file name and location, include the `--output` option when you run the `convert` command (e.g. `/opt/puppet/bin/nc_migrate convert --input ./dashboard-classification-export.json --output <NEW FILE PATH>`.) 

4. Review the JSON file and ensure that all groups and nodes are present as expected. Save a backup of this file somewhere safe.

> **Note:** If you have PE 3.3 nodes that are not members of a group and do not have classification, they will not appear in this file. This is normal and expected. As long as the node is active, it will still be present in PE 3.8.

> **Note:** If your Puppet master node for PE 3.8 is not the same node that you designated as the Puppet master in your PE 3.3 installation (e.g., if you are installing PE 3.8 on a new system and migrating your data), you will need to SCP your exported PE 3.3 data to the new Puppet master. 

## Step 7: Upgrade to PE 3.8
This step does not use the migration tool. To upgrade to PE 3.8, follow the instructions in [Upgrading Puppet Enterprise](./install_upgrading.html#upgrading-a-split-installation). After you have completed the upgrade, proceed to [Step 8](#step-8-install-the-migration-tool-on-your-puppet-master-server).

## Step 8: Install the Migration Tool on Your Puppet Master Server
When you import your converted classification data in Step 9, the data is imported to your PE Puppet master. You therefore need to install the migration tool on the PE Puppet master server. The migration tool package is located in the PE 3.8 tarball that you used to upgrade.

To install on Red Hat-based systems:

`rpm -Uvh <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.rpm`

To install on Debian-based systems:

`dpkg -i <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.deb`

## Step 9: Import Your Classification Data Into PE 3.8

If you resolved all conflicts during [Step 6](#step-6-convert-your-pe-33-classification-data), you can use the migration tool to import your converted PE 3.3 classification data into PE 3.8. After you have upgraded to PE 3.8, follow the steps below to import the classification data.

> **Note:** The migration tool preserves the PE 3.8 preconfigured node groups that are created by the installer script during upgrade. For a list of these node groups, see [Preconfigured Node Groups](./install_upgrade_migration_preconfigured_groups.html). All other node groups are removed. 
> 
> If you would like to back up your PE 3.8 node groups before importing your PE 3.3 classification data, use the [`/v1/groups` endpoint of the Node Classifier Service API](./nc_groups.html) and save the output from this endpoint to a file. If for any reason you want to restore the state of your PE 3.8 upgrade prior to importing PE 3.3 classification data, you can do so by [POSTing the file to the `/v1/import-hierarchy` endpoint](/nc_import-hierarchy.html). For information about using the Node Classifier Service API, see [Forming Node Classifier Requests](./nc_forming_requests.html).

To import your PE 3.3 classification data:

1. Go to your PE 3.8 Puppet master. (If you run the import command from the Puppet master, it can use Puppet’s configuration to find the location of the Node Classifier Service API and the SSL files needed to communicate with it.)

2. Run the migration tool with the import command: 

    `/opt/puppet/bin/nc_migrate import`
    
    Use the `-i` or `--input` option to specify your input file if your classification data is not in the default file, which is `converted_dashboard_classification.json` in the current directory.
	
3. The migration tool will import the converted node groups from the default or specified JSON file into PE 3.8.

Other available options when running the import command:

* `--classifier-api-url` The URL to the Node Classifier Service API. Make sure that the URL does **not** include a trailing slash. (Example: `https://console.lan.mycompany.com:4432/node-classifier`)
* `--ssl-key` The path to a PEM file on disk that has the private SSL key used to connect to the Node Classifier Service API. 
* `--ssl-cert` The path to a PEM file on disk that has the public SSL key used to connect to the Node Classifier Service API. 
* `--ssl-ca-cert` The path to a PEM file on disk that has the CA certificate used to connect to the Node Classifier Service API.

> For information about using whitelisted SSL certificates to connect to the Node Classifier Service API, see [Forming Node Classifier Requests](./nc_forming_requests.html#authentication).



* * *


- [Next: Treatment of Preconfigured Node Groups](./install_upgrade_migration_preconfigured_groups.html)