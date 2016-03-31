---
layout: default
title: "Language: Type Aliases"
canonical: "/puppet/latest/reference/lang_type_aliases.html"
---

[reserved]: ./lang_reserved.html


Type aliases allow you to create reusable and descriptive types.

## Syntax

Type aliases are written as `type <NAME> = <TYPE DEFINITION>`, the alias `<NAME>` beginning with a capital letter. The alias name must not be a [reserved word][reserved]. 

As an example:

~~~
type MyType = Integer
~~~

Makes `MyType` equivalent to `Integer`.

This mechanism is used for several reasons:

* Gives a type a descriptive name such as `IPv6Addr`, rather than just using a complex pattern based type.
* Shortens complex type expressions and moves them "out of the way".
* Reuse of types increases the quality, as not everyone has to invent types like `IPv6Addr`.
* Type definitions can be tested separately.


## Location

Store the type aliases you write in your modules' `types` folder, which is a top-level directory, a sibling of `manifests` and `lib`. Define only one alias per file.

The name of the `.pp` file defining the alias must be the alias name in all lower case without underscore separators inserted at camel case positions. For example, `MyType` is expected to be loaded from a file named `"mytype.pp"`.

>**Note:** It is okay to use type aliases in manifests when showing examples, or doing experiments, but best practices dictate you should define them as outlined above in production scenarios.


## Recursive types

Creating recursive types is allowed:

~~~
type Tree = Array[Variant[Data, Tree]]
~~~

This type definition allows a tree that is built out of arrays that contain data, or a tree 

~~~
[1,2 [3], [4, [5, 6], [[[[1,2,3]]]]]]
~~~

A recursive alias may refer to the alias being declared, or other types.

This is a very powerful mechanism that allows higher quality type definitions. Earlier references like these were impossible, the only option was to use `Any`.


## Aliasing resource types

It is also possible to create aliases to resource types.

~~~
type MyFile = File
~~~

When doing this, use the short form such as `File` instead of `Resource[File]`.


## Type aliases and type references are transparent

The Puppet language aliases are transparent:

~~~
type MyInteger = Integer
notice MyInteger == Integer
~~~

The above notices `true`.

The internal type system types `TypeReference` and `TypeAlias` are never values in a Puppet program.