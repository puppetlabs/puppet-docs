---
layout: default
title: "Language: About values and data types"
canonical: "/puppet/latest/lang_data.html"
---




## Values and data

Most of the things you can do with the Puppet language involve some form of data.

An individual piece of data is called a **value,** and every value has a **data type,** which determines what kind of information that value can contain and how you can interact with it.

Strings are the most common and useful data type, but you'll also have to work with others, including numbers, arrays, and some Puppet-specific data types like resource references.


## Puppet's data types

* [Strings](./lang_data_string.html)
* [Numbers](./lang_data_number.html)
* [Booleans](./lang_data_boolean.html)
* [Arrays](./lang_data_array.html)
* [Hashes](./lang_data_hash.html)
* [Regular Expressions](./lang_data_regexp.html)
* [Sensitive](./lang_data_sensitive.html)
* [Undef](./lang_data_undef.html)
* [Resource References](./lang_data_resource_reference.html)
* [Default](./lang_data_default.html)

## Literal data types as values

Although you'll mostly interact with values _of_ the various data types, Puppet also includes values like `String` that _represent_ data types.

You can use these special values to examine a piece of data or enforce rules. Most of the time, they act like patterns, similar to a regular expression: given a value and a data type, you can test whether the value _matches_ the data type. (And then either adjust your code's behavior accordingly, or raise an error if something has gone wrong.)

For the syntax and behavior of literal data types, see:

* [Data Type Syntax](./lang_data_type.html)

For info about each type's behavior, see the main data type pages listed above. Each of these pages gives details about using that data type as a value.

For special abstract data types, which you can use to do more sophisticated or permissive type checking, see:

* [Abstract Data Types](./lang_data_abstract.html)

