---
layout: default
title: "Language: Data types: Arrays"
canonical: "/puppet/latest/lang_data_array.html"
---

[undef]: ./lang_data_undef.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[data type]: ./lang_data_type.html
[tuple]: ./lang_data_abstract.html#tuple
[data]: ./lang_data_abstract.html#data
[abstract types]: ./lang_data_abstract.html
[regexp]: ./lang_data_regexp.html
[string data type]: ./lang_data_string.html


Arrays are ordered lists of values.

Resource attributes which accept multiple values (including the relationship metaparameters) generally expect those values in an array.

Many functions also take arrays, including the iteration functions.

## Syntax

Arrays are written as comma-separated lists of values surrounded by square brackets. An optional trailing comma is allowed between the final value and the closing square bracket.

``` puppet
[ 'one', 'two', 'three' ]
# Equivalent:
[ 'one', 'two', 'three', ]
```

The values in an array can be any data type.


## Accessing Values

You can access items in an array by their numerical index (counting from zero). Square brackets are used for accessing.

Example:

``` puppet
$foo = [ 'one', 'two', 'three' ]
notice( $foo[1] )
```

This manifest would log `two` as a notice. (`$foo[0]` would be `one`, since indexes count from zero.)

Nested arrays and hashes can be accessed by chaining indexes:

``` puppet
$foo = [ 'one', {'second' => 'two', 'third' => 'three'} ]
notice( $foo[1]['third'] )
```

This manifest would log `three` as a notice. (`$foo[1]` is a hash, and we access a key named `'third'`.)

Arrays support negative indexes, with `-1` being the final element of the array:

``` puppet
$foo = [ 'one', 'two', 'three', 'four', 'five' ]
notice( $foo[2] )
notice( $foo[-2] )
```

The first notice would log `three`, and the second would log `four`.

Note that the opening square bracket must not be preceded by a white space:

``` puppet
$foo = [ 'one', 'two', 'three', 'four', 'five' ]
notice( $foo[2] )  # ok
notice( $foo [2] ) # syntax error
```

If you try to access an element beyond the bounds of the array, its value will be [`undef`.][undef]

``` puppet
$foo = [ 'one', 'two', 'three', 'four', 'five' ]
$cool_value = $foo[6] # value is undef
```

When testing with a [regular expression][regexp] whether an `Array[<TYPE>]` data type matches a given array, empty arrays will match as long as the type can accept zero-length arrays.

``` puppet
$foo = []
if $foo =~ Array[String] {
  notice( 'foo' )
}
```

This manifest would log `foo` as a notice, because the regex matches the empty array.

## Array Sectioning

You can also access sections of an array by numerical index. Like accessing, sectioning uses square brackets, but it uses two indexes (separated by a comma) instead of one (e.g. `$array[3,10]`).

The result of an array section is always another array.

The first number of the index is the start position.

* Positive numbers will count from the start of the array, starting at `0`.
* Negative numbers will count back from the end of the array, starting at `-1`.

The second number of the index is the stop position.

* Positive numbers are lengths, counting forward from the start position.
* Negative numbers are absolute positions, counting back from the end of the array (starting at `-1`).

``` puppet
$foo = [ 'one', 'two', 'three', 'four', 'five' ]
notice( $foo[2,1] )  # evaluates to ['three']
notice( $foo[2,2] )  # evaluates to ['three', 'four']
notice( $foo[2,-1] ) # evaluates to ['three', 'four', 'five']
notice( $foo[-2,1] ) # evaluates to ['four']
```

## Array Operators

There are three expression operators that can act on array values: `*` (splat), `+` (concatenation), and `-` (removal).

For details, [see the relevant section of the Expressions and Operators page.](./lang_expressions.html#array-operators)


## Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with arrays, including:

* `delete`
* `delete_at`
* `flatten`
* `grep`
* `hash`
* `is_array`
* `join`
* `member`
* `prefix`
* `range`
* `reverse`
* `shuffle`
* `size`
* `sort`
* `unique`
* `validate_array`
* `values_at`
* `zip`

## The `Array` Data Type

The [data type][] of arrays is `Array`.

By default, `Array` matches arrays of any length, as long as any values in the array match [the abstract type `Data`][data].

You can use parameters to restrict which values `Array` will match.

### Parameters

The full signature for `Array` is:

    Array[<CONTENT TYPE>, <MIN SIZE>, <MAX SIZE>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Content type | `Type`    | `Data`   | What kind of values the array contains. You can only specify one data type per array, and _every_ value in the array must match that type. Use an abstract type to allow multiple data types. If the order of elements matters, use the `Tuple` type instead of `Array`.
2 | Min size     | `Integer` | 0        | The minimum number of elements in the array. This parameter accepts the special value `default`, which will use its default value.
3 | Max size     | `Integer` | infinite | The maximum number of elements in the array. This parameter accepts the special value `default`, which will use its default value.


### Examples

* `Array` --- matches an array of any length; any elements in the array must match `Data`.
* `Array[String]` --- matches an array of any size that contains only strings.
* `Array[Integer, 6]` --- matches an array containing at least six integers.
* `Array[Float, 6, 12]` --- matches an array containing at least six and at most 12 floating-point numbers.
* `Array[Variant[String, Integer]]` --- matches an array of any size that contains only strings and/or integers.
* `Array[Any, 2]` --- matches an array containing at least two elements, allowing any data type (including `Type` and `Resource`).

### Related Data Types

The abstract [`Tuple` data type][tuple] lets you specify data types for every element in an array, in order.

Several [abstract types][], including `Variant` and `Enum`, are useful when specifying content type for arrays that might include multiple kinds of data.
