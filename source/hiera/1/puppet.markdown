---
layout: default
title: "Hiera 1: Using Hiera With Puppet"
---

[hiera_config]: /puppet/latest/reference/configuration.html#hieraconfig
[confdir]: /puppet/latest/reference/configuration.html#confdir
[datadir]: ./configuring.html#datadir
[hiera_yaml]: ./configuring.html
[variable_tokens]: ./variables.html
[hierarchy]: ./hierarchy.html
[data_sources]: data_sources.html
[custom_facts]: /facter/latest/custom_facts.html
[facts]: /puppet/latest/reference/lang_variables.html#facts-and-built-in-variables
[absolute_scope]: /puppet/latest/reference/lang_variables.html#accessing-out-of-scope-variables
[classes]: /puppet/latest/reference/lang_classes.html
[parameters]: /puppet/latest/reference/lang_classes.html#class-parameters-and-variables
[class_declare]: /puppet/latest/reference/lang_classes.html#declaring-classes
[class_definition]: /puppet/latest/reference/lang_classes.html#defining-classes
[resource_like]: /puppet/latest/reference/lang_classes.html#using-resource-like-declarations
[enc_assign]: /puppet/latest/reference/lang_classes.html#assigning-classes-from-an-enc
[priority]: ./lookup_types.html#priority-default
[array_lookup]: ./lookup_types.html#array-merge
[hash_lookup]: ./lookup_types.html#hash-merge
[template_functions]: /guides/templating.html#using-functions-within-templates
[enc]: /guides/external_nodes.html
[site_manifest]: /puppet/latest/reference/dirs_manifest.html
[node_definition]: /puppet/latest/reference/lang_node_definitions.html

{% partial /hiera/_hiera_update.md %}

Puppet can use Hiera to look up data. This helps you disentangle site-specific data from Puppet code, for easier code re-use and easier management of data that needs to differ across your node population.


Enabling and Configuring Hiera for Puppet
-----

### Puppet 3 and Newer

Puppet 3.x and later ship with Hiera support already enabled. You don't need to do anything extra. Hiera data should live on the puppet master(s).

* Puppet expects to find the [hiera.yaml file][hiera_yaml] at [`$confdir`][confdir]`/hiera.yaml` (usually `/etc/puppet/hiera.yaml`); you can change this with the [`hiera_config`][hiera_config] setting.
* Remember to set the [`:datadir`][datadir] setting for any backends you are using. It's generally best to use something within the `/etc/puppet/` directory, so that the data is in the first place your fellow admins expect it.

### Puppet 2.7

You must install both Hiera and the `hiera-puppet` package on your puppet master(s) before using Hiera with Puppet. Hiera data should live on the puppet master(s).

* Puppet expects to find the [hiera.yaml file][hiera_yaml] at [`$confdir`][confdir]`/hiera.yaml` (usually `/etc/puppet/hiera.yaml`). This is not configurable in 2.7.
* Remember to set the [`:datadir`][datadir] setting for any backends you are using. It's generally best to use something within the `/etc/puppet/` directory, so that the data is in the first place your fellow admins expect it.

### Older Versions

Hiera is not supported with older versions, but you may be able to make it work similarly to Puppet 2.7.




Puppet Variables Passed to Hiera
-----

Whenever a Hiera lookup is triggered from Puppet, Hiera receives a copy of **all** of the variables currently available to Puppet, including both top scope and local variables.

Hiera can then use any of these variables in the [interpolation tokens][variable_tokens] scattered throughout its [hierarchy][] and [data sources][data_sources]. You can enable more flexible hierarchies by creating [custom facts][custom_facts] for things like datacenter location and server purpose.

### Special Pseudo-Variables

When doing any Hiera lookup, with both automatic parameter lookup and the Hiera functions, Puppet sets two variables that aren't available in regular Puppet manifests:

* `calling_module` --- The module in which the lookup is written. This has the same value as the [Puppet `$module_name` variable.][module_name]
* `calling_class` --- The class in which the lookup is evaluated. If the lookup is written in a defined type, this is the class in which the current instance of the defined type is declared.

Note that these variables are effectively local scope, as they are pseudo-variables that only exist within the context of a specific class, and only inside of hiera. Therefore, they must be called as `%{variable_name}` and never `%{::variable_name}`. They are not top-scope.

> **Note:** These variables were broken in some versions of Puppet.
>
> Version                                        | Status
> -----------------------------------------------|-----------
> Puppet 2.7.x / PE 2.x                          | **Good**
> Puppet 3.0.x -- 3.3.x / PE 3.0 -- 3.1          | **Broken**
> Puppet 3.4.x and later / PE 3.2                | **Good**


[module_name]: /puppet/latest/reference/lang_variables.html#parser-set-variables

### Best Practices

There are two practices we always recommend when using Puppet's variables in Hiera:

- **Do not use local Puppet variables** in Hiera's hierarchy or data sources. Only use [**facts**][facts] and **ENC-set top-scope variables.**

    Using local variables can make your hierarchy incredibly difficult to debug.
- **Use [absolute top-scope notation][absolute_scope]** (i.e. `%{::clientcert}` instead of `%{clientcert}`) in Hiera's config files to avoid accidentally accessing a local variable instead of a top-scope one.

    Note that this is different from Puppet manifests, where the `$::fact` idiom is [never necessary.](/puppet/latest/reference/lang_facts_and_builtin_vars.html#historical-note-about-) In Puppet, re-using the name of a fact variable in a local scope will only have local consequences. In Hiera, a re-used fact name can have more distant effects, so you still need to defend against it.

Automatic Parameter Lookup
-----

Puppet will automatically retrieve class parameters from Hiera, using lookup keys like `myclass::parameter_one`.

> **Note:** This feature only exists in Puppet 3 and later.

Puppet [classes][] can optionally include [parameters][] in their definition. This lets the class ask for data to be passed in at the time that it's declared, and it can use that data as normal variables throughout its definition.

~~~ ruby
    # In this example, $parameter's value gets set when `myclass` is eventually declared.
    # Class definition:
    class myclass ($parameter_one = "default text") {
      file {'/tmp/foo':
        ensure  => file,
        content => $parameter_one,
      }
    }
~~~

Parameters can be set several ways, and Puppet will try each of these ways in order when the class is [declared][class_declare] or [assigned by an ENC][enc_assign]:

1. If it was a [resource-like declaration/assignment][resource_like], Puppet will use any parameters that were explicitly set. These always win if they exist.
2. **Puppet will automatically look up parameters in Hiera,** using `<CLASS NAME>::<PARAMETER NAME>` as the lookup key. (E.g. `myclass::parameter_one` in the example above.)
3. If 1 and 2 didn't result in a value, Puppet will use the default value from the class's [definition][class_definition]. (E.g. `"default text"` in the example above.)
4. If 1 through 3 didn't result in a value, fail compilation with an error.

Step 2 interests us most here. Because Puppet will always look for parameters in Hiera, you can safely declare **any** class with `include`, even classes with parameters. (This wasn't the case in earlier Puppet versions.) Using the example above, you could have something like the following in your Hiera data:

~~~ yaml
    # /etc/puppet/hieradata/web01.example.com.yaml
    ---
    myclass::parameter_one: "This node is special, so we're overriding the common configuration that the other nodes use."

    # /etc/puppet/hieradata/common.yaml
    ---
    myclass::parameter_one: "This node can use the standard configuration."
~~~

You could then say `include myclass` for every node, and each node would get its own appropriate data for the class.

### Why

Automatic parameter lookup is good for writing reusable code because it is **regular and predictable.** Anyone downloading your module can look at the first line of each manifest and easily see which keys they need to set in their own Hiera data. If you use the Hiera functions in the body of a class instead, you will need to clearly document which keys the user needs to set.

#### To Disable

If you need to disable this feature, then you can set `data_binding_terminus = none` in your master's `puppet.conf`

### Limitations

#### Priority Only

Automatic parameter lookup can only use the [priority][] lookup method.

This means that, although it **can** receive any type of data from Hiera (strings, arrays, hashes), it **cannot** merge values from multiple hierarchy levels; you will only get the value from the most-specific hierarchy level.

If you need to merge arrays or merge hashes from multiple hierarchy levels, you will have to use the `hiera_array` or `hiera_hash` functions in the body of your classes.

#### No Puppet 2.7 Support

Relying on automatic parameter lookup means writing code for Puppet 3 and later only.

You can, however, mimic Puppet 3 behavior in 2.7 by combining parameter defaults and Hiera function calls:

~~~ ruby
    class myclass (
      $parameter_one = hiera('myclass::parameter_one', 'default text')
    ) {
      # ...
    }
~~~

* This pattern requires that 2.7 users have Hiera installed; it will fail compilation if the Hiera functions aren't present.
* Since all of your parameters will have defaults, your class will be safely declarable with `include`, even in 2.7.
* Puppet 2.7 will do Hiera lookups for the same keys that Puppet 3 automatically looks up.
* Note that this carries a performance penalty, since Puppet 3 will end up doing two Hiera calls for each parameter instead of one.


Hiera Lookup Functions
-----

Puppet has three lookup functions for retrieving data from Hiera. All of these functions return a single value (though note that this value may be an arbitrarily complex nested data structure), and can be used anywhere that Puppet accepts values of that type. (Resource attributes, resource titles, the values of variables, etc.)

`hiera`
: Standard priority lookup. Gets the most specific value for a given key. This can retrieve values of any data type (strings, arrays, hashes) from Hiera.

`hiera_array`
: Uses an [array merge lookup][array_lookup]. Gets all of the string or array values in the hierarchy for a given key, then flattens them into a single array of unique values.

`hiera_hash`
: Uses a [hash merge lookup][hash_lookup]. Expects every value in the hierarchy for a given key to be a hash, and merges the top-level keys in each hash into a single hash. Note that this does not do a deep-merge in the case of nested structures.

Each of these functions takes three arguments. In order:

1. Key (required): the key to look up in Hiera.
2. Default (optional): a fallback value to use if Hiera doesn't find anything for that key. If this isn't provided, a lookup failure will cause a compilation failure.
3. Override (optional): the name of an arbitrary [hierarchy level][hierarchy] to insert at the top of the hierarchy. This lets you use a temporary modified hierarchy for a single lookup. (E.g., instead of a hierarchy of `$clientcert -> $osfamily -> common`, a lookup would use `specialvalues -> $clientcert -> $osfamily -> common`; you would need to be sure to have `specialvalues.yaml` or whatever in your Hiera data.)



### Using the Lookup Functions From Templates

In general, don't use the Hiera functions from templates. That pattern is too obscure, and will hurt your code's maintainability --- if a co-author of your code needs to change the Hiera invocations and is searching `.pp` files for them, they might miss the extra invocations in the template. Even if only one person is maintaining this code, they're likely to make similar mistakes after a few months have passed.

It's much better to use the lookup functions in a Puppet manifest, assign their value to a local variable, and then reference the variable from the template. This keeps the function calls isolated in one layer of your code, where they'll be easy to find if you need to modify them later or document them for other users.

Nevertheless, you can, of course, [use the `scope.function_` prefix][template_functions] to call any of the Hiera functions from a template.

Interacting With Structured Data from Hiera
-----

The lookup functions and the automatic parameter lookup always return the values of **top-level keys** in your Hiera data --- they cannot descend into deeply nested data structures and return only a portion of them. To do this, you need to first store the whole structure as a variable, then index into the structure from your Puppet code or template.

Example:

~~~ yaml
    # /etc/puppet/hieradata/appservers.yaml
    ---
    proxies:
      - hostname: lb01.example.com
        ipaddress: 192.168.22.21
      - hostname: lb02.example.com
        ipaddress: 192.168.22.28
~~~

Good:

~~~ ruby
    # Get the structured data:
    $proxies = hiera('proxies')
    # Index into the structure:
    $use_ip = $proxies[1]['ipaddress'] # will be 192.168.22.28
~~~

Bad:

~~~ ruby
    # Try to skip a step, and give Hiera something it doesn't understand:
    $use_ip = hiera( 'proxies'[1]['ipaddress'] ) # will explode
~~~


Assigning Classes to Nodes With Hiera (`hiera_include`)
-----

You can use Hiera to assign classes to nodes with the special `hiera_include` function. This lets you assign classes in great detail without repeating yourself --- it's essentially what people have traditionally tried and failed to use node inheritance for. It can get you the benefits of a rudimentary [external node classifier][enc] without having to write an actual ENC.

1. Choose a key name to use for classes. Below, we assume you're just using `classes`.
2. In your [main manifest][site_manifest], write the line `hiera_include('classes')`. Put this **outside any [node definition][node_definition],** and below any top-scope variables that you might be relying on for Hiera lookups.
3. Create `classes` keys throughout your Hiera hierarchy.
    * The value of each `classes` key should be an **array.**
    * Each value in the array should be **the name of a class.**

Once you do these steps, Puppet will automatically assign classes from Hiera to every node. Note that the `hiera_include` function uses an [array merge lookup][array_lookup] to retrieve the `classes` array; this means every node will get **every** class from its hierarchy.

Example:

Assuming a hierarchy of:

~~~ yaml
    :hierarchy:
      - "%{::clientcert}"
      - "%{::osfamily}"
      - common
~~~

...and given Hiera data like the following:

~~~ yaml
    # common.yaml
    ---
    classes:
      - base
      - security
      - mcollective

    # Debian.yaml
    ---
    classes:
      - base::linux
      - localrepos::apt

    # web01.example.com.yaml
    ---
    classes:
      - apache
      - apache::passenger
~~~

...the Ubuntu node `web01.example.com` would get all of the following classes:

- apache
- apache::passenger
- base::linux
- localrepos::apt
- base
- security
- mcollective

In Puppet 3, each of these classes would then automatically look up any required parameters in Hiera.
