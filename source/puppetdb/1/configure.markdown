---
title: "PuppetDB 1 » Configuration"
layout: default
canonical: "/puppetdb/latest/configure.html"
---

[log4j]: http://logging.apache.org/log4j/1.2/manual.html
[dashboard]: ./maintain_and_tune.html#monitor-the-performance-dashboard

Summary
-----


PuppetDB has three main groups of settings:

* The init script's configuration file, which sets the Java heap size and the location of PuppetDB's main config file
* Logging settings, which go in the [log4j.properties](#logging-config) file and can be changed without restarting PuppetDB
* All other settings, which go in PuppetDB's configuration file(s) and take effect after the service is restarted


### Init Script Config File

If you installed PuppetDB from packages or used the `rake install` installation method, an init script was created for PuppetDB. This script has its own configuration file, whose location varies by platform and by package:

OS and Package              | File
----------------------------|----------------------------
Redhat-like (open source)   | `/etc/sysconfig/puppetdb`
Redhat-like (PE)            | `/etc/sysconfig/pe-puppetdb`
Debian/Ubuntu (open source) | `/etc/default/puppetdb`
Debian/Ubuntu (PE)          | `/etc/default/pe-puppetb`

 In this file, you can change the following settings:

`JAVA_BIN`

: The location of the Java binary.

`JAVA_ARGS`

: Command line options for the Java binary, most notably the `-Xmx` (max heap size) flag.

`USER`

: The user PuppetDB should be running as.

`INSTALL_DIR`

: The directory into which PuppetDB is installed.

`CONFIG`

: The location of the PuppetDB config file, which may be a single file or a directory of .ini files.

#### Configuring the Java Heap Size

To change the JVM heap size for PuppetDB, edit the [init script config file](#init-script-config-file) by setting a new value for the `-Xmx` flag in the `JAVA_ARGS` variable.

For example, to cap PuppetDB at 192MB of memory:

    JAVA_ARGS="-Xmx192m"

To use 1GB of memory:

    JAVA_ARGS="-Xmx1g"

### Configuring Logging

Logging is configured with a log4j.properties file, whose location is defined with the [`logging-config`](#logging-config) setting. If you change the log settings while PuppetDB is running, it will apply the new settings without requiring a restart. 

[See the log4j documentation][log4j] for more information about logging options.


### The PuppetDB Configuration File(s)

PuppetDB is configured using an INI-style config format with several `[sections]`. This is very similar to the format used by Puppet. 

**Whenever you change PuppetDB's configuration settings, you must restart the service for the changes to take effect.**

You can change the location of the main config file in [the init script config file](#init-script-config-file). This location can point to a single configuration file or a directory of .ini files. If you specify a directory (_conf.d_ style), PuppetDB will merge the .ini files in alphabetical order.

If you've installed PuppetDB from a package, by default it will use the _conf.d_ config style. The default config directory is `/etc/puppetdb/conf.d` (or `/etc/puppetlabs/puppetdb/conf.d` for Puppet Enterprise).  If you're running from source, you may use the `-c` command-line argument to specify your config file or directory.

An example configuration file:

    [global]
    vardir = /var/lib/puppetdb
    logging-config = /var/lib/puppetdb/log4j.properties
    resource-query-limit = 20000

    [database]
    classname = org.postgresql.Driver
    subprotocol = postgresql
    subname = //localhost:5432/puppetdb

    [jetty]
    port = 8080

`[global]` Settings
-----


The `[global]` section is used to configure application-wide behavior.

### `vardir`

This defines the parent directory for the MQ's data directory. Also, if a database isn't specified, the default database's files will be stored in `<vardir>/db`. The directory must exist and be writable by the PuppetDB user in order for the application to run.

### `logging-config`

This describes the full path to a [log4j.properties](http://logging.apache.org/log4j/1.2/manual.html) file. Covering all the options available for configuring log4j is outside the scope of this document; see the aforementioned link for exhaustive information.

If this setting isn't provided, PuppetDB defaults to logging at INFO level to standard out.

If you installed from packages, PuppetDB will use the log4j.properties file in the `/etc/puppetdb/` or `/etc/puppetlabs/puppetdb` directory. Otherwise, you can find an example file in the `ext` directory of the source.

You can edit the logging configuration file while PuppetDB is running, and it will automatically react to changes after a few seconds.

### `resource-query-limit`

The maximum number of legal results that a resource query can return.  If you issue a query that would result in more results than this value, the query will simply return an error.  (This can be used to prevent accidental queries that would yield huge numbers of results from consuming undesirable amounts of resources on the server.)
  
The default value is 20000.

`[database]` Settings
-----

The `[database]` section configures PuppetDB's database settings.

PuppetDB can use either **a built-in HSQLDB database** or **a PostgreSQL database.** If no database information is supplied, an HSQLDB database at `<vardir>/db` will be used.

> **FAQ: Why no MySQL or Oracle support?** 
>
> MySQL lacks several features that PuppetDB relies on; the most notable is recursive queries. We have no plans to ever support MySQL.
>
> Depending on demand, Oracle support may be forthcoming in a future version of PuppetDB. This hasn't been decided yet.

### Using Built-in HSQLDB

To use an HSQLDB database at the default `<vardir>/db`, you can simply remove all database settings. To configure the DB for a different location, put the following in the `[database]` section:

    classname = org.hsqldb.jdbcDriver
    subprotocol = hsqldb
    subname = file:</PATH/TO/DB>;hsqldb.tx=mvcc;sql.syntax_pgs=true
  
Replace `</PATH/TO/DB>` with the filesystem location in which you'd like to persist the database.

Do not use the `username` or `password` settings.

### Using PostgreSQL

Before using the PostgreSQL backend, you must set up a PostgreSQL server, ensure that it will accept incoming connections, create a user for PuppetDB to use when connecting, and create a database for PuppetDB. Completely configuring PostgreSQL is beyond the scope of this manual, but if you are logged in as root on a running Postgres server, you can create a user and database as follows:

    $ sudo -u postgres sh
    $ createuser -DRSP puppetdb
    $ createdb -O puppetdb puppetdb
    $ exit

Ensure you can log in by running:

    $ psql -h localhost puppetdb puppetdb

To configure PuppetDB to use this database, put the following in the `[database]` section:

    classname = org.postgresql.Driver
    subprotocol = postgresql
    subname = //<HOST>:<PORT>/<DATABASE>
    username = <USERNAME>
    password = <PASSWORD>

Replace `<HOST>` with the DB server's hostname. Replace `<PORT>` with the port on which PostgreSQL is listening. Replace `<DATABASE>` with the name of the database you've created for use with PuppetDB.

It's possible to use SSL to protect connections to the database. The [PostgreSQL JDBC docs](http://jdbc.postgresql.org/documentation/head/ssl.html) explain how to do this. Be sure to add `?ssl=true` to the `subname` setting:

    subname = //<host>:<port>/<database>?ssl=true


### `gc-interval`

This controls how often, in minutes, to compact the database. The compaction process reclaims space and deletes unnecessary rows. If not supplied, the default is every 60 minutes.

### `node-ttl-days`

This sets the number of days with no activity (no new catalogs, facts, etc) before a node will be auto-deactivated. Nodes will be checked for staleness every `gc-interval` minutes. Manual deactivation will continue to work as always.

If unset, auto-deactivation of nodes is disabled.

### `log-slow-statements`

This sets the number of seconds before an SQL query is considered "slow." Slow SQL queries are logged as warnings, to assist in debugging and tuning. Note PuppetDB does not interrupt slow queries; it simply reports them after they complete.
  
The default value is 10 seconds. A value of 0 will disable logging of slow queries.


### `classname`

This sets the JDBC class to use. Set this to:

* `org.hsqldb.jdbcDriver` when using the embedded database
* `org.postgresql.Driver` when using PostgreSQL

### `subprotocol`

Set this to:

* `hsqldb` when using the embedded database
* `postgresql` when using PostgreSQL

### `subname`

This describes where to find the database. Set this to:

* `file:</PATH/TO/DB>;hsqldb.tx=mvcc;sql.syntax_pgs=true` when using the embedded database, replacing `</PATH/TO/DB>` with a local filesystem path
* `//<HOST>:<PORT>/<DATABASE>` when using PostgreSQL, replacing `<HOST>` with the DB server's hostname, `<PORT>` with the port on which PostgreSQL is listening, and `<DATABASE>` with the name of the database
    * Append `?ssl=true` to this if your PostgreSQL server is using SSL.

### `username`

This is the username to use when connecting. Only used with PostgreSQL.

### `password`

This is the password to use when connecting. Only used with PostgreSQL.



`[command-processing]` Settings
-----

The `[command-processing]` section configures the command-processing subsystem.

Every change to PuppetDB's data stores arrives via **commands** that are inserted into a message queue (MQ). Command processor threads pull items off of that queue, persisting those changes.

### `threads`

This defines how many command processing threads to use. Each thread can process a single command at a time. [The number of threads can be tuned based on what you see in the performance dashboard.][dashboard]
  
This setting defaults to half the number of cores in your system.

`[jetty]` (HTTP) Settings
-----

The `[jetty]` section configures HTTP for PuppetDB.

### `host`

This sets the hostname to listen on for _unencrypted_ HTTP traffic. If not supplied, we bind to `localhost`, which will reject connections from anywhere but the PuppetDB server itself. To listen on all available interfaces, use `0.0.0.0`.

> **Note:** Unencrypted HTTP is the only way to view the [performance dashboard][dashboard], since PuppetDB uses host verification for SSL. However, it can also be used to make any call to PuppetDB's API, including inserting exported resources and retrieving arbitrary data about your Puppet-managed nodes. **If you enable cleartext HTTP, you MUST configure your firewall to protect unverified access to PuppetDB.**

### `port`

This sets what port to use for _unencrypted_ HTTP traffic. If not supplied, we won't listen for unencrypted traffic at all.

### `ssl-host`

This sets the hostname to listen on for _encrypted_ HTTPS traffic. If not supplied, we bind to `localhost`. To listen on all available interfaces, use `0.0.0.0`.

### `ssl-port`

This sets the port to use for _encrypted_ HTTPS traffic. If not supplied, we won't listen for encrypted traffic at all.

### `keystore`

This sets the path to a Java keystore file containing the key and certificate to be used for HTTPS.

### `key-password`

This sets the passphrase to use for unlocking the keystore file.

### `truststore`

This describes the path to a Java keystore file containing the CA certificate(s) for your puppet infrastructure.

### `trust-password`

This sets the passphrase to use for unlocking the truststore file.

### `certificate-whitelist`

Optional. This describes the path to a file that contains a list of certificate names, one per line.  Incoming HTTPS requests will have their certificates validated against this list of names and only those with an _exact_ matching entry will be allowed through. (For a puppet master, this compares against the value of the `certname` setting, rather than the `dns_alt_names` setting.)

If not supplied, PuppetDB uses standard HTTPS without any additional authorization. All HTTPS clients must still supply valid, verifiable SSL client certificates.

`[repl]` Settings
-----

The `[repl]` section configures remote runtime modification. 

Enabling a remote [REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) allows you to manipulate the behavior of PuppetDB at runtime. This should only be done for debugging purposes, and is thus disabled by default. An example configuration stanza:

    [repl]
    enabled = true
    type = nrepl
    port = 8081

### `enabled`

Set to `true` to enable the REPL. Defaults to false.

### `type`

Either `nrepl` or `swank`.

The _nrepl_ repl type opens up a socket you can connect to via telnet. 

The _swank_ type allows emacs' clojure-mode to connect directly to a running PuppetDB instance by using `M-x slime-connect`. This is much more user-friendly than telnet.

### `port`

The port to use for the REPL.
