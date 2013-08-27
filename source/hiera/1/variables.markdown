---
layout: default
title: "Hiera 1: Variables and Interpolation"
---

[config]: ./configuring.html
[data]: ./data_sources.html
[puppet_vars]: /puppet/latest/reference/lang_variables.html
[qualified_var]: /puppet/latest/reference/lang_variables.html#naming
[built_in_vars]: /puppet/latest/reference/lang_variables.html#facts-and-built-in-variables
[command_line]: ./command_line.html
[hierarchy]: ./hierarchy.html


Hiera receives a set of variables whenever it is invoked, and the [config file][config] and [data sources][data] can insert these variables into settings and data. This lets you make dynamic data sources in the [hierarchy][], and avoid repeating yourself when writing data.


Inserting Variable Values
-----

**Interpolation tokens** look like `%{variable}` --- a percent sign (`%`) followed by a pair of curly braces (`{}`) containing a variable name.

If any [setting in the config file][config] or [value in a data source][data] contains an interpolation token, Hiera will replace the token with the value of the variable. Interpolation tokens can appear alone or as part of a string.

* Hiera can only interpolate variables whose values are **strings.** (**Numbers** from Puppet are also passed as strings and can be used safely.) You cannot interpolate variables whose values are booleans, numbers not from Puppet, arrays, hashes, resource references, or an explicit `undef` value.
* Additionally, Hiera cannot interpolate an individual **element** of any array or hash, even if that element's value is a string.
* In YAML files, **any string containing an interpolation token must be quoted** in order to comply with the YAML spec. (Under Ruby 1.8, interpolation tokens in unquoted strings will sometimes work anyway, but this can't be relied on.)

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

Within a data source, you can interpolate variables into any string, whether it's a standalone value or part of a hash or array value. This can be useful for values that should be different for every node, but which differ **predictably:**

    # /var/lib/hiera/common.yaml
    ---
    smtpserver: "mail.%{::domain}"

In this example, instead of creating a `%{::domain}` hierarchy level and a data source for each domain, you can get a similar result with one line in the `common` data source.



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

{% highlight ruby %}
    hiera_object.lookup(key, default, scope, order_override=nil, resolution_type=:priority)
{% endhighlight %}
