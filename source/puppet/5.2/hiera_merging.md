---
title: "Hiera: Merging data from multiple sources"
toc_levels: 234
---


[automatic]: ./hiera_automatic.html
[first]: #first
[unique]: #unique
[hash]: #hash
[deep]: #deep
[lookup_function]: ./hiera_use_function.html
[lookup_command]: ./man/lookup.html
[module layer]: ./hiera_layers.html#the-module-layer
[regexp]: ./lang_data_regexp.html
[ruby_regexp]: http://ruby-doc.org/core/Regexp.html
[hiera_functions]: ./hiera_use_hiera_functions.html


When you look up a key in Hiera, it's common for multiple data sources to have different values for it. By default, Hiera returns the first value it finds, but it can also continue searching and merge all the found values together.

You can set the **merge behavior** for a lookup in two ways:

* **At lookup time.** This works with [the `lookup` function][lookup_function], but doesn't support [automatic class parameter lookup][automatic].
* **In Hiera data,** with the `lookup_options` key. This works for both manual and automatic lookups. It also lets module authors set default behavior that users can override.

With both of these methods, you can specify a merge behavior as either a string (like `'first'`) or a hash (like `{'strategy' => 'first'}`). The hash syntax is only useful for `deep` merges (where it can set some extra options), but it works with the other merge types for consistency's sake.

## List of merge behaviors

There are four merge behaviors to choose from: [first][], [unique][], [hash][], and [deep][].

### Syntax summary

[inpage_identifiers]: #syntax-summary

When specifying a merge behavior, use one of the following identifiers:

* `'first'`, `{'strategy' => 'first'}`, or nothing.
* `'unique'` or `{'strategy' => 'unique'}`.
* `'hash'` or `{'strategy' => 'hash'}`.
* `'deep'` or `{'strategy' => 'deep', <OPTION> => <VALUE>, ...}`. Valid options:
    * `'knockout_prefix'` (string or undef; default is `undef`)
    * `'sort_merged_arrays'` (boolean; default is `false`)
    * `'merge_hash_arrays'` (boolean; default is `false`)

### First

A first-found lookup doesn't merge anything; it returns the first value found, and ignores the rest. This is Hiera's default behavior.

Specify this merge behavior with one of:

* `'first'`
* `{'strategy' => 'first'}`
* Nothing (since it's the default)

### Unique

A unique merge (sometimes called "array merge") combines any number of array and scalar (string/number/boolean) values to return a merged, flattened array with all duplicate values removed. The lookup fails if any of the values are hashes. The result is ordered from highest-priority to lowest.

For example:

``` yaml
# location/pdx.yaml
profile::server::time_servers: time.pdx.example.com
# common.yaml
profile::server::time_servers:
  - 0.pool.ntp.org
  - 1.pool.ntp.org
```

`lookup('profile::server::time_servers', {merge => 'unique'})` would return the following:

``` puppet
[
  'time.pdx.example.com',
  '0.pool.ntp.org',
  '1.pool.ntp.org',
]
```

Specify this merge behavior with one of:

* `'unique'`
* `{'strategy' => 'unique'}`

### Hash

A hash merge combines the keys and values of any number of hashes to return a merged hash. The lookup fails if any of the values aren't hashes.

If multiple source hashes have a given key, Hiera uses the value from the highest-priority data source; it won't recursively merge the values.

Hashes in Puppet preserve the order in which their keys are written. When merging hashes, Hiera starts with the _lowest-priority_ data source. For each higher-priority source, it appends new keys at the end of the hash and updates existing keys in-place.

For example:

``` yaml
# web01.example.com.yaml
mykey:
  d: "per-node value"
  b: "per-node override"
# common.yaml
mykey:
  a: "common value"
  b: "default value"
  c: "other common value"
```

`lookup('mykey', {merge => 'hash'})` would return the following:

``` puppet
{
  a => "common value",
  b => "per-node override", # Using value from the higher-priority source, but
                            # preserving the order of the lower-priority source.
  c => "other common value",
  d => "per-node value",
}
```

Specify this merge behavior with one of:

* `'hash'`
* `{'strategy' => 'hash'}`

### Deep

Like a hash merge, a deep merge combines the keys and values of any number of hashes to return a merged hash. But if the same key exists in multiple source hashes, Hiera **recursively merges them:**

* Hash values are merged with another deep merge.
* Array values are merged. This differs from the normal unique merge as follows:
    * The result is ordered from lowest-priority to highest, which is the reverse of the unique merge's ordering.
    * The result isn't flattened, so it can contain nested arrays.
    * The `merge_hash_arrays` and `sort_merged_arrays` options can make further changes to the result.
* Scalar (string/number/boolean) values use the highest-priority value, like in a first-found lookup.

> **Note:** Unlike a hash merge, a deep merge can also accept arrays as the root values. It merges them with its normal array merging behavior, which differs from a unique merge as described above.
>
> This does not apply to the `hiera_hash` function, which can be configured to do deep merges but can't accept arrays.

> **Note:** Hiera 5's deep merge is equivalent to Hiera 3's "deeper" merge.

In this example, note what happens to the `bob` user in a hash merge vs. a deep merge: In the former, all of his attributes come from the higher-priority source, but in the latter, they're combined.

<table>
<tr>
<th>Data sources</th> <th>Hash merge</th> <th>Deep merge</th>
</tr>

<tr>

<td>
{% md %}
``` yaml
# groups/ops.yaml
site_users:
  jen:
    uid: 503
    shell: /bin/zsh
    group: ops
  bob:
    uid: 1000
    group: ops

# common.yaml
site_users:
  bob:
    uid: 501
    shell: /bin/bash
  ash:
    uid: 502
    shell: /bin/zsh
    group: common
```
{% endmd %}
</td>

<td>
{% md %}
``` puppet
{
  "bob"=>{
    group=>"ops",
    uid=>1000,
  },
  "jen"=>{
    group=>"ops",
    uid=>503
    shell=>"/bin/zsh",
  },
  "ash"=>{
    group=>"common",
    uid=>502,
    shell=>"/bin/zsh"
  }
}
```
{% endmd %}
</td>

<td>
{% md %}
``` puppet
{
  "bob"=>{
    group=>"ops",
    uid=>1000,
    shell=>"/bin/bash"
  },
  "jen"=>{
    group=>"ops",
    uid=>503
    shell=>"/bin/zsh",
  },
  "ash"=>{
    group=>"common",
    uid=>502,
    shell=>"/bin/zsh"
  }
}
```
{% endmd %}
</td>
</tr>
</table>


Specify this merge behavior with one of:

* `'deep'`
* `{'strategy' => 'deep', <OPTION> => <VALUE>, ...}` --- This form can adjust the merge behavior with some additional options:
    * `'knockout_prefix'` (string or undef) --- A string prefix to indicate a value should be _removed_ from the final result. Defaults to `undef`, which disables this feature.
    * `'sort_merged_arrays'` (boolean) --- Whether to sort all arrays that are merged together. Defaults to `false`.
    * `'merge_hash_arrays'` (boolean) --- Whether to deep-merge hashes within arrays, by position. For example, `[ {a => high}, {b => high} ]` and `[ {c => low}, {d => low} ]` would be merged as `[ {c => low, a => high}, {d => low, b => high} ]`. Defaults to `false`.


## Setting merge behavior at lookup time

With the `lookup` function and the `puppet lookup` command, you can provide a merge behavior as an argument or flag. This overrides any pre-configured merge behavior for that key.

Function example:

``` puppet
# Merge several arrays of class names into one array:
lookup('classes', {merge => 'unique'})
```

CLI example:

```
$ puppet lookup classes --merge unique --environment production --explain
```

For more details about syntax, see [Using the lookup function][lookup_function] and [Using the `puppet lookup` command][lookup_command].

Note that each of [the `hiera_*` functions][hiera_functions] is locked to one particular merge behavior. (`hiera` only does first-found, `hiera_array` only does unique merge, etc.)

## Configuring merge behavior in Hiera data

In any Hiera data source (including [module data][module layer]), you can use the special `lookup_options` key to configure merge behavior. Hiera uses a key's configured merge behavior in any lookup that doesn't explicitly override it. (Note that [the `hiera_*` functions][hiera_functions] always explicitly override configured merge behavior.)

For example:

``` yaml
# <ENVIRONMENT>/data/common.yaml
lookup_options:
  ntp::servers:     # Name of key
    merge: unique   # Merge behavior as a string
  "^profile::(.*)::users$": # Regexp: `$users` parameter of any profile class
    merge:          # Merge behavior as a hash
      strategy: deep
      merge_hash_arrays: true
```

In this example, Hiera would use the configured merge behaviors for these keys as follows:

Scenario                                                    | Merge behavior
------------------------------------------------------------|---------------
Automatic lookup for `ntp` class's `$servers` param         | Unique
`lookup('ntp::servers')`                                    | Unique
`lookup('ntp::servers', {merge => first})`                  | First (due to override)
Automatic lookup for `profile::server`'s `$users` param     | Deep, with `merge_hash_arrays`


### `lookup_options` format

The value of `lookup_options` is a hash with the following format:

``` yaml
lookup_options:
  <NAME or REGEXP>:
    merge: <MERGE BEHAVIOR>
```

That is:

* Each key is either the full name of a lookup key (like `ntp::servers`) or a [regular expression][regexp] (like `'^profile::(.*)::users$'`).
    * In a module's data, you can only configure lookup keys in that module's namespace. (So the `ntp` module can set options for `ntp::servers`, but the `apache` module can't.)
* Each value is a hash with a `merge` key. [As shown above][inpage_identifiers], a merge behavior can be a string or a hash.

**`lookup_options` is a reserved key** --- you can't put other kinds of data in it, and you can't look it up directly. This is Hiera's only reserved key.

### Overriding merge behavior

* Any data source can override individual `lookup_options` from a lower-priority source. Since Hiera uses a [hash merge][hash] on the `lookup_options` values, module authors can configure a default merge behavior for a given key and end users can override it.
* When you specify a merge behavior as an argument to [the `lookup` function][lookup_function], it always overrides any configured merge behavior.

### Matching keys with regular expressions

You can use [regular expressions][regexp] in `lookup_options` to configure merge behavior for many lookup keys at once. For example, a regexp key like `'^profile::(.*)::users$'` can set the merge behavior for `profile::server::users`, `profile::postgresql::users`, `profile::jenkins::master::users`, etc.

Regexp lookup options use [Puppet's regexp support][regexp], which in turn is based on [Ruby's regular expressions][ruby_regexp].

To use a regular expression in `lookup_options`:

* Write the pattern as a quoted string. Do not use the Puppet language's forward-slash (`/.../`) regexp delimiters.
* Begin the pattern with the start-of-line metacharacter (`^`, also called a carat).
    * If `^` isn't the first character, Hiera treats it as a literal key name instead of a regexp.
* If this data source is in a module, follow `^` with the module's namespace --- its full name, plus the `::` namespace separator.
    * For example, all regexp lookup options in the `ntp` module must start with `^ntp::` --- starting with anything else results in an error.

The merge behavior you set for that pattern applies to all lookup keys that match it.

In cases where multiple lookup options could apply to the same key, Hiera resolves the conflict as follows:

* If there's a literal (non-regexp) option available, it always wins.
    * For example, if you've configured merge options for both `profile::server::users` and `'^profile::(.*)::users$'`, lookups for `profile::server::users` will use the former.
* Otherwise, Hiera uses the **first** regular expression that matches the lookup key, using the order in which they're written.

  > **Note:** `lookup_options` are assembled with a [hash merge][hash], which puts keys from lower-priority data sources **before** those from higher-priority sources. This means that if you want to override a module's regexp-configured merge behavior, you must use the **exact same** regexp string in your environment data, so that it _replaces_ the module's value. If you use a slightly different regexp that would match most of the same keys, it won't work because the lower-priority regexp goes first.
