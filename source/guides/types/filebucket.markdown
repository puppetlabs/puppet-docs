---
layout: default
title: filebucket
---

filebucket
==========

Defines a repository for backing up files.

* * *

Background
----------

If no filebucket is defined,
then files will be backed up in their current directory, but the
filebucket can be either a host- or site-global repository for
backing up. It stores files and returns the MD5 sum, which can
later be used to retrieve the file if restoration becomes
necessary. A filebucket does not do any work itself; instead, it
can be specified as the value of *backup* in a **file** object.

Currently, filebuckets are only useful for manual retrieval of
accidentally removed files (e.g., you look in the log for the md5
sum and retrieve the file with that sum from the filebucket), but
when transactions are fully supported filebuckets will be used to
undo transactions.

You will normally want to define a single filebucket for your whole
network and then use that as the default backup location:

    # Define the bucket
    filebucket { main: server => puppet }
    
    # Specify it as the default target
    File { backup => main }
{:puppet}

Puppetmaster servers create a filebucket by default, so this will
work in a default configuration.

{GENERIC}

Parameters
----------

### `name`

The name of the filebucket.

INFO: This is the `namevar` for this resource type.

### `path`

The path to the local filebucket. If this is unset, then the bucket
is remote. The parameter `server` must can be specified to set the
remote server.

### `port`

The port on which the remote server is listening. Defaults to the
normal Puppet port, `8140`.

### `server`

The server providing the remote filebucket. If this is not
specified then `path` is checked. If it is set, then the bucket is
local. Otherwise the puppetmaster server specified in the config or
at the commandline is used.
