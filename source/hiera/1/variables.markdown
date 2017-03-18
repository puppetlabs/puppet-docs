---
layout: default
title: "Hiera 1: Interpolation Tokens, Variables, and Lookup Functions"
---

[config]: ./configuring.html
[data]: ./data_sources.html
[puppet_vars]: /puppet/latest/reference/lang_variables.html
[qualified_var]: /puppet/latest/reference/lang_variables.html#naming
[built_in_vars]: /puppet/latest/reference/lang_variables.html#facts-and-built-in-variables
[command_line]: ./command_line.html
[hierarchy]: ./hierarchy.html

{% partial /hiera/_hiera_update.md %}

When writing Hiera's [settings][config] and [data][], you can instruct it to look up values at run-time and insert them into strings. This lets you make dynamic data sources in the [hierarchy][], and avoid repeating yourself when writing data.


Interpolation Tokens
-----

**Interpolation tokens** look like `%{variable}` or `%{function("input")}`. That is, they consist of:

* A percent sign (`%`)
* An opening curly brace (`{`)
* One of:
    * A variable name
    * A lookup function and its input _(Hiera 1.3 and later)_
* A closing curly brace

If any [setting in the config file][config] or [value in a data source][data] contains an interpolation token, Hiera will replace the token with the value it refers to at run time.

> **Notes:**
>
> * Hiera can only interpolate variables whose values are **strings.** (**Numbers** from Puppet are also passed as strings and can be used safely.) You cannot interpolate variables whose values are booleans, numbers not from Puppet, arrays, hashes, resource references, or an explicit `undef` value.
> * Additionally, Hiera cannot interpolate an individual **element** of any array or hash, even if that element's value is a string.
> * In YAML files, **any string containing an interpolation token must be quoted** in order to comply with the YAML spec. (Under Ruby 1.8, interpolation tokens in unquoted strings will sometimes work anyway, but this can't be relied on.)

### Interpolating Normal Variables

Hiera receives a set of variables whenever it is invoked, and it can insert them by name into any string. This is the default behavior; if the content of the interpolation token doesn't match one of the lookup functions listed below, Hiera will treat it as a variable name.

    smtpserver: "mail.%{::domain}"

See ["Passing Variables to Hiera"](#passing-variables-to-hiera) below for details on how Hiera receives these variables.

### Using Lookup Functions

Hiera currently has two lookup functions: [`scope()`](#the-scope-lookup-function) and [`hiera()`](#the-hiera-lookup-function). These are described in their own sections below.

To use a lookup function in an interpolation token, write the name of the function plus a pair of parentheses containing a quoted input value:

    wordpress::database_server: "%{hiera('instances::mysql::public_hostname')}"

Notes on this syntax:

* The input value must be surrounded by either single quotes (`'`) or double quotes (`"`).
    * In YAML or JSON, the quotes may be escaped with a backslash if they are embedded in the same kind of quotes; however, the unescaping is handled by the parser and not by Hiera itself.
* The parentheses surrounding the quoted input are mandatory.
* There must be **no spaces** between:
    * The function and the interpolation token's curly braces
    * The function name and the opening parenthesis
    * The parentheses and the quoted input value
    * The quotes and the input value itself

### The `hiera()` Lookup Function

**Only available in Hiera 1.3 and later.**

The `hiera()` lookup function performs a Hiera lookup, using its input as the lookup key. The result of the lookup must be a string; any other result will cause an error.

This can be very powerful in Hiera's data sources. By storing a fragment of data in one place and then using sub-lookups wherever it needs to be used, you can avoid repetition and make it easier to change your data.

    wordpress::database_server: "%{hiera('instances::mysql::public_hostname')}"

The value looked up by the `hiera()` function may itself contain a `hiera()` lookup. (The function will detect any circular lookups and fail with an error instead of looping infinitely.)

> **Note:** Using recursive lookups in Hiera's config file is untested and can potentially cause infinite recursion. (See [HI-220](https://tickets.puppetlabs.com/browse/HI-220).) You should only use the `hiera()` function in data sources.

### The `scope()` Lookup Function

**Only available in Hiera 1.3 and later.**

The `scope()` lookup function interpolates variables; it works identically to variable interpolation as described above. The function's input is the name of a variable surrounded by single or double quotes.

The following two values would be identical:

    smtpserver: "mail.%{::domain}"
    smtpserver: "mail.%{scope('::domain')}"


Where to Interpolate Data
-----

### In Data Sources

The main use for interpolation is in the [config file][config], where you can set dynamic data sources in the [hierarchy][]:

    ---
    :hierarchy:
      - "%{::clientcert}"
      - "%{::custom_location}"
      - "virtual_%{::is_virtual}"
      - "%{::environment}"
      - common

In this example, every data source except the final one will vary depending on the current values of the `::clientcert, ::custom_location, ::is_virtual,` and `::environment` variables.

### In Other Settings

You can also interpolate variables into other [settings][config], such as `:datadir` (in the YAML and JSON backends):

    :yaml:
      :datadir: "/etc/puppet/hieradata/%{::environment}"

This example would let you use completely separate data directories for your production and development environments.

### In Data

Within a data source, you can interpolate values into any string, whether it's a standalone value or part of a hash or array value. This can be useful for values that should be different for every node, but which differ **predictably:**

    # /var/lib/hiera/common.yaml
    ---
    smtpserver: "mail.%{::domain}"

In this example, instead of creating a `%{::domain}` hierarchy level and a data source for each domain, you can get a similar result with one line in the `common` data source.

**In Hiera 1.3 and later,** you can also interpolate values into hash keys:

    # /var/lib/hiera/common.yaml
    ---
    bacula::jobs:
      "%{::hostname}_Cyrus":
        fileset: MailServer
        bacula_schedule: 'CycleStandard'
      "%{::hostname}_LDAP":
        fileset: LDAP
        bacula_schedule: 'CycleStandard'

This generally only useful when building something complicated with [the `create_resources` function](/puppet/latest/reference/function.html#createresources), as it lets you interpolate values into resource titles.

**Note:** With YAML data sources, interpolating into hash keys means those hash keys must be quoted.

**Note:** This _only works for keys that are part of a value;_ that is, you can't use interpolation to dynamically create new Hiera lookup keys at the root of a data source.

    # /var/lib/hiera/common.yaml
    ---
    # This isn't legal:
    "%{::hostname}_bacula_jobs":
      "%{::hostname}_Cyrus":
        fileset: MailServer
        bacula_schedule: 'CycleStandard'

Passing Variables to Hiera
-----

Hiera's variables can come from a variety of sources, depending on how Hiera is invoked.

### From Puppet

When used with Puppet, Hiera **automatically** receives **all** of Puppet's current [variables][puppet_vars]. This includes [facts and built-in variables][built_in_vars], as well as local variables from the current scope. Most users will almost exclusively interpolate facts and built-in variables in their Hiera configuration and data.

* Remove Puppet's `$` (dollar sign) prefix when using its variables in Hiera. (That is, a variable called `$::clientcert` in Puppet is called `::clientcert` in Hiera.)
* Puppet variables can be accessed by their [short name or qualified name][qualified_var].

> #### Best Practices
>
> * Usually avoid referencing **user-set local variables** from Hiera. Instead, use [**facts,** **built-in variables,**][built_in_vars] **top-scope variables,** **node-scope variables,** or **variables from an ENC** whenever possible.
> * When possible, reference variables by their [**fully-qualified names**][qualified_var] (e.g. `%{::environment}` and `%{::clientcert}`) to make sure their values are not masked by local scopes.
>
> These two guidelines will make Hiera more predictable, and can help protect you from accidentally mingling data and code in your Puppet manifests.

### From the Command Line

When called from the command line, Hiera defaults to having no variables available. You can specify individual variables, or a file or service from which to obtain a complete "scope" of variables. See [command line usage][command_line] for more details.

### From Ruby

When calling Hiera from Ruby code, you can pass in a complete "scope" of variables as the third argument to the `#lookup` method. The complete signature of `#lookup` is:

~~~ ruby
    hiera_object.lookup(key, default, scope, order_override=nil, resolution_type=:priority)
~~~
