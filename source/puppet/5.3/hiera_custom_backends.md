---
title: "Writing new data backends"
---

[yaml_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/yaml_data.rb
[json_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/json_data.rb
[hocon_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/hocon_data.rb
[merging]: ./hiera_merging.html
[interpolation]: ./lang_data_string.html#interpolation
[automatic]: ./hiera_automatic.htmlAccess#hash-and-array-elements-using-a-key.subkey-notation
[eyaml_lookup_key.rb]: https://github.com/puppetlabs/puppet/blob/master/lib/puppet/functions/eyaml_lookup_key.rb
[puppet_functions]: ./lang_write_functions_in_puppet.html
[ruby_functions]: ./functions_ruby_overview.html
[hiera.yaml]: ./hiera_config_yaml_5.html
[struct]: ./lang_data_abstract.html#struct
[functions]: ./lang_functions.html

You can extend Hiera to look up values in data stores, for example, a PostgreSQL database table, a custom web app, or a new kind of structured data file.

To teach Hiera how to talk to other data sources, write a custom backend.

> **Important**: Writing a custom backend is an advanced topic. Before proceeding, make sure you really need it. It is also worth asking the puppet-dev mailing list or Slack channel to see whether there is one you can re-use, rather than starting from scratch.

{:.concept}
## Custom backends overview

A backend is a custom Puppet function that accepts a particular set of arguments and whose return value obeys a particular format. The function can do whatever is necessary to locate its data.

A backend function uses the modern Ruby functions API or the Puppet language. This means you can use different versions of a Hiera backend in different environments, and you can distribute Hiera backends in Puppet modules.

Different types of data have different performance characteristics. To make sure Hiera performs well with every type of data source, it supports three types of backends: `data_hash`, `lookup_key` and `data_dig`.

### data_hash

For data sources where it’s inexpensive, performance-wise, to read the entire contents at once, like simple files on disk. We suggest using the `data_hash` backend type if:
* The cache is alive for the duration of one compilation
* The data is small
* The data can be retrieved all at once
* Most of the data gets used
* The data is static

For more information, please the see data_hash backends reference.

### lookup_key

For data sources where looking up a key is relatively expensive, performance-wise, like an HTTPS API. We suggest using the `lookup_key` backend type if:
* The data set is big, but only a small portion is used
* The result can vary during the compilation

The `hiera-eyaml` backend is a `lookup_key` function, because decryption tends to affect performance; as a given node uses only a subset of the available secrets, it makes sense to decrypt only on-demand.

For more information, please the see lookup_key backend reference.

### data_dig

For data sources that can access arbitrary elements of hash or array values before passing anything back to Hiera, like a database.

For more information, please the see data_dig backend reference.

Related topics: [custom Puppet function][puppet_functions], [the modern Ruby functions API][ruby_functions].

#### The `RichDataKey` and `RichData` types

To simplify backend function signatures, you can use two extra data type aliases: `RichDataKey`, and `RichData`. These are only available to backend functions called by Hiera; normal functions and Puppet code can not use them.

{:.reference}
## data_hash backends

A `data_hash` backend function reads an entire data source at once, and returns its contents as a hash.

The built-in YAML, JSON, and HOCON backends are all `data_hash` functions. You can view their source on GitHub:
* [`yaml_data.rb`][yaml_data]
* [`json_data.rb`][json_data]
* [`hocon_data.rb`][hocon_data]

### Arguments

Hiera calls a `data_hash` function with two arguments:

* A hash of options
	* The options hash will contain a  `path` when the entry in hiera.yaml is using `path`/`paths`,`glob`/`globs`, or `mapped_paths`, and the backend will receive one call per path to an existing file. When the entry in hiera.yaml is using `uri`/`uris`, the options hash will have a `uri` key, and the backend function is called once per given uri. When `uri`/`uris` are used, hiera does not perform an existence check. It is up to the function to type the options parameter as wanted.
* A `Puppet::LookupContext` object

### Return type

The function must either call the context object’s `not_found` method, or return a hash of lookup keys and their associated values. The hash can be empty.

Puppet language example signature:

```
function mymodule::hiera_backend(
  Hash                  $options,
  Puppet::LookupContext $context,
)
```

Ruby example signature:

```
dispatch :hiera_backend do
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
end
```

The returned hash can include the `lookup_options` key to configure merge behavior for other keys. See Configuring merge behavior in Hiera data for more information. Values in the returned hash can include Hiera interpolation tokens like `%{variable}` or `%{lookup('key')}`; Hiera interpolates values as needed. This is a significant difference between `data_hash` and the other two backend types; `lookup_key` and `data_dig` functions have to explicitly handle interpolation.

Related topics: [Configuring merge behavior in Hiera data][merging].

{:.reference}
## lookup_key backends

A `lookup_key` backend function looks up a single key and returns its value.
For example, the built-in `hiera_eyaml` backend is a `lookup_key` function. You can view its source on GitHub at [eyaml_lookup_key.rb][eyaml_lookup_key.rb].

### Arguments

Hiera calls a `lookup_key` function with three arguments:
1. A key to look up.
2. A hash of options.
3. A Puppet::LookupContext object.

### Return type

The function must either call the context object’s `not_found` method, or return a value for the requested key. It may return undef as a value.

Puppet language example signature:

```
function mymodule::hiera_backend(
  Variant[String, Numeric] $key,
  Hash                     $options,
  Puppet::LookupContext    $context,
)
```
Ruby example signature:

```
dispatch :hiera_backend do
  param 'Variant[String, Numeric]', :key
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
end
```

A `lookup_key` function can return a hash for the  the `lookup_options` key to configure merge behavior for other keys. See Configuring merge behavior in Hiera data for more information. To support Hiera interpolation tokens, for example, `%{variable}` or `%{lookup('key')}` in your data, call `context.interpolate` on your values before returning them.

Related topics: [interpolation][interpolation], [Hiera calling conventions for backend functions][puppet_functions].

{:.reference}
##  data_dig backend

A `data_dig` backend function is similar to a `lookup_key` function, but instead of looking up a single key, it looks up a single sequence of keys and subkeys.
Hiera lets you look up individual members of hash and array values using `key.subkey` notation. Use `data_dig` types in cases where:
* Lookups are relatively expensive.
* The data source knows how to extract elements from hash and array values.
* Users are likely to pass `key.subkey` requests to the `lookup` function to access subsets of large data structures.

### Arguments

Hiera calls a `data_dig` function with three arguments:

1. An array of lookup key segments, made by splitting the requested lookup key on the dot (`.`) subkey separator. For example, a lookup for `users.dbadmin.uid` results in `['users', 'dbadmin', 'uid']`. Positive base-10 integer subkeys (for accessing array members) are converted to Integer objects, but other number subkeys remain as strings.
2. A hash of options.
3. A `Puppet::LookupContext` object.

### Return type

The function must either call the context object’s `not_found` method, or return a value for the requested sequence of key segments. Note that returning undef (nil in Ruby) means that the key was found but that the value for that key was specified to be undef.
Puppet language example signature:

```
function mymodule::hiera_backend(
  Array[Variant[String, Numeric]] $segments,
  Hash                            $options,
  Puppet::LookupContext           $context,
)
```

Ruby example signature:

```
dispatch :hiera_backend do
  param 'Array[Variant[String, Numeric]]', :segments
  param 'Hash', :options
  param 'Puppet::LookupContext', :context
end
```
A `data_dig` function can return a hash for the  the `lookup_options` key to configure merge behavior for other keys. See Configuring merge behavior in Hiera data for more info.

To support Hiera interpolation tokens like `%{variable}` or `%{lookup('key')}` in your data, call `context.interpolate` on your values before returning them.

Related topics: [key.subkey notation][automatic], [Configuring merge behavior in Hiera data][merging].

{:.concept}
## Hiera calling conventions for backend functions

Hiera uses the following conventions when calling backend functions:

* Hiera calls `data_hash` once per data source.
* Hiera calls `lookup_key` functions once per data source for every unique key lookup.
* Hiera calls `data_dig` functions once per data source for every unique sequence of key segments.

However, a given hierarchy level can refer to multiple data sources with the `path`, `uri`, and `glob` settings. Hiera handles each hierarchy level as follows:

* If the `path` or `glob` settings are used, Hiera determines which files exist and calls the function once for each. If no files were found, the function will not be called.
* If the `uri` settings are used, Hiera calls the function once per URI.
* If none of those settings are used, Hiera calls the function once.

Hiera can call a function again for a given data source, if the inputs change. For example, if `hiera.yaml` interpolates a local variable in a file path, Hiera calls the function again for scopes where that variable has a different value. This has a significant performance impact, and so you should  interpolate only facts, trusted facts, and server facts in the hierarchy.

{:.concept}
## The options hash

Hierarchy levels are configured in the `hiera.yaml` file. When calling a backend function, Hiera passes a modified version of that configuration as a hash.

The options hash may contain (depending on whether `path`/`glob`/`uri`/`mapped_paths` have been set) the following keys:
* `path` - The absolute path to a file on disk. It is present only if `path`, `paths`, `glob`, `globs`, or `mapped_paths` is present in the hierarchy. Hiera will never call the function unless the file is present.
* `uri` - A uri that your function can use to locate a data source. It is present only if `uri` or `uris` is present in the hierarchy. Hiera does not verify the URI before passing it to the function.
* Every key from the hierarchy level’s `options` setting. List any options your backend requires or accepts. The `path` and `uri` keys are reserved.

> Note: If your backend uses data files, use the context object’s `cached_file_data` method to read them.

For example, the following hierarchy level in `hiera.yaml` results in several different options hashes, depending on such things as the current node’s facts and whether the files exist:

```
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

The various hashes  would all be similar to this:

```
{
  'path' => '/etc/puppetlabs/code/environments/production/data/secrets/nodes/web01.example.com.eyaml',
  'pkcs7_private_key' => '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem',
  'pkcs7_public_key' => '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem'
}
```

In your function’s signature, you can validate the options hash by using the Struct data type to restrict its contents. In particular, note you can disable all of the `path` and `glob` settings for your backend by disallowing the `path` key in the options hash.

Related topics: [Configuring merge behavior in Hiera data][merging], [Hiera interpolation tokens][interpolation], [hiera.yaml][hiera.yaml], [the Struct data type][struct].

{:.reference}
## The Puppet::LookupContext object and methods

To support caching and other backends needs, Hiera provides a `Puppet::LookupContext` object.

In Ruby functions, the context object  is a normal Ruby object of class `Puppet::LookupContext`, and you can call methods with standard Ruby syntax, for example `context.not_found`.

In Puppet language functions, the context object appears as the special data type `Puppet::LookupContext`, that has methods attached.You can call the context’s methods using Puppet’s chained function call syntax with the method name instead of a normal function call syntax, for example, `$context.not_found`. For methods that take a block, use Puppet’s lambda syntax (parameters outside block) instead of Ruby’s block syntax (parameters inside block).

### not_found()

Tells Hiera to halt this lookup and move on to the next data source. Call this method when your function cannot find a matching key or a given lookup. This method returns no value.

For `data_hash` backends, return an empty hash. The empty hash will result in `not_found`, and will prevent further calls to the provider. Missing data sources are not an issue when using `path/glob`, but are important for backends that locate their own data sources.

For `lookup_key` and `data_dig` backends, use `not_found` when a requested key is not present in the data source or the data source does not exist. Do not return `undef` or `nil` for missing keys, as these are legal values that can be set in data.

### interpolate(value)

Returns the provided value, but with any Hiera interpolation tokens (`%{variable}` or `%{lookup('key')}`) replaced by their value. This lets you opt-in to allowing Hiera-style interpolation in your backend’s data sources. It works recursively on arrays and hashes. Hashes can interpolate into both keys and values.

In `data_hash` backends, support for interpolation is built in, and you do not need to call this method.

In `lookup_key` and `data_dig` backends, call this method if you want to support interpolation.

### environment_name()

Returns the name of the environment, regardless of layer.

### module_name()

Returns the name of the module whose `hiera.yaml` called the function. Returns `undef` (in Puppet) or `nil` (in Ruby) if the function was called by the global or environment layer.

### cache(key, value)

Caches a value, in a per-data-source private cache. It also returns the cached value.

On future lookups in this data source, you can retrieve values by calling `cached_value(key)`. Cached values are immutable, but you can replace the value for an existing key. Cache keys can be anything valid as a key for a Ruby hash, including `nil`.

For example, on its first invocation for a given YAML file, the built-in `eyaml_lookup_key` backend reads the whole file and caches it, and will then decrypt only the specific value that was requested. On subsequent lookups into that file, it gets the encrypted value from the cache instead of reading the file from disk again. It also caches decrypted values so that it won’t have to decrypt again if the same key is looked up repeatedly.

The cache is useful for storing session keys or connection objects for backends that access a network service.

Each `Puppet::LookupContext` cache lasts for the duration of the current catalog compilation. A node can’t access values cached for a previous node.

Hiera creates a separate cache for each combination of inputs for a function call, including inputs like `name` that are configured in `hiera.yaml` but not passed to the function. Each hierarchy level has its own cache, and hierarchy levels that use multiple paths have a separate cache for each path.

If any inputs to a function change, for example, a path interpolates a local variable whose value changes between lookups, Hiera uses a fresh cache.

### cache_all(hash)

Caches all the key-value pairs from a given hash. Returns `undef` (in Puppet) or `nil` (in Ruby).

### cached_value(key)

Returns a previously cached value from the per-data-source private cache. Returns `undef` or `nil` if no value with this name has been cached.

### cache_has_key(key)

Checks whether the cache has a value for a given key yet. Returns `true` or `false`.

### cached_entries()

Returns everything in the `per-data-source` cache as an iterable object. The returned object is not a hash. If you want a hash, use `Hash($context.all_cached())` in the Puppet language or `Hash[context.all_cached()]` in Ruby.

### cached_file_data(path)

Puppet syntax:

`cached_file_data(path) |content| { ... }`

Ruby syntax:

`cached_file_data(path) {|content| ...}`

For best performance, use this method to read files in Hiera backends.

`cached_file_data(path) {|content| ...}` returns the content of the specified file as a string. If an optional block is provided, it passes the content to the block and returns the block’s return value. For example, the built-in JSON backend uses a block to parse JSON and return a hash:

```
context.cached_file_data(path) do |content|
      begin
        JSON.parse(content)
      rescue JSON::ParserError => ex
        # Filename not included in message, so we add it here.
        raise Puppet::DataBinding::LookupError, "Unable to parse (#{path}): #{ex.message}"
      end
    end
```

On repeated access to a given file, Hiera checks whether the file has changed on disk. If it hasn’t, Hiera uses cached data instead of reading and parsing the file again.

This method does not use the same `per-data-source` caches as `cache(key, value)` and similar methods. It uses a separate cache that lasts across multiple catalog compilations, and is tied to Puppet Server’s environment cache.

Since the cache can outlive a given node’s catalog compilation, do not do any node-specific pre-processing (like calling `context.interpolate`) in this method’s block.

### explain() { 'message' }

Puppet syntax:

`explain() || { 'message' }`

Ruby syntax:

`explain() { 'message' }`

In both Puppet and Ruby, the provided block must take zero arguments.

`explain() { 'message' }` adds a message, which appears in debug messages or when using `puppet lookup --explain`. The block provided to this function must return a string.

The `explain` method is useful for complex lookups where a function tries several different things before arriving at the value. The built-in backends do not use the `explain` method, and they still have relatively verbose explanations. This method is for when you need to provide even more detail.

Hiera never executes the explain block unless explain is enabled.

Related topics: [Ruby functions][ruby_functions], [Puppet language functions][puppet_functions], [chained function call syntax][functions].
