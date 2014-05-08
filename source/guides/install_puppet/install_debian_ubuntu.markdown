These instructions apply to currently supported versions of Debian, Ubuntu, and derived Linux distributions, including:

{% include platforms_debian_like.markdown %}

Users of out-of-production versions may have vendor packages of Puppet available, but cannot use the Puppet Labs packages.

#### 1. Choose a Package Source

Debian and Ubuntu systems can install Puppet from Puppet Labs' official repo, or from the OS vendor's default repo.

##### Using Puppet Labs' Packages

Puppet Labs provides an official package repo at [apt.puppetlabs.com](http://apt.puppetlabs.com). It contains up-to-date packages, and can install Puppet and its prerequisites without requiring any other external repositories.

To use the Puppet Labs repo, [follow the instructions here](/guides/puppetlabs_package_repositories.html#for-debian-and-ubuntu).

##### Using Vendor Packages

Debian and Ubuntu distributions include Puppet in their default package repos. No extra steps are necessary to enable it.

Older OS versions will have outdated Puppet versions, which are updated only with security patches. As a general guideline to how current OS packages tend to be, we found the following when checking versions in April 2012:

* Debian unstable's Puppet was current.
* Debian testing's Puppet was nearly current (one point release behind the current version).
* Debian stable's Puppet was more than 18 months old, with additional security patches.
* The latest Ubuntu's Puppet was nearly current (one point release behind).
* The prior (non-LTS) Ubuntu's Puppet was nine months old, with additional security patches.
* The prior LTS Ubuntu's Puppet was more than two years old, with additional security patches.


#### 2. Install the Puppet Master

Skip this step for a standalone deployment.

On your puppet master node, run one of the following:

* `sudo apt-get install puppetmaster` --- This will install Puppet, its prerequisites, and an init script (`/etc/init.d/puppetmaster`) for running a test-quality puppet master server.
* `sudo apt-get install puppetmaster-passenger` --- (May not be available for all OS versions.) This will automatically configure a production-capacity web server for the Puppet master, using Passenger and Apache. In this configuration, do not use the puppetmaster init script; instead, control the puppet master by turning the Apache web server on and off or by disabling the puppet master vhost.

#### 3. Install Puppet on Agent Nodes

On your other nodes, run `sudo apt-get install puppet`. This will install Puppet and an init script (`/etc/init.d/puppet`) for running the puppet agent daemon.

For a standalone deployment, run `sudo apt-get install puppet-common` on all nodes instead. This will install Puppet without the agent init script.

#### 4. Configure and Enable

{{ after }}
