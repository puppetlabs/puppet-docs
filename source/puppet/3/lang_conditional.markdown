---
title: "Language: Conditional Statements"
layout: default
canonical: "/puppet/latest/reference/lang_conditional.html"
---


[local]: ./lang_scope.html#local-scopes
[boolean]: ./lang_datatypes.html#booleans
[regex]: ./lang_datatypes.html#regular-expressions
[facts]: ./lang_variables.html#facts
[equality]: ./lang_expressions.html#equality
[fail]: /puppet/latest/reference/function.html#fail
[regex_compare]: ./lang_expressions.html#regex-match
[expressions]: ./lang_expressions.html
[bool_convert]: ./lang_datatypes.html#automatic-conversion-to-boolean
[variables]: ./lang_variables.html
[functions]: ./lang_functions.html


Conditional statements let your Puppet code behave differently in different situations. They are most helpful when combined with [facts][] or with data retrieved from an external source.

Summary
-----

Puppet 3 supports "if" and "unless" statements, case statements, and selectors.

An "if" statement:

~~~ ruby
    if $is_virtual == 'true' {
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
    if $is_virtual == 'true' {
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
* A **condition**
* A pair of curly braces containing any Puppet code
* **Optionally:** the `elsif` keyword, another condition, and a pair of curly braces containing Puppet code
* **Optionally:** the `else` keyword and a pair of curly braces containing Puppet code

### Behavior

Puppet's "if" statements behave much like those in any other language. The `if` condition is evaluated first and, if it is true, only the `if` code block is executed. If it is false, each `elsif` condition (if present) is tested in order, and if all conditions fail, the `else` code block (if present) is executed.

If none of the conditions in the statement match and there is no `else` block, Puppet will do nothing and move on.

"If" statements will execute a maximum of one code block.

### Conditions

The condition(s) of an "if" statement may be any fragment of Puppet code that resolves to a boolean value. This includes:

* [Variables][]
* [Expressions][], including arbitrarily nested `and` and `or` expressions
* [Functions][] that return values

Fragments that resolve to non-boolean values will be [automatically converted to booleans as described here][bool_convert].

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

**"Unless" statements** work like reversed "if" statements. They take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is **false.** They **cannot** include `elsif` or `else` clauses.

### Syntax

~~~ ruby
    unless $memorysize > 1024 {
      $maxclient = 500
    }
~~~

The general form of an "unless" statement is:

* The `unless` keyword
* A **condition**
* A pair of curly braces containing any Puppet code

If an `else` or `elsif` clause is included in an "unless" statement, it is a syntax error and will cause compilation to fail.

### Behavior

The condition is evaluated first and, if it is false, the code block is executed. If the condition is true, Puppet will do nothing and move on.

### Conditions

The condition(s) of an "unless" statement may be any fragment of Puppet code that resolves to a boolean value. This includes:

* [Variables][]
* [Expressions][], including arbitrarily nested `and` and `or` expressions
* [Functions][] that return values

Fragments that resolve to non-boolean values will be [automatically converted to booleans as described here][bool_convert].

Static values may also be conditions, although doing this would be pointless.

#### Regex Capture Variables

Although "unless" statements receive regex capture variables like "if" statements, they generally can't be used, since the code in the statement will only be executed if the condition didn't match anything. Compound conditions can cause the capture variables to be set inside the statement, but this is essentially useless.



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
* A **control expression** (see below)
* An opening curly brace
* Any number of possible matches, which consist of:
    * A **case** (see below) or comma-separated list of cases
    * A colon
    * A pair of curly braces containing any arbitrary Puppet code
* A closing curly brace


### Behavior

Puppet compares the **control expression** to each of the **cases,** in the order they are listed. It will execute the block of code associated with the **first** matching case, and ignore the remainder of the statement.

* Basic cases are compared with [the `==` operator][equality] (which is case-insensitive).
* Regular expression cases are compared with [the `=~` operator][regex_compare] (which is case-sensitive).
* The special `default` case matches anything.

If none of the cases match, Puppet will do nothing and move on.

Case statements will execute a maximum of one code block.

### Control Expressions

The control expression of a case statement may be any fragment of Puppet code that resolves to a normal value. This includes:

* [Variables][]
* [Expressions][]
* [Functions][] that return values

### Cases

Cases may be any of the following:

* A literal value (remember to quote strings)
* A variable
* A [function][functions] call that returns a value
* A [regular expression][regex]
* The special bare word value `default`

Note that you cannot use arbitrary [expressions][] or [selectors](#selectors) as cases.

You may use a comma-separated list of cases to associate more than one case with the same block of code.

Normal values are compared to the control expression using [the `==` operator][equality], and regular expressions are compared with [the `=~` operator][regex_compare]. The special `default` case matches any control expression.

Cases are compared in the order that they are written in the manifest --- if more than one case might match for a given node, the first one will win. The one exception is the special `default` case, which will only be used as a last resort regardless of its position in the list.

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

~~~ ruby
    if $hostname =~ /^www(\d+)\./ {
      notice("Welcome to web server number $1")
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

**Selector statements** are similar to case statements, but return a value instead of executing a code block.

### Location

Selectors must be used at places in the code where a **plain value** is expected. This includes:

* Variable assignments
* Resource attributes
* Function arguments
* Resource titles
* A value in another selector
* [Expressions][]

Selectors are not legal in:

* A case in another selector
* A case in a case statement

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

* A **control variable**
* The `?` (question mark) keyword
* An opening curly brace
* Any number of possible matches, each of which consists of:
    * A **case**
    * The `=>` (fat comma) keyword
    * A **value**
    * A trailing comma
* A closing curly brace

### Behavior

The entire selector statement is **treated as a single value.**

Puppet compares the **control variable** to each of the **cases,** in the order they are listed. When it finds a matching case, it will treat that value as the value of the statement and ignore the remainder of the statement.

* Basic cases are compared with [the `==` operator][equality] (which is case-insensitive).
* Regular expression cases are compared with [the `=~` operator][regex_compare] (which is case-sensitive).
* The special `default` case matches anything.

If none of the cases match, Puppet will **fail compilation with a parse error.** Consequently, a default case should be considered mandatory.

### Control Variables

Control variables in selectors must be **variables** or **functions that return values.** You cannot use expressions as control variables.

### Cases

Cases may be any of the following:

* A literal value (remember to quote strings)
* A variable
* A [function][functions] call that returns a value
* A [regular expression][regex]
* The special bare word value `default`

Note that you cannot use arbitrary [expressions][] or [selectors](#selectors) as cases.

**Unlike in case statements,** you cannot use lists of cases. If you need more than one case associated with a single value, you must use a regular expression.

Normal values are compared to the control variable using [the `==` operator][equality], and regular expressions are compared with [the `=~` operator][regex_compare]. The special `default` case matches any control variable.

Cases are compared in the order that they are written in the manifest; thus, the `default` case (if any) must be at the end of the list.

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated value as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

~~~ ruby
    $system = $operatingsystem ? {
      /(RedHat|Debian)/ => "our system is $1",
      default           => "our system is unknown",
    }
~~~

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the value associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

### Values

Values may be any of the following:

* Any literal value, with the exception of hash literals
* A variable
* A [function][functions] call that returns a value
* Another selector

Note that you cannot use arbitrary [expressions][] as values.
