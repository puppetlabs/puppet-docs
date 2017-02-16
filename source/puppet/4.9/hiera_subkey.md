---
title: "Hiera: Accessing hash and array elements (key.subkey syntax)"
---

[hashes]: todo
[arrays]: todo
[interpolation]: todo
[lookup_function]: todo
[lookup_command]: todo
[interpolation_functions]: todo


In Puppet and Hiera, you often need to work with structured data in [hashes][] and [arrays][].

In the Puppet language, you can access hash and array members with square brackets, like `$facts['networking']['fqdn']`. Hiera doesn't use square brackets; instead, it uses a key.subkey notation, like `facts.networking.fqdn`.

## Key.subkey syntax

To access a single member of an array or hash, use the name of the value followed by a dot (`.`) and a subkey.

* If the value is an array, the subkey must be an integer, like `users.8`.
* If the value is a hash, the subkey must be the name of a key in that hash, like `facts.os`.

To access values in nested data structures, you can chain subkeys together. For example, since the value of `facts.system_uptime` is a hash, you can access its `hours` key with `facts.system_uptime.hours`.

Unlike the Puppet language's square bracket notation, Hiera's dotted notation doesn't support using arbitrary expressions as subkeys; only literal keys are valid.

## Where can you access hash and array elements?

You can access hash and array elements when:

* [Interpolating variables][interpolation] into hiera.yaml or a data file. Many of the most commonly used variables, like `facts` and `trusted`, are deeply nested data structures.
* Using [the `lookup` function][lookup_function] or [the `puppet lookup` command][lookup_command]. If the value of `lookup('some_key')` would be a hash or array, you can look up a single member of it with `lookup('some_key.subkey')`.
* Using [interpolation functions that do Hiera lookups][interpolation_functions], like `lookup` and `alias`.
