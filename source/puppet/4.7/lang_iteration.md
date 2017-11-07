---
title: "Language: Iteration and loops"
layout: default
canonical: "/puppet/latest/lang_iteration.html"
---

[functions]: ./lang_functions.html
[lambdas]: ./lang_lambdas.html
[each]: ./function.html#each
[slice]: ./function.html#slice
[filter]: ./function.html#filter
[map]: ./function.html#map
[reduce]: ./function.html#reduce
[with]: ./function.html#with
[array]: ./lang_data_array.html
[hash]: ./lang_data_hash.html
[defined types]: ./lang_defined_types.html
[array_titles]: ./lang_resources_advanced.html#arrays-of-titles


The Puppet language has looping and iteration features, which can help you write more succinct code and use data more effectively.

## Basics


In Puppet, iteration features are implemented as [functions][] that accept blocks of code ([lambdas][]).

That is, you write a block of code (lambda) that requires some kind of extra information, then pass it to a function that can provide that information and evaluate the code, possibly multiple times.

This differs from some other languages where looping constructs are special keywords; in Puppet, they're just functions.

## List of iteration functions


The following functions can accept a block of code and run it in some special way. See each function's documentation for more details.

* [`each`][each] --- Repeat a block of code any number of times, using a collection of values to provide different parameters each time.
* [`slice`][slice] --- Repeat a block of code any number of times, using _groups_ of values from a collection as parameters.
* [`filter`][filter] --- Use a block of code to transform some data structure by removing non-matching elements.
* [`map`][map] --- Use a block of code to transform every value in some data structure.
* [`reduce`][reduce] --- Use a block of code to create a new value or data structure by combining values from a provided data structure.
* [`with`][with] --- Evaluate a block of code once, isolating it in its own local scope. Doesn't iterate, but has a family resemblance to the iteration functions.

## Syntax


* See [the functions page][functions] for the syntax of function calls.
* See [the lambdas page][lambdas] for the syntax of code blocks that can be passed to functions.

In general, the iteration functions take an [array][] or a [hash][] as their main argument, then iterate over its values.

### Common lambda arguments

The [`each`][each], [`filter`][filter], and [`map`][map] functions can accept a lambda with either one or two parameters. The values they pass into a lambda will vary, depending on the number of parameters and the type of data structure you're iterating over:

Collection Type | Single Parameter                       | Two Parameters
----------------|----------------------------------------|-------------------
Array           | `<VALUE>`                              | `<INDEX>, <VALUE>`
Hash            | `[<KEY>, <VALUE>]` (two-element array) | `<KEY>, <VALUE>`

For example:

``` puppet
['a','b','c'].each |Integer $index, String $value| { notice("${index} = ${value}") }
```

This will result in:

    Notice: Scope(Class[main]): 0 = a
    Notice: Scope(Class[main]): 1 = b
    Notice: Scope(Class[main]): 2 = c

The [`slice`][slice] and [`reduce`][reduce] functions handle parameters differently; see their docs for details.


## Examples


### Declaring resources

Since the focus of the Puppet language is declaring resources, most people will want to use iteration to declare many similar resources at once:

``` puppet
$binaries = ['facter', 'hiera', 'mco', 'puppet', 'puppetserver']

# function call with lambda:
$binaries.each |String $binary| {
  file {"/usr/bin/${binary}":
    ensure => link,
    target => "/opt/puppetlabs/bin/${binary}",
  }
}
```

In this example, we have an array of command names that we want to use in each symlink's path and target. The `each` function makes this very easy and succinct.

### Old-style iteration with defined resource types

In earlier versions of Puppet, when there were no iteration functions and lambdas weren't supported, you could achieve a clunkier form of iteration by writing [defined resource types][defined types] and [using arrays as resource titles.][array_titles] To do the same thing as the previous example:

``` puppet
# one-off defined resource type, in
# /etc/puppetlabs/code/environments/production/modules/puppet/manifests/binary/symlink.pp
define puppet::binary::symlink ($binary = $title) {
  file {"/usr/bin/${binary}":
    ensure => link,
    target => "/opt/puppetlabs/bin/${binary}",
  }
}

# using defined type for iteration, somewhere else in your manifests
$binaries = ['facter', 'hiera', 'mco', 'puppet', 'puppetserver']

puppet::binary::symlink { $binaries: }
```

The main problems with this approach were:

* The block of code that did the work was separated from the place where you used it, which made a simple task more complicated than it needed to be.
* Every type of thing you needed to iterate over would require its own one-off defined type.

In general, the modern style of iteration is much better, but you'll often see existing code using this old style, and might have to use it yourself to target older versions of Puppet.

### Using iteration to transform data

You can also use iteration to transform data into more useful forms. For example:

``` puppet
$filtered_array = [1,20,3].filter |$value| { $value < 10 }
# returns [1,3]

$sum = reduce([1,2,3]) |$result, $value|  { $result + $value }
# returns 6

$hash_as_array = ['key1', 'first value',
                 'key2', 'second value',
                 'key3', 'third value']

$real_hash = $hash_as_array.slice(2).reduce( {} ) |Hash $memo, Array $pair| {
  $memo + $pair
}
# returns {"key1"=>"first value", "key2"=>"second value", "key3"=>"third value"}
```

