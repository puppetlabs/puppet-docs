---
title: "PuppetDB 0.9 » Configuration"
layout: default
canonical: "/puppetdb/latest/configure.html"
---

Configuring the Java Heap Size
-----

Unlike most of PuppetDB's settings, the JVM heap size is specified on the command line. If you installed PuppetDB from packages or used the `rake install` installation method, you can change this setting in the init script's configuration file. 

The location of this file varies by platform and by the package used to install:

* Redhat-like, with open source package: `/etc/sysconfig/puppetdb`
* Redhat-like, with PE package: `/etc/sysconfig/pe-puppetdb`
* Debian/Ubuntu, with open source package: `/etc/default/puppetdb`
* Debian/Ubuntu, with PE package: `/etc/default/pe-puppetb`

To change the heap size, edit this file and change the `JAVA_ARGS` variable. This setting contains command line flags for the Java executable, and you should use the `-Xmx` flag to specify a max size. For example, to cap PuppetDB at 192MB of memory:

    JAVA_ARGS="-Xmx192m"

To use 1GB of memory:

    JAVA_ARGS="-Xmx1g"


The PuppetDB Configuration File(s)
-----

PuppetDB is configured using an INI-style config file with several `[sections]`. This is very similar to the format used by Puppet. 

**Whenever you change settings in the configuration file, you must restart PuppetDB before the changes will take effect.**

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

You can specify either a single configuration file or a directory of .ini files. If you specify a directory (_conf.d_ style), PuppetDB will merge the .ini files in alphabetical order.

If you've installed puppetdb from a package, the default is to use the _conf.d_ style, directory-based approach.  The default config directory is `/etc/puppetdb/conf.d` (or `/etc/puppetlabs/puppetdb/conf.d` for Puppet Enterprise installations).  If you're running from source you may use the "-c" command-line argument to specify your config file or directory.

The available configuration **sections** and **settings** are as follows:

### `[global]`


The `[global]` section is used to configure application-wide behavior.

`vardir`

: The parent directory for the MQ's data directory. Also, if a database isn't specified, the default database's files will be stored in `<vardir>/db`. The directory must exist and be writable by the PuppetDB user in order for the application to run.

`logging-config`

: Full path to a [log4j.properties](http://logging.apache.org/log4j/1.2/manual.html) file. Covering all the options available for configuring log4j is outside the scope of this document; see the aforementioned link for exhaustive information.

  If this setting isn't provided, we default to logging at INFO level to standard out.

  If you installed from packages, PuppetDB will use the log4j.properties file in the `/etc/puppetdb/` or `/etc/puppetlabs/puppetdb` directory. Otherwise, you can find an example file in the `ext` directory of the source.

  You can edit the logging configuration file while PuppetDB is running, and it will automatically react to changes after a few seconds.

### `[database]`

The `[database]` section configures PuppetDB's database settings.

We currently support two configurations: a built-in HSQLDB database, and PostgreSQL. If no database information is supplied, an HSQLDB database at `<vardir>/db` will be used.

#### Universal DB Settings

`gc-interval`

: How often, in minutes, to compact the database. The compaction process reclaims space, and deletes unnecessary rows. If not supplied, the default is every 60 minutes.

#### Embedded DB Settings

`classname`, `subprotocol`, and `subname`

: These three settings _must_ be configured as follows:

      classname = org.hsqldb.jdbcDriver
      subprotocol = hsqldb
      subname = file:/path/to/db;hsqldb.tx=mvcc;sql.syntax_pgs=true
  
  Replace `/path/to/db` with a filesystem location in which you'd like to persist the database.

#### PostgreSQL DB Settings

Before using the PostgreSQL backend, you must set up a PostgreSQL server, ensure that it will accept incoming connections, create a user for PuppetDB to use when connecting, and create a database for PuppetDB. Configuring PostgreSQL is beyond the scope of this manual, but if you are logged in as root on a running Postgres server, you can create a user and db as follows:

    $ sudo -u postgres sh
    $ createuser -DRSP puppetdb
    $ createdb -O puppetdb puppetdb
    $ exit

Ensure you can log in by running:

    $ psql -h localhost puppetdb puppetdb

`classname`, `subprotocol`, and `subname`

: These three settings _must_ be configured as follows:

      classname = org.postgresql.Driver
      subprotocol = postgresql
      subname = //<host>:<port>/<database>

  Replace `<host>` with the DB server's hostname. Replace `<port>` with the port on which PostgreSQL is listening. Replace `<database>` with the name of the database you've created for use with PuppetDB.
  
  It's possible to use SSL to protect connections to the database. The [PostgreSQL JDBC docs](http://jdbc.postgresql.org/documentation/head/ssl.html) indicate how to do this. Be sure to add `ssl=true` to the `subname` parameter.

`username`

: The username to use when connecting.

`password`

: The password to use when connecting.



### `[command-processing]`

The `[command-processing]` section configures the command-processing subsystem.

Every change to PuppetDB's data stores comes in via commands that are inserted into a message queue (MQ). Command processor threads pull items off of that queue, persisting those changes.

`threads`

: How many command processing threads to use. Each thread can process a single command at a time. [The number of threads can be tuned based on what you see in the performance console.](./maintain_and_tune.html#monitor-the-performance-console)
  
  This setting defaults to half the number of cores in your system.

### `[jetty]` (HTTP)

The `[jetty]` section configures HTTP for PuppetDB.

`host`

: The hostname to listen on for _unencrypted_ HTTP traffic. If not supplied, we bind to localhost.

`port`

: What port to use for _unencrypted_ HTTP traffic. If not supplied, we won't listen for unencrypted traffic at all.

`ssl-host`

: The hostname to listen on for HTTPS. If not supplied, we bind to localhost.

`ssl-port`

: What port to use for _encrypted_ HTTPS traffic. If not supplied, we won't listen for encrypted traffic at all.

`keystore`

: The path to a Java keystore file containing the key and certificate we should use for HTTPS.

`key-password`

: Passphrase to use to unlock the keystore file.

`truststore`

: The path to a Java keystore file containing the CA certificate(s) for your puppet infrastructure.

`trust-password`

: Passphrase to use to unlock the truststore file.

`certificate-whitelist`

: Optional. Path to a file that contains a list of hostnames, one per line.  Incoming HTTPS requests will have their certificates validated against this list of hostnames, and only those with an _exact_, matching entry will be allowed through.

  If not supplied, we'll perform standard HTTPS without any additional authorization. We'll still make sure that all HTTPS clients supply valid, verifiable SSL client certificates.

### `[repl]` (Remote Runtime Modification)

The `[repl]` section configures remote runtime modification. 

Enabling a remote [REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) allows you to manipulate the behavior of PuppetDB at runtime. This should only be done for debugging purposes, and is thus disabled by default. An example configuration stanza:

    [repl]
    enabled = true
    type = nrepl
    port = 8081

`enabled`

: Set to `true` to enable the REPL. Defaults to false.

`type`

: Either `nrepl` or `swank`.

  The _nrepl_ repl type opens up a socket you can connect to via telnet. 
  
  The _swank_ type allows emacs' clojure-mode to connect directly to a running PuppetDB instance by using `M-x slime-connect`. This is much more user-friendly than telnet.

`port`

: The port to use for the REPL.
