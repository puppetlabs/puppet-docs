---
layout: default
title: "Language: Data types: Hashes"
---

[undef]: ./lang_data_undef.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[data type]: ./lang_data_type.html
[struct]: ./lang_data_abstract.html#struct
[abstract types]: ./lang_data_abstract.html
[data]: ./lang_data_abstract.html#data
[scalar]: ./lang_data_abstract.html#scalar

Hashes map keys to values, maintaining the order of the entries according to insertion order.

When hashes are merged (using the `+` operator), the keys in the constructed hash have the same order as in the original hashes, with the left hash keys ordered first, followed by any keys that appeared only in the hash on the right side of the merge.

Where a key exists in both original hashes, the value of the key in the original hash to the right of the `+` operator that ends up in the resulting hash."

For example:

```
$values = {'a' => 'a', 'b' => 'b'}
$overrides = {'a' => 'overridden'}
$result = $values + $overrides
notice($result)
-> {'a' => 'overridden', 'b' => 'b'}
```

## Syntax

Hashes are written as a pair of curly braces containing any number of key/value pairs. A key is separated from its value by a `=>` (arrow, fat comma, or hash rocket), and adjacent pairs are separated by commas. An optional trailing comma is allowed between the final value and the closing curly brace.

``` puppet
{ 'key1' => 'val1', key2 => 'val2' }
# Equivalent:
{ 'key1' => 'val1', key2 => 'val2', }
```

Hash keys can be any data type, but generally, you should use only strings. You should quote any keys that are strings. You should not assign a hash with non-string keys to a resource attribute or class parameter, because Puppet cannot serialize non-string hash keys into the catalog.

```
{ 'key1' => ['val1','val2'], 
   key2 => {  'key3' =>  'val3',  }, 
  'key4' => true,
  'key5' => 12345,
 }
```

## Accessing values

You can access hash members with their key; square brackets are used for accessing.

``` puppet
$myhash = { key       => "some value",
            other_key => "some other value" }
notice( $myhash[key] )
```

This manifest would log `some value` as a notice.

If you try to access a nonexistent key from a hash, its value will be [`undef`.][undef]

``` puppet
$cool_value = $myhash[absent_key] # Value is undef
```

Nested arrays and hashes can be accessed by chaining indexes:

``` puppet
$main_site = { port        => { http  => 80,
                                https => 443 },
               vhost_name  => 'docs.puppetlabs.com',
               server_name => { mirror0 => 'warbler.example.com',
                                mirror1 => 'egret.example.com' }
             }
notice ( $main_site[port][https] )
```

This example manifest would log `443` as a notice.

## Additional functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with hashes, including:

* `has_key`
* `is_hash`
* `keys`
* `merge`
* `validate_hash`
* `values`

## The `Hash` data type

The [data type][] of hashes is `Hash`.

By default, `Hash` matches hashes of any size, as long as their keys match [the abstract type `Scalar`][scalar] and their values match [the abstract type `Data`.][data]

You can use parameters to restrict which values `Hash` will match.

### Parameters

The full signature for `Hash` is:

    Hash[<KEY TYPE>, <VALUE TYPE>, <MIN SIZE>, <MAX SIZE>]

Although all of these parameters are optional, you must specify _both_ key type and value type if you're going to specify one of them.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Key type | `Type` | `Scalar` | What kinds of values can be used as keys. **Note:** If you specify a key type, a value type is **mandatory.**
2 | Value type | `Type` | `Data` | What kinds of values can be used as values.
3 | Min Size | `Integer` | 0 | The minimum number of key/value pairs in the hash. This parameter accepts the special value `default`, which will use its default value.
4 | Max Size | `Integer` | infinite | The maximum number of key/value pairs in the hash. This parameter accepts the special value `default`, which will use its default value.


### Examples

* `Hash` --- matches a hash of any length; any keys must match `Scalar` and any values must match `Data`.
* `Hash[Integer, String]` --- matches a hash that uses integers for keys and strings for values.
* `Hash[Integer, String, 1]` --- same as above, but requires a non-empty hash.
* `Hash[Integer, String, 1, 8]` --- same as above, but with a maximum size of eight key-value pairs.


### Related data types

The abstract [`Struct` data type][struct] lets you specify the exact keys allowed in a hash, as well as what value types are allowed for each key.

Several [abstract types][], including `Variant` and `Enum`, are useful when specifying a value type for hashes that might include multiple kinds of data.
