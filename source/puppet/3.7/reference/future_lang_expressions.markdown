---
title: "Future Parser: Expressions"
layout: default
canonical: "/puppet/latest/reference/future_lang_expressions.html"
---

[conditional]: ./lang_conditional.html
[datatypes]: ./lang_datatypes.html
[boolean]: ./lang_datatypes.html#booleans
[numbers]: ./lang_datatypes.html#numbers
[strings]: ./lang_datatypes.html#strings
[arrays]: ./lang_datatypes.html#arrays
[hashes]: ./lang_datatypes.html#hashes
[regex]: ./lang_datatypes.html#regular-expressions
[regex_match]: http://www.ruby-doc.org/core/Regexp.html
[if]: ./lang_conditional.html#if-statements
[case]: ./lang_conditional.html#case-statements
[selector]: ./lang_conditional.html#selectors
[function]: ./lang_functions.html
[bool_convert]: ./lang_datatypes.html#automatic-conversion-to-boolean
[variables]: ./lang_variables.html


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

* **infix operators** appear between two operands: `$a = 1`, `5 < 9`, `$operatingsystem != 'Solaris'`, etc.
* **prefix operators** appear immediately before a single operand: `*$interfaces`, `!$is_virtual`, etc.

The vast majority of operators are infixes. Expressions may optionally be surrounded by parentheses, which can help
make your code clearer: `($operatingsystem == 'Solaris') or ($virtual == 'LXC')`.

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
5. `=~` and `!~` (regex matches and non-match)
6. `*`, `/`, and `%` (multiplication, division, and modulo)
7. `+` and `-` (subtraction and addition/concatenation)
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

This operator is **non-transitive** with regard to data types: it accepts a [string][strings] as the left operand, and the following types of right operands:

* [Strings][] --- Tests whether the left operand is a substring of the right, ignoring case.
* [Arrays][] --- Tests whether one of the members of the array is identical to the left operand (case-sensitive).
* [Hashes][] --- Tests whether the hash has a **key** identical to the left operand (case-sensitive).

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
    'eat' in { 'present' => 'eat', 'past' => 'ate' } # resolves to false
{% endhighlight %}

Boolean Operators
-----

Boolean Operators have the following traits:

* They take [**boolean**][boolean] operands; if another data type is given, it will be [automatically converted to boolean][bool_convert]
* They resolve to [**boolean**][boolean] values

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

* They take two [**numeric**][numbers] operands
* They resolve to [**numeric**][numbers] values

### `+` (addition)

Resolves to the sum of the two operands.

### `-` (subtraction)

Resolves to the difference of the two operands.

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

Array Operations
-----

### `*` (splat)

"Unfolds" an array into a series of function arguments. For example:

{% highlight ruby %}
    $a = ['vim', 'emacs']
    myfunc($a)    # calls myfunc with a single argument: the array containing 'vim' and 'emacs'
    myfunc(*$a)   # calls myfunc with two arguments: 'vim' and 'emacs'
{% endhighlight %}

### `+` (concatenation)

Resolves to an array containing the elements in the left operand and the elements in the right operand. One or both operands must be an array, or the result will be the arithmetical sum. This operation **does not change** the operands.

### `-` (removal)

Resolves to an array containing the elements in the left operand without the elements in the right operand. The left operand must be an array, but the right
operand may be any data type. This operation **does not change** the operands.


Assignment Operations
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
