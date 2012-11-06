---
layout: default
title: "Hiera 1: Variables and Interpolation"
---

[master_set]: /puppet/3/reference/lang_variables.html#master-set-variables
[agent_set]: /puppet/3/reference/lang_variables.html#agent-set-variables
[datadir]: ./configuring.html#datadir
[config]: 
[data]: 
[puppet_vars]: 
[qualified_var]: 
[command_line]: 

<!-- The following references are not used in the text:
[datadir]:
-->

Hiera receives a set of variables (a "scope") when it is invoked. Hiera's [config file][config] and [data sources][data] can use interpolation tokens (`%{variable}`) to insert any of these variables into both **settings** and **data.**

Interpolating Values
-----

If any [setting][config] or [data value][data] contains an interpolation token, Hiera will replace the token with the value of a variable. Interpolation tokens can appear alone or as part of a string.

Interpolation tokens look like `%{variable}` --- a percent sign (`%`) and a pair of curly braces (`{}`) containing a variable name.

### Examples

The main use for interpolation is to set dynamic [hierarchy levels][hierarchy] in the [config file][config]:

    ---
    :hierarchy:
      - %{::clientcert}
      - %{::custom_location}
      - %{::environment}
      - common



### Limits of Interpolation

Hiera can only interpolate variables whose values are **strings** (and **numbers,** for variables that come from Puppet).

Trying to interpolate variables that contain booleans, arrays, hashes, resource references, or `undef` will result in an error.

Additionally, Hiera cannot interpolate an element of an array or hash, even if that element's value is a string.


Variables and Scopes
-----

Hiera's variables can come from a variety of sources, depending on how Hiera is invoked.

### From Puppet

When used with Puppet, Hiera receives **all of the [variables][puppet_vars] currently available to Puppet.** Variables can be accessed by their short or fully-qualified names.

Within Hiera, the dollar sign (`$`) prefix must be removed from Puppet variable names. (That is, `$::clientcert` in Puppet would be `::clientcert` in Hiera.)

> #### Best Practices
>
> When used with Puppet, Hiera should **only** rely on the following kinds of variables:
>
> * Facts
> * [Agent-set][agent_set] or [master-set][master_set] variables, including `clientcert` and `environment`
> * Top-scope variables set by an ENC
>
> You should access these variables by their [fully-qualified names][qualified_var] (e.g. `%{::environment}` and `%{::clientcert}`) to make sure their values are not masked by local scopes.
>
> These special variables are set **before** catalog compilation begins, and retain their values for the entire run. By limiting yourself to variables that don't depend on parse order or manifest contents, you can guarantee that your Hiera data will be both node-specific and stable. 

### From the Command Line

When called from the command line, Hiera defaults to having no variables available. You can specify individual variables, or a file or service from which to obtain a complete "scope" of variables. See [command line usage][command_line] for more details. 

### From Ruby

When calling Hiera from Ruby code, you can pass in a complete "scope" of variables as the third argument to the `#lookup` method. The complete signature of `#lookup` is:

{% highlight ruby %}
    hiera_object.lookup(key, default, scope, order_override=nil, resolution_type=:priority)
{% endhighlight %}
