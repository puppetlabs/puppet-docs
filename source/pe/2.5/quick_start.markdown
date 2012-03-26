---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Quick Start Guide"
subtitle: "Quick Start for PE 2.5"
---








Welcome to the PE 2.5 quick start guide. This document is a short walkthrough to help you evaluate Puppet Enterprise and become familiar with its features. By following along, you will do the following:

* Install a small proof-of-concept deployment
* Add nodes to your deployment
* Examine the node in real time with live management
* Install a third-party Puppet module
* Write your own Puppet module
* Apply Puppet classes to a node


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
> * [Puppet Enterprise installer tarballs](http://info.puppetlabs.com/puppet-enterprise) suitable for the OS and architecture your nodes are using. 
> * A network --- all of your nodes should be able to reach each other.
> * An internet connection or a local mirror of your operating system's package repositories, for downloading additional software that Puppet Enterprise may require.
> * [Properly configured firewalls](./install_preparing.html#firewall-configuration).
>     * For demonstration purposes, all nodes should allow **all traffic on ports 8140, 61613, and 443.** (Production deployments can and should partially restrict this traffic.)
> * [Properly configured name resolution](./install_preparing.html#name-resolution).
>     * Each node needs **a unique hostname,** and they should be on **a shared domain.** For the rest of this walkthrough, we will refer to the puppet master as `master.example.com` and the first agent node as `agent1.example.com`. You can substitute different names as needed.
>     * All nodes must **know their own hostnames.** This can be done by properly configuring reverse DNS on your local DNS server, or by setting the hostname explicitly. Setting the hostname usually involves the hostname command and one or more configuration files, and the exact method varies by platform. <!-- todo double check the reverse dns part -->
>     * All nodes must be able to **reach each other by name.** This can be done with a local DNS server, or by editing the `/etc/hosts` file on each node to point to the proper IP addresses.
>     * All nodes should also be able to **reach the puppet master node at puppet.example.com and at puppet.** This can be done with DNS or with hosts files.
>     * The **control workstation** from which you are carrying out these instructions must be able to **reach every node in the deployment by name.** 

### Installing the Puppet Master

* On the puppet master node, log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* Download the Puppet Enterprise tarball, extract it, and navigate to the directory it creates. 
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them. 
    * **Install** the puppet master and console roles; **skip** the cloud provisioner role. 
    * Make sure that the unique "certname" is **`master.example.com`**.
    * You will need the **email address and console password** it requests in order to use the console; **choose something memorable.**
    * None of the **other passwords** are relevant to this quick start guide. **Choose something random.**
    * **Accept the default responses for every other question** by hitting enter. 
* The installer will then install and configure Puppet Enterprise. It will probably need to install additional packages from your OS's repository, including Java and MySQL. 

**You have now installed the puppet master node.** Stay logged in as root for further exercises.

### Installing the Agent Node

* On the agent node, log in as root or with a root shell. (Use `sudo -s` to get a root shell if your operating system's root account is disabled.)
* Download the Puppet Enterprise tarball, extract it, and navigate to the directory it creates. 
* Run `./puppet-enterprise-installer`. The installer will ask a series of questions about which components to install, and how to configure them. 
    * **Skip** the puppet master, cloud provisioner, and console roles; **install** the puppet agent role.
    * Make sure that the unique "certname" is **`agent1.example.com`**.
    * Set the puppet master hostname as **`master.example.com`**. If you configured the master to be reachable at `puppet`, you can alternately accept the default. 
    * **Accept the default responses for every other question** by hitting enter. 
* The installer will then install and configure Puppet Enterprise. It should not need additional software.

**You have now installed the puppet agent node.** Stay logged in as root for further exercises.


Adding Nodes to a Deployment
-----

After installing, the agent node is **not yet allowed** to fetch configurations from the puppet master; it must be explicitly approved and granted a certificate. 

### Approving the Certificate Request

During installation, the agent node contacted the puppet master and requested a certificate. **To add the agent node to the deployment, approve its request on the puppet master.**

* On the puppet master node, run `puppet cert list` to view all outstanding certificate requests.
* Note that a node called `agent1.example.com` has requested a certificate, and a fingerprint for the request is shown. 
    * If you wish to validate the request, go to the agent node and run `puppet agent --fingerprint` --- the response should match the fingerprint visible on the puppet master. 
* On the puppet master node, run `puppet cert sign agent1.example.com` to approve the request and add the node to the deployment. 

**The agent node can now retrieve configurations from the master.**

### Testing the Agent Node

Puppet agent runs in the background on agent nodes. It fetches and applies configurations from the puppet master every 30 minutes. (This interval is configurable with the `runinterval` setting in puppet.conf.)

Puppet agent can also be run interactively. Now that the node is approved, run puppet agent and watch it in action. 

* On the agent node, run `puppet agent --test`; this will trigger a single puppet agent run with verbose logging. 
* Note the long string of log messages, which should end with `notice: Finished catalog run in [...] seconds`.

**The agent node has now checked in with the puppet master for the first time, and has both fetched a configuration and submitted a report. It is now visible in the console.**

### Viewing the Agent Node in the Console

[console_cert]: ./console_accessing.html#accepting-the-consoles-certificate
[console_nav]: ./console_navigating.html

You can now log into the console and see both the agent node and the puppet master node as registered agents.

* On your control workstation, open a web browser and point it to <https://master.example.com>. 
* You will receive a warning about an untrusted certificate. This is because _you_ were the signing authority for the console's certificate, and your Puppet Enterprise deployment is not known to the major browser vendors as a valid signing authority. **Ignore the warning and accept the certificate.** The steps to do this vary by browser; [see here][console_cert] for detailed steps for the major web browsers. 
* Next, you will see a login screen for the console:

    ![The console login screen](./images/quick/login.png)
    
    **Log in with the email address and password you provided when installing the puppet master.**
* Next, you will see the front page of the console, which shows a summary of your deployment's recent puppet runs. **Notice that both the master and the agent appear in the list of nodes:**

    ![The console front page](./images/quick/front.png)
* **Explore the console.** Note that if you click on a node to view its details, you can see its recent history, the Puppet classes it receives, and a very large list of inventory information about it. [See here for more information about navigating the console.][console_nav]

### Being Impatient

Although puppet agent is now fully functional on the agent node, some other Puppet Enterprise software is not; specifically, the daemon that listens for orchestration messages is not configured. **This is because Puppet Enterprise uses puppet to configure itself.**

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


**The agent node can now respond to orchestration messages, and its resources can be edited live in the console.**

Examining Nodes with Live Management
-----


