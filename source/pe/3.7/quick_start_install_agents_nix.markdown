---
layout: default
title: "PE 3.7 » Quick Start » Agent Install (*nix)"
subtitle: "Agent Install Quick Start Guide"
canonical: "/pe/latest/quick_start_install_agents_nix.html"
---


## Overview

The following instructions are for installing Puppet agents on nodes running *nix operating systems. Refer to the [Windows agent installation quick start guide](./quick_start_install_agents_windows.html) for instructions on installing Puppet agents on nodes running supported versions of the Windows OS.

A computer running the PE agent is usually referred to as an “agent node”. The Puppet agent regularly pulls configuration catalogs from a Puppet master server and applies them to the local system.

For more information about Puppet agents, as well as the components that make up your PE deployment, visit the [installation overview](./install_basic.html) in the PE docs.

>**Tip**: If you don't have internet connectivity, refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](./install_agents.html#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access) to choose a method that is suitable for your needs.

>**Prerequisites**: This guide assumes you've [installed a monolithic PE deployment](./quick_start_install_mono.html) and have the Puppet master, the PE console, and PuppetDB up and running on one node.

## Installing the Puppet Enterprise Agent

Choose one of the following scenarios:

- My Puppet agent node has the [same OS and architecture as my Puppet master](#installing-agents-with-the-same-os-and-architecture-as-the-puppet-master).
- My Puppet agent node has a [different OS and architecture than my Puppet master](#installing-agents-with-different-os-and-architecture-than-the-puppet-master).


### Installing Agents with the Same OS and Architecture as the Puppet Master

If your Puppet agent node is the same OS and architecture as the Puppet master, log into your agent node and run the following command:
 `curl -k https://<master.example.com>:8140/packages/current/install.bash | sudo bash`.

This script detects the OS on which the agent is running, sets up an apt, yum, or zipper repo that refers back to the Puppet master, and then pulls down and installs the `pe-agent` packages.

> **Important**: After installation is complete, you need to approve your new agent node’s certificate request in the console. Continue on to [Approving the Certificate Request](#approving-the-certificate-request) to do so.

### Installing Agents with Different OS and Architecture than the Puppet Master

[classification_selector]: ./images/quick/classification_selector.png
[add_repo]: ./images/quick/add_repo.png
[node_request]: ./images/console/request_indicator.png

If your Puppet master OS and architecture are different from the agent, follow this example. This example describes adding an agent node running Debian 6 on AMD64 hardware. You can select a different architecture for your agent if you prefer.

To install an agent with a different OS than the Puppet master, you first add the appropriate class for the repo that contains the agent packages; you then classify the PE Master node group with that class; and then you run a curl command from the agent to the master to retrieve the necessary packages to install the agent.

1. From the console, click __Classification__ in the top navigation bar.

   ![classification selection][classification_selector]

2. From the __Classification page__, click the __PE Master__ group.

3. Click the __Classes__ tab.

4. In the __Add new class__ field, in the _Class name_ box, begin typing `pe_repo`, and select the class `pe_repo::platform::debian_6_amd64`, or whichever class you want, from the list of classes.

   > **Note**: The repo classes are listed as `pe_repo::platform::<agent_os_version_architecture>`

   ![adding the repo class][add_repo]

5. Click __Add class__.

6. Click __Commit 1 change__.

   **Note**: The class you selected now appears in the list of classes for the __PE Master__ group, but it has not yet been configured on your nodes. For that to happen, you need to kick off a Puppet run.

7. Click _Live Management_, and click __Control Puppet__.

8. Click __runonce__  and then click __Run__. This configures the Puppet master node using the newly-assigned class.

   The new repo is created in `/opt/puppet/packages/public`. It’s called `puppet-enterprise-3.7.0-<os-version-architecture>-agent`.

9. SSH into the Debian node where you want to install the agent, and run `curl -k https://<master.example.com>:8140/packages/current/install.bash | sudo bash`.

   You can replace `current` in the script with a specific PE version number, in the form of `3.x.x`.

>**Note**: Depending on your platform, the method for downloading the script may vary.

The installer installs and configures the Puppet Enterprise agent.

> **Important**: After installation is complete, you need to approve your new agent node’s certificate request in the console. Continue on to [Approving the Certificate Request](#approving-the-certificate-request) to do so.

### Approving the Certificate Request

During installation, the agent node contacts the Puppet master and requests a certificate. To add the node to the console and to start managing its configuration, you need to **approve its request on the Puppet master**. This is most easily done via the console, as follows.

1. From the console, note the pending __node requests__ indicator in the upper right corner. Click it to load a list of currently pending node requests.

   ![Node Request Indicator][node_request]

2. Click the __Accept All__ button to approve all the requests and add the nodes.

> The Puppet agents can now retrieve configurations from the master the next time Puppet runs.

### Testing the Agent Nodes

During this walkthrough, you’ll run the Puppet agent interactively. By default, the agent runs in the background and fetches configurations from the Puppet master every 30 minutes. (This interval is configurable with the `runinterval` setting in puppet.conf.) However, you can also trigger a Puppet run manually from the command line.

1. **On the agent node,** log in as root and run `puppet agent --test` on the command line. This triggers a single Puppet run on the agent with verbose logging.

   > **Note**: You might receive a `-bash: puppet: command not found` error; this is due to the fact that PE installs its binaries in `/opt/puppet/bin` and `/opt/puppet/sbin`, which aren't included in your default `$PATH`. To include these binaries in your default `$PATH`, manually add them to your profile or run `PATH=/opt/puppet/bin:$PATH;export PATH`.

2. Note the long string of log messages, which should end with `notice: Finished catalog run in [...] seconds`.

> You are now fully managing the agent node. It has checked in with the Puppet master for the first time and received its configuration info. It will continue to check in and fetch new configurations every 30 minutes. The node also appears in the console, where you can make changes to its configuration by assigning classes and modifying the values of class parameters.


---------------
Next: [Hello, World!](./quick_start_helloworld.html)


