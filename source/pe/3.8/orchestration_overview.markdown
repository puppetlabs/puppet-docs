---
layout: default
title: "PE 3.8 » Orchestration » Overview"
subtitle: "Overview of Orchestration Topics"
canonical: "/pe/latest/orchestration_overview.html"
---


Puppet Enterprise includes an orchestration engine (MCollective), which can invoke many kinds of actions in parallel across any number of nodes. Several useful actions are available by default, and you can easily add and use new actions.

Quick Links
-----

**Special orchestration tasks:**

- [Controlling Puppet](./orchestration_puppet.html)
- [Browsing and Searching Resources](./orchestration_resources.html)

**General orchestration tasks:**

- [Invoking Actions (In the PE Console)](./console_navigating_live_mgmt.html)
- [Invoking Actions (Command Line)](./orchestration_invoke_cli.html)
- [List of Built-In Actions](./orchestration_actions.html)

**Extending the orchestration engine:**

- [Adding New Actions](./orchestration_adding_actions.html)

**Configuring the orchestration engine:**

- [Configuring Orchestration](./orchestration_config.html)


> **Note:** Sometimes, newly added nodes won't respond immediately to orchestration commands. These nodes will begin responding to orchestration commands about 30 minutes after Puppet Enterprise is installed. You can accelerate this by logging into the node and running `puppet agent --test` as an admin user.

Orchestration Fundamentals
-----

### Actions and Plugins

Orchestration isn't quite like SSH, PowerShell, or other tools meant for running arbitrary shell code in an ad-hoc way.

PE's orchestration is built around the idea of predefined **actions** --- it is essentially a highly parallel **remote procedure call (RPC)** system.

**Actions** are distributed in **MCollective agent plugins**, which are bundles of several related actions.

* Many plugins are available by default; see [Built-In Orchestration Actions](./orchestration_actions.html).
* You can extend the orchestration engine by downloading or writing new plugins and [adding them to the engine with Puppet](./orchestration_adding_actions.html).

### Invoking Actions and Filtering Nodes

The core concept of PE's orchestration is **invoking actions**, in parallel, on a select group of nodes.

Typically you choose some nodes to operate on (usually with a **filter** that describes the desired fact values or Puppet classes), and specify an **action** and its **arguments**. The orchestration engine then runs that action on the chosen nodes, and displays any data collected during the run.

Puppet Enterprise can invoke orchestration actions in two places:

* [**In the PE console** (on the live management page)](./console_navigating_live_mgmt.html)
* [**On the command line**](./orchestration_invoke_cli.html)

>**Note**: Live Management is deprecated in PE 3.8 and will be replaced in future versions of PE. See the [PE 3.8 release notes](./release_notes.html#live-management-is-deprecated) for more information.

### Special Interfaces: Puppet Runs and Resources

In addition to the main action invocation interfaces, Puppet Enterprise provides special interfaces for two of the most useful orchestration tasks:

* [Remotely controlling the Puppet agent and triggering Puppet runs](./orchestration_puppet.html)
* [Browsing and comparing resources across your nodes](./orchestration_resources.html)


Orchestration Internals
-----

### Components

The orchestration engine consists of the following parts:

- The `pe-activemq` service (which runs on the Puppet master server) routes all orchestration-related messages.
- The `pe-mcollective` service (which runs on every agent node) listens for authorized commands and invokes actions in response. It relies on the available agent plugins for its set of possible actions.
- The `mco` command (available to the `peadmin` user account on the Puppet master server) and the live management page of the PE console can issue authorized orchestration commands to any number of nodes.

### Configuration

See [the Configuring Orchestration page][config].

[config]: ./orchestration_config.html

### Security

The orchestration engine in Puppet Enterprise 3.0 uses the same security model as the recommended "standard MCollective deployment." [See the "security model" section on the MCollective standard deployment page](/mcollective/deploy/standard.html#security-model) for a more detailed rundown of these security measures.

In short, all commands and replies are encrypted in transit, and only a few authorized clients are permitted to send commands. By default, PE allows orchestration commands to be sent by:

- Read/write and admin users of the PE console
- Users able to log in to the Puppet master server with full administrator `sudo` privileges

If you extend orchestration by [integrating external applications][integrate], you can limit the actions each application has access to by distributing policy files; [see the Configuring Orchestration page][config] for more details.

You can also allow additional users to log in as the `peadmin` user on the Puppet master, usually by distributing standard SSH public keys.

### Network Traffic

Every node (including all agent nodes, the Puppet master server, and the console) needs the ability to initiate connections to the Puppet master server over TCP port 61613. See the [notes on firewall configuration in the "System Requirements" chapter of this guide](./install_system_requirements.html#firewall-configuration) for more details about PE's network traffic.


* * *

- [Next: Invoking Actions](./orchestration_invoke_cli.html)
