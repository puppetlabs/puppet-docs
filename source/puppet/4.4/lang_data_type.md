---
layout: default
title: "Language: Data Types: Data Type Syntax"
canonical: "/puppet/latest/lang_data_type.html"
---

[classes]: ./lang_classes.html
[defined types]: ./lang_defined_types.html
[lambdas]: ./lang_lambdas.html
[case statements]: ./lang_conditional.html#case-statements
[selector expressions]: ./lang_conditional.html#selectors
[match_operator]: ./lang_expressions.html#regex-or-data-type-match
[strings]: ./lang_data_string.html
[assert_type]: ./function.html#asserttype
[number]: ./lang_data_number.html
[boolean]: ./lang_data_boolean.html
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html
[regexp]: ./lang_data_regexp.html
[undef]: ./lang_data_undef.html
[default]: ./lang_data_default.html
[resource_reference]: ./lang_data_resource_reference.html
[scalar]: ./lang_data_abstract.html#scalar
[collection]: ./lang_data_abstract.html#collection
[variant]: ./lang_data_abstract.html#variant
[data]: ./lang_data_abstract.html#data
[pattern]: ./lang_data_abstract.html#pattern
[enum]: ./lang_data_abstract.html#enum
[tuple]: ./lang_data_abstract.html#tuple
[struct]: ./lang_data_abstract.html#struct
[optional]: ./lang_data_abstract.html#optional
[catalogentry]: ./lang_data_abstract.html#catalogentry
[any]: ./lang_data_abstract.html#any
[callable]: ./lang_data_abstract.html#callable
[stdlib]: https://forge.puppetlabs.com/puppetlabs/stdlib

Each value in the Puppet language has a data type, like "string." There is also a set of values _whose data type is "data type."_

These values represent the other data types. For example, the value `String` represents the data type of [strings][].

(The value that represents the data type of _these_ values is `Type`.)

You can use these special values to examine a piece of data or enforce rules --- for example, you can test whether something is a string with the expression `$possible_string =~ String`, or specify that a class parameter requires string values like `class myclass (String $string_parameter = "default value") { ... }`.

## Syntax

Data types are written as unquoted upper-case words, like `String`.

Data types sometimes take parameters, which make them more specific. (For example, `String[8]` is the data type of strings with a minimum of eight characters.)

Each known data type defines how many parameters it accepts, what values those parameters take, and the order in which they must be given. Some of the abstract types _require_ parameters, and most types have some optional parameters available.

The general form of a data type is:

* An upper-case word matching one of the known data types.
* Sometimes, a **set of parameters,** which consists of:
    * An opening square bracket (`[`) after the type's name. (There can't be any space between the name and the bracket.)
    * A comma-separated list of values or expressions --- arbitrary whitespace is allowed, but you can't have a trailing comma after the final value.
    * A closing square bracket (`]`).

For example:

~~~ ruby
    Variant[Boolean, Enum['true', 'false', 'running', 'stopped']]
~~~

This is an abstract data type (`Variant`) which takes any number of data types as parameters; one of the parameters we provided is _another_ abstract data type (`Enum`) that takes any number of strings as parameters.

> ### Note on Required Parameters
>
> The only situation where you can leave out required parameters is if you're referring to the type itself; that is, `Type[Variant]` is legal, even though `Variant` has required parameters.

## Usage

Data types are useful in parameter lists, match (`=~`) expressions, case statements, and selector expressions. There are also a few less common uses for them.

### Parameter Lists

[Classes][], [defined types][], and [lambdas][] all let you specify _parameters,_ which let your code request data from a user or some other source.

Generally, your code expects each parameter to be a specific kind of data. You can enforce that expectation by putting a data type before that parameter's name in the parameter list. At evaluation time, Puppet will raise an error if any parameter receives an illegal value.

For example:

~~~ ruby
class ntp (
  Boolean $service_manage = true,
  Boolean $autoupdate     = false,
  String  $package_ensure = 'present',
  # ...
) {
  # ...
}
~~~

If you tried to set `$autoupdate` to a string like `"true"`, Puppet would raise an error, since it expects a legit boolean value.

Abstract data types can let you write more sophisticated and flexible restrictions. For example, this `$puppetdb_service_status` parameter would accept values of `true`, `false`, `"true"`, `"false"`, `"running"`, and `"stopped"`, and raise an error for any other value:

~~~ ruby
class puppetdb::server (
  Variant[Boolean, Enum['true', 'false', 'running', 'stopped']]
    $puppetdb_service_status = $puppetdb::params::puppetdb_service_status,
) inherits puppetdb::params {
  # ...
}
~~~


### Cases

[Case statements][] and [selector expressions][] both allow data types as their _cases._ Puppet will choose a data type case if the control expression resolves to a value of that data type. For example:

~~~ ruby
$enable_real = $enable ? {
  Boolean => $enable,
  String  => str2bool($enable),
  Numeric => num2bool($enable),
  default => fail('Illegal value for $enable parameter'),
}
~~~

### Match Expressions

[The `=~` and `!~` match operators][match_operator] can accept a data type on the right operand, and will test whether the left operand is a value of that data type.

For example: `5 =~ Integer` and `5 =~ Integer[1,10]` both resolve to `true`.

### Less Common Uses

The built-in [`assert_type` function][assert_type] takes a value and a data type, and will raise errors if your code encounters an illegal value. It's basically a shorthand for an `if` statement with a non-match (`!~`) expression and a `fail()` function call.

You can also provide data types as both operands for the `==`, `!=`, `<`, `>`, `<=`, and `>=` comparison operators, which tests whether two data types are equal, whether one is a subset of another, etc. This feature doesn't have any particular practical use.

### Obtaining Data Types

[The `puppetlabs/stdlib` module][stdlib] includes a `type_of` function, which can return the type of any value. E.g. `type_of(3)` returns `Integer[3,3]`.


## Known Data Types

The following data types are available in Puppet:

### Core Data Types

These are the "real" data types, which make up the most common values you'll interact with in the Puppet language.

* [`String`][strings]
* [`Integer`, `Float`, and `Numeric`][number]
* [`Boolean`][boolean]
* [`Array`][array]
* [`Hash`][hash]
* [`Regexp`][regexp]
* [`Undef`][undef]
* [`Default`][default]

### Resource and Class References

Resource references and class references are implemented as data types, although they behave somewhat differently from other values.

* [`Resource` and `Class`][resource_reference]


### Abstract Data Types

Abstract data types let you do more sophisticated or permissive type checking.

* [`Scalar`][Scalar]
* [`Collection`][Collection]
* [`Variant`][Variant]
* [`Data`][Data]
* [`Pattern`][Pattern]
* [`Enum`][Enum]
* [`Tuple`][Tuple]
* [`Struct`][Struct]
* [`Optional`][Optional]
* [`Catalogentry`][Catalogentry]
* [`Type`][inpage_type]
* [`Any`][Any]
* [`Callable`][Callable]

## The `Type` Data Type

[inpage_type]: #the-type-data-type

The data type of literal data type values is `Type`.

By default, `Type` matches any value that represents a data type, such as `Integer`, `Integer[0,800]`, `String`, `Enum["running", "stopped"]`, etc.

You can use parameters to restrict which values `Type` will match.

### Parameters

The full signature for `Type` is:

    Type[<ANY DATA TYPE>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Any data type | `Type` | `Any` | A data type, which will cause the resulting `Type` object to only match against _that type_ or _types that are more specific subtypes of that type._

### Examples

* `Type` --- matches any data type, such as `Integer`, `String`, `Any`, or `Type`.
* `Type[String]` --- matches the data type `String`, as well as any of its more specific subtypes like `String[3]` or `Enum["running", "stopped"]`.
* `Type[Resource]` --- matches any `Resource` data type --- that is, any resource reference.

