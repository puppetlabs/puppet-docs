---
layout: default
title: "PE 3.2 » Deploying PE » Non-Root Agents"
subtitle: "Running PE Agents without Root Privileges"
canonical: "/pe/latest/deploy_nonroot-agent.html"
---


**IMPORTANT**: these procedures assume some degree of experience with Puppet Enterprise (PE). If you are new to PE, Puppet Labs strongly recommends you work through the [Quick Start Guide](./quick_start.html) and some of our other educational resources before attempting to implement non-root agent capability.

Summary
------
 
In some circumstances, users without root access privileges may need to run the Puppet agent. The most common use case for this is some version of the following: 

For security or organizational reasons, your infrastructure’s platform is maintained by one team with root privileges while your infrastructure’s applications are managed by a separate team (or teams) with diminished privileges. The applications team would like to be able to manage their part of the infrastructure using Puppet Enterprise, but the platform team cannot give them root privileges. So, the applications team needs a way to run Puppet without root privileges. In this scenario, PE is only used for application management, which will be performed by a single (applications) team. The platform team will not be using PE to manage any of the application team’s nodes.

Configuration
------

### Overview

PE *must* be installed with root privileges, so the platform team will need to set up and provide non-root access to a monolithic PE master. That is, the master, console, and database roles will all be installed on a single node. Similarly, the puppet agent will be installed on the application team’s nodes by a privileged user with root access. A non-root user account will also be set up at this time.
 
This will provide a reduced set of configuration management tasks available for the application team’s nodes. Application team members will be able to configure puppet settings (i.e., edit `~/.puppet/puppet.conf`), configure Facter external facts, and run `puppet agent --test` on their nodes. Alternatively, the application team can run puppet via non-privileged cron jobs (or a similar scheduling service). The application team will classify their nodes by writing or editing manifests in the directories where they have write privileges.

Note that the application team will not be able to use PE’s orchestration capabilities to manage their nodes and Mcollective will be disabled on all nodes. 

### Installation & Configuration

In this scenario, the platform team needs to:

   * Install and configure a monolithic PE master
   * Modify the "default" group to exclude live management
   * Install and configure PE agents, disable the `pe-puppet` service on all nodes, and create non-root users 
   * Verify the non-root configuration

#### Install and Configure a Monolithic Master

The platform team starts by having a root (i.e., privileged) user install and configure a monolithic PE master with orchestration disabled. (To learn more about installing PE, refer to Installing Puppet Enterprise in the PE user’s manual.)

Disabling orchestration is done by automating the install with an [answers file](../pe/latest/install_automated.html). Once you have [downloaded the appropriate tarball](http://info.puppetlabs.com/download-pe.html) for your hardware onto the node you’ll be using for the master, generate an answers file by doing a dry-run of the installer with `puppet-enterprise-installer -s puppet_answers.txt`.  It is not necessary to install the optional cloud provisioner, but you can if you wish.

Once the answer file has been generated, edit it by adding an answer that disables live management: `q_disable_live_management=y`.

Now you can run the installer using the newly generated answer file: `puppet-installer -a puppet_answers.txt`. 

After the installation is complete, log into the console and verify that the "Live Management" tab is NOT present in the main, top nav bar.

#### Modify the “Default” Group to Exclude Live Management

We now need to ensure that any new agents that are added will not get added to the Live Management group (which would normally happen by default whenever puppet runs). 
In the console, navigate to the “Groups” tab, select the “default” group and click “Edit”.
Add the “no mcollective” group and click “Update”.

![Add the No MCO Group][add_no_mco_group]

#### Install and Configure PE Agents and Create Non-Root Users

1. For each agent node, install a PE agent while logged in as a root user. You can do this using your usual package management tools, the installer script, or with `puppet node install` if cloud provisioner was installed on the master.  If you need to, review the [instructions for installing agents](../pe/latest/install_basic.html#installing-agents).

2. Add the non-root user to the node with `puppet resource user <non-root username> ensure=present managehome=true`.

3. Set the non-root user’s password. For example, on most *nix systems you would run `passwd <username>`.

4. By default, the `pe-puppet` service runs automatically as a root user, so it needs to be disabled. As a root user on the agent node, stop the pe-puppet service by running `puppet resource service pe-puppet ensure=stopped enable=false`.

5. As the non-root user, generate and submit the cert for the agent node. Log into the agent node and execute the following command: 

    `puppet agent -t --certname "<non-root username>" --server "<master hostname>"`

    This puppet run will submit a cert request to the master and will create a `~/.puppet` directory structure in the non-root user’s home directory.

6. As the non-root user, create a Puppet configuration file (`~/.puppet/puppet.conf`) to specify the agent certname and the hostname of the master: 

		[main]
		 certname = <non-root username>
		 server = <master hostname>
		
7. Log into the console on the master and navigate to the [pending node requests](./console_cert_mgmt.html). If you think you’ll ever need to run the agent WITH root privileges, you can accept all the pending requests. If you think you will never need to run the agent with root privileges, you should reject those requests coming from root user agents and only accept the requests from non-root user agents.

8. You can now connect the non-root agent node to the master and get PE to configure it. Log into the agent as the non-root user and run `puppet agent -t`. PE should now run and apply the configuration specified in the catalog. Keep an eye on the output from the run, if you see Facter facts being created in the non-root user’s home directory, you know that you have successfully created a functional non-root agent. 

![non-root user first run output][nonrootuser_first_run]

#### Verify the Non-Root Configuration 

Check the following to make sure the agent is properly configured and functioning as desired:

- The non-root agent node should be able to request certificates and be able to download and apply the catalog from the master without issue when a non-privileged user executes `puppet agent -t`.
- The puppet agent service should not be running. Check it with `service pe-puppet status`.
- The non-root agent node should not receive the “pe-mcollective” class. You can check the console to ensure that `nonrootuser` is part of the `no mcollective` group. 

![non-root node not in mcollective group][nonroot_no_mco_group]

[TODO:Other tests a user should run to verify?

- Non-privileged users should be able to collect facts existing facts by running `facter` on agents, and they should be able to define new, external Facter facts.

#### Install and configure Windows Agents and their Certificates

If you need to run agents on nodes running a Windows OS, take the following steps:

1. Connect to the agent node as a privileged user and install the [Windows agent](./install_windows.html). 

2. As a privileged user, add the non-privileged user with the following command: `puppet resource user <non-privileged username> ensure=present managehome=true password="puppet" groups="Users"`.

  **Note**: If the non-privileged user needs remote desktop access, edit the user resource to include the "Remote Desktop Users" group.

3. While still connected as a privileged user, disable the pe-puppet service with `puppet resource service pe-puppet ensure=stopped enable=false`.

4. Log out of the Windows agent machine and log back in as the non-privileged user, and then run the following command:

   `puppet agent -t --certname "<non-privileged username>" --server "<master hostname>"`
		
   This puppet run will submit a cert request to the master and will create a `~/.puppet` directory structure in the non-root user’s home directory.

5. As the non-privileged user, create a Puppet configuration file (`%USERPROFILE%/.puppet/puppet.conf`) to specify the agent certname and the hostname of the master: 

    	[main]
     	 certname = <non-privileged username>
         server = <master hostname>
        
6. While still connected as the non-privileged user, send a cert request to the master by running puppet with `puppet agent -t`. 

7. On the master node, as a privileged user, sign the certificate request using the console or by running `puppet cert sign nonrootuser`. 

8. On the agent node, verify that the agent is connected and working by again starting a puppet run while logged in as the non-privileged user. Running `puppet agent -t` should download and process the catalog from the master without issue.

###Usage

Non-root users can only use a subset of PE’s functionality. Basically, any operation that requires root privileges (e.g., installing system packages) cannot be managed by a non-root puppet agent.

[TODO: list of examples of things a non-root agent can and can’t do]
[TODO: walk through a couple of real-life use cases]


[add_no_mco_group]: ./images/console/add_no_mco_group.png
[nonrootuser_first_run]: ./images/console/nonrootuser_first_run.png
[nonroot_no_mco_group]: ./images/console/nonroot_no_mco_group.png

* * *

- [Next: Beginners Guide to Modules](../guides/module_guides/bgtm.html)