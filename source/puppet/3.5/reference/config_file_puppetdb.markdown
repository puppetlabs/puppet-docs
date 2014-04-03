---
layout: default
title: "Config Files: puppetdb.conf"
canonical: "/puppet/latest/reference/config_file_puppetdb.html"
---



The `puppetdb.conf` file contains the hostname and port of the [PuppetDB](/puppetdb/latest/) server. It is only used if you are using PuppetDB and have [connected your puppet master to it](/puppetdb/latest/connect_puppet_master.html).

## Location

The `puppetdb.conf` file is always located at `$confdir/puppetdb.conf`. Its location is **not** configurable.

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Example

    [main]
    server = puppetdb.example.com
    port = 8081

## Format

The `puppetdb.conf` file uses the same INI-like format as `puppet.conf`, but only uses a `[main]` section and only has two settings:

* The `server` setting must be set to the hostname of the PuppetDB server.
* The `port` setting must be set to the port of the PuppetDB server.

See the [PuppetDB manual](/puppetdb/latest/) for more information.

