---
layout: default
title: "Updating 3.x Manifests for Puppet 4.x"
---

[str2bool]: https://forge.puppetlabs.com/puppetlabs/stdlib#str2bool
[file_mode]: ./type.html#file-attribute-mode
[where]: ./whered_it_go.html
[reserved]: ./lang_reserved.html
[numeric]: ./lang_data_number.html
[expressions]: ./lang_expressions.html
[boolean]: ./lang_data_boolean.html


Several breaking changes were introduced in Puppet 4.0. If you previously used Puppet 3.x, your manifests will need to be updated for the new implementation. This page lists the most important steps to update your manifests to be 4.x compatible.


## Make sure everything is in the right place

The locations of code directories and important config files have changed. Read about [where everything went][where] to make sure your files are in the correct place before tackling updates to your manifests.

## Double-check to make sure it's safe before purging `cron` resources

Previously, using [`resources {'cron': purge => true}`](./type.html#resources) to purge `cron` resources would only purge jobs belonging to the current user performing the Puppet run (usually `root`). [In Puppet 4](/puppet/4.0/release_notes.html), this action is more aggressive and causes **all** unmanaged cron jobs to be purged.

Make sure this is what you want. You might want to set `noop => true` on the purge resource to keep an eye on it.

## Check your data types

[Data types](./lang_data.html) have changed in a few ways.

### Boolean facts are always real booleans

In Puppet 3, facts with boolean true/false values (like `$is_virtual`) were converted to strings unless the `stringify_facts` setting was disabled. This meant it was common to test for these facts with the `==` operator, like `if $is_virtual == 'true' { ... }`.

In Puppet 4, boolean facts are never turned into strings, and those `==` comparisons will always evaluate to `false`. This can cause serious problems. Check your manifests for any comparisons that treat boolean facts like strings; if you need a manifest to work with both Puppet 3 and Puppet 4, you can convert a boolean to a string and then pass it to [the stdlib module's `str2bool` function][str2bool]:

``` puppet
if str2bool("$is_virtual") { ... }
```

### Numbers and strings are different in the DSL

For full details, [see the language page about numeric values.][numeric]

Previously, Puppet would convert everything to strings, then attempt to convert those strings back into numbers when they were used in a numeric context. In Puppet 4, numbers in the DSL are parsed and maintained internally as numbers. The following examples would have been equivalent in Puppet 3, but are now different:

``` puppet
$port_a = 80   # Parsed and maintained as a number, errors if NOT a number
$port_b = '80' # Parsed and maintained as a string
```

The difference now is that Puppet will STRICTLY enforce numerics and will throw errors if values that begin with a number are not valid numbers.

``` puppet
node 1name {} # invalid because 1name is not a valid decimal number; you would need to quote this name
notice(0xggg) # invalid because 0xggg is not a valid hexadecimal number
$a = 1 + 0789 # invalid because 0789 is not a valid octal number
```

### Arithmetic expressions

Mathematical expressions still convert strings to numeric values. If a value begins with 0 or 0x, it will be interpreted as an octal or hex number, respectively.  An error is raised if either side in an arithmetic expression is not a number or a string that can be converted to a number.  For example:

``` puppet
$valid = 40 + 50       # valid because both values are numeric
$valid = 25 + '30'     # valid because '30' can be cast numerically
$invalid = 40 + 0789   # invalid because 0789 isn't a valid octal number
$invalid = 40 + '0789' # invalid because '0789' can't be cast numerically
```

## Check your comparisons

Some comparison operations have changed in Puppet 4. Read about [expressions and operators][expressions] for the full details.

### Regular expressions against non-strings

Matching a value that is not a string with a regular expression now raises an error. In 3.x, other data types were converted to string form before matching (often with surprising and undefined results).

``` puppet
$securitylevel = 2

case $securitylevel {
  /[1-3]/: { notify { 'security low': } }
  /[4-7]/: { notify { 'security medium': } }
  default: { notify { 'security high': } }
}
```

Prior to Puppet 4.0, the first regex would match, and the notify { 'security low': } resource would be put into the catalog.

Now, in Puppet 4.0, neither of the regexes would match because the value of `$securitylevel` is an integer, not a string, and so the default condition would match, resulting in the inclusion of notify `{ 'security high': }` in the catalog.

### Empty strings in boolean context are `true`

In previous versions of Puppet, an empty string was evaluated as a `false` boolean value. You would see this in variable and parameter default values where conditional checks would be used to determine if someone passed in a value or left it blank.

``` puppet
class empty_string_defaults (
  $parameter_to_check = ''
) {
  if $parameter_to_check {
    $parameter_to_check_real = $parameter_to_check
  } else {
    $parameter_to_check_real = 'default value'
  }
}
```

Puppet's old behavior of evaluating the empty string as `false` would allow you to set the default based on a simple if-statement. In Puppet 4.x, this behavior is flipped and `$parameter_to_check_real` will be set to an empty string.

You can check your existing codebase for this behavior with a [puppet-lint plugin](https://github.com/puppet-community/puppet-lint-empty_string-check).

See [the language page on boolean values][boolean] for more info.

### The `in` operator is slightly different

The `in` operator used to be case-sensitive when testing strings, which was inconsistent with the `==` operator. Now it's case-insensitive, like `==`. It can also test regular expressions and data types, which wasn't possible before.

The full behavior is [defined in the documentation](./lang_expressions.html#in).

### Comparing data types

Different [data types](./lang_data.html) can't be compared as if they're the same data type anymore. This is most noticeable when comparing numbers to strings.

## Check single-quoted strings for double backslashes

The `\\` escape now works properly in single-quoted strings. Previously, there was no way to end a single-quoted string with a backslash.

This will change any existing strings that are supposed to have literal double backslashes in them; you'll need to change them to quadruple backslashes. Read more about this behavior in the [language page about strings](./lang_data_string.html#single-quoted-strings).

## Check names of variables, classes, functions, defined types, etc.

Naming conventions have changed and become more strict.

* Capitalized bare words as un-quoted strings are no longer allowed.
* Variables must not start with capital letters.
* Classes, defined types, functions must not include hyphens or begin with digits.

## Check for non-productive expressions

Puppet 4.0.0 validates logic that has no effect and flags such expressions as being errors.

An example of a non productive expression is:

``` puppet
if true { } # non productive
$a = 10
```

The `if` expression produces a value of `undef`, which is then thrown away. Note that expressions are never considered non-productive when they are the last in a manifest or block of code, as that is also the value of the sequence.

If Puppet raises a non-productive expression error about your code, you should be able to remove the offending statements without changing the code's behavior.


## Check for bare words that might now be reserved

More reserved words were added in Puppet 4.0, so check your manifests for any un-quoted strings on [the reserved words list][reserved] and quote them as needed.

## Check for excess spaces when accessing hashes and arrays

The space between a value and a left bracket is significant, and Puppet will output different results if there is a space.

Bad:

``` puppet
$a [3]  # first the value of a, then a literal array with the single value 3 in it
```

Good:

``` puppet
$a[3]   # index 3 in the array referenced by $a
```

## Check for function calls without parentheses

Only certain functions are allowed to be called without parentheses. Read the [documentation on functions](./lang_functions.html) to learn when parentheses can be omitted.

## Check your regular expressions for correct syntax

Puppet 4 bundles its own copy of Ruby 2.x, and the regex syntax is slightly different than Ruby 1.8.7, which you might have been running prior to upgrade. Because the two versions of Ruby use differing regex engines, your results might vary.

## Check YAML files used by Hiera, etc. for correct syntax

If the Ruby version changed since upgrade, the YAML parser will be more strict. Ensure strings containing a `%` are quoted.

## Check the `mode` attribute of any file resources

[The `mode` attribute][file_mode] of a file resource must be a string. If you use an actual octal number, it will be converted to a decimal number, then converted back to a string representing the wrong number when it comes time to run the `chown` command.

## Check for resources with `noop => true` that receive refresh events

In Puppet 3, resources with `noop` set to true could escape no-op mode and cause changes if they received a refresh event (via the `notify` or `subscribe` metaparameters or the `~>` arrow).

This is no longer possible in Puppet 4; no-op resources always stay no-op. For most users that's a win with no downside, but there's a slim chance that your configurations relied on this behavior, so look around to make sure.

## Check for removed features

Several things were removed from Puppet 4, either because they no longer had practical use cases and were not being used, or there was a better work around.

### `import` statements and node inheritance

Removal of `import` means you'll have to use a directory as your main manifest to recreate this functionality. Read the [Main Manifest](./dirs_manifest.html) page to learn more about this method.

Node inheritance has also been removed. It is no longer possible to have node definitions that inherit from another node definition. You can get better results by using a combination of Hiera data and wrapper modules to construct system configurations.

### Dynamic scoping in ERB

In Puppet 4.0, dynamic scoping has been removed for variables in ERB templates.

``` puppet
class outer {
  $var = 'dynamic'
  include inner
}

class inner {
  notice(inline_template('<%= @var %>'))
}

include outer
```

Prior to Puppet 4.x, the value supplied to `notice()` will resolve to the string dynamic.

Now, in Puppet 4.x, the value supplied to `notice()` will resolve to an empty string.

The behavior of resource defaults has not been changed.

### += and -=

These operators have been removed. You can run the puppet-lint plugin to check your existing code base for them.

### Modules using the Ruby DSL

Finally, the long-deprecated Ruby DSL has been fully removed from Puppet.

