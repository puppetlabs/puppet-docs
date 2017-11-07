---
layout: default
title: "Language: Data Types: Undef"
canonical: "/puppet/latest/lang_data_undef.html"
---


[resourcedefault]: ./lang_defaults.html
[data type]: ./lang_data_type.html
[data]: ./lang_data_abstract.html#data
[any]: ./lang_data_abstract.html#any
[optional]: ./lang_data_abstract.html#optional
[variant]: ./lang_data_abstract.html#variant
[notundef]: ./lang_data_abstract.html#notundef

Puppet's special `undef` value is roughly equivalent to `nil` in Ruby; it represents the absence of a value. If the `strict_variables` setting isn't enabled, variables which have never been declared have a value of `undef`.

The `undef` value is usually useful for testing whether a variable has been set. It can also be used as the value of a resource attribute, which can let you un-set any value inherited from a [resource default][resourcedefault] and cause the attribute to be unmanaged.

## Syntax

The only value in the undef data type is the bare word `undef`.

## Conversion

When used as a boolean, `undef` is false.

When interpolated into a string, `undef` will be converted to the empty string.

## The `Undef` Data Type

The [data type][] of `undef` is `Undef`.

It matches only the value `undef`, and takes no parameters.


### Related Data Types

Several of the abstract data types will also match the value `undef`:

* [The `Data` type][data] matches `undef` in addition to several other data types.
* [The `Any` type][any] matches any value, including `undef`.
* [The `Optional` type][optional] wraps one other data type, and returns a type that matches `undef` in addition to that type.
* [The `Variant` type][variant] can accept the `Undef` type as a parameter, which will make the resulting data type match `undef`.
* [The `NotUndef` type][notundef] matches any value except `undef`.
