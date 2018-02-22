---
layout: default
title: "Language: Data types: Numbers"
---

[arithmetic]: ./lang_expressions.html#arithmetic-operators
[data type]: ./lang_data_type.html
[variant]: ./lang_data_abstract.html#variant

Numbers in the Puppet language are normal integers and floating point numbers.

You can work with numbers using Puppet's [arithmetic operators.][arithmetic]

## Syntax

Numbers are written without quotation marks, and can consist only of:

-   Digits.
-   An optional negative sign (`-`). This is the [unary negation operator](./lang_expressions.html#subtraction-and-negation), rather than part of the number.
    -   Explicit positive signs (`+`) aren't allowed, because there's no unary `+` operator.
-   An optional decimal point, which results in a floating point value.
-   A prefix, for octal or hexidecimal bases.
-   An optional `e` or `E` for scientific notation of floating point values.

### Integers

Integers are numbers without decimal points.

If you divide two integers, the result _is not_ a floating point number. Instead, Puppet truncates the remainder. For example, `2/3 == 0`.

### Floating point numbers

Floating point numbers ("floats") are numbers that include a fractional value after a decimal point, even if that fractional value is zero (such as `2.0`).

If an expression includes both integer and float values, the result is a float.

``` puppet
$some_number = 8 * -7.992           # evaluates to -63.936
$another_number = $some_number / 4  # evaluates to -15.984
```

Floating point numbers between -1 and 1 cannot start with a bare decimal point. They must have a zero before the decimal point.

``` puppet
$product = 8 * .12   # syntax error
$product = 8 * 0.12  # OK
```

To express floating point numbers in scientific notation, append `e` or `E` and an exponent. Puppet multiplies the preceding number by 10 to the power of that exponent. Numbers in scientific notation are always floats.

``` puppet
$product = 8 * 3e5  # evaluates to 240000.0
```

### Octal and hexadecimal integers

Integer values can be expressed in decimal notation (base 10), octal notation (base 8), and hexadecimal notation (base 16).

-   _Non-zero_ decimal integers must not start with a `0`.
-   Octal values have a prefix of `0`, which can be followed by a sequence of octal digits 0-7.
-   Hexadecimal values have a prefix of `0x` or `0X`, which can be followed by hexadecimal digits 0-9, a-f, or A-F.

Floats can't be expressed in octal or hex.

``` puppet
# Octal
$value = 0777    # evaluates to decimal 511
$value = 0789    # Error, invalid octal
$value = 0777.3  # Error, invalid octal

# Hexadecimal
$value = 0x777  # evaluates to decimal 1911
$value = 0xdef  # evaluates to decimal 3567
$value = 0Xdef  # same as above
$value = 0xDEF  # same as above
$value = 0xLSD  # Error, invalid hex
```

## Converting numbers to strings

Numbers are automatically converted to strings when interpolated into a string. The automatic conversion uses decimal (base 10) notation.

To convert numbers to non-decimal string representations, you can use the [`sprintf` function](./function.html#sprintf), or you can create a new string object with the `new()` function and [specify its format](./function.html#conversion-to-string).

## Converting strings to numbers

[Arithmetic operators][arithmetic] automatically convert strings to numbers.

In all other contexts (resource attributes, function arguments, etc.), Puppet _won't_ automatically convert strings to numbers, but you can:

-   Create a new `Integer` or `Float` object using the string as a parameter, such as `$mynum = Integer($mystring)`. This invokes the type's `new()` function, which can convert objects of other types --- including Strings --- into [Integers](./function.html#conversion-to-integer) and [Floats](./function.html#conversion-to-float).

    The default radix of this conversion is base 10, but you can specify others.
-   Use [the `scanf` function](./function.html#scanf) to manually extract numbers from strings. This function can also account for surrounding non-numerical text.

> **Deprecation note:** Puppet 4.10.2 deprecated numeric coercion, which silently and automatically converted strings into numbers by adding a number to a string (for example, `$mynum = '10' + 0` would result in `$mynum` being assigned the number 10.) This now logs a Warning, or generates an Error if `--strict` is enabled.
>
> To ensure that your code works with future versions of Puppet, create new instances of numeric objects to convert String values to numeric types.

### Examples

Converting a string to an integer and float:

    $mystring = '10';                  # $mystring == '10'
    $myinteger = Integer($mystring);   # $myinteger == 10
    $myfloat = Integer($mystring);     # $myfloat == 10.0
    $myhexint = Integer($mystring, 16) # $myhexint == 16; '10' in base 16

## The `Integer` data type

The [data type][] of integers is `Integer`.

By default, `Integer` matches whole numbers of any size (within the limits of available memory).

You can use parameters to restrict which values `Integer` matches.

### Parameters

The full signature for `Integer` is:

    Integer[<MIN VALUE>, <MAX VALUE>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data type | Default value     | Description
---------| -----------------|-----------|-------------------|-----------------------------
1        | Minimum value    | `Integer` | negative infinity | The minimum value for the integer. This parameter accepts the special value `default`, which uses its default value.
2        | Maximum value    | `Integer` | infinity          | The maximum value for the integer. This parameter accepts the special value `default`, which uses its default value.

Practically speaking, the integer size limit is the range of a 64-bit signed integer (−9,223,372,036,854,775,808 to 9,223,372,036,854,775,807), which is the maximum size that can roundtrip safely between the components in the Puppet ecosystem.

### Examples

-   `Integer` --- matches any integer.
-   `Integer[0]` --- matches any integer greater than or equal to 0.
-   `Integer[default, 0]` --- matches any integer less than or equal to 0.
-   `Integer[2, 8]` --- matches any integer from 2 to 8, inclusive.

## The `Float` data type

The [data type][] of floating point numbers is `Float`.

By default, `Float` matches floating point numbers within the limitations of Ruby's [Float class](http://www.ruby-doc.org/core/Float.html). Practically speaking, this means a 64 bit double precision floating point value.

You can use parameters to restrict which values `Float` matches.

### Parameters

The full signature for `Float` is:

    Float[<MIN VALUE>, <MAX VALUE>]

All of these parameters are optional. They must be listed in order; if you need to specify a later parameter, you must specify values for any prior ones.

Position | Parameter        | Data type | Default value     | Description
---------| -----------------|-----------|-------------------|-----------------------------
1        | Minimum value    | `Float`   | negative infinity | The minimum value for the float. This parameter accepts the special value `default`, which uses its default value.
2        | Maximum value    | `Float`   | infinity          | The maximum value for the float. This parameter accepts the special value `default`, which uses its default value.

### Examples

-   `Float` --- matches any floating point number.
-   `Float[1.6]` --- matches any floating point number greater than or equal to 1.6.
-   `Float[1.6, 3.501]` --- matches any floating point number from 1.6 to 3.501, inclusive.

## The `Numeric` data type

The [data type][] of all numbers, both integer and floating point, is `Numeric`.

It matches any integer or floating point number, and takes no parameters.

### Related data types

`Numeric` is equivalent to `Variant[Integer, Float]`. If you need to set size limits but still accept both integers and floats, you can use [the abstract `Variant` type][variant] to construct an appropriate data type, e.g. `Variant[Integer[-3,3], Float[-3.0,3.0]]`.
