---
title: "Writing custom functions in Ruby: Overview and examples"
---


Puppet includes two Ruby APIs for writing custom functions. This page is about the modern API, which uses the `Puppet::Functions` namespace.

* If you want an easier way to write functions, try [writing them in the Puppet language.][func_puppet]
* If you absolutely must support Puppet 3, you can use [the legacy Ruby functions API;][func_legacy] otherwise, you should always use the API described on this page.

## Basic syntax for Ruby functions

``` ruby
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

* A function name.
* A block of code (which takes no arguments). This block should contain:
    * One or more signatures, to configure the function's arguments. To build signatures, use the `dispatch` method and the parameter methods.
    * An implementation method for each signature. The return value of the implementation method will be the return value of the function.

In summary, with the pieces labled:

``` ruby
Puppet::Functions.create_function(:<FUNCTION NAME>) do
  dispatch :<METHOD NAME> do
    param '<DATA TYPE>', :<ARGUMENT NAME (for display in docs and errors)>
    ...
  end

  def <METHOD NAME>(<ARGUMENT NAME (for local use)>, ...)
    <IMPLEMENTATION>
  end
end
```

## Detailed topics for Ruby functions

To effectively write functions in Ruby, you should get familiar with the following topics:

* [Naming functions][inpage_name] (below, on this page).
* [Defining function signatures][signatures] with the `dispatch` method and the parameter methods.
* [Advanced function API features][advanced], including:
    * Working with lambdas (blocks of Puppet code provided to a function).
    * Calling other functions from inside a function.
    * Accessing facts and other Puppet variables from a function.
    * Local data type aliases.
* [Documenting Ruby functions][documenting] to work well with Puppet Strings (a free documentation tool for Puppet).

## Naming functions

[inpage_name]: #naming-functions

{% partial ./_naming_functions.md %}


