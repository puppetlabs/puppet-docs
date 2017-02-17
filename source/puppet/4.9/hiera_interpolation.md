---
title: "Hiera: Interpolating variables and other values"
---


[interpolation_puppet]: ./lang_data_string.html#interpolation
[variables]: todo
[hierarchy]: todo
[hiera.yaml]: todo
[facts]: todo
[inpage_functions]: todo
[data types]: todo
[subkey]: todo
[facts_hash]: todo
[trusted]: todo
[server_facts]: todo
[v3]: todo
[v5]: todo
[environment]: todo

In several places in Hiera, you can interpolate the value of a [variable][variables] or a secondary Hiera lookup into a string.

This is a lot like [Puppet's expression interpolation][interpolation_puppet], but it uses a different syntax --- `%{variable}`, instead of `${expression}`.

## Where Hiera uses interpolation

Hiera uses interpolation in two places: [hierarchies][hierarchy] and data.

* In a [hierarchy][], you can interpolate values into the `path(s)`, `glob(s)`, `uri(s)`, and `options` of a hierarchy level. This lets each node get a customized version of the hierarchy. For a deeper explanation, see [How hierarchies work][hierarchy] and the [hiera.yaml syntax reference][hiera.yaml].
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

Hiera can interpolate values of any of [Puppet's data types][data types], but will convert them to strings if necessary. For arrays and hashes, this won't fully match [Puppet's rules for interpolating non-string values][interpolation_puppet], but it will be close.

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

But don't do that! It's hard to predict how local variables interact with Hiera, and using them tends to entangle your code and data in an unhealthy, hard-to-maintain way. There might be rare cases where it's necessary, but you're going to have a much better time if you limit yourself to the three protected variables listed above.

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

Hiera's interpolation tokens support a few special functions, which can insert non-variable values.

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
* [`scope`][inpage_scope] --- an alternate way to interpolate a variable. Most people don't need this.

### `lookup` / `hiera`

[inpage_lookup]: #lookup--hiera

The `lookup` interpolation function does a Hiera lookup, using its input as the lookup key. The result of the lookup must be a string; any other result causes an error. The `hiera` interpolation function is an alias for `lookup`.

This can be very powerful in Hiera's data sources. By storing a fragment of data in one place and then using sub-lookups elsewhere, you can avoid repetition and make it easier to change your data.

``` yaml
wordpress::database_server: "%{lookup('instances::mysql::public_hostname')}"
```

The value referenced by the `lookup` function might contain another call to `lookup`, and that's fine; if you accidentally make an infinite loop, Hiera will detect it and fail instead of hanging indefinitely.

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

