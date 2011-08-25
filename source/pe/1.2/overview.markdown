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

Puppet Enterprise's features are divided into three main **roles,** any or all of which can be installed on a single computer:

- The **puppet agent** role should be installed on every node Puppet will be managing; it installs Puppet, and enables the puppet agent service (`pe-puppet`) that checks in with the puppet master every half-hour and applies the node's catalog. This role also installs (but doesn't automatically enable) the MCollective server, which listens and responds to messages on the ActiveMQ Stomp bus; to enable MCollective on a node, use Puppet to assign the `mcollectivepe` class to it.
- The **puppet master** role should be installed on exactly one server at your site[^multi]; it installs Puppet, Apache, the ActiveMQ server, and the MCollective control client. Servers with this role will respond to catalog requests from puppet agent nodes (using instances of puppet master managed by the `pe-httpd` Apache service), and will act as the hub for all MCollective traffic at the site. Puppet master can be configured during installation to submit reports to and request node classifications from Puppet Dashboard.
- The **Puppet Dashboard** role should be installed on exactly one server at your site; it installs Puppet Dashboard (with the Puppet Compliance extension), Puppet, and Apache, and configures them to respond to requests from the puppet master, serve a web interface to your site's administrators, and act as a machine inventory browser and file content viewer. The Dashboard role should usually be installed on the same machine as the puppet master role; splitting the two roles between different machines can increase performance in some situations, but will require some additional configuration.


[^multi]: A future release of PE may add support for multi-master ecosystems, but for the time being, they require significant extra configuration which won't be covered in this manual.

<!-- TK don't know what else goes here. -->
