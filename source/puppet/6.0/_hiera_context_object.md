## The `Puppet::LookupContext` object

To support caching and other needs, Hiera provides backends a special `Puppet::LookupContext` object, which has several methods you can call for various effects.

* In [Ruby functions](./functions_ruby_overview.html), this is a normal Ruby object of class `Puppet::LookupContext`, and you can call methods with standard Ruby syntax (like `context.not_found`).
* In [Puppet language functions](./lang_write_functions_in_puppet.html), the context object appears as a special data type (Object) that has methods attached. Right now, there isn't anything else in the Puppet language that acts like this.

    You can call its methods using Puppet's [chained function call syntax](./lang_functions.html#chained-function-calls) with the method name instead of a normal function --- for example, `$context.not_found`. For methods that take a block, use Puppet's lambda syntax (parameters outside block) instead of Ruby's block syntax (parameters inside block).

The following methods are available:

* [`not_found()`][method_not], for bailing out of a lookup.
* [`interpolate(value)`][method_interpolate], for handing Hiera interpolation tokens in values.
* [`environment_name()`][method_env], to find out which environment this is.
* [`module_name()`][method_module], to find out which module this is.
* [`cache(key, value)`][method_cache], for caching information between function runs.
* [`cache_all(hash)`][method_cache_all], for caching several things at once.
* [`cached_value(key)`][method_cached], for retrieving cached values.
* [`cache_has_key(key)`][method_haskey], for checking the cache.
* [`cached_entries()`][method_allcached], for dumping the whole cache.
* [`cached_file_data(path) {|content| ...}`][method_cached_file], for high-performance reading of data files.
* [`explain() || { 'message' }`][method_explain], for helpful debug messages.


### `not_found()`

[method_not]: #notfound

Tells Hiera to move on to the next data source. Call this method when your function can't find a value for a given lookup. **This method does not return.**

For `data_hash` backends, use this when the requested data source doesn't exist. (If it exists and is empty, return an empty hash.) Missing data sources aren't an issue when using `path`/`glob` settings, but are important for backends that locate their own data sources.

For `lookup_key` and `data_dig` backends, use this when a requested key isn't present in the data source or the data source doesn't exist. Don't return `undef`/`nil` for missing keys, since that's a legal value that can be set in data.

### `interpolate(value)`

[method_interpolate]: #interpolatevalue

Returns the provided value, but with any Hiera interpolation tokens (like `%{variable}` or `%{lookup('key')}`) replaced by their value. This lets you opt-in to allowing Hiera-style interpolation in your backend's data sources. Works recursively on arrays and hashes; hashes can interpolate into both keys and values.

In `data_hash` backends, interpolation is automatically supported and you don't need to call this method.

In `lookup_key` and `data_dig` backends, you **must** call this method if you want to support interpolation; if you don't, Hiera assumes you have your own thing going on.

### `environment_name()`

[method_env]: #environmentname

Returns the name of the environment whose hiera.yaml called the function. Returns `undef` (in Puppet) or `nil` (in Ruby) if the function was called by the global or module layer.

### `module_name()`

[method_module]: #modulename

Returns the name of the module whose hiera.yaml called the function. Returns `undef` (in Puppet) or `nil` (in Ruby) if the function was called by the global or environment layer.

### `cache(key, value)`

[method_cache]: #cachekey-value

Caches a value, in a per-data-source private cache; also returns the cached value.

On future lookups in this data source, you can retrieve values with `cached_value(key)`. Cached values are immutable, but you can replace the value for an existing key. Cache keys can be anything valid as a key for a Ruby hash. (Notably, this means you can use `nil` as a key.)

For example, on its first invocation for a given YAML file, the built-in `eyaml_lookup_key` backend reads the whole file and caches it, and then decrypts only the specific value that was requested. On subsequent lookups into that file, it gets the encrypted value from the cache instead of reading the file from disk again. It also caches decrypted values, so that it won't have to decrypt again if the same key is looked up repeatedly.

The cache is also useful for storing session keys or connection objects for backends that access a network service.

#### Cache lifetime and scope

Each `Puppet::LookupContext` cache only lasts for the duration of the current catalog compilation; a node can't access values cached for a previous node.

Hiera creates a separate cache for each *combination of inputs for a function call,* including inputs like `name` that are configured in hiera.yaml but not passed to the function. So not only does each hierarchy level have its own cache, but hierarchy levels that use multiple paths have a separate cache for each path.

If any inputs to a function change (for example, a path interpolates a local variable whose value changes between lookups), Hiera uses a fresh cache.


### `cache_all(hash)`

[method_cache_all]: #cacheallhash

Caches all the key/value pairs from a given hash; returns `undef` (in Puppet) or `nil` (in Ruby).

### `cached_value(key)`

[method_cached]: #cachedvaluekey

Returns a previously cached value from the per-data-source private cache. Returns `nil` or `undef` if no value with this name has been cached. See [`cache(key, value)`][method_cache] above for more info about how the cache works.

### `cache_has_key(key)`

[method_haskey]: #cachehaskeykey

Checks whether the cache has a value for a given key yet. Returns `true` or `false`.

### `cached_entries()`

[method_allcached]: #cachedentries

Returns everything in the per-data-source cache, as an iterable object. Note that this iterable object isn't a hash; if you want a hash, you can use `Hash($context.all_cached())` (in the Puppet language) or `Hash[context.all_cached()]` (in Ruby).

### `cached_file_data(path) {|content| ...}`

[method_cached_file]: #cachedfiledatapath-content-

> **Note:** The header above uses Ruby's block syntax. To call this method in the Puppet language, you would use `cached_file_data(path) |content| { ... }`.

For best performance, use this method to read files in Hiera backends.

Returns the content of the specified file, as a string. If an optional block is provided, it passes the content to the block and returns the block's return value. For example, the built-in JSON backend uses a block to parse JSON and return a hash:

``` ruby
    context.cached_file_data(path) do |content|
      begin
        JSON.parse(content)
      rescue JSON::ParserError => ex
        # Filename not included in message, so we add it here.
        raise Puppet::DataBinding::LookupError, "Unable to parse (#{path}): #{ex.message}"
      end
    end
```

On repeated access to a given file, Hiera checks whether the file has changed on disk. If it hasn't, Hiera uses cached data instead of reading and parsing the file again.

This method **does not** use the same per-data-source caches as `cache(key, value)` and friends. It uses a separate cache that lasts across multiple catalog compilations, and is tied to [Puppet Server's environment cache]({{puppetserver}}/admin-api/v1/environment-cache.html).

Since the cache can outlive a given node's catalog compilation, do not do any node-specific pre-processing (like calling `context.interpolate`) in this method's block.

### `explain() { 'message' }`

[method_explain]: #explain--message-

> **Note:** The header above uses Ruby's block syntax. To call this method in the Puppet language, you would use `explain() || { 'message' }`. In both cases, the provided block must take zero arguments.

Adds a message, which appears in debug messages or when using `puppet lookup --explain`. The block provided to this function must return a string.

This is meant for complex lookups where a function tries several different things before arriving at the value. Note that the built-in backends don't use the `explain` method, and they still have relatively verbose explanations; this is for when you need to go above and beyond that.

Feel free to not worry about performance when constructing your message; Hiera never executes the explain block unless debugging is enabled.


