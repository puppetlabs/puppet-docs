---
layout: default
title: "Language: Data types: Type aliases"
canonical: "/puppet/latest/reference/lang_data_aliases.html"
---

[built-in data types]: ./lang_data.html
[modules]: ./modules_fundamentals.html
[class parameters]: ./lang_classes.html#class-parameters-and-variables
[environments]: ./environments.html
[data type]: ./lang_data_type.html

In addition to Puppet's [built-in data types][], [modules][] may define their own **type aliases** to shorten and avoid duplication when using complex data types (e.g. variants, enums).

These aliases may be used in place of data types in any location --- [class parameters][], type comparisons and so on. Type aliases may also be used by other modules, allowing shared data types to be changed easily. The aliases defined will work identically to the assigned data type in all respects.

## Defining type aliases

### Syntax

You can use a `type` statement to define a new type alias:

``` puppet
type MyModule::Foo = Array[Integer]
```

This defines a new data type called `MyModule::Foo` which is equivalent to the data type `Array[Integer]`.

The general form of a type statement is:

* The `type` keyword
* The name of the type alias
* An equals (`=`) sign
* A [data type][] that the type alias will be equivalent to

### Naming

Type alias names must use namespace (prefix) when loaded from a module or environment.

When loaded from the module `my_module`, the alias must be defined in the `MyModule::` namespace.

When loaded from an environment, the alias must be in the fixed `Environment::` namespace.

### Location

Type aliases must be stored in [modules][] or [environments][]. Puppet is **automatically aware** of type aliases in modules and environments, and can autoload them by name.

Type aliases must be stored in their module's or environment's `types/` directory (see [Module Fundamentals][modules]) with one alias per file, and each filename must reflect the lower case name of its alias. Underscores should not be used to separate words in a filename; the file for `MyType` should be `mytype.pp`, not `my_type.pp`.

### Assigned data type

Any [data type][] may be assigned to the type alias, even the alias being defined (creating a _self recursive type_).
