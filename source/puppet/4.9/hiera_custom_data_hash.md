---
title: "Hiera: Implementing a data_hash backend"
---

[struct]: ./lang_data_abstract.html#struct
[lookup_options]: ./hiera_merging.html#configuring-merge-behavior-in-hiera-data
[interpolate]: todo
[hiera.yaml]: todo
[ruby functions]: todo
[puppet language functions]: todo
[chained_call]: todo
[yaml_data]: todo
[json_data]: todo
[hocon_data]: todo

A `data_hash` backend function reads an entire data source at once and returns its contents as a hash.

## Examples

The built-in YAML/JSON/HOCON backends are all `data_hash` functions. You can view their source on GitHub here:

* [`yaml_data.rb`][yaml_data]
* [`json_data.rb`][json_data]
* [`hocon_data.rb`][hocon_data]

## Arguments and return type

Hiera calls a `data_hash` function with two arguments:

1. A hash of options. (More on this below.)
2. A `Puppet::LookupContext` object. (More on this below.)

The function must either call the context object's `not_found` method, or return a hash of lookup keys and their associated values. That hash's keys must match the `Puppet::LookupKey` type, and its values must match the `Puppet::LookupValue` type. (The hash can also be empty.)

Like other Hiera data sources, the returned hash can use the special `lookup_options` key to configure merge behavior for other keys. See [Configuring merge behavior in Hiera data][lookup_options] for more info.

Values in the returned hash can include [Hiera interpolation tokens][interpolate] like `%{variable}` or `%{lookup('key')}`; Hiera will interpolate values as needed. This is a significant difference between `data_hash` and the other two backend types; `lookup_key` and `data_dig` have to explicitly handle interpolation.

### The `Puppet::LookupKey` and `Puppet::LookupValue` types

To simplify backend function signatures, you can use two extra data type aliases: `Puppet::LookupKey`, and `Puppet::LookupValue`. These are only available to backend functions called by Hiera; normal functions and Puppet code can't use them.

`Puppet::LookupKey` matches any legal Hiera lookup key. It's equivalent to:

``` puppet
Variant[String, Numeric]
```

`Puppet::LookupValue` matches any value Hiera could return for a lookup. It's equivalent to:

``` puppet
Variant[
  Scalar,
  Undef,
  Sensitive,
  Type,
  Hash[Puppet::LookupKey, Puppet::LookupValue],
  Array[Puppet::LookupValue]
]
```

### The options hash

Hierarchy levels are configured in [hiera.yaml][]. When calling a backend function, Hiera passes a modified version of that configuration as a hash.

The options hash contains the following keys:

* `path` --- The absolute path to a file on disk. Only present if the user set one of the `path`, `paths`, `glob`, or `globs` settings. Hiera ensures the file exists before passing it to the function.
* `uri` --- A URI that your function can use to locate a data source. Only present if the user set `uri` or `uris`. Hiera doesn't verify the URI before passing it to the function.
* Every key from the hierarchy level's `options` setting. In your documentation, make sure to list any options your backend requires or accepts. Note that the `path` and `uri` keys are reserved.

For example: this hierarchy level in hiera.yaml...

``` yaml
  - name: "Secret data: per-node, per-datacenter, common"
    lookup_key: eyaml_lookup_key # eyaml backend
    datadir: data
    paths:
      - "secrets/nodes/%{trusted.certname}.eyaml"
      - "secrets/location/%{facts.whereami}.eyaml"
      - "common.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
```

...would result in several different options hashes (depending on the current node's facts, whether the files exist, etc.), but they would all resemble the following:

``` ruby
{
  'path' => '/etc/puppetlabs/code/environments/production/data/secrets/nodes/web01.example.com.eyaml',
  'pkcs7_private_key' => '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem',
  'pkcs7_public_key' => '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem'
}
```

In your function's signature, you can validate the options hash by using [the Struct data type][struct] to restrict its contents. In particular, note that you can disable all of the `path(s)` and `glob(s)` settings for your backend by disallowing the `path` key in the options hash.


## Calling conventions for `data_hash` functions

Since `data_hash` functions return an entire data source at once, Hiera generally calls them only once per data source.

However, a given hierarchy level can refer to multiple data sources with the `paths`, `uris`, and `glob(s)` settings. Hiera handles this as follows:

* If the `path(s)` or `glob(s)` settings are used, Hiera figures out which files actually exist and calls the function once for each. If no files were found, the function won't be called at all.
* If the `uri(s)` settings are used, Hiera calls the function once per URI.
* If none of those settings are used, Hiera calls the function once.

Hiera might call a function again for a given data source, if the inputs change --- for example, if hiera.yaml interpolates a local variable in a file path, Hiera would have to call the function again for scopes where that variable has a different value. (This has a significant performance impact, and is why we tell users to only interpolate `facts`, `trusted`, and `server_facts` in the hierarchy.)

## The `Puppet::LookupContext` object

To support caching and other needs, Hiera provides backends a special `Puppet::LookupContext` object, which has several methods you can call for various effects.

* In [Ruby functions][], this is a normal Ruby object of class `Puppet::LookupContext`, and you can call methods with standard Ruby syntax (like `context.not_found`).
* In [Puppet language functions][], the context object appears as a special data type (Object) that has methods attached. Right now, there isn't anything else in the Puppet language that acts like this.

    You can call its methods using Puppet's [chained function call syntax][chained_call] with the method name instead of a normal function --- for example, `$context.not_found`. For methods that take a block, use Puppet's lambda syntax (parameters outside block) instead of Ruby's block syntax (parameters inside block).

The following methods are available:

* [`not_found()`][method_not], for bailing out of a lookup.
* [`explain() || { 'message' }`][method_explain], for helpful debug messages.
* [`cache(key, value)`][method_cache], for caching information between function runs.
* [`cache_all(hash)`][method_cache_all], for caching several things at once.
* [`cache_has_key(key)`][method_haskey], for checking the cache.
* [`cached_value(key)`][method_cached], for retrieving cached values.
* [`all_cached()`][method_allcached], for dumping the whole cache.
* [`environment_name()`][method_env], to find out which environment's hiera.yaml this is.
* [`module_name()`][method_module], to find out which module's hiera.yaml this is.
* [`interpolate(value)`][method_interpolate], for handing Hiera interpolation tokens in values.


### `not_found()`

[method_not]: #notfound

Tells Hiera to move on to the next data source. Call this method when your function can't find a value for a given lookup. **This method does not return.**

For `data_hash` backends, use this when the requested data source doesn't exist. (If it exists and is empty, return an empty hash.) Missing data sources aren't an issue when using `path(s)`/`glob(s)`, but are important for backends that locate their own data sources.

For `lookup_key` and `data_dig` backends, use this when a requested key isn't present in the data source or the data source doesn't exist. Don't return `undef`/`nil` for missing keys, since that's a legal value that can be set in data.

### `explain() || { 'message' }`

[method_explain]: #explain---message-

> **Note:** The header above uses the Puppet lambda syntax. To call this method in Ruby, you would use `explain() { 'message' }`. In either case, the provided block must take zero arguments.

Adds a message, which appears in debug messages or when using `puppet lookup --explain`.

This is meant for complex lookups where a function tries several different things before arriving at the value. Note that the built-in backends don't use the `explain` method, and they still have relatively verbose explanations; this is for when you need to go above and beyond that.

Feel free to not worry about performance when constructing your message; Hiera never executes the explain block unless debugging is enabled.

### `cache(key, value)`

[method_cache]: #cachekey-value

Caches a value, in a per-data-source private cache; also returns the cached value.

On future lookups in this data source, you can retrive values with `cached_value(key)`. Cached values are immutable, but you can replace the value for an existing key. Cache keys can be anything valid as a key for a Ruby hash. (Notably, this means you can use `nil` as a key.)

For example, on its first invocation for a given YAML file, the built-in `eyaml_lookup_key` backend reads the whole file and caches it, and then decrypts only the specific value that was requested. On subsequent lookups into that file, it gets the encrypted value from the cache instead of reading the file from disk again. It also caches decrypted values, so that it won't have to decrypt again if the same key is looked up repeatedly.

The cache is also useful for storing session keys or connection objects for backends that access a network service.

#### Cache lifetime and scope

Each `Puppet::LookupContext` cache only lasts for the duration of the current catalog compilation; a node can't access values cached for a previous node.

Hiera creates a separate cache for each *combination of inputs for a function call,* including inputs like `name` that are configured in hiera.yaml but not passed to the function. So not only does each hierarchy level have its own cache, but hierarchy levels that use multiple paths have a separate cache for each path.

If any inputs to a function change (for example, a path interpolates a local variable whose value changes between lookups), Hiera uses a fresh cache.


### `cache_all(hash)`

[method_cache_all]: #cacheallhash

Caches all the key/value pairs from a given hash; returns `undef` (in Puppet) or `nil` (in Ruby).

### `cache_has_key(key)`

[method_haskey]: #cachehaskeykey

Checks whether the cache has a value for a given key yet. Returns `true` or `false`.

### `cached_value(key)`

[method_cached]: #cachedvaluekey

Returns a previously cached value from the per-data-source private cache. See [`cache(key, value)`][method_cache] above.

### `cached_entries()`

[method_allcached]: #allcached

TODO important! Check name of method with Henrik/Thomas! This was listed as `all_cached()` in the predocs.

Returns everything in the per-data-source cache, as an iterable object. Note that this iterable object isn't a hash; if you want a hash, you can use `Hash($context.all_cached())` (in the Puppet language) or `Hash[context.all_cached()]` (in Ruby).

### `environment_name()`

[method_env]: #environmentname

Returns the name of the environment whose hiera.yaml called the function. Returns `undef` (in Puppet) or `nil` (in Ruby) if the function was called by the global or module layer.

### `module_name()`

[method_module]: #modulename

Returns the name of the module whose hiera.yaml called the function. Returns `undef` (in Puppet) or `nil` (in Ruby) if the function was called by the global or environment layer.

### `interpolate(value)`

[method_interpolate]: #interpolatevalue

TODO does this take any kind of value, or just strings? Is it recursive, if it takes hashes etc.?

Returns the provided value, but with any Hiera interpolation tokens (like `%{variable}` or `%{lookup('key')}`) replaced by their value. This lets you opt-in to allowing Hiera-style interpolation in your backend's data sources.

In `data_hash` backends, interpolation is automatically supported and you don't need to call this method.

In `lookup_key` and `data_dig` backends, you **must** call this method if you want to support interpolation; if you don't, Hiera assumes you have your own thing going on.


