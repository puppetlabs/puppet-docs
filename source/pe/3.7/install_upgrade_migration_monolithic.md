---
layout: default
title: "PE 3.8 » Installing » Upgrading » PE 3.3 to PE 3.8 Migration Tool"
subtitle: "Instructions for Migrating a Monolithic Installation From PE 3.3 to PE 3.8"
canonical: "/pe/latest/install_upgrade_migration_monolithic.html"
---

To upgrade from PE 3.3 to PE 3.8 using the migration tool, follow the steps below in the order shown.

## Step 1: Download the PE 3.8 Tarball on Your PE 3.3.2 Puppet Master Server

The migration tool is a package that is included in the PE 3.8 tarball. On the node that will be your Puppet master server, [download](https://puppetlabs.com/download-puppet-enterprise) the appropriate tarball and GPG signagure (.asc) for your operating system and unpack the tarball. For more information about downloading the tarball, see [Downloading Puppet Enterprise](./install_upgrading.html#download-pe).

The package is located in `<TARBALL>/packages/<YOUR_OPERATING_SYSTEM>/pe-nc-migration-tool`.

## Step 2: Back Up Your PE 3.3 Installation

Before going any further, back up the following databases and PE files located on your Puppet master server:

   - `/etc/puppetlabs`
   - `/opt/puppet/share/puppet-dashboard/certs`
   - [The console and console_auth databases](./maintain_console-db.html#database-backups)
   - [The PuppetDB database](/puppetdb/2.3/migrate.html#exporting-data-from-an-existing-puppetdb-database)

## Step 3: Install the Migration Tool

To install on Red Hat or SLES-based systems:

`rpm -Uvh <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.rpm`

To install on Debian-based systems:

`dpkg -i <pe tarball>/packages/<platform-tag>/pe-nc-migration-tool.deb`

## Step 4: Export Your Classification Data

Before upgrading, you need to export your node classification data from PE 3.3. 

**Note:** If any of your classification data is not compatible with PE 3.8 classification, you will have a chance to make modifications in the console and export the modified data in [Step 5](#step-5-review-and-convert-your-pe-33-classification-data). 

The migration tool includes an export command. The export command gathers up your PE 3.3 classification data and exports it as a JSON file. Specifically, the following items get exported.

For nodes: 

* The node name
* The node description
* Classification information (which variables, classes, and parameters are assigned to the node)
* Group membership

For node groups:

* The group name
* The group description
* Member nodes
* Classification information
* Parent groups (which variables, classes, and parameters are assigned to the node)


The format for using the migration tool is `nc_migrate <ACTION> <OPTION> <TARGET>`. To view a list of options, type `/opt/puppet/bin/nc_migrate --help`.

To run the migration tool and export your classification data:

1. Type `/opt/puppet/bin/nc_migrate export`. This loads the PE 3.3 console database configuration from the default file, which is `/etc/puppetlabs/puppet-dashboard/database.yml`. If you have changed the default location for the console database configuration file, you will need to specify the new location when you run the export command (e.g. `/opt/puppet/bin/nc_migrate export --database <PATH TO NEW LOCATION>`.)

2. Once the database configuration has been acquired, the migration tool connects to the console database and exports your classification data to a JSON file called `dashboard-classification-export.json` in the current directory. To specify a different output file name and location, include the `--output` option when you run the export command (e.g. `/opt/puppet/bin/nc_migrate export --output <NEW FILE PATH>`.)

## Step 5: Review and Convert Your PE 3.3 Classification Data

In this step, the migration tool is essentially mapping your exported classification data to a node group hierarchy that is compatible with PE 3.8. The tool first checks the exported classification data for PE 3.8 compatibility issues. If compatibility issues exist, you will have a chance to resolve the issues and export your data again. 

To start the migration process, run the migration tool with the `convert` command and supply the exported configuration file:

`/opt/puppet/bin/nc_migrate convert --input ./dashboard-classification-export.json`


If any of your exported classification data is incompatible with PE 3.8 node classification, the migration tool will print errors. After reviewing any errors, you can choose to:

<ol>
<li>
Resolve the conflicts in the PE 3.3 console, and then <a href="#step-4-export-your-classification-data">return to Step 4 above</a>. (Recommended)
</li>
<li>
Ignore the conflicts and upgrade to PE 3.8 without using the migration tool. (Not recommended)
If you choose to ignore the conflicts, disregard the remaining instructions on  this page and switch to the instructions in <a href="./install_upgrading.html">Upgrading Puppet Enterprise</a>.
</li>

<strong>WARNING: If you choose to ignore conflicts and upgrade without the migration tool, all PE 3.3 groups are discarded. In this case, classification is retained in PE 3.8 by creating an individual node group for each node and pinning the node to the node group.</strong>
<br>
<br>
The unsupported configurations that cause conflicts are:
<ul>
<li>A node group with multiple parent groups</li>
<li>A node that matches a node group but does not match all of the node group’s ancestors</li> 
<li>A node that has classification applied to it directly as well as through node groups</li>
</ul>
If any of the above configurations are found, the data conversion process will be aborted. For information on resolving each of these conflicts, see <a href="./install_upgrade_migration_conflicts.html">Resolving Conflicts</a>.
<br>
<br>
<li>If the conversion process is successful, the converted node group hierarchy and classification data is output to a JSON file called <code>converted-dashboard-classification.json</code> in the current directory. 
<br>
To specify a different output file name and location, include the <code>output</code> option when you run the <code>convert</code> command (e.g. <code>/opt/puppet/bin/nc_migrate convert --input ./dashboard-classification-export.json --output &lt;NEW FILE PATH&gt;</code>.)</li>
<br>
<li>Review the JSON file and ensure that all groups and nodes are present as expected. Save a backup of this file somewhere safe.</li>
</ol>

Notes
Your PE 3.3 nodes that do not have groups or classification will not appear in this file. This is normal and expected. As long as the node is active, it will still be present in PE 3.8.
If your Puppet master node for PE 3.8 is not the same node that you designated as the Puppet master in your PE 3.3 installation (e.g., if you are installing PE 3.8 on a new system and migrating your data), you will need to SCP your exported PE 3.3 data to the new Puppet master. 

## Step 6: Upgrade to PE 3.8

To upgrade to PE 3.8, follow the instructions in [Upgrading Puppet 	Enterprise](./install_upgrading.html). After you have completed the upgrade, proceed to Step 7 below.
Step 7: Import your converted classification data into PE 3.8
If you resolved all conflicts during Step 5, you can use the migration tool to import your converted classification data into PE 3.8. After you have upgraded to PE 3.8, follow the steps below to import the classification data.

> **Note:** The migration tool preserves the PE 3.8 preconfigured node groups that are created by the installer script during upgrade. For a list of these node groups, see [Treatment of PE Infrastructure Groups](./install_upgrade_migration_preconfigured_groups.html). All other node groups will be removed. 
> 
> We strongly recommend you back up your PE 3.8 node groups before importing your PE 3.3 classification data, use the [`/v1/groups` endpoint of the Node Classifier Service API](./nc_groups.html) and save the output from this endpoint to a file. If for any reason you want to restore the state of your PE 3.8 upgrade prior to importing PE 3.3 classification data, you can do so by [POSTing the file to the `/v1/import-hierarchy` endpoint](/nc_import-hierarchy.html). For information about using the Node Classifier Service API, see [Forming Node Classifier Requests](./nc_forming_requests.html).

To import your PE 3.3 classification data:

Go to your PE 3.8 Puppet master. (If you run the import command from the Puppet master, it can use Puppet’s configuration to find the location of the Node Classifier Service API and the SSL files needed to communicate with it.)
Run the migration tool with the import command. Use the `-i` or `--input` option to specify your input file if your classification data is not in the default file, which is `converted-dashboard-classification.json` in the current directory.
	
		`/opt/puppet/bin/nc_migrate import`

The migration tool will import the converted node groups from the default or specified JSON file into PE 3.8.

Other available options when running the import command:

`--classifier-api-url` The URL to the Node Classifier Service API. Make sure that the URL does **not** include a trailing slash. (Example: `https://console.lan.mycompany.com:4432/node-classifier`)
`--ssl-key` The path to a PEM file on disk that has the private SSL key used to connect to the Node Classifier Service API. 
`--ssl-cert` The path to a PEM file on disk that has the public SSL key used to connect to the Node Classifier Service API. 
`--ssl-ca-cert` The path to a PEM file on disk that has the CA certificate used to connect to the Node Classifier Service API.

> For information about using whitelisted SSL certificates to connect to the Node Classifier Service API, see [Forming Node Classifier Requests](./nc_forming_requests.html#authentication).



* * *


- [Next: Treatment of Preconfigured Node Groups](./install_upgrade_migration_preconfigured_groups.html)