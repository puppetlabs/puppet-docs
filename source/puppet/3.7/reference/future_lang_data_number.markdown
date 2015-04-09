---
layout: default
title: "Future Parser: Data Types: Numbers"
canonical: "/puppet/latest/reference/future_lang_data_number.html"
---



Puppet's arithmetic expressions accept integers and floating point numbers.

Numbers are written without quotation marks, and can consist only of:

* Digits
* An optional negative sign (`-`; actually [the unary negation operator](./future_lang_expressions.html#subtraction-and-negation))
    * Explicit positive signs (`+`) aren't allowed.
* An optional decimal point (which results in a floating point value)
* A prefix, for octal or hexidecimal bases
* An optional `e` or `E` for scientific notation of floating point values

## Floats

If an expression includes both integer and float values, the result will be a float

{% highlight ruby %}
    $some_number = 8 * -7.992           # evaluates to -63.936
    $another_number = $some_number / 4  # evaluates to -15.984
{% endhighlight %}

Floating point numbers between -1 and 1 cannot start with a bare decimal point; they must have a zero before the decimal point.

{% highlight ruby %}
    $product = 8 * .12 # syntax error
    $product = 8 * 0.12 # OK
{% endhighlight %}

You can express floating point numbers in scientific notation: append `e` or `E` plus an exponent, and the preceding number will be multiplied by 10 to the power of that exponent. Numbers in scientific notation are always floats.

{% highlight ruby %}
    $product = 8 * 3e5  # evaluates to 240000.0
{% endhighlight %}

## Octal and Hexadecimal Integers

Integer values can be expressed in decimal notation (base 10), octal notation (base 8), and hexadecimal notation (base 16). Octal values have a prefix of `0`, which can be followed by a sequence of octal digits 0-7. Hexadecimal values have a prefix of `0x` or `0X`, which can be followed by hexadecimal digits 0-9, a-f, or A-F.

Floats can't be expressed in octal or hex.

{% highlight ruby %}
    # octal
    $value = 0777   # evaluates to decimal 511
    $value = 0789   # Error, invalid octal
    $value = 0777.3 # Error, invalid octal

    # hexadecimal
    $value = 0x777 # evaluates to decimal 1911
    $value = 0xdef # evaluates to decimal 3567
    $value = 0Xdef # same as above
    $value = 0xDEF # same as above
    $value = 0xLSD # Error, invalid hex
{% endhighlight %}

## Converting Numbers to Strings

Numbers are automatically converted to strings when interpolated into a string. The automatic conversion uses decimal (base 10) notation.

If you need to convert numbers to non-decimal string representations, you can use [the `printf` function.](/references/3.7.latest/function.html#printf)

## Converting Strings to Numbers

Strings are never automatically converted to numbers. You can use [the `scanf` function](/references/3.7.latest/function.html#scanf) to convert strings to numbers, accounting for various notations and any surrounding non-numerical text.
