---
layout: default
title: "Config Files: routes.yaml"
canonical: "/puppet/latest/reference/config_file_routes.html"
---

[route_file]: ./configuration.html#routefile

The `routes.yaml` file overrides configuration settings involving indirector termini, and allows termini to be set in greater detail than `puppet.conf` allows.

## Context

The `routes.yaml` file works around config limitations in Puppet's internals and makes it possible to use certain extensions to Puppet, most notably PuppetDB. Most users shouldn't freely edit the file, and should only make changes that are explicitly recommended by the setup instructions for the extension they are trying to install.

## Location

The `routes.yaml` file is located at `$confdir/routes.yaml` by default. Its location is configurable with the [`route_file` setting][route_file].

The location of the `confdir` varies; it depends on the OS, Puppet distribution, and user account. [See the confdir documentation for details.][confdir]

[confdir]: ./dirs_confdir.html

## Example

    ---
    master:
      facts:
        terminus: puppetdb
        cache: yaml

## Format

The `routes.yaml` file should be a YAML hash.

* Each top level key should be the name of a run mode (`master`, `agent`, or `user`), and its value should be another hash.
    * Each key of these second-level hashes should be the name of an indirection, and its value should be another hash.
        * The only keys allowed in these third-level hashes are `terminus` and `cache`. The value of each of these keys should be the name of a valid terminus for the indirection named above.

