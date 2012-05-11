---
title: "PuppetDB 0.9 » Configuration"
layout: pe2experimental
nav: puppetdb0.9.html
---

## Configuration guide

PuppetDB is configured using an INI-style file format. The format is
the same that Puppet proper uses for much of its own configuration.

Here is an example configuration file:

    [global]
    vardir = /var/lib/puppetdb
    logging-config = /var/lib/puppetdb/log4j.properties

    [database]
    classname = org.postgresql.Driver
    subprotocol = postgresql
    subname = //localhost:5432/puppetdb

    [jetty]
    port = 8080

You can specify either a single configuration file or a directory of
.ini files. If you specify a directory (_conf.d_ style) we'll merge
all the .ini files together in alphabetical order.

There's not much to it, as you can see. Here's a more detailed
breakdown of each available section:

**[global]**
This section is used to configure application-wide behavior.

`vardir`

This setting is used as the parent directory for the MQ's data directory. Also,
if a database isn't specified, the default database's files will be stored in
<vardir>/db. The directory must exist and be writable in order for the
application to run.

`logging-config`

Full path to a
[log4j.properties](http://logging.apache.org/log4j/1.2/manual.html)
file. Covering all the options available for configuring log4j is
outside the scope of this document, but the aforementioned link has
some exhaustive information.

For an example log4j.properties file, you can look at the `ext`
directory for versions we include in packages.

If this setting isn't provided, we default to logging at INFO
level to standard out.

You can edit the logging configuration file after you've started
PuppetDB, and those changes will automatically get picked up after a
few seconds.

**[database]**

`gc-interval`

How often, in minutes, to compact the database. The compaction process
reclaims space, and deletes unnecessary rows. If not supplied, the
default is every 60 minutes.

`classname`, `subprotocol`, and `subname`

These are specific to the type of database you're using. We currently
support 2 different configurations:

An embedded database (for proof-of-concept or extremely tiny
installations), and PostgreSQL.

If no database information is supplied, an HSQLDB database at
<vardir>/db will be used.

**Embedded database**

The configuration _must_ look like this:

    classname = org.hsqldb.jdbcDriver
    subprotocol = hsqldb
    subname = file:/path/to/db;hsqldb.tx=mvcc;sql.syntax_pgs=true

Replace `/path/to/db` with a filesystem location in which you'd like
to persist the database.

**PostgreSQL**

The `classname` and `subprotocol` _must_ look like this:

    classname = org.postgresql.Driver
    subprotocol = postgresql
    subname = //host:port/database

Replace `host` with the hostname on which the database is
running. Replace `port` with the port on which PostgreSQL is
listening. Replace `database` with the name of the database you've
created for use with PuppetDB.

It's possible to use SSL to protect connections to the database. The
[PostgreSQL JDBC docs](http://jdbc.postgresql.org/documentation/head/ssl.html)
indicate how to do this. Be sure to add `ssl=true` to the `subname`
parameter.

Other properties you can set:

`username`

What username to use when connecting.

`password`

A password to use when connecting.

**[command-processing]**

Options relating to the commang-processing subsystem. Every change to
PuppetDB's data stores comes in via commands that are inserted into
an MQ. Command processor threads pull items off of that queue,
persisting those changes.

`threads`

How many command processing threads to use. Each thread can process a
single command at a time. If you notice your MQ depth is rising and
you've got CPU to spare, increasing the number of threads may help
churn through the backlog faster.

If you are saturating your CPU, we recommend lowering the number of
threads.  This prevents other PuppetDB subsystems (such as the web
server, or the MQ itself) from being starved of resources, and can
actually _increase_ throughput.

This setting defaults to half the number of cores in your system.

**[jetty]**

HTTP configuration options.

`host`

The hostname to listen on for _unencrypted_ HTTP traffic. If not
supplied, we bind to localhost.

`port`

What port to use for _unencrypted_ HTTP traffic. If not supplied, we
won't listen for unencrypted traffic at all.

`ssl-host`

The hostname to listen on for HTTPS. If not supplied, we bind to
localhost.

`ssl-port`

What port to use for _encrypted_ HTTPS traffic. If not supplied, we
won't listen for encrypted traffic at all.

`keystore`

The path to a Java keystore file containing the key and certificate we
should use for HTTPS.

`key-password`

Passphrase to use to unlock the keystore file.

`truststore`

The path to a Java keystore file containing the CA certificate(s) for
your puppet infrastructure.

`trust-password`

Passphrase to use to unlock the truststore file.

**[repl]**

Enabling a remote
(REPL)[http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop]
allows you to manipulate the behavior of PuppetDB at runtime. This
should only be done for debugging purposes, and is thus disabled by
default. An example configuration stanza:

    [repl]
    enabled = true
    type = nrepl
    port = 8081

`enabled`

Set to `true` to enable the REPL.

`type`

Either `nrepl` or `swank`.

The _nrepl_ repl type opens up a socket you can connect to via
telnet. If you are using emacs' clojure-mode, you can choose a type of
_swank_ and connect your editor directly to a running PuppetDB
instance by using `M-x slime-connect`. Using emacs is much nicer than
using telnet. :)

`port`

What port to use for the REPL.
