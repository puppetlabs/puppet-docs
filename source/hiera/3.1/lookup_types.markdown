---
layout: default
title: "Hiera 3.1: Lookup Types"
---

{% partial /hiera/_hiera_update.md %}

Hiera always takes a lookup key and returns a single value (of some simple or complex data type), but it has several methods for extracting/assembling that one value from the hierarchy. We refer to these as "lookup methods."

All of these lookup methods are available via Hiera's Puppet functions, command line interface, and Ruby API.


Priority (default)
-----

A **priority lookup** gets a value from **the** most specific matching level of the hierarchy. Only one hierarchy level --- the first one to match --- is consulted.

Priority lookups can retrieve values of any data type (strings, arrays, hashes), but the entire value will come from only one hierarchy level.

This is Hiera's default lookup method.

### Lookup Keys

Unlike the other lookup types, priority lookup accepts two kinds of key:

* **Top-level lookup keys,** which return the entire value of the key.
* **Qualified keys,** which return just the specified part of a value.

Qualified keys are composed of a top-level lookup key along with any number of additional subkeys, separated by dots.

For example, to look up an element in a hash:

~~~
$ hiera user
{"name"=>"kim", "home"=>"/home/kim"}

$ hiera user.name
kim
~~~

Or, to look up an element in an array:

~~~
$ hiera ssh_users
["root", "jeff", "gary", "hunter"]

$ hiera ssh_users.0
root
~~~

A subkey can be an integer if the value is an array, or a key name if the value is a hash. You can also chain subkeys together for deeply nested structures. Qualified keys can be used in interpolated values just like a normal key, so `%{hiera('user.name')}` is valid.

If no matching key or subkey is found, Hiera returns a `nil` result. If a subkey is an unexpected type (e.g., you tried to use an integer as a hash key or a string as an array index), an exception is returned.

#### Note About Other Lookup Methods

Hiera doesn't support using qualified keys with array merge or hash merge lookups. If you're looking up merged data, you must use a non-segmented key to get the entire merged hash or array and then manipulate the data as needed.

Array Merge
-----

An **array merge lookup** assembles a value from **every** matching level of the hierarchy. It retrieves **all** of the (string or array) values for a given key, then **flattens** them into a single array of unique values. If priority lookup can be thought of as a "default with overrides" pattern, array merge lookup can be though of as "default with additions."

For example, given a hierarchy of:

    - web01.example.com
    - common

...and the following data:

~~~ yaml
    # web01.example.com.yaml
    mykey: one

    # common.yaml
    mykey:
      - two
      - three
~~~

...an array merge lookup would return a value of `[one, two, three]`.

In this version of Hiera, array merge lookups fail with an error if any of the values found in the data sources are hashes. It only works with strings, string-like scalar values (booleans, numbers), and arrays.


Hash Merge
-----

A **hash merge lookup** assembles a value from **every** matching level of the hierarchy. It retrieves **all** of the (hash) values for a given key, then **merges** the hashes into a single hash.

Hash merge lookups fail with an error if any of the values found in the data sources are strings or arrays. It only works when every value found is a hash.


### Native Merging

In a native hash merge, Hiera merges only the **top-level keys and values** in each source hash. If the same key exists in both a lower priority source and a higher priority source, the higher priority value is used.

For example, given a hierarchy of:

    - web01.example.com
    - common

...and the following data:

~~~ yaml
    # web01.example.com.yaml
    mykey:
      z: "local value"

    # common.yaml
    mykey:
      a: "common value"
      b: "other common value"
      z: "default local value"
~~~

...a native hash merge lookup would return a value of `{z => "local value", a => "common value", b => "other common value"}`. Note that in cases where two or more source hashes share some keys, higher priority data sources in the hierarchy override lower ones.

### Deep Merging in Hiera

You can also configure hash merge lookups to **recursively merge** hash keys. (Implemented as [Issue 16107](https://projects.puppetlabs.com/issues/16107).) This is intended for users who have moved complex data structures (such as [`create_resources` hashes][create]) into Hiera.

To configure deep merging, use the [`:merge_behavior` setting][mergebehavior], which can be set to `native`, `deep`, or `deeper`. Additionally, you can pass a hash of options to the deep merge gem with [`:deep_merge_options`][deepmerge_options].

> Limitations:
>
> * This currently only works with the yaml and json backends.
> * You must install the `deep_merge` Ruby gem for deep merges to work. If it isn't available, Hiera falls back to the default `native` merge behavior. If you're using Puppet Server, you'll need to use the [`puppetserver gem`][puppetserver_gem] command to install the gem.
> * This configuration is global, not per-lookup.

[create]: /puppet/latest/reference/function.html#createresources
[mergebehavior]: ./configuring.html#mergebehavior
[deepmerge]: https://github.com/danielsdeleo/deep_merge
[puppetserver_gem]: /puppetserver/latest/gems.html#installing-and-removing-gems
[deepmerge_options]: ./configuring.html#deepmergeoptions

#### Merge Behaviors

There are three merge behaviors available.

* The default `native` type is described above under "Native Merging."
* The `deep` type is largely useless and should be avoided.
* The `deeper` type does a recursive merge, behaving as most users expect.

In a `deeper` hash merge, Hiera **recursively** merges keys and values in each source hash. **For each key,** if the value is:

* **...only present in one** source hash, it goes into the final hash.
* ...a **string/number/boolean** and exists in two or more source hashes, the **highest priority** value goes into the final hash.
* ...an **array** and exists in two or more source hashes, the values from each source are **merged** into a single array and de-duplicated (but not automatically flattened, as in an array merge lookup).
* ...a **hash** and exists in two or more source hashes, the values from each source are **recursively merged,** as though they were source hashes.
* **...mismatched** between two or more source hashes, we haven't validated the behavior. It should act as described in the [`deep_merge` gem documentation][deepmerge].

In a `deep` hash merge, Hiera behaves as above, except that when a string/number/boolean exists in two or more source hashes, the **lowest priority** value goes into the final hash. As mentioned above, this is generally useless.

#### Example

 A typical use case
for hashes in Hiera is building a data structure which gets passed to the
`create_resources` function. This example implements business rules that say:

1. user 'jen' is defined only on the host 'deglitch'
2. user 'bob' is defined everywhere, but has a different uid on 'deglitch' than
   he receives on other hosts.
3. user 'ash' is defined everywhere with a consistent uid and shell.

In hiera.yaml, we set a two-level hierarchy:

~~~ yaml
    # /etc/puppetlabs/code/hiera.yaml
    ---
    :backends:
      - yaml
    :logger: puppet
    :hierarchy:
      - "%{hostname}"
      - common
    :yaml:
      :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
    # options are native, deep, deeper
    :merge_behavior: deeper
~~~

In common.yaml, we set up default users for all nodes:

~~~ yaml
    ---
    site_users:
      bob:
        uid: 501
        shell: /bin/bash
      ash:
        uid: 502
        shell: /bin/zsh
        group: common
~~~

In deglitch.yaml, we set up node-specific user details for the deglitch.example.com:

~~~ yaml
    ---
    site_users:
      jen:
        uid: 503
        shell: /bin/zsh
        group: deglitch
      bob:
        uid: 1000
        group: deglitch
~~~

With a standard `native` hash merge, we would end up with a hash like the following:

~~~ ruby
    {
      "bob"=>{
        group=>"deglitch",
        uid=>1000,
      },
      "jen"=>{
        group=>"deglitch",
        uid=>503
        shell=>"/bin/zsh",
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }
~~~

Notice that Bob is missing his shell --- this is because the value of the top-level `bob` key from common.yaml was replaced entirely.

With a `deeper` hash merge, we would get a more intuitive behavior:

~~~ ruby
    {
      "bob"=>{
        group=>"deglitch",
        uid=>1000,
        shell=>"/bin/bash"
      },
      "jen"=>{
        group=>"deglitch",
        uid=>503
        shell=>"/bin/zsh",
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }
~~~

In this case, Bob's shell persists from common.yaml, but deglitch.yaml is allowed to override his uid and group, reducing the amount of data you have to duplicate between files.

With a `deep` merge, you would get:

~~~ ruby
    {
      "bob"=>{
        group=>"deglitch",
        uid=>501,
        shell=>"/bin/bash"
      },
      "jen"=>{
        group=>"deglitch",
        shell=>"/bin/zsh",
        uid=>503
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }
~~~

In this case, deglitch.yaml was able to set the group because common.yaml didn't have a value for it, but where there was a conflict, like the uid, common won. Most users don't want this.

Unfortunately none of these merge behaviors work with data bindings for automatic parameter lookup, because there's no way to specify the lookup type. So instead of any of the above results, automatic data binding lookups only see results from `deglitch.yaml`. See [Bug HI-118](https://tickets.puppetlabs.com/browse/HI-118) to track progress on this.


