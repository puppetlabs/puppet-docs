---
layout: default
title: "Language: Facts and built-in variables"
canonical: "/puppet/latest/lang_facts_and_builtin_vars.html"
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
[environment_setting]: ./configuration.html#environment
[certname]: ./configuration.html#certname
[puppetdb_facts]: {{puppetdb}}/api/index.html
[localscope]: ./lang_scope.html#local-scopes
[trusted_on]: ./config_important_settings.html#getting-new-features-early
[scope]: ./lang_scope.html
[extensions]: ./ssl_attributes_extensions.html
[structured_facts_on]: ./config_important_settings.html#getting-new-features-early
[strings]: ./lang_data_string.html
[datatypes]: ./lang_data.html
[qualified_var_names]: ./lang_variables.html#accessing-out-of-scope-variables
[hashaccess]: ./lang_data_hash.html#accessing-values

Before requesting a [catalog][] (or compiling one with `puppet apply`), Puppet will collect system information with [Facter][]. Puppet receives this information as **facts,** which are **pre-set variables** you can use anywhere in your manifests.

Puppet also pre-sets some **other special variables** which behave a lot like facts.

This page describes how to use facts and lists all of the special variables added by Puppet.

## Which facts?

Puppet can access the following facts:

* Facter's built-in [core facts][core_facts]
* Any [custom facts][customfacts] or [external facts][] present in your modules

You can see the [list of core facts][core_facts] to get acquainted with what's available. You can also run `facter -p` at the command line to see real-life values, or browse facts on node detail pages in the Puppet Enterprise console.

For building other tools, [PuppetDB's API][puppetdb_facts] offers powerful ways to to search and report on your entire deployment's facts. (PuppetDB is included in Puppet Enterprise.)

## Data types

This version of Puppet supports fact values of [any data type][datatypes]. It will never convert boolean, numeric, or structured facts to strings.

### Handling boolean facts in older Puppet versions

Puppet 3.x sometimes converts all fact values to [strings][] (e.g. `"false"` instead of `false`), depending on the `stringify_facts` setting and the installed Facter version.

If you're writing code that might be used with pre-4.0 versions of Puppet, you'll need to take extra care when dealing with boolean facts like `$is_virtual`, since the string `"false"` is actually true when used as the condition of an [`if` statement.](./lang_conditional.html#if-statements)

To handle this, you can use the `str2bool` function (from [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)) to prevent fake true values:

``` puppet
if str2bool("$is_virtual") {
  ...
}
```

This pattern (quote the variable, then pass it to `str2bool`) will work with both stringified facts and full data type support.

## Accessing facts from Puppet code

There are two ways to access facts from Puppet code:

* Classic `$fact_name` facts
* The `$facts['fact_name']` hash

### Classic `$fact_name` facts

All facts appear in Puppet as [top-scope variables][topscope]. They can be accessed in manifests as `$fact_name`.

Example, with the osfamily fact:

``` puppet
if $osfamily == 'RedHat' {
  # ...
}
```

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

### The `$facts['fact_name']` hash

Facts also appear in a `$facts` hash. They can be accessed in manifests as `$facts['fact_name']`. The variable name `$facts` is reserved, so local scopes cannot re-use it. Structured facts show up as a nested structure inside the `$facts` namespace, and can be accessed using Puppet's normal [hash access syntax][hashaccess]. Due to ambiguity with function invocation, the dot-separated access syntax that is available at the Facter command line is not available in manifests.

Example, with the `os.family` fact:

``` puppet
if $facts['os']['family'] == 'RedHat' {
  # ...
}
```

**Benefits:** More readable and maintainable code, by making facts visibly distinct from other variables. Eliminates possible confusion if you use a local variable whose name happens to match that of a common fact.

**Drawbacks:** Only works with Puppet 3.5 or later. Disabled by default in open source releases prior to Puppet 4.0.

## Special variables added by Puppet

In addition to Facter's core facts and any custom facts, Puppet creates some special variables of its own. The main categories of special variables are:

* **The `$trusted` hash,** which has trusted data from the node's certificate
* **Agent facts,** which are set by `puppet agent` or `puppet apply`
* **Puppet master variables,** which are set by the Puppet master (and sometimes by `puppet apply`)
* **Compiler variables,** which are special local variables set for each scope.

### Trusted facts

A few special **trusted facts** appear in a `$trusted` hash. They can be accessed in manifests as `$trusted['fact_name']`. The variable name `$trusted` is reserved, so local scopes cannot re-use it.

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
* `domain` --- the node's domain, as derived from its validated certificate name. The value can be empty if the certificate name doesn't contain a fully qualified domain name.
* `extensions` --- a hash containing any [custom extensions][extensions] present in the node's certificate.
    * The keys of the hash will be the [extension OIDs](./ssl_attributes_extensions.html#recommended-oids-for-extensions) --- any OIDs in the ppRegCertExt range will appear using their short names, and other OIDs will appear as plain dotted numbers.
    * If no extensions are present or `authenticated` is `local` or `false`, this will be an empty hash.
* `hostname` --- the node's hostname, as derived from its validated certificate name.

#### Examples

The `$trusted` hash generally looks something like this:

``` puppet
{
  'authenticated' => 'remote',
  'certname'      => 'web01.example.com',
  'domain'        => 'example.com',
  'extensions'    => {
                      'pp_uuid'                 => 'ED803750-E3C7-44F5-BB08-41A04433FE2E',
                      'pp_image_name'           => 'storefront_production'
                      '1.3.6.1.4.1.34380.1.2.1' => 'ssl-termination'
                   },
  'hostname'      => 'web01'
}
```

Here's a snippet of example Puppet code using a [certificate extension][extensions]:

``` puppet
if $trusted['extensions']['pp_image_name'] == 'storefront_production' {
  include private::storefront::private_keys
}
```

### `$server_facts` variable

The `$server_facts` variable provides a hash of server-side facts that cannot be overwritten by client side facts. This is important because it enables you to get trusted server facts that could otherwise be overwritten by client-side facts.

For example, the Puppet master sets the global `$::environment` variable to contain the name of the node's environment. However, if a node provides a fact with the name `environment`, that fact's value overrides the server-set `environment` fact. The same happens with other server-set global variables, like `$::servername` and `$::serverip`. As a result, modules couldn't reliably use these variables for whatever their intended purpose was.

The `$server_facts` variable is opt-in. Its `trusted_server_facts` setting is set to false by default. If you set `trusted_server_facts` to `true`, the `$server_facts` variable will be populated, and will ensure that you get trusted server facts.

In addition, a warning will be issued any time a node parameter is overwritten.

#### Example

The following is an example `$server_facts` hash.

``` puppet
{
  serverversion => "4.1.0",
  servername    => "v85ix8blah.delivery.puppetlabs.net",
  serverip      => "10.32.115.182",
  environment   => "production",
}
```

### Puppet agent facts

Puppet agent and Puppet apply both add several extra pieces of info to their facts before requesting or compiling a catalog. Like other facts, these are available as either top-scope variables or elements in the `$facts` hash.

* `$clientcert` --- the value of the node's [`certname` setting][certname]. (This is self-reported; for the verified certificate name, use `$trusted['certname']`.)
* `$clientversion` --- the current version of Puppet agent.
* `$clientnoop` --- the value of the node's [`noop` setting][noop] (true or false) at the time of the run.
* `$agent_specified_environment` --- the value of the node's [`environment` setting][environment_setting]. If the Puppet master's node classifier specified an environment for the node, `$agent_specified_environment` and `$environment` can have different values.

    If no value was set for the `environment` setting (in puppet.conf or with `--environment`), the value of `$agent_specified_environment` will be `undef`. (That is, it won't default to `production` like the setting does.)

### Puppet master variables

Several variables are set by the Puppet master. These are most useful when managing Puppet with Puppet. (For example, managing puppet.conf with a template.)

These are **not** available in the `$facts` hash.

* `$environment` (also available to `puppet apply`) --- the agent node's [environment][]. Note that nodes can accidentally or purposefully override this with a custom fact; the `$server_facts['environment']` variable always contains the correct environment, and can't be overridden.
* `$servername` --- the Puppet master's fully-qualified domain name. (Note that this information is gathered from the Puppet master by Facter, rather than read from the config files; even if the master's certname is set to something other than its fully-qualified domain name, this variable will still contain the server's fqdn.)
* `$serverip` --- the Puppet master's IP address.
* `$serverversion` --- the current version of Puppet on the Puppet master.
* `$settings::<name of setting>` (also available to `puppet apply`) --- the value of any of the master's [settings](./config_about_settings.html). This is implemented as a special namespace and these variables must be referred to by their qualified names. Note that, other than `$environment` and `$clientnoop`, the agent node's settings are **not** available in manifests. If you wish to expose them to the master in this version of Puppet, you will have to create a custom fact.

### Compiler variables

These variables are set in every [local scope][scope] by the compiler during compilation. They are mostly useful when implementing complex [defined types][definedtype].

These are **not** available in the `$facts` hash.

These variables are always defined (by the standards of the `strict_variables` setting), but their value is `undef` whenever no other value is applicable.

* `$module_name` --- the name of the module that contains the current class or defined type.
* `$caller_module_name` --- the name of the module in which the **specific instance** of the surrounding defined type was declared. This is only useful when creating versatile defined types which will be re-used by several modules.
