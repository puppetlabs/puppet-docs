Overview
=====

What Is Puppet Enterprise? 
-----

Puppet Enterprise is a fully supported software distribution that bundles the Puppet family of systems management tools, adds several premium enterprise-only features, and deploys all of it in a highly scalable default configuration. 

- **Puppet** is an industry-leading configuration management platform that lets you describe a desired system state as code and enforce that state on any number of machines. 
- **MCollective** is a message-based server orchestration framework for fast parallel command execution.
- **Puppet Dashboard** is a web interface to Puppet. It can view and analyze Puppet's reports, and can simplify the process of assigning your existing Puppet classes to nodes.
- **Puppet Compliance** is an enterprise-only extension to Puppet Dashboard that enables a new auditing workflow for unmanaged resources.
- **Facter** is a system data discovery utility used by both Puppet and MCollective. 
- **Accounts** is a ready-to-use Puppet module for managing user accounts. 

To get maximum compatibility and performance on your existing systems, PE bundles and maintains its own versions of Ruby, Apache, and all required libraries, and sequesters all included software in the `/opt/puppet` directory. This lets us enable advanced features while still shielding users from dependency conflicts, and it offers a relatively seamless transition path for users migrating from a manually maintained Puppet installation.

PE Roles
-----

Puppet Enterprise's features are divided into three main **roles,** any or all of which can be enabled on a single computer:

- The **Puppet Agent** role should be installed on every node Puppet will be managing: it installs Puppet, and enables the puppet agent service (`pe-puppet`) that checks in with the puppet master every half-hour and applies the node's catalog. This role also installs (but doesn't automatically enable) the MCollective server, which listens and responds to messages on the ActiveMQ Stomp bus.
- The **Puppet Master** role should be installed on exactly one server at your site. (A future release of PE may add support for multi-master ecosystems.)