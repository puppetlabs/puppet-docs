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

### Overview:

PE *must* be installed with root privileges, so the platform team will need to set up and provide non-root access to a monolithic PE master. That is, the master, console, and database roles will all be installed on a single node. Similarly, the puppet agent will be installed on the application team’s nodes by a privileged user with root access. A non-root user account will also be set up at this time.
 
This will provide a reduced set of configuration management tasks available for the application team’s nodes. Application team members will be able to configure puppet settings (i.e., edit `~/.puppet/puppet.conf`), configure Facter external facts, and run `puppet agent --test` on their nodes. Alternatively, the application team can run puppet via non-privileged cron jobs (or a similar scheduling service). The application team will classify their nodes by writing or editing manifests in the directories where they have write privileges.

Note that the application team will not be able to use PE’s orchestration capabilities to manage their nodes and Mcollective will be disabled on all nodes. 

### Installation & Configuration

In this scenario, the platform team needs to:

   * Install and configure a monolithic PE master
   * Disable the orchestration engine (MCollective)
   * Install the puppet agent on the nodes the application team wants to manage with PE
   * Create and configure a non-root user account
   * Disable the `pe-puppet` service on all nodes

#### Install and Configure a Monolithic Master

The platform team starts by having a privileged (i.e., root) user install and configure a monolithic PE master with orchestration disabled. (To learn more about installing PE, refer to Installing Puppet Enterprise in the PE user’s manual.)

Disabling orchestration is done by automating the install with an [answers file](../pe/latest/install_automated.html). Once you have [downloaded the appropriate tarball](http://info.puppetlabs.com/download-pe.html) for your hardware onto the node you’ll be using for the master, generate an answers file by doing a dry-run of the installer with `puppet-installer -s puppet_answers.txt`.  It is not necessary to install the optional cloud provisioner, but you can if you wish.

Once the answer file has been generated, edit it by adding an answer that disables Live Management: `q_disable_live_management=y`.

Now you can run the installer using the newly generated answer file: `puppet-installer -a puppet_answers.txt`. 

After the installation is complete, log into the console and verify that the "Live Management" tab is NOT present in the main, top nav bar.

#### Modify the “Default” Group to Exclude Live Management

We now need to ensure that any new agents that are added will not get added to the Live Management group (which would normally happen by default whenever puppet runs). 
In the console, navigate to the “Groups” tab, select the “default” group and click “Edit”.
Add the “no mcollective” group and click “Update”.

![Add the No MCO Group][add_no_mco_group]

#### Install and Configure PE Agents and Create Non-Root Users

1. For each agent node, install a PE agent while logged in as a privileged (root) user. You can do this using the installer (or with `puppet node install` if cloud provisioner was installed) on the master (TODO: might need to modify/add frictionless agent stuff).

2. Add the non-root user to the node with: `puppet resource user <username> ensure=present managehome=true`.

3. Set the non-root user’s password. For example, on most *nix systems you would run `passwd <username>`.

4. By default, the `pe-puppet` service runs automatically as a root user, so it needs to be disabled. As a privileged user on the agent node, stop the pe-puppet service by running `puppet resource service pe-puppet ensure=stopped enable=false`.

5. Generate and submit the cert for the agent node as the non-root user.  Log into the agent node as the non-privileged user and execute the following command: 

    `puppet agent -t --certname "<non-root username>" --server "<master hostname>"`

    This puppet run will submit a cert request to the master and will create a ‘~/puppet` directory structure in the non-root user’s home directory.

6. Add the non-root user to the agent by modifying the puppet.conf file. On the agent node, as a non-privileged user, create a Puppet configuration file (`~/.puppet/puppet.conf`) and edit it to include  the following:

{% highlight ruby %}
    [main]
    certname = nonrootuser
    server = master
     .
     .
     .
{% endhighlight %}     

7. Log into the console on the master and navigate to the pending node requests [TODO: link]. If you think you’ll ever need to run the agent WITH root privileges, you can Accept all the pending requests. If you think you will never need to run the agent with root privileges, you should Reject those requests coming from root user agents and only Accept the requests from non-root user agents.

8. You can now connect the non-root agent node to the master and get PE to configure it. Log into the agent as the non-root user and run `puppet agent -t`. PE should now run and apply the configuration specified in the catalog. Keep an eye on the output from the run, if you see Facter facts being created in the non-root user’s home directory, you know that you have successfully created a functional non-root agent. 

![non-root user first run output][nonrootuser_first_run]

#### Verification
Check the following to make sure the agent is properly connected and functioning as desired:

- The agent should be able to download and apply the catalog from the master without issue when a non-privileged user executes `puppet agent -t`.
The puppet agent service should not be running. Check it with `service pe-puppet status`.
Nodes running non-root agents should not receive the “pe-mcollective” class. Once the agent is connected to the master, run `/etc/puppetlabs/puppet-dashboard/external_node AGENT_CERT`. The agent should not receive the “pe mcollective” class. You can also check the console and ensure that `nonrootuser` is part of the `no mcollective` group. [TODO screenshot]
Other tests a user should run to verify?

- At this point, a non-root agent should be able to request certificates and complete puppet runs. Non-root agents should be able to process catalogs from the master without error. 

- Non-privileged users should be able to collect facts existing facts by running `facter` on agents, and they should be able to define new, external Facter facts.

#### Install and configure Windows Agents and their Certificates

If you need to run agents on nodes running a Windows OS, take the following steps:

1. Connect to the agent node as a privileged user and installing the agent as an Administrator. 

2. On the command line, run the following to add the non-root user: `puppet resource user nonrootuser ensure=present managehome=true password="puppet" groups="Users"`.

3. While still connected as a privileged user, disable the pe-puppet service with `puppet resource service pe-puppet ensure=stopped enable=false`.

4. Log out of the Windows agent machine and log back in again, this time as the non-privileged user. Then, edit the puppet configuration file (`%USERPROFILE%\.puppet\puppet.conf`) as follows:

{% highlight ruby %}
    [main]
    certname = nonrootuser
    server = master
    .
    .
    .
{% endhighlight %}

5. While still connected as the non-privileged user, send a cert request to the master by running puppet with `puppet agent -t`. 

6. On the master node, as a privileged user, sign the certificate request using the console or by running `puppet cert sign nonrootuser`. 

7. On the agent node, verify that the agent is connected and working by again starting a puppet run while logged in as the non-privileged user. Running `puppet agent -t` should download and process the catalog from the master without issue.

###Usage

Non-root users can only use a subset of PE’s functionality. Basically, any operation that requires root privileges (e.g., installing system packages) cannot be managed by a non-root puppet agent.

[TODO: list of examples of things a non-root agent can and can’t do]
[TODO: walk through a couple of real-life use cases]


[add_no_mco]: .images/console/add_no_mco_group.png
[non root user first run]: .images/console/nonrootuser_first_run.png

* * *

- [Next: Beginners Guide to Modules](../guides/module_guides/bgtm.html)