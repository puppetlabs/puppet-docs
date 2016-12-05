---
layout: default
title: "Config Files: puppetdb.conf"
canonical: "/puppet/latest/reference/config_file_puppetdb.html"
---

[puppetdb_connection]: /puppetdb/latest/puppetdb_connection.html


The `puppetdb.conf` file configures how Puppet should connect to one or more [PuppetDB](/puppetdb/latest/) servers. It is only used if you are using PuppetDB and have [connected your Puppet master to it](/puppetdb/latest/connect_puppet_master.html).

## PuppetDB 2.3 and Earlier

The following description does **not** apply to PuppetDB 3.0 and later. If you're using a newer version, see [the PuppetDB docs][puppetdb_connection] instead, as the file format has changed.

### Location

The `puppetdb.conf` file is always located at `$confdir/puppetdb.conf`. Its location is **not** configurable.

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

### Example

    [main]
    server = puppetdb.example.com
    port = 8081

### Format

The `puppetdb.conf` file uses the same INI-like format as `puppet.conf`, but only uses a `[main]` section and only has two settings:

* The `server` setting must be set to the hostname of the PuppetDB server.
* The `port` setting must be set to the port of the PuppetDB server.

See the [PuppetDB manual](/puppetdb/latest/) for more information.

