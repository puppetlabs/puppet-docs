---
layout: default
title: "PE 3.7 » Installing » Upgrading"
subtitle: "Upgrading Puppet Enterprise"
canonical: "/pe/latest/install_upgrading.html"
---


## Upgrading Overview

> **Important**: Before upgrading, please review [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html), as some user action is required. Please also review [Upgrading Puppet Enterprise: Notes and Warnings](install_upgrading_notes.html), which includes important information about upgrading to the new node classifier and the new Puppet Server running on the Puppet master.
>
> Currently upgrades to PE 3.7.0 are only supported from 3.3.2.
>
> We generally recommend updating your PE deployments in full before upgrading to a new version. We also recommend [cleaning old reports](./maintain_console-db.html#cleaning-old-reports) and [pruning your database](./maintain_console-db.html#pruning-the-console-database-with-a-cron-job), to reduce the time it takes to upgrade.

The Puppet Installer script is used to perform both installations and upgrades. The script will check for a prior version and run as upgrader or installer as needed. You start by [downloading][downloading] and unpacking a tarball with the appropriate version of the PE packages for your system. Then, when you run the `puppet-enterprise-installer` script, the script will check for a prior installation of PE and, if it detects one, will ask if you want to proceed with the upgrade. The installer will then upgrade all the PE components (master, agent, etc.) it finds on the node to version 3.7.

>**Note**: When you upgrade PE, older versions are left in your `/opt/puppet/packages/public` folder. They won't cause any problems, but if you want to save space, you can remove the old PE files that are no longer needed from this folder.

## Download PE

If you haven't done so already, you will need a Puppet Enterprise tarball appropriate for your system(s). See the [Installing PE][downloading] section of this guide for more information on accessing Puppet Enterprise tarballs, or go directly to the [download page](http://info.puppetlabs.com/download-pe.html).

[downloading]: ./install_basic.html#downloading-puppet-enterprise

Once downloaded, copy the appropriate tarball to each node you'll be upgrading.

Before starting the upgrade, all of the components (agents, master, console, etc.) in your current deployment should be correctly configured and communicating with each other, and live management should be up and running with all nodes connected.

## Upgrading a Monolithic Installation

If you have a monolithic installation (with the master, PE console, and database components all on the same node), the process involves the following steps, which **must be performed in the following order**:

1. [Upgrade the monolithic PE server](#step-1-upgrade-the-monolithic-pe-server)
2. [Classify the new PE groups](#classify-the-new-pe-groups)
3. [Upgrade Puppet agent nodes](#upgrade-agents)

### Upgrade the Monolithic PE Server

> **Important:** All installer commands should be run as `root`.

Start the upgrade by running the `puppet-enterprise-installer` script on the monolithic PE server. From the PE installer directory, run the following command:

    sudo ./puppet-enterprise-installer

The script will detect any previous versions of PE components and stop any PE services that are currently running. The script will then step through the install script, providing default answers based on the components it has detected on the monolithic PE server. The upgrader should be able to answer all of the questions based on your current installation before starting the upgrade.

As with installation, the script will also check for any missing dependent vendor packages and offer to install them automatically.

Lastly, the script will summarize the upgrade plan and ask you to go ahead and perform the upgrade. Your answers to the script will be saved as usual in `/etc/puppetlabs/installer/answers.install`.

The upgrade script will run and provide detailed information as to what it installs, what it updates and what it replaces. It will preserve existing certificates and `puppet.conf` files.

> **Notes**: 
>
> - The new node classifier and role-based access control (RBAC) will be installed as part of the PE console.
> - If necessary, after upgrading, see the instructions for [Disabling/Enabling Live Management During an Upgrade](#disablingenabling-live-management-during-an-upgrade).

### Classify PE Groups

Please see [section on classifying PE groups](#classify-the-new-pe-groups) below.  

### Upgrade Puppet Agents

Please see [section on upgrading Puppet agents](#upgrade-agents).


##  Upgrading a Split Installation

If you have a split installation (with the master, PE console, and database components on different nodes), the process involves the following steps, which **must be performed in the following order**:

1. [Upgrade the Puppet Master](#upgrade-the-puppet-master)
2. [Upgrade PuppetDB](#upgrade-puppetdb)
3. [Upgrade the PE Console](#upgrade-the-pe-console)
4. [Classify the PE groups](#classify-the-new-pe-groups)
5. [Upgrade Puppet agent nodes](#upgrade-agents)

> **Note**: When upgrading to PE 3.7.x, the node classifier and role-based access control (RBAC) will be installed on the PE console node.

> ![windows logo](./images/windows-logo-small.jpg) To upgrade Windows agents, simply download and run the new MSI package as described in [Installing Windows Agents](./install_windows.html). However, be sure to upgrade your master, console, and database nodes first.

### Upgrade the Puppet Master

> **Important:** All installer commands should be run as `root`.

Start the upgrade by running the `puppet-enterprise-installer` script on the master node.  From the PE installer directory, run the following command:

    sudo ./puppet-enterprise-installer

The script will detect any previous versions of PE components and stop any PE services that are currently running. The script will then step through the install script, providing default answers based on the components it has detected on the node (e.g., if the script detects only an agent on a given node, it will provide "No" as the default answer to installing the master component). The upgrader should be able to answer all of the questions based on your current installation except for the hostname and port of the PuppetDB node you prepped before starting the upgrade.

As with installation, the script will also check for any missing dependent vendor packages and offer to install them automatically.

Lastly, the script will summarize the upgrade plan and ask you to go ahead and perform the upgrade. Your answers to the script will be saved as usual in `/etc/puppetlabs/installer/answers.install`.

The upgrade script will run and provide detailed information as to what it installs, what it updates and what it replaces. It will preserve existing certificates and `puppet.conf` files.

### Upgrade PuppetDB

> **Note**: The upgrader can install a pre-configured version of PostgreSQL (must be version 9.2) along with PuppetDB on the node you select. If you prefer to use a node with an existing instance of PostgreSQL, that instance needs to be manually configured with the correct users and access. This also needs to be done BEFORE starting the upgrade.

On the node you provisioned for PuppetDB before starting the upgrade, unpack the PE 3.7 tarball and run the `puppet-enterprise-installer` script. From the PE installer directory, run the following command:

    sudo ./puppet-enterprise-installer

### Upgrade the PE Console

On the node serving the console component, unpack the PE 3.7 tarball and run the `puppet-enterprise-installer` script. From the PE installer directory, run the following command:

    sudo ./puppet-enterprise-installer

The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment.

The installer will also ask for the following information:

* The hostname and port number for the PuppetDB node you created in the previous step.
* Database credentials; specifically, the database names, user names, and passwords for the console, role-based access control (RBAC), and PuppetDB databases. These can be found in `/etc/puppetlabs/installer/database_info.install` on the PuppetDB node.

**Important**: If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.2 or higher.

In addition if you are using an external PostgreSQL instance that is not managed by PE, please note the following:

1. You will need to create databases for RBAC, activity service, and the node classifier before upgrading.
2. The databases you create need to have the citext extension enabled.

#### Disabling/Enabling Live Management During an Upgrade

The status of live management is not managed during an upgrade of PE unless you specifically indicate a change is needed in an answer file. In other words, if your previous version of PE had live management enabled (the PE default), it will remain enabled after you upgrade unless you add or change `q_disable_live_manangement={y|n}` in your answer file.

Depending on your answer, the `disable_live_management` setting in `/etc/puppetlabs/puppet-dashboard/settings.yml` on the Puppet master (or console node in a split install) will be set to either `true` or `false` after the upgrade is complete.

(Note that you can enable/disable Live Management at any time during normal operations by editing the aforementioned `settings.yml` and then running `sudo /etc/init.d/pe-httpd restart`.)

### Classify PE Groups

Please see [section on classifying PE groups](#classify-the-new-pe-groups) below.  

### Upgrade Puppet Agents

Please see [section on upgrading Puppet agents](#upgrade-agents).

## Classify the New PE Groups 

**Warning**: After upgrading to 3.7.x from 3.3, you must classify the new PE groups. **This applies to both split and monolithic upgrades.

For upgrades, these groups are created but no classes are added to them. This helps prevent errors during the upgrade process, but it means that if you're upgrading, you have to manually add classes to each node.

The [preconfigured groups doc](./console_classes_groups_preconfigured_groups.html) has a list of groups and their classes that get installed on fresh upgrades.

**After upgrading, you must classify the new PE groups**. We recommend that you perform the manual classification in the following order and use the [preconfigured groups doc](./console_classes_groups_preconfigured_groups.html) to determine which classes to apply to the PE node groups. The ordered specified is as follows:

1. The PE Infrastructure node group
2. The PE Certificate Authority node group
3. The PE Master node group
4. The PuppetDB node group
5. The PE Console node group
6. The PE ActiveMQ Broker node group

## Upgrade Agents

If you are using the PE package repo hosted on the Puppet master, it will get upgraded when you upgrade the Puppet master.

You will want to perform these steps:

1. Upgrade your Puppet master.
2. Follow the instructions for [using the agent install script](./install_agents.html#installing-agents-using-pe-package-management) to upgrade your agents.

   a. If the OS/architecture of your Puppet master is the same as your agents, choose [scenario 1](./install_agents.html#scenario-1-the-osarchitecture-of-the-puppet-master-and-the-agent-node-are-the-same).

   b. If the OS/architecture of your Puppet master is different than your agents, choose [scenario 2](./install_agents.html#scenario-1-the-osarchitecture-of-the-puppet-master-and-the-agent-node-are-the-same).

If you are using your own package manager (e.g., Satellite), the simplest way to upgrade agents is to upgrade the `pe-agent` package in the repo your package manager (e.g., Satellite) is using.

For nodes running an OS that doesn't support remote package repos (e.g., Windows) you'll need to use the installer script on the PE tarball as you did for the Puppet master, etc. On each node with a Puppet agent, unpack the PE 3.7 tarball and run the `puppet-enterprise-installer` script. The installer will detect the version from which you are upgrading and answer as many installer questions as possible based on your existing deployment. Note that the agents on your Puppet master, PE console, and PuppetDB nodes will have been updated already when you upgraded those nodes.

PE services should restart automatically after the upgrade. But if you want to check that everything is working correctly, you can run `puppet agent -t` on your agents to ensure that everything is behaving as it was before upgrading. Generally speaking, it's a good idea to run Puppet right away after an upgrade to make sure everything is hooked and has the latest configuration.

## Checking For Updates

[Check here][updateslink] to find out the latest maintenance release of Puppet Enterprise. To see the version of PE you are currently using, you can run `puppet --version` on the command line.

{% comment %} This link is the same one as the console's help -> version information link. We only have to change the one to update both. {% endcomment %}

[updateslink]: http://info.puppetlabs.com/download-pe.html

**Note: By default, the Puppet master will check for updates whenever the `pe-puppetserver` service restarts.** As part of the check, it passes some basic, anonymous information to Puppet Labs' servers. This behavior can be disabled if need be. The details on what is collected and how to disable checking can be found in one of the [answer file references](./install_mono_answers.html#puppet-master-answers).

* * *


- [Next: Uninstalling](./install_uninstalling.html)
