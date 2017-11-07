---
layout: default
title: "Writing functions in the Puppet language"
---

[defined_types]: ./lang_defined_types.html
[literal_types]: ./lang_data_type.html
[modules]: ./modules_fundamentals.html
[naming]: ./lang_reserved.html#classes-and-defined-resource-types
[namespace]: ./lang_namespaces.html
[resource]: ./lang_resources.html
[resource_defaults]: ./lang_defaults.html
[references_namespaced]: ./lang_data_resource_reference.html
[function_call]: ./lang_functions.html#choosing-a-call-style
[classes]: ./lang_classes.html
[variable]: ./lang_variables.html
[array]: ./lang_data_array.html

You can write your own functions in the Puppet language to transform data and construct values. A function can optionally take one or more parameters as arguments. A function returns a calculated value from its final expression.

## Syntax

``` puppet
function <MODULE NAME>::<NAME>(<PARAMETER LIST>) >> <RETURN TYPE> {
  ... body of function ...
  final expression, which will be the returned value of the function
}
```

{% capture bool2httpexample %}

``` puppet
function apache::bool2http(Variant[String, Boolean] $arg) >> String {
  case $arg {
    false, undef, /(?i:false)/ : { 'Off' }
    true, /(?i:true)/          : { 'On' }
    default               : { "$arg" }
  }
}
```
{% endcapture %}

{{ bool2httpexample }}

The general form of a function written in Puppet language is:

* The keyword `function`.
* The [namespace][] of the function. This should match the name of the module the function is contained in.
* The namespace separator, a double colon (::).
* The [name][naming] of the function.
* An optional **parameter list,** which consists of:
    * An opening parenthesis.
    * A comma-separated list of **parameters** (for example, `String $myparam = "default value"`). Each parameter consists of:
        * An optional [data type][literal_types], which will restrict the allowed values for the parameter (defaults to `Any`).
        * A [variable][] name to represent the parameter, including the `$` prefix.
        * An optional equals (`=`) sign and **default value** (which must match the data type, if one was specified).
    * An optional trailing comma after the last parameter.
    * A closing parenthesis.
* An optional **return type**, which consists of:
    * Two greater-than signs (`>>`).
    * A [data type][literal_types] that matches every value the function could return.
* An opening curly brace.
* A block of Puppet code, ending with an expression whose value is returned.
* A closing curly brace.


### Parameters

Functions are passed arguments by **parameter position**. This means that the _order_ of parameters is important, and the parameter names will not affect the order they are passed.


#### Mandatory and optional parameters

If a parameter has a default value, then it's optional to pass a value for it when the function is called. If the caller doesn't pass in an argument for that parameter, the function will use the default value.

However, since parameters are passed by position, _optional parameters must be listed after all required parameters_. If you put a required parameter after an optional one, it will cause an evaluation error.

#### Variables in Default Parameter Values

If you reference a variable in a default value for a parameter, Puppet will always start looking for that variable at top scope. So if you use `$fqdn`, but then you call the function from a class that overrides the variable `$fqdn`, the parameter's default value will be the value from top scope, not the value from the class. You can reference qualified variable names in a function default value, but compilation will fail if that class wasn't declared by the time the function gets called.

#### The extra arguments parameter

The _final_ parameter of a function can optionally be a special _extra arguments parameter_, which will collect an unlimited number of extra arguments into an array. This is useful when you don't know in advance how many arguments the caller will provide.

To specify that the parameter should collect extra arguments, start its name with an asterisk symbol (`*`) `*$others`. The asterisk is only valid for the last parameter.

An extra arguments parameter is always optional.

The value of an extra arguments parameter is always an [array][], containing every argument in excess of the earlier parameters. If there are no extra arguments and no default value, it will be an empty array.

An extra arguments parameter can have a default value, which has some automatic array wrapping for convenience:

* If the provided default is a non-array value, the real default will be a single-element array containing that value.
* If the provided default is an array, the real default will be that array.

An extra arguments parameter can also have a [data type][literal_types]. Puppet will use this data type to validate _the elements_ of the array. That is, if you specify a data type of `String`, the real data type of the extra arguments parameter will be `Array[String]`.

### Return types

> **Note:** Return types only work with Puppet 4.8 and later. In earlier versions of Puppet, they cause an evaluation error.

Between the parameter list and the function body, you can use `>>` and a [data type][literal_types] to specify the types of the values the function returns.

For example, this function is guaranteed to only return strings:

``` puppet
function apache::bool2http(Variant[String, Boolean] $arg) >> String {
  ...
}
```

The return type serves two purposes: documentation, and insurance.

* Puppet Strings can include information about the return value of a function.
* If something goes wrong and your function returns the wrong type (like `undef` when a string is expected), it will fail early with an informative error instead of allowing compilation to continue with an incorrect value.

### The function body

Functions are meant for constructing values and transforming data, so the body of your function code will differ based on what you're trying to achieve with your function, and the parameters that you're requiring. Avoid declaring resources in the body of your function. If you want to create resources based on inputs, use [defined types][defined_types] instead.

The final expression in the function body determines the value that the function will return when called.

Most [conditional expressions](./lang_conditional.html) in the Puppet language have values that work in a similar way, so you can use an if statement or a case statement as the final expression to give different values based on different numbers or types of inputs. In the following example, the case statement serves as both the body of the function, and its final expression.


{{ bool2httpexample }}


## Location

Store the functions you write in your modules' `functions` folder, which is a top-level directory, a sibling of `manifests` and `lib`. Define only one function per file, and name the file to match the name of the function being defined. For larger, more complex blocks of functional code, see [classes][].

Puppet is automatically aware of functions in a valid module and will autoload them by name.


>### Aside: Writing functions in the main manifest
>
>In most circumstances, you will store functions in modules. However, in rare situations you might find it necessary to put a function in the main manifest. This is not recommended. If you do put a function in the main manifest, it will override any function of the same name in all modules (except built-in functions).


## Naming

[The characters allowed in a function's name are listed here][naming].


## Calling a function

The [function call][function_call] acts like a normal call to any built-in Puppet function, and resolves to the function's returned value.

Once a function is written and available (in a module where the autoloader can find it), you can call that function in any Puppet manifest that lists the containing module as a dependency and from your [main manifest](./dirs_manifest.html). The arguments you pass to the function map to the parameters defined in the function's definition. You must pass arguments for the mandatory parameters, and can choose whether to pass in arguments for the optional ones.

## Complex function example

The below code is a re-written version of a Ruby function from the [`postgresql`](https://forge.puppetlabs.com/puppetlabs/postgresql) module into Puppet code. This function translates the IPv4 and IPv6 ACLs format into a resource suitable for `create_resources`. The writer of this function also left helpful inline comments for other people who use the it, or in case it needs to be altered in the future. In this case the filename would be `acls_to_resource_hash.pp`, and it would be saved in a folder named `functions` in the top-level directory of the `postgresql` module.

``` puppet
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
  $resources.reduce({}) |$result, $resource| { $result + $resource }
}
```
