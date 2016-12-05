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
[customfacts]: /facter/latest/custom_facts.html
[catalog]: ./lang_summary.html#compilation-and-catalogs
[enc]: /guides/external_nodes.html


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

Note that the top scope's name is the empty string --- thus, the qualified name of a top scope variable would be, e.g., `$::osfamily`. See [scope][] for details.

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

> Note: Due to insufficient protection of the scope object that gets passed into templates, it is possible to reassign a variable inside a template and have the new value persist in the Puppet scope after the template is evaluated. **Do not do this.** This behavior is considered a bug rather than designed behavior and may be removed at any point without a deprecation period.

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
* Run `facter -p` on one of your nodes to get a complete report of the facts that node will report to the master. In Puppet Enterprise, each node detail page in the PE console contains a list of that node's facts.

### Trusted Node Data

In **Puppet 3.4.0 and later,** you can enable a `$trusted` variable, which is a hash containing _verified_ node data. Instead of being self-reported by an agent node, this data is extracted from the node's cryptographic credentials by the puppet master, which makes it resistant to spoofing and suitable for assigning sensitive data to certain nodes.

To enable `$trusted`, set `trusted_node_data = true` in your puppet master's puppet.conf file. (For standalone puppet apply nodes, set it to true in each node's puppet.conf.)

The `$trusted` variable is a hash containing the following keys:

* `$trusted['authenticated']` --- an indication of whether the catalog request was authenticated, as well as how it was authenticated. The value will be one of:
    * `remote` for authenticated remote requests (as with agent/master Puppet configurations)
    * `local` for all local requests (as with standalone puppet apply nodes)
    * `false` for unauthenticated remote requests (generally only possible if you've configured auth.conf to allow unauthenticated catalog requests)
* `$trusted['certname']` --- the node's certificate name, usually set via the `certname` setting.
    * For remote agent/master requests, this is the subject CN extracted from the node's certificate.
    * For local catalog compilation, this is read directly from the `certname` setting.
    * If the value of the `authenticated` key is `false`, the value of this key will be an empty string.

If the `$trusted` hash is enabled with the `trusted_node_data` setting, Puppet will prevent you from accidentally modifying it. This means you can't assign new values to `$trusted` in local scopes, you can't add new keys to it, and you can't overwrite its existing keys in a template. Trying to do any of these things will fail compilation with an error.

The `trusted_node_data` setting defaults to `false` in Puppet 3.x; it will default to `true` in Puppet 4.

### Agent-Set Variables

Puppet agent (and puppet apply) sets several additional variables for a node which are available when compiling that node's catalog:

* `$clientcert` --- the value of the node's certname setting.
* `$clientversion` --- the current version of puppet agent.
* `$clientnoop` --- available in Puppet 3.3.0 (Puppet Enterprise 3.1) and later. The value of the node's [`noop` setting][noop] (true or false) at the time of the run.

These variables are self-reported, so they shouldn't be used to decide whether a node receives sensitive data in its catalog. For that, see the `$trusted['certname']` variable above.

### Master-Set Variables

These variables are set by the puppet master and are most useful when managing Puppet with Puppet. (For example, managing puppet.conf with a template.)

* `$environment` --- the agent node's [environment][]. (In Puppet 3, the agent may request an environment, but the master's [ENC][] may override it.)
* `$servername` --- the puppet master's fully-qualified domain name. (Note that this information is gathered from the puppet master by Facter, rather than read from the config files; even if the master's certname is set to something other than its fully-qualified domain name, this variable will still contain the server's fqdn.)
* `$serverip` --- the puppet master's IP address.
* `$serverversion` --- the current version of puppet on the puppet master.
* `$settings::<name of setting>` --- the value of any of the master's [configuration settings](./config_about_settings.html). This is implemented as a special namespace and these variables must be referred to by their qualified names. Note that, other than `$environment`, the agent node's settings are **not** available in manifests. If you wish to expose them to the master in Puppet 3, you will have to create a custom fact.

### Parser-Set Variables

These variables are set in every [local scope][scope] by the parser during compilation. These are mostly useful when implementing complex [defined types][definedtype].

* `$module_name` --- the name of the module that contains the current class or defined type.
* `$caller_module_name` --- the name of the module in which the **specific instance** of the surrounding defined type was declared. This is only useful when creating versatile defined types which will be re-used by several modules.

