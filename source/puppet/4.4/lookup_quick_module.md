---
layout: default
title: "Puppet Lookup: Quick Intro to Module Data"
canonical: "/puppet/latest/lookup_quick_module.html"
---

[hash merge operator]: ./lang_expressions.html#merging
[metadata.json]: ./modules_metadata.html


{% partial ./_lookup_experimental.md %}

This page is a short introduction to setting default parameter values in a module with Puppet lookup.

## General Instructions: Migrating From `params.pp`

Many modules today already specify complex default values for their parameters using the "params.pp" pattern. (This is where the main classes inherit from a `<MODULE>::params` class, which only sets variables.)

If you already use the "params.pp" pattern, you can easily switch to using a function or Hiera-like data for your defaults. To do this, you'll need to:

* Write a function or a hierarchy of data files that will produce the same values as the `params.pp` manifest.
    * Use names that your class parameters will automatically look up. For example, if your `ntp` class has a `$service_name` parameter, assign its default value to the key `ntp::service_name`.
* Set `"data_provider": "function"` or `"data_provider": "hiera"` in the module's [`metadata.json` file.][metadata.json]
* Edit the module's main classes to:
    * Remove any default parameter values that reference variables from the `<MODULE>::params` class.
    * Stop inheriting from `<MODULE>::params`.
* Delete the params class.

## More About the Function Data Provider

In a module, the `function` provider calls a function named `<MODULE NAME>::data`. This function must take no arguments and return a hash; Puppet will try to find the requested data as a key in that hash.

The `<MODULE NAME>::data` function can be one of:

* A Puppet language function, located at `<MODULE ROOT>/functions/data.pp`.
* A Ruby function (using the modern `Puppet::Functions` API), located at `<MODULE ROOT>/lib/puppet/functions/<MODULE NAME>/data.rb`.

Within the bounds of that interface (special function name, does something to return a hash), you could pretty much do anything with this provider. But practically speaking, you'll probably write something that looks a lot like a params class, which uses conditional logic to set different values depending on a node's facts.

## Complete Examples

The following examples illustrate three different ways to set default parameter values:

* With the "params.pp" pattern.
* With a Puppet language function.
* With Hiera-like data sources.

They don't use very many parameters, but they demonstrate the sort of defaults-plus-overrides behavior you'll see in most params classes.

### Example With Params.pp

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

With the params.pp pattern, the main classes must inherit from the params class and explicitly set default values for the parameters.

~~~ ruby
# ntp/manifests/init.pp
class ntp (
  $autoupdate   = $ntp::params::autoupdate,
  $service_name = $ntp::params::service_name,
) inherits ntp::params {
 ...
}
~~~

### Example With Function

~~~ json
# ntp/metadata.json
{
  ...
  "data_provider": "function"
}
~~~

Instead of setting variables, our function needs to return a hash. Other than that, it looks a lot like a params class.

The [hash merge operator][] is a convenient way to override default data using the results of a case statement.

~~~ ruby
# ntp/functions/data.pp
function ntp::data() {
  $base_params = {
    'ntp::autoupdate'   => false,
    'ntp::service_name' => 'ntpd',
  }

  $os_params = case $facts['os']['family'] {
    'AIX': {
      { 'ntp::service_name' => 'xntpd' }
    }
    'Debian': {
      { 'ntp::service_name' => 'ntp' }
    }
    default: {
      {}
    }
  }

  # Merge the hashes and return a single hash.
  $base_params + $os_params
}
~~~

Defaults set with Puppet lookup don't need to be explicitly set, and you no longer have to inherit from any particular class.

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

### Example With Hiera

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
~~~

In this case, the Hiera version of the defaults ends up being simpler than either params.pp or the function. However, there might be cases where Puppet or Ruby code could express the logic in a more succinct and maintainable way.

~~~ yaml
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

Defaults set with Puppet lookup don't need to be explicitly set, and you no longer have to inherit from any particular class.

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
