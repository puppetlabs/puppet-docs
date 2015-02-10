---
title: "Future Parser: Conditional Statements"
layout: default
canonical: "/puppet/latest/reference/future_lang_conditional.html"
---


[local]: ./future_lang_scope.html#local-scopes
[boolean]: ./future_lang_datatypes.html#booleans
[regex]: ./future_lang_datatypes.html#regular-expressions
[facts]: ./future_lang_variables.html#facts
[equality]: ./future_lang_expressions.html#equality
[fail]: /references/latest/function.html#fail
[regex_compare]: ./future_lang_expressions.html#regex-match
[expressions]: ./future_lang_expressions.html
[bool_convert]: ./future_lang_datatypes.html#automatic-conversion-to-boolean
[variables]: ./future_lang_variables.html
[functions]: ./future_lang_functions.html


Conditional statements let your Puppet code behave differently in different situations. They are most helpful when combined with [facts][] or with data retrieved from an external source.

Summary
-----

Puppet supports "if" and "unless" statements, "case" statements, and selectors.

An "if" statement:

{% highlight ruby %}
    if $is_virtual == 'true' {
      warning('Tried to include class ntp on virtual machine; this node may be misclassified.')
    }
    elsif $operatingsystem == 'Darwin' {
      warning('This NTP module does not yet work on our Mac laptops.')
    }
    else {
      include ntp
    }
{% endhighlight %}

An "unless" statement:

{% highlight ruby %}
    unless $memorysize > 1024 {
      $maxclient = 500
    }
{% endhighlight %}

A case statement:

{% highlight ruby %}
    case $operatingsystem {
      'Solaris':          { include role::solaris }
      'RedHat', 'CentOS': { include role::redhat  }
      /^(Debian|Ubuntu)$/:{ include role::debian  }
      default:            { include role::generic }
    }
{% endhighlight %}

A selector:

{% highlight ruby %}
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
{% endhighlight %}

"If" Statements
-----

**"If" statements** take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is **true.** They can optionally include `elsif` and `else` clauses.


### Syntax

{% highlight ruby %}
    if $is_virtual == 'true' {
      # Our NTP module is not supported on virtual machines:
      warn( 'Tried to include class ntp on virtual machine; this node may be misclassified.' )
    }
    elsif $operatingsystem == 'Darwin' {
      warn ( 'This NTP module does not yet work on our Mac laptops.' )
    }
    else {
      # Normal node, include the class.
      include ntp
    }
{% endhighlight %}

The general form of an "if" statement is:

* The `if` keyword
* A **condition**
* A pair of curly braces containing any Puppet code
* **Optionally:** the `elsif` keyword, another condition, and a pair of curly braces containing Puppet code. The `elsif` part can be repeated.
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

{% highlight ruby %}
    if $hostname =~ /^www(\d+)\./ {
      notice("Welcome to web server number $1")
    }
{% endhighlight %}

This example would capture any digits from a hostname like `www01` and `www02` and store them in the `$1` variable.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

### If as an Expression

**"If"** is really an expression that produces a value and it may be used wherever a value
is allowed. This means you can write:

{% highlight ruby %}
    $maxclient = if $memorysize > 1024 { 
        500 
      }
      else {
        100
      }
{% endhighlight %}

Instead of:

{% highlight ruby %}
    if $memorysize > 1024 { 
      $maxclient = 500 
    }
    else {
      $maxclient = 100
    }
{% endhighlight %}


The value of the `if` expression is the value of the last expression in executed block, or undef
if no block was executed.

"Unless" Statements
-----

**"Unless" statements** work like reversed "if" statements. They take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is **false.** They **cannot** include `elsif` clauses.

### Syntax

{% highlight ruby %}
    unless $memorysize > 1024 {
      $maxclient = 500
    }
{% endhighlight %}

The general form of an "unless" statement is:

* The `unless` keyword
* A **condition**
* A pair of curly braces containing any Puppet code
* **Optionally:** the `else` keyword and a pair of curly braces containing Puppet code

If an `elsif` clause is included in an "unless" statement, it is a syntax error and will cause compilation to fail.

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

Although "unless" statements receive regex capture variables like "if" statements, they usually aren't used, since the code in the statement will only be executed if the condition didn't match anything. It's possible to use regex captures in the "else" clause, but it would make more sense to just use an "if" statement.

### Unless as an Expression

**"Unless"** is really an expression that produces a value and it may be used wherever a value
is allowed. The value of the `unless` expression is the value of the last expression in executed block, or undef if no block was executed.


Case Statements
-----

Like "if" statements, **case statements** choose one of several blocks of arbitrary Puppet code to execute. They take a control expression and a list of cases and code blocks, and will execute the first block whose case value matches the control expression.

### Syntax

{% highlight ruby %}
    case $operatingsystem {
      'Solaris':          { include role::solaris } # apply the solaris class
      'RedHat', 'CentOS': { include role::redhat  } # apply the redhat class
      /^(Debian|Ubuntu)$/:{ include role::debian  } # apply the debian class
      default:            { include role::generic } # apply the generic class
    }
{% endhighlight %}

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
* Type expression cases are compared with [the `=~` operator][regexp_compare]
* The special `default` case matches anything, but only if none of the other cases match.

If none of the cases match, Puppet will do nothing and move on.

Case statements will execute a maximum of one code block.

### Control Expressions

The control expression of a case statement may be any fragment of Puppet code that resolves to a normal value or type. This includes:

* [Variables][]
* [Expressions][]
* [Functions][] that return values

### Cases

Cases may be any any fragment of Puppet code that resolves to a normal value or type, including the following:

* A literal value (remember to quote strings)
* A variable
* A [function][functions] call that returns a value
* A [regular expression][regex]
* The special bare word value `default`

You may use a comma-separated list of cases to associate more than one case with the same block of code.

Normal values are compared to the control expression using [the `==` operator][equality], and regular expressions and types are compared with [the `=~` operator][regex_compare]. The special `default` case matches any control expression.

Cases are compared in the order that they are written in the manifest --- if more than one case might match for a given node, the first one will win. The one exception is the special `default` case, which will only be used as a last resort, regardless of its position in the list.

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

{% highlight ruby %}
    case $hostname {
      /www(d+)/: { notice("Welcome to web server number ${1}"); include role::web }
      default:   { include role::generic }
    }
{% endhighlight %}

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

### Case as an Expression

**"Case"** is really an expression that produces a value and it may be used wherever a value
is allowed. The value of the `case` expression is the value of the last expression in executed block, or undef if no block was executed.

{% highlight ruby %}
    notice case $hostname {
      /www(d+)/: { include role::web; "Welcome to web server number ${1}" }
      default:   { include role::generic; "Generic role selected" }
    }
{% endhighlight %}

This example would notice either the `"Welcome to..."` or the `"Generic role..."` messages
depending what the value of `$hostname` is. This because the respective literal string value
is last in the case's executed block, and this value becomes the value of the case expression which
is given to the `notice` function as an argument.

Selectors
-----

**Selector expressions** are similar to case statements, but only return a value instead of also executing a code block.

### Location

Selectors can be placed wherever a **value** is expected. This includes:

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

{% highlight ruby %}
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
{% endhighlight %}

In the example above, the value of `$rootgroup` is determined using the value of `$osfamily`.

The general form of a selector is:

* A **control expression**
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

Puppet compares the value of **control expression** to each of the **cases,** in the order they are listed. When it finds a matching case, it will treat that value as the value of the statement and ignore the remainder of the statement.

* Basic cases are compared with [the `==` operator][equality] (which is case-insensitive).
* Regular expression and type cases are compared with [the `=~` operator][regex_compare] (which is case-sensitive).
* The special `default` case matches anything, but only as a last resort if none of the other cases match.

If none of the cases match, Puppet will **fail compilation with a parse error.** Consequently, a default case should be considered mandatory.

### Control Expressions

The control expression of a selector may be any fragment of Puppet code that resolves to a normal value. This includes:

* [Variables][]
* [Expressions][]
* [Functions][] that return values

### Cases

Cases may be any any fragment of Puppet code that resolves to a normal value or type including
the following:

* A literal value (remember to quote strings)
* A variable
* A [function][functions] call that returns a value
* A [regular expression][regex]
* The special bare word value `default`


**Unlike in case statements,** you cannot use lists of cases. If you need more than one case associated with a single value, you can use a regular expression if the matched value is a string. Otherwise, use a `case` expression instead of the selector expression.

Normal values are compared to the control variable using [the `==` operator][equality], and regular expressions and types are compared with [the `=~` operator][regex_compare]. The special `default` case matches any control variable.

Cases are compared in the order that they are written in the manifest. The one exception is the special `default` case, which will only be used as a last resort, regardless of its position in the list.

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated value as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

{% highlight ruby %}
    $system = $operatingsystem ? {
      /(RedHat|Debian)/ => "our system is ${1}",
      default           => "our system is unknown",
    }
{% endhighlight %}

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the value associated with the pattern that set them.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

### Values

Values may be any any fragment of Puppet code that resolves to a normal value or type, including the following:

* Any literal value, with the exception of hash literals
* A variable
* A [function][functions] call that returns a value
* Another selector

