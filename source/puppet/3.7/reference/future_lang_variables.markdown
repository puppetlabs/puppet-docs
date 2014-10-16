---
layout: default
title: "Future Parser: Variables"
canonical: "/puppet/latest/reference/future_lang_variables.html"
---


[expressions]: ./future_lang_expressions.html
[acceptable]: ./future_lang_reserved.html#variables
[reserved]: ./future_lang_reserved.html#reserved-variable-names
[datatype]: ./future_lang_datatypes.html
[double_quote]: ./future_lang_datatypes.html#double-quoted-strings
[functions]: ./future_lang_functions.html
[resource]: ./future_lang_resources.html
[resource_attribute]: ./future_lang_resources.html#syntax
[scope]: ./future_lang_scope.html


<!-- Preserve links to old headers --> <a id="facts"><a id="trusted-node-data"><a id="agent-set-variables"><a id="master-set-variables"><a id="parser-set-variables">

> Facts and Built-In Variables
> -----
>
> Puppet has many built-in variables that you can use in your manifests. For a list of these, see [the page on facts and built-in variables.](./future_lang_facts_and_builtin_vars.html)

Syntax
-----

### Assignment

{% highlight ruby %}
    $content = "some content\n"
{% endhighlight %}

Variable names are prefixed with a `$` (dollar sign). Values are assigned to them with the `=` (equal sign) assignment operator.

Any value of any of the [data types][datatype] can be assigned to a variable. Any statement that resolves to a normal value (including [expressions][], [functions][], and other variables) can be used in place of a literal value. The variable will contain the value that the statement resolves to, rather than a reference to the statement.

Variables can only be assigned using their [short name](#naming). That is, a given [scope][] cannot assign values to variables in a foreign scope.

### Resolution

{% highlight ruby %}
    file {'/tmp/testing':
      ensure  => file,
      content => $content,
    }

    $address_array = [$address1, $address2, $address3]
{% endhighlight %}

The name of a variable can be used in any place where a value of its data type would be accepted, including [expressions][], [functions][], and [resource attributes][resource_attribute]. Puppet will replace the name of the variable with its value.

### Interpolation

{% highlight ruby %}
    $rule = "Allow * from $ipaddress"
    file { "${homedir}/.vim":
      ensure => directory,
      ...
    }
{% endhighlight %}

Puppet can resolve variables in [double-quoted strings][double_quote]; this is called "interpolation."

Inside a double-quoted string, you can optionally surround the name of the variable (the portion after the `$`) with curly braces (`${var_name}`). This syntax helps to avoid ambiguity and allows variables to be placed directly next to non-whitespace characters. These optional curly braces are only allowed inside strings.

Behavior
-----

### Scope

The area of code where a given variable is visible is dictated by its [scope][]. Variables in a given scope are only available within that scope and its child scopes, and any local scope can locally override the variables it receives from its parents.

See the [section on scope][scope] for complete details.

### Accessing Out-of-Scope Variables

You can access out-of-scope variables from named scopes by using their [qualified names](#naming):

{% highlight ruby %}
    $vhostdir = $apache::params::vhostdir
{% endhighlight %}

Note that the top scope's name is the empty string --- thus, the qualified name of a top scope variable would be, e.g., `$::osfamily`. See [scope][] for details.

### No Reassignment

Unlike most other languages, Puppet only allows a given variable to be assigned **once** within a given [scope][]. You may not change the value of a variable, although you may assign a different value to the same variable name in a new scope:

{% highlight ruby %}
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
{% endhighlight %}

In the example above, `$myvar` has several different values, but only one value will apply to any given scope.

### Parse-Order Dependence

Unlike [resource declarations][resource], variable assignments are parse-order dependent. This means you cannot resolve a variable before it has been assigned.

This is the main way in which the Puppet language fails to be fully declarative.



Naming
-----

Variable names are case-sensitive and can include alphanumeric characters and underscores.

Qualified variable names are prefixed with the name of their scope and the `::` (double colon) namespace separator. (For example, the `$vhostdir` variable from the `apache::params` class would be `$apache::params::vhostdir`.)

[See the section on acceptable characters in variable names][acceptable] for more details. Additionally, [several variable names are reserved][reserved].
