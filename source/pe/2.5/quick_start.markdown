---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Quick Start Guide"
subtitle: "Quick Start for PE 2.5"
---








Welcome to the PE 2.5 quick start guide. This document is a short walkthrough to help you evaluate Puppet Enterprise and become familiar with its features. By following along, you will do the following:

* Install a small proof-of-concept deployment
* Add nodes to your deployment
* Examine nodes in real time with live management
* Install a third-party Puppet module
* Apply Puppet classes to nodes with the console
* Write your own Puppet module


Creating a Deployment
-----

A standard Puppet Enterprise deployment consists of:

* Many **agent nodes,** which are computers managed by Puppet.
* At least one **puppet master server,** which serves configurations to agent nodes.
* At least one **console server,** which analyzes agent reports and presents a GUI for managing your site.

For this deployment, the puppet master and the console will be the same machine, and we will have one additional agent node.

> ### Preparing Your Proof-of-Concept Systems
> 
> To create this small deployment, you will need the following:
> 
> * At least two computers ("nodes") running a \*nix operating system [supported by Puppet Enterprise](./install_system_requirements.html).
>     * These can be virtual machines or physical servers. 
>     * One of these nodes (the "puppet master" server) should have at least 1 GB of RAM.
> * Optionally, a computer running a version of Microsoft Windows [supported by Puppet Enterprise](./install_system_requirements.html).
> * [Puppet Enterprise installer tarballs](http://info.puppetlabs.com/puppet-enterprise) suitable for the OS and architecture your nodes are using. 
> * A network --- all of your nodes should be able to reach each other.
> * An internet connection or a local mirror of your operating system's package repositories, for downloading additional software that Puppet Enterprise may require.
> * [Properly configured firewalls](./install_preparing.html#firewall-configuration).
>     * For demonstration purposes, all nodes should allow **all traffic on ports 8140, 61613, and 443.** (Production deployments can and should partially restrict this traffic.)
> * [Properly configured name resolution](./install_preparing.html#name-resolution).
>     * Each node needs **a unique hostname,** and they should be on **a shared domain.** For the rest of this walkthrough, we will refer to the puppet master as `master.example.com`, the first agent node as `agent1.example.com`, and the Windows node as `windows.example.com`. You can substitute different names as needed.
>     * All nodes must **know their own hostnames.** This can be done by properly configuring reverse DNS on your local DNS server, or by setting the hostname explicitly. Setting the hostname usually involves the hostname command and one or more configuration files, and the exact method varies by platform. <!-- todo double check the reverse dns part -->
>     * All nodes must be able to **reach each other by name.** This can be done with a local DNS server, or by editing the `/etc/hosts` file on each node to point to the proper IP addresses.
>     * All nodes should also be able to **reach the puppet master node at puppet.example.com and at puppet.** This can be done with DNS or with hosts files.
>     * The **control workstation** from which you are carrying out these instructions must be able to **reach every node in the deployment by name.** 

### Installing the Puppet Master

* **On the puppet master node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* Download the Puppet Enterprise tarball, extract it, and navigate to the directory it creates. 
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them. 
    * **Install** the puppet master and console roles; **skip** the cloud provisioner role. 
    * Make sure that the unique "certname" is **`master.example.com`**.
    * You will need the **email address and console password** it requests in order to use the console; **choose something memorable.**
    * None of the **other passwords** are relevant to this quick start guide. **Choose something random.**
    * **Accept the default responses for every other question** by hitting enter. 
* The installer will then install and configure Puppet Enterprise. It will probably need to install additional packages from your OS's repository, including Java and MySQL. 

**You have now installed the puppet master node.** A puppet master node **is also an agent node,** and can configure itself the same way it configures the other nodes in a deployment. Stay logged in as root for further exercises.

### Installing the Agent Node

* **On the agent node,** log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* Download the Puppet Enterprise tarball, extract it, and navigate to the directory it creates. 
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them. 
    * **Skip** the puppet master, cloud provisioner, and console roles; **install** the puppet agent role.
    * Make sure that the unique "certname" is **`agent1.example.com`**.
    * Set the puppet master hostname as **`master.example.com`**. If you configured the master to be reachable at `puppet`, you can alternately accept the default. 
    * **Accept the default responses for every other question** by hitting enter. 
* The installer will then install and configure Puppet Enterprise. It should not need additional software.

**You have now installed the puppet agent node.** Stay logged in as root for further exercises.

### Installing the Optional Windows Node

* **On the Windows node,** log in as a user with administrator privileges. 
* Download the Puppet Enterprise installer for Windows. 
* Run the Windows installer by double-clicking it. The installer will ask for the name of the puppet master to connect to; set this to **`master.example.com`.

**You have now installed the Windows puppet agent node.** Stay logged in as administrator for further exercises.

Adding Nodes to a Deployment
-----

After installing, the agent nodes are **not yet allowed** to fetch configurations from the puppet master; they must be explicitly approved and granted a certificate. 

### Approving the Certificate Request

During installation, the agent node contacted the puppet master and requested a certificate. **To add the agent node to the deployment, approve its request on the puppet master.**

* **On the puppet master node,** run `puppet cert list` to view all outstanding certificate requests.
* Note that nodes called `agent1.example.com` and `windows.example.com` (or whatever names you chose) have requested certificates, and fingerprints for the request are shown. 
    * If you wish to validate a request, go to the agent node and run `puppet agent --fingerprint` --- the response should match the fingerprint visible on the puppet master. 
        * Note that on Windows, you must first open a special command prompt by using the **"Start Command Prompt with Puppet"** start menu item. On Windows 7 and 2008, you must **right-click this item and choose "Run as Administrator."**
* **On the puppet master node,** run `puppet cert sign agent1.example.com` to approve the request and add the node to the deployment. Run `puppet cert sign windows.example.com` to approve the Windows node.

**The agent nodes can now retrieve configurations from the master.**

### Testing the Agent Nodes

Puppet agent runs in the background on agent nodes. It fetches and applies configurations from the puppet master every 30 minutes. (This interval is configurable with the `runinterval` setting in puppet.conf.)

Puppet agent can also be run interactively. Now that the node is approved, run puppet agent and watch it in action. 

* **On the first agent node,** run `puppet agent --test`; this will trigger a single puppet agent run with verbose logging. 
* Note the long string of log messages, which should end with `notice: Finished catalog run in [...] seconds`.
* **On the Windows node,** choose "Run Puppet Agent" from the start menu, elevating privileges if necessary.
* Note the similar string of log messages.

**The agent node has now checked in with the puppet master for the first time, and has both fetched a configuration and submitted a report. It is now visible in the console.**

### Viewing the Agent Node in the Console

[console_cert]: ./console_accessing.html#accepting-the-consoles-certificate
[console_nav]: ./console_navigating.html

You can now log into the console and see all agent nodes and the puppet master node as registered agents.

* **On your control workstation,** open a web browser and point it to <https://master.example.com>. 
* You will receive a warning about an untrusted certificate. This is because _you_ were the signing authority for the console's certificate, and your Puppet Enterprise deployment is not known to the major browser vendors as a valid signing authority. **Ignore the warning and accept the certificate.** The steps to do this vary by browser; [see here][console_cert] for detailed steps for the major web browsers. 
* Next, you will see a login screen for the console:

    ![The console login screen](./images/quick/login.png)
    
    **Log in with the email address and password you provided when installing the puppet master.**
* Next, you will see the front page of the console, which shows a summary of your deployment's recent puppet runs. **Notice that the master and any agent nodes appear in the list of nodes:**

    ![The console front page](./images/quick/front.png)
* **Explore the console.** Note that if you click on a node to view its details, you can see its recent history, the Puppet classes it receives, and a very large list of inventory information about it. [See here for more information about navigating the console.][console_nav]

### Being Impatient

Although puppet agent is now fully functional on any agent nodes, some other Puppet Enterprise software is not; specifically, the daemon that listens for orchestration messages is not configured. **This is because Puppet Enterprise uses puppet to configure itself.**

In a normal deployment, the orchestration features **would be enabled automatically within 30 minutes of adding the node:** 

* After the node checks in for the first time, the console becomes aware of its existence.
* Every two minutes, the console ensures that every node it knows of is added to the **default** group, which assigns the Puppet classes used to configure orchestration.
* The next time the node fetches its configuration (which will happen within 30 minutes), it will correctly configure orchestration, and will then be able to field live management requests.

If you do not have something else to do for the next half hour, you can do this manually in a matter of seconds:

* **On the console,** use the sidebar to navigate to the default group:

    ![the default group link](./images/quick/default_link.png)
* Click the "edit" button:

    ![the edit button](./images/quick/default_edit.png)
* In the "nodes" field, begin typing `agent1.example.com`'s name. You can then select it from the list of autocompletion guesses. Click the update button once you have selected it.

    ![the nodes field](./images/quick/default_nodes.png)
* **On the agent node,** run `puppet agent --test` again. Note the long string of log messages related to the `pe_mcollective` class. 
* **You do not need to repeat this for the Windows node.** Orchestration is not supported on Windows for this release of Puppet Enterprise.

**The agent node can now respond to orchestration messages, and its resources can be edited live in the console.**

Using Live Management to Control Agent Nodes
-----

Live management uses Puppet Enterprise's orchestration features to view and edit resources in real time. It can also trigger Puppet runs and orchestration tasks.

* **On the console,** click the "live management" tab in the top navigation.

    ![live management](./images/quick/live_mgmt.png)
* Note that the master and the first agent node are visible in the sidebar, but the Windows node is not. Live management is not supported on Windows nodes for this release of Puppet Enterprise.

### Viewing and Cloning Resources

* Note that you are currently in the "manage resources" tab. Click the "user resources" link, then click the "find resources" button:

    ![the find resources button](./images/quick/find_resources.png)
* Examine the **complete list of user accounts** found on all of the nodes currently selected in the sidebar node list. (In this case, both the master and the first agent node are selected.) Most of the users will be identical, as these machines are very close to a default OS install, but some users related to the puppet master's functionality are only on one node:

    ![different users](./images/quick/different_users.png)
* Click the MySQL user, which is only present on the puppet master. (If the MySQL server was installed on both nodes, you can use a different user like `peadmin`.)

    ![the mysql user details][mysql_user]
* Click the "clone" button, then click the new "preview" button. This will prepare the console to duplicate the mysql user across all of the nodes selected in the sidebar. 

    ![the preview button][clone_first]
    
    ![the preview][clone_preview]
* Click the "clone" button to finish.

    ![the completed clone operation][clone_done]

**The `mysql` user is now present on both the master and the first agent node.** You can clone user accounts, user groups, entries in the `/etc/hosts` file, and software packages using this interface. This can let you quickly make many nodes resemble a single model node. 

[mysql_user]: ./images/quick/mysql_user.png
[clone_done]: ./images/quick/clone_done.png
[clone_preview]: ./images/quick/clone_preview.png
[clone_first]: ./images/quick/clone_first.png

### Triggering Puppet Runs

* **On the console, in the live management page,* click the "control puppet" tab.
* Click the "runonce" action to reveal the "run" button, then click the "run" button.

    ![the run button revealed](./images/quick/control_puppet.png)

**You have just triggered a puppet agent run on several agents at once;** in this case, the master and the first agent node. The "runonce" action will trigger a puppet run on every node currently selected in the sidebar.

Installing a Puppet Module
-----

Puppet **configures nodes by applying classes to them.** Classes are **chunks of Puppet code that configure a specific aspect or feature of machine.**

Puppet classes are **distributed in the form of modules.** You can save time by **using pre-existing modules.** Pre-existing modules are distributed on the [Puppet Forge](http://forge.puppet.com), and **can be installed with the `puppet module` subcommand.** Any module installed on the puppet master can be used to configure agent nodes.

### Installing two Forge Modules

* **On your control workstation,** navigate to <http://forge.puppetlabs.com/puppetlabs/motd>. This is the Forge listing for a simple example module that sets the message of the day file (`/etc/motd`), which is displayed to users when the log in.
* Navigate to <https://forge.puppetlabs.com/puppetlabs/win_desktop_shortcut>. This is the Forge listing for a simple example module that manages a desktop shortcut on Windows.
* **On the puppet master,** run `puppet module search motd`. This is an alternate way to find the same information as a Forge listing contains:

        Searching http://forge.puppetlabs.com ...
        NAME             DESCRIPTION                                                 AUTHOR        KEYWORDS                     
        puppetlabs-motd  This module populates `/etc/motd` with the contents of ...  @puppetlabs   Testing                      
        jeffmccune-motd  This manages a basic message of the day based on useful...  @jeffmccune   motd                         
        dhoppe-motd       This module manages motd                                   @dhoppe       debian ubuntu motd           
        saz-motd         Manage 'Message Of The Day' via Puppet                      @saz          motd                         
* Install the first module by running `puppet module install puppetlabs-motd`:

        Preparing to install into /etc/puppetlabs/puppet/modules ...
        Downloading from http://forge.puppetlabs.com ...
        Installing -- do not interrupt ...
        /etc/puppetlabs/puppet/modules
        └── puppetlabs-motd (v1.0.0)
* Install the second module by running `puppet module install puppetlabs-win_desktop_shortcut`.

### Using a Module in the Console

[classbutton]: ./images/quick/add_class_button.png
[add_motd]: ./images/quick/add_motd.png
[assign_motd]: ./images/quick/assign_motd.png

Every module contains one or more classes. To discover which classes a module contains, **read its documentation or view the files in its `manifests` directory.** Modules are stored in `/etc/puppetlabs/puppet/modules.

The modules you just installed contain classes called `motd` and `win_desktop_shortcut`. To use the class, you must **tell the console about it** and then **apply it to one or more nodes.**

* **On the console,** click the "add class" button in the sidebar:

    ![The console's add class button][classbutton]
* Type the name of the `motd` class, and click the "create" button:

    ![the add class field][add_motd]
* Do the same for the `win_desktop_shortcut` class.
* Navigate to `agent1.example.com` (by clicking the all nodes link in the sidebar and clicking agent1's name), click the edit button, and begin typing "motd" in the "classes" field; you can select the `motd` class from the list of autocomplete suggestions. Click the "save changes" button after you have selected it. 

    ![assigning the motd class][assign_motd]
* Note that the `motd` class now appears in the list of agent1's classes.
* Navigate to `windows.example.com`, click the edit button, and begin typing "`win_desktop_shortcut`" in the "classes" field; select the class and click the "save changes" button.
* Note that the `win_desktop_shortcut` class now appears in the list of `windows.example.com`'s classes.
* Navigate to the live management page, and select the "control Puppet" tab. Use the "runonce" action to trigger a puppet run on both the master and the first agent. Wait one or two minutes.
* **On the first agent node,** run `cat /etc/motd`. Note that its contents resemble the following:

        The operating system is CentOS
        The free memory is 82.27 MB
        The domain is example.com
* **On the puppet master,** run `cat /etc/motd`. Note that its contents are either empty or the operating system's default, since the `motd` class wasn't applied to it.
* **On the Windows node,** choose "Run Puppet Agent" from the start menu, elevating privileges if necessary. 
* View the desktop; note that there is a shortcut to the Puppet Labs website.

**Puppet is now managing the first agent node's message of the day file,** and will revert it to the specified state if it is ever modified. **Puppet is also managing the desktop shortcut on the Windows machine,** and will restore it if it is ever deleted or modified. 

For more recommended modules, [explore the Forge](http://forge.puppetlabs.com) or check out the [Module of the Week series on the Puppet Labs blog.](http://puppetlabs.com/category/blog/module-of-the-week-blog/) 

Writing a Puppet Module
-----

Third-party modules save time, but **most users will also write their own modules.**

### Module Basics

Modules are directory trees that look like this:

- `core_permissions/` (the module name)
    - `manifests/`
        - `init.pp` (contains the `core_permissions` class)
        - `webserver.pp` (contains the `core_permissions::webserver` class)

File names map to class names in a predictable way: `init.pp` will contain a class with the same name as the module, `<NAME>.pp` will contain a class called `<MODULE NAME>::<NAME>`, and `<NAME>/<OTHER NAME>.pp` will contain `<MODULE NAME>::<NAME>::<OTHER NAME>`. 

* For more on how modules work, see [Module Fundamentals](/modules/modules_fundamentals.html) in the Puppet documentation.
* For a more detailed guided tour, see [the modules chapters of Learning Puppet](/learning/modules1.html). 

### Writing a Class in a Module

This exercise will create a class that manages the permissions of the fstab, passwd, and crontab files. 

* **On the puppet master,** navigate to the modules directory by running `cd /etc/puppetlabs/puppet/modules`. This is the default directory where Puppet looks for modules, and can be configured with the `modulepath` setting in puppet.conf. 
* Run `mkdir -p core_permissions/manifests` to create the module directory and manifests directory.
* Create and begin editing the `core_permissions/manifests/init.pp` file, using the editor of your choice. 
    * If you do not have a preferred Unix editor, run `nano core_permissions/manifests/init.pp`.
        * If nano is not installed, run `puppet resource package nano ensure=installed` to install it from your OS's package repositories. 
* Edit the init.pp file so it contains the following, then save it and exit the editor: 

{% highlight ruby %}
    class core_permissions {
      if $osfamily != 'windows' {

        $rootgroup = $operatingsystem ? {
          'Solaris' => 'wheel',
          default   => 'root',
        }
        
        file {'/etc/fstab':
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => 'root',
        }
        
        file {'/etc/passwd':
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => 'root',
        }
        
        file {'/etc/crontab':
          ensure => present,
          mode   => 0644,
          owner  => 'root',
          group  => 'root',
        }

      }
    }
{% endhighlight %}

**Puppet now knows about this class, and it can added to the console and assigned to nodes.**

This class:

* Uses a [conditional][] to only manage \*nix systems.
* Uses a [conditional][] and a variable to change the name of the root user's primary group on Solaris.
* Uses three [`file` resources][file_type] to manage the fstab, passwd, and crontab files on \*nix systems. These resources do not manage the content of the files, only the ownership and permissions. 

[file_type]: /references/latest/type.html#file
[conditional]: /guides/language_guide.html#conditionals

See the Puppet documentation for more information about writing classes. 

* To learn how to write resource declarations, conditionals, and classes in a guided tour format, [start at the beginning of Learning Puppet.](/learning/)
* For a complete but terse guide to the Puppet language's syntax, [see the language guide](/guides/language_guide.html).
* For complete documentation of the available resource types, [see the type reference](/references/latest/type.html).
* For short printable references, see [the modules cheat sheet](/module_cheat_sheet.pdf) and [the core types cheat sheet](/puppet_core_types_cheatsheet.pdf).

### Using a Homemade Module in the Console

* **On the console,** use the "add class" button to make the class available, just as in the [previous example](#using-a-module-in-the-console).

    ![adding the `core_permissions` class](./images/quick/add_core_permissions.png)
* Instead of assigning the class to a single node, **assign it to a group.** Navigate to the default group and use the edit button, then **add the `core_permissions` class to its list of classes.** Do not delete the existing classes, which are necessary for configuring new nodes.
* **On the puppet master node,** manually set dangerous permissions for the crontab and passwd files. This will make them editable by any unprivileged user.

        # chmod 0666 /etc/crontab /etc/passwd
        # ls -lah /etc/crontab /etc/passwd /etc/fstab
        -rw-rw-rw- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-r--r-- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-rw-rw- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **On the first agent node,** manually set dangerous permissions for the fstab file:

        # chmod 0666 /etc/fstab
        # ls -lah /etc/crontab /etc/passwd /etc/fstab
        -rw-rw-r-- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-r--rw- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-rw-r-- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **Run puppet agent once on every node.** You can do this by:
    * Doing nothing and waiting 30 minutes
    * Using live management to run Puppet on the two \*nix nodes, then triggering a manual run on Windows
    * Triggering a manual run on every node, with either `puppet agent --test` or the "Run Puppet Agent" start menu item.
* **On the master and first agent nodes,** note that the permissions of the three files have been returned to safe defaults, such that only root can edit them:

        # ls -lah /etc/fstab /etc/passwd /etc/crontab
        -rw-r--r-- 1 root root  255 Jan  6  2007 /etc/crontab
        -rw-r--r-- 1 root root  534 Aug 22  2011 /etc/fstab
        -rw-r--r-- 1 root root 2.3K Mar 26 08:18 /etc/passwd
* **On the Windows node,** note that the class has safely done nothing, and has not accidentally created any files in `C:\etc\`. 
* **On the console,** navigate to `master.example.com`, by clicking the nodes item in the top navigation and then clicking on the node's name. Scroll down to the list of recent reports, and note that the most recent one is blue, signifying that changes were made:

    ![blue report link][report_link]
    
* Click on the topmost report, then navigate to the "log" tab of the report:

    ![the report tabs, with the log tab circled][report_tabs]
* Note the two changes made to the file permissions:

    ![events logged in the node's report][report_log]

[report_link]: ./images/quick/master_report_link.png
[report_tabs]: ./images/quick/report_tabs.png
[report_log]: ./images/quick/report_log.png


### Using a Site Module to Simplify your Console

Many users create a "site" module. Instead of describing smaller units of a configuration, the classes in a site module **describe a complete configuration for a given _type_ of machine.** For example, a site module might contain:

* A `site::basic` class, for nodes that require security management but haven't been given a specialized role yet.
* A `site::webserver` class for nodes that serve web content.
* A `site::dbserver` class for nodes that provide a database server to other applications.

Site modules **hide complexity so you can more easily divide labor at your site.** System architects can create the site classes, and junior admins can create new machines and assign a single "role" class to them in the console. 

You can create a simple site module now.

* **On the puppet master,** create the `/etc/puppetlabs/puppet/modules/site/manifests/basic.pp` file, and edit it to contain the following: 

{% highlight ruby %}
    class site::basic {
      if $osfamily == 'windows' {
        include win_desktop_shortcut
      }
      else {
        include motd
        include core_permissions
      }
    }
{% endhighlight %}

* **On the console,** remove all of the previous classes from your nodes and groups using the edit button in each node or group page.
* Add the `site::basic` class to the console with the "add class" button in the sidebar.
* Assign the `site::basic` class to the default group.

**Your nodes are now receiving the same configurations as before, but with a simplified interface in the console.**

* The site module **declares** other classes with the `include` function. For more information about declaring classes, see [the modules and classes chapters of Learning Puppet](/learning/modules1.html).


Summary
-----

This walkthrough has introduced you to the core features and workflows of Puppet Enterprise. In summary, a Puppet Enterprise user will:

* Deploy new nodes, install PE on them, and add them to their deployment by approving their certificate requests.
* Create **modules** in `/etc/puppetlabs/puppet/modules`, and fill them with **classes** that manage **resources.**
* Use **pre-built modules from the Forge** to save time and effort.
* Assign classes to nodes in the console, either directly or with **groups.**
* Use live management for ad-hoc edits to nodes, and for triggering puppet agent runs when necessary.
