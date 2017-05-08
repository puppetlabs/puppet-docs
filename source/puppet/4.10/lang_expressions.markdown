---
title: "Language: Expressions and operators"
layout: default
---

[datatypes]: ./lang_data.html
[boolean]: ./lang_data_boolean.html
[numbers]: ./lang_data_number.html
[strings]: ./lang_data_string.html
[arrays]: ./lang_data_array.html
[hashes]: ./lang_data_hash.html
[regex]: ./lang_data_regexp.html
[if]: ./lang_conditional.html#if-statements
[case]: ./lang_conditional.html#case-statements
[selector]: ./lang_conditional.html#selectors
[function]: ./lang_functions.html
[bool_convert]: ./lang_data_boolean.html
[variables]: ./lang_variables.html
[resources]: ./lang_resources.html
[class]: ./lang_classes.html
[defined types]: ./lang_defined_types.html
[node definitions]: ./lang_node_definitions.html
[resource collectors]: ./lang_collectors.html
[chaining]: ./lang_relationships.html#syntax-chaining-arrows
[literal_types]: ./lang_data_type.html
[spec]: https://github.com/puppetlabs/puppet-specifications
[lambdas]: ./lang_lambdas.html

**Expressions** are statements that resolve to values.

You can use expressions almost anywhere a value (of the standard [data types][datatypes]) is required. Expressions can be compounded with other expressions, and the entire combined expression will resolve to a single value.

## Basics


In this version of the Puppet language, nearly everything is an expression, including [literal values][datatypes], references to [variables][], [resource declarations][resources], [function calls][function], and more.

In other words: almost all statements in the language will resolve to a value, and can be used anywhere that value would be expected.

### Expressions constructed with operators

Most of this page is about **expressions constructed with operators.** Operators are built-in constructs that take input values of some kind and result in some other value.

Other kinds of expressions (function calls, etc.) are described in more detail on other pages of this manual. This page will mostly focus on the available operators and how they work.

### Expressions with Side Effects

Some (non-operator) expressions always have side effects when evaluated. For example:

* [Resource declarations][resources] always add a resource to the catalog.
* [Variable assignments][variables] always create a variable and assign it a value.
* [Chaining statements][chaining] always form a relationship between two or more resources.

These statements are usually used _only_ for their side effects, with their values ignored. However, the values are sometimes useful for things like forming relationships to resources whose names can't be predicted until runtime.

### List of Non-Expressions

The following statements are NOT normal expressions: they don't resolve to usable values, and can only be used in certain contexts.

* [Class definitions][class]
* [Defined types][]
* [Node definitions][]
* [Resource collectors][]
* [Lambdas][]


## Location


Expressions can be used almost everywhere, including:

* The operand of another expression
* The condition of an [if statement][if]
* The control expression of a [case statement][case] or [selector statement][selector]
* The assignment value of a variable
* The value of a resource attribute
* The argument(s) of a [function][] call
* The title of a resource
* An entry in an array or a key or value of a hash

Expressions cannot be used:

* Where a literal name of a class or defined type is expected (e.g. in `class` or `define` statements)
* As the name of a variable (the name of the variable must be a literal name)
* Where a literal resource type or name of a resource type is expected (e.g. in the type position of a resource declaration)

## Expression syntax


Each kind of expression has its own syntax. Most have their own pages in this manual, where we describe their syntax and behavior in greater detail. See the sections below for the syntax of expressions constructed with operators.

Any expression can optionally be surrounded by parentheses. This can change the order of evaluation in compound expressions (e.g. `10+10/5` is 12, and `(10+10)/5` is 4), or just make your code clearer.

## Operator syntax


There are two kinds of operators:

* **Infix operators** (also called **binary operators**) appear between two operands: `$a = 1`, `5 < 9`, `$operatingsystem != 'Solaris'`, etc.
* **Prefix operators** (also called **unary operators**) appear immediately before a single operand: `*$interfaces`, `!$is_virtual`, etc.

Most operators are infixes.

### Operands

Operands in an expression can be any other expression --- that is, anything that resolves to a value of the expected data type is allowed.

Each operator has its own rules for the [data types][datatypes] of its operands. See the list of operators below for details.

When creating compound expressions by using other expressions as operands, you should use parentheses for clarity:

``` puppet
(90 < 7) and ('Solaris' == 'Solaris') # resolves to false
(90 < 7) or ('Solaris' in ['Linux', 'Solaris']) # resolves to true
```


## Order of Operations


Compound expressions are evaluated in a standard order of operations. However, parentheses will override the order of operations:

``` puppet
# This example will resolve to 30, rather than 23.
notice( (7+8)*2 )
```

For the sake of clarity, we recommend using parentheses in all but the simplest compound expressions.

The precedence of operators, from highest to lowest:

1. `!` (unary: not)
2. `-` (unary: numeric negation)
3. `*` (unary: array splat)
4. `in`
5. `=~` and `!~` (regex or data type match/non-match)
6. `*`, `/`, and `%` (multiplication, division, and modulo)
7. `+` and `-` (addition/array concatenation and subtraction/array deletion)
8. `<<` and `>>` (left shift and right shift)
9. `==` and `!=` (equal and not equal)
10. `>=`, `<=`, `>`, and `<` (greater or equal, less or equal, greater than, and less than)
11. `and`
12. `or`
13. `=` (assignment)


## Comparison operators


Comparison operators have the following traits:

* They take operands of **several data types**
* They resolve to [**boolean**][boolean] values

Comparisons of [numbers][numbers] automatically convert between floating point and integer values, such that `1.0 == 1` is true. Note that floating point values created by division are inexact, and mathematically equal values might be slightly unequal when turned into floating point values.

You can compare any two values with equals (`==`) or not equals (`!=`), but only strings, numbers, and data types can be compared with the less than or greater than operators that require values to have a defined order.

### String encoding and comparisons

Comparisons of [string][strings] values are case insensitive for characters in the US ASCII range. Characters outside this range are case sensitive.

Characters are compared based on their encoding. This means that for characters in the US ASCII range, punctuation comes before digits, digits are in the order 0, 1, 2, ... 9, and letters are in alphabetical order. For characters outside US ASCII, ordering is defined by their UTF-8 character code, which might not always place them in alphabetical order for a given locale.

### `==` (equality)

Resolves to `true` if the operands are equal. Accepts the following data types as operands:

* [Numbers][] --- Tests simple equality.
* [Strings][] --- Tests whether two strings are identical, ignoring case (see above).
* [Arrays][] and [hashes][] --- Tests whether two arrays or hashes are identical.
* [Booleans][boolean] --- Tests whether two booleans are the same value.
* [Data types][literal_types] --- Tests whether two data types would match the exact same set of values.

Values are only considered equal if they have the same data type. Notably, this means that `1 == "1"` is false, and `"true" == true` is false.

### `!=` (non-equality)

Resolves to `false` if the operands are equal. Note that `$x != $y` is the same as `!($x == $y)`.

For more behavior details, see `==`.

### `<` (less than)

Resolves to `true` if the left operand is smaller than the right operand. Accepts [numbers][], [strings][], and [data types][literal_types]; both operands must be the same type.

When acting on data types, `<` is true if the left operand is a _subset_ of the right operand.

### `>` (greater than)

Resolves to `true` if the left operand is bigger than the right operand. Accepts [numbers][], [strings][], and [data types][literal_types]; both operands must be the same type.

When acting on data types, `>` is true if the left operand is a _superset_ of the right operand.

### `<=` (less than or equal to)

Resolves to `true` if the left operand is smaller than or equal to the right operand. Accepts [numbers][], [strings][], and [data types][literal_types]; both operands must be the same type.

When acting on data types, `<=` is true if the left operand is the same as the right operand or a _subset_ of it.

### `>=` (greater than or equal to)

Resolves to `true` if the left operand is bigger than or equal to the right operand. Accepts [numbers][], [strings][], and [data types][literal_types]; both operands must be the same type.

When acting on data types, `>=` is true if the left operand is the same as the right operand or a _superset_ of it.

### `=~` (regex or data type match)

Resolves to `true` if the left operand **matches** the right operand. "Match" can mean two different things, depending on what the right operand is.

This operator is **non-transitive** with regard to data types. The right operand must be one of:

* A [regular expression][regex] (like `/^[<>=]{7}/`)
* A stringified regular expression --- that is, a [string][strings] that represents a regular expression, like `"^[<>=]{7}"`
* A [data type][literal_types] (like `Integer[1,10]`)

Regular expressions and stringified regexes work the same: the left operand **must be a string,** and the expression will be `true` if the string matches the regular expression.

If the right operand is a data type, the left operand can be any value. The expression will be `true` if the left operand has the specified data type. (For example, `5 =~ Integer` and `5 =~ Integer[1,10]` are both true.)

### `!~` (regex or data type non-match)

Resolves to `false` if the left operand **matches** the right operand. Note that `$x !~ $y` is the same as `!($x =~ $y)`.

For more behavior details, see `=~`.

### `in`

Resolves to `true` if the right operand contains the left operand. The exact definition of "contains" here depends on the data type of the right operand.

This operator is **non-transitive** with regard to data types. It accepts:

* A [string][strings], [regular expression][regex], or [data type][literal_types] as the left operand.
* A [string][strings], [array][arrays], or [hash][hashes] as the right operand.

If the left operand is a string, an `in` expression checks the right operand as follows:

* [Strings][] --- Tests whether the left operand is a substring of the right, ignoring case.
* [Arrays][] --- Tests whether one of the members of the array is identical to the left operand, ignoring case.
* [Hashes][] --- Tests whether the hash has a **key** identical to the left operand, ignoring case.

If the left operand is a regular expression, it checks the right operand as follows:

* [Strings][] --- Tests whether the right operand matches the regular expression.
* [Arrays][] --- Tests whether one of the members of the array matches the regular expression.
* [Hashes][] --- Tests whether the hash has a **key** that matches the regular expression.

If the left operand is a data type, it checks the right operand as follows:

* [Arrays][] --- Tests whether one of the members of the array matches the data type.
* Anything else --- Always false.

Examples:

``` puppet
# Right operand is a string:
'eat' in 'eaten' # resolves to true
'Eat' in 'eaten' # resolves to true

# Right operand is an array:
'eat' in ['eat', 'ate', 'eating'] # resolves to true
'Eat' in ['eat', 'ate', 'eating'] # resolves to true

# Right operand is a hash:
'eat' in { 'eat' => 'present tense', 'ate' => 'past tense'} # resolves to true
'eat' in { 'present' => 'eat', 'past' => 'ate' }            # resolves to false

# Left operand is a regular expression (with the case-insensitive option "?i")
/(?i:EAT)/ in ['eat', 'ate', 'eating'] # resolves to true

# Left operand is a data type (matching integers between 100-199)
Integer[100, 199] in [1, 2, 125] # resolves to true
Integer[100, 199] in [1, 2, 25]  # resolves to false
```

Boolean Operators
-----

Boolean Operators have the following traits:

* They take [**boolean**][boolean] operands; if a value of another data type is given, it will be [automatically converted to boolean][bool_convert].
* They resolve to [**boolean**][boolean] values.

These expressions are most useful when creating compound expressions.

### `and`

Resolves to `true` if both operands are true, otherwise resolves to `false`.

### `or`

Resolves to `true` if either operand is true.

### `!` (not)

**Takes one operand:**

``` puppet
$my_value = true
notice ( !$my_value ) # Will resolve to false
```

Resolves to `true` if the operand is false, and `false` if the operand is true.


## Arithmetic operators


Arithmetic Operators have the following traits:

* They take two [**numeric**][numbers] operands (except unary `-`).
    * If an operand is a string, it will be converted to numeric form. The operation fails if a string can't be converted.
* They resolve to [**numeric**][numbers] values.

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

Array operators take [arrays][] as operands; with the exception of `*` (unary splat), they resolve to array values.

### `*` (splat)

This unary operator accepts a single [array][arrays] value. (If given a scalar value, it will convert it to a single-element array first.)

"Unfolds" a single array into comma-separated list of values. This lets you use variables in places where, in previous versions of the language, only literal lists were allowed.

For example:

``` puppet
$a = ['vim', 'emacs']
myfunc($a)    # calls myfunc with a single argument: the array containing 'vim' and 'emacs'
myfunc(*$a)   # calls myfunc with two arguments: 'vim' and 'emacs'
```

``` puppet
$a = ['vim', 'emacs']
$x = 'vim'
notice case $x {
  $a      : { 'an array with both vim and emacs' }
  *$a     : { 'vim or emacs'}
  default : { 'no match' }
}
```

The splat operator is only meaningful in places where a comma-separated list of values is valid. Those places are:

* The arguments of a function call
* The cases of a case statement
* The cases of a selector statement

In any other context, splat just resolves to the array it was given.

### `<<` (append)

Resolves to an array containing the elements in the left operand, plus the right operand as its final element.

The left operand should be an [array][arrays], and the right operand can be any data type. Appending will only add a single element at a time to an array; to add multiple elements from a second array, use `+` (concatenation).

``` puppet
[1, 2, 3] << 4     # resolves to [1, 2, 3, 4]
[1, 2, 3] << [4, 5]   # resolves to [1, 2, 3, [4, 5]]
```

This operator does not change its operands; it only creates a new value.

### `+` (concatenation)

Resolves to an array containing the elements in the left operand followed by the elements in the right operand.

Both operands should be [arrays][]; if the right operand is a scalar value, it will be converted to a single-element array first. Hash values will be converted to arrays instead of wrapped, so you must wrap them yourself.

If the left operand isn't an array, Puppet will interpret `+` as arithmetic addition.

``` puppet
[1, 2, 3] + 1     # resolves to [1, 2, 3, 1]
[1, 2, 3] + [1]   # resolves to [1, 2, 3, 1]
[1, 2, 3] + [[1]] # resolves to [1, 2, 3, [1]]
```

This operator does not change its operands; it only creates a new value.

### `-` (removal)

Resolves to an array containing the elements in the left operand, with _every_ occurrence of any elements in the right operand removed.

Both operands should be [arrays][]; if the right operand is a scalar value, it will be converted to a single-element array first. Hash values aren't automatically wrapped in arrays, so you must always do this yourself.

If the left operand isn't an array, Puppet will interpret `-` as arithmetic subtraction.

``` puppet
[1, 2, 3, 4, 5, 1, 1] - 1    # resolves to [2, 3, 4, 5]
[1, 2, 3, 4, 5, 1, 1] - [1]  # resolves to [2, 3, 4, 5]
[1, 2, 3, [1, 2]] - [1, 2]   # resolves to [3, [1, 2]]
[1, 2, 3, [1, 2]] - [[1, 2]] # resolves to [1, 2, 3]
```

This operator does not change its operands; it only creates a new value.

## Hash Operators


Hash operators take:

* A [hash][hashes] as their left operand.
* Various values as their right operand.

They resolve to hash values.

### `+` (merging)

Resolves to a hash containing the keys and values in the left operand _plus_ the keys and values in the right operand; if any keys are present in both operands, the final hash will use the value from the right. It does not merge hashes recursively; it only merges top-level keys.

The right operand can be one of the following:

* A hash
* An array with an **even** number of elements; the first element of each pair will be used as a key, and the second element will be used as its value.

``` puppet
{a => 10, b => 20} + {b => 30}  # resolves to {a => 10, b => 30}
{a => 10, b => 20} + {c => 30}  # resolves to {a => 10, b => 30, c => 30}
{a => 10, b => 20} + [c, 30]    # resolves to {a => 10, b => 20, c => 30}
{a => 10, b => 20} + 30         # gives an error
{a => 10, b => 20} + [30]       # gives an error
```

This operator does not change its operands; it only creates a new value.


### `-` (removal)

Resolves to a hash containing the keys and values in the left operand, minus any keys that are also present in the right operand.

The right operand can be one of the following:

* A hash; any keys present in this hash will be removed from the final hash, regardless of whether that key has the same values in both operands.
* An array of keys
* A single key

``` puppet
{a => first, b => second, c => 17} - c                                # resolves to {a => first, b => second}
{a => first, b => second, c => 17} - [c, a]                           # resolves to {b => second}
{a => first, b => second, c => 17} - {c => 17, a => "something else"} # resolves to {b => second}
{a => first, b => second, c => 17} - {a => a, d => d}                 # resolves to {b => second, c => 17}
```

This operator does not change its operands; it only creates a new value.


## Assignment operators


### `=` (assignment)

The assignment operator sets the [variable][variables] on the left hand side to the value on the right hand side. The entire expression resolves to the value of the right hand side.

Note that variables can only be set once, after which any attempt to set the variable to a new value will cause an error.



## Formal descriptions of Puppet expressions

For formal descriptions of the Puppet language, including expressions constructed with operators, please see [the Puppet language specification.][spec]
