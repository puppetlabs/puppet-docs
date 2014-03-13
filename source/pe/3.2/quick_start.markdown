---
layout: default
title: "PE 3.2 » Quick Start » Using PE"
subtitle: "Quick Start: Using PE 3.2"
canonical: "/pe/latest/quick_start.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html

Welcome to the Puppet Enterprise 3.2 quick start guide. This document is a short walkthrough to help you evaluate Puppet Enterprise (PE) and become familiar with its features. There are two parts to this guide, an introductory guide (below) that demonstrates basic use and concepts and a [follow-up guide](./quick_writing.html) where you can build on the concepts you learned in the introduction while learning some basics about developing puppet modules.

#### Quick Start Part One: Introduction

In this first part, follow along to learn how to:

* Install a small proof-of-concept deployment
* Add nodes to your deployment
* Examine and control nodes in real time with live management
* Install a PE-supported Puppet module
* Apply Puppet classes to nodes using the console
* Set the parameters of classes using the console
* Use the console to inspect and analyze the results of configuration events

####  Quick Start Part Two: Developing Modules

In the [second part](./quick_writing.html), you'll learn about:

* Installing the agent on a Windows node and adding a Windows module to your master
* Basic module structure
* Editing manifests and templates
* Writing your own modules
* Creating a site module that builds other modules into a complete machine role
* Applying classes to groups with the console

> Following this walkthrough will take approximately 30-60 minutes for each part.

Creating a Deployment
-----

A typical Puppet Enterprise deployment consists of:

* A number of **agent nodes,** which are computers (physical or virtual) managed by Puppet.
* At least one **puppet master server,** which serves configurations to agent nodes.
* At least one **console server,** which analyzes agent reports and presents a GUI for managing your site. (This may or may not be the same server as the master.)
* At least one **database support server** which runs PuppetDB and databases that support the console. (This may or may not be the same server as the console server.)

For this walk-through, you will create a simple deployment where the puppet master, the console, and database support roles will run on one machine (a.k.a., a monolithic master). This machine will manage one or two agent nodes. In a production environment you have total flexibility in how you deploy and distribute your master, console, and database support roles, but for the purposes of this guide we're keeping things simple.

> ### Preparing Your Proof-of-Concept Systems
>
> To create this small deployment, you will need the following:
>
> * At least two computers ("nodes") running a \*nix operating system [supported by Puppet Enterprise](./install_system_requirements.html).
>     * These can be virtual machines or physical servers.
>     * One of these nodes (the puppet master server) should have at least 1 GB of RAM. **Note:** For actual production use, a puppet master node should have at least 4 GB of RAM.
> * For part two, a computer running a version of Microsoft Windows [supported by Puppet Enterprise](./install_system_requirements.html).
> * [Puppet Enterprise installer tarballs][downloads] suitable for the OS and architecture your nodes are using.
> * A network --- all of your nodes should be able to reach each other.
> * All of the nodes you intend to use should have their system clocks set to within a minute of each other.
> * An internet connection or a local mirror of your operating system's package repositories, for downloading additional software that Puppet Enterprise may require.
> * [Properly configured firewalls](./install_system_requirements.html#firewall-configuration).
>     * For demonstration purposes, all nodes should allow **all traffic on ports 8140, 61613, and 443.** (Production deployments can and should partially restrict this traffic.)
> * [Properly configured name resolution](./install_system_requirements.html#name-resolution).
>     * Each node needs **a unique hostname,** and they should be on **a shared domain.** For the rest of this walkthrough, we will refer to the puppet master as `master.example.com` and the agent node as `agent1.example.com`. You can use any hostnames and any domain; simply substitute the names as needed throughout this document.
>     * All nodes must **know their own hostnames.** This can be done by properly configuring reverse DNS on your local DNS server, or by setting the hostname explicitly. Setting the hostname usually involves the `hostname` command and one or more configuration files, while the exact method varies by platform.
>     * All nodes must be able to **reach each other by name.** This can be done with a local DNS server, or by editing the `/etc/hosts` file on each node to point to the proper IP addresses. Test this by running `ping master.example.com` and `ping agent1.example.com` on every node.
>     * Optionally, to simplify configuration later, all nodes should also be able to **reach the puppet master node at the hostname `puppet`.** This can be done with DNS or with hosts files. Test this by running `ping puppet` on every node.
>     * The **control workstation** from which you are carrying out these instructions must be able to **reach every node in the deployment by name.**

### Installing the Puppet Master

* **On the puppet master node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled, as on Debian and Ubuntu.)
* [Download the Puppet Enterprise tarball][downloads], extract it, and navigate to the directory it creates.
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them.
    * **Install** the puppet master, database support, and console roles; the cloud provisioner role is not required, but may be useful if you later promote this machine to production or just want to experiment with PE provisioning features.
    * Make sure that the unique "certname" matches the hostname you chose for this node. (For example, `master.example.com`.)
    * You will need the **email address and console password** it requests in order to use the console; **choose something memorable.**
    * None of the **other passwords** are relevant to this quick start guide. **Choose something random.**
    * For purposes of this walkthrough, when prompted for an SMTP server you can enter `localhost` or other inert text. Otherwise, you can **accept the default responses for every other question** by hitting enter. 
* The installer will then install and configure Puppet Enterprise. It may also need to install additional packages from your OS's repository. **This process may take 10-15 minutes.**

> You have now installed the puppet master node. As indicated by the installer, the puppet master node is also an agent node, and can configure itself the same way it configures the other nodes in a deployment. Stay logged in as root for further exercises.

### Installing the Agent Node

* **On the agent node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* Copy or [download the Puppet Enterprise tarball][downloads], extract it, and navigate to the directory it creates.
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them.
    * **Skip** the puppet master role by answering "No" in the installer script.
    * Provide the puppet master hostname; in this case, **`master.example.com`**. If you configured the master to be reachable at `puppet`, you can alternately accept the default.
    * **Skip** the database support and console roles by answering "No" in the installer script.
    * **Install** the puppet agent role by answering "Yes" in the installer script. The cloud provisioner role is optional and is not used in this exercise.
    * Make sure that the unique "certname" matches the hostname you chose for this node. (For example, `agent1.example.com`.)
    * **Accept the default responses for every other question** by hitting enter.
* The installer will then install and configure the Puppet Enterprise agent. 

**Note**: In a production environment there are other ways to install agents that are faster and easier. For more information, see the [complete installation instructions](./install_basic.html).

> You have now installed the puppet agent node. Stay logged in as root for further exercises.

Adding Nodes to a Deployment
-----

After installing, the agent nodes are **not yet allowed** to fetch configurations from the puppet master; they must be explicitly approved and granted a certificate.

### Approving the Certificate Request

[console_cert]: ./console_accessing.html#accepting-the-consoles-certificate

During installation, the agent node contacted the puppet master and requested a certificate. To add the agent node to the deployment, you'll need to **approve its request on the puppet master**. This is most easily done via the console.

* **On your control workstation**, open a web browser and point it to https://master.example.com.
* You will receive a warning about an untrusted certificate. This is because _you_ were the signing authority for the console's certificate, and your Puppet Enterprise deployment is not known to the major browser vendors as a valid signing authority. **Ignore the warning and accept the certificate**. The steps to do this vary by browser; [see here][console_cert] for detailed steps for the major web browsers.
* Next, you will see a login screen for the console. **Log in** with the email address and password you provided when installing the puppet master.

![The console login screen](./images/quick/login.png)

* The console GUI loads in your browser. Note the pending "node requests" indicator in the upper right corner. Click it to load a list of pending node requests.

![Node Request Indicator](./images/console/request_indicator.png)

* Click the "Accept All" button to approve all the requests and add the nodes to the deployment.

> The puppet agents can now retrieve configurations from the master the next time puppet runs.

### Testing the Agent Nodes

During this walkthrough, we will be running the puppet agent interactively. By default, the agent runs in the background and fetches configurations from the puppet master every 30 minutes. (This interval is configurable with the `runinterval` setting in puppet.conf.) However, you can also trigger a puppet run manually from the command line.

* **On the agent node,** log in as root and run `puppet agent --test` on the command line. This will trigger a single puppet run on the agent with verbose logging.

    > **Note**: If you receive a `-bash: puppet: command not found` error, run `export PATH=/usr/local/sbin:/usr/local/bin:$PATH`, then try again. This error can appear when the `/usr/local/bin` directory is not present in the root user's `$PATH` by default.
* Note the long string of log messages, which should end with `notice: Finished catalog run in [...] seconds`.


> You are now fully managing the agent node. It has checked in with the puppet master for the first time and received its configuration info. It will continue to check in and fetch new configurations every 30 minutes. The node will also appear in the console, where you can make changes to its configuration by assigning classes and modifying the values of class parameters.

### Viewing the Agent Node in the Console


[console_nav]: ./console_navigating.html


* Click "Nodes" in the primary navigation bar. You'll see various UI elements, which show a summary of your deployment's recent puppet runs and their status. Notice that the master and any agent nodes appear in the list of nodes:

![The console front page](./images/quick/front.png)

* **Explore the console**. Note that if you click on a node to view its details, you can see its recent history, the Puppet classes it receives, and a very large list of inventory information about it. [See here for more information about navigating the console.][console_nav]

> You now know how to find detailed information about any node in your deployment, including its status, inventory details, and the results of its last puppet run.

### Avoiding the Wait

Although the puppet agent is now fully functional on the agent node, some other Puppet Enterprise software is not; specifically, the daemon that listens for orchestration messages is not yet configured. This is because Puppet Enterprise **uses Puppet to configure itself**.

Puppet Enterprise does this automatically within 30 minutes of a node's first check-in. To fast-track the process and avoid the wait, do the following:

* **On the console**, use the sidebar to navigate to the "mcollective" group:

![the mcollective group link](./images/quick/mcollective_link.png)

* Check the list of nodes at the bottom of the page for `agent1.example.com` --- depending on your timing, it may already be present. If so, skip to "on each agent node" below.
* If `agent1` is not a member of the group already, click the "edit" button:

![the edit button](./images/quick/mcollective_edit.png)

* In the "nodes" field, begin typing `agent1.example.com`'s name. You can then select it from the list of autocompletion guesses. Click the "Update" button after you have selected it.

![the nodes field](./images/quick/default_nodes.png)

* **On each agent node**, run `puppet agent --test` again, [as described above](#testing-the-agent-nodes). Note the long string of log messages related to the `pe_mcollective` class.

In a normal environment, you would usually skip these steps and allow orchestration to come on-line when Puppet runs automatically.

> The agent node can now respond to orchestration messages and its resources can be viewed live in the console.

Using Live Management to Control Agent Nodes
-----

Live management uses Puppet Enterprise's orchestration features to view and edit resources in real time. It can also trigger puppet runs and perform other orchestration tasks.

* **On the console**, click the "Live Management" tab in the top navigation.

![live management](./images/quick/live_mgmt.png)

* Note that the master and the agent nodes are all listed in the sidebar.

### Discovering Resources

* Note that you are currently in the "Browse Resources" tab. Choose "user resources" from the list of resource types, then click the "Find Resources" button:

![the find resources button](./images/quick/find_resources.png)

* Examine the **complete list of user accounts** found on all of the nodes currently selected in the sidebar node list. (In this case, both the master and the agent node are selected.) Most of the users will be identical, as these machines are very close to a default OS install, but some users related to the puppet master's functionality are only on one node:

![different users](./images/quick/different_users.png)

* Note that you can click on a user to view details about its properties and where it is present.

The other resource types work in a similar manner. Choose the node(s) whose resources you wish to browse. Select a resource type, click "Find Resources" to discover the resource on the selected nodes, click on one of the resulting found resources to see details about it.

### Triggering Puppet Runs

Rather than using the command line to kick off puppet runs with `puppet agent -t` one at a time, you can use live management to run Puppet on several selected nodes.

* **On the console, in the live management page**, click the "Control Puppet" tab.
* Make sure one or more nodes are selected with node selector on the left.
* Click the `runonce` action to reveal the red "Run" button and additional options. Click the "Run" button to run Puppet on the selected nodes.

> **Note**: You can't always use the `runonce` action's additional options --- with \*nix nodes, you must stop the `pe-puppet` service before you can use options like `noop`. [See this note in the orchestration section of the manual](./orchestration_puppet.html#behavior-differences-running-vs-stopped) for more details.
<br>

![The runonce action and its options](./images/quick/console_runonce.png)

You have just triggered a puppet run on several agents at once; in this case, the master and the agent node. The "runonce" action will trigger a puppet run on every node currently selected in the sidebar.

When using this action in production deployments, select target nodes carefully, as running it on dozens or hundreds of nodes at once can strain  the Puppet master server. If you need to do an immediate Puppet run on many nodes, [you should use the orchestration command line to do a controlled run series](./orchestration_puppet.html#run-puppet-on-many-nodes-in-a-controlled-series).

Installing Modules
-----

Puppet configures nodes by applying classes to them. Classes are chunks of Puppet code that configure a specific aspect or feature of a machine.

Puppet classes are **distributed in the form of modules**. You can save time by **using pre-existing modules**. Pre-existing modules are distributed on the [Puppet Forge](http://forge.puppetlabs.com), and **can be installed with the `puppet module` subcommand**. Any module installed on the Puppet master can be used to configure agent nodes.

### Installing a Forge Module

We will install a Puppet Enterprise supported module: `puppetlabs-ntp`. While you can use any module available on the Forge, PE customers can take advantage of [supported modules](http://forge.puppetlabs.com/supported) which are supported, tested, and maintained by Puppet Labs. 

* **On your control workstation**, point your browser to [http://forge.puppetlabs.com/puppetlabs/ntp](http://forge.puppetlabs.com/puppetlabs/ntp). This is the Forge listing for a module that installs, configures, and manages the ntp service.

* **On the puppet master**, run `puppet module search ntp`. This searches for modules from the Puppet Forge with `ntp` in their names or descriptions and results in something like:

        Searching http://forge.puppetlabs.com ...
        NAME             DESCRIPTION                                                 AUTHOR        KEYWORDS
        puppetlabs-ntp   NTP Module                                                  @puppetlabs   ntp aix
        saz-ntp          UNKNOWN                                                     @saz          ntp OEL
        thias-ntp        Network Time Protocol...                                    @thias        ntp ntpd
        warriornew-ntp   ntp setup                                                   @warriornew   ntp      

We want `puppetlabs-ntp`, which is the PE supported ntp module. You can view detailed info about the module in the "Read Me" on the Forge page you just visited: <http://forge.puppetlabs.com/puppetlabs/ntp>. 

* Install the module by running `puppet module install puppetlabs-ntp`:

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Notice: Downloading from http://forge.puppetlabs.com ...
        Notice: Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── puppetlabs-ntp (v3.0.1)
        
> You have just installed a Puppet module. All of the classes in it are now available to be added to the console and assigned to nodes.

There are many more modules, including PE supported modules, on [the Forge](http://forge.puppetlabs.com). In [part two](./quick_writing.html) of this guide you'll learn more about modules, including customizing and writing your own modules.

### Using Modules in the PE Console

[classbutton]: ./images/quick/add_class_button.png
[add_ntp]: ./images/quick/add_ntp.png
[assign_ntp]: ./images/quick/assign_ntp.png
[edit-params]: ./images/quick/edit-parameters.png
[ntp-params]: ./images/quick/ntp-params.png

Every module contains one or more **classes**. [Classes](../puppet/3/reference/lang_classes.html) are named chunks of puppet code and are the primary means by which Puppet configures nodes. The module you just installed contains a class called `ntp`. To use any class, you must first **tell the console about it** and then **assign it to one or more nodes**.

* **On the console**, click the "Add classes" button in the sidebar:

![The console's add classes button][classbutton]

* Locate the `ntp` class in the list of classes, and click its checkbox to select it. Click the "Add selected classes" button at the bottom of the page.

![the add class field][add_ntp]

* Navigate to `agent1.example.com` (by clicking the "Nodes" link in the top nav bar and clicking `agent1`'s name), click the "Edit" button, and begin typing "`ntp`" in the "Classes" field; you can select the `ntp` class from the list of autocomplete suggestions. Click the "Update" button after you have selected it.

![assigning the ntp class][assign_ntp]

* Note that the `ntp` class now appears in the list of classes on `agent1`.
* Navigate to the live management page, and select the "Control Puppet" tab. Use the "runonce" action to trigger a puppet run on both the master and the agent. This will configure the nodes using the newly-assigned classes. Wait one or two minutes.
* On the agent node, run the following commands:
 
        service ntpd stop
        ntpdate us.pool.ntp.org
 
 **Note**: the NTP service name may vary depending on your operating system; for example, on Debian nodes, the service name is "ntp."
 
 The result should resemble the following:

		28 Jan 17:12:40 ntpdate[27833]: adjust time server 50.18.44.19 offset 0.057045 sec
 
 Finally, run `service ntpd start`.
 		
> Puppet is now managing NTP on the `agent.1` node. So, for example, if you forget to restart the NTP service after running `ntpdate`, PE will automatically restart it on the next puppet run. 

#### Setting Class Parameters

You can use the console to set the values of the class parameters of nodes by selecting a node and then clicking "Edit parameters" in the list of classes. For example, if you wanted to specify an NTP server for a given node you would:

* Click on the node in the node list
* Click the edit button on the node's view
 * Click on "Edit Parameters" next to "ntp" in the class list
    
![the node class list][edit-params]
    
* Enter a value for the parameter you wish to set. To set a specific server, enter `ntp1.example.com` in the box next to the "servers" parameter. The grey text that appears as values for some parameters is the default value, which can be either a literal value or a Puppet variable. You can restore this value with the "Reset value" control that appears next to the value after you have entered a custom value.
    
![the NTP parameters list][ntp-params]
    
For more information, see the page on [classifying nodes with the console](./console_classes_groups.html).

### Viewing Changes with Event Inspector

[EI-default]: ./images/quick/EI_default.png
[EI-class_change]: ./images/quick/EI_class-change.png
[EI-detail]: ./images/quick/EI_detail.png

The event inspector lets you view and research changes and other eventsClick the "Events" tab in the main navigation bar. The event inspector window is displayed, showing the default view: classes with failures. Note that in the summary pane on the left, one event, a successful change, has been recorded for Nodes. However, there are two changes for Classes and Resources. This is because the NTP class loaded from the Puppetlabs-ntp module contains additional classes---a class that handles the configuration of NTP (`Ntp::Config`)and a class that handles the NTP service (`Ntp::Service`).

![The default event inspector view][EI-default]

You can click on events in the summary pane to inspect them in detail. For example, if you click "With Changes" in the "Classes With Events" summary view, the main pane will show you that the `Ntp::Config` and `Ntp::Service` classes were successfully added when you triggered the last puppet run.

![Viewing a successful change][EI-class_change]

You can keep clicking to drill down and see more detail. You can click the previous arrow (left of the summary pane), the bread-crumb trail at the top of the page, or bookmark a page for later reference (but note that after subsequent puppet runs, the bookmarks may be different when you revisit them). Eventually, you will end up at a run summary that shows you the details of the event. For example, you can see exactly which piece of puppet code was responsible for generating the event; in this case, it was line 15 of the `service.pp` manifest and line 21 of the `config.pp` manifest.

![Event detail][EI-detail]

If there had been a problem with applying this class, this information would tell you exactly what piece of code you need to fix. In this case, event inspector lets you confirm that PE is now managing NTP.

In the upper right corner of the detail pane is a link to a run report which contains information about the puppet run that made the change, including metrics about the run, logs, and more information. Visit the [reports page](./console_reports.html#reading-reports) for more information.

Summary
-----

You have now experienced the core features and workflows of Puppet Enterprise. In summary, a Puppet Enterprise user will:

* Deploy new nodes, install PE on them ([\*nix](./install_basic.html) and [Windows](./install_windows.html) instructions), and [add them to their deployment by approving their certificate requests](./console_cert_mgmt.html).
* Use [pre-built, PE supported modules from the Puppet Forge](http://forge.puppetlabs.com) to save time and effort.
* [Assign classes from modules to nodes in the console.](./console_classes_groups.html)
* [Use the console to set values for class parameters.](./console_classes_groups.html)
* [Allow nodes to be managed by regularly scheduled Puppet runs.](./puppet_overview.html#when-new-configurations-take-effect)
* Use [live management](./console_navigating_live_mgmt.html) to [inspect and compare nodes](./orchestration_resources.html), and to [trigger on-demand puppet agent](./orchestration_puppet.html) runs when necessary.
* Use [event inspector](./console_event-inspector.html) to learn more about events that occurred during puppet runs, such as what was changed or why something failed.

### Next Steps

Beyond what this brief walkthrough has covered, most users will go on to:

* Edit Forge modules to customize them to the deployment.
* Create new modules from scratch by writing classes that manage resources.
* Use a **site module** to compose other modules into machine roles, allowing console users to control policy instead of implementation.
* Configure multiple nodes at once by adding classes to groups in the console instead of individual nodes.

To learn about these workflows, continue to [part two of this quick start guide](./quick_writing.html).

#### Other Resources

Puppet Labs offers many opportunities for learning and training, from formal certification courses to guided on-line lessons. We've noted a few below; head over to the [learning Puppet page](https://puppetlabs.com/learn) to discover more.

* [Learning Puppet](http://docs.puppetlabs.com/learning/) is a series of exercises on various core topics on deploying and using PE.  It includes the [Learning Puppet VM](http://info.puppetlabs.com/download-learning-puppet-VM.html) which provides a pre-built PE deployment on VMware and VirtualBox virtualization platforms. 
* The Puppet Labs workshop contains a series of self-paced, online lessons that cover a variety of topics on Puppet basics. You can sign up at the [learning page](https://puppetlabs.com/learn).
* To explore the rest of the PE user's manual, use the sidebar at the top of this page, or [return to the index](./index.html).

* * *

- [Next: Quick Start: Writing Modules](./quick_writing.html)
