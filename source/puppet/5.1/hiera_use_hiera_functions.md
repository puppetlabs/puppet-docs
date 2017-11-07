---
title: "Hiera: Using the deprecated hiera functions"
---

[illegal_overrides]: ./hiera_migrate_environments.html#step-1-check-for-illegal-hierarchy-overrides
[v3_merge_behavior]: ./hiera_config_yaml_3.html#mergebehavior
[automatic]: ./hiera_automatic.html
[lookup_function]: ./hiera_use_function.html
[migrate_functions]: ./hiera_migrate_functions.html
[lookup_options]: ./hiera_merging.html#configuring-merge-behavior-in-hiera-data
[first]: ./hiera_merging.html#first
[unique]: ./hiera_merging.html#unique
[hash]: ./hiera_merging.html#hash
[deep]: ./hiera_merging.html#deep
[environment layer]: ./hiera_layers.html#the-environment-layer
[global layer]: ./hiera_layers.html#the-global-layer
[v3]: ./hiera_config_yaml_3.html
[include]: ./lang_classes.html#using-include


The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions are Hiera's classic interface; they predate [automatic class parameter lookup][automatic] and [the `lookup` function][lookup_function].

Those newer interfaces are better, so the classic functions are now deprecated. They'll be removed in Puppet 6.

For info about updating uses of the `hiera_*` functions to use `lookup`, see [Update classic hiera function calls][migrate_functions].

> **Note:** These classic functions cannot use [configured merge behavior (`lookup_options`)][lookup_options], because each one is dedicated to one particular merge behavior. (`hiera_array` always does a unique merge, etc.)


## `hiera`

Does a [first-found lookup][first].

`hiera` takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. **(Deprecated)** The optional name of an arbitrary
hierarchy level to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

> **Important:** If the [environment layer][] is enabled, Hiera 5 does not support the third argument to this function, and raises an error if it is present. See [Enable the environment layer][illegal_overrides] for more details.

**Example**: Using `hiera`

``` yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming web01.example.com.yaml:
# users:
#   - "Amy Barry"
#   - "Carrie Douglas"

# Assuming common.yaml:
users:
  admins:
    - "Edith Franklin"
    - "Ginny Hamilton"
  regular:
    - "Iris Jackson"
    - "Kelly Lambert"
```

``` puppet
# Assuming we are not web01.example.com:

$users = hiera('users', undef)

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
```

You can optionally generate the default value with a
[lambda](./lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera` with a lambda

``` puppet
# Assuming the same Hiera data as the previous example:

$users = hiera('users') | $key | { "Key '${key}' not found" }

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
# If hiera couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
```


## `hiera_array`

Does a [unique merge][unique] lookup.

`hiera_array` takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. **(Deprecated)** The optional name of an arbitrary
hierarchy level to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

> **Important:** If the [environment layer][] is enabled, Hiera 5 does not support the third argument to this function, and raises an error if it is present. See [Enable the environment layer][illegal_overrides] for more details.


**Example**: Using `hiera_array`

``` yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming common.yaml:
# users:
#   - 'cdouglas = regular'
#   - 'efranklin = regular'

# Assuming web01.example.com.yaml:
# users: 'abarry = admin'
```

``` puppet
$allusers = hiera_array('users', undef)

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
```

You can optionally generate the default value with a
[lambda](./lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_array` with a lambda

``` puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_array('users') | $key | { "Key '${key}' not found" }

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
# If hiera_array couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
```

`hiera_array` expects that all values returned will be strings or arrays. If any matched
value is a hash, Puppet raises a type mismatch error.


## `hiera_hash`

Normally does a [hash merge][hash] lookup. However, if the [global layer][] uses a [version 3 hiera.yaml][v3] file and its [`:merge_behavior`][v3_merge_behavior] setting is set to `deeper`, this function does a [deep merge][deep] lookup instead. (Note that the `:merge_behavior` setting only affects `hiera_hash`; it does not affect automatic class parameter lookup, the `lookup` function, or the `puppet lookup` command.)

The `hiera_hash` function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. **(Deprecated)** The optional name of an arbitrary
hierarchy level to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

> **Important:** If the [environment layer][] is enabled, Hiera 5 does not support the third argument to this function, and raises an error if it is present. See [Enable the environment layer][illegal_overrides] for more details.

**Example**: Using `hiera_hash`

``` yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming common.yaml:
# users:
#   regular:
#     'cdouglas': 'Carrie Douglas'

# Assuming web01.example.com.yaml:
# users:
#   administrators:
#     'aberry': 'Amy Berry'
```

``` puppet
# Assuming we are not web01.example.com:

$allusers = hiera_hash('users', undef)

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
```

You can optionally generate the default value with a
[lambda](./lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_hash` with a lambda

``` puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_hash('users') | $key | { "Key '${key}' not found" }

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
# If hiera_hash couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
```

`hiera_hash` expects that all values returned will be hashes. If any of the values
found in the data sources are strings or arrays, Puppet raises a type mismatch error.


## `hiera_include`

Does a [unique merge][unique] lookup for the requested key, then calls [the `include` function][include] on the resulting array.

`hiera_include` requires:

- A string key name to use for classes.
- A call to this function (i.e. `hiera_include('classes')`) in your environment's
`sites.pp` manifest, outside of any node definitions and below any top-scope variables
that Hiera uses in lookups.
- `classes` keys in the appropriate Hiera data sources, with an array for each
`classes` key and each value of the array containing the name of a class.

The function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. **(Deprecated)** The optional name of an arbitrary
hierarchy level to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

> **Important:** If the [environment layer][] is enabled, Hiera 5 does not support the third argument to this function, and raises an error if it is present. See [Enable the environment layer][illegal_overrides] for more details.


**Example**: Using `hiera_include`

``` yaml
# Assuming hiera.yaml
# :hierarchy:
#   - web01.example.com
#   - common

# Assuming web01.example.com.yaml:
# classes:
#   - apache::mod::php

# Assuming common.yaml:
# classes:
#   - apache
```

``` puppet
# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes', undef)

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
```

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_include` with a lambda

``` puppet
# Assuming the same Hiera data as the previous example:

# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes') | $key | {"Key '${key}' not found" }

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
# If hiera_include couldn't match its key, it would return the lambda result,
# "Key 'classes' not found".
```

