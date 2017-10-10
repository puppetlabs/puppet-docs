---
layout: default
title: "Language: Data Types: Abstract Data Types"
canonical: "/puppet/latest/lang_data_abstract.html"
---

[types]: ./lang_data_type.html
[data types]: ./lang_data.html
[strings]: ./lang_data_string.html
[regular expressions]: ./lang_data_regexp.html
[booleans]: ./lang_data_boolean.html
[arrays]: ./lang_data_array.html
[hashes]: ./lang_data_hash.html
[hash_missing_key_access]: ./lang_data_hash.html#accessing-values
[numbers]: ./lang_data_number.html

As described in [the Data Type Syntax][types] page, each of Puppet's main [data types][] has a corresponding value that _represents_ that data type, which can be used to match values of that type in several contexts. (For example, `String` or `Array`.)

Each of those core data types will only match a particular set of values. They let you further restrict the values they'll match, but only in limited ways, and there's no way to _expand_ the set of values they'll match.

If you're using data types to match or restrict values and need more flexibility, you can use one of the _abstract data types_ on this page to construct a data type that suits your needs and matches the values you want.


## Flexible Data Types

These abstract data types can match values with a variety of concrete data types. Some of them are similar to a concrete type but offer alternate ways to restrict them (like `Enum`), and some of them let you combine types and match a union of what they would individually match (like `Variant` and `Optional`).

### `Optional`

The `Optional` data type wraps _one_ other data type, and results in a data type that matches anything that type would match _plus_ `undef`.

This is useful for matching values that are allowed to be absent.

It takes one mandatory parameter.

#### Parameters

The full signature for `Optional` is:

    Optional[<DATA TYPE>]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Data type | `Type` or `String` | none **(mandatory)** | The data type to add `undef` to.

`Optional` also allows you to specify a string as its parameter, which is a shortcut for `Optional[Enum["my string"]]` --- it will match only that exact string value or `undef`.

`Optional[<DATA TYPE>]` is equivalent to `Variant[ <DATA TYPE>, Undef ]`

#### Examples

* `Optional[String]` --- matches any string or `undef`.
* `Optional[Array[Integer[0, 10]]]` --- matches an array of integers between 0 and 10, or `undef`.
* `Optional["present"]` --- matches the exact string `"present"` or `undef`.


### `NotUndef`

The `NotUndef` type matches any value _except_ `undef`. It can also wrap one other data type, resulting in a type that matches anything the original type would match except `undef`.

It accepts one optional parameter.

#### Parameters

The full signature for `NotUndef` is:

    NotUndef[<DATA TYPE>]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Data type | `Type` or `String` | `Any` | The data type to subtract `undef` from.

`NotUndef` also allows you to specify a string as its parameter, which is a shortcut for `NotUndef[Enum["my string"]]` --- it will match only that exact string value. (This doesn't actually subtract anything, since the `Enum` wouldn't have matched `undef` anyway, but it enables a convenient notation for mandatory keys in `Struct` schema hashes.)

### `Variant`

The `Variant` data type combines any number of other data types, and results in a type that matches the union of what _any_ of those data types would match.

It takes any number of parameters, and requires at least one.

#### Parameters

The full signature for `Variant` is:

    Variant[ <DATA TYPE>, (<DATA TYPE, ...) ]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1–∞ | Data type | `Type` | none **(mandatory)** | A data type to add to the resulting compound data type. You must provide at least one data type parameter, and can provide any number of additional ones.

#### Examples

* `Variant[Integer, Float]` --- matches any integer or floating point number (equivalent to `Numeric`).
* `Variant[Enum['true', 'false'], Boolean]` --- matches `'true'`, `'false'`, `true`, or `false`.


### `Pattern`

The `Pattern` data type only matches [strings][], but it provides an alternate way to restrict which strings it will match. It takes any number of [regular expressions][], and results in a data type that matches any strings that would match _any_ of those regular expressions.

It takes any number of parameters, and requires at least one.

#### Parameters

The full signature for `Pattern` is:

    Pattern[ <REGULAR EXPRESSION>, (<REGULAR EXPRESSION>, ...) ]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1–∞ | Regular expression | `Regexp` | none **(mandatory)** | A regular expression describing some set of strings that the resulting data type should match. You must provide at least one regular expression parameter, and can provide any number of additional ones.


Note that you can use capture groups in the regular expressions, but they won't cause any variables like `$1` to be set.

#### Examples:

* `Pattern[/\A[a-z].*/]` --- matches any string that begins with a lowercase letter.
* `Pattern[/\A[a-z].*/, /\Anone\Z/]` --- matches the above **or** the exact string `"none"`.


### `Enum`

The `Enum` data type only matches [strings][], but it provides an alternate way to restrict which strings it will match. It takes any number of strings, and results in a data type that matches any string values that _exactly_ match one of those strings. Unlike the `==` operator, this matching is case-sensitive.

It takes any number of parameters, and requires at least one.

#### Parameters

The full signature for `Enum` is:

    Enum[ <OPTION>, (<OPTION>, ...) ]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1–∞ | Option | `String` | none **(mandatory)** | One of the literal string values that the resulting data type should match. You must provide at least one option parameter, and can provide any number of additional ones.


#### Examples:

* `Enum['stopped', 'running']` --- matches the strings `'stopped'` and `'running'`, and no other values.
* `Enum['true', 'false']` --- matches the strings `'true'` and `'false'`, and no other values. Will not match the [boolean][booleans] values `true` or `false` (without quotes).


### `Tuple`

The `Tuple` type only matches [arrays][], but it lets you specify different data types for _every element_ of the array, in order.

It takes any number of parameters, and requires at least one.

#### Parameters

The full signature for `Tuple` is:

    Tuple[ <CONTENT TYPE>, (<CONTENT TYPE>, ..., <MIN SIZE>, <MAX SIZE>) ]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1–∞ | Content type | `Type` | none **(mandatory)** | What kind of values the array contains _at the given position._ You must provide at least one content type parameter, and can provide any number of additional ones.
-2 | Min size | `Integer` | # of content types | The minimum number of elements in the array. If this is smaller than the number of content types you provided, any elements beyond the minimum will be optional; however, if present, they must still match the provided content types. This parameter accepts the special value `default`, but this won't use the default value; instead, it means 0 (all elements optional).
-1 | Max size | `Integer` | # of content types | The maximum number of elements in the array. You cannot specify a max without also specifying a min. If the max is larger than the number of content types you provided, it means the array may contain any number of additional elements, which _all_ must match the _last_ content type. This parameter accepts the special value `default`, but this won't use the default value; instead, it means infinity (any number of elements matching the final content type).

Note that if the max is _smaller_ than the number of content types you provided, it's nonsensical.

#### Examples

* `Tuple[String, Integer]` --- matches a two-element array containing a string followed by an integer, like `["hi", 2]`.
* `Tuple[String, Integer, 1]` --- matches the above **or** a one-element array containing only a string.
* `Tuple[String, Integer, 1, 4]` --- matches an array containing one string followed by 0 to 3 integers.
* `Tuple[String, Integer, 1, default]` --- matches an array containing one string followed by any number of integers.

### `Struct`

The `Struct` type only matches [hashes][], but it lets you specify:

* The name of every allowed key.
* Whether each key is required or optional.
* The allowed data type for each of those keys' values.

It takes one mandatory parameter.

#### Parameters

The full signature for `Struct` is:

    Struct[<SCHEMA HASH>]

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Schema hash | `Hash[Variant[String, Optional, NotUndef], Type]` | none **(mandatory)** | A hash that has all of the allowed keys and data types for the struct.


#### Schema Hashes

A struct's schema hash must have the same keys as the hashes it will match. Each value must be a [data type][types] that matches the allowed values for that key.

The keys in a schema hash are usually strings. They can also be an `Optional` or `NotUndef` type with the key's name as their parameter.

If a key is a string, Puppet uses the _value's_ type to determine whether it's optional --- since [accessing a missing key resolves to the value `undef`][hash_missing_key_access], the key will be optional if the value type accepts `undef` (like `Optional[Array]`).

Note that this doesn't distinguish between an explicit value of `undef` and an absent key. If you want to be more explicit, you can use `Optional['my_key']` to indicate that a key can be absent, and `NotUndef['my_key']` to make it mandatory. If you use one of these, a value type that accepts `undef` will only be used to decide about explicit `undef` values, not missing keys.

#### Examples

~~~ ruby
Struct[{mode => Enum[read, write, update],
        path => String[1]}]
~~~

This data type would match hashes like `{mode => 'read', path => '/etc/fstab'}`. Both the `mode` and `path` keys are mandatory; `mode`'s value must be one of `'read', 'write',` or `'update'`, and `path` must be a string of at least one character.

~~~ ruby
Struct[{mode => Enum[read, write, update],
        path => Optional[String[1]]}]
~~~

This data type would match the same values as the previous example, but the `path` key is optional. If present, `path` must match `String[1]`.

~~~ ruby
Struct[{mode            => Enum[read, write, update],
        path            => Optional[String[1]],
        Optional[owner] => String[1]}]
~~~

In this data type, the `owner` key can be absent, but if it's present, it _must_ be a string; a value of `undef` isn't allowed.

~~~ ruby
Struct[{mode            => Enum[read, write, update],
        path            => Optional[String[1]],
        NotUndef[owner] => Optional[String[1]]}]
~~~

In this data type, the owner key is mandatory, but it allows an explicit `undef` value.

## Parent Types

These abstract data types are the parents of multiple other types, and match values that would match _any_ of their sub-types. They're mostly useful when you have very loose restrictions but still want to guard against something weird.

### `Scalar`

The `Scalar` data type matches _all_ values of the following concrete data types:

* [Numbers][] (both integers and floats)
* [Strings][]
* [Booleans][]
* [Regular expressions][]

Note that it doesn't match `undef`, `default`, resource references, arrays, or hashes.

It takes no parameters.

`Scalar` is equivalent to `Variant[Integer, Float, String, Boolean, Regexp]`.

### `Data`

The `Data` data type matches any value that would match `Scalar`, but it also matches:

* `undef`
* [Arrays][] that only contain values that would also match `Data`
* [Hashes][] whose keys would match `Scalar` and whose values would also match `Data`

Note that it doesn't match `default` or resource references.

It takes no parameters.

`Data` is especially useful because it represents the subset of types that can be directly represented in almost all serialization formats (e.g. JSON).

### `Collection`

The `Collection` type matches _any_ array or hash, regardless of what kinds of values (and/or keys) it contains.

Note that this means it only partially overlaps with `Data` --- there are values (like an array of resource references) that match `Collection` but will not match `Data`.

`Collection` is equivalent to `Variant[Array[Any], Hash[Any, Any]]`.

### `Catalogentry`

The `Catalogentry` data type is the parent type of `Resource` and `Class`. This means that, like those types, the Puppet language contains no values that it will ever match. However, the type `Type[Catalogentry]` will match any class reference or resource reference.

It takes no parameters.

### `Any`

The `Any` data type matches _any_ value of _any_ data type.


## Unusual Types

These types aren't quite like the others.

### `Callable`

The `Callable` data type matches callable lambdas provided as function arguments.

There is no way to interact with `Callable` values in the Puppet language, but Ruby functions written to the modern function API (`Puppet::Functions`) can use this data type to inspect the lambda provided to the function.

#### Parameters

The full signature for `Callable` is:

    Callable[ (<DATA TYPE>, ...,) <MIN COUNT>, <MAX COUNT>, <BLOCK TYPE> ]

All of these parameters are optional.

Position | Parameter | Data Type | Default Value | Description
---------|-----------|-----------|---------------|------------
1–∞      | Data type | `Type`    | none          | Any number of data types, representing the data type of each argument the lambda accepts.
-3 | Min count | `Integer` | 0 | The minimum number of arguments the lambda accepts. This parameter accepts the special value `default`, which will use its default value.
-2 | Max count | `Integer` | infinity | The maximum number of arguments the lambda accepts. This parameter accepts the special value `default`, which will use its default value.
-1 | Block type | `Type[Callable]` | none | The `block_type` of the lambda.

