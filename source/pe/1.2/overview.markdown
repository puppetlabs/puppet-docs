Overview
=====

Puppet Enterprise is a software distribution bundling Puppet, Puppet Dashboard, and MCollective, and it embodies strong opinions about best practices for configuring and running these tools.

What Makes Puppet Enterprise Different?
-----

To get maximum compatibility and performance on your existing systems, PE bundles and maintains its own versions of Ruby, Apache, and all required libraries, and sequesters all of its software in the `/opt/puppet` directory. This lets us deploy complicated and cutting-edge features while shielding users from dependency conflicts, and offers a relatively seemless transition path for users moving to PE from an older manually maintained Puppet installation.

PE also offers several commercial features not found in the open source versions of the included software, including a new compliance and auditing workflow and a ready-to-use Puppet module for managing user accounts. 

Components of Puppet Enterprise
-----

- **Puppet** is an industry-leading configuration management platform that lets you describe the desired state of your infrastructure as code. 
- **Puppet Dashboard** is a web interface to Puppet. It can view and analyze Puppet's reports, and can simplify the process of assigning your existing Puppet classes to nodes. It also serves as the heart of the new Puppet Compliance workflow. 
- **MCollective** is a message-based server orchestration framework that enables fast and powerful parallel command execution.
- **Facter** is a tool for 
