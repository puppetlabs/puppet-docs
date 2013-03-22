---
layout: default
title: "Hiera 1: Lookup Types"
---


Hiera always takes a lookup key and returns a single value (of some simple or complex data type), but it has several methods for extracting/assembling that one value from the hierarchy. We refer to these as "lookup methods."

All of these lookup methods are available via Hiera's Puppet functions, command line interface, and Ruby API.


Priority (default)
-----

A **priority lookup** gets a value from **the** most specific matching level of the hierarchy. Only one hierarchy level --- the first one to match --- is consulted.

Priority lookups can retrieve values of any data type (strings, arrays, hashes), but the entire value will come from only one hierarchy level.

This is Hiera's default lookup method.


Array Merge
-----

An **array merge lookup** assembles a value from **every** matching level of the hierarchy. It retrieves **all** of the (string or array) values for a given key, then **flattens** them into a single array of unique values. If priority lookup can be thought of as a "default with overrides" pattern, array merge lookup can be though of as "default with additions."

For example, given a hierarchy of:

    - web01.example.com
    - common

...and the following data:

{% highlight yaml %}
    # web01.example.com.yaml
    mykey: one

    # common.yaml
    mykey:
      - two
      - three
{% endhighlight %}

...an array merge lookup would return a value of `[one, two, three]`.

In this version of Hiera, array merge lookups will fail with an error if any of the values found in the data sources are hashes. It only works with strings, string-like scalar values (booleans, numbers), and arrays.


Hash Merge
-----

A **hash merge lookup** assembles a value from **every** matching level of the hierarchy. It retrieves **all** of the (hash) values for a given key, then **merges** the top-level keys in each source hash into a single hash. Note that this does not do a deep-merge in the case of nested structures; it only handles top-level keys. 

For example, given a hierarchy of:

    - web01.example.com
    - common

...and the following data:

{% highlight yaml %}
    # web01.example.com.yaml
    mykey: 
      z: "local value"

    # common.yaml
    mykey:
      a: "common value"
      b: "other common value"
      z: "default local value"
{% endhighlight %}

...a hash merge lookup would return a value of `{z => "local value", a => "common value", b => "other common value"}`. Note that in cases where two or more source hashes share some keys, higher priority data sources in the hierarchy will override lower ones.

In this version of Hiera, hash merge lookups will fail with an error if any of the values found in the data sources are strings or arrays. It only works when every value found is a hash. 
