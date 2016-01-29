---
layout: default
title: "Experimental Features: The Future Parser"
canonical: "/puppet/3.8/reference/experiments_future.html"
---

[parser_setting]: /puppet/latest/reference/configuration.html#parser
[evaluator_setting]: /puppet/latest/reference/configuration.html#evaluator
[users_group]: https://groups.google.com/forum/#!forum/puppet-users

> **Warning:** This document describes an **experimental feature,** which is not officially supported and is not considered ready for production. [See here for more information about experimental features in Puppet](./experiments_overview.html), especially if you are using Puppet Enterprise.

> **Status:** In Puppet 3.6, the future parser performs much better than it used to. We think it's about on par with the default parser, but haven't extensively speed tested it with real-world manifests. It should still be considered a preview, but can now be used with larger test environments.
>
> The new language features in the future parser are still being designed and considered. If you want to join the conversation, or if some of your manifests don't work the way you think they should under the future parser, please join [the puppet-users group][users_group] and tell us what you've learned.

You can set `parser = future` in puppet.conf to enable experimental new language features, which may or may not be included in a future Puppet version.

Under the hood, the "future" parser is a ground-up reimplementation of the Puppet grammar and evaluator. In addition to the experimental features it includes, the "future" parser makes some other changes and clean-ups to the language.


Enabling the Future Parser
-----

To enable the future parser:

* On your puppet master(s) (or all nodes, if running puppet apply), ensure the `rgen` gem is installed. If you installed Puppet from the official packages, this was already installed as a dependency; otherwise, you may need to install it manually.
* On your puppet master(s) (or each node, if running puppet apply), set [`parser = future`][parser_setting] in the `[master]` or `[main]` section of puppet.conf. (In a masterless "puppet apply" deployment, use `[main]`.)
    * Alternately, for one-off tests, you can set `--parser future` on the command line when running puppet apply.

### Toggling the Future Evaluator

By default, the future parser also uses a new evaluator. (The parser is what turns the source text into a model; the evaluator is what takes actions based on the model --- for example, reducing a complex expression into a simpler expression, or adding a resource to the catalog based on a resource declaration.)

The new evaluator defaults to enabled when the future parser is turned on, but it can be independently deactivated by setting [`evaluator = current`][evaluator_setting] in puppet.conf or `--evaluator current` on the command line.

This is generally only useful if you're comparing the old and new compilation systems and need to track down differences in catalog output.

Lambdas and Iteration
-----

The most complex features added by the future parser involve iterations and transformations acting on collections of data.

These features are covered in a separate document:

* [Experimental Features: Lambdas and Iteration](./experiments_lambdas.html)


Other New Language Features
-----

The future parser makes several other additions to the Puppet language.

### Expressions Are Now Valid Statements

In Puppet 3 it is not possible to have a body of code that is just an expression. This makes it

difficult to enter predicates as in the case of a collect or reject.

An expression such as...

    1 + 2

...is now a legal statement if it appears as the last "statement" in a block. Block "return" their last expression/statement as its produced result. There is no explicit "return", it is always the value of the last evaluated expression.

### Array/Hash Literals are Now Allowed Anywhere Arrays/Hashes are Allowed

In Puppet 3, if you wanted to operate on a literal array or hash, you typically had to assign it to a variable first. This was due to how the internal grammar for the language was organized. You can now use literal arrays and hashes more naturally in a puppet manifest.

    notice([1, 2][1])
    # produces the output
    Notice: Scope(Class[main]): 2

### Concatenation and Append

You can concatenate array and merge hashes with `+`

    [1,2,3] + [4,5,6]   # produces [1,2,3,4,5,6]
    {a => 1} + {b => 2} # produces {a=>1, b=>2 }

You can append to an array with `<<`

    [1,2,3] << 10 # produces [1,2,3,10]
    [1,2,3] << [4,5] # produces [1,2,3,[4,5]]

### A Semicolon Acts as an Optional Expression Separator

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

### Functions That Produce a Value May Be Invoked as Statements

It is harmless to call a function that produce a value and not use the returned value. Puppet 3 forbids this and raises an error. With the entry of iteration functions (which always return a value, but may be used for only the side effects) this was made impossible by Puppet 3's separation of function (returning a value) and procedure (returning nothing).

### Right Side of Matches May Be a String (unfinished)

It is allowed to have a string instead of a regular expression in matches expressions. The intent is to support variable interpolation in these strings before they are converted to regular expressions. This is unfinished, and will currently result in an error when evaluated (instead of when parsed).

### Unless with Else Supported

An `unless` can now have an `else` clause (but it cannot be combined with an `elsif`).

While not being recommended to use complex logic in `unless`, it is at the same time quite annoying to have to reverse tests in order to be able to do something like a notice "unless not triggered" for debugging.

### Chained Assignments

Chained assignments are now possible for both `=`, and `+=`.

    $a = $b = 10

Note that `=` and `+=` have low precedence, so this is an error:

    $a = 1 + $b = 10 # i.e. this is parsed as $a = (1 + $b) = 10

and needs to be written

    $a = 1 + ($b = 10)

Assignments may thus also be used where expressions are.

### Function Calls in Interpolation Supported

Calling a function in interpolation now works:

    notice "This is a random number: ${fqdn_rand(30)}

This has mysterious result in the regular parser since it is interpreted as

    ${$fqdn_rand(30)}


New Language Restrictions
-----

Since the future parser will not be enabled until at least the next major version boundary, we took the opportunity to clean up certain edge cases and oddities in the language. Most code written for the current parser should be forward compatible, but watch for these changes:

### User Defined Numeric Variables Not Allowed

Assignments to numeric variables are flagged as errors.

This is illegal:

    $3 = 'hello'

In some puppet versions this produces strange effects, and in some it is silently ignored.

As a consequence it is also illegal to name parameters in defines, and parameterized classes with numeric names.

This is illegal:

    define mytype ($1, $2) { … }

It is ok to use names with digits 0-9 as long as one character is not a digit.

### Capitalized Variable Names Not Allowed

Variable names may not contain capital letters. They are limited to lowercase letters, numbers, and underscores.

### "Bare Words" May Not Start with a Digit

The positive effect of this is that numbers entered without quotes can be validated to be correct decimal, hex or octal values.

### Numbers Are Validated If Entered without Quotes

If you enter an unquoted number in decimal, hex or octal it is now validated, and an error is raised if it is illegal.

These will raise errors:

    $a = 0x0EH
    $b = 0778

Error Reporting Improvements
-----

Another feature of the future parser is that it's now possible to introspect extra information about errors. We use this to improve error messages when using it.

### Many Errors Now Contain Position on Line

If available, errors now output position on the line. This helps for errors related to punctuation such as `{` since it may appear several times on a line and the problem may be hard to find/understand. (This problem was made worse with the addition of lambdas to the language since they are typically entered as one-liners).

The output format is: `filename:line:pos`

Pos is never displayed without a line; if you see `file:3`, it is a reference to the line.

Position starts from 1 (first character on a line is in position 1).

### Odd "Expected" Errors Fixed

When there is a syntax error involving a token that is paired (e.g. `{`, `(`, `[`), the error message always said "`expected ...`" and it showed the matching side of the violating token. This is only correct if the problem is reaching EOF. In all other cases this information was misleading, and adding what was suggested would almost always make things worse.

The "expected" is now only included when encountering the end of file and there are outstanding expectations (such as terminating an open string).

### Error and Warning Feedback

Error and Warning feedback from parsing now outputs multiple errors / warnings (if multiple were found before lower level parsing gave up). The default cap on output of these are 10. The number can be changed via the following puppet.conf settings:

* `max_errors`
* `max_warnings`
* `max_deprecations`

When there are multiple errors, the output emits errors up to the cap. A final error is then generated with the error and warning count. If there is only one error, only this error is emitted (no count). Deprecations count as warnings.

As an example, you can try this:

    $ puppet apply --parser future -e '$a = node "a+b" { }'
    Error: Invalid use of expression. A Node Definition does not produce a value at line 1:6
    Error: The hostname 'a+b' contains illegal characters (only letters, digits, '_', '-', and '.' are allowed) at line 1:11
    Error: Classes, definitions, and nodes may only appear at toplevel or inside other classes at line 1:6
    Error: Could not parse for environment production: Found 3 errors. Giving up on node henriks-macbook-pro.local

### Fat Arrow (`=>`) as Comma Is Not Supported

In the Puppet 3 parser, it is allowed to use a fat arrow `=>` in many places where a comma is required. This undocumented feature is removed in the experimental parser.
