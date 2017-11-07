---
title: "Hiera: How custom backends work"
---


[custom_functions]: ./functions_basics.html
[ruby_functions]: ./functions_ruby_overview.html
[puppet_functions]: ./lang_write_functions_in_puppet.html
[hash]: ./hiera_custom_data_hash.html
[key]: ./hiera_custom_lookup_key.html
[dig]: ./hiera_custom_data_dig.html

You can extend Hiera to look up values in almost any kind of data store --- for example, a PostgreSQL database table, a custom web app, or a new kind of structured data file.

To teach Hiera how to talk to other data sources, you'll need to write a custom backend.

## Hiera backends are Puppet functions

In this version of Hiera, a backend is simply a [custom Puppet function][custom_functions] that accepts a particular set of arguments and whose return value obeys a particular format. The function can do whatever is necessary to locate its data.

A backend function can use [the modern Ruby functions API][ruby_functions] or [the Puppet language][puppet_functions]. (They can't use the legacy Ruby functions API.) Among other things, this means you can use different versions of a Hiera backend in different environments, and you can distribute Hiera backends in Puppet modules.

This is a simpler interface than in previous versions of Hiera, where custom backends were globally-loaded Ruby classes that had to define particular methods.

## Three kinds of backends

Different kinds of data have different performance characteristics. To make sure Hiera performs well with every kind of data source, it supports three kinds of backends:

Backend type         | Purpose
---------------------|--------
[`data_hash`][hash]  | For data sources where it's inexpensive to read the entire contents at once, like simple files on disk.
[`lookup_key`][key]  | For data sources where looking up a key is relatively expensive, like an HTTPS API.
[`data_dig`][dig]    | For data sources that can access arbitrary elements of hash or array values _before_ passing anything back to Hiera, like a database.

To illustrate: The built-in YAML/JSON/HOCON backends are all `data_hash` functions, because each data source is a single file, which can be cheaply deserialized. But the hiera-eyaml backend is a `lookup_key` function, because decryption is relatively expensive; since a given node only uses a subset of the available secrets, it makes sense to only decrypt on-demand.

