---
layout: default
title: "Language: Type Aliases"
canonical: "/puppet/latest/lang_type_aliases.html"
---

[reserved]: ./lang_reserved.html

Type aliases allow you to create reusable and descriptive data and resource types.

## Creating type aliases

Type aliases are written as `type <NAME> = <TYPE DEFINITION>`. The alias `<NAME>` begins with a capital letter and must not be a [reserved word][reserved].

This example makes the type alias `MyType` equivalent to the `Integer` data type:

``` puppet
type MyType = Integer
```

You can then declare a parameter using the alias as though it were a unique type:

``` puppet
MyType $example = 10
```

By using type aliases, you can:

-   Give a type a descriptive name, such as `IPv6Addr`, instead of creating or using a complex pattern-based type.
-   Shorten and move complex type expressions.
-   Improve code quality by reusing existing types instead of inventing new types.
-   Test type definitions separately.

### Type alias transparency

Puppet language aliases are transparent. This example's `notice` returns `true`:

``` puppet
type MyInteger = Integer
notice MyInteger == Integer
```

> **Note:** The internal types `TypeReference` and `TypeAlias` are never values in a Puppet program.

## Organizing type alias defintiions

Store type aliases in your module's `types` directory, which is a top-level directory and sibling of the `manifests` and `lib` directories. Define only one alias per file.

The name of the `.pp` file defining the alias must be the same as the alias name, in all lower case and without underscore separators inserted at camel case positions. For example, `MyType` is expected to be loaded from a file named `mytype.pp`.

> **Warning:** For production Puppet deployments, do not define type aliases inside of other manifests. Keep type aliases organized into their own files within the `types` directory.

## Creating recursive types

You can create recursive types:

``` puppet
type Tree = Array[Variant[Data, Tree]]
```

This type definition allows a tree built out of arrays that contain data, or a tree:

```
[1,2 [3], [4, [5, 6], [[[[1,2,3]]]]]]
```

A recursive alias can refer to the alias being declared, or to other types.

This is a very powerful mechanism that allows higher quality type definitions that don't require you to use the `Any` type.

## Aliasing resource types

You can also create aliases to resource types.

``` puppet
type MyFile = File
```

Use the resource type's short form, such as `File`, instead of `Resource[File]`.

## Related topics

-   [Data types](./lang_data_types.md)
-   [Resources](./lang_resources.md)
