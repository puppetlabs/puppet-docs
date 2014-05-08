These instructions apply to the following Enterprise Linux (EL) versions:

{% include platforms_redhat_like.markdown %}

CentOS and other community forks have all of Puppet's requirements in the main repo, but RHEL itself is split into channels. If you're installing Puppet on RHEL, you'll want to make sure the "optional" channel is enabled.

Users of out-of-production EL systems (i.e. RHEL 4) may need to compile their own copy of Ruby before installing, or use an older snapshot of EPEL.

#### 1. Choose a Package Source

Enterprise Linux users can install from Puppet Labs' official repo, or from [EPEL][].

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [yum.puppetlabs.com](http://yum.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-red-hat-enterprise-linux-and-derivatives).

##### Using EPEL

The [Extra Packages for Enterprise Linux (EPEL)][epel] repo includes Puppet and its prerequisites. These packages are usually older Puppet versions with security patches. <!-- dated --> As of April 2012, EPEL was shipping a Puppet version from the prior, maintenance-only release series.

To install Puppet from EPEL, follow [EPEL's own instructions][epelinstall] for enabling their repository on all of your target systems.


#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo yum install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

For a standalone deployment, install this same package on all nodes.


#### 4. Configure and Enable

{{ after }}

