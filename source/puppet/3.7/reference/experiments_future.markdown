---
layout: default
title: "Future Parser: Introduction to the Future Parser"
canonical: "/puppet/3.8/reference/experiments_future.html"
---

[parser_setting]: ./configuration.html#parser
[boolean_convert_old]: ./lang_datatypes.html#automatic-conversion-to-boolean
[boolean_convert]: ./future_lang_data_boolean.html#automatic-conversion-to-boolean
[puppet.conf]: ./config_file_main.html
[environment]: ./environments.html
[environment.conf]: ./config_file_environment.html
[iteration]: ./future_lang_iteration.html
[match_operator]: ./future_lang_expressions.html#regex-or-data-type-match
[parameter_datatypes]: ./future_lang_data_type.html#parameter-lists
[data_types]: ./future_lang_data.html
[relative_namespace]: ./lang_namespaces.html#relative-name-lookup-and-incorrect-name-resolution
[comparison operators]: ./future_lang_expressions.html#comparison-operators
[fact]: ./future_lang_facts_and_builtin_vars.html
[strings]: ./future_lang_data_string.html
[stringify_facts]: ./configuration.html#stringifyfacts
[str2bool]: https://forge.puppetlabs.com/puppetlabs/stdlib#str2bool
[file_mode]: ./type.html#file-attribute-mode
[integer_bases]: ./future_lang_data_number.html#octal-and-hexadecimal-integers

Over the course of the 3.x series, Puppet has included work-in-progress releases of a rewritten Puppet language, which can be enabled with a setting. This revised language includes significant breaking changes, major additions, and a new underlying implementation.

In Puppet 4.0, the rewritten language is the new normal; in this version of Puppet, it's optional, and you can choose when and where to enable it.

As of Puppet 3.7.5, the future parser is functionally identical to the Puppet language in Puppet 4.0. It's ready for real-world use, and it should be an important part of your migration to Puppet 4.


Enabling the Future Parser
-----

To enable the future parser, you need to set [the `parser` setting][parser_setting] to `future`. This setting is used by the Puppet master and Puppet apply applications.

There are three ways to change the parser:

* To enable the future parser **globally,** you can set `parser = future` in the `[main]` section of [puppet.conf][].
* To enable the future parser **for a specific [environment][],** you can set `parser = future` in that environment's [environment.conf][] file. This is only available in Puppet 3.7.5 and later.
* For one-off tests, you can set `--parser future` on the command line when running Puppet apply.

**Note:** If you installed Puppet with something other than the official packages, ensure that the `rgen` gem is installed on your Puppet master(s) (or all nodes, if running Puppet apply).

What's Cool About the Future Parser
-----

### Lambdas and Iteration

Puppet now has iteration and looping features, which can help you write more succinct and readable code.

For an introduction, see [the language page on iteration.][iteration]

### Better Data Type Enforcement

The revised language has a more consistent concept of data types now, and you can take advantage of it in several ways. It's now easier to [test what data type a value is][match_operator] and catch common errors early by [restricting allowed values for class/defined type parameters.][parameter_datatypes]

For an introduction, see [the language page on data types.][data_types]

### Cleaner and More Consistent Behavior

<del>The frustrations of <a href="./lang_namespaces.html#relative-name-lookup-and-incorrect-name-resolution">relative namespace lookup</a> are gone.</del> (Not actually fixed in 3.7; see [PUP-4818](https://tickets.puppetlabs.com/browse/PUP-4818).) Most expressions with values work the same now, so the weird rules about where you can use a variable but not a function call are gone. A lot of edge cases have been cleaned up, and everything is just a lot nicer.


What's Tricky About Switching to the Future Parser
-----

The revised language includes breaking changes, and some of them might break your existing Puppet code or make it behave differently. Watch out for the following:

### Check Your Comparisons

The rules for comparing values with the [comparison operators][] have changed quite a bit, and some of the changes might reverse the results of comparisons in your code. So you'll want to check your `if`, `unless`, `case`, and selector expressions to see if you're relying on changed behavior.

The most notable changes are:

* The `in` operator now ignores case when comparing strings, same as the `==` operator.
* You can't do relative comparisons with incompatible data types. For example, `"3" < 40` is now an error, because strings and numbers aren't the same anymore.
* The rules for converting non-boolean values to boolean have changed. In the future parser, [`undef` converts to `false`][boolean_convert] and all other non-boolean values convert to `true`; in the 3.x parser, [empty strings were also false.][boolean_convert_old]


### Facts Can Have Additional Data Types

Look for any place in your code that either _checks truth_ of a [fact][] or makes a numerical comparison with a fact, and make sure they're ready for Puppet 4.

This isn't strictly part of the future parser, but it's a related change that and can be enabled early with a setting.

Old versions of Facter returned all facts as [strings][], but modern versions can return facts of many data types. Puppet will use the real fact data types if [the `stringify_facts` setting][stringify_facts] is set to `false`, which is the default in Puppet 4.0 and up.

This is generally good, but a lot of older code assumes that "boolean" facts like `$is_virtual` are actually strings, using conditionals like `if $is_virtual == "true"`. If you enable multi-type facts, any conditionals that treat booleans like strings will silently change their behavior, which is super bad. You'll need to change these when migrating to the future parser.

Most people will want a period of overlap, where their code can work in both Puppet 4 and Puppet 3. The safe and compatible way to handle boolean facts is to:

* Interpolate the fact into a string (`"$is_virtual"`)...
* ...then pass the string to [the stdlib `str2bool` function][str2bool] (`str2bool("$is_virtual")`).

This will behave identically in new and old Puppet versions.


### Quote Any Octal Numbers in File Modes

Search your code for any use of [the `file` type's `mode` attribute,][file_mode] and make sure the mode is quoted. Unquoted numbers in the `mode` attribute will cause compilation errors in Puppet 4 (and a deprecation warning in this version of Puppet).

We enabled integers in [octal and hexidecimal][integer_bases] bases as part of making data types more rigorous, and Puppet internally normalizes these numbers to decimal base. And since the `mode` attribute is actually just a string that's passed to the underlying operating system tools, a literal octal number would be converted into decimal before being converted to a string, which would result in something very unwanted. So Puppet 4 fails early if you do that, instead of doing anything weird.
