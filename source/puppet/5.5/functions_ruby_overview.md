---
title: "Writing functions in Ruby: Overview and examples"
---

[signatures]: ./functions_ruby_signatures.html
[implementation]: ./functions_ruby_implementation.html
[documenting]: ./functions_ruby_documenting.html
[func_puppet]: ./lang_write_functions_in_puppet.html
[func_legacy]: ./functions_legacy.html
[module]: ./modules_fundamentals.html
[environment]: ./environments.html
[symbol]: https://ruby-doc.org/core/Symbol.html
[data types]: ./lang_data_type.html
[boolean]: ./lang_data_boolean.html
[undef]: ./lang_data_undef.html
[string]: ./lang_data_string.html
[number]: ./lang_data_number.html
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html
[default]: ./lang_data_default.html
[regexp]: ./lang_data_regexp.html
[resource reference]: ./lang_data_resource_reference.html
[lambda]: ./lang_lambdas.html
[data type]: ./lang_data_type.html

Puppet includes two Ruby APIs for writing custom functions. This page is about the modern API, which uses the `Puppet::Functions` namespace.

-   If you want an easier way to write functions, try [writing them in the Puppet language.][func_puppet]
-   If you absolutely must support Puppet 3, you can use [the legacy Ruby functions API.][func_legacy]

## Basic syntax

``` ruby
# /etc/puppetlabs/code/environments/production/modules/mymodule/lib/puppet/functions/mymodule/upcase.rb
Puppet::Functions.create_function(:'mymodule::upcase') do
  dispatch :up do
    param 'String', :some_string
  end

  def up(some_string)
    some_string.upcase
  end
end
```

To write a new function in Ruby, use the `Puppet::Functions.create_function` method. You don't need to `require` any Puppet libraries to make it available; Puppet handles that automatically when it loads the function file.

The `create_function` method requires:

-   A function name.
-   A block of code (which takes no arguments). This block should contain:
    -   One or more signatures, to configure the function's arguments. To build signatures, use the `dispatch` method and the parameter methods. [Signatures are fully described in a separate page.][signatures]
    -   An implementation method for each signature. The return value of the implementation method will be the return value of the function.

In summary, with the pieces labled:

``` ruby
Puppet::Functions.create_function(:<FUNCTION NAME>) do
  dispatch :<METHOD NAME> do
    param '<DATA TYPE>', :<ARGUMENT NAME (displayed in docs/errors)>
    ...
  end

  def <METHOD NAME>(<ARGUMENT NAME (for local use)>, ...)
    <IMPLEMENTATION>
  end
end
```

## Location

A Ruby function must be placed in its own file, in the `lib/puppet/functions` directory of either a [module][] or an [environment][].

The filename must match the name of the function, and have the `.rb` extension. For namespaced functions, each segment prior to the final one must be a subdirectory of `functions`, and the final segment must be the filename.

Examples:

Function name         | File location
----------------------|--------------
`upcase`              | `<MODULES DIR>/mymodule/lib/puppet/functions/upcase.rb`
`upcase`              | `/etc/puppetlabs/code/environments/production/lib/puppet/functions/upcase.rb`
`mymodule::upcase`    | `<MODULES DIR>/mymodule/lib/puppet/functions/mymodule/upcase.rb`
`environment::upcase` | `/etc/puppetlabs/code/environments/production/lib/puppet/functions/environment/upcase.rb`

## Function names

Function names generally resemble these examples:

-   `num2bool` (a function that could come from anywhere)
-   `postgresql::acls_to_resource_hash` (a function in the `postgresql` module)
-   `environment::hash_from_api_call` (a function in an environment)

Function names are almost the same as [class names](./lang_reserved.html#classes-and-defined-resource-types). They consist of one or more segments. Each segment must start with a lowercase letter, and can include:

-   Lowercase letters
-   Numbers
-   Underscores

If a name has multiple segments, they are separated by the double-colon (`::`) namespace separator.

In other words, each segment should match this regular expression:

    \A[a-z][a-z0-9_]*\Z

The full name should match this regular expression:

    \A([a-z][a-z0-9_]*)(::[a-z][a-z0-9_]*)*\Z

Function names can be either _global_ or _namespaced._

-   Global names have only one segment (like `str2bool`), and can be used in any module or environment.

    Global names are shorter, but they're not guaranteed to be unique --- two modules might use the same function name, in which case Puppet won't necessarily load the one you want.
-   Namespaced names have multiple segments (like `stdlib::str2bool`), and are guaranteed to be unique. The first segment is dictated by the function's location:
    -   In an environment, it must be the literal word `environment` (like `environment::str2bool`).
    -   In a module, it must be the module's name (like `stdlib::str2bool`, for a function stored in the `stdlib` module).

Most functions have two name segments, although it's legal to use more.

Some illegal function names:

-   `6_pack` (must start with a letter)
-   `_hash_from_api_call` (must start with a letter)
-   `Find-Resource` (can only contain lowercase letters, numbers, and underscores)

### Pass names to `create_function` as symbols

When you call the `Puppet::Functions.create_function` method, you should pass the function's name to it as a Ruby [symbol][]. (Although it can accept a string, we recommend always using a symbol.)

To turn a function name into a symbol:

-   If the name is global, prefix it with a colon (like `:str2bool`).
-   If it's namespaced: quote the name, then prefix the full quoted string with a colon (like `:'stdlib::str2bool'`).

## Behavior of Ruby functions

Ruby functions can have multiple signatures. When a function is called, Puppet checks each signature in order, comparing the allowed arguments to the arguments that were actually passed. Arguments are checked using Puppet's [data type system][data types], the same way class parameters are checked.

As soon as Puppet finds a signature that can accept the provided arguments, it calls the associated implementation method, passing the arguments to that method. When the method finishes running and returns a value, Puppet uses that as the function's return value.

If none of the function's signatures match the provided arguments, Puppet fails compilation and logs an error message describing the mismatch between the provided and expected arguments.

### Conversion of Puppet and Ruby data types

When function arguments are passed to a Ruby method, they're converted to Ruby objects. Similarly, the method's return value is converted to a Puppet data type when the Puppet manifest regains control.

Puppet converts data types between the Puppet language and Ruby as follows:

Puppet type             | Ruby class
------------------------|-------------------------------------------------------------------------------
[Boolean][]             | `Boolean`
[Undef][]               | `NilClass` (value `nil`)
[String][]              | `String`
[Number][]              | subtype of `Numeric`
[Array][]               | `Array`
[Hash][]                | `Hash`
[Default][]             | `Symbol` (value `:default`)
[Regexp][]              | `Regexp`
[Resource reference][]  | `Puppet::Pops::Types::PResourceType`, or `Puppet::Pops::Types::PHostClassType`
[Lambda][] (code block) | `Puppet::Pops::Evaluator::Closure`
[Data type][] (`Type`)  | A type class under `Puppet::Pops::Types`, such as `Puppet::Pops::Types::PIntegerType`

When writing iterative functions, use [iterative types](./functions_iterative.html) instead of Puppet types.

## Next pages

To make this API reference easier to use, we've split some of its larger topics into separate pages. Please read the following pages to learn the remainder of the Ruby functions API:

-   [Defining function signatures][signatures]. This page describes the `dispatch` method and the parameter methods.
-   [Using special features in implementation methods][implementation]. For the most part, implementation methods are basic Ruby. However, there are some special features available for accessing Puppet variables, working with provided blocks of Puppet code, and calling other functions.
-   [Documenting Ruby functions][documenting]. Puppet Strings, a free documentation tool for Puppet, can extract documentation from functions and display it to your module's users. This page describes how to format your code comments to work well with Strings.
