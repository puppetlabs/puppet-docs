These instructions apply to the currently supported Fedora releases, which are:

{% include platforms_fedora.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.

#### 1. Choose a Package Source

Fedora systems can install Puppet from Puppet Labs' official repo, or from the OS vendor's default repo.

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [yum.puppetlabs.com](http://yum.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-fedora).

##### Using Vendor Packages

Fedora includes Puppet in its default package repos. No extra steps are necessary to enable it.

These packages are usually older Puppet versions with security patches. <!-- dated --> As of April 2012, both current releases of Fedora had Puppet versions from the prior, maintenance-only release series.

#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run `sudo yum install puppet-server`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppetmaster.service`) for running a test-quality puppet master server.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo yum install puppet`. This will install Puppet and a systemd configuration (`/usr/lib/systemd/system/puppet.service`) for running the puppet agent daemon. (Note that prior to Puppet 3.4.0, the agent service name on Fedora ≥ 17 was `puppetagent` instead of puppet. This name will continue to work until Puppet 4, but you should use the more consistent `puppet` instead.)

For a standalone deployment, install this same package on all nodes.

#### 4. Configure and Enable

{{ after }}

