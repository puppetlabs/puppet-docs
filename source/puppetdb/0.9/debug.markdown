---
title: "PuppetDB 0.9 » Debugging"
layout: pe2experimental
nav: puppetdb0.9.html
---

### Connecting to a remote REPL

If you have configured your PuppetDB instance to start up a remote
REPL, you can connect to it and begin issuing low-level debugging
commands.

For example, let's say that you'd like to perform some emergency
database compaction, and you've got an _nrepl_ type REPL configured on
port 8082:

    $ telnet localhost 8082
    Connected to localhost.
    Escape character is '^]'.
    ;; Clojure 1.3.0
    user=> (+ 1 2 3)
    6

At this point, you're at an interactive terminal that allows you to
manipulate the running PuppetDB instance. This is really a
developer-oriented feature; you have to know both Clojure and the
PuppetDB codebase to make full use of the REPL.

To compact the database, you can just execute the function in the
PuppetDB codebase that performs garbage collection:

    user=> (use 'com.puppetlabs.puppetdb.cli.services)
    nil
    user=> (use 'com.puppetlabs.puppetdb.scf.storage)
    nil
    user=> (use 'clojure.java.jdbc)
    nil
    user=> (with-connection (:database configuration)
             (garbage-collect!))
    (0)

You can also manipulate the running PuppetDB instance by redefining
functions on-the-fly. Let's say that for debugging purposes, you'd
like to log every time a catalog is deleted. You can just redefine
the existing `delete-catalog!` function dynamically:

    user=> (ns com.puppetlabs.puppetdb.scf.storage)
    nil
    com.puppetlabs.puppetdb.scf.storage=>
    (def original-delete-catalog! delete-catalog!)
    #'com.puppetlabs.puppetdb.scf.storage/original-delete-catalog!
    com.puppetlabs.puppetdb.scf.storage=>
    (defn delete-catalog!
      [catalog-hash]
      (log/info (str "Deleting catalog " catalog-hash))
      (original-delete-catalog! catalog-hash))
    #'com.puppetlabs.puppetdb.scf.storage/delete-catalog!

Now any time that function is called, you'll see a message logged.

Note that any changes you make to the running system are transient;
they don't persist between restarts. As such, this is really meant to
be used as a development aid, or as a way of introspecting a running
system for troubleshooting purposes.

