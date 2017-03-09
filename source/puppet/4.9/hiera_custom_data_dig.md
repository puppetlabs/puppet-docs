---
title: "Hiera: Implementing a data_dig backend"
---

[lookup_key]: ./hiera_custom_lookup_key.html
[subkey]: ./hiera_subkey.html
[lookup_options]: ./hiera_merging.html#configuring-merge-behavior-in-hiera-data
[interpolate]: ./hiera_interpolation.html

> **Note:** This page goes directly into the details of implementing one type of backend. For an intro to the custom backends system, see [How custom backends work](./hiera_custom_backends.html).

A `data_dig` backend function is similar to [a `lookup_key` function][lookup_key]. But instead of looking up a single key, it looks up a single _sequence of keys and subkeys._

Hiera lets you look up individual members of hash and array values using [key.subkey notation][subkey]. In cases where:

* Lookups are relatively expensive.
* The data source knows how to extract elements from hash and array values.
* Users are likely to pass key.subkey requests to the `lookup` function to access subsets of large data structures.

...then it's possible to get better performance by writing a `data_dig` backend instead of a `lookup_key` backend.

## Examples

We don't currently have any realistic examples of `data_dig` backends. Let us know if you see any in the wild.

## Arguments and return type

Hiera calls a `data_dig` function with three arguments:

1. An array of lookup key segments.

    The array of key segments is made by splitting the requested lookup key on the dot (`.`) subkey separator. For example, a lookup for `users.dbadmin.uid` would result in `['users', 'dbadmin', 'uid']`. Positive base-10 integer subkeys (for accessing array members) are converted to Integer objects, but other number-like subkeys remain as strings.
2. A hash of options. (More on this below.)
3. A `Puppet::LookupContext` object. (More on this below.)

The function must either call the context object's `not_found` method, or return a value for the requested sequence of key segments.

> **Example signatures:**
>
> Puppet language:
>
> ``` puppet
> function mymodule::hiera_backend(
>   Array[Variant[String, Numeric]] $segments,
>   Hash                            $options,
>   Puppet::LookupContext           $context,
> )
> ```
>
> Ruby:
>
> ``` ruby
> dispatch :hiera_backend do
>   param 'Array[Variant[String, Numeric]]', :segments
>   param 'Hash', :options
>   param 'Puppet::LookupContext', :context
> end
> ```

Like other Hiera data sources, a `data_dig` function can use the special `lookup_options` key to configure merge behavior for other keys. See [Configuring merge behavior in Hiera data][lookup_options] for more info.

If you want to support [Hiera interpolation tokens][interpolate] like `%{variable}` or `%{lookup('key')}` in your data, you must call `context.interpolate` on your values before returning them.

{% partial ./_hiera_options_hash.md %}

## Calling conventions for `data_dig` functions

Hiera generally calls `data_dig` functions _once per data source_ for every unique sequence of key segments.

Note that a given hierarchy level can refer to multiple data sources with the `paths`, `uris`, and `glob(s)` settings. Hiera handles each hierarchy level as follows:

* If the `path(s)` or `glob(s)` settings are used, Hiera figures out which files actually exist and calls the function once for each. If no files were found, the function won't be called at all.
* If the `uri(s)` settings are used, Hiera calls the function once per URI.
* If none of those settings are used, Hiera calls the function once.

Hiera tries to cache the value for a given sequence of key segments and use the cached value on subsequent lookups. However, it might call a function again for a given key and data source if the inputs change --- for example, if hiera.yaml interpolates a local variable in a file path, Hiera would have to call the function again for scopes where that variable has a different value. (This has a significant performance impact, and is why we tell users to only interpolate `facts`, `trusted`, and `server_facts` in the hierarchy.)

{% partial ./_hiera_context_object.md %}

