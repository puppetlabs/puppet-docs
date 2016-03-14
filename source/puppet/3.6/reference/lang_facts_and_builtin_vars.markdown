---
layout: default
title: "Language: Facts and Built-in Variables"
canonical: "/puppet/latest/reference/lang_facts_and_builtin_vars.html"
---

[definedtype]: ./lang_defined_types.html
[environment]: ./environments.html
[topscope]: ./lang_scope.html#top-scope
[core_facts]: /facter/latest/core_facts.html
[facter]: /facter/latest
[customfacts]: /facter/latest/custom_facts.html
[catalog]: ./lang_summary.html#compilation-and-catalogs
[noop]: ./configuration.html#noop
[certname]: ./configuration.html#certname
[puppetdb_facts]: /puppetdb/latest/api/index.html
[localscope]: ./lang_scope.html#local-scopes
[trusted_on]: ./config_important_settings.html#getting-new-features-early
[scope]: ./lang_scope
[extensions]: ./ssl_attributes_extensions.html
[structured_facts_on]: ./config_important_settings.html#getting-new-features-early
[strings]: ./lang_datatypes.html#strings
[qualified_var_names]: ./lang_variables.html#accessing-out-of-scope-variables

Puppet provides many built-in variables that you can use in your manifests. This page covers where they come from and how to use them.

Facts
-----

Before requesting a [catalog][] from a puppet master (or compiling one locally with puppet apply), a puppet node will run [Facter][] to collect information about the system.

Puppet receives this information as **facts,** which are pre-set variables you can use anywhere in your manifests. Puppet can use both the built-in [core facts][core_facts] and any [custom facts][customfacts] present in your modules.

By default, all facts are [strings][]. If you use Facter 2.0 and [enable structured facts in Puppet][structured_facts_on], facts can contain any data type, including arrays and hashes. The same setting will enable structured facts in versions of PuppetDB since 2.2.

* [See here for a complete list of built-in facts][core_facts]. Note that the list depends on the version of Facter you are using.
* [See here for a guide to writing custom facts][customfacts]. They're useful and easy, and most Puppet users should learn how to make them.
* In Puppet Enterprise, any node detail page in the PE console will contain a list of that node's facts.
* You can run `facter -p` on one of your nodes to get a complete report of the facts that node will report to the master.
* You can use [PuppetDB's APIs][puppetdb_facts] to search and report on your entire deployment's facts. (PE users already have PuppetDB installed.)

### Classic Facts

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

### The `$facts` Hash

If you [set `trusted_node_data = true` in puppet.conf][trusted_on] on the puppet master,\* facts also appear in a `$facts` hash. They can be accessed in manifests as `$facts[fact_name]`. The variable name `$facts` will be reserved, so local scopes cannot re-use it.

Example, with the osfamily fact:

~~~ ruby
    if $facts[osfamily] == 'redhat' {
      # ...
    }
~~~

**Benefits:** More readable and maintainable code, by making facts visibly distinct from other variables. Eliminates possible confusion if you use a local variable whose name happens to match that of a common fact.

**Drawbacks:** Only works with Puppet 3.5 or later, so it's currently a bad choice for reusable code.

\* Note: The `$facts` hash is enabled by default when setting `trusted_node_data`, but it can be disabled with the `immutable_node_data` setting.

### Trusted Facts

If you [set `trusted_node_data = true` in puppet.conf][trusted_on] on the puppet master, a few special **trusted facts** will appear in a `$trusted` hash. They can be accessed in manifests as `$trusted[fact_name]`. The variable name `$trusted` will be reserved, so local scopes cannot re-use it.

Normal facts are self-reported by the node, and nothing guarantees their accuracy. Trusted facts are extracted from the node's certificate, which can prove that the CA checked and approved them. This makes them useful for deciding whether a given node should receive sensitive data in its catalog.

Example, using a [certificate extension][extensions]:

~~~ ruby
    if $trusted[extensions][pp_image_name] == 'storefront_production' {
      include private::storefront::private_keys
    }
~~~

#### List of Trusted Facts

The `$trusted` hash looks something like this:

~~~ ruby
    {
      authenticated => 'remote',
      certname      => 'web01.example.com',
      extensions    => {
                          pp_uuid                   => 'ED803750-E3C7-44F5-BB08-41A04433FE2E',
                          pp_image_name             => 'storefront_production'
                          '1.3.6.1.4.1.34380.1.2.1' => 'ssl-termination'
                       }
    }
~~~

The available keys are:

* `authenticated` --- an indication of whether the catalog request was authenticated, as well as how it was authenticated. The value will be one of:
    * `remote` for authenticated remote requests (as with agent/master Puppet configurations)
    * `local` for all local requests (as with standalone puppet apply nodes)
    * `false` for unauthenticated remote requests (generally only possible if you've configured auth.conf to allow unauthenticated catalog requests)
* `certname` --- the node's subject CN, as listed in its certificate. (When first requesting its certificate, the node requests a subject CN matching the value of its `certname` setting.)
    * If `authenticated` is `remote`, this is the subject CN extracted from the node's certificate.
    * If `authenticated` is `local`, this is read directly from the `certname` setting.
    * If `authenticated` is `false`, the value of this key will be an empty string.
* `extensions` --- a hash containing any [custom extensions][extensions] present in the node's certificate.
    * The keys of the hash will be the [extension OIDs](./ssl_attributes_extensions.html#recommended-oids-for-extensions) --- any OIDs in the ppRegCertExt range will appear using their short names, and other OIDs will appear as plain dotted numbers.
    * If no extensions are present or `authenticated` is `local` or `false`, this will be an empty hash.


### Puppet Agent Facts

Puppet agent and puppet apply both add several extra pieces of info to their facts before requesting or compiling a catalog. Like other facts, these are available as either top-scope variables or elements in the `$facts` hash.

* `$clientcert` --- the value of the node's [`certname` setting][certname]. (This is self-reported; for the verified certificate name, use `$trusted['certname']`.)
* `$clientversion` --- the current version of puppet agent.
* `$clientnoop` --- the value of the node's [`noop` setting][noop] (true or false) at the time of the run.

Variables Set by the Puppet Master
-----

Several variables are set by the puppet master. These are most useful when managing Puppet with Puppet. (For example, managing puppet.conf with a template.)

* `$environment` --- the agent node's [environment][].
* `$servername` --- the puppet master's fully-qualified domain name. (Note that this information is gathered from the puppet master by Facter, rather than read from the config files; even if the master's certname is set to something other than its fully-qualified domain name, this variable will still contain the server's fqdn.)
* `$serverip` --- the puppet master's IP address.
* `$serverversion` --- the current version of puppet on the puppet master.
* `$settings::<name of setting>` --- the value of any of the master's [settings](./config_about_settings.html). This is implemented as a special namespace and these variables must be referred to by their qualified names. Note that, other than `$environment` and `$clientnoop`, the agent node's settings are **not** available in manifests. If you wish to expose them to the master in this version of Puppet, you will have to create a custom fact.

Variables Set by the Parser
-----

These variables are set in every [local scope][scope] by the parser during compilation. These are mostly useful when implementing complex [defined types][definedtype].

* `$module_name` --- the name of the module that contains the current class or defined type.
* `$caller_module_name` --- the name of the module in which the **specific instance** of the surrounding defined type was declared. This is only useful when creating versatile defined types which will be re-used by several modules.

