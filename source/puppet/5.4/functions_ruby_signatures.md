---
title: "Writing functions in Ruby: Defining function signatures"
---

[overview]: ./functions_ruby_overview.html
[symbol]: https://ruby-doc.org/core/Symbol.html
[ruby_string]: https://ruby-doc.org/core/String.html
[data type]: ./lang_data_type.html
[lambda]: ./lang_lambdas.html
[call]: ./lang_functions.html
[callable]: ./lang_data_abstract.html#callable
[variant]: lang_data_abstract.html#variant
[implementation]: ./functions_ruby_implementation.html
[documenting]: ./functions_ruby_documenting.html


Functions can specify how many arguments they expect, and can specify a data type for each argument. The rule set for a function's arguments is called a **signature.**

Since Puppet functions support more advanced argument checking than Ruby does, the functions API uses a lightweight domain-specific language (DSL) to specify signatures.

> **Note:** This is one of several pages describing the Ruby functions API. Before reading it, make sure you understand the [overview of this API.][overview]


## Number of signatures

A function written in Ruby can have more than one signature.

Using multiple signatures is an easy way to have a function behave differently when passed different types or quantities of arguments --- instead of writing complex logic to decide what to do, you can write separate implementations and let Puppet figure out which one to use.

If a function has multiple signatures, Puppet checks them in the order they're written and uses the first one to match the provided arguments.

## Using automatic signatures

If your function only needs one signature, and you're willing to skip the API's data type checking, you can use an automatic signature. To do so:

* Do not write a `dispatch` block.
* Define one implementation method whose name _matches the final namespace segment_ of the function's name.

``` ruby
Puppet::Functions.create_function(:'stdlib::camelcase') do
  def camelcase(str)
    str.split('_').map{|e| e.capitalize}.join
  end
end
```

In this case, since the last segment of `stdlib::camelcase` is `camelcase`, we must define a method named `camelcase`.

### Drawbacks of automatic signatures

Although functions with automatic signatures are simpler to write, they give worse error messages when called incorrectly. Users will get a useful error if they call the function with a wrong number of arguments, but if they give the wrong _type_ of argument, they'll get something unhelpful. (For example, if you pass the function above a number instead of a string, it reports `Error: Evaluation Error: Error while evaluating a Function Call, undefined method 'split' for 5:Fixnum at /Users/nick/Desktop/test2.pp:7:8 on node magpie.lan`.)

If your function might be used by anyone other than yourself, you should support your users by writing a signature with `dispatch`.

## Writing signatures with `dispatch`

To write a signature, use the `dispatch` method.

``` ruby
  # A signature that takes a single string argument
  dispatch :camelcase do
    param 'String', :input_string
    return_type 'String' # optional
  end
```

`dispatch` takes:

* The name of an implementation method, provided as a Ruby [symbol][].
    * The corresponding method must be defined somewhere in the `create_function` block, usually after all the signatures.
* A block of code, which should only contain calls to the parameter and return methods (described below).


## Parameter methods

In the code block of a `dispatch` statement, you can specify arguments with special parameter methods. All of these methods take two arguments:

* The allowed data type for the argument, as a [string][ruby_string].
    * Types are specified using Puppet's [data type syntax][data type].
* A user-facing name for the argument, as a [symbol][].
    * This name is only used in documentation and error messages; it doesn't have to match the argument names in the implementation method.

The order in which you call these methods is important: the function's first argument should go first, the second one second, etc.

The following parameter methods are available:

Method name                                   | Description
----------------------------------------------|------------
`param` or `required_param`                   | A mandatory argument. You can use any number of these. **Position:** All mandatory arguments must come first.
`optional_param`                              | An argument that can be omitted. You can use any number of these. When there are multiple optional arguments, users can only pass latter ones if they also provide values for the prior ones. This also applies to repeated arguments. **Position:** Must come _after_ any required arguments.
`repeated_param` or `optional_repeated_param` | A repeatable argument, which can receive zero or more values. A signature can only use one repeatable argument. **Position:** Must come _after_ any non-repeating arguments.
`required_repeated_param`                     | A repeatable argument, which must receive one or more values. A signature can only use one repeatable argument. **Position:** Must come _after_ any non-repeating arguments.
`block_param` or `required_block_param`       | A mandatory [lambda][] (block of Puppet code). A signature can only use one block. **Position:** Must come _after_ all other arguments.
`optional_block_param`                        | An optional [lambda][] (block of Puppet code). A signature can only use one block. **Position:** Must come _after_ all other arguments.

### More about repeatable arguments

When specifying a repeatable argument, note that:

* In your implementation method, the repeatable argument appears as an array, which contains all the provided values that weren't assigned to earlier, non-repeatable arguments.
* The specified data type is matched against _each value_ for the repeatable argument, not the repeatable argument as a whole. For example, if you want to accept any number of numbers, you should specify `repeated_param 'Numeric', :values_to_average`, not `repeated_param 'Array[Numeric]', :values_to_average`.

### More about blocks of code

Functions can receive blocks of Puppet code, as described in [the docs on calling functions.][call]

The data type for a block argument should always be [`Callable`][callable], or a [`Variant`][variant] that only contains `Callable`s.

The `Callable` type can optionally specify the type and quantity of parameters that the lambda should accept; for example, `Callable[String, String]` matches any lambda that can be called with a pair of strings. For more details, [see the docs on the `Callable` type.][callable]

For details on how to execute a provided block in your implementation method, see [Using special features in implementation methods.][implementation]

### Matching arguments with implementation methods

The implementation method that corresponds to a signature must be able to accept any combination of arguments that the signature might allow.

Most notably, this means:

* If the signature has optional arguments, the corresponding method arguments need default values. Otherwise, the function will fail if the arguments are omitted.

  For example:

  ``` ruby
  dispatch :epp do
    required_param 'String', :template_file
    optional_param 'Hash', :parameters_hash
  end

  def epp(template_file, parameters_hash = {})
    # Note that parameters_hash defaults to an empty hash.
  end
  ```

* If the signature has a repeatable argument, the method must use a splat parameter (like `*args`) as its final argument.

  For example:

  ``` ruby
  dispatch :average do
    required_repeated_param 'Numeric', :values_to_average
  end

  def average(*values)
    # Inside the method, the `values` variable will be an array of numbers.
  end
  ```

## The `return_type` method

> **Note:** `return_type` only works with Puppet 4.7 and later. In earlier versions of Puppet, it will cause an evaluation error.

After specifying a signature's arguments, you can use the `return_type` method to specify the data type of its return value. This method takes one argument: a [Puppet data type][data type], specified as a string.

``` ruby
dispatch :camelcase do
  param 'String', :input_string
  return_type 'String'
end
```

The return type serves two purposes: documentation, and insurance.

* Puppet Strings can include information about the return value of a function.
* If something goes wrong and your function returns the wrong type (like `nil` when a string is expected), it will fail early with an informative error instead of allowing compilation to continue with an incorrect value.

## Specifying local type aliases

> **Note:** Local type aliases only work with Puppet 4.5 and later. In earlier versions of Puppet, they will cause an evaluation error.

If you are using complicated [abstract data types][] to validate arguments, and if you need to use these types in multiple signatures, they can sometimes become difficult to work with.

In these cases, you can specify short aliases for your complex types and use the short names in your signatures. Centralizing the complex part like this can make your function more maintainable by reducing copy-pasted code.

To specify aliases, use the `local_types` method.

* You must call `local_types` only once, _before_ any signatures.
* `local_types` takes a block, which should only contain calls to the `type` method.
* The `type` method takes a single [string][] argument, of the form `'<NAME> = <TYPE>'`.
    * The name should be a capitalized, CamelCase word, similar to a Ruby class name or the existing [Puppet data types][data type].
    * The type should be a valid [Puppet data type][data type].

Example:

``` ruby
local_types do
  type 'PartColor = Enum[blue, red, green, mauve, teal, white, pine]'
  type 'Part = Enum[cubicle_wall, chair, wall, desk, carpet]'
  type 'PartToColorMap = Hash[Part, PartColor]'
end

dispatch :define_colors do
  param 'PartToColorMap', :part_color_map
end

def define_colors(part_color_map)
  # etc
end
```

## Next pages

To make this API reference easier to use, we've split some of its larger topics into separate pages. Please read the following pages to learn the remainder of the Ruby functions API:

* [Using special features in implementation methods][implementation]. For the most part, implementation methods are basic Ruby. However, there are some special features available for accessing Puppet variables, working with provided blocks of Puppet code, and calling other functions.
* [Documenting Ruby functions][documenting]. Puppet Strings, a free documentation tool for Puppet, can extract documentation from functions and display it to your module's users. This page describes how to format your code comments to work well with Strings.
