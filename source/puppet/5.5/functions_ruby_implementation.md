---
title: "Writing functions in Ruby: Using special features in implementation methods"
---

[overview]: ./functions_ruby_overview.html
[signatures]: ./functions_ruby_signatures.html
[documenting]: ./functions_ruby_documenting.html
[parser scope]: ./yard/Puppet/Parser/Scope.html
[variables]: ./lang_variables.html
[facts]: ./lang_facts_and_builtin_vars.html
[trusted data]: ./lang_facts_and_builtin_vars.html#trusted-facts
[server data]: ./lang_facts_and_builtin_vars.html#serverfacts-variable
[lambdas]: ./lang_lambdas.html
[proc]: https://ruby-doc.org/core/Proc.html

For the most part, implementation methods are normal Ruby. However, there are some special features available for accessing Puppet variables, working with provided blocks of Puppet code, and calling other functions.

> **Note:** This is one of several pages describing the Ruby functions API. Before reading it, make sure you understand the [overview of this API][overview] and how to [define function signatures][signatures].


## Accessing Puppet variables

Most functions should only use the arguments they are passed. However, you also have the option of accessing globally-reachable [Puppet variables][variables]. The main use case for this is accessing [facts][], [trusted data][], or [server data][].

> **Note:** Functions cannot access **local** variables in the scope from which they were called. They can only access global variables or fully-qualified class variables.

To access variables, use the special `closure_scope` method, which takes no arguments and returns [a `Puppet::Parser::Scope` object][parser scope].

The only method you should call on the scope object is `#[](varname)`, which returns the value of the specified variable. Make sure to exclude the `$` from the variable name.

Example:

``` ruby
Puppet::Functions.create_function(:'mymodule::fqdn_rand') do
  dispatch :fqdn do
    # no arguments
  end

  def fqdn()
    scope = closure_scope
    fqdn = scope['facts']['networking']['fqdn']
    # ...
  end
end
```

## Working with lambdas (code blocks)

If their signatures allow it (see [Defining function signatures][signatures]), functions can accept [lambdas][] (blocks of Puppet code). Once a function _has_ a lambda, it will generally need to execute it.

To do this, use Ruby's normal block calling conventions.

### Checking for a block with `block_given?`

If your signature specified an optional code block, your implementation method can check for its presence with the `block_given?` method. This is `true` if a block was provided, `false` if not.

### Executing a block with `yield()`

When you know a block was provided, you can execute it any number of times with the `yield()` method.

The arguments to `yield` will be passed as arguments to the lambda; since your signature probably specified the number and type of arguments the lambda should expect, you should be able to call it with confidence.

The return value of the `yield` call will be the return value of the provided lambda.

### Capturing a block as a Proc

If you need to introspect a provided lambda, or pass it on to some other method, an implementation method can capture it as a [Proc][] by specifying an extra argument with an ampersand (`&`) flag. This works the same way as capturing a Ruby block as a Proc.

Once you've captured the block, you can execute it with `#call` instead of `yield`. You can also use any other Proc instance methods to examine it.

``` ruby
def implementation(arg1, arg2, *splat_arg, &block)
  # Now the `block` variable has the provided lambda, as a Proc.
  block.call(arg1, arg2, splat_arg)
end
```

## Calling other functions

If you want to call another Puppet function (like `include`) from inside a function, use the special `call_function(name, *args, &block)` method.

``` ruby
# Flatten an array of arrays of strings, then pass it to include:
def include_nested(array_of_arrays)
  call_function('include', *array_of_arrays.flatten)
end
```

* The first argument must be the name of the function to call, as a string.
* The next arguments can be any data type that the called function accepts. They will be passed as arguments to the called function.
* The last argument may be a Ruby Proc, or a Puppet [lambda][lambdas] previously captured as a Proc (see above). You can also provide a block of Ruby code using the normal block syntax.

``` ruby
def my_function1(a, b, &block)
  # passing given Proc
  call_function('my_other_function', a, b, &block)
end

def my_function2(a, b)
  # using a Ruby block
  call_function('my_other_function', a, b) { |x| ... }
end
```

## Next pages

To make this API reference easier to use, we've split some of its larger topics into separate pages. Please read the following pages to learn the remainder of the Ruby functions API:

* [Documenting Ruby functions][documenting]. Puppet Strings, a free documentation tool for Puppet, can extract documentation from functions and display it to your module's users. This page describes how to format your code comments to work well with Strings.
