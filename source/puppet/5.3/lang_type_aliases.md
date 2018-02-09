---
layout: default
title: "Language: Type Aliases"
---

[reserved]: ./lang_reserved.html

Type aliases allow you to create reusable and descriptive data and resource types.

## Creating type aliases

Type aliases are written as:

``` puppet
type <MODULE NAME>::<ALIAS NAME> = <TYPE DEFINITION>
```

The `<MODULE NAME>` must be named after the module that contains the type alias, and both the `<MODULE NAME>` and `<ALIAS NAME>` begin with a capital letter and must not be a [reserved word][reserved].

For example, you can create a type alias named `MyType` that is equivalent to the `Integer` data type:

``` puppet
type MyModule::MyType = Integer
```

You can then declare a parameter using the alias as though it were a unique data type:

``` puppet
MyModule::MyType $example = 10
```

By using type aliases, you can:

-   Give a type a descriptive name, such as `IPv6Addr`, instead of creating or using a complex pattern-based type.
-   Shorten and move complex type expressions.
-   Improve code quality by reusing existing types instead of inventing new types.
-   Test type definitions separately from manifests.

### Type alias transparency

Type aliases are transparent, which means they are fully equivalent to the types of which they are aliases. For instance, this example's `notice` returns `true` because `MyType` is an alias of the `Integer` type:

``` puppet
type MyModule::MyType = Integer
notice MyModule::MyType == Integer
```

> **Note:** The internal types `TypeReference` and `TypeAlias` are never values in Puppet code.

## Organizing type alias defintiions

If you define type aliases inside of manifests that contain other Puppet code, you make it more difficult to find where and how they are defined. It's easier to maintain and diagnose problems with type aliases by placing them into files within their own directory of your Puppet module.

Store type aliases as `.pp` files in your module's `types` directory, which is a top-level directory and sibling of the `manifests` and `lib` directories. Define only one alias per file, and name the file after the type alias name converted to lowercase. For example, `MyType` is expected to be loaded from a file named `mytype.pp`.

## Creating recursive types

You can create recursive types:

``` puppet
type MyModule::Tree = Array[Variant[Data, Tree]]
```

This `Tree` type alias is defined as a being built out of Arrays that contain Data, or a Tree:

```
[1,2 [3], [4, [5, 6], [[[[1,2,3]]]]]]
```

A recursive alias can refer to the alias being declared, or to other types.

This powerful mechanism allows you to define complex, descriptive type definitions instead of using the `Any` type.

## Aliasing resource types

You can also create aliases to resource types.

``` puppet
type MyModule::MyFile = File
```

When defining an alias to a resource type, use its short form (such as `File`) instead of its long form (such as `Resource[File]`).

## Related topics

-   [Data types](./lang_data_type.md)
-   [Resources](./lang_resources.md)
