---
title: "Language: Conditional Statements and Expressions"
layout: default
canonical: "/puppet/latest/reference/lang_conditional.html"
---


[local]: ./lang_scope.html#local-scopes
[boolean]: ./lang_data_boolean.html
[regex]: ./lang_data_regexp.html
[facts]: ./lang_variables.html#facts
[equality]: ./lang_expressions.html#equality
[fail]: /references/4.3.latest/function.html#fail
[matching]: ./lang_expressions.html#regex-or-data-type-match
[expressions]: ./lang_expressions.html
[bool_convert]: ./lang_data_boolean.html
[variables]: ./lang_variables.html
[functions]: ./lang_functions.html
[datatypes]: ./lang_data.html
[splat]: ./lang_expressions.html#splat
[literal_types]: ./lang_data_type.html

Conditional statements let your Puppet code behave differently in different situations. They are most helpful when combined with [facts][] or with data retrieved from an external source.

Summary
-----

Puppet supports "if" and "unless" statements, case statements, and selectors.

An "if" statement:

~~~ ruby
if $is_virtual {
  warning('Tried to include class ntp on virtual machine; this node may be misclassified.')
}
elsif $operatingsystem == 'Darwin' {
  warning('This NTP module does not yet work on our Mac laptops.')
}
else {
  include ntp
}
~~~

An "unless" statement:

~~~ ruby
unless $memorysize > 1024 {
  $maxclient = 500
}
~~~

A case statement:

~~~ ruby
case $operatingsystem {
  'Solaris':          { include role::solaris }
  'RedHat', 'CentOS': { include role::redhat  }
  /^(Debian|Ubuntu)$/:{ include role::debian  }
  default:            { include role::generic }
}
~~~

A selector:

~~~ ruby
$rootgroup = $osfamily ? {
    'Solaris'          => 'wheel',
    /(Darwin|FreeBSD)/ => 'wheel',
    default            => 'root',
}

file { '/etc/passwd':
  ensure => file,
  owner  => 'root',
  group  => $rootgroup,
}
~~~

"If" Statements
-----

**"If" statements** take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is **true.** They can optionally include `elsif` and `else` clauses.


### Syntax

~~~ ruby
if $is_virtual {
  # Our NTP module is not supported on virtual machines:
  warning( 'Tried to include class ntp on virtual machine; this node may be misclassified.' )
}
elsif $operatingsystem == 'Darwin' {
  warning( 'This NTP module does not yet work on our Mac laptops.' )
}
else {
  # Normal node, include the class.
  include ntp
}
~~~

The general form of an "if" statement is:

* The `if` keyword
* A **condition** (any expression resolving to a boolean value)
* A pair of curly braces containing any Puppet code
* **Optionally:** any number of `elsif` clauses, which will be processed in order. An `elsif` clause consists of:
    * The `elsif` keyword
    * A **condition**
    * A pair of curly braces containing any Puppet code
* **Optionally:** the `else` keyword and a pair of curly braces containing Puppet code

### Behavior

Puppet's "if" statements behave much like those in any other language. The `if` condition is evaluated first and, if it is true, only the `if` code block is executed. If it is false, each `elsif` condition (if present) is tested in order, and if all conditions fail, the `else` code block (if present) is executed.

If none of the conditions in the statement match and there is no `else` block, Puppet will do nothing and move on.

"If" statements will execute a maximum of one code block.

#### When Used as a Value

In addition to executing the code in a block, an `if` statement is also an expression that produces a value, and can be used wherever a value is allowed.

The value of an `if` expression is the value of the last expression in the executed block, or `undef` if no block was executed.

### Conditions

The condition(s) of an "if" statement may be any expression that resolves to a boolean value. This includes:

* [Variables][]
* [Expressions][], including arbitrarily nested `and` and `or` expressions
* [Functions][] that return values

Expressions that resolve to non-boolean values will be [automatically converted to booleans as described here][bool_convert].

Static values may also be conditions, although doing this would be pointless.

#### Regex Capture Variables

If you use the regular expression match operator in a condition, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

~~~ ruby
if $hostname =~ /^www(\d+)\./ {
  notice("Welcome to web server number $1")
}
~~~

This example would capture any digits from a hostname like `www01` and `www02` and store them in the `$1` variable.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

"Unless" Statements
-----

**"Unless" statements** work like reversed "if" statements. They take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is **false.** They **cannot** include `elsif` clauses.

### Syntax

~~~ ruby
unless $memorysize > 1024 {
  $maxclient = 500
}
~~~

The general form of an "unless" statement is:

* The `unless` keyword
* A **condition** (any expression resolving to a boolean value)
* A pair of curly braces containing any Puppet code
* **Optionally:** the `else` keyword and a pair of curly braces containing Puppet code

If an `elsif` clause is included in an "unless" statement, it is a syntax error and will cause compilation to fail.

### Behavior

The condition is evaluated first and, if it is false, the code block is executed. If the condition is true, Puppet will do nothing and move on.

#### When Used as a Value

In addition to executing the code in a block, an `unless` statement is also an expression that produces a value, and can be used wherever a value is allowed.

The value of an `unless` expression is the value of the last expression in the executed block, or `undef` if no block was executed.

### Conditions

The condition(s) of an "unless" statement may be any expression that resolves to a boolean value. This includes:

* [Variables][]
* [Expressions][], including arbitrarily nested `and` and `or` expressions
* [Functions][] that return values

Expressions that resolve to non-boolean values will be [automatically converted to booleans as described here][bool_convert].

Static values may also be conditions, although doing this would be pointless.

#### Regex Capture Variables

Although "unless" statements receive regex capture variables like "if" statements, they usually aren't used, since the code in the statement will only be executed if the condition didn't match anything. It's possible to use regex captures in the "else" clause, but it would make more sense to just use an "if" statement.



Case Statements
-----

Like "if" statements, **case statements** choose one of several blocks of arbitrary Puppet code to execute. They take a control expression and a list of cases and code blocks, and will execute the first block whose case value matches the control expression.

### Syntax

~~~ ruby
case $operatingsystem {
  'Solaris':          { include role::solaris } # apply the solaris class
  'RedHat', 'CentOS': { include role::redhat  } # apply the redhat class
  /^(Debian|Ubuntu)$/:{ include role::debian  } # apply the debian class
  default:            { include role::generic } # apply the generic class
}
~~~

The general form of a case statement is:

* The `case` keyword
* A **control expression** (any expression resolving to a value; see below)
* An opening curly brace
* Any number of possible matches, which consist of:
    * A **case** (see below) or comma-separated list of cases
    * A colon
    * A pair of curly braces containing any arbitrary Puppet code
* A closing curly brace


### Behavior

Puppet compares the control expression to each of the cases, in the order they are listed (except for the top-most level `default` case, which always goes last). It will execute the block of code associated with the **first** matching case, and ignore the remainder of the statement.

Case statements will execute a _maximum_ of one code block. If none of the cases match, Puppet will do nothing and move on.

See "Case Matching" below for details on how Puppet matches different kinds of cases.

#### Control Expressions

The control expression of a case statement can be any expression that resolves to a value. This includes:

* [Variables][]
* [Expressions][]
* [Functions][] that return values

#### Case Matching

A case can be any expression that resolves to a value. (This includes literal values, variables, function calls, etc.)

You can use a comma-separated list of cases to associate multiple cases with the same block of code. (If you need to use values from a variable as cases, note that [the `*` splat operator][splat] can convert an array of values into a comma-separated list of values.)

{% capture case_matching_behavior %}
Depending on the [data type][datatypes] of a case's value, Puppet will use one of following behaviors to test whether the case matches:

* **Most data types** (strings, booleans, etc.) are compared to the control value with [the `==` equality operator][equality], which is case-insensitive when comparing strings.
* [**Regular expressions**][regex] are compared to the control value with [the `=~` matching operator][matching], which is case-sensitive. Regex cases _only_ match strings.
* [**Data types**][literal_types] (like `Integer`) are compared to the control value with [the `=~` matching operator][matching]. This tests whether the control value is an instance of that data type.
* Arrays are compared to the control value recursively. First, it checks whether the control and array are the same length, then each corresponding element is compared using these same case matching rules.
* Hashes compare each key/value pair. To match, the control value and the case have to have the same keys, and each corresponding value is compared using these same case matching rules.
* **The special value `default`** matches anything, and unless nested inside an array or hash is _always tested last,_ regardless of its position in the list.

{% endcapture %}

{{case_matching_behavior}}

#### When Used as a Value

In addition to executing the code in a block, a `case` statement is also an expression that produces a value, and can be used wherever a value is allowed.

The value of a `case` expression is the value of the last expression in the executed block, or `undef` if no block was executed.


#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

~~~ ruby
case $hostname {
  /www(d+)/: { notice("Welcome to web server number ${1}"); include role::web }
  default:   { include role::generic }
}
~~~

This example would capture any digits from a hostname like `www01` and `www02` and store them in the `$1` variable.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)


> #### Aside: Best Practices
>
> Case statements should usually have a default case.
>
> * If the rest of your cases are meant to be comprehensive, putting a [`fail('message')`][fail] call in the default case makes your code more robust by protecting against mystery failures due to behavior changes elsewhere in your manifests.
> * If your cases aren't comprehensive and nodes that match none should do nothing, write a default case with an empty code block (`default: {}`). This makes your intention obvious to the next person who has to maintain your code.


Selectors
-----

**Selector expressions** are similar to case statements, but only return a value instead of executing a code block.

### Location

Selectors can be used wherever a **value** is expected. This includes:

* Variable assignments
* Resource attributes
* Function arguments
* Resource titles
* A value in another selector
* [Expressions][]

> #### Aside: Best Practices
>
> For readability's sake, you should generally only use selectors in variable assignments.

### Syntax

Selectors resemble a cross between a case statement and the ternary operator found in other languages.

~~~ ruby
$rootgroup = $osfamily ? {
    'Solaris'          => 'wheel',
    /(Darwin|FreeBSD)/ => 'wheel',
    default            => 'root',
}

file { '/etc/passwd':
  ensure => file,
  owner  => 'root',
  group  => $rootgroup,
}
~~~

In the example above, the value of `$rootgroup` is determined using the value of `$osfamily`.

The general form of a selector is:

* A **control expression** (any expression resolving to a value; see below)
* The `?` (question mark) keyword
* An opening curly brace
* Any number of possible matches, each of which consists of:
    * A **case** (see below)
    * The `=>` (fat comma) keyword
    * A **value** (which can be any expression resolving to a value)
    * A trailing comma
* A closing curly brace

### Behavior

The entire selector expression is **treated as a single value.**

Puppet compares the control expression to each of the cases, in the order they are listed (except for the `default` case, which always goes last). When it finds a matching case, it will treat that value as the value of the expression and ignore the remainder of the expression.

If none of the cases match, Puppet will **fail compilation with an error.**

See "Case Matching" below for details on how Puppet matches different kinds of cases.

#### Control Expressions

The control expression of a selector can be any expression that resolves to a value. This includes:

* [Variables][]
* [Expressions][]
* [Functions][] that return values

#### Case Matching

A case can be any expression that resolves to a value. (This includes literal values, variables, function calls, etc.)

**Unlike in case statements,** you cannot use lists of cases. If the control expression is a string and you need more than one case associated with a single value, you can use a regular expression. Otherwise, use a case statement instead of a selector.

{{case_matching_behavior}}

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated value as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

~~~ ruby
$system = $operatingsystem ? {
  /(RedHat|Debian)/ => "our system is ${1}",
  default           => "our system is unknown",
}
~~~

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the value associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

