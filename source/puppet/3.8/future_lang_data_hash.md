---
layout: default
title: "Future Parser: Data Types: Hashes"
canonical: "/puppet/latest/reference/lang_data_hash.html"
---

[undef]: ./future_lang_data_undef.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[data type]: ./future_lang_data_type.html
[struct]: ./future_lang_data_abstract.html#struct
[abstract types]: ./future_lang_data_abstract.html
[data]: ./future_lang_data_abstract.html#data
[scalar]: ./future_lang_data_abstract.html#scalar


Hashes (sometimes called hash maps) are unordered structures that map keys to values.

## Syntax

Hashes are written as a pair of curly braces containing any number of key/value pairs. A key is separated from its value by a `=>` (arrow, fat comma, or hash rocket), and adjacent pairs are separated by commas. An optional trailing comma is allowed between the final value and the closing curly brace.

~~~ ruby
    { key1 => 'val1', key2 => 'val2' }
    # Equivalent:
    { key1 => 'val1', key2 => 'val2', }
~~~

Hash keys can be any data type, but you should generally only use strings or numbers.

Hash values can be any data type.

## Accessing Values

You can access hash members with their key; square brackets are used for accessing.

~~~ ruby
    $myhash = { key       => "some value",
                other_key => "some other value" }
    notice( $myhash[key] )
~~~

This manifest would log `some value` as a notice.

If you try to access a nonexistent key from a hash, its value will be [`undef`.][undef]

~~~ ruby
    $cool_value = $myhash[absent_key] # Value is undef
~~~

Nested arrays and hashes can be accessed by chaining indexes:

~~~ ruby
    $main_site = { port        => { http  => 80,
                                    https => 443 },
                   vhost_name  => 'docs.puppetlabs.com',
                   server_name => { mirror0 => 'warbler.example.com',
                                    mirror1 => 'egret.example.com' }
                 }
    notice ( $main_site[port][https] )
~~~

This example manifest would log `443` as a notice.

## Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with hashes, including:

* `has_key`
* `is_hash`
* `keys`
* `merge`
* `validate_hash`
* `values`

## The `Hash` Data Type

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


### Related Data Types

The abstract [`Struct` data type][struct] lets you specify the exact keys allowed in a hash, as well as what value types are allowed for each key.

Several [abstract types][], including `Variant` and `Enum`, are useful when specifying a value type for hashes that might include multiple kinds of data.
