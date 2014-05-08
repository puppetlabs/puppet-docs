Check the following before you install Puppet.

### OS/Ruby Version

* See the [supported platforms][platforms] guide.
* If your OS is older than the supported versions, you may still be able to run Puppet if you install an updated version of Ruby. See the [list of supported Ruby versions][ruby].

### Deployment Type

Decide on a deployment type before installing:

Agent/master
: Agent nodes pull their configurations from a puppet master server. Admins must manage node certificates, but will only have to maintain manifests and modules on the puppet master server(s), and can more easily take advantage of features like reporting and external data sources.

  You must decide in advance which server will be the master; install Puppet on it before installing on any agents. The master should be a dedicated machine with a fast processor, lots of RAM, and a fast disk.

Standalone
: Every node compiles its own configuration from manifests. Admins must regularly sync Puppet manifests and modules to every node.

### Network

In an agent/master deployment, you must prepare your network for Puppet's traffic.

* **Firewalls:** The puppet master server must allow incoming connections on port 8140, and agent nodes must be able to connect to the master on that port.
* **Name resolution:** Every node must have a unique hostname. **Forward and reverse DNS** must both be configured correctly. Instructions for configuring DNS are beyond the scope of this guide. If your site lacks DNS, you must write an `/etc/hosts` file on each node.

> **Note:** The default master hostname is `puppet`. Your agent nodes will be ready sooner if this hostname resolves to your puppet master.
