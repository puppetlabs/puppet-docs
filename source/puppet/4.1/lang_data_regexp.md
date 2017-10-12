---
layout: default
title: "Language: Data Types: Regular Expressions"
canonical: "/puppet/latest/lang_data_regexp.html"
---

[regsubst]: ./function.html#regsubst
[match]: ./function.html#match
[ruby_regexp]: http://ruby-doc.org/core/Regexp.html
[conditional]: ./lang_conditional.html
[node]: ./lang_node_definitions.html
[local]: ./lang_scope.html#local-scopes
[data type]: ./lang_data_type.html
[pattern]: ./lang_data_abstract.html#pattern


A regular expression (sometimes shortened as "regex" or "regexp") is a pattern that can match some set of strings, and optionally capture parts of those strings for further use.

You can use regular expression values with the `=~` and `!~` match operators, case statements and selectors, node definitions, and certain functions (notably [`regsubst`][regsubst] for editing strings and [`match`][match] for capturing and extracting substrings). Regexes act like any other value, and can be assigned to variables and used in function arguments.

## Syntax

Regular expressions are written as patterns bordered by forward slashes. (Unlike in Ruby, you cannot specify options or encodings after the final slash, like `/node .*/m`.)

~~~ ruby
    if $host =~ /^www(\d+)\./ {
      notify { "Welcome web server #$1": }
    }
~~~

Puppet uses [Ruby's standard regular expression implementation][ruby_regexp] to match patterns.

Alternate forms of regex quoting like Ruby's `%r{^www(\d+)\.}` are not allowed. You cannot interpolate variables or expressions into regex values.

Some places in the language accept both real regex values and stringified regexes --- that is, the same pattern quoted as a string instead of surrounded by slashes.

## Regex Options

Regexes in Puppet cannot have options or encodings appended after the final slash. However, you can turn options on or off for portions of the expression using the `(?<ENABLED OPTION>:<SUBPATTERN>)` and `(?-<DISABLED OPTION>:<SUBPATTERN>)` notation. The following example enables the `i` option while disabling the `m` and `x` options:

~~~ ruby
     $packages = $operatingsystem ? {
       /(?i-mx:ubuntu|debian)/        => 'apache2',
       /(?i-mx:centos|fedora|redhat)/ => 'httpd',
     }
~~~

The following options are allowed:

* i --- Ignore case
* m --- Treat a newline as a character matched by `.`
* x --- Ignore whitespace and comments in the pattern

## Regex Capture Variables

Within [conditional statements][conditional] and [node definitions][node], any captured substrings from parentheses in a regular expression will be available as numbered variables (`$1, $2`, etc.) inside the associated code section, and the entire match will be available as `$0`.

These are not normal variables, and have some special behaviors:

* The values of the numbered variables do not persist outside the code block associated with the pattern that set them.
* You can't manually assign values to a variable with only digits in its name; they can only be set by pattern matching.
* In nested conditionals, each conditional has its own set of values for the set of numbered variables. At the end of an interior statement, the numbered variables are reset to their previous values for the remainder of the outside statement. (This causes conditional statements to act like [local scopes][local], but only with regard to the numbered variables.)

## The `Regexp` Data Type

The [data type][] of regular expressions is `Regexp`.

By default, `Regexp` matches any regular expression value.

You can use parameters to restrict which values `Regexp` will match.

### Parameters

The full signature for `Regexp` is:

    Regexp[<SPECIFIC REGULAR EXPRESSION>]

This parameter is optional.

Position | Parameter        | Data Type | Default Value | Description
---------| -----------------|-----------|---------------|------------
1 | Specific regular expression | `Regexp` | none | If specified, this will result in a data type that only matches one specific regular expression value. This doesn't have any particular practical use.

### Examples

* `Regexp` --- matches any regular expression.
* `Regexp[/foo/]` --- matches the regular expression `/foo/` only.

### Related Data Types

`Regexp` only matches literal regular expression values. It's not to be confused with [the abstract `Pattern` data type][pattern], which uses a regular expression to match a limited set of `String` values.
