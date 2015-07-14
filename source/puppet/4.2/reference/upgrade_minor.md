---
layout: default
title: "Minor Upgrades: Within 4.x (Puppet Collection 1 / PC1)"
canonical: "/puppet/latest/reference/upgrade_minor.html"
---


* We deliver Puppet 4.x (and all the stuff that works with it) in a group of releases called Puppet Collection 1 (PC1). Contains:
    * puppet-agent (has puppet, facter, hiera, and prerequisites like ruby and augeas)
    * puppetserver
    * puppetdb
* In general, upgrading from older versions of Puppet 4.x (and assoc'd stuff) to newer versions should be easy and painless.


* Upgrade Puppet Server regularly. If you're going to upgrade agent nodes to a new version of puppet-agent, make sure you upgrade Puppet Server on the server nodes first.
    * Puppet Server depends on the puppet-agent package. You should upgrade puppet-agent on a server node at the same time you upgrade Puppet Server. It might also upgrade automatically if that particular Puppet Server version requires a specific version of puppet-agent.
* Upgrade puppet-agent regularly.
    * Read the release notes first. Generally you need no special preparation to go from one 4.x version to another, but sometimes there's a note about changes that will affect certain users.
* You can upgrade PuppetDB independently of puppetserver and puppet-agent. You should use the puppetlabs/puppetdb module to manage it.
    * make sure to upgrade the puppetdb-terminus package on your Puppet Server nodes every time you upgrade puppetdb.
