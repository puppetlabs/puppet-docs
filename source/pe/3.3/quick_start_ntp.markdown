---
layout: default
title: "PE 3.3 » Quick Start » NTP"
subtitle: "NTP Quick Start Guide"
canonical: "/pe/latest/quick_start_ntp.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Welcome to the Puppet Enterprise NTP Quick Start Guide. This document provides instructions for getting started managing an NTP service using the Puppet Labs NTP module. 

The clocks on your servers are not inherently accurate. They need to synchronize with something to let them know what the right time is. NTP is a protocol designed to synchronize the clocks of computers over a network. NTP uses Coordinated Universal Time (UTC) to synchronize computer clock times to a millisecond---and sometimes to a fraction of a millisecond. 

Your entire datacenter, from the network to the applications, depends on accurate time for many different things, such as security services, certificate validation, and file sharing across nodes.

NTP is one of the most crucial, yet easiest, services to configure and manage with Puppet Enterprise. Using the Puppet Labs NTP module, you can:

* ensure time is correctly synced across all the servers in your infrastructure. 
* ensure time is correctly synced across your configuration management tools (e.g., PE). 
*  roll out updates quickly if you need to change or specify your own internal NTP server pool. 

Using this guide, you will:

* [install the `puppetlabs-ntp` module](#install-the-puppetlabs-ntp-module).
* [use the PE console to add classes from the NTP module to your agent nodes](#use-the-pe-console-to-add-classes-from-the-ntp-module). 
* [use the PE console event inspector to view changes to your infrastructure made by the main NTP class](#use-the-console-event-inspector-to-view-changes-made-by-the-ntp-class).
* [use the PE console to edit parameters of the main NTP class](#use-the-pe-console-to-edit-parameters-of-the-ntp-class).


### Install Puppet Enterprise and the Puppet Enterprise Agent

If you haven't already done so, you'll need to get PE installed. See the [system requirements][sys_req] for supported platforms. 

1. [Download and verify the appropriate tarball][downloads].
2. Refer to the [installation overview][install_overview] to determine how you want to install PE, and follow the instructions provided.
3. Refer to the [agent installation instructions][agent_install] to determine how you want to install your PE agent(s), and follow the instructions provided.

>**Note**: You can add the NTP service to as many agents as needed. For ease of explanation, our console images or instructions may show only one agent node. 

  
### Install the puppetlabs-ntp Module

The puppetlabs-ntp module is part of the PE [supported modules](http://forge.puppetlabs.com/supported) program; these modules are supported, tested, and maintained by Puppet Labs. You can learn more about the puppetlabs-ntp module by visiting [http://forge.puppetlabs.com/puppetlabs/ntp](http://forge.puppetlabs.com/puppetlabs/ntp). 

**To install the puppetlabs-ntp module**:

From the PE master, run `puppet module install puppetlabs-ntp`.

You should see output similar to the following: 

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Notice: Downloading from http://forgeapi.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── puppetlabs-ntp (v3.1.2)
        
> That's it! You've just installed the puppetlabs-ntp module. All of the classes in it are now available to be added to the console and assigned to your agent nodes.

### Use the PE Console to Add Classes from the NTP Module

[classbutton]: ./images/quick/add_class_button.png
[add_ntp]: ./images/quick/add_ntp.png
[assign_ntp_default]: ./images/quick/assign_ntp_default.png

The NTP module contains several **classes**. [Classes](../puppet/3/reference/lang_classes.html) are named chunks of puppet code and are the primary means by which Puppet Enterprise configures nodes. The NTP module contains the following classes:
 
* `ntp`: the main class; this class includes all other classes (including the classes in this list).
* `ntp::install`: this class handles the installation packages.
* `ntp::config`: this class handles the configuration file.
* `ntp::service`: this class handles the service.

We're going to add the `ntp` class to the **default** node group. Depending on your needs or infrastructure, you may have a different group that you'll assign NTP to, but these same instructions would apply. 

**To add the** `ntp` **class to the default group**:

1. From the console, click __Add classes__ in the sidebar:

   ![The console's add classes button][classbutton]

2. In the list of classes, locate `ntp`, and select it. 

   ![the add class field][add_ntp]
   
3. Click __Add selected classes__.

4. Navigate to the __default__ group page (by clicking the link in the __Groups__ menu in the sidebar).

5. Click __Edit__ and begin typing "`ntp`" in the __Classes__ field; you can select `ntp` from the list of autocomplete suggestions. 
   ![assigning the ntp class to default group][assign_ntp_default]
   
   **Tip**: You only need to add the main `ntp` class; it contains the other classes from the module. 
   
6. Click __Update__. 

   **Note**: The `ntp` class now appears in the list of classes for the __default__ group, but it has not yet been configured on your nodes. For that to happen, you need to kick off a puppet run. 
   
7. Navigate to the live management page, and select the __Control Puppet__ tab. 

8. Click the __runonce__ action and then __Run__. This will configure the nodes using the newly-assigned classes. Wait one or two minutes.

9. On the agent, stop the NTP service.

   **Note**: the NTP service name may vary depending on your operating system; for example, on Debian nodes, the service name is "NTP."
   
10. Run `ntpdate <ntp server address>` (e.g., us.pool.ntp.org). The result should resemble the following:

   `28 Jan 17:12:40 ntpdate[27833]: adjust time server 50.18.44.19 offset 0.057045 sec`

11. Finally, restart the NTP service.

> **Success!** Puppet Enterprise is now managing NTP on the nodes in the __default__ group. So, for example, if you forget to restart the NTP service on one of those nodes after running `ntpdate`, PE will automatically restart it on the next Puppet Enterprise run. 

### Using the PE Console Event Inspector to View Changes Made by the `ntp` Class

[EI-default]: ./images/quick/EI_default.png
[EI-class_change]: ./images/quick/EI_class-change.png
[EI-detail]: ./images/quick/EI_detail.png

The PE console event inspector lets you view and research changes and other events. For example, after applying the `ntp` class, you can use event inspector to confirm that changes (or "events") were indeed made to your infrastructure. 

Note that in the summary pane on the left, one event, a successful change, has been recorded for **Nodes: with events**. However, there are two changes for **Classes: with events** and **Resources: with events**. This is because the `ntp` class loaded from the `puppetlabs-ntp` module contains additional classes---a class that handles the configuration of NTP (`Ntp::Config`) and a class that handles the NTP service (`Ntp::Service`).

![The default event inspector view][EI-default]

Click __With Changes__ in the __Classes: with events__ summary view. The main pane will show you that the `Ntp::Config` and `Ntp::Service` classes were successfully added when you ran PE after adding the main `ntp` class.

![Viewing a successful change][EI-class_change]

The further you drill down, the more detail you'll receive. Eventually, you will end up at a run summary that shows you the details of the event. For example, you can see exactly which piece of puppet code was responsible for generating the event; in this case, it was line 15 of the `service.pp` manifest and line 21 of the `config.pp` manifest from the `puppetlabs-ntp` module.

![Event detail][EI-detail]

If there had been a problem applying this class, this information would tell you exactly which piece of code you need to fix. In this case, event inspector simply lets you confirm that PE is now managing NTP.

In the upper right corner of the detail pane is a link to a run report which contains information about the puppet run that made the change, including logs and metrics about the run. Visit the [reports page](./console_reports.html#reading-reports) for more information.

For more information about using the PE console event inspector, check out the [event inspector docs](./console_event_inspector). 


### Use the PE Console to Edit Parameters of the `ntp` Class

[ntp_params]: ./images/quick/ntp-params.png

With Puppet Enterprise you can edit or add class parameters directly in the PE console without needing to edit the module code directly. 

The NTP module, by default, uses public NTP servers, but what if your infrastructure runs an internal pool of NTP servers? 

Changing the server parameter of the `ntp` class can be accomplished in a few steps using the PE console.

**To edit the server parameter of the** `ntp` **class**: 

1. Navigate to the node list and choose the node you want to edit.
2. On the node view page, click __Edit__.
3. Find __ntp__ in the class list, and click __Edit parameters__.
4. For the `server` parameter, enter the new server name (e.g., `time.apple.com`) in the __servers__  value field.

   ![the NTP parameters list][ntp_params]

   **Note**: The grey text that appears as values for some parameters is the default value, which can be either a literal value or a Puppet variable. You can restore this value with the __Reset value__ control that appears next to the value after you have entered a custom value.
 
5. Click __Done__. 
6. Navigate to the live management page, and select the __Control Puppet__ tab. 
7. Click the __runonce__ action and then __Run__ to trigger a puppet run to have Puppet Enterprise create the new configuration. 

> Puppet Enterprise will now use the NTP server you've specified for that node.
>
> **Hint**: Remember to use the event inspector to be sure the changes were correctly applied to your nodes!

### Other Resources

For more information about working with the puppetlabs-ntp module, check out our [Puppetlabs-NTP: A Puppet Enterprise Supported Module](http://puppetlabs.com/blog/puppetlabs-ntp-puppet-enterprise-supported-module) blog post and our [How to Manage NTP](http://puppetlabs.com/webinars/how-manage-ntp) webinar. 

Puppet Labs offers many opportunities for learning and training, from formal certification courses to guided online lessons. We've noted a few below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* [Learning Puppet](http://docs.puppetlabs.com/learning/) is a series of exercises on various core topics about deploying and using PE. 
* The Puppet Labs workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).




