---
layout: default
title: "Future Parser: Data Types: Arrays"
canonical: "/puppet/latest/reference/future_lang_data_array.html"
---

[undef]: ./future_lang_data_undef.html
[stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib


Arrays are written as comma-separated lists of items surrounded by square brackets. An optional trailing comma is allowed between the final value and the closing square bracket.

{% highlight ruby %}
    [ 'one', 'two', 'three' ]
    # Equivalent:
    [ 'one', 'two', 'three', ]
{% endhighlight %}

The items in an array can be any data type, including hashes or more arrays.

Resource attributes which can optionally accept multiple values (including the relationship metaparameters) expect those values in an array.

## Indexing

You can access items in an array by their numerical index (counting from zero). Square brackets are used for indexing.

Example:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three' ]
    notice( $foo[1] )
{% endhighlight %}

This manifest would log `two` as a notice. (`$foo[0]` would be `one`, since indexing counts from zero.)

Nested arrays and hashes can be accessed by chaining indexes:

{% highlight ruby %}
    $foo = [ 'one', {'second' => 'two', 'third' => 'three'} ]
    notice( $foo[1]['third'] )
{% endhighlight %}

This manifest would log `three` as a notice. (`$foo[1]` is a hash, and we access a key named `'third'`.)

Arrays support negative indexing, with `-1` being the final element of the array:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )
    notice( $foo[-2] )
{% endhighlight %}

The first notice would log `three`, and the second would log `four`.

Note that the opening square bracket must not be preceded by a white space:

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2] )  # ok
    notice( $foo [2] ) # syntax error
{% endhighlight %}

If you try to access an element beyond the bounds of the array, its value will be [`undef`.][undef]

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    $cool_value = $foo[6] # value is undef
{% endhighlight %}


## Array Sectioning

You can also access sections of an array by numerical index. Like indexing, sectioning uses square brackets, but it uses two indexes (separated by a comma) instead of one (e.g. `$array[3,10]`).

The result of an array section is always another array.

The first number of the index is the start position.

* Positive numbers will count from the start of the array, starting at `0`.
* Negative numbers will count back from the end of the array, starting at `-1`.

The second number of the index is the stop position.

* Positive numbers are lengths, counting forward from the start position.
* Negative numbers are absolute positions, counting back from the end of the array (starting at `-1`).

{% highlight ruby %}
    $foo = [ 'one', 'two', 'three', 'four', 'five' ]
    notice( $foo[2,1] )  # evaluates to ['three']
    notice( $foo[2,2] )  # evaluates to ['three', 'four']
    notice( $foo[2,-1] ) # evaluates to ['three', 'four', 'five']
    notice( $foo[-2,1] ) # evaluates to ['four']
{% endhighlight %}

## Array Operators

There are three expression operators that can act on array values: `*` (splat), `+` (concatenation), and `-` (removal).

For details, [see the relevant section of the Expressions and Operators page.](./future_lang_expressions.html#array-operators)


## Additional Functions

The [puppetlabs-stdlib][stdlib] module contains several additional functions for dealing with arrays, including:

* `delete`
* `delete_at`
* `flatten`
* `grep`
* `hash`
* `is_array`
* `join`
* `member`
* `prefix`
* `range`
* `reverse`
* `shuffle`
* `size`
* `sort`
* `unique`
* `validate_array`
* `values_at`
* `zip`
