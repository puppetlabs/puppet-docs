---
layout: default
title: "Config Files: puppetdb.conf"
---



The `puppetdb.conf` file contains the hostname and port of the [PuppetDB](/puppetdb/latest/) server. It is only used if you are using PuppetDB and have [connected your puppet master to it](/puppetdb/latest/connect_puppet_master.html).

## Location

The `puppetdb.conf` file is always located at `$confdir/puppetdb.conf`. (`/etc/puppetlabs/puppet/puppetdb.conf` in Puppet Enterprise, and `/etc/puppet/puppetdb.conf` in open source Puppet.)

Its location is **not** configurable.

## Example

    [main]
    server = puppetdb.example.com
    port = 8081

## Format

The `puppetdb.conf` file uses the same ini-like format as `puppet.conf`, but only uses a `[main]` block and only has two settings:

* The `server` setting must be set to the hostname of the PuppetDB server.
* The `port` setting must be set to the port of the PuppetDB server.

See the [PuppetDB manual](/puppetdb/latest/) for more information.

