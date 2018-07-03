---
layout: default
title: "Future Parser: Data Types: Booleans"
canonical: "/puppet/latest/reference/lang_data_boolean.html"
---

[if]: ./future_lang_conditional.html#if-statements
[comparison]: ./future_lang_expressions.html#comparison-operators
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[facts]: ./future_lang_variables.html#facts
[fact_datatypes]: ./future_lang_facts_and_builtin_vars.html#data-types
[function]: ./future_lang_functions.html
[abstract types]: ./future_lang_data_abstract.html
[data type]: ./future_lang_data_type.html


Booleans are one-bit values, representing true or false.

The condition of an ["if" statement][if] expects an expression that resolves to a boolean value. All of Puppet's [comparison operators][comparison] resolve to boolean values, as do many [functions][function].

## Syntax

The boolean data type has two possible values: `true` and `false`. Literal booleans must be one of these two bare words (that is, not quoted).

## Automatic Conversion to Boolean

If a non-boolean value is used where a boolean is required:

* The `undef` value is converted to boolean `false`.
* **All** other values are converted to boolean `true`.

Notably, this means the string values `""` (zero-length string) and `"false"` both resolve to `true`. If Puppet is configured to treat all [facts][] as strings, this can cause unexpected behavior; see [the docs on fact data types][fact_datatypes] for more info.

If you want to convert other values to booleans with more permissive rules (`0` as false, `"false"` as false, etc.), the [puppetlabs-stdlib][stdlib] module includes `str2bool` and `num2bool` functions.

## The `Boolean` Data Type

The [data type][] of boolean values is `Boolean`.

It matches only the values `true` or `false`, and accepts no parameters.


### Related Data Types

You can use [abstract types][] to match values that might be boolean or might have some other value. For example, `Optional[Boolean]` will match `true`, `false`, or `undef`. `Variant[Boolean, Enum["true", "false"]]` will match stringified booleans as well as true booleans.
