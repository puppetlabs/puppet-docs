---
layout: default
title: "Language: Data types: Sensitive"
canonical: "/puppet/latest/reference/lang_data_sensitive.html"
---

[arithmetic]: ./lang_expressions.html#arithmetic-operators
[data type]: ./lang_data_type.html
[variant]: ./lang_data_abstract.html#variant


Sensitive in the Puppet language are strings marked as sensitive, to prevent inadvertent leakage in logs and reports.

## Syntax

The Sensitive type can be written as `Sensitive.new(val)`, or the shortform `Sensitive(val)`

### Parameters

The full signature for `Integer` is:

    Sensitive[<STRING VALUE>]

It's worth noting that the Sensitive type is parameterized, but the parameterized type (the type of the value it contains) only retains the basic type as sensitive information about the length or details about the contained data value can otherwise be leaked.

It is therefore not possible to have detailed data types and expect that the data type match - for example Sensitive[Enum[red, blue, green]] will fail if a value of Sensitive('red') is given - thus when sensitive type is used, the type parameter must be generic - in the example a Sensitive[String] would match Sensitive('red').
