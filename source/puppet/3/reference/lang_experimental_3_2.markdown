---
layout: default
title: "Language: Experimental Features (Puppet 3.2)"
---

[parser_setting]: /references/latest/configuration.html#parser
[arm2]: https://github.com/puppetlabs/armatures/tree/master/arm-2.iteration
[array]: /puppet/3/reference/lang_datatypes.html#arrays

## Background: The Puppet "Future" Parser

Starting with Puppet 3.2, you can set `parser = future` in puppet.conf to enable experimental new language features, which may or may not be included in a future Puppet version.

We're doing this to get early feedback on potential features without imposing heavy requirements on people who might want to test them. You can start testing future features with the normal release of Puppet, just by changing a setting.

Under the hood, the "future" parser is a ground-up reimplementation of the Puppet grammar. This replacement parser is separate from the specific new features being enabled, and allows us to implement _many_ things that would have been difficult or impossible before. It will eventually replace the current parser entirely, although this won't happen until a major release boundary.

In addition to the experimental features, the "future" parser makes some other changes and clean-ups to the language. These improvements are shown in the "Other Changes" section of this page.

### Requirements

To enable everything described in this document:

* Use Puppet 3.2.x. This isn't available in prior versions.
* Install the `rgen` gem. If you installed Puppet from the official packages, this was already installed as a dependency; otherwise, you may need to install it manually.
* On your puppet master(s), set [`parser = future` ][parser_setting]in the `[master]` block of puppet.conf. (In a masterless "puppet apply" deployment, set this in the `[main]` block on every node.)
    * Alternately, you can set `--parser future` on the command line when running puppet apply.


## Scope of This Document

This page describes the experimental parser features in Puppet 3.2, which includes support for _iteration_ and _enumerables._

This page is user-oriented (in contrast to the technical background information found in [ARM-2.Iteration][arm2]), and offers an introduction to iteration in Puppet and lambdas. It also presents differences in the experimental parser compared to Puppet 3.

This experimental feature set implements several alternative syntaxes. The intent is to study which of these alternatives is most liked and should go into an official release. The introductions and examples are written in the recommended style as described in [ARM-2.iteration][arm2]. Alternatives are shown in a separate section.

## Collection Manipulation and Iteration

This experimental feature set contains support for iteration and enumerables via an extension to the language known as _lambdas_.

### Lambdas

A Lambda can be thought of as _parameterized code blocks;_ a block of code that has parameters and can be invoked/called with arguments. A single lambda can be passed to a function (such as the iteration function `each`).

    $a = [1,2,3]
    each($a) |$value| { notice $value }

We can try this on the command line:

    puppet apply --parser future -e '$a=[1,2,3] each($a) |$value|{ notice $value }'
    Notice: Scope(Class[main]): 1
    Notice: Scope(Class[main]): 2
    Notice: Scope(Class[main]): 3
    Notice: Finished catalog run in 0.12 seconds

Lets look at what we just did:

* We used `puppet apply` and passed the `--parser future` option to get the experimental parser, as [described above.](#requirements) (All examples below assume this is set in `puppet.conf`).
* We called a function called `each`
* We passed an [array][] to it as an argument
* After the list of arguments we gave it a _lambda_:
    * The lambda's parameters are declared within _pipes_ (`|`) (just like parameters are specified for a define).
    * We declared the lambda to have one parameter, and we named it `$value` (we could have called it whatever we wanted; `$x`, or `$a_unicorn`, etc.)
    * The lambdas body is enclosed in braces `{ }`, where you can place any puppet logic except class, define, or node statements.


### Available Functions

You have already seen the iteration function `each` (there is more to say about it), but before going into details, meet the entire family of iteration functions.

* `each` (also available as `foreach`) --- iterates over each element of an array or hash
* `collect` --- transforms an array or a hash into a new Array
* `select` --- filters an array or hash (include elements for which lambda returns true)
* `reject` --- filters an array or hash (exclude elements for which lambda returns true)
* `reduce` --- reduces an array or hash to a single value which is computed by the lambda
* `slice` --- slices an array or hash into chunks and feeds each result to a lambda

The function `each` (AKA `foreach`) calls a lambda with one or two arguments (depending on how many are used in the lambda parameters).

**For an array:**

If one parameter is used, it will be set to the value of each element. If two parameters are used, they will be set to the index and value of each element.

**For a hash:**

Only two-parameter lambdas are supported. They will be set to the key and value of each hash entry.

Using a similar example as before, but now with two parameters, we get:

    user$ puppet apply -e '$a  = ['a','b','c'] each($a) |$index, $value| { notice "$index = $value" }'
    Notice: Scope(Class[main]): 0 = a
    Notice: Scope(Class[main]): 1 = b
    Notice: Scope(Class[main]): 2 = c

The remaining functions also operate on arrays and hashes, and always convert hash entries to an array of `[key, value]`.

Here are some examples to illustrate:

    collect([1,20,3]) |$value| { $value < 10 }
    # produces [1,3]

    reject([1,20,3]) |$value| { $value >= 10 }
    # produces [1,3]

    reduce([1,2,3]) |$result, $value|  { $result + $value }
    # produces: 6

    slice(['fred', 10, 'mary', 20], 2) |$name, $val| { notice "$name = $val" }
    # results in the following output
    Notice: Scope(Class[main]): fred = 10
    Notice: Scope(Class[main]): mary = 20

### Chaining Functions

You can chain function calls from left to right. And a chain may be as short as a single step.

The examples you have seen can be written like this:

    [1,2,3].each |$index, $value| { notice "$index = $value" }'

    [1,20,3].collect |$value| { $value < 10 }

    [1,20,3].reject() |$value| { $value >= 10 }

    [1,2,3].reduce |$result, $value|  { $result + $value }

    ['fred', 10, 'mary', 20].slice(2) |$name, $val| { notice "$name = $val" }

And then let's chain these:

    [1,20,3].collect |$value| {$value < 10 }.each |$value| { notice $value }
    # produces the output
    Notice: Scope(Class[main]): 1
    Notice: Scope(Class[main]): 3

Note: It is possible to chain functions that produce a value (which includes the iteration functions, but not functions like `notice`).

### Learning More About the Iteration Functions

The functions are documented as all other functions and this documentation is available in arm-2.iteration ["Functions for iteration and transformation"](https://github.com/puppetlabs/armatures/blob/master/arm-2.iteration/iteration.md#functions-for-iteration-and-transformation).

Here is the [Index of arm-2](https://github.com/puppetlabs/armatures/blob/master/arm-2.iteration/index.md) if you want to read all the details, alternatives, and what has been considered so far.

### Alternative Syntax for Lambdas

ARM-2 proposes alternatives to the syntax that are implemented in the experimental version. The alternative syntaxes for lambdas are an experiment to see which one is found to be most understandable to users.

    # Alternative 0 (as shown): Parameters are outside the lambda block.
    [1,2,3].each |$value| { notice $value }

    # Alternative 1: Parameters are inside the lambda block.
    [1,2,3].each { |$value| notice $value }

    # Alternative 2: A fat arrow is placed after the parameters.
    [1,2,3].each |$value| => { notice $value }

[ARM-2][arm2] also proposes a completely different way of  manipulating data based on the notion of unix pipes; please refer to [ARM-2][arm2] for the details of this alternative. It is also based on lambdas, but with slightly different syntax. The pipe syntax proposal has not been implemented.

### Lambda Scope

When a lambda is evaluated, this takes place in a _local scope_ that shadows outer scopes. Each invocation of a lambda sets up a fresh local scope. The variables assigned (and the lambda parameters) are immutable once assigned, and they can not be referenced from code outside of the lambda block. The lambda block may however use variables visible in the scope where the lambda is given, as in this example:

    $names = [fred, mary]
    [1,2].each |$x| { notice "$i is called ${names[$x]}"}

### Calls with Lambdas

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

### Statements in a Lambda Body

The statements in a lambda body can be anything legal in Puppet except definition of classes, resource types (i.e. 'define'), or nodes. This is the same rule as for any conditional construct in Puppet.

## Other Changes

In re-implementing a parser for the puppet language, there are a few changes to the language itself that were made. Some of the changes are to enforce restrictions which were suppose to be there in the first place, whereas other changes were to update the language to be able to support lambdas in a meaningful way (this takes more than you might at first think).

### New Language Features

Several new features have been added to the language in the course of re-implementing and re-examining what was there.

#### Expressions Are Now Valid Statements

In Puppet 3 it is not possible to have a body of code that is just an expression. This makes it

difficult to enter predicates as in the case of a collect or reject.

An expression such as...

    1 + 2

...is now a legal statement if it appears as the last "statement" in a block. Block "return" their last expression/statement as its produced result. There is no explicit "return", it is always the value of the last evaluated expression.

#### Arrays and Hashes Are Now Allowed "Everywhere"

In Puppet 3. if you wanted to operate on a literal array or hash, you typically had to assign it to a variable first. This was due to how the internal grammar for the language was organized. You can now use literal arrays and hashes more naturally in a puppet manifest.

    notice([1, 2][1])
    # produces the output
    Notice: Scope(Class[main]): 2

#### Concatenation and Append

You can concatenate array and merge hashes with `+`

    [1,2,3] + [4,5,6]   # produces [1,2,3,4,5,6]
    {a => 1} + {b => 2} # produces {a=>1, b=>2 }

You can append to an array with `<<`

    [1,2,3] << 10 # produces [1,2,3,10]
    [1,2,3] << [4,5] # produces [1,2,3,[4,5]]

#### A Semicolon Acts as an Optional Expression Separator

There is one corner case in the expression based grammar that required an expression separator `;` to be added. It can optionally be used to increase readability in one-liners.

    $a = 1; $b = 10

Which naturally also is legal without the semicolon.

The separator becomes important when you want to end a block with a literal array or hash, and when they would alter the meaning of the _preceding_ operand. (This example makes use of `+` to concatenate two arrays)

    { $x = [[1],[2],[3]]
      $a = [a] + $x[1]
    }
    # Results in $a being assigned [a,2], and this is also the value
    # returned by the block

is very different from:

    { $x = [[1],[2],[3]]
      $a = [a] + $x; [1]
    }
    # Results in $a being assigned to [a, [1],[2],[3]] and the
    # result of the block (which is returned) is [1]

#### Functions That Produce a Value May Be Invoked as Statements

It is harmless to call a function that produce a value and not use the returned value. Puppet 3 forbids this and raises an error. With the entry of iteration functions (which always return a value, but may be used for only the side effects) this was made impossible by Puppet 3's separation of function (returning a value) and procedure (returning nothing).

#### Right Side of Matches May Be a String (unfinished)

It is allowed to have a string instead of a regular expression in matches expressions. The intent is to support variable interpolation in these strings before they are converted to regular expressions. This is unfinished, and will currently result in an error when evaluated (instead of when parsed).

#### Unless with Else Supported

An `unless` can now have an `else` clause (but it cannot be combined with an `elsif`).

While not being recommended to use complex logic in `unless`, it is at the same time quite annoying to have to reverse tests in order to be able to do something like a notice "unless not triggered" for debugging.

#### Chained Assignments

Chained assignments are now possible for both `=`, and `+=`.

    $a = $b = 10

Note that `=` and `+=` have low precedence, so this is an error:

    $a = 1 + $b = 10 # i.e. this is parsed as $a = (1 + $b) = 10

and needs to be written

    $a = 1 + ($b = 10)

Assignments may thus also be used where expressions are.

#### Function Calls in Interpolation Supported

Calling a function in interpolation now works:

    notice "This is a random number: ${fqdn_rand(30)}

This has mysterious result in the regular parser since it is interpreted as

    ${$fqdn_rand(30)}

### Additional Restrictions and Error Reporting

The new parser structure also allowed us to revisit some of the features of the language and remove some things that might have been causing problems. It also allows for better error reporting in many cases.

#### User Defined Numeric Variables Not Allowed

Assignments to numeric variables are flagged as errors.

This is illegal:

    $3 = 'hello'

In some puppet versions this produces strange effects, and in some it is silently ignored.

As a consequence it is also illegal to name parameters in defines, and parameterized classes with numeric names.

This is illegal:

    define mytype ($1, $2) { … }

It is ok to use names with digits 0-9 as long as one character is not a digit.

#### "Bare Words" May Not Start with a Digit

The positive effect of this is that numbers entered without quotes can be validated to be correct decimal, hex or octal values.

#### Numbers Are Validated If Entered without Quotes

If you enter an unquoted number in decimal, hex or octal it is now validated, and an error is raised if it is illegal.

These will raise errors:

    $a = 0x0EH
    $b = 0778

#### Many Errors Now Contain Position on Line

If available, errors now output position on the line. This helps for errors related to punctuation such as `{` since it may appear several times on a line and the problem may be hard to find/understand. (This problem was made worse with the addition of lambdas to the language since they are typically entered as one-liners).

The output is: `filename:line:pos`

Pos is never displayed without a line, if you see `file:3`, it is a reference to the line.

Position starts from 1 (first character on a line is in position 1).

#### Odd "Expected" Errors Fixed

When there is a syntax errors involving a token that is paired (e.g. `{`, `(`, `[`), the error message always said "`expected ...`" and it showed the matching side of the violating token. This is only correct if the problem is reaching EOF. In all other cases this information was misleading, adding what was suggested would almost always make things worse.

The "expected" is now only included when encountering the end of file and there are outstanding expectations (such as terminating an open string).

#### Error and Warning Feedback

Error and Warning feedback from parsing now outputs multiple errors / warnings (if multiple were found before lower level parsing gave up). The default cap on output of these are 10. The number can be changed via the settings:

    max_errors
    max_warnings
    max_deprecations

When there are multiple errors, the output emits errors up to the cap. A final error is then generated with the error and warning count. If there is only one error, only this error is emitted (no count). Deprecations count as warnings.

As an example, you can try this:

    puppet apply --parser future -e '$a = node "a+b" { }'
    Error: Invalid use of expression. A Node Definition does not produce a value at line 1:6
    Error: The hostname 'a+b' contains illegal characters (only letters, digits, '_', '-', and '.' are allowed) at line 1:11
    Error: Classes, definitions, and nodes may only appear at toplevel or inside other classes at line 1:6
    Error: Could not parse for environment production: Found 3 errors. Giving up on node henriks-macbook-pro.local

#### Fat Arrow as Comma Is Not Supported

In the 3 parser, it is allowed to use a fat arrow `=>` instead of a comma in many places. This undocumented feature is removed in the experimental parser.
