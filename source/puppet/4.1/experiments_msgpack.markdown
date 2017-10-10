---
layout: default
title: "Experimental Features: Msgpack Support"
canonical: "/puppet/latest/experiments_msgpack.html"
---

Background on Msgpack
-----

Puppet agents and masters communicate over HTTPS, exchanging structured data in JSON (or, more specifically, "PSON," which allows binary data).

[Msgpack](http://msgpack.org/) is an efficient (in space and time) serialization protocol that behaves similarly to JSON. It should provide faster and more robust serialization for agent/master communications, without requiring many changes in our code.

When msgpack is enabled, the Puppet master and agent will communicate using msgpack instead of PSON.


Enabling Msgpack Serialization
-----

Enabling msgpack is easy, but first it must be installed, as we don't include this gem in the puppet-agent or puppetserver packages. 

1. Install the [msgpack gem](http://rubygems.org/gems/msgpack) on your master and all agent nodes.
    * If you are using a Puppet Enterprise test environment, be sure to use PE's gem command instead of the system gem command.
    * On \*nix nodes, use `/opt/puppetlabs/puppet/bin/gem install msgpack`. 
    * On Windows, use `"C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin\gem" install msgpack`
    * On Puppet Server, use `puppetserver gem install msgpack`, and then restart the Puppet Server service.
2. On any number of agent nodes, set [the `preferred_serialization_format` setting](./configuration.html#preferredserializationformat) to `msgpack` (in the `[agent]` or `[main]` section of puppet.conf).

Once this is configured, the Puppet master server(s) will use msgpack when serving any agents that have `preferred_serialization_format` set to `msgpack`. Any agents without that setting will continue to receive PSON as normal.
