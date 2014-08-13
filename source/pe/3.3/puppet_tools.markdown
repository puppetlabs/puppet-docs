---
layout: default
title: "PE 3.3 » Puppet » Tools"
subtitle: "Puppet Tools"
canonical: "/pe/latest/puppet_tools.html"
---

Puppet is built on a large number of services and command-line tools. Understanding which to reach for and when is crucial to using Puppet effectively.

You can read more about any of these tools by running `puppet man <SUBCOMMAND>` at the command line.

Services
-----

Puppet agent and puppet master are the heart of Puppet's architecture.

* The puppet agent service runs on every managed Puppet Enterprise node. It fetches and applies configurations from a puppet master server.

    In Puppet Enterprise, the puppet agent runs without user interaction as the `pe-puppet` service; by default, it performs a run every 30 minutes. You can also [use the orchestration engine to manually trigger Puppet runs on any nodes](./orchestration_puppet.html). (If you are logged into an agent node as an administrator, you can also run `sudo puppet agent --test` from the command line.)

    The puppet agent reads its settings from the `[main]` and `[agent]` blocks of `/etc/puppetlabs/puppet/puppet.conf`.
* The puppet master service compiles and serves configurations to agent nodes.

    In Puppet Enterprise, the puppet master is managed by Apache and Passenger, under the umbrella of the `pe-httpd` service. Apache handles HTTPS requests from agents, and it spawns and kills puppet master processes as needed.

    The puppet master creates agent configurations by consulting its Puppet modules and the instructions it receives from the [console](./console_accessing.html).

    The puppet master reads its settings from the `[main]` and `[master]` blocks of `/etc/puppetlabs/puppet/puppet.conf`. It can also be configured conditionally by using [environments](/puppet/3.6/reference/environments.html).
* The PuppetDB service collects information from the puppet master, and makes it available to other services.

    The puppet master itself consumes PuppetDB's data in the form of [exported resources][exported]. You can also install [a set of additional functions][query_functions] to do deeper queries from your Puppet manifests.

    External services can easily integrate with PuppetDB's data via its query API. [See the PuppetDB manual's API pages][puppetdb_api] for more details.

[query_functions]: https://forge.puppetlabs.com/dalen/puppetdbquery
[exported]: /puppet/3.6/reference/lang_exported.html
[puppetdb_api]: /puppetdb/1.6/api/index.html

Everyday Tools
-----

[cert_mgmt]: ./console_cert_mgmt.html
* The [node requests page of the PE console][cert_mgmt] is used to add nodes to your Puppet Enterprise deployment.

    After a new agent node has been installed, it requests a certificate from the master, which will allow it to fetch configurations; the agent node can't be managed by PE until its certificate request has been approved. [See the documentation for the node requests page][cert_mgmt] for more info.

    When you decommission a node and remove it from your infrastructure, you should destroy its certificate information by logging into the puppet master server as an admin user and running `puppet cert clean <NODE NAME>`.
* The `puppet apply` subcommand can compile and apply Puppet manifests without the need for a puppet master. It's ideal for testing new modules (`puppet apply -e 'include <CLASS NAME>'`), but can also be used to manage an entire Puppet deployment in a masterless arrangement.
* The `puppet resource` subcommand provides an interactive shell for manipulating Puppet's underlying resource framework. It works well for one-off administration tasks and ad-hoc management, and offers an abstraction layer between various OSs' implementations of core functionality.

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

- [Next: Puppet Data Library](./puppet_data_library.html)