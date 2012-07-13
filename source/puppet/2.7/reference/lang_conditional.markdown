---
title: "Language: Conditional Statements"
layout: default
---


<!-- TODO -->
[boolean]: ./lang_datatypes.html#booleans
[regex]: ./lang_datatypes.html#regular-expressions
[facts]: 
[equality]: 
[fail]: /references/latest/function.html#fail
[regex_compare]:
[expressions]: 
[bool_convert]: ./lang_datatypes.html#automatic-conversion-to-boolean
[variables]: 
[expressions]: 
[functions]: 


Conditional statements let your Puppet code behave differently in different situations. They are most helpful when combined with [facts][] or data retrieved from an external source.

Summary
-----

Puppet 2.7 supports "if" statements, case statements, and selectors. 

An "if" statement: 

{% highlight ruby %}
    if $is_virtual == 'true' {
      warn( 'Tried to include class ntp on virtual machine; this node may be misclassified.' )
    }
    elsif $operatingsystem == 'Darwin' {
      warn ( 'This NTP module does not yet work on our Mac laptops.' )
    else {
      include ntp
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

**"If" statements** take a [boolean][] condition and an arbitrary block of Puppet code, and will only execute the block if the condition is true. They can optionally include `elsif` and `else` clauses. 


### Syntax

{% highlight ruby %}
    if $is_virtual == 'true' {
      # Our NTP module is not supported on virtual machines:
      warn( 'Tried to include class ntp on virtual machine; this node may be misclassified.' )
    }
    elsif $operatingsystem == 'Darwin' {
      warn ( 'This NTP module does not yet work on our Mac laptops.' )
    else {
      # Normal node, include the class.
      include ntp
    }
{% endhighlight %}

The general form of an "if" statement is:

* The `if` keyword
* A **condition**
* A pair of curly braces containing any arbitrary Puppet code
* **Optionally:** the `elsif` keyword, another condition, and a pair of curly braces containing Puppet code
* **Optionally:** the `else` keyword and a pair of curly braces containing Puppet code

### Behavior

Puppet's "if" statements behave much like those in any other language. The `if` condition is processed first, and if it is true, only the `if` code block is executed. If it is false, each `elsif` condition (if present) is tested in order, and if all conditions fail, the `else` code block (if present) is executed.

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

If you use the regular expression match operator in a condition, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.):

{% highlight ruby %}
    if $hostname =~ /^www(\d+)\./ {
      notice("Welcome to web server number $1")
    }
{% endhighlight %}

This example would capture any digits from a hostname like `www01` and `www02` and store them in the `$1` variable.

These are not normal variables, and are not available outside their conditional code block. 

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

* Basic cases are compared with [the `==` operator][equality].
* Regular expression cases are compared with [the `=~` operator][regex_compare].
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

Cases are compared in the order that they are written in the manifest; thus, the `default` case (if any) must be at the end of the list. 

#### Regex Capture Variables

If you use regular expression cases, any captures from parentheses in the pattern will be available inside the associated code block as numbered variables (`$1, $2`, etc.), and the entire match will be available as `$0`:

{% highlight ruby %}
    if $hostname =~ /^www(\d+)\./ {
      notice("Welcome to web server number $1")
    }
{% endhighlight %}

This example would capture any digits from a hostname like `www01` and `www02` and store them in the `$1` variable.

These are not normal variables, and are not available outside their conditional code block. 


> #### Aside: Best Practices
> 
> Case statements should usually have a default case. 
> 
> * If the rest of your cases are meant to be comprehensive, putting a [`fail('message')`][fail] call in the default case makes your code more robust, by protecting against mystery failures due to behavior changes elsewhere in your manifests.
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

* A **control variable**
* The `?` (question mark) keyword
* An opening curly brace
* Any number of possible matches, which consist of:
    * A **case**
    * The `=>` (fat comma) keyword
    * A **value**
    * A trailing comma
* A closing curly brace

### Behavior

The entire selector statement is **treated as a single value.** 

Puppet compares the **control variable** to each of the **cases,** in the order they are listed. When it finds a matching case, it will treat that value as the value of the statement and ignore the remainder of the statement.

* Basic cases are compared with [the `==` operator][equality].
* Regular expression cases are compared with [the `=~` operator][regex_compare].
* The special `default` case matches anything.

If none of the cases match, Puppet will **fail compilation with a parse error.** As such, a default case should be considered mandatory.

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

{% highlight ruby %}
    $system = $operatingsystem ? {
      /(RedHat|Debian)/ => "our system is $1",
      default           => "our system is unknown",
    }
{% endhighlight %}

These are not normal variables, and are not available outside the selector statement.

### Values

Values may be any of the following:

* A literal value
* A variable
* A [function][functions] call that returns a value
* Another selector

Note that you cannot use arbitrary [expressions][] as values.
