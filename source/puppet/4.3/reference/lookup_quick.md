---
layout: default
title: "Puppet Lookup: Quick Reference for Hiera Users"
canonical: "/puppet/latest/reference/lookup_quick.html"
---

{% partial ./_lookup_experimental.md %}


Puppet lookup is, among other things, a more capable replacement for Hiera. Since it uses a modified version of Hiera's data formats and configurable hierarchies, existing Hiera users don't have to learn very much to start using it.

This page is what Hiera users need to know about Puppet lookup.


## Puppet Lookup is: Classic Hiera + Environment Data + Module Data

Right now, Puppet lookup consists of two new things (environment data and module data) that work together with classic Hiera.

When you do a lookup, Puppet consults the following pools of data, in order:

1. Plain old Hiera. This always goes first, to keep backwards compatibility. It works the same way it always has.
2. Environment data, using the new data lookup providers. Each environment can configure its own data provider.
3. Module data, using the new data lookup providers. Each module can configure its own data provider.

We'll explain below how to configure environment and module data.

## Automatic Class Parameter Lookup Now Uses Puppet Lookup

When you declare or assign a class without setting values for its parameters, Puppet automatically looks up `<CLASS NAME>::<PARAMETER>` before falling back to the parameter's default value.

This used to just use classic Hiera; now, it uses Puppet lookup. (Values you set with Hiera will still win, since it searches Hiera first.)

Automatic parameter lookup is still limited to the first value found; it can't merge values from multiple data sources.

## `lookup` Replaces the Hiera Functions

The `hiera`, `hiera_array`, `hiera_hash`, and `hiera_include` functions still exist, but they don't use Puppet lookup; they just use classic Hiera.

To use Puppet lookup, you'll use the `lookup` function instead. It defaults to returning the first value found, like the `hiera` function, but you can do merged lookups (and even specify the merge strategy per-lookup) using its optional arguments. (And `hiera_include` hasn't been necessary since Puppet 3.0, because `include` can accept arrays now. Just use `include(lookup( ... ))`.)

See [the `lookup` function docs][lookup_function] for more details.

## `puppet lookup` Replaces Hiera's CLI

The new `puppet lookup` command lets you do ad-hoc lookups from the CLI. It's easier than the Hiera CLI, because it can directly access Puppet's stored node data via a `--node <NAME>` option.

It also has an `--explain` option that helps show where a piece of data was found. (Which works better with the new environment and module data than with classic Hiera.)

See [the puppet lookup man page][lookup_man] for more details.

## `hiera.yaml` is Two Different File Formats Now

They have the same name, but they're different. Sorry. We needed a new format to fix some of Hiera's limitations, but we couldn't change classic Hiera's config format in a minor release of Puppet agent, so you'll be using two different formats for a while.

* [**Old `hiera.yaml`**][hiera_config] configures classic Hiera. It's [documented in the Hiera manual][hiera_config]. Puppet can only use one Hiera config file, and it's global across all environments.
* [`hiera.yaml` (version 4)][hiera_4_config] configures environment and module data. Every environment or module has its own `hiera.yaml` (version 4) file, but there's no global or default one. The format is [documented here, on the `hiera.yaml` (version 4) page][hiera_4_config].

### `hiera.yaml` (Version 4), the Short Version

`hiera.yaml` (version 4) is a YAML hash that contains a `version` (must always be `4`), an optional default `datadir`, and a `hierarchy`.

The `hierarchy` is an array, and each item in it is a hash. Unlike in classic Hiera, each hierarchy level can specify its own backend or use a separate datadir.

The `datadir` is a relative path, from the root of the environment or module being configured. The default is `data`.

Each hierarchy level has an arbitrary human-readable name, which is used for debugging and for `puppet lookup --explain`. If you don't specify any paths to data files, the name will be used as the path. (If the name interpolates variables, Puppet will use the pre-interpolation string as the name but the interpolated version as the path.)

You can specify `path` or `paths` in a hierarchy level, but not both; `paths` will be searched in order, and can be easier to read if you have a bunch of consecutive hierarchy levels that use the same backend and datadir.

~~~ yaml
---
version: 4
datadir: data
hierarchy:
  - name: "Generated JSON nodes"
    backend: json
    datadir: data_generated
    path: "nodes/%{::trusted.certname}"

  - name: "Other hierarchy levels (YAML)"
    backend: yaml
    paths:
      - "nodes/%{::trusted.certname}"
      - "virtual/%{::virtual}"
      - "common"
~~~

## How to Use Environment Data

Use the new `environment_data_provider` setting in [environment.conf][] or [puppet.conf][] to enable data lookup for an environment. If Puppet looks up data while compiling for a node in that environment, it will consult the environment's data.

You can only set one data provider per environment. There are two allowed values:

* `hiera` --- This enables Hiera-like data lookup in the environment, which is configured with a `hiera.yaml` (version 4) file in the environment's main directory.
* `function` --- This enables function-based lookup in the environment. The environment must contain a Puppet function called `environment::data` that returns a hash, which will be used to fulfill data lookups. The function can be one of:
    * A function written in Ruby using the modern `Puppet::Functions` API (not yet fully documented), in `<ENVIRONMENT>/lib/puppet/functions/environment/data.rb`.
    * A function written in the Puppet language, in `<ENVIRONMENT>/functions/environment/data.rb`.

If you are already keeping Hiera data in your environments (by setting something like `:datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"`), you can switch to true environment data like this:

* Set `environment_data_provider = hiera` in each environment (or in puppet.conf to set a global default).
* Create a `hiera.yaml` (version 4) file in each environment, recreating your existing hierarchy.
* Edit your classic `hiera.yaml` to use a datadir outside your environments. (This is necessary because classic Hiera is always consulted before environment data.)

### Why Use This?

With classic Hiera, you have to use the same hierarchy for every environment, which makes it hard or impossible to roll hierarchy changes through your environments. Environment data makes that relatively easy.

## How to Enable Module Data

Use the new `data provider` setting in a module's [metadata.json][] file to enable data lookup for that module. If Puppet does a data lookup from that module

You can only set one data provider per module. There are two allowed values:

* `hiera` --- This enables Hiera-like data lookup in the module, which is configured with a `hiera.yaml` (version 4) file in the module's main directory.
* `function` --- This enables function-based lookup in the module. The module must contain a Puppet function called `<MODULE NAME>::data` that returns a hash, which will be used to fulfill data lookups. The function can be one of:
    * A function written in Ruby using the modern `Puppet::Functions` API (not yet fully documented), in `<MODULE ROOT>/lib/puppet/functions/<MODULE NAME>/data.rb`.
    * A function written in the Puppet language, in `<MODULE ROOT>/functions/data.rb`.

### Why Use This?

Using a Puppet language function for default module data is a lot like the classic "params.pp" pattern, but requires less boilerplate.

Using Hiera-like data sources for default module data doesn't necessarily add any new features over params.pp, but a lot of people are much more comfortable with Hiera's data formats and its hierarchical approach to data that varies by platform.

Most re-usable modules need to set default values for their classes. The current state of the art is the "params.pp" pattern, where most classes in the module inherit from a special `<MODULE>::params` class that only sets variables.

Params.pp works fine, but:

* Some people would rather manage their default data with Hiera-like data files.
* Everyone expects
Which works fine, but sometimes results in a lot of extra work when the author wants to let the user override those default values anyway. Additionally, some module authors would prefer to use Hiera-like data files to set default values.

