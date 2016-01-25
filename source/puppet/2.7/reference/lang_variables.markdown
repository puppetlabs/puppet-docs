---
layout: default
title: "Language: Variables"
canonical: "/puppet/latest/reference/lang_variables.html"
---


[expressions]: ./lang_expressions.html
[acceptable]: ./lang_reserved.html#variables
[reserved]: ./lang_reserved.html#reserved-variable-names
[datatype]: ./lang_datatypes.html
[double_quote]: ./lang_datatypes.html#double-quoted-strings
[functions]: ./lang_functions.html
[definedtype]: ./lang_defined_types.html
[environment]: /puppet/latest/reference/environments_classic.html
[resource]: ./lang_resources.html
[resource_attribute]: ./lang_resources.html#syntax
[scope]: ./lang_scope.html
[topscope]: ./lang_scope.html#top-scope
[facts]: /facter/latest/core_facts.html
[facter]: /facter
[customfacts]: /facter/1.7/custom_facts.html
[catalog]: ./lang_summary.html#compilation-and-catalogs



Syntax
-----

### Assignment

~~~ ruby
    $content = "some content\n"
~~~

Variable names are prefixed with a `$` (dollar sign). Values are assigned to them with the `=` (equal sign) assignment operator.

Any value of any of the normal (i.e. non-regex) [data types][datatype] can be assigned to a variable. Any statement that resolves to a normal value (including [expressions][], [functions][], and other variables) can be used in place of a literal value. The variable will contain the value that the statement resolves to, rather than a reference to the statement.

Variables can only be assigned using their [short name](#naming). That is, a given [scope][] cannot assign values to variables in a foreign scope.

### Resolution

~~~ ruby
    file {'/tmp/testing':
      ensure  => file,
      content => $content,
    }

    $address_array = [$address1, $address2, $address3]
~~~

The name of a variable can be used in any place where a value of its data type would be accepted, including [expressions][], [functions][], and [resource attributes][resource_attribute]. Puppet will replace the name of the variable with its value.

### Interpolation

~~~ ruby
    $rule = "Allow * from $ipaddress"
    file { "${homedir}/.vim":
      ensure => directory,
      ...
    }
~~~

Puppet can resolve variables in [double-quoted strings][double_quote]; this is called "interpolation."

Inside a double-quoted string, you can optionally surround the name of the variable (the portion after the `$`) with curly braces (`${var_name}`). This syntax helps to avoid ambiguity and allows variables to be placed directly next to non-whitespace characters. These optional curly braces are only allowed inside strings.

### Appending Assignment

When creating a local variable with the same name as a variable in [top scope, node scope, or a parent scope][scope], you can optionally append to the received value with the `+=` (plus-equals) appending assignment operator.

~~~ ruby
    $ssh_users = ['myself', 'someone']

    class test {
      $ssh_users += ['someone_else']
    }
~~~

In the example above, the value of `$ssh_users` inside class `test` would be `['myself', 'someone', 'someone_else']`.

The value appended with the `+=` operator **must** be the same [data type][datatype] as the received value. This operator can only be used with strings, arrays, and hashes:

* Strings: Will concatenate the two strings.
* Arrays: Will add the elements of the appended array to the end of the received array.
* Hashes: Will merge the two hashes.


Behavior
-----

### Scope

The area of code where a given variable is visible is dictated by its [scope][]. Variables in a given scope are only available within that scope and its child scopes, and any local scope can locally override the variables it receives from its parents.

See the [section on scope][scope] for complete details.

### Accessing Out-of-Scope Variables

You can access out-of-scope variables from named scopes by using their [qualified names](#naming):

~~~ ruby
    $vhostdir = $apache::params::vhostdir
~~~

Note that the top scope's name is the empty string. See [scope][] for details.

### No Reassignment

Unlike most other languages, Puppet only allows a given variable to be assigned **once** within a given [scope][]. You may not change the value of a variable, although you may assign a different value to the same variable name in a new scope:

~~~ ruby
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
~~~

In the example above, `$myvar` has several different values, but only one value will apply to any given scope.

> Note: Due to insufficient protection of the scope object that gets passed into templates, it is possible to reassign a variable inside a template and have the new value persist in the Puppet scope after the template is evaluated. This behavior is considered a bug; **do not use it.** It will not be removed during the Puppet 2.7 series, but may be removed thereafter without a deprecation period.

### Parse-Order Dependence

Unlike [resource declarations][resource], variable assignments are parse-order dependent. This means you cannot resolve a variable before it has been assigned.

This is the main way in which the Puppet language fails to be fully declarative.



Naming
-----

Variable names are case-sensitive and can include alphanumeric characters and underscores.

Qualified variable names are prefixed with the name of their scope and the `::` (double colon) namespace separator. (For example, the `$vhostdir` variable from the `apache::params` class would be `$apache::params::vhostdir`.)

[See the section on acceptable characters in variable names][acceptable] for more details. Additionally, [several variable names are reserved][reserved].


Facts and Built-In Variables
-----

Puppet provides several built-in [top-scope][topscope] variables, which you can rely on in your own manifests.

### Facts

Each node submits a very large number of [facts][] (as discovered by [Facter][]) when requesting its [catalog][], and all of them are available as top-scope variables in your manifests. In addition to the built-in facts, you can create and distribute custom facts as plugins.

* [See here for a complete list of built-in facts][facts].
* [See here for a guide to writing custom facts][customfacts].
* Run `facter -p` on one of your nodes to get a complete report of the facts that node will report to the master.

### Agent-Set Variables

Puppet agent sets several additional variables for a node which are available when compiling that node's catalog:

* `$environment` --- the node's current [environment][].
* `$clientcert` --- the node's certname setting.
* `$clientversion` --- the current version of puppet agent.

### Master-Set Variables

These variables are set by the puppet master and are most useful when managing Puppet with Puppet. (For example, managing puppet.conf with a template.)

* `$servername` --- the puppet master's fully-qualified domain name. (Note that this information is gathered from the puppet master by Facter, rather than read from the config files; even if the master's certname is set to something other than its fully-qualified domain name, this variable will still contain the server's fqdn.)
* `$serverip` --- the puppet master's IP address.
* `$serverversion` --- the current version of puppet on the puppet master.
* `$settings::<name of setting>` --- the value of any of the master's [configuration settings](./configuration.html). This is implemented as a special namespace and these variables must be referred to by their qualified names. Note that, other than `$environment`, the agent node's settings are **not** available in manifests. If you wish to expose them to the master in this version of Puppet (2.7), you will have to create a custom fact.

### Parser-Set Variables

These variables are set in every [local scope][scope] by the parser during compilation. These are mostly useful when implementing complex [defined types][definedtype].

* `$module_name` --- the name of the module that contains the current class or defined type.
* `$caller_module_name` --- the name of the module in which the **specific instance** of the surrounding defined type was declared. This is only useful when creating versatile defined types which will be re-used by several modules.

