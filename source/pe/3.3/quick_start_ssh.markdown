---
layout: default
title: "PE 3.3 » Quick Start » SSH"
subtitle: "SSH Quick Start Guide"
canonical: "/pe/latest/quick_start_ssh.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Puppet Enterprise SSH Quick Start Guide. This document provides instructions for getting started managing SSH across your PE deployment using a module from the Puppet Forge.

Secure Shell (SSH) is a protocol that enables encrypted connections between nodes on a network for administrative purposes. It is most commonly used in the *nix world by admins who wish to remotely log into machines to access the command line and execute commands and scripts.

Typically, the first time you attempt to SSH into a host you’ve never connected to before, you get a warning similar to the following:

    The authenticity of host '10.10.10.9 (10.10.10.9)' can't be established.
    RSA key fingerprint is 05:75:12:9a:64:2f:29:27:39:35:a6:92:2b:54:79:5f.
    Are you sure you want to continue connecting (yes/no)?

If you select yes, the public key for that host is added to your SSH `known_hosts` file, and you won’t have to authenticate it again unless that host’s key changes. 

The SSH module you’ll install in this guide uses Puppet resources that collect and distribute the public key for each agent node in your PE deployment, which will enable you to SSH to and from any node without authentication warnings. 

Using this guide, you will:

* [install the saz-ssh module](#install-the-saz-ssh-module).
* [use the PE console to add classes from the SSH module to your agent nodes](#use-the-pe-console-to-add-classes-from-the-ssh-module). 
* [use the PE console event inspector to view changes to your infrastructure made by the `ssh` class](#use-the-console-event-inspector-to-view-changes-made-by-the-ssh-class).
* [use the PE console to edit root login parameters of the `ssh` class](#use-the-pe-console-to-edit-root-login-parameters-of-the-ssh-class).


### Install Puppet Enterprise and the Puppet Enterprise Agent

If you haven't already done so, you'll need to get PE installed. See the [system requirements][sys_req] for supported platforms. 

1. [Download and verify the appropriate tarball][downloads].
2. Refer to the [installation overview][install_overview] to determine how you want to install PE, and follow the instructions provided.
3. Refer to the [agent installation instructions][agent_install] to determine how you want to install your PE agent(s), and follow the instructions provided.


### Install the saz-ssh Module

The saz-ssh module, available on the Puppet Forge, is one of many modules written by  members of our user community.  

You can learn more about the saz-ssh module by visiting[http://forge.puppetlabs.com/saz/ssh](http://forge.puppetlabs.com/saz/ssh). 

**To install the saz-ssh module**:

From the PE master, run `puppet module install saz-ssh`.

You should see output similar to the following: 

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── saz-ssh (v2.3.6)
              └── puppetlabs-stdlib (3.2.2) [/opt/puppet/share/puppet/modules]

> That's it! You've just installed the saz-ssh module. All of the classes in it are now available to be added to the console and assigned to your agent nodes.
>
> Note: the Puppet Labs Standard Library module is listed as a dependency for the saz-ssh module. But it was installed as part of your PE installation. 

### Create SSH Group

Groups let you assign classes and variables to many nodes at once. Nodes can belong to many groups and will inherit classes and variables from all of them. Groups can also be members of other groups and inherit configuration information from their parent group the same way nodes do. PE automatically creates several groups in the console, which you can read more about in the [PE docs](./console_classes_groups.html#special-groups).

In this procedure, you’ll create a simple group called, __ssh_example__, but you can add the `ssh` class to any existing group, or create your own group.  

[add_ssh_group]: ./images/quick/add_ssh_group.png

**To create the ssh_example group**:

1. From the console sidebar, click __Add Group__.
2. From the __Add Node group__ page, in the __Name__ field, name your group (e.g., **ssh_example**).
 
   ![adding the ssh group][add_ssh_group]

3. In the __Add a node__ field, type in the name of each node you’d like to add. 
4. Click __Update__. 


### Use the PE Console to Add Classes from the SSH Module

[classbutton]: ./images/quick/add_class_button.png
[add_ssh]: ./images/quick/add_ssh.png
[assign_ssh_group]: ./images/quick/assign_ssh_group.png

The saz-ssh module contains several **classes**. [Classes](../puppet/3/reference/lang_classes.html) are named chunks of Puppet code and are the primary means by which Puppet Enterprise configures nodes. Some useful classes in the saz-ssh module include:

* `ssh`: the main class; this class handles all the other classes (including the classes in this list).
* `ssh::hostkeys`: creates host keys on your servers, if needed.
* `ssh::knownhosts`: contains Puppet resources that manages known host keys. 
* `ssh::client::config`: contains Puppet resources that manages the client configuration file.
* `ssh::server::config`: contains Puppet resources that manages the server configuration file.
 
You're going to add the `ssh` class to the **ssh_example** node group. Depending on your needs or infrastructure, you may have a different group that you'll assign SSH to, but these same instructions would apply. 

After you apply the `ssh` class and run Puppet, the public key for each agent node will be exported and then disseminated to the known_hosts files of the other agent nodes in the group, and you will no longer be asked to authenticate those nodes on future SSH attempts. 

**To add the** `ssh` **class to the ssh_example group**:

1. From the console, click __Add classes__ in the sidebar:

   ![The console's add classes button][classbutton]

2. In the list of classes, locate `ssh`, and select it. 

   ![the add class field][add_ssh]
   
3. Click __Add selected classes__.

4. Navigate to the __ssh_example__ group page.

5. Click __Edit__ and begin typing "`ssh`" in the __Classes__ field; you can select `ssh` from the list of autocomplete suggestions. 
   ![assigning the ntp class to default group][assign_ssh_group]
   
   **Tip**: You only need to add the main `ssh` class; it contains the other classes from the module. 
   
6. Click __Update__. 

   **Note**: The `ssh` class now appears in the list of classes for the __ssh_example__ group, but the SSH keys have not yet been shared across your agent nodes. For that to happen, you need to kick off a Puppet run. 
   
7. Navigate to the live management page, and select the __Control Puppet__ tab. 

8. Click the __runonce__ action and then __Run__. Wait one or two minutes and run Puppet a second time. 

   **Important**: You need to run Puppet a second time due to the round-robin nature of the key sharing. In other words, the first server that ran on the first Puppet run was only able to share its key, but it was not also able to retrieve the keys from the other agents. It will collect the other keys on the second Puppet run. 

9. Attempt to SSH from one agent to another. Note that you are no longer asked to verify the authenticity of the host. 

> **That’s it!** Puppet Enterprise is now managing SSH known_host files for the agent nodes in your deployment. The next section will use the PE console event inspector to examine the events and SSH configuration files PE is now managing. 

### Use the Puppet Enterprise Console Event Inspector to View Changes Made by the `ssh` Class

[ssh_ei_default]: ./images/quick/ssh_ei_default.png
[ssh_ei_class_change]: ./images/quick/ssh_ei_class_change.png
[ssh_ei_detail]: ./images/quick/ssh_ei_detail.png

The PE console event inspector lets you view and research changes and other events. For example, after applying the `ssh` class, you can use event inspector to confirm that changes (or "events") were indeed made to your infrastructure. 

Note that in the summary pane on the left, one event, a successful change, has been recorded for **Classes: with events**. However, there are three changes for **Classes: with events** and six changes **Resources: with events**. 

![The default event inspector view][ssh_ei_default]

Click __With Changes__ in the __Classes: with events__ summary view. The main pane will show you that the `Ssh:Knownhosts` class was successfully added when you ran PE after adding the main `ssh` class. This class set the `known_hosts` entries after it collects the public keys from agents nodes in your deployment .

![Viewing a successful change][ssh_ei_class_change]

Click __Changed__ in the __Resources: with events__ summary view. The main page will show you that public key resources for each agent in our example has now been brought under PE management. The further you drill down, the more information you’ll receive about the event. For example, in this case, you see that the the SSH rsa key for __agent1.example.com__ has been created and is now present in the `known_hosts` file for __master.example.com__.

![Event detail][ssh_ei_detail]

If there had been a problem applying any piece of the `ssh` class, the information found here could tell you exactly which piece of code you need to fix. In this case, event inspector simply lets you confirm that PE is now managing SSH keys.

In the upper right corner of the detail pane is a link to a run report which contains information about the Puppet run that made the change, including logs and metrics about the run. Visit the [reports page](./console_reports.html#reading-reports) for more information.

For more information about using the PE console event inspector, check out the [event inspector docs](./console_event_inspector). 

 
### Use the PE Console to Edit Root Login Parameters of the `ssh` Class

[ssh_params]: ./images/quick/ssh_params.png

With Puppet Enterprise you can edit or add class parameters directly in the PE console without needing to edit the module code directly. 

The saz-ssh module, by default, allows root login over SSH, but what if your compliance protocols do not allow this on certain pools of agent nodes? 

Changing this parameter of the `ssh` class can be accomplished in a few steps using the PE console.

**To edit the root login parameter of the** `ssh` **class**: 

1. Navigate to the ssh_example group page, and click __Edit__.
3. Find __ssh__ in the class list, and click __Edit parameters__.
4. For the `server_options` parameter, enter the in the value field: `{"PermitRootLogin"=>"no"}`.

   ![the SSH parameters list][ssh_params]

   **Note**: The grey text that appears as values for some parameters is the default value, which can be either a literal value or a Puppet variable. You can restore this value with the __Reset value__ control that appears next to the value after you have entered a custom value.
 
5. Click __Done__. 
6. Navigate to the live management page, and select the __Control Puppet__ tab. 
7. Click the __runonce__ action and then __Run__ to trigger a Puppet run to have Puppet Enterprise create the new configuration. 
8. Attempt to SSH from one agent to another. Note that root login permissions are now denied over SSH. 

> Puppet Enterprise is now managing the root login parameter for your SSH configuration. You can see this setting in `/etc/ssh/sshd_config`. For fun, change the `PermitRootLogin` parameter to `yes`, run PE, and then recheck this file. As long as the parameter is set to `no` in the PE console, the parameter in this file will be set back to `no` on every Puppet run if it is ever changed.
>
> You can use the PE console to manage other SSH parameters, such as agent forwarding, X11 forwarding, and password authentication.


### Other Resources

For a video on automating SSH with Puppet Enterprise, check out [Automate SSH configuration in 5 minutes with Puppet Enterprise](http://puppetlabs.com/resources/video/automate-ssh).

[Speed up SSH by reusing connections](https://puppetlabs.com/blog/speed-up-ssh-by-reusing-connections) on the Puppet Labs blog gives some helpful hints for working with SSH. 

Puppet Labs offers many opportunities for learning and training, from formal certification courses to guided online lessons. We've noted a few below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* [Learning Puppet](http://docs.puppetlabs.com/learning/) is a series of exercises on various core topics about deploying and using PE. 
* The Puppet Labs workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).


