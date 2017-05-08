---
title: "Hiera: Interpolating variables and other values"
---


[interpolation_puppet]: ./lang_data_string.html#interpolation
[variables]: ./lang_variables.html
[hierarchy]: ./hiera_hierarchy.html
[hiera.yaml]: ./hiera_config_yaml_5.html
[facts]: ./lang_facts_and_builtin_vars.html
[data types]: ./lang_data.html
[subkey]: ./hiera_subkey.html
[facts_hash]: ./lang_facts_and_builtin_vars.html#the-factsfactname-hash
[trusted]: ./lang_facts_and_builtin_vars.html#trusted-facts
[server_facts]: ./lang_facts_and_builtin_vars.html#serverfacts-variable
[v3]: ./hiera_config_yaml_3.html
[v5]: ./hiera_config_yaml_5.html
[environment]: ./environments.html

In several places in Hiera, you can insert the value of a [variable][variables] into a string.

This is a lot like [Puppet's expression interpolation][interpolation_puppet], but it uses a different syntax --- `%{variable}`, instead of `${expression}`.

## Where Hiera uses interpolation

Hiera uses interpolation in two places: [hierarchies][hierarchy] and data.

* In a [hierarchy][], you can interpolate variables into the `path(s)`, `glob(s)`, `uri(s)`, and `options` of a hierarchy level. This lets each node get a customized version of the hierarchy. For a deeper explanation, see [How hierarchies work][hierarchy] and the [hiera.yaml syntax reference][hiera.yaml].
* In data sources, you can use interpolation to avoid repeating yourself. This usually takes one of two forms:
    * If some value always involves the value of a [fact][facts] (for example, if you need to specify a mail server and you have one predictably-named mail server per domain), you can reference the fact directly instead of manually transcribing it.
    * If multiple keys need to share the same value, you can write it out for one of them and re-use it for the rest with the `lookup` or `alias` interpolation functions. This can make it easier to keep data up to date, since you only need to change a given value in one place.


## Interpolation token syntax

**Interpolation tokens** look like `%{trusted.certname}` or `%{alias("users")}`. That is, they consist of:

* A percent sign (`%`).
* An opening curly brace (`{`).
* One of:
    * A variable name, optionally using [key.subkey notation][subkey] to access a specific member of a hash or array.
    * An interpolation function ([see below][inpage_functions]) and its argument.
* A closing curly brace (`}`).

> **Note:** Unlike Puppet's interpolation tokens, you can't interpolate an arbitrary expression. Hiera's not a programming language, so its interpolation features are more limited.

Hiera can interpolate values of any of [Puppet's data types][data types], and converts them to strings if necessary. For arrays and hashes, this doesn't fully match [Puppet's rules for interpolating non-string values][interpolation_puppet], but it's close.

In YAML files, **any string containing an interpolation token must be quoted.** (YAML syntax allows you to be lazy with quoting for simple strings, but strings with interpolation aren't simple.)

## Interpolating variables

The most common thing to interpolate is the value of a [Puppet variable][variables]. To do so, use the name of the variable, omitting the leading dollar sign (`$`).

Since the most useful variables are all hashes, you'll usually use [Hiera's key.subkey notation][subkey] to access a member of a data structure. For example, to interpolate the value of `$facts['networking']['domain']`:

``` yaml
smtpserver: "mail.%{facts.networking.domain}"
```

### Which variables should you use?

Most people should only use the following variables:

* [The `facts` hash][facts_hash]
* [The `trusted` hash][trusted]
* [The `server_facts` hash][server_facts]

These three hashes have all the information that's most useful to Hiera. They also behave very predictably, which makes them the easiest to work with.

> **Tip:** Most people need a hierarchy level that references the name of a node. The best way to get a node's name is with `trusted.certname`. If you need to reference a node's [environment][], use `server_facts.environment`.

#### Avoid local variables

Technically, Hiera can also access any Puppet variables that are visible _in the scope in which the lookup occurs._ This includes local variables, and namespaced variables from classes (as long as the class in question has already been evaluated at the time the lookup occurs).

But don't do that!

* It's hard to predict how local variables interact with Hiera, and using them tends to entangle your code and data in an unhealthy, hard-to-maintain way.
* If you use local variables in the [hierarchy][], it can make Hiera lookups significantly slower.

You will have a much better time if you limit yourself to the three protected variables listed above.

#### What about classic `::fact_name` facts?

Puppet makes facts available in two ways: grouped together in the `facts` hash (like `$facts['networking']`), and individually as top-scope variables (like `$networking`).

You can use the individual fact variables in Hiera, but **you must specify the (empty) top-scope namespace for them:**

* Good: `%{::networking}`.
* Bad: `%{networking}`.

This is because the individual fact names aren't protected the way `$facts` is, and local scopes can set unrelated variables with the same names. In most of Puppet, you don't have to worry about unknown scopes overriding your variables, but in Hiera you do. So you might as well just use the `facts` hash instead.

#### What about the old Hiera-specific pseudo-variables?

They're mostly gone. Don't use them.

Puppet used to set three extra variables (`calling_module`, `calling_class`, and `calling_class_path`) when doing lookups with Hiera 3 and earlier. You can still use these in a global [version 3 hiera.yaml file][v3], but you can't use them in a [version 5 hiera.yaml][v5] or in data files.

These variables were a workaround for the lack of a module data layer. Since there's a real module layer now, you should no longer need them.

## Using interpolation functions

[inpage_functions]: #using-interpolation-functions

In Hiera's data sources, you can use several special functions to insert non-variable values. These aren't the same as Puppet functions; they're only available in Hiera's interpolation tokens.

> **Important:** You cannot use interpolation functions in hiera.yaml. They're only for use in data sources.

To use an interpolation function, write:

* The name of the function.
* An opening parenthesis.
* One argument to the function, enclosed in single or double quotes.
    * Note which kind of quotes the enclosing string uses, and use the opposite here. This ensures the internal quotes don't prematurely terminate the string.
* A closing parenthesis.

For example:

``` yaml
wordpress::database_server: "%{lookup('instances::mysql::public_hostname')}"
```

Note that there must be **no spaces** between these elements. The syntax for Hiera interpolation isn't as flexible as the Puppet language.

There are five interpolation functions:

* [`lookup`][inpage_lookup] --- looks up a key using Hiera, and interpolates the value into a string.
* [`hiera`][inpage_lookup] --- a synonym for `lookup`.
* [`alias`][inpage_alias] --- looks up a key using Hiera, and uses the value as a _replacement_ for the enclosing string.
* [`literal`][inpage_literal] --- a way to write a literal percent sign (`%`) without accidentally interpolating something.
* [`scope`][inpage_scope] --- an alternate way to interpolate a variable. Not generally useful.

### `lookup` / `hiera`

[inpage_lookup]: #lookup--hiera

The `lookup` and `hiera` interpolation functions do the same thing: they look up a key with Hiera and return the resulting value. The result of the lookup must be a string; any other result causes an error.

This can be useful in Hiera's data sources. If you need to use the same value for multiple keys, you can assign the literal value to one key, then call `lookup` to re-use the value elsewhere. This way, you can edit the value once to change it everywhere it's used.

For example, say your WordPress profile needs a database server, but you're already configuring that hostname in data because the MySQL profile needs it. You could write something like:

``` yaml
# in location/pdx.yaml:
profile::mysql::public_hostname: db-server-01.pdx.example.com

# in location/bfs.yaml:
profile::mysql::public_hostname: db-server-06.belfast.example.com

# in common.yaml:
profile::wordpress::database_server: "%{lookup('profile::mysql::public_hostname')}"
```

This way, the value of `profile::wordpress::database_server` is always the same as `profile::mysql::public_hostname`. And even though you wrote the WordPress parameter in the `common.yaml` data, it's still location-specific, since the value it references was set in your per-location data files.

The value referenced by the `lookup` function can contain another call to `lookup`; if you accidentally make an infinite loop, Hiera detects it and fails instead of hanging indefinitely.

Note that the `lookup` and `hiera` interpolation functions aren't the same as the Puppet functions of the same names. Most notably, they only take a single argument.

### `alias`

[inpage_alias]: #alias

The `lookup` interpolation function is only useful for strings; the `alias` function lets you use re-use hash, array, or boolean values. When you interpolate `alias` in a string, Hiera replaces that entire string with the aliased value, using its original data type. For example:

``` yaml
original:
  - 'one'
  - 'two'
aliased: "%{alias('original')}"
```

A lookup of `original` and a lookup of `aliased` would both return the value `['one', 'two']`.

When you use the `alias` function, its interpolation token must be the **only** text in that string. For example, the following would be an error:

``` yaml
aliased: "%{alias('original')} - 'three'"
```

### `literal`

[inpage_literal]: #literal

The `literal` interpolation function lets you escape a literal percent sign (`%`) in Hiera data, to avoid triggering interpolation where it isn't wanted. This is useful when you're dealing with things like Apache config files, which might include text like `%{SERVER_NAME}`.

For example:

``` yaml
server_name_string: "%{literal('%')}{SERVER_NAME}"
```

The value of `server_name_string` would be `%{SERVER_NAME}`, and Hiera would not attempt to interpolate a variable named `SERVER_NAME`.

The only legal argument for `literal` is a single `%` sign.

### `scope`

[inpage_scope]: #scope

The `scope` interpolation function interpolates variables; it works identically to variable interpolation as described above. The function's argument is the name of a variable.

The following two values would be identical:

``` yaml
smtpserver: "mail.%{facts.domain}"
smtpserver: "mail.%{scope('facts.domain')}"
```

