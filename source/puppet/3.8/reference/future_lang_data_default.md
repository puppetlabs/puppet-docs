---
layout: default
title: "Future Parser: Data Types: Default"
canonical: "/puppet/latest/reference/lang_data_default.html"
---

[case statements]: ./future_lang_conditional.html#case-statements
[selector expressions]: ./future_lang_conditional.html#selectors
[resource declaration]: ./future_lang_resources.html
[data type]: ./future_lang_data_type.html
[string]: ./future_lang_data_string.html
[resources_advanced]: ./future_lang_resources_advanced.html

Puppet's special `default` value usually acts like a keyword in a few limited corners of the language. Less commonly, it can also be used as a value in other places.

## Syntax

The only value in the default data type is the bare word `default`.

## Usage

The special `default` value is used in a few places:

### Cases and Selectors

In [case statements][] and [selector expressions][], you can use `default` as a _case,_ where it causes special behavior. Puppet will only try to match a `default` case last, after it has tried to match against every other case.

### Per-Block Resource Defaults

You can use `default` as the title in a [resource declaration][] to invoke special behavior. (For details, see [Resources (Advanced).][resources_advanced])

Instead of creating a resource and adding it to the catalog, the special `default` resource sets fallback attributes that can be used by any other resource in the same resource expression. That is:

~~~ ruby
    file {
      default:
        mode   => '0600',
        owner  => 'root',
        group  => 'root',
        ensure => file,
      ;
      '/etc/ssh_host_dsa_key':
      ;
      '/etc/ssh_host_key':
      ;
      '/etc/ssh_host_dsa_key.pub':
        mode => '0644',
      ;
      '/etc/ssh_host_key.pub':
        mode => '0644',
      ;
    }
~~~

All of the resources in the block above will inherit attributes from `default` unless they specifically override them.

### Parameters of Data Types

Several [data types][data type] take parameters that have default values. In some cases, like minimum and maximum sizes, the default value can be difficult or impossible to refer to using the available literal values in the Puppet language. For example, the default value of [the `String` type][string]'s max length parameter is infinity, which can't be represented in the Puppet language.

These parameters will often let you provide a value of `default` to say you want the otherwise-unwieldy default value.

### Anywhere Else

You can also use the value `default` anywhere you aren't prohibited from using it. In these cases, it generally won't have any special meaning.

There are a few reasons you might want to do this. The main one would be if you were writing a class or defined resource type and wanted to give users the option to specifically request a parameter's default value. Some people have used `undef` to do this, but that's tricky when dealing with parameters where `undef` would, itself, be a meaningful value. Others have used some gibberish value, like the string `"UNSET"`, but this can be messy.

In other words, using `default` would let you distinguish between:

* A chosen "real" value
* A chosen value of `undef`
* Explicitly declining to choose a value, represented by `default`

In other other words, `default` can be useful when you need a truly meaningless value.

## The `Default` Data Type

The [data type][] of `default` is `Default`.

It matches only the value `default`, and takes no parameters.

### Examples

* `Variant[String, Default, Undef]` --- matches `undef`, `default`, or any string.

