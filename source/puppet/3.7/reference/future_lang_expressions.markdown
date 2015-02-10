---
title: "Future Parser: Expressions"
layout: default
canonical: "/puppet/latest/reference/future_lang_expressions.html"
---

[conditional]: ./future_lang_conditional.html
[datatypes]: ./future_lang_datatypes.html
[boolean]: ./future_lang_datatypes.html#booleans
[numbers]: ./future_lang_datatypes.html#numbers
[strings]: ./future_lang_datatypes.html#strings
[arrays]: ./future_lang_datatypes.html#arrays
[hashes]: ./future_lang_datatypes.html#hashes
[regex]: ./future_lang_datatypes.html#regular-expressions
[regex_match]: http://www.ruby-doc.org/core/Regexp.html
[if]: ./future_lang_conditional.html#if-statements
[case]: ./future_lang_conditional.html#case-statements
[selector]: ./future_lang_conditional.html#selectors
[function]: ./future_lang_functions.html
[bool_convert]: ./future_lang_datatypes.html#automatic-conversion-to-boolean
[variables]: ./future_lang_variables.html


**Expressions** resolve to values and can be used in **most** of the places where values of the [standard data types][datatypes] are required.  Expressions can be compounded with other expressions and the entire combined expression will resolve to a single value.

Most expressions resolve to [boolean][] values. They are particularly useful as conditions in [conditional statements][conditional].

Location
-----

Expressions can be used in the following places:

* The operand of another expression
* The condition of an [if statement][if]
* The control expression of a [case statement][case] or [selector statement][selector]
* The assignment value of a variable
* The value of a resource attribute
* The argument(s) of a [function][] call

They cannot be used as resource titles.

Syntax
-----

Operator expressions take two basic forms:

* **Infix operators** appear between two operands: `$a = 1`, `5 < 9`, `$operatingsystem != 'Solaris'`, etc.
* **Prefix (or unary) operators** appear immediately before a single operand: `*$interfaces`, `!$is_virtual`, etc.

The vast majority of operators are infixes. Expressions may optionally be surrounded by parentheses, which can help
make compound expressions clearer: `($operatingsystem == 'Solaris') or ($virtual == 'LXC')`.

### Operands

Operands in an expression may be:

* Literal values
* [Variables][]
* Other expressions
* [Function calls][function] which return values

The [data type][datatypes] of each operand is dictated by the operator. See the list of operators below for details.

When creating compound expressions by using other expressions as operands, you should use parentheses for clarity:

{% highlight ruby %}
    (90 < 7) and ('Solaris' == 'Solaris') # resolves to false
    (90 < 7) or ('solaris' in ['linux', 'solaris']) # resolves to true
{% endhighlight %}


Order of Operations
-----

Compound expressions are evaluated in a standard order of operations. However, parentheses will override the order of operations:

{% highlight ruby %}
    # This example will resolve to 30, rather than 23.
    notice( (7+8)*2 )
{% endhighlight %}

For the sake of clarity, we recommend using parentheses in all but the simplest compound expressions.

The precedence of operators, from highest to lowest:

1. `!` (unary: not)
2. `-` (unary: numeric negation)
3. `*` (unary: array splat)
4. `in`
5. `=~` and `!~` (regex match and non-match)
6. `*`, `/`, and `%` (multiplication, division, and modulo)
7. `+` and `-` (addition and subtraction)
8. `<<` and `>>` (left shift/append and right shift)
9. `==` and `!=` (equal and not equal)
10. `>=`, `<=`, `>`, and `<` (greater or equal, less or equal, greater than, and less than)
11. `and`
12. `or`
13. `=` (assignment)


Comparison Operators
-----

Comparison operators have the following traits:

* They take operands of **several data types**
* They resolve to [**boolean**][boolean] values

### `==` (equality)

Resolves to `true` if the operands are equal. Accepts the following types of operands:

* [Numbers][] --- Tests simple equality.
* [Strings][] --- Case-insensitively tests whether two strings are identical.
* [Arrays][] and [hashes][] --- Tests whether two arrays or hashes are identical.
* [Booleans][boolean] --- Tests whether two booleans are the same value.

### `!=` (non-equality)

Resolves to `false` if the operands are equal. Behaves similarly to `==`.

### `<` (less than)

Resolves to `true` if the left operand is smaller than the right operand. Accepts [numbers][].

The behavior of this operator when used with strings is undefined.

### `>` (greater than)

Resolves to `true` if the left operand is bigger than the right operand. Accepts [numbers][].

The behavior of this operator when used with strings is undefined.

### `<=` (less than or equal to)

Resolves to `true` if the left operand is smaller than or equal to the right operand. Accepts [numbers][].

The behavior of this operator when used with strings is undefined.

### `>=` (greater than or equal to)

Resolves to `true` if the left operand is bigger than or equal to the right operand. Accepts [numbers][].

The behavior of this operator when used with strings is undefined.

### `=~` (regex match)

This operator is **non-transitive** with regard to data types: it accepts a [string][strings] as the left operand and a [regular expression][regex] as the right operand.

Resolves to `true` if the left operand [matches][regex_match] the regular expression.

### `!~` (regex non-match)

This operator is **non-transitive** with regard to data types: it accepts a [string][strings] as the left operand and a [regular expression][regex] as the right operand.

Resolves to `false` if the left operand [matches][regex_match] the regular expression.

### `in`

Resolves to `true` if the right operand contains the left operand. The exact definition of "contains" here depends on the data type of the right operand.

This operator is **non-transitive** with regard to data types. It accepts:

* A [string][strings] or [regular expression][regex] as the left operand.
* A [string][strings], [array][arrays], or [hash][hashes] as the right operand.

If the left operand is a string, an `in` expression checks the right operand as follows:

* [Strings][] --- Tests whether the left operand is a substring of the right, ignoring case.
* [Arrays][] --- Tests whether one of the members of the array is identical to the left operand (case-sensitive).
* [Hashes][] --- Tests whether the hash has a **key** identical to the left operand (case-sensitive).

If the left operand is a regular expression, it checks the right operand as follows:

* [Strings][] --- Tests whether the right operand matches the regular expression.
* [Arrays][] --- Tests whether one of the members of the array matches the regular expression.
* [Hashes][] --- Tests whether the hash has a **key** that matches the regular expression.

Examples:

{% highlight ruby %}
    # Right-hand operand is a string:
    'eat' in 'eaten' # resolves to true
    'Eat' in 'eaten' # resolves to true

    # Right hand operand is an array:
    'eat' in ['eat', 'ate', 'eating'] # resolves to true
    'Eat' in ['eat', 'ate', 'eating'] # resolves to false

    # Right hand operand is a hash:
    'eat' in { 'eat' => 'present tense', 'ate' => 'past tense'} # resolves to true
    'eat' in { 'present' => 'eat', 'past' => 'ate' }            # resolves to false

    # Left hand operand is a regular expression (with the case-insensitive option "?i")
    /(?i:EAT)/ in ['eat', 'ate', 'eating'] # resolves to true
{% endhighlight %}

Boolean Operators
-----

Boolean Operators have the following traits:

* They take [**boolean**][boolean] operands; if another data type is given, it will be [automatically converted to boolean][bool_convert].
* They resolve to [**boolean**][boolean] values.

These expressions are most useful when creating compound expressions.

### `and`

Resolves to `true` if both operands are true, otherwise resolves to `false`.

### `or`

Resolves to `true` if either operand is true.

### `!` (not)

**Takes one operand:**

{% highlight ruby %}
    $my_value = true
    notice ( !$my_value ) # Will resolve to false
{% endhighlight %}

Resolves to `true` if the operand is false, and `false` if the operand is true.


Arithmetic Operators
-----

Arithmetic Operators have the following traits:

* They take two [**numeric**][numbers] operands (except unary `-`)
    * If an operand is a string, it will be converted to numeric form. The operation fails if a string can't be converted.
* They resolve to [**numeric**][numbers] values

### `+` (addition)

Resolves to the sum of the two operands.

### `-` (subtraction and negation)

Resolves to the difference of the two operands.

There is also a unary form of `-`, which takes one numeric operand and returns the value of subtracting that operand from zero.

### `/` (division)

Resolves to the quotient of the two operands.

### `*` (multiplication)

Resolves to the product of the two operands. Not to be confused with the [splat operator](#splat), which only takes one operand.

### `%` (modulo)

Resolves to the **remainder** of dividing the first operand by the second operand. (E.g. `5 % 2` would resolve to `1`.)

### `<<` (left shift)

Left bitwise shift: shifts the left operand by the number of places specified by the right operand. This is equivalent to rounding each operand down to the nearest integer and multiplying the left operand by 2 to the power of the right operand.

### `>>` (right shift)

Right bitwise shift: shifts the left operand by the number of places specified by the right operand. This is equivalent to rounding each operand down to the nearest integer and dividing the left operand by 2 to the power of the right operand.

Array Operators
-----

### `*` (splat)

This unary operator accepts a single array value. (If given a scalar value, it will convert it to a single-element array.)

"Unfolds" a single array into comma-separated list of values. This lets you use variables in places where, in previous versions of the language, only literal lists were allowed.

For example:

{% highlight ruby %}
    $a = ['vim', 'emacs']
    myfunc($a)    # calls myfunc with a single argument: the array containing 'vim' and 'emacs'
    myfunc(*$a)   # calls myfunc with two arguments: 'vim' and 'emacs'
{% endhighlight %}

The splat operator is only meaningful in places where a comma-separated list of values is valid. Those places are:

* The arguments of a function call
* The cases of a case statement
* The cases of a selector statement

In any other context, splat just resolves to the array it was given.

### `+` (concatenation)

Resolves to an array containing the elements in the left operand and the elements in the right operand. One or both operands must be an array, or the result will be the arithmetical sum. This operation **does not change** the operands.

### `-` (removal)

Resolves to an array containing the elements in the left operand without the elements in the right operand. The left operand must be an array, but the right
operand may be any data type. This operation **does not change** the operands.


Assignment Operators
-----

### `=` (assignment)

The assignment operator sets the [variable](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html) on the left hand side to the value on the right hand side. The entire expression resolves to the value of the right hand side.

Note that variables can only be set once, after which any attempt to set the variable to a new value will cause an error.

Backus-Naur Form
-----

With the exception of the `in` operator, the available operators in Backus-Naur Form are:

    <exp> ::=  <exp> <arithop> <exp>
             | <exp> <boolop> <exp>
             | <exp> <compop> <exp>
             | <exp> <matchop> <regex>
             | <variable> <assignop> <rightvalue>
             | ! <exp>
             | - <exp>
             | "(" <exp> ")"
             | <rightvalue>

    <arithop> ::= "+" | "-" | "/" | "*" | "<<" | ">>"
    <boolop>  ::= "and" | "or"
    <compop>  ::= "==" | "!=" | ">" | ">=" | "<=" | "<"
    <matchop>  ::= "=~" | "!~"
    <assignop> ::= "=" | "+=" | "-="

    <rightvalue> ::= <variable> | <function-call> | <literals>
    <literals> ::= <float> | <integer> | <hex-integer> | <octal-integer> | <quoted-string>
    <regex> ::= '/regex/'
