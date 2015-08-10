---
layout: default
title: "Quick Start » Puppet Master/Agent Communication"
subtitle: "Open Source Puppet Quick Start Guide Series: 3.8.0"
canonical: "/puppet/latest/quick_start_master_agent_communication.html"
---

## Overview

This guide walks you through the process to make sure your Puppet master and agent are able to communicate. To do so, you must modify your `/etc/hosts` file on your Puppet master and any agents you have installed, as well as open the firewall to your Puppet master so that it is able to sign certificates from your Puppet agents.

> **Prerequisites**: This guide assumes you've already [installed Puppet](./guides/install_puppet/pre_install.html), and have installed at least one [*nix agent node](./guides/install_puppet/post_install.html).
>
> For this walkthrough, you should be logged in as root or administrator on your nodes.

## Using the `/etc/hosts` file

To make sure your Puppet master and agents communicate, set the `/etc/hosts` file on each so that they’re aware of each other. 
First, use your text editor to open /etc/hosts on your Puppet master. Add each of your agents by IP address and name below the existing text. It should look something like this:

		192.168.33.11    agent1.example.com

Next, add the name and IP address of your Puppet master to each of your Puppet agents. Use your text editor to open /etc/hosts from the CLI of your Puppet agent and add the IP address and name of your Puppet master below the existing text, as well as the alias `puppet`. It should look similar to this:

		192.168.33.10    master.example.com puppet

Repeat this step for all of your Puppet agents.

>That’s it! You’ve successfully made sure your Puppet master and agents can communicate. 

## Opening port 8140 on your firewall

For your Puppet master to successful sign an agent certificate, the agent needs to be able to connect to the master’s firewall through port 8140. You will learn to set full firewall rules later in the Quick Start Guide.

***WARNING:*** These next steps open the port 8140 in your firewall. This does create a security risk.

From the CLI of your Puppet master, run:

		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8140 -j ACCEPT

From the CLI of your Puppet agent, run `puppet agent -t`.

From your Puppet master, run `puppet cert list` and then `puppet cert sign <NAME>` to sign the certificate(s) of your Puppet agent(s).

> That’s it! Your Puppet configuration is ready to go.