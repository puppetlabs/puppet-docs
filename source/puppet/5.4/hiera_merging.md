---
title: "Creating and editing data"
---

[lookup_command]: ./man/lookup.html
[automatic]: ./hiera_automatic.html
[data types]: ./lang_data.html
[interpolation_puppet]: ./lang_data_string.html#interpolation
[facts_hash]: ./lang_facts_and_builtin_vars.html#the-factsfactname-hash
[trusted]: ./lang_facts_and_builtin_vars.html#trusted-facts
[server_facts]: ./lang_facts_and_builtin_vars.html#serverfacts-variable
[environment]: ./environments.html

{:.task}
## Setting the merge behavior for a lookup

When you look up a key in Hiera, it is common for multiple data sources to have different values for it. By default, Hiera returns the first value it finds, but it can also continue searching and merge all the found values together.

1. You can set the merge behavior for a lookup in two ways:

	* At lookup time. This works with the `lookup` function, but does not support automatic class parameter lookup.
	* In Hiera data, with the `lookup_options` key. This works for both manual and automatic lookups. It also lets module authors set default behavior that users can override.

2. With both of these methods, specify a merge behavior as either a string, for example, `'first'` or a hash, for example `{'strategy' => 'first'}`. The hash syntax is useful for `deep` merges (where extra options are available), but it also works with the other merge types.

Related topics: [lookup][lookup_command], [automatic class parameter lookup][automatic].

{:.concept}
## Merge behaviors

There are four merge behaviors to choose from: `first`, `unique`, `hash`, and `deep`.
When specifying a merge behavior, use one of the following identifiers:

* `'first'`, `{'strategy' => 'first'}`, or nothing.
* `'unique'` or `{'strategy' => 'unique'}`.
* `'hash'` or `{'strategy' => 'hash'}`.
* `'deep'` or `{'strategy' => 'deep', <OPTION> => <VALUE>, ...}`. Valid options:
	* `'knockout_prefix'` - string or undef; default is `undef`
	* `'sort_merged_arrays'` - Boolean; default is `false`
	* `'merge_hash_arrays'` - boolean; default is `false`

### First

A first-found lookup doesn’t merge anything: it returns the first value found, and ignores the rest. This is Hiera’s default behavior.

Specify this merge behavior with one of these:
* `'first'`
* `{'strategy' => 'first'}`
* Nothing (since it’s the default)

### Unique

A unique merge (also called an array merge) combines any number of array and scalar (string, number, boolean) values to return a merged, flattened array with all duplicate values removed. The lookup fails if any of the values are hashes. The result is ordered from highest priority to lowest.

Specify this merge behavior with one of these:
* `'unique'`
* `{'strategy' => 'unique'}`

### Hash

A hash merge combines the keys and values of any number of hashes to return a merged hash. The lookup fails if any of the values aren’t hashes.

If multiple source hashes have a given key, Hiera uses the value from the highest priority data source: it won’t recursively merge the values.

Hashes in Puppet preserve the order in which their keys are written. When merging hashes, Hiera starts with the lowest priority data source. For each higher priority source, it appends new keys at the end of the hash and updates existing keys in place.

For example:

```
# web01.example.com.yaml
mykey:
  d: "per-node value"
  b: "per-node override"
# common.yaml
mykey:
  a: "common value"
  b: "default value"
  c: "other common value"


`lookup('mykey', {merge => 'hash'})
```

Returns the following:

```
{
  a => "common value",
  b => "per-node override", # Using value from the higher-priority source, but
                            # preserving the order of the lower-priority source.
  c => "other common value",
  d => "per-node value",
}
```

Specify this merge behavior with one of these:

* `'hash'`
* `{'strategy' => 'hash'}`

### Deep

A deep merge combines the keys and values of any number of hashes to return a merged hash. If the same key exists in multiple source hashes, Hiera recursively merges them:

* Hash values are merged with another deep merge.
* Array values are merged. This differs from the unique merge. The result is ordered from lowest priority to highest, which is the reverse of the unique merge’s ordering. The result isn’t flattened, so it can contain nested arrays. The `merge_hash_arrays` and `sort_merged_arrays` options can make further changes to the result.
* Scalar (String, Number, Boolean) values use the highest priority value, like in a first-found lookup.

Specify this merge behavior with one of these:

* `'deep'`
* `{'strategy' => 'deep', <OPTION> => <VALUE>, ...}` — Adjust the merge behavior with these additional options:
	* `'knockout_prefix'` (String or Undef) — A string prefix to indicate a value should be removed from the final result. Defaults to `undef`, which turns off this option.
	* `'sort_merged_arrays'` (Boolean) — Whether to sort all arrays that are merged together. Defaults to `false`.
	* `'merge_hash_arrays'` (Boolean) — Whether to deep-merge hashes within arrays, by position. For example, `[ {a => high}, {b => high} ]` and `[ {c => low}, {d => low} ]` would be merged as `[ {c => low, a => high}, {d => low, b => high} ]`. Defaults to `false`.

> Note: Unlike a hash merge, a deep merge can also accept arrays as the root values. It merges them with its normal array merging behavior, which differs from a unique merge as described above. This does not apply to the deprecated hiera 3 `hiera_hash` function, which can be configured to do deep merges but can’t accept arrays.

{:.task}
## Set merge behavior at lookup time

Use merge behaviour at lookup time to override preconfigured merge behavior for a key.

Use the `lookup` function or the `puppet lookup` command to provide a merge behavior as an argument or flag.

Function example:

```
# Merge several arrays of class names into one array:
lookup('classes', {merge => 'unique'})
```

Command line example:

`$ puppet lookup classes --merge unique --environment production --explain`


> Note that each of the deprecated `hiera_*` functions is locked to one particular merge behavior. (`hiera` only does first-found, `hiera_array` only does unique merge, etc.)

Related topics: [lookup][lookup_command], [puppet lookup][automatic]

{:.task}
## Configure merge behavior in Hiera data

Hiera uses a key’s configured merge behavior in any lookup that doesn’t explicitly override it.

In any Hiera data source, including module data:

1. Use the `lookup_options` key to configure merge behavior.

For example:

```
# <ENVIRONMENT>/data/common.yaml
lookup_options:
  ntp::servers:     # Name of key
    merge: unique   # Merge behavior as a string
  "^profile::(.*)::users$": # Regexp: `$users` parameter of any profile class
    merge:          # Merge behavior as a hash
      strategy: deep
      merge_hash_arrays: true
```

Hiera uses the configured merge behaviors for these keys.

> Note: the `hiera_*` functions always override configured merge behavior.

{:.reference}
## `lookup_options` format

The value of `lookup_options` is a hash.

It follows this format:

```
 lookup_options:
  <NAME or REGEXP>:
    merge: <MERGE BEHAVIOR>
```

Each key is either the full name of a lookup key (like `ntp::servers`) or a regular expression (like `'^profile::(.*)::users$'`). In a module’s data, you can configure lookup keys only within that module’s namespace:the ntp module can set options for `ntp::servers`, but the `apache` module can’t.

Each value is a hash with a `merge` key. A merge behavior can be a string or a hash.

`lookup_options` is a reserved key — you can’t put other kinds of data in it, and you can’t look it up directly. This is the only reserved key in Hiera.

### Overriding merge behavior

Any data source overrides individual `lookup_options` from a lower priority source. As Hiera uses a hash merge on the `lookup_options` values, module authors can configure a default merge behavior for a given key and end users can override it.

When you specify a merge behavior as an argument to the `lookup` function, it overrides the configured merge behavior.

{:.task}
## Use a regular expression in `lookup_options`

You can use regular expressions in `lookup_options` to configure merge behavior for many lookup keys at once.

A regular expression key such as `'^profile::(.*)::users$'` sets the merge behavior for `profile::server::users, profile::postgresql::users`, `profile::jenkins::master::users`. Regular expression lookup options use Puppet’s regular expression support, which is based on Ruby’s regular expressions.

To use a regular expression in `lookup_options`:

1. Write the pattern as a quoted string. Do not use the Puppet language’s forward-slash (`/.../`) regular expression delimiters.
2. Begin the pattern with the start-of-line metacharacter (`^`, also called a carat). If `^` isn’t the first character, Hiera treats it as a literal key name instead of a regular expression.
3. If this data source is in a module, follow ^ with the module’s namespace: its full name, plus the `::` namespace separator.
For example, all regular expression lookup options in the `ntp` module must start with `^ntp::`. Starting with anything else results in an error.

The merge behavior you set for that pattern applies to all lookup keys that match it. In cases where multiple lookup options could apply to the same key, Hiera resolves the conflict. For example, if there’s a literal (not regular expression) option available, Hiera uses it. Otherwise, Hiera uses the first regular expression that matches the lookup key, using the order in which they appear in the module code.

> Note: `lookup_options` are assembled with a hash merge, which puts keys from lower priority data sources before those from higher priority sources. To override a module’s regular expression configured merge behavior, use the exact same regular expression string in your environment data, so that it replaces the module’s value. A slightly different regular expression won’t work because the lower-priority regular expression goes first.

{:.concept}
## Interpolation

In Hiera you can insert, or interpolate, the value of a variable into a string, using the syntax `%{variable}`.

Hiera uses interpolation in two places:

* Hierarchies: you can interpolate variables into the `path`, `glob`, `uri`, `datadir`, `mapped_paths` and `options` of a hierarchy level. This lets each node get a customized version of the hierarchy.
* Data: you can use interpolation to avoid repetition. This takes one of two forms:
	* If some value always involves the value of a fact (for example, if you need to specify a mail server and you have one predictably-named mail server per domain), reference the fact directly instead of manually transcribing it.
	* If multiple keys need to share the same value, write it out for one of them and reuse it for the rest with the `lookup` or `alias` interpolation functions. This make it easier to keep data up to date, as you only need to change a given value in one place.

{:.reference}
## Interpolation token syntax

Interpolation tokens consist of:
* A percent sign (`%`).
* An opening curly brace (`{`).
* One of:
	* A variable name, optionally using key.subkey notation to access a specific member of a hash or array.
	* An interpolation function and its argument.
* A closing curly brace (`}`).

For example,  `%{trusted.certname}` or `%{alias("users")}`.

Hiera interpolates values of Puppet data types and converts them to strings. Note that the exception to this is when using an alias. If the alias is the only thing present, then it's value is not converted.

In YAML files, any string containing an interpolation token must be enclosed in quotation marks.

> Note: Unlike the Puppet interpolation tokens, you can’t interpolate an arbitrary expression.

Related topics: [Puppet’s data types][data types], [Puppet’s rules for interpolating non-string values][interpolation_puppet].

{:.task}
## Interpolate a Puppet variable

The most common thing to interpolate is the value of a Puppet top scope variable.

1. Use the name of the variable, omitting the leading dollar sign (`$`).Use the Hiera key.subkey notation to access a member of a data structure. For example, to interpolate the value of `$facts['networking']['domain']` write:
`smtpserver: "mail.%{facts.networking.domain}"`

Related topics: [Hiera key.subkey notation][automatic].

{:.concept}
## Interpolating variables

The `facts` hash, `trusted` hash, and `server_facts` hash are the most useful variables to Hiera and behave predictably.

> Note: If you have  a hierarchy level that needs to reference  the name of a node, get the  node’s name by using `trusted.certname`. To reference a node’s environment, use `server_facts.environment`.

Avoid using local variables, namespaced variables from classes (unless the class has already been evaluated), and Hiera-specific pseudo-variables (pseudo-variables are not supported in Hiera 5).

If you are using hiera 3 pseudo-variables, see Puppet variables passed to Hiera.

### classic `::<fact_name>` facts

Puppet makes facts available in two ways: grouped together in the `facts` hash ( `$facts['networking']`), and individually as top-scope variables ( `$networking`).

When you use individual fact variables, specify the (empty) top-scope namespace for them, like this:

* `%{::networking}`.

Not like this:

* `%{networking}`.

> Note: The individual fact names aren’t protected the way `$facts` is, and local scopes can set unrelated variables with the same names. In most of Puppet, you don’t have to worry about unknown scopes overriding your variables, but in Hiera you do.

Related topics: [facts][facts_hash], [trusted][trusted], [server_facts][server_facts], [environment][environment].

{:.concept}
## Interpolation functions

In Hiera data sources, you can use interpolation functions to insert non-variable values. These aren’t the same as Puppet functions; they’re only available in Hiera interpolation tokens.

> Note: you cannot use interpolation functions in `hiera.yaml`. They’re only for use in data sources.

There are five interpolation functions:
* `lookup` - looks up a key using Hiera, and interpolates the value into a string.
* `hiera` - a synonym for `lookup`.
* `alias` - looks up a key using Hiera, and uses the value as a replacement for the enclosing string. The result has the same data type as what the aliased key has - no conversion to string takes place if the value is exactly one alias.
* `literal` —-a way to write a literal percent sign (`%`) without accidentally interpolating something.
* `scope` - an alternate way to interpolate a variable. Not generally useful.

### `lookup` and `hiera`

The `lookup` and `hiera` interpolation functions look up a key and return the resulting value. The result of the lookup must be a string; any other result causes an error.

This is useful in the Hiera data sources. If you need to use the same value for multiple keys, you can assign the literal value to one key, then call lookup to reuse the value elsewhere. You can edit the value once to change it everywhere it’s used.

For example, suppose your WordPress profile needs a database server, and you’re already configuring that hostname in data because the MySQL profile needs it. You could write:

```
# in location/pdx.yaml:
profile::mysql::public_hostname: db-server-01.pdx.example.com

# in location/bfs.yaml:
profile::mysql::public_hostname: db-server-06.belfast.example.com

# in common.yaml:
profile::wordpress::database_server: "%{lookup('profile::mysql::public_hostname')}"
```

The value of `profile::wordpress::database_server` is always the same as `profile::mysql::public_hostname`. Even though you wrote the WordPress parameter in the  `common.yaml` data, it’s location-specific, as the value it references was set in your per-location data files.

The value referenced by the lookup function can contain another call to lookup; if you accidentally make an infinite loop, Hiera detects it and fails.

> Note: the lookup and hiera interpolation functions aren’t the same as the Puppet functions of the same names. They only take a single argument.

### `alias`

The  `alias` function lets you use reuse Hash, Array, or Boolean values. When you interpolate  `alias` in a string, Hiera replaces that entire string with the aliased value, using its original data type. For example:

```
original:
  - 'one'
  - 'two'
aliased: "%{alias('original')}"
```

A lookup of original and a lookup of aliased would both return the value `['one', 'two']`.

When you use the `alias` function, its interpolation token must be the only text in that string. For example, the following would be an error:

`aliased: "%{alias('original')} - 'three'"`

> Note: A lookup resulting in an interpolation of `alias` referencing a non-existant key will return an empty string, not a Hiera "not found" condition.

### `literal`

The `literal` interpolation function lets you escape a literal percent sign (`%`) in Hiera data, to avoid triggering interpolation where it isn’t wanted. This is useful when dealing with Apache config files, for example, which might include text such as `%{SERVER_NAME}`.

For example:

`server_name_string: "%{literal('%')}{SERVER_NAME}"`

The value of `server_name_string` would be `%{SERVER_NAME}`, and Hiera would not attempt to interpolate a variable named `SERVER_NAME`.

The only legal argument for `literal` is a single `%` sign.

### `scope`

The `scope` interpolation function interpolates variables. It works identically to variable interpolation. The function’s argument is the name of a variable.

The following two values would be identical:

```
smtpserver: "mail.%{facts.domain}"
smtpserver: "mail.%{scope('facts.domain')}"
```

Related topics: [lookup][lookup_command].

{:.task}
## Use interpolation functions

Use an interpolation function to insert non-variable values.

To use an interpolation function, write:

1. The name of the function.
2. An opening parenthesis
3. One argument to the function, enclosed in single or double quotation marks.
4. Use the opposite of what the enclosing string uses: if it uses single quotation marks, use double quotation marks.
5. A closing parenthesis.

For example:

`wordpress::database_server: "%{lookup('instances::mysql::public_hostname')}"`

> Note: There must be no spaces between these elements.
