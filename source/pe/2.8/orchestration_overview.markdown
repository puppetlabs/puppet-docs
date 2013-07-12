---
layout: default
title: "PE 2.8  » Orchestration » Overview"
subtitle: "Orchestration for New PE Users: Overview"
canonical: "/pe/latest/orchestration_overview.html"
---

What is Orchestration?
-----

Orchestration means invoking actions in parallel across any number of nodes at once.

PE's orchestration features are built on the MCollective framework, which consists of the following components:

* **Client interfaces** can issue orchestration commands to some or all of your nodes. The console's live management tools are one client interface and the `mco` command line tool is another.
* **Orchestration agents** are plugins installed on agent nodes that provide orchestration actions.
* The **MCollective service** runs on every agent node and listens for orchestration commands. If a command is legit, relevant to the node, and for a supported action, the service will trigger the action and send back results.
* The **message broker** is a central server that routes orchestration messages between client interfaces and nodes running the MCollective service. (PE's ActiveMQ message server runs on the puppet master node.)

> ![windows-only](./images/windows-logo-small.jpg) **NOTE:** Orchestration and MCollective are not yet supported on Windows nodes.

### Orchestration isn't SSH

Orchestration isn't for running arbitrary code on nodes. Instead, each node has a collection of **actions** available. Actions are distributed in plugins, and you can extend PE's orchestration features by downloading or writing new orchestration agents and distributing them with Puppet.

### Live Management is Orchestration

The console's live management page offers
a convenient graphical interface for orchestration tasks, such as
browsing and cloning resources across nodes. See [the live management chapters of this user's guide](./console_live.html) for more details.

### Orchestration is Also Scriptable

In addition to live management's interactive interface, PE includes command-line tools
that let you script and automate orchestration tasks (or just run them from the comfort of your terminal).

Changes Since PE 1.2
-----

PE's orchestration features have been changed and improved since they were introduced in version 1.2.

* Orchestration is enabled by default for all PE nodes.
* Orchestration tasks can now be invoked directly from the console, using the "advanced tasks" tab of the live management page. PE's orchestration framework also powers the other live management features.
* The `mco` user account on the puppet master is gone, in favor of a new `peadmin` user. This user can still invoke orchestration tasks across your nodes, but will also gain more general purpose capabilities in future versions.
* PE now includes the `puppetral` plugin, which lets you use Puppet's Resource Abstraction Layer (RAL) in orchestration tasks.
* For performance reasons, the default message security scheme has changed from AES to PSK.
* The network connection over which messages are sent is now encrypted using SSL.

Security
-----

All network traffic for orchestration is encrypted with SSL (without host verification). In addition, all orchestration messages are authenticated using a randomly generated pre-shared key (PSK).

* If necessary, you can [change the password][mco_password] used as the pre-shared key.
* You can also [change the authentication method][mco_aes] to use an AES key pair instead of a pre-shared key. (Note that this can potentially affect performance with large numbers of nodes.)

[mco_password]: ./config_advanced.html#changing-the-pre-shared-key
[mco_aes]: ./config_advanced.html#changing-the-authentication-method


Network Traffic
-----

Nodes send orchestration messages over TCP port 61613
to the ActiveMQ server, which runs on the puppet master node. See the [notes on firewall configuration in the "System Requirements" chapter of this guide](./install_system_requirements.html#firewall-configuration) for more details about PE's network traffic.


* * *

- [Next: Orchestration Usage and Examples](./orchestration_usage.html)
