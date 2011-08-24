Components of Puppet Enterprise
===============

Puppet Enterprise is made up of several clusters of functionality. 

Puppet Master
------

Puppet master serves compiled configurations, files, templates, and custom plugins to managed nodes. It also acts as the certificate authority that authenticates agents. Puppet Enterprise currently supports sites with a single puppet master server; future releases may support more complex deployments.

In Puppet Enterprise, the puppet master service is managed by Apache 2 with [Phusion Passenger](http://www.modrails.com/). It never needs to be run directly; as long as Apache is running (as `pe-httpd`), puppet master will be able to respond efficiently to agent nodes. 

Puppet Agent
-----

The puppet agent service retrieves and applies the catalogs compiled by the puppet master. By default, it runs as a daemon on managed nodes and requests a catalog every 30 minutes.

Puppet Dashboard
------

Puppet Dashboard is a web interface for Puppet, which can view and analyze reports and assign classes to nodes. 

Puppet Enterprise uses an enhanced version of Puppet Dashboard, with new PE-only compliance features (see below) and with inventory and file content viewing enabled by default. 

MCollective
------

MCollective is a server orchestration framework that enables fast and powerful parallel command execution. Puppet Enterprise installs MCollective and all of its dependencies, and lets you use Puppet itself to manage it. 

<!-- TK what happens w/ mcollective server if you install master but no agent? -->

Compliance Features
------

Puppet Enterprise includes exclusive new compliance features for auditing changes to unmanaged resources 

Modules
------

### Accounts

### Stdlib

### MCollective

### Baselines

Facter
------

