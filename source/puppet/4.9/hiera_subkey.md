---
title: "Hiera: Accessing hash and array elements (key.subkey syntax)"
---

[hashes]: ./lang_data_hash.html
[arrays]: ./lang_data_array.html
[interpolation]: ./hiera_interpolation.html
[lookup_function]: ./hiera_use_function.html
[lookup_command]: ./hiera_use_cli.html
[interpolation_functions]: ./hiera_interpolation.html#using-interpolation-functions
[extensions]: ./ssl_attributes_extensions.html

In Puppet and Hiera, you often need to work with structured data in [hashes][] and [arrays][].

In the Puppet language, you can access hash and array members with square brackets, like `$facts['networking']['fqdn']`. Hiera doesn't use square brackets; instead, it uses a key.subkey notation, like `facts.networking.fqdn`.

## Key.subkey syntax

To access a single member of an array or hash, use the name of the value followed by a dot (`.`) and a subkey.

* If the value is an array, the subkey must be an integer, like `users.8`.
* If the value is a hash, the subkey must be the name of a key in that hash, like `facts.os`.

To access values in nested data structures, you can chain subkeys together. For example, since the value of `facts.system_uptime` is a hash, you can access its `hours` key with `facts.system_uptime.hours`.

Unlike the Puppet language's square bracket notation, Hiera's dotted notation doesn't support using arbitrary expressions as subkeys; only literal keys are valid.

### Quoting subkeys

It's possible for a hash to include literal dots in the text of a key. For example, the value of `$trusted['extensions']` is a hash containing any [certificate extensions][extensions] for a node, but some of its keys can raw OID strings like `'1.3.6.1.4.1.34380.1.2.1'`.

You can access those values in Hiera with key.subkey notation, but you must put quotes around the affected subkey. For example:

``` yaml
hierarchy:
  # ...
  - name: "Machine role (custom certificate extension)"
    path: "role/%{trusted.extensions.'1.3.6.1.4.1.34380.1.2.1'}.yaml"
  # ...
```

You can use either single or double quotes.

If the entire compound key is quoted (for example, as required by the `lookup` [interpolation function][interpolation_functions]), you must use the other kind of quote for the subkey, and you must also escape quotes (as needed by your data file format) to ensure that you don't prematurely terminate the whole string. For example:

``` yaml
aliased_key: "%{lookup('other_key.\"dotted.subkey\"')}"
# Or:
aliased_key: "%{lookup(\"other_key.'dotted.subkey'\")}"
```

## Where can you access hash and array elements?

You can access hash and array elements when:

* [Interpolating variables][interpolation] into hiera.yaml or a data file. Many of the most commonly used variables, like `facts` and `trusted`, are deeply nested data structures.
* Using [the `lookup` function][lookup_function] or [the `puppet lookup` command][lookup_command]. If the value of `lookup('some_key')` would be a hash or array, you can look up a single member of it with `lookup('some_key.subkey')`.
* Using [interpolation functions that do Hiera lookups][interpolation_functions], like `lookup` and `alias`.
