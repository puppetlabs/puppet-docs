---
layout: default
title: "Puppet Lookup: Quick Reference for Hiera Users"
canonical: "/puppet/latest/reference/lookup_quick.html"
---

[lookup_function]: TODO
[lookup_man]: TODO
[auto_params]: TODO
[hiera_config]: TODO
[hiera_4_config]: TODO
[environment.conf]: TODO
[puppet.conf]: TODO
[metadata.json]: TODO


{% partial ./_lookup_experimental.md %}


We designed Puppet lookup to be familiar to Hiera users, but there are a few important differences. If you already use Hiera, this page will catch you up on the changes.

## What Is Puppet Lookup?

It's a lot like Hiera, except that:

* Environments can configure their own lookup hierarchies, which frees you to manage hierarchy changes like the rest of your code.
* Modules can contribute default data, which is used if an environment (or classic Hiera) doesn't specify some.
* The lookup tools are slightly better.

There are some extra details, and we might add more new features in the future, but those are the most important bits.

## Three Tiers: Classic Hiera → Environment Data → Module Data

Every time you request data through the new Puppet lookup system, Puppet will search three tiers of data:

1. Classic Hiera.
2. Environment data.
3. Module data.

Puppet checks the tiers in that order, with classic Hiera always going first (for backwards compatibility).

If you do a merging lookup, Puppet can combine answers from all three tiers.

## Three Tools: Function, Command, and Automatic Lookup

There are three ways to use Puppet lookup:

* The `lookup` function (see the [function docs][lookup_function]).
* The `puppet lookup` command (see the [man page][lookup_man]).
* Automatic class parameter lookup (see the [language docs about automatic lookup][auto_params]).

### The `lookup` Function

Puppet manifests can request data with the new `lookup` function. By default, it acts like the `hiera` function; with optional arguments, it can mimic `hiera_array` and `hiera_hash`. (For `hiera_include` behavior, just use `include( lookup(...) )`.)

The older Hiera functions are still around, but they can only access classic Hiera.

See [the `lookup` function docs][lookup_function] for more details.

### The `puppet lookup` Command

The `puppet lookup` command lets you look up data from the CLI.

Use the `--node <NAME>` option to automatically use real facts from PuppetDB. Use the `--explain` option to see how Puppet arrived at a given answer.

See [the puppet lookup man page][lookup_man] for more details.


### Automatic Class Parameter Lookup

If you omit a parameter when declaring a class, Puppet automatically looks up the value of `<CLASS NAME>::<PARAMATER NAME>` before using the default value (or failing, if there's no default.) This is called automatic class parameter lookup, or sometimes "data binding".

This feature has changed: instead of using Hiera directly, it now uses Puppet lookup, so it can access environment or module data if classic Hiera doesn't set a value.

Other than that, it works the same as it did before. It can't do merging lookups, and will only use the first value found.

See the [language docs about automatic lookup][auto_params] for more details.

## Using Environment Data

### ...If You Already Use Hiera in Environments

If you already keep classic Hiera's YAML or JSON data in your environments (probably with something like `:datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"`), you can switch to new-style environment data like this:

* Set `environment_data_provider = hiera` in puppet.conf.
* Create a `hiera.yaml` (version 4) file in each environment, recreating your existing hierarchy. [See below for the file format.][inpage_config_4]
* Edit your classic `hiera.yaml` to use a datadir outside your environments (like `/etc/puppetlabs/code/hieradata`), so that classic Hiera won't interfere with the new environment data provider.

Once these three steps are done, your Puppet infrastructure should work the same way it did before, but you'll have a lot more freedom the next time you want to make changes to your hierarchy.

### ...In General

Every environment can specify a **data provider.** Whenever Puppet compiles a catalog for a given environment, it will use that environment's data provider for all lookups.

To specify a data provider, set a value for the `environment_data_provider` setting. You can set this in [environment.conf][] (for an individual environment) or [puppet.conf][] (as a default for any environments that don't specify their own). You can only set one data provider per environment.

{% capture dataproviders %}
The default data provider is `none`, which doesn't provide any data. There are two other providers available:

* `hiera` --- Hiera-like data lookup, which is configured with a local [`hiera.yaml` (version 4)][inpage_config_4] file.
* `function` --- Function-based data lookup, which is a simpler interface. It calls a specially-named Puppet function that returns a hash, and tries to find the requested data as a key in that hash. It's generally better for modules than for environments.
{% endcapture %}

{{ dataproviders }}

    In an environment, the `function` provider expects a function named `environment::data`. (That's the literal string "environment", not the name of the environment.) This can be one of:

    * A Puppet language function, located at `<ENVIRONMENT>/functions/environment/data.pp`.
    * A Ruby function (using the modern `Puppet::Functions` API), located at `<ENVIRONMENT>/lib/puppet/functions/environment/data.rb`.

## Using Module Data

Every module can also specify a data provider. Whenever Puppet looks up a key _in a module's namespace,_ it will search that module's data after checking both Hiera and the current environment. (For example: since `apache::service::service_enable` starts with `apache::`, it's in the `apache` module's namespace.)

To specify a data provider, set a value for the `data_provider` key in a module's [metadata.json][] file. You can only set one data provider per module.

{{ dataproviders }}

    In a module, the `function` provider expects a function named `<MODULE NAME>::data`. This can be one of:

    * A Puppet language function, located at `<MODULE>/functions/data.pp`.
    * A Ruby function (using the modern `Puppet::Functions` API), located at `<MODULE>/lib/puppet/functions/<MODULE NAME>/data.rb`.

### Migrating From `params.pp`

If you already use the "params.pp" pattern to set default values for your modules' parameters, you can easily switch to using a function or Hiera-like data. To do this, you'll need to:

* Write a function or a hierarchy of data files that will produce the same values as the `params.pp` manifest.
    * Use names that your class parameters will automatically look up. So for example, if `params.pp` sets a `$service_name` variable that gets used by class `ntp`, you'd want to assign that value to the key `ntp::service_name`.
* Set `"data_provider": "function"` or `"data_provider": "hiera"` in the module's `metadata.json` file.
* Edit the module's main classes to:
    * Remove any default parameter values that reference variables from the `<MODULE>::params` class.
    * Stop inheriting from `<MODULE>::params`.
* Delete the params class.

#### Example With Params.pp

~~~ ruby
# ntp/manifests/params.pp
class ntp::params {
  $autoupdate = false
  $default_service_name = 'ntpd'

  case $::osfamily {
    'AIX': {
      $service_name = 'xntpd'
    }
    'Debian': {
      $service_name = 'ntp'
    }
    'RedHat': {
      $service_name = $default_service_name
    }
  }
}
~~~

~~~ ruby
# ntp/manifests/init.pp
class ntp (
  $autoupdate   = $ntp::params::autoupdate,
  $service_name = $ntp::params::service_name,
) inherits ntp::params {
 ...
}
~~~

#### Example With Function

~~~ json
# ntp/metadata.json
{
  ...
  "data_provider": "function"
}
~~~

~~~ ruby
# ntp/functions/data.pp
function ntp::data() {
  $base_params = {
    'ntp::autoupdate'   => false,
    'ntp::service_name' => 'ntpd',
  }

  case $facts['os']['family'] {
    'AIX': {
      $os_params = {
        'ntp::service_name' => 'xntpd'
      }
    }
    'Debian': {
      $os_params = {
        'ntp::service_name' => 'ntp'
      }
    }
    default: {
      $os_params = {}
    }
  }

  # merge params and return a single hash
  $base_params + $os_params
}
~~~

~~~ ruby
# ntp/manifests/init.pp
# ntp/manifests/init.pp
class ntp (
  # default values are in ntp/functions/data.pp
  $autoupdate
  $service_name
) {
 ...
}
~~~

#### Example With Hiera

~~~ json
# ntp/metadata.json
{
  ...
  "data_provider": "hiera"
}
~~~

~~~ yaml
# ntp/hiera.yaml
---
version: 4
datadir: data
hierarchy:
  - name: "OS family"
    backend: yaml
    path: "os/%{facts.os.family}

  - name: "common"
    backend: yaml

# ntp/data/common.yaml
---
ntp::autoupdate: false
ntp::service_name: ntpd

# ntp/data/os/AIX.yaml
---
ntp::service_name: xntpd

# ntp/data/os/Debian.yaml
ntp::service_name: ntp
~~~

~~~ ruby
# ntp/manifests/init.pp
# ntp/manifests/init.pp
class ntp (
  # default values are in ntp/data
  $autoupdate
  $service_name
) {
 ...
}
~~~

## There Are Two `hiera.yaml` Formats Now

[inpage_config_4]: #there-are-two-hierayaml-formats-now

These files have the same name, but they're different. Sorry. We couldn't fix some of Hiera's limitations without a new format, but we couldn't change classic Hiera's config format in a minor Puppet agent release, so you'll be using two different formats for a while.

* [**Old `hiera.yaml`**][hiera_config] configures classic Hiera. It's [documented in the Hiera manual][hiera_config]. Puppet can only use one Hiera config file, and it's global across all environments.
* [**`hiera.yaml` (version 4)**][hiera_4_config] configures environment and module data. Every environment or module has its own `hiera.yaml` (version 4) file, but there's no global one. The format is [documented on the `hiera.yaml` (version 4) page][hiera_4_config].

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

  - name: "Exported JSON nodes"
    backend: json
    paths:
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

The `hierarchy` is an array, and each item in it is a hash. Unlike in classic Hiera, each hierarchy level can specify its own backend or use a separate datadir.

Each hierarchy level has an arbitrary human-readable name, which is used for debugging and for `puppet lookup --explain`. If you don't specify any paths to data files, the name will be used as the path. (If the name interpolates variables, Puppet will use the pre-interpolation string as the name but the interpolated version as the path.)

You can specify `path` or `paths` in a hierarchy level, but not both; `paths` will be searched in order, and can be easier to read if you have a bunch of consecutive hierarchy levels that use the same backend and datadir.



