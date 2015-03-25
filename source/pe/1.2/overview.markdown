---
layout: default
title: "PE 1.2 Manual: Overview"
canonical: "/pe/latest/overview_about_pe.html"
---

{% include pe_1.2_nav.markdown %}

Overview
=====

What Is Puppet Enterprise? 
-----

Puppet Enterprise is a fully supported software distribution of the Puppet family of systems management tools. It adds several premium enterprise-only features, and deploys out-of-the-box into a highly scalable production-ready configuration. 

- **Puppet** (version 2.6.9) is an industry-leading configuration management platform that lets you describe a desired system state as code and enforce that state on any number of machines. 
- **MCollective** (version 1.2.1) is a message-based server orchestration framework for fast parallel command execution.
- **Puppet Dashboard** (version 1.2) is a web interface to Puppet. It can view and analyze Puppet's reports, and can simplify the process of assigning your existing Puppet classes to nodes.
- **Puppet Compliance** is an enterprise-only extension to Puppet Dashboard that enables a new workflow for auditing changes to resources.
- **Facter** (version 1.6.0) is a system data discovery utility used by both Puppet and MCollective. 
- **Accounts** (version 1.0.0) is a ready-to-use Puppet module for managing user accounts. 

To get maximum compatibility and performance on your existing systems, PE bundles and maintains its own versions of Ruby, Apache, and all required libraries, and installs all included software in the `/opt/puppet` directory. This lets us enable advanced features while still shielding users from dependency conflicts, and it offers a relatively seamless transition path for users migrating from a manually maintained Puppet installation.

Roles
-----

Puppet Enterprise's features are divided into three main **roles,** any or all of which can be installed on a single computer:

- The **puppet agent** role should be installed on every node Puppet will be managing; it installs Puppet, and enables the puppet agent service (`pe-puppet`) that checks in with the puppet master every half-hour and applies the node's catalog. This role also installs (but doesn't automatically enable) the MCollective server, which listens and responds to messages on the ActiveMQ Stomp bus; to enable MCollective on a node, use Puppet to assign the `mcollectivepe` class to it.
- The **puppet master** role should be installed on exactly one server at your site; it installs Puppet, Apache, the ActiveMQ server, and the MCollective control client. Servers with this role will respond to catalog requests from puppet agent nodes (using instances of puppet master managed by the `pe-httpd` Apache service), and will act as the hub for all MCollective traffic at the site. Puppet master can be configured during installation to submit reports to and request node classifications from Puppet Dashboard.
- The **Puppet Dashboard** role should be installed on exactly one server at your site; it installs Puppet Dashboard (with the Puppet Compliance extension), Puppet, and Apache, and configures them to respond to requests from the puppet master, serve a web interface to your site's administrators, and act as a machine inventory browser and file content viewer. Unlike the other two roles, Puppet Dashboard is an optional component of your site. The Dashboard role should usually be installed on the same machine as the puppet master role; splitting the two roles between different machines can increase performance in some situations, but will require some additional configuration.




Licensing
------

Puppet Enterprise can be evaluated with a complementary ten-node license; beyond that, a commercial per-node license is required for use. A license key file will have been emailed to you after your purchase, and the puppet master  will look for this key at `/etc/puppetlabs/license.key`. Puppet will log warnings if the license is expired or exceeded, and you can view the status of your license by running `puppet license` at the command line on the puppet master. 

To purchase a license, please see the [Puppet Enterprise pricing page](http://www.puppetlabs.com/puppet/how-to-buy/), or contact Puppet Labs at <sales@puppetlabs.com> or (877) 575-9775. For more information on licensing terms, please see [the licensing FAQ](http://www.puppetlabs.com/licensing-faq/). If you have misplaced or never received your license key, please contact <sales@puppetlabs.com>. 

