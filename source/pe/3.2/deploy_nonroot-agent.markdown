---
layout: default
title: "PE 3.2 » Deploying PE » Non-Root Agents"
subtitle: "Running PE Agents without Root Privileges"
canonical: "/pe/latest/deploy_nonroot-agent.html"
---


**IMPORTANT**: these procedures assume some degree of experience with Puppet Enterprise (PE). If you are new to PE, we strongly recommend you work through the [Quick Start Guide](./quick_start.html) and some of our other educational resources before attempting to implement non-root agent capability.

Summary
------
 
In some circumstances, users without root access privileges may need to run the Puppet agent. The most common use case for this is some version of the following: 

For security or organizational reasons, your infrastructure’s platform is maintained by one team with root privileges while your infrastructure’s applications are managed by a separate team (or teams) with diminished privileges. The applications team would like to be able to manage their part of the infrastructure using Puppet Enterprise, but the platform team cannot give them root privileges. So, the applications team needs a way to run Puppet without root privileges. In this scenario, PE is only used for application management, which will be performed by a single (applications) team. The platform team will not be using PE to manage any of the application team’s nodes.

The instructions below are tailored to setting up non-root agents for this scenario. You may be able to adapt them to other scenarios, but in all cases you will need to make sure you are still adhering to these instructions in order for non-root agents to function correctly.

Configuration
------

### Overview

PE *must* be installed with root privileges, so the platform team will need to set up and provide non-root access to a monolithic PE master. That is, the master, console, and database roles will all be installed on a single node by a user with root privileges. Similarly, the puppet agent must also be installed on the application team’s nodes by a privileged user. A non-root user account will also be set up at this time.
 
This will provide a reduced set of configuration management tasks available for the application team’s nodes. Application team members will be able to configure puppet settings (i.e., edit `~/.puppet/puppet.conf`), configure Facter external facts, and run `puppet agent --test` on their nodes. Alternatively, the application team can run puppet via non-privileged cron jobs (or a similar scheduling service). The application team will classify their nodes by writing or editing manifests in the directories where they have write privileges.

Note that the application team will not be able to use PE’s orchestration capabilities to manage their nodes, and non-root agents need to be added to the `no mcollective` group. 

### Installation & Configuration

In this scenario, the platform team needs to:

   * Install and configure a monolithic PE master
   * Add non-root agents to the `no mcollective` group 
   * Install and configure PE agents, disable the `pe-puppet` service on all nodes, and create non-root users 
   * Verify the non-root configuration

#### Install and Configure a Monolithic Master

The platform team starts by having a root (i.e., privileged) user install and configure a monolithic PE master. (To learn more about installing PE, refer to [Installing Puppet Enterprise](../pe/latest/install_basic.html).)

#### Add non-root agents to the `no mcollective` group

We now need to ensure that non-root agents are added to the `no mcollective` group.
In the console sidebar, click the **no mcollective** group and click **Edit** to navigate to the group edit page. Start typing the name of your non-root agent into the **Add a node** text field. As you type, an auto-completion list appears. Select the appropriate node and click **Update**.


#### Install and Configure PE Agents and Create Non-Root Users

1. For each agent node, install a PE agent while logged in as a root user. You can do this using your usual package management tools, the installer script, or with `puppet node install` if cloud provisioner was installed on the master.  If you need to, review the [instructions for installing agents](../pe/latest/install_basic.html#installing-agents).

2. Add the non-root user to the node with `puppet resource user <unique non-root username> ensure=present managehome=true`. Each and every non-root user *must* have a unique name.

3. Set the non-root user’s password. For example, on most *nix systems you would run `passwd <username>`.

4. By default, the `pe-puppet` service runs automatically as a root user, so it needs to be disabled. As a root user on the agent node, stop the service by running `puppet resource service pe-puppet ensure=stopped enable=false`. If you wish to use `su - nonrootuser` to switch between accounts, make sure to use the `-` (`-l` in some unix variants) argument so that full login privileges are correctly granted. Otherwise you may see "permission denied" errors when trying to apply a catalog.

5. As the non-root user, generate and submit the cert for the agent node. Log into the agent node and execute the following command: 

    `puppet agent -t --certname "<unique non-root username.hostname>" --server "<master hostname>"`

    This puppet run will submit a cert request to the master and will create a `~/.puppet` directory structure in the non-root user’s home directory.

6. As the non-root user, create a Puppet configuration file (`~/.puppet/puppet.conf`) to specify the agent certname and the hostname of the master: 

		[main]
		 certname = <unique non-root username.hostname>
		 server = <master hostname>
		
7. Log into the console on the master and navigate to the [pending node requests](./console_cert_mgmt.html) and accept the requests from non-root user agents.  
    
    **Note**: It is possible to also sign the root user certificate in order to allow that user to also manage the node. However, you should do so only with great caution as this introduces the possibility of unwanted behavior and potential security issues. For example, if your site.pp has no default node configuration, running agent as non-admin could lead to unwanted node definitions getting generated using alt hostnames, a potential security issue. In general, then, if you deploy this scenario you should be careful to ensure the root and non-root users never try to manage the same resources, have clear-cut node definitions, ensure that classes scope correctly, and so forth.

8. You can now connect the non-root agent node to the master and get PE to configure it. Log into the agent as the non-root user and run `puppet agent -t`. PE should now run and apply the configuration specified in the catalog. Keep an eye on the output from the run, if you see Facter facts being created in the non-root user’s home directory, you know that you have successfully created a functional non-root agent. 

![non-root user first run output][nonrootuser_first_run]

#### Verify the Non-Root Configuration 

Check the following to make sure the agent is properly configured and functioning as desired:

- The non-root agent node should be able to request certificates and be able to download and apply the catalog from the master without issue when a non-privileged user executes `puppet agent -t`.
- The puppet agent service should not be running. Check it with `service pe-puppet status`.
- The non-root agent node should not receive the “pe-mcollective” class. You can check the console to ensure that `nonrootuser` is part of the `no mcollective` group. 

![non-root node not in mcollective group][nonroot_no_mco_group]

- Non-privileged users should be able to collect existing facts by running `facter` on agents, and they should be able to define new, external Facter facts.

#### Install and Configure Windows Agents and Their Certificates

If you need to run agents without admin privileges on nodes running a Windows OS, take the following steps:

1. Connect to the agent node as an admin user and install the [Windows agent](./install_windows.html). 

2. As an admin user, add the non-admin user with the following command: `puppet resource user <unique non-admin username> ensure=present managehome=true password="puppet" groups="Users"`. 

    **Note:** Each and every non-admin user *must* have a unique name. If the non-privileged user needs remote desktop access, edit the user resource to include the "Remote Desktop Users" group.

3. While still connected as an admin user, disable the pe-puppet service with `puppet resource service pe-puppet ensure=stopped enable=false`.

4. Log out of the Windows agent machine and log back in as the non-admin user, and then run the following command:

   `puppet agent -t --certname "<unique non-privileged username>" --server "<master hostname>"`
		
   This puppet run will submit a cert request to the master and will create a `~/.puppet` directory structure in the non-root user’s home directory.

5. As the non-admin user, create a Puppet configuration file (`%USERPROFILE%/.puppet/puppet.conf`) to specify the agent certname and the hostname of the master:  

        [main]
        certname = <unique non-privileged username.hostname>  
        server = <master hostname>  
        
6. While still connected as the non-admin user, send a cert request to the master by running puppet with `puppet agent -t`. 

7. On the master node, as an admin user, sign the non-root certificate request using the console or by running `puppet cert sign nonrootuser`.  

    **Note**: It is possible to also sign the root user certificate in order to allow that user to also manage the node. However, you should do so only with great caution as this introduces the possibility of unwanted behavior and potential security issues. For example, if your site.pp has no default node configuration, running agent as non-admin could lead to unwanted node definitions getting generated using alt hostnames, a potential security issue. In general, then, if you deploy this scenario you should be careful to ensure the root and non-root users never try to manage the same resources, have clear-cut node definitions, ensure that classes scope correctly, and so forth.  

8. On the agent node, verify that the agent is connected and working by again starting a puppet run while logged in as the non-admin user. Running `puppet agent -t` should download and process the catalog from the master without issue.

### Usage

Non-root users can only use a subset of PE’s functionality. Basically, any operation that requires root privileges (e.g., installing system packages) cannot be managed by a non-root puppet agent.

On ***nix systems**, as non-root agent you should be able to enforce the following resource types:

* `cron` (only non-root cron jobs can be viewed or set)
* `exec` (cannot run as another user or group)
* `file` (only if the non-root user has read/write privileges)
* `notify`
* `schedule`
* `ssh_key`
* `ssh_authorized_key`
* `service`
* `augeas`

You should also be able to inspect the following resource types (use `puppet resource <resource type>`):

* `host`
* `mount`
* `package`

On **windows systems** as non-admin user you should be able to enforce the following resource types :

* `exec`
* `file`

**NOTE**: A non-root agent on Windows is extremely limited as compared to non-root *nix. While you can use the above resources, you are limited on usage based on what the agent user has access to do (which isn't much). For instance, you can't create a file\directory in `C:\Windows` unless your user has permission to do so.

You should also be able to inspect the following resource types (use `puppet resource <resource type>`):

* `host`
* `package`
* `user`
* `group`
* `service`


#### Issues & Warnings

 - When running a cron job as non-root user, using the `-u` flag to set a user with root privileges will cause the job to fail, resulting in the following error message:  
 `Notice: /Stage[main]/Main/Node[nonrootuser]/Cron[illegal_action]/ensure: created must be privileged to use -u`


[add_no_mco_group]: ./images/console/add_no_mco_group.png
[nonrootuser_first_run]: ./images/console/nonrootuser_first_run.png
[nonroot_no_mco_group]: ./images/console/nonroot_no_mco_group.png

* * *

- [Next: Beginners Guide to Modules](../guides/module_guides/bgtm.html)