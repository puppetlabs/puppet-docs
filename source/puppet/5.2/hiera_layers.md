---
title: "Hiera: How the three config layers work"
---


[hierarchy]: ./hiera_hierarchy.html
[confdir]: ./dirs_confdir.html
[v3]: ./hiera_config_yaml_3.html
[v5]: ./hiera_config_yaml_5.html
[environment]: ./environments.html
[v4]: ./hiera_config_yaml_4.html
[module]: ./modules_fundamentals.html
[params.pp]: ./hiera_migrate_modules.html

Previous versions (Hiera 3 and earlier) used a single, global hiera.yaml file to configure the [hierarchy][]. This version uses three.


## Three layers: Global, environment, and module

Hiera uses three independent **layers** of configuration. Each layer has its own hierarchy, and they're concatenated into one super-hierarchy before doing a lookup.

The three layers always go in this order:

1. Global
2. Environment
3. Module

That is: Hiera searches every data source in the global layer's hierarchy before checking _any_ source in the environment layer.

### Why are there three layers now?

Hiera ≤ 3 only used a global hiera.yaml, and it had two huge problems:

* **Every environment had to use the same hierarchy.** Most people keep configuration data in their environments, but since the hierarchy was global, you couldn't make any changes to it without changing _every_ environment at the same time. Since environments are often used for staged rollout of code changes, this made the hierarchy a dangerous exception to normal change processes.
* **Module data was impossible.** Most modules need some amount of default data. A lot of module authors wanted to use Hiera to provide it, but a central hierarchy couldn't support that.

The three-layer system fixes those issues. You can now roll out hierarchy changes on an environment-by-environment basis, and module data is simple and seamless to use. The global layer stays around for temporary overrides and other special cases.

## The global layer

* **Config file:** [`$confdir`][confdir]`/hiera.yaml` --- can be changed with Puppet's `hiera_config` setting.
* **Supported config formats:** [hiera.yaml v5][v5], [hiera.yaml v3][v3] (deprecated).

Hiera has only one global hierarchy. Since it goes before the environment layer, it's useful for temporary overrides, when your ops team needs to bypass its normal change processes.

It's also the only place where legacy Hiera 3 backends can be used, so it's an important piece of the transition period while everyone's updating their backends to support Hiera 5.

But other than those two use cases, you should try to avoid the global layer. All your normal data should live at the environment layer.


## The environment layer

* **Config file:** [`<ENVIRONMENT DIR>`][environment]`/hiera.yaml`
* **Supported config formats:** [hiera.yaml v5][v5], [hiera.yaml v4][v4] (deprecated).

This is Hiera's main layer.

Every [environment][] has its own hierarchy configuration, which applies to nodes in that environment.

## The module layer

* **Config file:** `<MODULE>/hiera.yaml`
* **Supported config formats:** [hiera.yaml v5][v5], [hiera.yaml v4][v4] (deprecated).
* Only used for namespaced lookup keys (e.g. `ntp::servers`).

This layer can set default values and merge behavior for a [module][]'s class parameters. Think of it as a convenient alternative to [the params.pp pattern][params.pp].

The module layer comes last, so environment data set by a user gets to override default data set by a module author.

Every [module][] can have its own hierarchy configuration. A module's hierarchy **only affects lookup keys in its own namespace.** For example:

Lookup key      | Relevant module hierarchy
----------------|----------------------
`ntp::servers`  | `ntp`
`jenkins::port` | `jenkins`
`secure_server` | (none)

Hiera uses the `ntp` module's hierarchy when looking up `ntp::servers`, but uses the `jenkins` module's hierarchy when looking up `jenkins::port`. Hiera never checks the `ntp` module for a key beginning with `jenkins::`.

For lookup keys that don't have a namespace (for example, `secure_server`), or which don't correspond to an existing module, Hiera skips the module layer.

