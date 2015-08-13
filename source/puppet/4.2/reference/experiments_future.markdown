---
layout: default
title: "Updating 3.x Manifests for Puppet 4.x"
canonical: "/puppet/latest/reference/experiments_future.html"
---

[boolean_convert_old]: ./lang_datatypes.html#automatic-conversion-to-boolean
[boolean_convert]: ./lang_data_boolean.html#automatic-conversion-to-boolean
[iteration]: ./lang_iteration.html
[match_operator]: ./lang_expressions.html#regex-or-data-type-match
[parameter_datatypes]: ./lang_data_type.html#parameter-lists
[data_types]: ./lang_data.html
[relative_namespace]: ./lang_namespaces.html#relative-name-lookup-and-incorrect-name-resolution
[comparison operators]: ./lang_expressions.html#comparison-operators
[fact]: ./lang_facts_and_builtin_vars.html
[strings]: ./lang_data_string.html
[stringify_facts]: /references/4.2.latest/configuration.html#stringifyfacts
[str2bool]: https://forge.puppetlabs.com/puppetlabs/stdlib#str2bool
[file_mode]: /references/4.2.latest/type.html#file-attribute-mode
[integer_bases]: ./lang_data_number.html#octal-and-hexadecimal-integers
[where]: ./whered_it_go.html
[reserved]: ./lang_reserved.html



Several breaking changes were introduced in Puppet 4.x and your manifests will need to be updated to for the new implementation. This page helps to identify some of the steps necessary to update your manifest to be 4.x compatible.


## Make Sure Everything Is in the Right Place

The locations of important config files and directories have changed. Read about [where everything went][where] to make sure your files are in the correct place before tackling updates to your manifest.

## Double-Check to Make Sure It's Safe Before Purging `cron` Resources

Previously, using the [resources]() resource to set `purge` to `true` for `cron` resources would only result in the purge of the current user performing the Puppet run's unmanaged cron jobs. [In Puppet 4](https://docs.puppetlabs.com/puppet/4.0/reference/release_notes.html_), this action is more aggressive and causes **all** unmanaged cron jobs to be purged.

## Check Your Data Types

[Data types](./lang_data.html) have changed in a few ways.

### Numbers and Strings Are Different in the DSL

Previously, Puppet would convert everything to strings, and then attempt to convert numbers to numerics for the purpose of arithmetic and comparison (which, as you'll see, it will still attempt to do). In Puppet 4, numbers in the DSL are parsed and maintained internally as numbers, so the below are different:

    $port_a = 80   # Parsed and maintained as a number, errors if NOT a number
    $port_b = '80' # Parsed and maintained as a string

The difference now is that Puppet will STRICTLY enforce numerics and will throw errors if strings that begin with a number are not valid numbers.

    node 1name {} # invalid because 1name is not a valid decimal number
    notice(0xggg) # invalid because 0xggg is not a valid hexadecimal number
    $a = 1 + 0789 # invalid because 0789 is not a valid octal number

### Arithmetic Expressions

Mathematical equations still convert strings to numeric values using the prefixes 0, and 0x to determine if the number in string form is an octal or hex number.  An error is raised if either side in an arithmetic expression is not numeric or a string is not convertible to numeric.  For example:

    $number = 40 + 50     # valid because both values are numeric
    $another = 25 + '30'  # valid because '30' can be cast numerically
    $nan = 40 + 0789      # invalid because 0789 isn't a valid octal number
    $nanliu = 40 + '0789' # invalid because '0789' can't be cast numerically

## Check Your Comparisons

Comparison operations have changed in Puppet 4. Read about expressions and operators for the full details.

### Regular Expressions Against Non Strings

Matching a value that is not a string with a regular expression now raises an error. In 3.x, other data types were converted to string form before matching with surprising and undefined results.

    ~~~
    $securitylevel = 2

    case $securitylevel {
      /[1-3]/: { notify { 'security low': } }
      /[4-7]/: { notify { 'security medium': } }
      default: { notify { 'security high': } }
    }
    ~~~

Prior to Puppet 4.0, the first regex would match, and the notify { 'security low': } resource would be put into the catalog.

Now, in Puppet 4.0, neither of the regexes would match because the value of `$securitylevel` is an integer, not a string, and so the default condition would match, resulting in the inclusion of notify `{ 'security high': }` in the catalog.

### Empty Strings in Boolean are `true`

In previous versions of Puppet, an empty string was evaluated as a `false` boolean value. You would see this in variable and parameter default values where conditional checks would be used to determine if someone passed in a value or left it blank.

~~~
    class empty_string_defaults (
      $parameter_to_check = ''
    ) {
      if $parameter_to_check {
        $parameter_to_check_real = $parameter_to_check
      } else {
        $parameter_to_check_real = 'default value'
      }
    }
~~~

Puppet's old behavior of evaluating the empty string as `false` would allow you to set the default based on a simple if-statement. In Puppet 4.x, this behavior is flipped and `$parameter_to_check_real` will be set to an empty string.

You can check your existing codebase for this behavior with the [puppet-lint plugin](https://github.com/puppet-community/puppet-lint-empty_string-check).

### The `in` Operator Is Now Specified

The `in` operator works slightly differently and its behaviors are now better [defined in the documentation](./lang_expressions.html#in).

### Comparing Data Types

Different [data types](./lang_data.html) can't be compared as if they're the same data type anymore.

## Check Single-Quoted Strings for Double Backslashes

The `\\` escape now works properly. Previously, there was no way to end a single-quoted string with a backslash.

This will change any existing that are supposed to have literal double backslashes in them. Read more about this behavior in the [Puppet Reference Manual](./lang_data_string.html#single-quoted-strings).

## Names of Variables, Classes, Functions, Defined Types, etc.

Naming conventions have changed and become more strict.

* Capitalized bare words as un-quoted strings are no longer allowed.
* Variables must not start with capital letters.
* Classes, defined types, functions must not include hyphens or begin with digits.

## Check for Non-Productive Expressions

Puppet 4.0.0 validates logic that has no effect and flags such expressions as being errors.

An example of a non productive expression is:

    if true { } # non productive
    $a = 10


The if expression produces undef, which is then thrown away. Note that expressions are never considered non-productive when they are the last in a sequence as that is also the value of the sequence. If code contains non-productive expression after being reviewed, simply remove them.



## Check for Bare Words That May Now Be Reserved

More reserved words were added in Puppet 4.0, so check your manifests for any un-quoted strings on [the reserved words list][reserved] and quote them as needed.

## Check for Excess Spaces in Hashes and Arrays

The space between a value and a left bracket is significant, and will output different results if there is a space.

Bad:

    $a [3]  # first the value of a, then a literal array with the single value 3 in it


Good:

    $a[3]   # index 3 in the array referenced by $a

## Check for Function Calls Without Parentheses

Only certain functions are allowed to be called without parentheses. Read the [documentation on functions](./lang_functions.html) to learn when parentheses can be omitted.

## Check Your Regular Expressions for Correct Syntax

Puppet 4 bundles its own copy of Ruby 2.x, and the regex syntax is slightly different than Ruby 1.8.7, which you may have been running prior to upgrade. Because the two versions of Ruby use differing regex engines, your results may vary.

## Check YAML Files Used by Hiera, etc. for Correct Syntax

If the Ruby version changed since upgrade, the yaml parser will be more strict. Ensure strings containing a % are quoted.

## Check the `mode` Attribute of Any File Resources

The `mode` attribute of file resources must be strings. If you use an actual octal number, it will be converted to a decimal number, then converted back to a string representing the wrong number when it comes time to run the `chown` command.

## Check for Resources with `noop => true`

In Puppet 4.0.0, resources with `noop` set to true are no longer enforced when being notified or when subscribed.

## Check for Removed Things

Several things were removed from Puppet 4, either because they did not have practical use cases and were not being used, or there was a better work around.

### `import` Statements and Node Inheritance

Removal of `import` means you'll have to use a directory as your main manifest to recreate this functionality. Read the [Main Manifest](./dirs_manifest.html) page to learn more about this method.

Node inheritance has also been removed. It is no longer possible to have node definitions that inherit from another node definition. Better results can be achieved using a combination of Hiera data and wrapper modules to construct system configurations.

### Dynamic Scoping

In Puppet 4.0, dynamic scoping has been removed from resource defaults and variables in ERB templates. The behavior of resource defaults has not been changed.

    class outer {
      $var = 'dynamic'
      include inner
    }

    class inner {
      notice(inline_template('<%= @var %>'))
    }

    include outer

Prior to Puppet 4.x, (dynamic versions) the value supplied to `notice()` will resolve to the string dynamic.

Now, in Puppet 4.x, the value supplied to `notice()` will resolve to an empty string.

### += and -=

These operators have been removed. You can run the puppet-lint plugin to check your existing code base for them.

### Modules Using the Ruby DSL

Finally, the long-deprecated Ruby DSL has been fully removed from Puppet.

