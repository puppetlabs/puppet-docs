---
layout: default
title: "Language: Variables"
canonical: "/puppet/latest/lang_variables.html"
---


[expressions]: ./lang_expressions.html
[acceptable]: ./lang_reserved.html#variables
[reserved]: ./lang_reserved.html#reserved-variable-names
[datatype]: ./lang_data.html
[double_quote]: ./lang_data_string.html#double-quoted-strings
[functions]: ./lang_functions.html
[resource]: ./lang_resources.html
[scope]: ./lang_scope.html
[undef]: ./lang_data_undef.html
[strict_variables]: ./configuration.html#strictvariables
[puppet.conf]: ./config_file_main.html


 <a id="facts"><a id="trusted-node-data"><a id="agent-set-variables"><a id="master-set-variables"><a id="parser-set-variables">

Variables store values so they can be accessed later.

In the Puppet language, variables are actually constants, since they [can't be reassigned](#no-reassignment). But since "variable" is more comfortable and familiar to most people, the name has stuck.

> Facts and Built-In Variables
> -----
>
> Puppet has many built-in variables that you can use in your manifests. For a list of these, see [the page on facts and built-in variables.](./lang_facts_and_builtin_vars.html)

## Syntax


### Assignment

``` puppet
$content = "some content\n"
```

Variable names are prefixed with a `$` (dollar sign). Values are assigned to them with the `=` (equal sign) assignment operator.

Variables can be assigned values of any [data type][datatype]. Any statement that resolves to a normal value (including [expressions][], [functions][], and other variables) can be used in place of a literal value. The variable will contain the value that the statement resolves to, rather than a reference to the statement.

Variables can only be assigned using their [short name](#naming). That is, a given [scope][] cannot assign values to variables in a foreign scope.

### Assigning multiple variables

You can assign multiple vairiables at once from an array or hash. 

#### Arrays 

When assigning multiple variables from an array, there must be an equal number of variables and values. Nested arrays can also be used.

```
    [$a, $b, $c] = [1,2,3]      # $a = 1, $b = 2, $c = 3
    [$a, [$b, $c]] = [1,[2,3]]  # $a = 1, $b = 2, $c = 3
    [$a, $b] = [1, [2]]         # $a = 1, $b = [2]
    [$a, [$b]] = [1, [2]]       # $a = 1, $b = 2
```

If the number of variables and values do not match, the operation will fail.

#### Hashes

When you assign multiple variables with a hash, the variables are listed in an array on the left side of the assignment operator, and the hash is on the right. Hash keys must match their corresponding variable name. 

```
    [$a, $b] = {a => 10, b => 20}           # $a = 10, $b = 20
```

There can be extra key/value pairs in the hash, but all variables to the left of the operator must have a corresponding key in the hash. 

```
    [$a, $c] = {a => 5, b => 10, c => 15, d => 22}   # $a = 5, $c = 15
```

### Resolution

``` puppet
file {'/tmp/testing':
  ensure  => file,
  content => $content,
}

$address_array = [$address1, $address2, $address3]
```

The name of a variable can be used in any place where a value of its data type would be accepted, including [expressions][], [functions][], and [resource attributes][resource]. Puppet will replace the name of the variable with its value.

By default, unassigned variables have a value of [`undef`][undef]; see [Unassigned Variables and Strict Mode](#unassigned-variables-and-strict-mode) below for more details.

### Interpolation

``` puppet
$rule = "Allow * from $ipaddress"
file { "${homedir}/.vim":
  ensure => directory,
  ...
}
```

Puppet can resolve variables in [double-quoted strings][double_quote]; this is called "interpolation."

Inside a double-quoted string, you can optionally surround the name of the variable (the portion after the `$`) with curly braces (`${var_name}`). This syntax helps to avoid ambiguity and allows variables to be placed directly next to non-whitespace characters. These optional curly braces are only allowed inside strings.

## Behavior


### Scope

The area of code where a given variable is visible is dictated by its [scope][]. Variables in a given scope are only available within that scope and its child scopes, and any local scope can locally override the variables it receives from its parents.

See the [section on scope][scope] for complete details.

### Accessing out-of-scope variables

You can access out-of-scope variables from named scopes by using their [qualified names](#naming):

``` puppet
$vhostdir = $apache::params::vhostdir
```

Note that the top scope's name is the empty string --- thus, the qualified name of a top scope variable would be, e.g., `$::osfamily`. See [scope][] for details.

### Unassigned variables and strict mode

By default, you can access variables that have never had values assigned to them. If you do, their value will be [`undef`.][undef]

This is usually not what you want, because using an unassigned variable is often an accident or a typo.

If you'd rather have unassigned variable usage throw an error, so you can get warned early and fix the problem, you can enable strict mode. Set [`strict_variables = true`][strict_variables] in [puppet.conf][] on your Puppet master(s) and any nodes that run Puppet apply.

### No reassignment

Unlike most other languages, Puppet only allows a given variable to be assigned **once** within a given [scope][]. You may not change the value of a variable, although you may assign a different value to the same variable name in a new scope:

``` puppet
# scope-example.pp
# Run with puppet apply --certname www1.example.com scope-example.pp
$myvar = "Top scope value"
node 'www1.example.com' {
  $myvar = "Node scope value"
  notice( "from www1: $myvar" )
  include myclass
}
node 'db1.example.com' {
  notice( "from db1: $myvar" )
  include myclass
}
class myclass {
  $myvar = "Local scope value"
  notice( "from myclass: $myvar" )
}
```

In the example above, `$myvar` has several different values, but only one value will apply to any given scope.

### Evaluation-order dependence

Unlike [resource declarations][resource], variable assignments are evaluation-order dependent. This means you cannot resolve a variable before it has been assigned.

This is the main way in which the Puppet language fails to be fully declarative.



## Naming


{% partial ./_naming_variables.md %}
