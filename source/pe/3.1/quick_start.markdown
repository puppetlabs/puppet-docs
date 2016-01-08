---
layout: default
title: "PE 3.1 » Quick Start » Using PE"
subtitle: "Quick Start: Using PE 3.1"
canonical: "/pe/latest/quick_start.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html

Welcome to the Puppet Enterprise 3.1 quick start guide. This document is a short walkthrough to help you evaluate Puppet Enterprise (PE) and become familiar with its features. Follow along to learn how to:

* Install a small proof-of-concept deployment
* Add nodes to your deployment
* Examine and control nodes in real time with live management
* Install a third-party Puppet module
* Apply Puppet classes to nodes with the console
* View the results of configuration changes in the console

> Following this walkthrough will take approximately 30-60 minutes.

Creating a Deployment
-----

A standard Puppet Enterprise deployment consists of:

* Many **agent nodes,** which are computers (physical or virtual) managed by Puppet.
* At least one **puppet master server,** which serves configurations to agent nodes.
* At least one **console server,** which analyzes agent reports and presents a GUI for managing your site. (This may or may not be the same server as the master.)
* At least one **database support server** which runs PuppetDB and databases that support the console. (This may or may not be the same server as the console server.)

For this deployment, the puppet master, the console and database support server will be the same machine, and we will have one additional agent node.

> ### Preparing Your Proof-of-Concept Systems
>
> To create this small deployment, you will need the following:
>
> * At least two computers ("nodes") running a \*nix operating system [supported by Puppet Enterprise](./install_system_requirements.html).
>     * These can be virtual machines or physical servers.
>     * One of these nodes (the puppet master server) should have at least 1 GB of RAM. **Note:** For actual production use, a puppet master node should have at least 4 GB of RAM.
> * Optionally, a computer running a version of Microsoft Windows [supported by Puppet Enterprise](./install_system_requirements.html).
> * [Puppet Enterprise installer tarballs][downloads] suitable for the OS and architecture your nodes are using.
> * A network --- all of your nodes should be able to reach each other.
> * All of the nodes you intend to use should have their system clocks set to within a minute of each other.
> * An internet connection or a local mirror of your operating system's package repositories, for downloading additional software that Puppet Enterprise may require.
> * [Properly configured firewalls](./install_system_requirements.html#firewall-configuration).
>     * For demonstration purposes, all nodes should allow **all traffic on ports 8140, 61613, and 443.** (Production deployments can and should partially restrict this traffic.)
> * [Properly configured name resolution](./install_system_requirements.html#name-resolution).
>     * Each node needs **a unique hostname,** and they should be on **a shared domain.** For the rest of this walkthrough, we will refer to the puppet master as `master.example.com`, the first agent node as `agent1.example.com`, and the Windows node as `windows.example.com`. You can use any hostnames and any domain; simply substitute the names as needed throughout this document.
>     * All nodes must **know their own hostnames.** This can be done by properly configuring reverse DNS on your local DNS server, or by setting the hostname explicitly. Setting the hostname usually involves the hostname command and one or more configuration files, while the exact method varies by platform.
>     * All nodes must be able to **reach each other by name.** This can be done with a local DNS server, or by editing the `/etc/hosts` file on each node to point to the proper IP addresses. Test this by running `ping master.example.com` and `ping agent1.example.com` on every node, including the Windows node if present.
>     * Optionally, to simplify configuration later, all nodes should also be able to **reach the puppet master node at the hostname `puppet`.** This can be done with DNS or with hosts files. Test this by running `ping puppet` on every node.
>     * The **control workstation** from which you are carrying out these instructions must be able to **reach every node in the deployment by name.**

### Installing the Puppet Master

* **On the puppet master node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled, as on Debian and Ubuntu.)
* [Download the Puppet Enterprise tarball][downloads], extract it, and navigate to the directory it creates.
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them.
    * **Install** the puppet master, database support, and console roles; the cloud provisioner role is not required, but may be useful if you later promote this machine to production.
    * Make sure that the unique "certname" matches the hostname you chose for this node. (For example, `master.example.com`.)
    * You will need the **email address and console password** it requests in order to use the console; **choose something memorable.**
    * None of the **other passwords** are relevant to this quick start guide. **Choose something random.**
    * **Accept the default responses for every other question** by hitting enter.
* The installer will then install and configure Puppet Enterprise. It may also need to install additional packages from your OS's repository. **This process may take 10-15 minutes.**

> You have now installed the puppet master node. As indicated by the installer, the puppet master node is also an agent node, and can configure itself the same way it configures the other nodes in a deployment. Stay logged in as root for further exercises.

### Installing the Agent Node

* **On the agent node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* [Download the Puppet Enterprise tarball][downloads], extract it, and navigate to the directory it creates.
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them.
    * **Skip** the puppet master role.
    * Provide the puppet master hostname; in this case, **`master.example.com`**. If you configured the master to be reachable at `puppet`, you can alternately accept the default.
    * **Skip** the database support and console roles.
    * **Install** the puppet agent role. The cloud provisioner role is optional and is not used in this exercise.
    * Make sure that the unique "certname" matches the hostname you chose for this node. (For example, `agent1.example.com`.)
    * **Accept the default responses for every other question** by hitting enter.
* The installer will then install and configure Puppet Enterprise.

> You have now installed the puppet agent node. Stay logged in as root for further exercises.

### Installing the Optional Windows Node

* **On the Windows node,** log in as a user with administrator privileges.
* [Download the Puppet Enterprise installer for Windows][downloads].
* Run the Windows installer by double-clicking it. The installer will ask for the name of the puppet master to connect to; set this to **`master.example.com`**.

> You have now installed the Windows puppet agent node. Stay logged in as administrator for further exercises.

Adding Nodes to a Deployment
-----

After installing, the agent nodes are **not yet allowed** to fetch configurations from the puppet master; they must be explicitly approved and granted a certificate.

### Approving the Certificate Request

[console_cert]: ./console_accessing.html#accepting-the-consoles-certificate

During installation, the agent node contacted the puppet master and requested a certificate. To add the agent node to the deployment, you'll need to **approve its request on the puppet master.** This is most easily done via the console.

* **On your control workstation,** open a web browser and point it to https://master.example.com.
* You will receive a warning about an untrusted certificate. This is because _you_ were the signing authority for the console's certificate, and your Puppet Enterprise deployment is not known to the major browser vendors as a valid signing authority. **Ignore the warning and accept the certificate.** The steps to do this vary by browser; [see here][console_cert] for detailed steps for the major web browsers.
* Next, you will see a login screen for the console. **Log in** with the email address and password you provided when installing the puppet master.

![The console login screen](./images/quick/login.png)

* The console GUI loads in your browser. Note the pending "node requests" indicator in the upper right corner. Click it to load a list of pending node requests.

![Node Request Indicator](./images/console/request_indicator.png)

* Click the "Accept All" button to approve all the requests and add the nodes to the deployment.

> The agent nodes can now retrieve configurations from the master the next time puppet runs.

### Testing the Agent Nodes

During this walkthrough, we will be running puppet agent interactively. Normally, puppet agent runs in the background and fetches configurations from the puppet master every 30 minutes. (This interval is configurable with the `runinterval` setting in puppet.conf.) However, you can also trigger a puppet run manually from the command line.


* **On the first agent node,** log in as root and run `puppet agent --test`. This will trigger a single puppet agent run with verbose logging.

    > **Note:** If you receive a `-bash: puppet: command not found` error, run `export PATH=/usr/local/sbin:/usr/local/bin:$PATH`, then try again. This error can appear when the `/usr/local/bin` directory is not present in the root user's `$PATH` by default.
* Note the long string of log messages, which should end with `notice: Finished catalog run in [...] seconds`.
* **On the Windows node,** open the start menu, navigate to the Puppet Enterprise folder, and choose "Run Puppet Agent," elevating privileges if necessary.
* Note the similar string of log messages.


> You are now fully managing these nodes. They have checked in with the puppet master for the first time, and have received their configuration info. They will continue to check in and fetch new configurations every 30 minutes. They will also appear in the console, where you can make changes to their configuration by assigning classes.

### Viewing the Agent Nodes in the Console


[console_nav]: ./console_navigating.html


* Click on "Nodes" in the primary navigation bar. You'll see various UI elements, which show a summary of your deployment's recent puppet runs and their status. Notice that the master and any agent nodes appear in the list of nodes:

![The console front page](./images/quick/front.png)

* **Explore the console.** Note that if you click on a node to view its details, you can see its recent history, the Puppet classes it receives, and a very large list of inventory information about it. [See here for more information about navigating the console.][console_nav]

> You now know how to find detailed information about any node in your deployment, including its status, inventory details, and the results of its last Puppet run.

### Avoiding the Wait

Although puppet agent is now fully functional on any agent nodes, some other Puppet Enterprise software is not; specifically, the daemon that listens for orchestration messages is not configured. This is because Puppet Enterprise **uses Puppet to configure itself.**

Puppet Enterprise does this automatically within 30 minutes of a node's first check-in. To fast-track the process and avoid the wait, do the following:

* **On the console,** use the sidebar to navigate to the "mcollective" group:

![the mcollective group link](./images/quick/mcollective_link.png)

* Check the list of nodes at the bottom of the page for `agent1.example.com` and `windows.example.com` (or whatever you named your Windows node) --- depending on your timing, they may already be present. If so, skip to "on each agent node" below.
* If `agent1` is not a member of the group already, click the "edit" button:

![the edit button](./images/quick/mcollective_edit.png)

* In the "nodes" field, begin typing `agent1.example.com`'s name. You can then select it from the list of autocompletion guesses. Click the update button after you have selected it.

![the nodes field](./images/quick/default_nodes.png)

* **On each agent node,** run `puppet agent --test` again, [as described above](#testing-the-agent-nodes). Note the long string of log messages related to the `pe_mcollective` class.

In a normal environment, you would usually skip these steps and allow orchestration to come on-line automatically.

> Both the Linux and the Windows agent node can now respond to orchestration messages, and their resources can be viewed live in the console.

Using Live Management to Control Agent Nodes
-----

Live management uses Puppet Enterprise's orchestration features to view and edit resources in real time. It can also trigger Puppet runs and orchestration tasks.

* **On the console,** click the "Live Management" tab in the top navigation.

![live management](./images/quick/live_mgmt.png)

* Note that the master and the agent nodes are all listed in the sidebar.

### Discovering Resources

* Note that you are currently in the "Browse Resources" tab. Choose "user resources" from the list of resource types, then click the "Find Resources" button:

![the find resources button](./images/quick/find_resources.png)

* Examine the **complete list of user accounts** found on all of the nodes currently selected in the sidebar node list. (In this case, both the master and the first agent node are selected.) Most of the users will be identical, as these machines are very close to a default OS install, but some users related to the puppet master's functionality are only on one node:

![different users](./images/quick/different_users.png)

* Note that you can click on a user to view details about its properties and where it is present.

The other resource types work in a similar manner. Choose the nodes whose resources you wish to browse. Select a resource type, click "Find Resources" to discover the resource on the selected nodes, click on one of the resulting found resources to see details about it.

### Triggering Puppet Runs

Rather than using the command line to kick off puppet runs with `puppet agent -t` one at a time, you can use live management to run puppet on several selected nodes.

* **On the console, in the live management page,** click the "Control Puppet" tab.
* Make sure one or more nodes are selected with node selector on the left.
* Click the `runonce` action to reveal the red "Run" button and additional options. Click the "Run" button to run Puppet on the selected nodes.

> **Note:** You can't always use the `runonce` action's additional options --- with \*nix nodes, you must stop the `pe-puppet` service before you can use options like `noop`. [See this note in the orchestration section of the manual](./orchestration_puppet.html#behavior-differences-running-vs-stopped) for more details.
<br>
![The runonce action and its options](./images/quick/console_runonce.png)

You have just triggered a puppet agent run on several agents at once; in this case, the master and the first agent node. The "runonce" action will trigger a puppet run on every node currently selected in the sidebar.

In production deployments, select target nodes carefully, as running this action on dozens or hundreds of nodes at once can put strain on the puppet master server. If you need to do an immediate Puppet run on many nodes, [you should use the orchestration command line to do a controlled run series](./orchestration_puppet.html#run-puppet-on-many-nodes-in-a-controlled-series).

Installing a Puppet Module
-----

Puppet configures nodes by applying classes to them. Classes are chunks of Puppet code that configure a specific aspect or feature of a machine.

Puppet classes are **distributed in the form of modules.** You can save time by **using pre-existing modules.** Pre-existing modules are distributed on the [Puppet Forge](http://forge.puppetlabs.com), and **can be installed with the `puppet module` subcommand.** Any module installed on the puppet master can be used to configure agent nodes.

### Installing two Forge Modules

We will install two example modules: `puppetlabs-motd` and `puppetlabs-win_desktop_shortcut`.

* **On your control workstation,** point your browser to [http://forge.puppetlabs.com/puppetlabs/motd](http://forge.puppetlabs.com/puppetlabs/motd). This is the Forge listing for an example module that sets the message of the day file (`/etc/motd`), which is displayed to users when they log into a \*nix system.
* Navigate to <https://forge.puppetlabs.com/puppetlabs/win_desktop_shortcut>. This is the Forge listing for an example module that manages a desktop shortcut on Windows.

* **On the puppet master,** run `puppet module search motd`. This searches for modules from the Puppet Forge with `motd` in their names or descriptions:

        Searching http://forge.puppetlabs.com ...
        NAME             DESCRIPTION                                                 AUTHOR        KEYWORDS
        puppetlabs-motd  This module populates `/etc/motd` with the contents of ...  @puppetlabs   Testing
        jeffmccune-motd  This manages a basic message of the day based on useful...  @jeffmccune   motd
        dhoppe-motd       This module manages motd                                   @dhoppe       debian ubuntu motd
        saz-motd         Manage 'Message Of The Day' via Puppet                      @saz          motd

    We want `puppetlabs-motd`, which is an example module that sets the message of the day file (`/etc/motd`) on \*nix systems. You can view detailed info about the module on the Forge page you just visited <http://forge.puppetlabs.com/puppetlabs/motd>. You can also use the Search feature on the Forge site.

    You can also do a similar search for `desktop_shortcut`, which should find the other module we'll be using.
* Install the first module by running `puppet module install puppetlabs-motd`:

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Downloading from http://forge.puppetlabs.com ...
        Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── puppetlabs-motd (v1.0.0)
* Install the second module by running `puppet module install puppetlabs-win_desktop_shortcut`. (If you are not using any Windows nodes, this module is inert; you can install it or skip it.)

> You have just installed multiple Puppet modules. All of the classes in them are now available to be added to the console and assigned to nodes.

### Using Modules in the PE Console

[classbutton]: ./images/quick/add_class_button.png
[add_motd]: ./images/quick/add_motd.png
[assign_motd]: ./images/quick/assign_motd.png

Every module contains one or more **classes.** The modules you just installed contain classes called `motd` and `win_desktop_shortcut`. To use any class, you must **tell the console about it** and then **assign it to one or more nodes.**

* **On the console,** click the "Add classes" button in the sidebar:

![The console's add classes button][classbutton]

* Locate the `motd` class in the list of classes, and click its checkbox to select it; do the same for the `win_desktop_shortcut` class. When both are selected, click the "Add selected classes button at the bottom of the page.

![the add class field][add_motd]

* Navigate to `agent1.example.com` (by clicking the "Nodes" link in the top nav bar and clicking `agent1`'s name), click the "Edit" button, and begin typing "motd" in the "classes" field; you can select the `motd` class from the list of autocomplete suggestions. After you select "motd" from the drop-down, it will appear in the "Classes" list. Click the "Update" button to save the changes.

![assigning the motd class][assign_motd]

* Note that the `motd` class now appears in the list of `agent1`'s classes.
* Navigate to `windows.example.com`, click the edit button, and begin typing "`win_desktop_shortcut`" in the "classes" field; select the class and click the "Update" button.
* Note that the `win_desktop_shortcut` class now appears in the list of `windows.example.com`'s classes.
* Navigate to the live management page, and select the "Control Puppet" tab. Use the "runonce" action to trigger a puppet run on both the master and the agents. This will configure the nodes using the newly-assigned classes. Wait one or two minutes.
* **On the first agent node,** run `cat /etc/motd`. Note that its contents resemble the following:

        The operating system is CentOS
        The free memory is 82.27 MB
        The domain is example.com
* **On the puppet master,** run `cat /etc/motd`. Note that its contents are either empty or the operating system's default, since the `motd` class wasn't applied to it.
* **On the Windows node,** note that there is now a shortcut to the Puppet Labs website on the desktop.

> Puppet is now managing the first agent node's message of the day file, and will revert it to the specified state if it is ever modified. Puppet is also managing the desktop shortcut on the Windows machine, and will restore it if it is ever deleted or modified.
>
> For more recommended modules, [search the Forge](http://forge.puppetlabs.com) or check out the [Module of the Week series on the Puppet Labs blog.](http://puppetlabs.com/category/blog/module-of-the-week-blog/)

### Viewing Changes with Event Inspector

[EI-default]: ./images/quick/EI_default.png
[EI-class_change]: ./images/quick/EI_class-change.png
[EI-detail]: ./images/quick/EI_detail.png

Click on the "Events" tab in the main navigation bar. The event inspector window is displayed, showing the default view: classes with failures. Note that in the summary pane on the left, one event, a successful change, has been recorded for Classes, Nodes, and Resources.

![The default event inspector view][EI-default]

You can click on events in the summary pane to inspect them in detail. For example, if you click on "With Changes" in the "Classes: with events" summary view, the main pane will show you that the MOTD class was successfully added when you triggered the last puppet run.

![Viewing a successful change][EI-class_change]

You can keep clicking to drill down and see more detail. You can click the back arrow left of the summary pane or the bread-crumb trail at the top of the page if you want to go back up a level. Eventually, you will end up at a run summary that shows you the details of the event. Note that you can see exactly which piece of puppet code was responsible for generating the event; in this case, it was line 21 of the `init.pp` manifest.

![Event detail][EI-detail]

If PE was unable to apply this class, the information would tell you exactly what piece of code you need to fix. In this case, you can see that PE is now managing the `/etc/motd` file.

Summary
-----

You have now experienced the core features and workflows of Puppet Enterprise. In summary, a Puppet Enterprise user will:

* Deploy new nodes, install PE on them ([\*nix](./install_basic.html) and [Windows](./install_windows.html) instructions), and [add them to their deployment by approving their certificate requests](./console_cert_mgmt.html).
* Use [pre-built modules from the Puppet Forge](http://forge.puppetlabs.com) to save time and effort.
* [Assign classes from modules to nodes in the console.](./console_classes_groups.html)
* [Allow nodes to be managed by regularly scheduled Puppet runs.](./puppet_overview.html#when-new-configurations-take-effect)
* Use [live management](./console_navigating_live_mgmt.html) to [inspect and compare nodes](./orchestration_resources.html), and to [trigger on-demand puppet agent](./orchestration_puppet.html) runs when necessary.
* Use [event inspector](./console_event-inspector.html) to learn more about events that occurred during puppet runs, such as what was changed or why something failed.

### Next

In addition to what this walkthrough has covered, most users will also:

* Edit modules from the Forge to make them better suit the deployment.
* Create new modules from scratch by writing classes that manage resources.
* Examine reports in the PE console.
* Use a **site module** to compose other modules into machine roles, allowing console users to control policy instead of implementation.
* Assign classes to groups in the console instead of individual nodes.

To learn about these workflows, continue to the [writing modules quick start guide](./quick_writing.html).

To explore the rest of the PE user's guide, use the sidebar at the top of this page, or [return to the index](./index.html).

* * *

- [Next: Quick Start: Writing Modules](./quick_writing.html)