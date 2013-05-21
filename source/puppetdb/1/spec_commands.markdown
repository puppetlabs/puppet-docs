---
title: "PuppetDB 1 » Spec » Commands"
layout: default
canonical: "/puppetdb/latest/api/commands.html"
---


Commands are used to change PuppetDB's
model of a population. Commands are represented by `command objects`,
which have the following JSON wire format:

    {"command": "...",
     "version": 123,
     "payload": <json object>}

`command` is a string identifying the command.

`version` is a JSON integer describing what version of the given
command you're attempting to invoke.

`payload` must be a valid JSON string of any sort. It's up to an
individual handler function to determine how to interpret that object.

The entire command MUST be encoded as UTF-8.

## Command submission

Commands are submitted via HTTP to the `/commands/` URL and must
conform to the following rules:

* A `POST` is used
* There is a parameter, `payload`, that contains the entire command as
  outlined above.
* There is an `Accept` header that contains `application/json`.
* The POST body is url-encoded
* The content-type is `x-www-form-urlencoded`.

Optionally, there may be a parameter, `checksum`, that contains a SHA-1 hash of
the payload which will be used for verification.

When a command is successfully submitted, the submitter will
receive the following:

* A response code of 200
* A content-type of `application/json`
* A response body in the form of a JSON object, containing a single key 'uuid', whose
  value is a UUID corresponding to the submitted command. This can be used, for example, by
  clients to correlate submitted commands with server-side logs.

## Command Semantics

Commands are processed _asynchronously_. If PuppetDB returns a 200
when you submit a command, that only indicates that the command has
been _accepted_ for processing. There are no guarantees as to when
that command will be processed, nor that when it is processed it will
be successful.

Commands that fail processing will be stored in files in the "dead
letter office", located under the MQ data directory, in
`discarded/<command>`. These files contain the command and diagnostic
information that may be used to determine why the command failed to be
processed.

## List of Commands

### "replace catalog", version 1

The payload is expected to be a Puppet catalog conforming to the
[catalog wire format](./spec_catalog_wire_format.html).

### "replace facts", version 1

The payload is expected to be a set of Puppet facts conforming to the
[facts wire format](./spec_facts_wire_format.html).

## "deactivate node", version 1

The payload is expected to be the name of a node, which will be deactivated
effective as of the time the command is *processed*.
