---
layout: default
title: "Experimental Features: Lambdas and Iteration"
canonical: "/puppet/latest/reference/experiments_lambdas.html"
---

[arm2]: https://github.com/puppetlabs/armatures/tree/master/arm-2.iteration
[array]: /puppet/3/reference/lang_datatypes.html#arrays
[experimentalmodule]: https://github.com/hlindberg/puppet-network
[experimentalcommit]: https://github.com/hlindberg/puppet-network/commit/b1665a2da730e31b76a9230796510d01e6a626d7

> **Warning:** This document describes an **experimental feature,** which is not officially supported and is not considered ready for production. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise.

> **Status:** Currently, we recommend _against_ enabling the future parser in a production deployment. As of Puppet 3.5, it still carries a massive performance penalty in catalog compilation compared to the default parser. It can be used to experiment with new features in a small environment, but it shouldn't bear the weight of a full-scale Puppet site.
>
> The new language features in the future parser are still being designed and considered, and there is ongoing debate over how they should work and whether they should be an official part of Puppet.


Lambdas and iteration are an experimental addition to the language, included in the also-experimental "future" parser. They can allow you to quickly create groups of resources based on data, as well as manipulate data in other ways.

This page is user-oriented (in contrast to the technical background information found in [ARM-2.Iteration][arm2]), and offers an introduction to iteration in Puppet and lambdas.

* For a demonstration with context, [see this revision of the puppet-network module.][experimentalcommit] (See also the [GitHub home][experimentalmodule] for the revised module.)

Enabling Lambdas and Iteration
-----

You must enable the future parser to use any of the features on this page. See [the "Enabling the Future Parser" section of the future parser page](./experiments_future.html#enabling-the-future-parser) for details.


Lambdas
-----

A Lambda can be thought of as _parameterized code blocks;_ a block of code that has parameters and can be invoked/called with arguments. A single lambda can be passed to a function (such as the iteration function `each`).

    $a = [1,2,3]
    each($a) |$value| { notice $value }

We can try this on the command line:

    puppet apply --parser future -e '$a=[1,2,3] each($a) |$value|{ notice $value }'
    Notice: Scope(Class[main]): 1
    Notice: Scope(Class[main]): 2
    Notice: Scope(Class[main]): 3
    Notice: Finished catalog run in 0.12 seconds

Let's look at what we just did:

* We used `puppet apply` and passed the `--parser future` option to get the experimental parser, as [described above.](#requirements) (All examples below assume this is set in `puppet.conf`).
* We called a function called `each`
* We passed an [array][] to it as an argument
* After the list of arguments we gave it a _lambda_:
    * The lambda's parameters are declared within _pipes_ (`|`) (just like parameters are specified for a define).
    * We declared the lambda to have one parameter, and we named it `$value` (we could have called it whatever we wanted; `$x`, or `$a_unicorn`, etc.)
    * The lambda's body is enclosed in braces `{ }`, where you can place any puppet logic except class, define, or node statements.

Available Functions
-----

You have already seen the iteration function `each` (there is more to say about it), but before going into details, meet the entire family of iteration functions.

* `each` --- iterates over each element of an array or hash
* `map` --- transforms an array or a hash into a new Array
* `filter` --- filters an array or hash (include elements for which lambda returns true)
* `reduce` --- reduces an array or hash to a single value which is computed by the lambda
* `slice` --- slices an array or hash into chunks and feeds each result to a lambda

The function `each` calls a lambda with one or two arguments (depending on how many are used in the lambda parameters).

**For an array:**

If one parameter is used, it will be set to the value of each element. If two parameters are used, they will be set to the index and value of each element.

**For a hash:**

If two parameters are used, they will be set to the key and value of each hash entry. If one parameter is used, it is set to an array containing `[key, value]`.

Using a similar example as before, but now with two parameters, we get:

    user$ puppet apply -e '$a  = ['a','b','c'] each($a) |$index, $value| { notice "$index = $value" }'
    Notice: Scope(Class[main]): 0 = a
    Notice: Scope(Class[main]): 1 = b
    Notice: Scope(Class[main]): 2 = c

The remaining functions also operate on arrays and hashes, and always convert hash entries to an array of `[key, value]`.

Here are some examples to illustrate:

    filter([1,20,3]) |$value| { $value < 10 }
    # produces [1,3]

    reduce([1,2,3]) |$result, $value|  { $result + $value }
    # produces: 6

    slice(['fred', 10, 'mary', 20], 2) |$name, $val| { notice "$name = $val" }
    # results in the following output
    Notice: Scope(Class[main]): fred = 10
    Notice: Scope(Class[main]): mary = 20

Chaining Functions
-----

You can chain function calls from left to right. And a chain may be as short as a single step.

The examples you have seen can be written like this:

    [1,2,3].each |$index, $value| { notice "$index = $value" }'

    [1,20,3].filter |$value| { $value < 10 }

    [1,2,3].reduce |$result, $value|  { $result + $value }

    ['fred', 10, 'mary', 20].slice(2) |$name, $val| { notice "$name = $val" }

And then let's chain these:

    [1,20,3].filter |$value| {$value < 10 }.each |$value| { notice $value }
    # produces the output
    Notice: Scope(Class[main]): 1
    Notice: Scope(Class[main]): 3

Note: It is possible to chain functions that produce a value (which includes the iteration functions, but not functions like `notice`).

Learning More About the Iteration Functions
-----

The functions are documented as all other functions and this documentation is available in arm-2.iteration ["Functions for iteration and transformation"](https://github.com/puppetlabs/armatures/blob/master/arm-2.iteration/iteration.md#functions-for-iteration-and-transformation).

Here is the [Index of arm-2](https://github.com/puppetlabs/armatures/blob/master/arm-2.iteration/index.md) if you want to read all the details, alternatives, and what has been considered so far.

Lambda Scope
-----

When a lambda is evaluated, this takes place in a _local scope_ that shadows outer scopes. Each invocation of a lambda sets up a fresh local scope. The variables assigned (and the lambda parameters) are immutable once assigned, and they can not be referenced from code outside of the lambda block. The lambda block may however use variables visible in the scope where the lambda is given, as in this example:

    $names = [fred, mary]
    [1,2].each |$x| { notice "$i is called ${names[$x]}"}

Calls with Lambdas
-----

You can place a lambda after calls on these forms:

    each($x)  |$value| { … }
    $x.each   |$value| { … }
    $x.each() |$value| { … }

    slice($x, 2) |$value| { … }
    $x.slice(2)  |$value| { … }

But these are _illegal_:

    each $x |$value| { … }
    slice $x, 2 |$value| { … }
    $z = |$value| { … }

Statements in a Lambda Body
-----

The statements in a lambda body can be anything legal in Puppet except definition of classes, resource types (i.e. 'define'), or nodes. This is the same rule as for any conditional construct in Puppet.


