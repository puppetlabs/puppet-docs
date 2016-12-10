---
layout: default
title: "Experimental Features: Msgpack Support (Puppet 3.4+)"
canonical: "/puppet/latest/reference/experiments_msgpack.html"
---

> **Warning:** This document describes an **experimental feature,** which is not officially supported and is not considered ready for production. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise.

> **Status:** Msgpack support is available in Puppet 3.4.0 and later. We think it's probably superior to our existing serialization formats, but we aren't sure yet and haven't tested all edge cases. If it proves to do well under real-world loads, we may eventually adopt it as our default wire format.

Background on Msgpack
-----

Puppet agents and masters communicate over HTTPS, exchanging structured data in some serialization format. Traditionally, this has been a mix of YAML and JSON (or actually "PSON," which allows binary data); more recently (Puppet 3.3), we've been trying to deprecate YAML and move entirely to PSON.

[Msgpack](http://msgpack.org/) is an efficient (in space and time) serialization protocol that behaves similarly to JSON. It should provide faster and more robust serialization for agent/master communications, without requiring many changes in our code.

When msgpack is enabled, the puppet master and agent will communicate using msgpack instead of PSON or YAML.


Enabling Msgpack Serialization
-----

Enabling msgpack is easy, but enabling it requires a change on both the master and all agent nodes.

1. Install the [msgpack gem](http://rubygems.org/gems/msgpack) on your master and all agent nodes.
    * If you are using a Puppet Enterprise test environment, be sure to use PE's gem command instead of the system gem command. On \*nix nodes, use `/opt/puppet/bin/gem install msgpack`. On Windows 32-bit systems, use `"C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin\gem" install msgpack`; on 64-bit systems, substitute `Program Files (x86)` for `Program Files`.
2. On any number of agent nodes, set [the `preferred_serialization_format` setting](./configuration.html#preferredserializationformat) to `msgpack` (in the `[agent]` or `[main]` block of puppet.conf).

Once this is configured, the puppet master server(s) will use msgpack when serving any agents that have `preferred_serialization_format` set to `msgpack`. Any agents without that setting will continue to receive PSON as normal.
