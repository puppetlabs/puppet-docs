---
layout: default
title: "Quick Start » Puppet Master/Agent Communication"
subtitle: "Open Source Puppet Quick Start Guide Series: 3.8.0"
canonical: "/puppet/latest/quick_start_master_agent_communication.html"
---

## Overview

This guide walks you through the process to make sure your Puppet master and agents are able to communicate. This involves modifying the `/etc/hosts` file on your master and agents, and also opening the firewall to your master so that it is able to sign certificates from the agents.

> **Prerequisites**: This guide assumes you've already [installed Puppet](/puppetserver/2.2/install_from_packages.html), and have installed at least one [*nix agent](./install_linux.html).
>
> For this walk-through, log in as root or administrator on your nodes.

##  Modifying the `/etc/hosts` files

To make sure your Puppet master and agents communicate, update the `/etc/hosts` file on each so that they’re aware of each other.
First, use your text editor to open `/etc/hosts` on your Puppet master. Add each of your agents by IP address and name below the existing text. It should look something like this:

		192.168.33.11    agent1.example.com

Next, add the name and IP address of your Puppet master to each of your Puppet agents. Use your text editor to open `/etc/hosts` on your Puppet agent and add the IP address and name of your Puppet master below the existing text, as well as the alias `puppet`. It should look similar to this:

		192.168.33.10    master.example.com puppet

Repeat this step for all of your Puppet agents.

> Congratulations! You’ve successfully made sure your Puppet master and agents can communicate.

## Opening port 8140 on your firewall

For your Puppet master to sign an agent certificate, the agent needs to be able to connect to the master’s firewall through port 8140. You will learn to set full firewall rules later in the Quick Start Guide.

***WARNING:*** These next steps open the port 8140 in your firewall. This does create a security risk, as you will need to keep port 8140 open so that the master and agents can continue to communicate.

From the command line on your Puppet master, run:

		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8140 -j ACCEPT

From the command line on each Puppet agent, run `puppet agent -t`.

From your Puppet master, run `puppet cert list` and then `puppet cert sign <AGENT NAME>` to sign the certificates of your Puppet agents.

> That’s it! Your Puppet configuration is ready to go.

--------

Next: Return to the [Quick Start Guides](./quick_start.html) or get started with the [Hello World Guide](./quick_start_helloworld.html).