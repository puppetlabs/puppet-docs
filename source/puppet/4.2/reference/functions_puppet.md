---
layout: default
title: "Writing Functions in the Puppet Language"
canonical: "/puppet/latest/functions_puppet.html"
---

[defined_types]: ./lang_defined_types.html
[literal_types]: ./lang_data_type.html
[modules]: ./modules_fundamentals.html
[naming]: ./lang_reserved.html#classes-and-types
[namespaces]: ./lang_namespaces.html
[resource]: ./lang_resources.html
[resource_defaults]: ./lang_defaults.html
[references_namespaced]: ./lang_data_resource_reference.html
[function_call]: ./lang_functions.html#choosing-a-call-style
[classes]: ./lang_classes.html
[variable]: ./lang_variables.html
[array]: ./lang_data_array.html

You can write your own functions in the Puppet language to transform data and construct values. Functions can optionally take one or more parameters as arguments, then return some other, resulting value from the final expression.

## Syntax

The general form of a function written in Puppet language is:

* The [name][naming] of the function
* An optional **parameter list,** which consists of:
    * An opening parenthesis
    * A comma-separated list of **parameters** (e.g. `String $myparam = "default value"`). Each parameter consists of:
        * An optional [data type][literal_types], which will restrict the allowed values for the parameter (defaults to `Any`)
        * A [variable][] name to represent the parameter, including the `$` prefix
        * An optional equals (`=`) sign and **default value** (which must match the data type, if one was specified)
    * An optional trailing comma after the last parameter
    * A closing parenthesis
* An opening curly brace
* A block of Puppet code
* A closing curly brace

~~~ ruby
function <NAME>(<PARAMETER LIST>) {
  ... body of function ...
  final expression, which will be the returned value of the function
}
~~~


### Parameters

Functions are passed arguments by **parameter position.** This means that the _order_ of parameters is important, and the paramater names will not affect the order they are passed.

#### Mandatory and Optional Parameters

If a parameter has a default value, it's optional --- the function will use the default if the caller doesn't provide a value for that parameter.

If you reference a variable in a default value for a parameter, Puppet will always start looking for that variable at top scope. So if you use `$fqdn`, but then you call the function from a class that overrides the variable `$fqdn`, the parameter's default value will be the value from top scope, not the value from the class. You can reference qualified variable names in a function default value, but compilation will fail if that class wasn't declared by the time the function gets called.

However, since parameters are passed by position, _any optional parameters have to be listed after all required parameters._ You cannot put a required parameter after an optional one, because it will cause an evaluation error.


#### The Extra Arguments Parameter

The _final_ parameter of a function can optionally be a special _extra arguments parameter,_ which will collect an unlimited number of extra arguments into an array. This is useful when you don't know in advance how many arguments the caller will provide.

To specify that the last parameter should collect extra arguments, write an asterisk/splat (`*`) in front of its name in the parameter list (like `*$others`). You can't put a splat in front of any parameter except the last one.

An extra arguments parameter is always optional.

The value of an extra arguments parameter is always an [array][], containing every argument in excess of the earlier parameters. If there are no extra arguments and no default value, it will be an empty array.

An extra arguments parameter can have a default value, which has some automatic array wrapping for convenience:

* If the provided default is a non-array value, the real default will be a single-element array containing that value.
* If the provided default is an array, the real default will be that array.

An extra arguments parameter can also have a [data type.][literal_types] Puppet will use this data type to validate _the elements_ of the array. That is, if you specify a data type of `String`, the final data type of the extra arguments parameter will be `Array[String]`.


### The Function Body

Functions are meant for constructing values and transforming data, so the body of your function code will differ based on what you're trying to achieve with your function, and the parameters that you're requiring. You should avoid declaring resources in the body of your function. If you want to create resources based on inputs, that's what [defined types][defined_types] are for.

The final expression in the function body will be the value returned by the function.

~~~ ruby
function apache::bool2http($arg) {
  case $arg {
    false, undef, /(?i:false)/ : { 'Off' }
    true, /(?i:true)/          : { 'On' }
    default               : { "$arg" }
  }
}
~~~

Most conditional expressions in the Puppet language have values that work in a similar way, so you can use an if statement or a case statement as the final expression to give different values based on different numbers or types of inputs.



~~~ ruby
# This internal function translates the ipv(4|6)acls format into a resource
# suitable for create_resources. It is not intended to be used outside of the
# postgresql internal classes/defined resources.
#
# This function accepts an array of strings that are pg_hba.conf rules. It
# will return a hash that can be fed into create_resources to create multiple
# individual pg_hba_rule resources.
#
# The second parameter is an identifier that will be included in the namevar
# to provide uniqueness. It must be a string.
#
# The third parameter is an order offset, so you can start the order at an
# arbitrary starting point.
#
function postgresql::acls_to_resource_hash(Array $acls, String $id, Integer $offset) {

  $func_name = "postgresql::acls_to_resources_hash()"

  # The final hash is constructed as an array of individual hashes
  # (using the map function), the result of that
  # gets merged at the end (using reduce).
  #
  $resources = $acls.map |$index, $acl| {
    $parts = $acl.split('\s+')
    unless $parts =~ Array[Data, 4] {
      fail("${func_name}: acl line $index does not have enough parts")
    }

    # build each entry in the final hash
    $resource = { "postgresql class generated rule ${id} ${index}" =>
      # The first part is the same for all entries
      {
        'type'     => $parts[0],
        'database' => $parts[1],
        'user'     => $parts[2],
        'order'    => sprintf("'%03d'", $offset + $index)
      }
      # The rest depends on if first part is 'local',
      # the length of the parts, and the value in $parts[4].
      # Using a deep matching case expression is a good way
      # to untangle if-then-else spaghetti.
      #
      # The conditional part is merged with the common part
      # using '+' and the case expression results in a hash
      #
      +
      case [$parts[0], $parts, $parts[4]] {

        ['local', Array[Data, 5], default] : {
          { 'auth_method' => $parts[3],
            'auth_option' => $parts[4, -1].join(" ")
          }
        }

        ['local', default, default] : {
          { 'auth_method' => $parts[3] }
        }

        [default, Array[Data, 7], /^\d/] : {
          { 'address'     => "${parts[3]} ${parts[4]}",
            'auth_method' => $parts[5],
            'auth_option' => $parts[6, -1].join(" ")
          }
        }

        [default, default, /^\d/] : {
          { 'address'     => "${parts[3]} ${parts[4]}",
            'auth_method' => $parts[5]
          }
        }

        [default, Array[Data, 6], default] : {
          { 'address'     => $parts[3],
            'auth_method' => $parts[4],
            'auth_option' => $parts[5, -1].join(" ")
          }
        }

        [default, default, default] : {
          { 'address'     => $parts[3],
            'auth_method' => $parts[4]
          }
        }
      }
    }
    $resource
  }
  # Merge the individual resource hashes into one
  #
  $resources.reduce({}) |$result, $resource| { $result + $resource }
}
~~~


## Location

Functions you write should be stored in modules. They go in the `functions` folder, which is a top-level directory, a sibling of `manifests`, `lib`, et al. You should only be defining one function per file, and each filename should reflect the name of the function being defined. For larger, more complex blocks of functional code, see [classes][].

Puppet is automatically aware of any functions in a valid module and will autoload them by name.

> ### Aside: Best Practices
>
> You should usually only write functions in modules. Although the additional options below this aside will work, they are not recommended.

You can also put functions in the main manifest, in which case they can have any name.

If you do put a function in the main manifest, it will override any function of the same name from all modules. (It cannot override built-in functions, though.)


## Naming

[The characters allowed in a function's name are listed here][naming].


## Behavior

Once a function is written and available (usually by putting it in a module where the autoloader will be able to find it), you can call that function in any Puppet manifest. The arguments you pass to the function call will map to the parameters defined in the function's definition. You will have to provide arguments for the mandatory parameters, and can choose whether to provide arguments for the optional ones.

The [function call][function_call] acts like a normal call to any other Puppet function, and resolves to the function's value.
