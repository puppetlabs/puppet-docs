---
layout: default
title: "PE 2.6  » Puppet » Tools"
subtitle: "Puppet Tools"
canonical: "/pe/latest/puppet_tools.html"
---

Puppet is built on a large number of services and command-line tools. Understanding which to reach for and when is crucial to using Puppet effectively.

You can read more about any of these tools by running `puppet man <SUBCOMMAND>` at the command line.

Fundamental Services
-----

Puppet agent and puppet master are the heart of Puppet's architecture.

* The puppet agent service runs on every managed Puppet Enterprise node. It fetches and applies configurations from a puppet master server every 30 minutes.

    In Puppet Enterprise, puppet agent runs without user interaction as the `pe-puppet` service. You can manually trigger an immediate run from a node's command line by running `sudo puppet agent --test`. You can also trigger agent runs using the [Control Puppet](./console_live_puppet.html) tab of the console's live management page.

    Puppet agent reads its settings from the `[main]` and `[agent]` blocks of `/etc/puppetlabs/puppet/puppet.conf`.
* The puppet master service compiles and serves configurations to agent nodes.

    In Puppet Enterprise, puppet master is managed by Apache and Passenger, under the umbrella of the `pe-httpd` service.

    The puppet master creates agent configurations by consulting its Puppet modules and the instructions it receives from the [console](./console_accessing.html).

    The puppet master reads its settings from the `[main]` and `[master]` blocks of `/etc/puppetlabs/puppet/puppet.conf`. It can also be configured conditionally by using [environments](/puppet/latest/reference/environments_classic.html).

Everyday Tools
-----

* The puppet cert subcommand is used to add nodes to your puppet deployment.

    After a new agent node has been installed, it cannot fetch configurations until its certificate request has been approved. Run `puppet cert list` on the puppet master to see which certificate requests are still outstanding, and run `puppet cert sign <NODE>` to approve a request.

    When you decommission a node and remove it from your infrastructure, you should destroy its certificate information by running `puppet cert clean <NODE>` on the puppet master.
* The puppet apply subcommand can compile and apply Puppet manifests without the need for a puppet master. It's ideal for testing new modules (`puppet apply -e 'include <CLASS NAME>'`), but can also be used to manage an entire Puppet deployment in a masterless arrangement.
* The puppet resource subcommand provides an interactive shell for manipulating Puppet's underlying resource framework. It is ideal for one-off administration tasks and ad-hoc management, and offers an abstraction layer between various OSs' implementations of core functionality.

        $ sudo puppet resource package nano ensure=latest
        notice: /Package[nano]/ensure: created
        package { 'nano':
          ensure => '1.3.12-1.1',
        }

Advanced Tools
-----

* [See the cloud provisioning chapter of this guide](./cloudprovisioner_overview.html) for more about the cloud provisioning tools.
* [See the orchestration chapter of this guide](./orchestration_overview.html) for more about the command-line orchestration tools.


* * *

- [Next: Puppet Modules and Manifests](./puppet_modules_manifests.html)
