---
title: "Hiera: Implementing a lookup_key backend"
---

[eyaml_lookup_key]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/eyaml_lookup_key.rb
[lookup_options]: ./hiera_merging.html#configuring-merge-behavior-in-hiera-data
[interpolate]: ./hiera_interpolation.html

> **Note:** This page goes directly into the details of implementing one type of backend. For an intro to the custom backends system, see [How custom backends work](./hiera_custom_backends.html).

A `lookup_key` backend function looks up a single key and returns its value.

## Examples

The built-in hiera-eyaml backend is a `lookup_key` function. You can view its source on GitHub:

* [`eyaml_lookup_key.rb`][eyaml_lookup_key]

## Arguments and return type

Hiera calls a `lookup_key` function with three arguments:

1. A key to look up.
2. A hash of options. (More on this below.)
3. A `Puppet::LookupContext` object. (More on this below.)

The function must either call the context object's `not_found` method, or return a value for the requested key.

> **Example signatures:**
>
> Puppet language:
>
> ``` puppet
> function mymodule::hiera_backend(
>   Variant[String, Numeric] $key,
>   Hash                     $options,
>   Puppet::LookupContext    $context,
> )
> ```
>
> Ruby:
>
> ``` ruby
> dispatch :hiera_backend do
>   param 'Variant[String, Numeric]', :key
>   param 'Hash', :options
>   param 'Puppet::LookupContext', :context
> end
> ```

Like other Hiera data sources, a `lookup_key` function can use the special `lookup_options` key to configure merge behavior for other keys. See [Configuring merge behavior in Hiera data][lookup_options] for more info.

If you want to support [Hiera interpolation tokens][interpolate] like `%{variable}` or `%{lookup('key')}` in your data, you must call `context.interpolate` on your values before returning them.

{% partial ./_hiera_options_hash.md %}

## Calling conventions for `lookup_key` functions

Hiera generally calls `lookup_key` functions _once per data source_ for every unique key lookup.

Note that a given hierarchy level can refer to multiple data sources with the `paths`, `uris`, and `glob(s)` settings. Hiera handles each hierarchy level as follows:

* If the `path(s)` or `glob(s)` settings are used, Hiera figures out which files actually exist and calls the function once for each. If no files were found, the function won't be called at all.
* If the `uri(s)` settings are used, Hiera calls the function once per URI.
* If none of those settings are used, Hiera calls the function once.

Hiera tries to cache the value for a given key and use the cached value on subsequent lookups. However, it might call a function again for a given key and data source if the inputs change --- for example, if hiera.yaml interpolates a local variable in a file path, Hiera would have to call the function again for scopes where that variable has a different value. (This has a significant performance impact, and is why we tell users to only interpolate `facts`, `trusted`, and `server_facts` in the hierarchy.)

{% partial ./_hiera_context_object.md %}

