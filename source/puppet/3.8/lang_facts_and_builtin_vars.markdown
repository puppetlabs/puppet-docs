---
layout: default
title: "Language: Facts and Built-in Variables"
canonical: "/puppet/latest/reference/lang_facts_and_builtin_vars.html"
---

[definedtype]: ./lang_defined_types.html
[environment]: ./environments.html
[topscope]: ./lang_scope.html#top-scope
[core_facts]: {{facter}}/core_facts.html
[facter]: {{facter}}
[customfacts]: {{facter}}/custom_facts.html
[external facts]: {{facter}}/custom_facts.html#external-facts
[catalog]: ./lang_summary.html#compilation-and-catalogs
[noop]: ./configuration.html#noop
[certname]: ./configuration.html#certname
[puppetdb_facts]: {{puppetdb}}/api/index.html
[localscope]: ./lang_scope.html#local-scopes
[trusted_on]: ./config_important_settings.html#getting-new-features-early
[scope]: ./lang_scope
[extensions]: ./ssl_attributes_extensions.html
[structured_facts_on]: ./config_important_settings.html#getting-new-features-early
[strings]: ./lang_datatypes.html#strings
[datatypes]: ./lang_datatypes.html
[qualified_var_names]: ./lang_variables.html#accessing-out-of-scope-variables


Before requesting a [catalog][] (or compiling one with `puppet apply`), Puppet will collect system information with [Facter][]. Puppet receives this information as **facts,** which are **pre-set variables** you can use anywhere in your manifests.

Puppet also pre-sets some **other special variables** which behave a lot like facts.

This page describes how to use facts, and lists all of the special variables added by Puppet.


Which Facts?
-----

Puppet can access the following facts:

* Facter's built-in [core facts][core_facts]
* Any [custom facts][customfacts] or [external facts][] present in your modules

You can see the [list of core facts][core_facts] to get acquainted with what's available. You can also run `facter -p` at the command line to see real-life values, or browse facts on node detail pages in the Puppet Enterprise console.

For building other tools, [PuppetDB's API][puppetdb_facts] offers powerful ways to to search and report on your entire deployment's facts. (PuppetDB is included in Puppet Enterprise.)

Data Types
-----

This version of Puppet **supports fact values of [any data type][datatypes],** but you may need to manually enable them:

Puppet Enterprise 3.8             | Puppet 3.8 (open source release)
----------------------------------|-------
All data types enabled by default | User must install Facter ≥ 2.0 on all nodes, upgrade to PuppetDB ≥ 2.2, then set `stringify_facts = false` in puppet.conf on all nodes [(details here)][structured_facts_on]

### Handling String-Only Facts

Older versions of Puppet would always convert all fact values to [strings][]. (Thus, `false` would become `"false"`, and hash or array data structures were impossible.) This is still the default in open source releases of Puppet 3.8.

When Puppet is configured to use stringified facts, you'll need to take extra care when dealing with boolean facts like `$is_virtual`, since the string `"false"` is actually true when used as the condition of an [`if` statement.](./lang_conditional.html#if-statements)

If you're writing code that might be used in Puppet installations without complete data types enabled for facts, you can use the `str2bool` function (from [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)) to prevent fake true values:

~~~ ruby
    if str2bool("$is_virtual") {
      ...
    }
~~~

This pattern (quote the variable, then pass it to `str2bool`) will work with both stringified facts and full data type support.

Accessing Facts From Puppet Code
-----

There are two ways to access facts from Puppet code:

* Classic `$fact_name` facts
* The `$facts['fact_name']` hash

### Classic `$fact_name` Facts

All facts appear in Puppet as [top-scope variables][topscope]. They can be accessed in manifests as `$fact_name`.

Example, with the osfamily fact:

~~~ ruby
    if $osfamily == 'redhat' {
      # ...
    }
~~~

**Benefits:** Works in all versions of Puppet.

**Drawbacks:** It's not immediately obvious that you're using a fact --- someone reading your code needs to know which facts exist to guess that you're accessing a special top-scope variable. To get around this, some people use [the `$::fact_name` idiom][qualified_var_names] as a hint, to show that they're accessing a top-scope variable.

> #### Historical Note About `$::`
>
> Classic facts use the same naming conventions as normal user-set variables, so the value of a fact variable can be overridden in a [local scope][localscope].
>
> Nowadays, this isn't a problem, because:
>
> * If a programmer overrides a fact value in a [local scope][localscope], it will only affect code that they control.
> * Most people don't set tons of variables in [node scope.](./lang_scope.html#node-scope)
>
> But prior to Puppet 3.0, Puppet's long and unpredictable chains of dynamic parent scopes could create serious problems, where an overridden value would clobber distant code that was trying to access a normal fact. To defend against that, people started using [the `$::fact_name` idiom][qualified_var_names] to always access the top-scope value of a variable.
>
> Then, when Puppet 2.7 added deprecation warnings about dynamic scope lookup, the code that implemented the warnings had [an annoying bug](http://projects.puppetlabs.com/issues/8174) that could cause _false_ warnings when facts were accessed without a leading `$::`. This made even more people start using it, just to make the warnings go away.
>
> Since Puppet 3.0, `$::fact` has never been strictly necessary, but some people still use it to alert readers that they're using a top-scope variable, as described above.

### The `$facts['fact_name']` Hash

This feature may be enabled by default, or you may need to enable it manually:

Puppet Enterprise 3.8             | Puppet 3.8 (open source release)
----------------------------------|-------
`$facts` hash enabled by default  | User must [set `trusted_node_data = true`][trusted_on]\* in puppet.conf on the Puppet master server

If enabled, facts also appear in a `$facts` hash. They can be accessed in manifests as `$facts['fact_name']`. The variable name `$facts` will be reserved, so local scopes cannot re-use it.

Example, with the osfamily fact:

~~~ ruby
    if $facts['osfamily'] == 'redhat' {
      # ...
    }
~~~

**Benefits:** More readable and maintainable code, by making facts visibly distinct from other variables. Eliminates possible confusion if you use a local variable whose name happens to match that of a common fact.

**Drawbacks:** Only works with Puppet 3.5 or later, and only when enabled.

\* Note: The `$facts` hash is enabled by default when setting `trusted_node_data`, but it can be disabled with the `immutable_node_data` setting.


Special Variables Added by Puppet
-----

In addition to Facter's core facts and any custom facts, Puppet creates some special variables of its own. The main categories of special variables are:

* **The `$trusted` hash,** which has trusted data from the node's certificate
* **Agent facts,** which are set by `puppet agent` or `puppet apply`
* **Puppet master variables,** which are set by the Puppet master (and sometimes by `puppet apply`)
* **Parser variables,** which are special local variables set for each scope.

### Trusted Facts

This feature may be enabled by default, or you may need to enable it manually:

Puppet Enterprise 3.8             | Puppet 3.8 (open source release)
----------------------------------|-------
Trusted facts enabled by default  | User must [set `trusted_node_data = true`][trusted_on] in puppet.conf on the Puppet master server

If enabled, a few special **trusted facts** will appear in a `$trusted` hash. They can be accessed in manifests as `$trusted['fact_name']`. The variable name `$trusted` will be reserved, so local scopes cannot re-use it.

Normal facts are self-reported by the node, and nothing guarantees their accuracy. Trusted facts are extracted from the node's certificate, which can prove that the CA checked and approved them. This makes them useful for deciding whether a given node should receive sensitive data in its catalog.

The available keys in the `$trusted` hash are:

* `authenticated` --- an indication of whether the catalog request was authenticated, as well as how it was authenticated. The value will be one of:
    * `remote` for authenticated remote requests (as with agent/master Puppet configurations)
    * `local` for all local requests (as with standalone Puppet apply nodes)
    * `false` for unauthenticated remote requests (generally only possible if you've configured auth.conf to allow unauthenticated catalog requests)
* `certname` --- the node's subject CN, as listed in its certificate. (When first requesting its certificate, the node requests a subject CN matching the value of its `certname` setting.)
    * If `authenticated` is `remote`, this is the subject CN extracted from the node's certificate.
    * If `authenticated` is `local`, this is read directly from the `certname` setting.
    * If `authenticated` is `false`, the value of this key will be an empty string.
* `extensions` --- a hash containing any [custom extensions][extensions] present in the node's certificate.
    * The keys of the hash will be the [extension OIDs](./ssl_attributes_extensions.html#recommended-oids-for-extensions) --- any OIDs in the ppRegCertExt range will appear using their short names, and other OIDs will appear as plain dotted numbers.
    * If no extensions are present or `authenticated` is `local` or `false`, this will be an empty hash.


#### Examples

The `$trusted` hash generally looks something like this:

~~~ ruby
    {
      'authenticated' => 'remote',
      'certname'      => 'web01.example.com',
      'extensions'    => {
                          'pp_uuid'                 => 'ED803750-E3C7-44F5-BB08-41A04433FE2E',
                          'pp_image_name'           => 'storefront_production'
                          '1.3.6.1.4.1.34380.1.2.1' => 'ssl-termination'
                       }
    }
~~~

Here's a snippet of example Puppet code using a [certificate extension][extensions]:

~~~ ruby
    if $trusted['extensions']['pp_image_name'] == 'storefront_production' {
      include private::storefront::private_keys
    }
~~~


### Puppet Agent Facts

Puppet agent and Puppet apply both add several extra pieces of info to their facts before requesting or compiling a catalog. Like other facts, these are available as either top-scope variables or elements in the `$facts` hash.

* `$clientcert` --- the value of the node's [`certname` setting][certname]. (This is self-reported; for the verified certificate name, use `$trusted['certname']`.)
* `$clientversion` --- the current version of Puppet agent.
* `$clientnoop` --- the value of the node's [`noop` setting][noop] (true or false) at the time of the run.

### Puppet Master Variables

Several variables are set by the Puppet master. These are most useful when managing Puppet with Puppet. (For example, managing puppet.conf with a template.)

These are **not** available in the `$facts` hash.

* `$environment` (also available to `puppet apply`) --- the agent node's [environment][].
* `$servername` --- the Puppet master's fully-qualified domain name. (Note that this information is gathered from the Puppet master by Facter, rather than read from the config files; even if the master's certname is set to something other than its fully-qualified domain name, this variable will still contain the server's fqdn.)
* `$serverip` --- the Puppet master's IP address.
* `$serverversion` --- the current version of Puppet on the Puppet master.
* `$settings::<name of setting>` (also available to `puppet apply`) --- the value of any of the master's [settings](./config_about_settings.html). This is implemented as a special namespace and these variables must be referred to by their qualified names. Note that, other than `$environment` and `$clientnoop`, the agent node's settings are **not** available in manifests. If you wish to expose them to the master in this version of Puppet, you will have to create a custom fact.

### Parser Variables

These variables are set in every [local scope][scope] by the parser during compilation. These are mostly useful when implementing complex [defined types][definedtype].

These are **not** available in the `$facts` hash.

As of Puppet 3.7.5: These variables are always defined (by the standards of the `strict_variables` setting), but their value is `undef` whenever no other value is applicable.

* `$module_name` --- the name of the module that contains the current class or defined type.
* `$caller_module_name` --- the name of the module in which the **specific instance** of the surrounding defined type was declared. This is only useful when creating versatile defined types which will be re-used by several modules.

