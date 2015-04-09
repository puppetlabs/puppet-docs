---
layout: default
title: "Future Parser: Parameter Types"
canonical: "/puppet/latest/reference/future_parameter_types.html"
---

## Puppet's Parameter Types

Puppet's parameter types fall into three basic categories:

* **Scalar** types specify a range of individual values, like numbers and strings.
* **Collection** types specify arrays and hashes.
* **Abstract** types are defined in terms of scalar and/or collection types, but add an additional level of flexibility.

Most types accept one or more **parameters** which follow the type name in a comma-separated list wrapped in angle brackets. For example, the `Integer` type takes up to two parameters --- minimum and maximum value --- so `Integer[0, 10]` means "an integer from 0 to 10." Parameters are usually optional, but a few types require them. (The only situation where you can leave out required parameters is if you're referring to the type itself; that is, `Type[Variant]` is legal, even though `Variant` has required parameters.)

## Scalar Types

These are the most specific types available in the Puppet language, representing individual values like numbers and strings. Note that none of the scalar types match `undef`.

### Integer

- **Matches**: whole numbers of any size within the limits of available memory. The `default` minimum and maximum values are `-Infinity` and `Infinity`, respectively. Practically the valid range is signed 64 bit integer since this is the range of integer values that can roundtrip safely between the components in the overall system.
- **Required Parameters**: none.
- **Optional Parameters**: minimum value, maximum value.

Examples:

* `Integer` --- matches any integer.
* `Integer[0]` --- matches any integer greater than or equal to 0.
* `Integer[default, 0]` --- matches any integer less than or equal to 0.
* `Integer[2, 8]` --- matches any integer from 2 to 8, inclusive.

### Float

- **Matches**: floating point numbers within the limitations of Ruby's [Float class](http://www.ruby-doc.org/core-2.1.2/Float.html). Practically this means a 64 bit double precision floating point value.
- **Required Parameters**: none.
- **Optional Parameters**: minimum value, maximum value.

Examples:

* `Float` --- matches any integer.
* `Float[1.6]` --- matches any floating point number greater than or equal to 1.6.
* `Float[1.6, 3.501]` --- matches any floating point number from 1.6 to 3.501, inclusive.

### Boolean

- **Matches**: `true` or `false`.
- **Required Parameters**: none.
- **Optional Parameters**: none.

### Regexp

- **Matches**: regular expressions. Not to be confused with the `Pattern` type, which matches strings.
- **Required Parameters**: none.
- **Optional Parameters**: accepts a regex pattern for exact comparison.

Examples:

* `Regexp` --- matches any regular expression.
* `Regexp[/foo/]` --- matches the regular expression `/foo/` only.

### String

- **Matches**: strings.
- **Required Parameters**: none.
- **Optional Parameters**: minimum length, maximum length.

Note: the String type also has two subtypes: [Enum](#enum), for matching one of a list of strings, and [Pattern](#pattern), for matching against one or more regular expressions.

Examples:

* `String` --- matches a string of any length.
* `String[6]` --- matches a string with *at least* 6 characters.
* `String[6, 8]` --- matches a string with at least 6 and at most 8 characters.

## Collection Types

The collection types are the simplest way to match arrays or classes, but also the least flexible. The abstract [Tuple](#tuple) and [Struct](#struct) types provide a bit more fine control over arrays and hashes.

### Array

- **Matches**: arrays.
- **Required Parameters**: none.
- **Optional Parameters**: type, minimum size, maximum size.

Note: Arrays in Puppet can contain any number of distinct types, while the `Array` parameter type only lets you specify one. You can use [abstract types](future_abstract_types.html) to express more nuanced type requirements (see the last two examples below). Another way to define an array that contains multiple types is with the [`Tuple` type](#tuple).



Examples:

* `Array` --- matches an array of any length; each element in the array must match `Data`.
* `Array[String]` --- matches an array of any size that contains only strings.
* `Array[Integer, 6]` --- matches an array containing at least six integers.
* `Array[Float, 6, 12]` --- matches an array containing at least six and at most 12 floating-point numbers.
* `Array[Variant[String, Integer]]` --- matches an array of any size that contains only strings and/or integers.
* `Array[Any, 2]` --- matches an array containing at least two elements, no matter what type those elements are.

### Hash

- **Matches**: hash maps.
- **Required Parameters**: none.
- **Optional Parameters**: key type, value type, minimum length (in pairs), maximum length (in pairs).

Note: Hashes in Puppet can contain any number of distinct key-value types, while the `Hash` parameter type only lets you specify a single type for each. You can use [abstract types](future_abstract_types.html) to express more nuanced type requirements. Another way to define a hash that contains multiple types is with the [`Struct` type](#struct).

Examples:

* `Hash` --- matches any hash map whose keys match `Scalar` and values match `Data`.
* `Hash[String]` --- matches any hash map that uses only strings as keys.
* `Hash[Integer, String]` --- matches a hash map that uses integers for keys and strings for values.
* `Hash[Integer, String, 1]` --- same as above, but requires a non-empty hash map.
* `Hash[Integer, String, 1, 8]` --- same as above, but with a maximum size of eight key-value pairs.

### Resource

The Resource type represents a reference to a puppet resource type, or a user defined resource type. While it matches resources, there are never any variables or other data structures in the Puppet Language that holds such values; only references to such values are used in the Language. In practice this means that to accept a resource reference as a parameter the type must be given as `Type[Resource]` (possible with additional type parameters).

- **Matches**: resource instances (which are not first class values in the Puppet Language)
- **Required Parameters**: none.
- **Optional Parameters**: resource type name, resource title.

Examples:

* `Type[Resource]` --- matches all kinds of resource references except classes
* `Type[Resource[file]]` --- matches all file resource references
* `Type[Resource[file, '/tmp/foo]]` --- matches only the file resource references with title 'tmp/foo'

### Class

The Class type represents a reference to a puppet class. WHile it matches classes, there are never any variables or other data structures in the Puppet Language that holds such values; only references to classes are used in the Language. In practice this means that to accept a class reference as a parameter the type must be given as Type[Class] (possible with additional type parameters).

- **Matches**: class instances (which are not first class values in the Puppet Language)
- **Required Parameters**: none.
- **Optional Parameters**: class name.

Examples:

* `Type[Class]` --- matches references to all classes
* `Type[Class[myclass]]` --- matches only the reference to the class myclass


## Abstract Types

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

### Numeric

- **Matches**: an instance of Integer or Float.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: the `Numeric` type is equivalent to `Variant[Integer, Float]`.

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

### Collection

- **Matches**: an instance of Array or Hash.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: the `Collection` type is equivalent to `Variant[Array[Any], Hash[Any, Any]]`.

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

### Undef

Puppet's special `undef` value, representing the absence of a value. Roughly equivalent to Ruby's `nil`.

- **Matches**: only the value `undef`.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note that the value `undef` can also match `Data` and `Optional`, as well as `Any`.

### Default

- **Matches**: an instance of the special value `default`.
- **Required Parameters**: none.
- **Optional Parameters**: none.

Note: the special value `default` is the only value that matches this type. To be meaningful
it is most often combined with some other data type using a Variant. This gives the ability to handle undef (meaning value is not set), given value (meaning set to this value), or a default value (meaning, please pick a suitable default).

Examples:

* `Variant[String, Default, Undef]` --- matches any string, `undef`, or `default`

### Catalogentry

A Catalogentry is the abstract base type for `Resource` and `Class`.

- **Matches**: an instance of Resource or Class
- **Required Parameters**: none.
- **Optional Parameters**: none.

* `Type[Catalogentry]` --- matches any class or resource reference.

### Type

- **Matches**: an instance of a type
- **Required Parameters**: none.
- **Optional Parameters**: a type.

Examples:

* `Type` --- matches any type, such as `Integer`, `String`, `Any`, `Type`.
* `Type[String]` --- matches only the type `String` (and any of its more specific instances like `String[3]`).
* `Type[Resource]` --- matches any `Resource` type (i.e. any resource reference).

Note: the standard lib function `type_of` can return the type of a value e.g. `type_of(3)` returns `Integer[3,3]`.

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
