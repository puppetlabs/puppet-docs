---
title: "Hiera: Implementing a data_hash backend"
---

[struct]: ./lang_data_abstract.html#struct
[lookup_options]: ./hiera_merging.html#configuring-merge-behavior-in-hiera-data
[interpolate]: ./hiera_interpolation.html
[hiera.yaml]: ./hiera_config_yaml_5.html
[yaml_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/yaml_data.rb
[json_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/json_data.rb
[hocon_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/hocon_data.rb

> **Note:** This page goes directly into the details of implementing one type of backend. For an intro to the custom backends system, see [How custom backends work](./hiera_custom_backends.html).

A `data_hash` backend function reads an entire data source at once and returns its contents as a hash.

## Examples

The built-in YAML/JSON/HOCON backends are all `data_hash` functions. You can view their source on GitHub:

* [`yaml_data.rb`][yaml_data]
* [`json_data.rb`][json_data]
* [`hocon_data.rb`][hocon_data]

## Arguments and return type

Hiera calls a `data_hash` function with two arguments:

1. A hash of options. (More on this below.)
2. A `Puppet::LookupContext` object. (More on this below.)

The function must either call the context object's `not_found` method, or return a hash of lookup keys and their associated values. (The hash can be empty.)

> **Example signatures:**
>
> Puppet language:
>
> ``` puppet
> function mymodule::hiera_backend(
>   Hash                  $options,
>   Puppet::LookupContext $context,
> )
> ```
>
> Ruby:
>
> ``` ruby
> dispatch :hiera_backend do
>   param 'Hash', :options
>   param 'Puppet::LookupContext', :context
> end
> ```


Like other Hiera data sources, the returned hash can use the special `lookup_options` key to configure merge behavior for other keys. See [Configuring merge behavior in Hiera data][lookup_options] for more info.

Values in the returned hash can include [Hiera interpolation tokens][interpolate] like `%{variable}` or `%{lookup('key')}`; Hiera interpolates values as needed. This is a significant difference between `data_hash` and the other two backend types; `lookup_key` and `data_dig` have to explicitly handle interpolation.

{% partial ./_hiera_options_hash.md %}

## Calling conventions for `data_hash` functions

Since `data_hash` functions return an entire data source at once, Hiera generally calls them only _once per data source._

However, a given hierarchy level can refer to multiple data sources with the `paths`, `uris`, and `glob(s)` settings. Hiera handles each hierarchy level as follows:

* If the `path(s)` or `glob(s)` settings are used, Hiera figures out which files actually exist and calls the function once for each. If no files were found, the function won't be called at all.
* If the `uri(s)` settings are used, Hiera calls the function once per URI.
* If none of those settings are used, Hiera calls the function once.

Hiera might call a function again for a given data source, if the inputs change --- for example, if hiera.yaml interpolates a local variable in a file path, Hiera would have to call the function again for scopes where that variable has a different value. (This has a significant performance impact, and is why we tell users to only interpolate `facts`, `trusted`, and `server_facts` in the hierarchy.)

{% partial ./_hiera_context_object.md %}

