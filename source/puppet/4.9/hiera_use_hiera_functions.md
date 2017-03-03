---
title: "Hiera: Using the deprecated hiera functions"
---

hiera
-----
Performs a standard priority lookup of the hierarchy and returns the most specific value
for a given key. The returned value can be any type of data.

The function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

The `hiera` function does **not** find all matches throughout a hierarchy, instead
returining the first specific value starting at the top of the hierarchy. To search
throughout a hierarchy, use the `hiera_array` or `hiera_hash` functions.

**Example**: Using `hiera`

~~~ yaml
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
~~~

~~~ puppet
# Assuming we are not web01.example.com:

$users = hiera('users', undef)

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera` with a lambda

~~~ puppet
# Assuming the same Hiera data as the previous example:

$users = hiera('users') | $key | { "Key '${key}' not found" }

# $users contains {admins  => ["Edith Franklin", "Ginny Hamilton"],
#                  regular => ["Iris Jackson", "Kelly Lambert"]}
# If hiera couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

The returned value's data type depends on the types of the results. In the example
above, Hiera matches the 'users' key and returns it as a hash.

The `hiera` function is deprecated in favor of using `lookup` and will be removed in 6.0.0.
See  https://docs.puppet.com/puppet/4.9.0/reference/deprecated_language.html.
Replace the calls as follows:

| from  | to |
| ----  | ---|
| hiera($key) | lookup($key) |
| hiera($key, $default) | lookup($key, { 'default_value' => $default }) |
| hiera($key, $default, $level) | override level not supported |

Note that calls using the 'override level' option are not directly supported by 'lookup' and the produced
result must be post processed to get exactly the same result, for example using simple hash/array `+` or
with calls to stdlib's `deep_merge` function depending on kind of hiera call and setting of merge in hiera.yaml.

See
[the documentation](https://docs.puppetlabs.com/hiera/latest/puppet.html#hiera-lookup-functions)
for more information about Hiera lookup functions.

- Since 4.0.0

- *Type*: rvalue

hiera_array
-----------
Finds all matches of a key throughout the hierarchy and returns them as a single flattened
array of unique values. If any of the matched values are arrays, they're flattened and
included in the results. This is called an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge).

The `hiera_array` function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

**Example**: Using `hiera_array`

~~~ yaml
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
~~~

~~~ puppet
$allusers = hiera_array('users', undef)

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_array` with a lambda

~~~ puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_array('users') | $key | { "Key '${key}' not found" }

# $allusers contains ["cdouglas = regular", "efranklin = regular", "abarry = admin"].
# If hiera_array couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

`hiera_array` expects that all values returned will be strings or arrays. If any matched
value is a hash, Puppet raises a type mismatch error.

`hiera_array` is deprecated in favor of using `lookup` and will be removed in 6.0.0.
See  https://docs.puppet.com/puppet/4.9.0/reference/deprecated_language.html.
Replace the calls as follows:

| from  | to |
| ----  | ---|
| hiera_array($key) | lookup($key, { 'merge' => 'unique' }) |
| hiera_array($key, $default) | lookup($key, { 'default_value' => $default, 'merge' => 'unique' }) |
| hiera_array($key, $default, $level) | override level not supported |

Note that calls using the 'override level' option are not directly supported by 'lookup' and the produced
result must be post processed to get exactly the same result, for example using simple hash/array `+` or
with calls to stdlib's `deep_merge` function depending on kind of hiera call and setting of merge in hiera.yaml.

See
[the documentation](https://docs.puppetlabs.com/hiera/latest/puppet.html#hiera-lookup-functions)
for more information about Hiera lookup functions.

- Since 4.0.0

- *Type*: rvalue

hiera_hash
----------
Finds all matches of a key throughout the hierarchy and returns them in a merged hash.
If any of the matched hashes share keys, the final hash uses the value from the
highest priority match. This is called a
[hash merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#hash-merge).

The merge strategy is determined by Hiera's
[`:merge_behavior`](https://docs.puppetlabs.com/hiera/latest/configuring.html#mergebehavior)
setting.

The `hiera_hash` function takes up to three arguments, in this order:

1. A string key that Hiera searches for in the hierarchy. **Required**.
2. An optional default value to return if Hiera doesn't find anything matching the key.
    * If this argument isn't provided and this function results in a lookup failure, Puppet
    fails with a compilation error.
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

**Example**: Using `hiera_hash`

~~~ yaml
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
~~~

~~~ puppet
# Assuming we are not web01.example.com:

$allusers = hiera_hash('users', undef)

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_hash` with a lambda

~~~ puppet
# Assuming the same Hiera data as the previous example:

$allusers = hiera_hash('users') | $key | { "Key '${key}' not found" }

# $allusers contains {regular => {"cdouglas" => "Carrie Douglas"},
#                     administrators => {"aberry" => "Amy Berry"}}
# If hiera_hash couldn't match its key, it would return the lambda result,
# "Key 'users' not found".
~~~

`hiera_hash` expects that all values returned will be hashes. If any of the values
found in the data sources are strings or arrays, Puppet raises a type mismatch error.

`hiera_hash` is deprecated in favor of using `lookup` and will be removed in 6.0.0.
See  https://docs.puppet.com/puppet/4.9.0/reference/deprecated_language.html.
Replace the calls as follows:

| from  | to |
| ----  | ---|
| hiera_hash($key) | lookup($key, { 'merge' => 'hash' }) |
| hiera_hash($key, $default) | lookup($key, { 'default_value' => $default, 'merge' => 'hash' }) |
| hiera_hash($key, $default, $level) | override level not supported |

Note that calls using the 'override level' option are not directly supported by 'lookup' and the produced
result must be post processed to get exactly the same result, for example using simple hash/array `+` or
with calls to stdlib's `deep_merge` function depending on kind of hiera call and setting of merge in hiera.yaml.

See
[the documentation](https://docs.puppetlabs.com/hiera/latest/puppet.html#hiera-lookup-functions)
for more information about Hiera lookup functions.

- Since 4.0.0

- *Type*: rvalue

hiera_include
-------------
Assigns classes to a node using an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge)
that retrieves the value for a user-specified key from Hiera's data.

The `hiera_include` function requires:

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
3. The optional name of an arbitrary
[hierarchy level](https://docs.puppetlabs.com/hiera/latest/hierarchy.html) to insert at the
top of the hierarchy. This lets you temporarily modify the hierarchy for a single lookup.
    * If Hiera doesn't find a matching key in the overriding hierarchy level, it continues
    searching the rest of the hierarchy.

The function uses an
[array merge lookup](https://docs.puppetlabs.com/hiera/latest/lookup_types.html#array-merge)
to retrieve the `classes` array, so every node gets every class from the hierarchy.

**Example**: Using `hiera_include`

~~~ yaml
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
~~~

~~~ puppet
# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes', undef)

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
~~~

You can optionally generate the default value with a
[lambda](https://docs.puppetlabs.com/puppet/latest/reference/lang_lambdas.html) that
takes one parameter.

**Example**: Using `hiera_include` with a lambda

~~~ puppet
# Assuming the same Hiera data as the previous example:

# In site.pp, outside of any node definitions and below any top-scope variables:
hiera_include('classes') | $key | {"Key '${key}' not found" }

# Puppet assigns the apache and apache::mod::php classes to the web01.example.com node.
# If hiera_include couldn't match its key, it would return the lambda result,
# "Key 'classes' not found".
~~~

`hiera_include` is deprecated in favor of using a combination of `include`and `lookup` and will be
removed in 6.0.0. See  https://docs.puppet.com/puppet/4.9.0/reference/deprecated_language.html.
Replace the calls as follows:

| from  | to |
| ----  | ---|
| hiera_include($key) | include(lookup($key, { 'merge' => 'unique' })) |
| hiera_include($key, $default) | include(lookup($key, { 'default_value' => $default, 'merge' => 'unique' })) |
| hiera_include($key, $default, $level) | override level not supported |

Note that calls using the 'override level' option are not directly supported by 'lookup' and the produced
result must be post processed to get exactly the same result, for example using simple hash/array `+` or
with calls to stdlib's `deep_merge` function depending on kind of hiera call and setting of merge in hiera.yaml.

See [the documentation](http://links.puppetlabs.com/hierainclude) for more information
and a more detailed example of how `hiera_include` uses array merge lookups to classify
nodes.

- Since 4.0.0

- *Type*: statement
