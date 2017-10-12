---
layout: default
title: "Puppet Lookup: Quick Reference for Hiera Users"
canonical: "/puppet/latest/lookup_quick.html"
---

[lookup_function]: ./function.html#lookup
[lookup_man]: ./man/lookup.html
[auto_params]: ./lang_classes.html#include-like-behavior
[hiera_config]: /hiera/3.0/configuring.html
[environment.conf]: ./config_file_environment.html
[puppet.conf]: ./config_file_main.html
[metadata.json]: ./modules_metadata.html
[namespace]: ./lang_namespaces.html
[quick_module]: ./lookup_quick_module.html
[writing data sources]: /hiera/3.0/data_sources.html
[hiera_interpolation]: /hiera/3.0/variables.html

{% partial ./_lookup_experimental.md %}


We designed Puppet lookup to be familiar to Hiera users, but there are a few important differences. If you already use Hiera, this page will catch you up on the changes.

## What Is Puppet Lookup?

It's a lot like Hiera, except:

* Environments can configure their own lookup hierarchies, which frees you to manage hierarchy changes like the rest of your code.
* Modules have more ways to set default values for their own parameters.
* The lookup tools are better.
* You can control merge behavior in new ways.
    * Related: There's a special key called `lookup_options` that you can never manually look up.

There are some extra details, and we might add more new features in the future, but those are the most important bits.

## Three Tiers: Classic Hiera → Environment Data → Module Data

Every time you request data through Puppet lookup, Puppet will search three tiers of data, in this order:

1. Classic Hiera.
2. Environment data.
3. Module data.

If you do a merging lookup, Puppet can combine answers from all three tiers.

### What Are the Tiers For?

* Environment data is the core of Puppet lookup. It's where most of your data should live.
* Classic Hiera is for global overrides, when you need to fix something before a change can roll through your environments.
* Module data can only provide default values for a module's own parameters. Puppet lookup enforces that by only using it for keys in a given module's [namespace][]. (For example, Puppet will check the `apache` module for keys starting with `apache::`.)

## Three Tools: Function, Command, and Automatic Lookup

There are three ways to use Puppet lookup:

* [The `lookup` function][lookup_function] --- for looking up data from Puppet manifests. Replaces `hiera`, `hiera_array`, and `hiera_hash`; you can use optional arguments to control merge behavior and more.
* [The `puppet lookup` command][lookup_man] --- for looking up data from the CLI. Replaces the `hiera` command. Try the `--node` and `--explain` options to see how much more powerful it is.
* [Automatic class parameter lookup][auto_params] --- when you omit a class parameter, Puppet now uses Puppet lookup (instead of plain Hiera) to search for `<CLASS NAME>::<PARAMETER>` keys.

The Hiera functions and CLI tool are still around, but they can only access classic Hiera.

## Data Files are Hiera-Compatible

If you use Puppet lookup's `hiera` data provider in an environment or module, the YAML and JSON data files work exactly the same as Hiera's do. This means they can interpolate variables, do sub-lookups with the `hiera()` and `alias()` functions, etc. For details, see the following Hiera pages:

* [Writing Data Sources][]
* [Interpolation and Variables][hiera_interpolation]

## Using Environment Data

### ...If You Already Use Hiera in Environments

If you already keep Hiera's YAML or JSON data in your environments (probably with something like `:datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"`), you can switch to new-style environment data like this:

* Change any `hiera`/`hiera_array`/`hiera_hash` calls in your manifests to use `lookup` instead.
* Set `environment_data_provider = hiera` in `puppet.conf`. (Individual environments can override this in `environment.conf` if needed.)
* Create a `hiera.yaml` (version 4) file in each environment, recreating your existing hierarchy. [See below for the file format.][inpage_config_4]
* Edit your classic `hiera.yaml` config to use a datadir outside your environments (like `/etc/puppetlabs/code/hieradata`), so that classic Hiera won't interfere with the new environment data provider.

Once these steps are done, your Puppet infrastructure should work the same way it did before, but you'll have a lot more freedom the next time you want to make changes to your hierarchy.

To interactively see where Puppet is finding data, log into your Puppet master server and run `sudo puppet lookup <KEY> --node <NAME> --explain`. This will show you whether Puppet is using the new environment data or not.

### ...In General

Every environment can specify a **data provider.** Whenever Puppet compiles a catalog for a given environment, it will use that environment's data provider for all lookups.

To specify a data provider, set a value for the `environment_data_provider` setting. You can set this in [environment.conf][] (for an individual environment) or [puppet.conf][] (as a default for any environments that don't specify their own). You can only set one data provider per environment.

{% capture dataproviders %}
The default data provider is `none`, which doesn't provide any data. There are two other providers available:

* `hiera` --- Hiera-like data lookup, which is configured with a local [`hiera.yaml` (version 4)][inpage_config_4] file.
* `function` --- Function-based data lookup, which obtains a hash from a specially-named Puppet function.
{% endcapture %}

{{ dataproviders }}

#### More About the Function Data Provider

In an environment, the `function` provider calls a function named `environment::data`. (That's the literal string "environment", not the name of the environment.) This function must take no arguments and return a hash; Puppet will try to find the requested data as a key in that hash.

The `environment::data` function can be one of:

* A Puppet language function, located at `<ENVIRONMENT>/functions/data.pp`.
* A Ruby function (using the modern `Puppet::Functions` API), located at `<ENVIRONMENT>/lib/puppet/functions/environment/data.rb`.

Since using a data function with an environment is kind of impractical, this quick reference won't cover it in detail.

## Using Module Data

Every module can also specify a data provider. Whenever Puppet looks up a key _in a module's namespace,_ it will search that module's data after checking both Hiera and the current environment. (For example: since `apache::service::service_enable` starts with `apache::`, it's in the `apache` module's namespace.)

To specify a data provider, set a value for the `data_provider` key in a module's [metadata.json][] file. You can only set one data provider per module.

{{ dataproviders }}

### Details and Examples

Module data works almost exactly like environment data, but it supports a different use case. This makes it more complicated to explain than just "hiera.yaml lives in your environments now," so we put some examples on a separate page:

[Quick Intro to Module Data][quick_module]

## There Are Two `hiera.yaml` Formats Now

[inpage_config_4]: #there-are-two-hierayaml-formats-now

These files have the same name, but they're different. Sorry. We couldn't fix some of Hiera's limitations without a new format, but we couldn't change classic Hiera's config format in a minor Puppet agent release, so you'll be using two different formats for a while.

* [**Old `hiera.yaml`**][hiera_config] configures classic Hiera. It's [documented in the Hiera manual][hiera_config]. Puppet can only use one Hiera config file, and it's global across all environments.
* [**`hiera.yaml` (version 4)**][inpage_config_4] configures environment and module data. Every environment or module has its own `hiera.yaml` (version 4) file, but there's no global one.

### `hiera.yaml` (Version 4) in a Nutshell

~~~ yaml
# /etc/puppetlabs/code/environments/production/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Nodes"
    backend: yaml
    path: "nodes/%{trusted.certname}"

  # Putting a JSON level between YAML levels like this
  # was impossible in the old format.
  - name: "Exported JSON nodes"
    backend: json
    paths:
      # Puppet checks these in order. Even though this is a single
      # item in the hierarchy, it acts like multiple hierarchy levels.
      - "nodes/%{trusted.certname}"
      - "insecure_nodes/%{facts.fqdn}"

  - name: "virtual/%{facts.virtual}"
    backend: yaml

  - name: "common"
    backend: yaml
~~~

The `hiera.yaml` (version 4) file goes in the main directory of a module or environment, and is used when the `environment_data_provider` or `data_provider` setting is set to `hiera`.

It is a YAML hash that contains three keys:

* `version` --- Required. Must always be `4`.
* `datadir` --- Optional. The default datadir, for any hierarchy levels that omit it. It is a relative path, from the root of the environment or module. The default is `data`.
* `hierarchy` --- Optional. A hierarchy of data sources to search, in the new format. If omitted, it defaults to a single source called `common` that uses the YAML backend.

The `hierarchy` is an array of hashes. Unlike in classic Hiera, each hierarchy level must specify its own backend, and can optionally use a separate datadir.

Each hierarchy level can contain the following keys:

* `name` --- Required. An arbitrary human-readable name, used for debugging and for `puppet lookup --explain`.

    This is also used as the default `path` if you don't specify any paths. (If the name interpolates variables, Puppet will interpolate when finding data files but leave it uninterpolated when reporting the level's name.)
* `backend` --- Required. Which backend to use. Currently only `yaml` and `json` are supported.
* `path` --- Optional; mutually exclusive with `paths`. The path to a data file. Can interpolate variables, to use different files depending on a node's facts.
* `paths` --- Optional; mutually exclusive with `path`. An array of paths to data files, which can interpolate variables. This acts like multiple hierarchy levels, and is shorthand for writing consecutive levels that use the same backend and datadir.
* `datadir` --- Optional. A one-off datadir to use instead of the default one specified at top level.

#### Interpolation

Variable interpolation in `hiera.yaml` (version 4) works the same way as it does in classic Hiera. See [the Hiera interpolation docs][hiera_interpolation] for details.

## Specifying Merge Behavior

Classic Hiera could optionally do deep merging of values when doing hash-merge lookups, but you could only configure this globally, in the `hiera.yaml` file. This was very hacky, and made a lot of simple use cases totally impossible.

In Puppet lookup, you can't configure global merge behavior like that. Instead, you configure merge behavior on a per-key basis. There are two ways to do this:

* **At lookup time,** as an argument to the `lookup` function or `puppet lookup` command. This always wins, overriding any default merge behavior. See the function and command documentation for details.
* **In the data source,** using the new `lookup_options` metadata key. This allows you to set default merge behavior for any lookup, _including automatic parameter lookup_ (which previously could not do merging lookup at all). If a lookup specifies its own merge behavior, this will override the default behavior.

### Setting `lookup_options` in Data

Any normal data source can set a special `lookup_options` metadata key, which controls the default merge behavior for _other_ keys in your data.

The value of `lookup_options` should be a hash, where:

* Each key is the name of a key that Puppet lookup might be asked for (like `ntp::servers`).
* Each value is a hash. This hash may contain a `merge` key, whose value is valid for [the `lookup` function's][lookup_function] `merge` argument.

So, for example:

~~~ yaml
lookup_options:
  ntp::servers:
    merge: unique
~~~

Whenever Puppet looks up a key, it also checks `lookup_options` to see if it contains any merge settings for that key. If it does, it will use that merge behavior unless the lookup request overrides it.

In the example above, Puppet will default to a `unique` merge (also called an array merge) any time it looks up the `ntp::servers` key. This includes automatic lookup (as a default for the `ntp` class's `$servers` parameter).

#### The `lookup_options` Key is Reserved

`lookup_options` is a special reserved metadata key, and you cannot do a manual lookup for it. If you attempt to look up `lookup_options`, it will fail.

#### Modules Can Set Lookup Options for Their Own Namespace

Usually, module data can only set values for keys in that module's namespace. The `lookup_options` key is a special exception: a module can set a value for it, but it can only set options for keys in that module's namespace.

If a module sets options for keys outside its namespace, they will be ignored.

#### Environments and Classic Hiera can Set Options for Anything

...although options from Hiera only apply when it's consulted by Puppet lookup; the classic `hiera` functions will ignore them.

#### Lookup Options are Merged

Before deciding on a merge behavior, Puppet merges the `lookup_options` values using a hash merge. (_Not_ a deep merge; if a higher-priority source sets any options for a given key, it overrides _all_ that key's options from lower-priority sources.)

This allows module authors to request default merge behavior, but also allows end users to override it.
