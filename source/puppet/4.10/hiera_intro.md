---
title: "Hiera: What is Hiera?"
---


[auto_lookup]: ./hiera_automatic.html
[facts]: ./lang_facts_and_builtin_vars.html
[roles_and_profiles]: {{pe}}/r_n_p_intro.html
[the migration guide]: ./hiera_migrate.html
[hiera_functions]: ./hiera_use_hiera_functions.html
[v3]: ./hiera_config_yaml_3.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html
[custom_backend]: ./hiera_custom_backends.html
[merging]: ./hiera_merging.html
[layers]: ./hiera_layers.html
[module layer]: ./hiera_layers.html#the-module-layer

## What is Hiera?

Hiera is Puppet's built-in key/value data lookup system. By default, it uses simple YAML or JSON files, although you can extend it to work with almost any data source. Almost every successful Puppet user relies on it heavily, and you should too.

### Hiera is the config file for your Puppet code

Puppet's primary strength is in reusable code. But code that serves many needs has to be configurable --- site-specific information should usually be in configuration data, rather than in the code itself.

Hiera is the most flexible way to get configuration data into Puppet. Puppet [automatically searches Hiera for class parameters][auto_lookup], so you can use Hiera to configure any module.

### Hiera helps you avoid repetition

Hiera's hierarchical lookups are built for a "defaults, with overrides" pattern. This lets you specify common data once, then override it in situations where the default won't work. And since Hiera uses Puppet's [facts][] to specify data sources, you can structure your overrides in whatever way makes sense for your infrastructure.

### You should use Hiera with the roles and profiles method

Hiera is immensely powerful, and with great power comes great responsibility. Specifically, you're responsible for making your infrastructure _maintainable_ and _legible,_ both for your co-workers and for your future self.

The best way to do this is to adopt sensible, rigorous rules about _where_ and _how_ Hiera data should enter your system. This makes your code and data easier to reason about and safer to edit.

For most Puppet users, [the roles and profiles method][roles_and_profiles] is a good starting point. It sets simple rules about what should and shouldn't be configured with Hiera, and strikes a good balance between flexibility and maintainability.


## What's the deal with Hiera 5?

"Hiera 5" is a backwards-compatible evolution of Hiera. It's built into this version of Puppet --- you're already using it, though you might not have enabled its new features yet.

### Hiera isn't separate from Puppet anymore

Hiera began as an independent Ruby library that worked with Puppet. Over time, it became a requirement and was even included in the puppet-agent package, but it was limited by its original design.

Now, Hiera is fully integrated into Puppet.

### Hiera 5 has environment and module data

The biggest new feature in Hiera 5 is independent hierarchy configurations for each environment and module. This means:

* Your main Hiera data was already in your environments, but now its configuration lives right alongside it. So making changes to the hierarchy is as safe and testable as any other change to your code or data.
* Module authors can use the power of Hiera to set default values for their modules, and users can override those defaults without having to worry about how they're implemented.

Read about [Hiera's system of three layers][layers] for more info.

### Building custom Hiera 5 backends is easy

We've totally overhauled the interface for building custom backends, so it's easy to integrate Hiera with almost any data source. See [How custom backends work][custom_backend] for more info.

### What happened to Hiera 4? To "Puppet lookup?"

The experimental "Puppet lookup" feature (from Puppet 4.3 through 4.8) was effectively Hiera 4 --- it used a "version: 4" hiera.yaml file, and included rough drafts of many features we completed for Hiera 5.

Hiera 5 is backwards compatible with Puppet lookup, and supports v4 hiera.yaml files. Hiera still uses the `lookup` function and `puppet lookup` command.

### Am I going to have to change all my data and config files?

No.

Your data probably won't need any changes, and Hiera 5 is compatible with your old configuration. But if you want to take full advantage of Hiera 5's new features, you'll need to make some configuration edits to enable them. See [the migration guide][] for details.

### I use a custom Hiera 3 backend. Can I use Hiera 5?

Even with all the new features enabled, you can keep using your Hiera 3 backends at the global layer.

As soon as possible, the backend's maintainer should rewrite it to support Hiera 5. Hiera 5 backends are much easier to write, and support per-environment configuration.

### Some features are deprecated. When are they getting removed?

Probably in Puppet 6. You have some time.

The current list of deprecated Hiera features includes:

* The [classic `hiera_*` functions][hiera_functions]. (They're fully replaced by the `lookup` function.)
* The `hiera` command line tool, which was used for testing and exploring data. (It's replaced by the `puppet lookup` command, which understands concepts like nodes and environments and can automatically get facts from PuppetDB.)
* [Version 3][v3] and [version 4][v4] of the hiera.yaml file.
* Custom backends written for Hiera ≤ 3. They should be rewritten for the [new, simpler custom backend system][custom_backend].
* Setting a global hash merge behavior in hiera.yaml. (Merge behavior is now [configured per-key and per-lookup][merging].)
* The `data_binding_terminus` setting. If you use a custom terminus, convert it to a [Hiera 5 custom backend][custom_backend].
* The following special pseudo-variables:
    * `calling_module`
    * `calling_class`
    * `calling_class_path`

    Hiera 3 could use these as a hacky predecessor of module data, but anything you were doing with them is better accomplished with [the module layer][module layer]. You can continue using these in a [version 3 hiera.yaml file][v3], but you'll need to remove them once you update your global config to [version 5][v5].
