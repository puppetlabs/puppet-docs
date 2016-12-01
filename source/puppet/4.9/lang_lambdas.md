---
title: "Language: Lambdas (code blocks)"
layout: default
---

[define_unique]: ./lang_defined_types.html#resource-uniqueness
[functions]: ./lang_functions.html
[literal_types]: ./lang_data_type.html
[variable]: ./lang_variables.html
[defined type]: ./lang_defined_types.html
[resources]: ./lang_resources.html
[local scope]: ./lang_scope.html#local-scopes
[callable]: ./lang_data_abstract.html#callable
[array]: ./lang_data_array.html
[iteration]: ./lang_iteration.html

Lambdas are blocks of Puppet code that can be passed to [functions][]. When a function receives a lambda, it can provide values for the lambda's parameters and evaluate its code.

If you've used other programming languages, you can think of lambdas as simple anonymous functions, which can be passed to other functions.

## Location

_Lambdas can only be used in [function calls][functions]._ While any function can accept a lambda, only some functions will do anything with them. See [the Iteration and Loops page][iteration] for info on some of the most useful lambda-accepting functions.

Lambdas are not valid in any other place in the Puppet language, and cannot be assigned to variables.

## Syntax

Lambdas are written as a list of parameters surrounded by pipe (`|`) characters, followed by a block of arbitrary Puppet code in curly braces. They must be used as part of a [function call.][functions]

``` puppet
$binaries = ["facter", "hiera", "mco", "puppet", "puppetserver"]

# function call with lambda:
$binaries.each |String $binary| {
  file {"/usr/bin/$binary":
    ensure => link,
    target => "/opt/puppetlabs/bin/$binary",
  }
}
```

The general form of a lambda is:

* A **parameter list.** (Mandatory, but can be empty.) This consists of:
    * An opening pipe character (`|`).
    * A comma-separated list of zero or more **parameters** (e.g. `String $myparam = "default value"`). Each parameter consists of:
        * An optional [data type][literal_types], which restricts the values it allows (defaults to `Any`).
        * A [variable][] name to represent the parameter, including the `$` prefix.
        * An optional equals (`=`) sign and **default value.**
    * Optionally, another comma and an **extra arguments parameter** (e.g. `String *$others = ["default one", "default two"]`), which consists of:
        * An optional [data type][literal_types], which restricts the values allowed for extra arguments (defaults to `Any`).
        * An asterisk (AKA "splat") character (`*`).
        * A [variable][] name to represent the parameter, including the `$` prefix.
        * An optional equals (`=`) sign and **default value,** which can be:
            * One value that matches the specified data type.
            * An array of values that all match the data type.
    * An optional trailing comma after the last parameter.
    * A closing pipe character (`|`).
* An opening curly brace.
* A block of arbitrary Puppet code.
* A closing curly brace.


## Parameters and variables

A lambda can include a list of parameters, and functions can set values for them when they call the lambda. Inside the lambda's code block you can use each parameter as a variable.

Functions pass lambda parameters **by position,** the same way you pass arguments in a function call. This means that the _order_ of parameters is important, but their _names_ can be anything. (Unlike class or defined type parameters, where the names are the main interface for users.)

Each function decides how many parameters it will pass to a lambda, and in what order. See the function's documentation for details.

In the parameter list, each parameter can be preceeded by an optional [**data type**][literal_types]. If you include one, Puppet will check the parameter's value at runtime to make sure that it has the right data type, and raise an error if the value is illegal. If no data type is provided, the parameter will accept values of any data type.

### Mandatory and optional parameters

If a parameter has a default value, it's optional --- the lambda will use the default if the caller doesn't provide a value for that parameter.

However, since parameters are passed by position, _any optional parameters have to go after the required parameters._ If you put a required parameter after an optional one, it will cause an evaluation error. And if you have multiple optional parameters, the later ones can only receive values if all of the prior ones do.

### The extra arguments parameter

The _final_ parameter of a lambda can optionally be a special _extra arguments parameter,_ which will collect an unlimited number of extra arguments into an array. This is useful when you don't know in advance how many arguments the caller will provide.

To specify that the last parameter should collect extra arguments, write an asterisk/splat (`*`) in front of its name in the parameter list (like `*$others`). You can't put a splat in front of any parameter except the last one.

An extra arguments parameter is always optional.

The value of an extra arguments parameter is always an [array][], containing every argument in excess of the earlier parameters. If there are no extra arguments and no default value, it will be an empty array.

An extra arguments parameter can have a default value, which has some automatic array wrapping for convenience:

* If the provided default is a non-array value, the real default will be a single-element array containing that value.
* If the provided default is an array, the real default will be that array.

An extra arguments parameter can also have a [data type.][literal_types] Puppet will use this data type to validate _the elements_ of the array. That is, if you specify a data type of `String`, the final data type of the extra arguments parameter will be `Array[String]`.


## Behavior

Much like a [defined type][], a lambda delays evaluation of the Puppet code it contains, making it available for later.

Unlike defined types, lambdas aren't directly invoked by a user. The user provides a lambda to some _other_ piece of code (a function), and _that_ code gets to decide:

* Whether (and when) to call/evaluate the lambda.
* How many times to call it.
* What values its parameters should have.
* What to do with any values it produces (see [Lambda-Produced Values][inpage_values] below).

Some functions can call a single lambda multiple times, providing different parameter values each time. For info on how a particular function uses its lambda, see its documentation.

In this version of the Puppet language, the only way to call a lambda is to pass it to a [function][functions] that will call it.

### Resource uniqueness

If you use any [resource declarations][resources] in the body of a lambda, make sure those resources will be unique. Duplicate resources will cause a compilation failure.

This means that if a function might call its lambda multiple times, any resource titles in the lambda should include a parameter whose value will change with every call. In the example above, we used the `$binary` parameter in the title of the lambda's `file` resource:

``` puppet
file {"/usr/bin/$binary":
  ensure => link,
  target => "/opt/puppetlabs/bin/$binary",
}
```

When we called the `each` function, we knew the array we passed had no repeated values, which ensured unique `file` resources. However, if we were working with an array that came from less reliable external data, we might want to use [the `unique` function from `stdlib`](https://forge.puppetlabs.com/puppetlabs/stdlib#unique) to protect against duplicates.

This uniqueness requirement is [similar to defined types][define_unique], which are also blocks of Puppet code that can be evaluated multiple times.

### Lambda-produced values

[inpage_values]: #lambda-produced-values

Every time a lambda is called, it produces a value, which is the value of the last expression in the code block.

The function that calls the lambda has access to this value, but not every function will do something with it. Some functions will return it, some will transform it, some will ignore it, and some will use it to do something else entirely.

For example:

* The `with` function calls its lambda once and returns the resulting value.
* The `map` function calls its lambda multiple times and returns an array of every resulting value.
* The `each` function throws away its lambda's values and returns a copy of its main argument.


### Lambda scope

Every lambda creates its own [local scope][]. This local scope is anonymous, and variables inside it cannot be accessed by qualified names from any other scope.

The parent scope of a lambda is the local scope in which that lambda is written. So if a lambda is written inside a class definition, its code block can access local variables from that class, as well as variables from that class's ancestor scopes and from top scope.

Lambdas can contain other lambdas, which makes the outer lambda the parent scope of the inner one.


### Detailed behavior: The callable data type

Under the hood, a lambda is actually a value with [the Callable data type][callable], and functions using the modern function API (`Puppet::Functions`) can use that data type to validate any lambda values it receives.

However, the Puppet language doesn't provide any way to store or interact with Callable values except as lambdas provided to a function.
