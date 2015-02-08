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


**Expressions** resolve to values and can be used almost everywhere values of the [standard data types][datatypes] are required.  Expressions can be compounded with other expressions and the entire combined expression will resolve to a single value.

Location
-----

Expressions can be used almost everywhere:

* The operand of another expression
* The condition of an [if statement][if]
* The control expression of a [case statement][case] or [selector statement][selector]
* The assignment value of a variable
* The value of a resource attribute
* The argument(s) of a [function][] call
* As the title of a resource
* As an entry in an array or hash (key or value)

Expressions cannot be used:

* Where a literal name of a class or define is expected (e.g. in `class` or `define` statements)
* As the name of a variable (the name of the variable must be a literal name)

Syntax
-----

Operator expressions take two basic forms:

* **infix operators** appear between operands: `$a = 1`, `5 < 9`, `$operatingsystem != 'Solaris'`, etc. Operators that operate on two operands are said to be *binary* operators.
* **prefix operators** appear immediately before a single operand: `*$interfaces`, `!$is_virtual`, etc. Prefix operators are also called *unary* operators.

More complex expressions involve multiple operators, punctuation (such as commas), and/or
keywords: `$a ? { 0 => false, 1 => true }`, `if $a == 1 { 'red' } else { 'blue'}`, etc.

The vast majority of operators are infixes. Expressions may optionally be surrounded by parentheses to alter the order of evaluation: `10+10/5` is 12, and `(10+10)/5` is 4. Parentheses can help
make your code clearer: `($operatingsystem == 'Solaris') or ($virtual == 'LXC')`.

### Operands

Operands in an expression may be any other expression:

* Literal values
* [Variables][]
* Other expressions
* [Function calls][function] which return values

The [data type][datatypes] of each operand is dictated by the operator. See the list of operators below for details.

When creating compound expressions by using other expressions as operands, you may use parentheses for clarity:

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
5. `=~` and `!~` (regex or type matches and non-match)
6. `*`, `/`, and `%` (multiplication, division, and modulo)
7. `+` and `-` (addition/concatenation and subtraction/deletion)
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

Comparisons of [numbers][numbers] automatically converts between floating point and integral
values such that `1.0 == 1` is true. Note that calculated floating point values are inexact in that two mathematically equal values may have fractional differences when encoded as a floating point values.

Comparisons of [string][strings] values are case independent for characters in the US ASCII range. Characters outside this range are case sensitive. Characters are compared based on their encoding. This means that for characters in US ASCII range, punctuation comes before digits, digits are in the order 0, 1, 2, ... 9, and letters are in alphabetical order. For characters outside the range the order is defined by their UTF-8 character code which may not always place them in alphabetical order in a given international locale.

It is never an error to compare two values with equals (`==`) or not equals (`!=`), but only strings and numbers can be compared with operators that require values to have a defined order.
 
### `==` (equality)

Resolves to `true` if the operands are equal. Accepts the following types of operands:

* [Numbers][] --- Tests simple equality.
* [Strings][] --- Case-insensitively tests whether two strings are identical.
* [Arrays][] and [hashes][] --- Tests whether two arrays or hashes are identical.
* [Booleans][boolean] --- Tests whether two booleans are the same value.

Values are only considered equal if they have the same data type. Notably, this means that
`1 == "1"` is false, and `"true" == true` is false.

### `!=` (non-equality)

Resolves to `false` if the operands are equal. Note that `$x != $y` is the same as `!($x == $y)`.
For details about equality see `==`.

### `<` (less than)

Resolves to `true` if the left operand is smaller than the right operand. Accepts [numbers][] and [strings][].

### `>` (greater than)

Resolves to `true` if the left operand is bigger than the right operand. Accepts [numbers][] and [strings][].

### `<=` (less than or equal to)

Resolves to `true` if the left operand is smaller than or equal to the right operand. Accepts [numbers][] and [strings][].

### `>=` (greater than or equal to)

Resolves to `true` if the left operand is bigger than or equal to the right operand. Accepts [numbers][] and [strings][].

### `=~` (regex match)

<!-- TODO: (regex match) should be changed, it is not only for regular expressions.
     suggestion: (matches operator) -->

This operator is **non-transitive** with regard to data types: it accepts different types of values as operands depending on the type of the right operand, which is one of the following types:

* [Literal Regexp][regex] --- a literal regular expression e.g. `/abc.*/`. The left operand
  must be of string value.
* [Regexp in String form][regex] --- a string value expression resulting in a regular expression
  in string form e.g. `$x =~ "abc.*"`. The left operand must be of string value.
* A Type --- matches if the left operand is an instance of the given type - e.g. `5 =~ 
  Integer[1,10]` is true.

Resolves to `true` if the left operand [matches][regex_match] the right operand.

### `!~` (regex non-match)
<!-- TODO: (regex non-match) should be changed, it is not only for regular expressions. 
     suggestion: (not-matches operator) -->

Resolves to `false` if the left operand [matches][regex_match] the right operand. Note that `$x !~ $y` is the same as `!($x =~ $y)`. For details about matching see the [matches][regex_match] operator.

### `in`

Resolves to `true` if the right operand contains the left operand. The exact definition of "contains" here depends on the data type of the right operand. This operator is **non-transitive** with regard to data types.

| left      | right  | Description
| --        | --     |
| String    | String | true if left is a substring of right using == to compare substrings
| Regexp    | String | true if the string matches the regexp
| *any other* | String | false
| 
| Type      | Array | true if there is an element in the array of the given type
| Regexp    | Array | true if there is an array element that matches the regexp (non string elements are skipped).
| *any other* | Array | true if there is an array element that is equal to the left value
| 
| Any       | Hash | true if left is `in` the array of hash keys
| 
| Any       | *any other* | false


Examples:

{% highlight ruby %}
    # Right-hand operand is a string:
    'eat' in 'eaten' # resolves to true
    'Eat' in 'eaten' # resolves to true

    # Right hand operand is an array:
    'eat' in ['eat', 'ate', 'eating'] # resolves to true
    'Eat' in ['eat', 'ate', 'eating'] # resolves to true

    # Right hand operand is a hash:
    'eat' in { 'eat' => 'present tense', 'ate' => 'past tense'} # resolves to true
    'eat' in { 'present' => 'eat', 'past' => 'ate' }            # resolves to false

    # Left hand operand is a regular expression (with the case-insensitive option "?i")
    /(?i:EAT)/ in ['eat', 'ate', 'eating'] # resolves to true
    
    # left hand is a type (an integer between 100-199)
    Integer[100, 199] in [1, 2, 125] # resolves to true
    Integer[100, 199] in [1, 2, 25]  # resolves to false
    
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

"Unfolds" an array into a series of individual arguments to a function or case options. For example:

{% highlight ruby %}
    $a = ['vim', 'emacs']
    myfunc($a)    # calls myfunc with a single argument: the array containing 'vim' and 'emacs'
    myfunc(*$a)   # calls myfunc with two arguments: 'vim' and 'emacs'
{% endhighlight %}

{% highlight ruby %}
    $a = ['vim', 'emacs']
    $x = 'vim'
    notice case $x {
      $a      : { 'an array with both vim and emacs' }
      *$a     : { 'vim or emacs'}
      default : { 'no match' }
    }
{% endhighlight %}


### `+` (concatenation)

Resolves to an array containing the elements in the left operand and the elements in the right operand. Left or both operands must be an array, or the result will be the arithmetical sum. This operation **does not change** the operands.

### `-` (removal)

Resolves to an array containing the elements in the left operand without the elements in the right operand. The left operand must be an array, but the right
operand may be any data type. This operation **does not change** the operands.

{% highlight ruby %}
    $a = ['vim', 'emacs', 'geppetto']
    notice( $a - 'vim') # resolves to ['emacs', 'geppetto']
{% endhighlight %}

If the right operand is an array, each of its entries are removed from the left. Thus, to remove array entries from the left, wrap the array in another array.

{% highlight ruby %}
    $a = [1, 2, 3, [1, 2]]
    notice( $a - [1, 2])   # resolves to [3, [1, 2]]
    notice( $a - [[1, 2]]) # resolves to [1, 2, 3]
{% endhighlight %}


Assignment Operations
-----

### `=` (assignment)

The assignment operator sets the [variable](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html) on the left hand side to the value on the right hand side. The entire expression resolves to the value of the right hand side.

Note that variables can only be set once, after which any attempt to set the variable to a new value will cause an error.

Backus-Naur Form
-----
<!-- TODO: This grammar is quite INCOMPLETE and has errors. 
     += and -= are removed
     % is missing
     in, ? {} is missing
     splat is missing
     names of operators are misleading since their meaning depend on data type
     (e.g. + is concat, - is delete as well as being arithmetic operators).
     the matchop does not require a right regexp (can be string or a Type).
     there are other constructs that are also right values
     heredoc is missing
     
     Suggest referring the user to the specification instead (at least initially).
-->

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
