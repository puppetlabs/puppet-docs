---
layout: default
title: "Future Parser: Data Types: Abstract Data Types"
canonical: "/puppet/latest/reference/future_lang_data_abstract.html"
---


### Variant

- **Matches**: anything that matches at least one of the given parameter types.
- **Required Parameters**: one or more parameter types.
- **Optional Parameters**: none.

Examples:

* `Variant[Integer, Float]` --- matches any integer or floating point number (equivalent to `Numeric`).
* `Variant[Enum['true', 'false'], Boolean]` --- matches `'true'`, `'false'`, `true`, or `false`.

### Scalar

- **Matches**: an instance of Integer, Float, String, Boolean, or Regexp.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: the `Scalar` type is equivalent to `Variant[Integer, Float, String, Boolean, Regexp]`.

### Collection

- **Matches**: an instance of Array or Hash.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: the `Collection` type is equivalent to `Variant[Array[Any], Hash[Any, Any]]`.

### Data

- **Matches**: an instance of `Scalar`, `Array[Data]`, `Hash[Scalar, Data]`, or `Undef`.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: this type is closely related to the Scalar type, but it also matches arrays of scalars or hashes with scalar/data values. The definition is recursive, so you can nest scalar values in any number of hashes or arrays. This data type is useful as it represents the subset of types that
can be directly represented in almost all serialization formats (e.g. JSON).

Examples of types that match `Data`:

* `Integer`
* `Array[Integer]`
* `Array[Array[Integer]]`
* `Hash[String, Integer]`
* `Hash[String, Array[Integer]]`
* `Array[Hash[String, Array[Integer]]]`

### Pattern

- **Matches**: a string that matches at least one of the given regular expressions.
- **Required Parameters**: one or more regular expressions or stringified regular expressions.
- **Optional Parameters**: none.

Note:

* Additional options like `i` (case insensitive) are not supported by the type, but can be added
  as parameters inside of the regular expression.
* Capture groups can be used, but does not set any variables that can be used.
* `Pattern` is a subtype of `String`, so it will only match strings.

Examples:

* `Pattern[/^[a-z].*/]` --- matches any string that begins with a lowercase letter.
* `Pattern[/^[a-z].*/, /^none$/]` --- matches above **or** the exact string `"none"`.

### Enum

- **Matches**: one of the exact strings given as parameters.
- **Required Parameters**: one or more strings.
- **Optional Parameters**: none.

Note: Enum is a subtype of String, so it will only match strings.

Examples:

* `Enum['stopped', 'running']` --- matches a string that is either `'stopped'` or `'running'`.
* `Enum['true', 'false']` --- matches a string that is either `'true'` or `'false'`. Will not match `true` or `false` (without quotes).

### Tuple

- **Matches**: same as Array, but specifies the type of each element.
- **Required Parameters**: the type of each element in the array.
- **Optional Parameters**: minimum size, maximum size. If you specify a minimum size of `1`, then everything after the first element is optional. Supplying a high maximum size means that the last element (and only the last element) may occur a variable number of times.

Examples:

* `Tuple[String, Integer]` --- matches a two-element array containing a string followed by an integer.
* `Tuple[String, Integer, 1]` --- matches above **or** a one-element array containing only a string.
* `Tuple[String, Integer, 1, 4]` --- matches an array containing one string followed by 0 to 3 integers.
* `Tuple[String, Integer, 1, default]` --- matches an array containing one string followed by any number of integers.

### Struct

- **Matches**: same as Hash, but specifies the type of every key and value.
- **Required Parameters**: a hash containing `key => Type` pairs. In order to validate the input hash, the value of each key must match its type declaration.
- **Optional Parameters**: none.

Note: Keys that are missing in the input hash are treated as `undef`. That means that it's possible to have optional keys in a Struct, as long as the corresponding type is compatible with `undef` (i.e., `Optional` or `Any`).

Examples:

{%highlight ruby %}
Struct[{mode => Enum[read, write, update],
        path => String[1]}]
{% endhighlight %}
This matches a hash with both `mode` and `path` keys, the values of which must match `Enum['read', 'write', 'update']` and `String[1]`, respectively.

{%highlight ruby %}
Struct[{filename => String[1],
        path     => Optional[String [1]]}]
{% endhighlight %}
This matches the same as the previous example, but the `path` key is optional. If present, it must match `String[1]`.

### Optional

- **Matches**: an instance of a given type, or `undef`.
- **Required Parameters**: a single parameter type.
- **Optional Parameters**: none.

Examples:

* `Optional[String]` --- matches any string or `undef`.
* `Optional[Array[Integer[0, 10]]]` --- matches an array of integers between 0 and 10, or `undef`.

### Catalogentry

A Catalogentry is the abstract base type for `Resource` and `Class`.

- **Matches**: an instance of Resource or Class
- **Required Parameters**: none.
- **Optional Parameters**: none.

* `Type[Catalogentry]` --- matches any class or resource reference.

### Any

- **Matches**: anything at all, including `undef`.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: parameters that are not given an explicit type are assumed to by of `Any` type, which will never fail to match.

### Callable

- **Matches**: callable lambdas provided as function arguments.
- **Required Parameters**: none.
- **Optional Parameters**: any number of Types, followed by, optionally, a minimum number of arguments, a maximum number of arguments, and a Callable, which is taken as its `block_type`.

There is no way to interact with Callable values in the Puppet language, but Ruby functions written to the modern function API (`Puppet::Functions`) can use it to inspect the lambda provided to the function.
