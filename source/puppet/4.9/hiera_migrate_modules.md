---
title: "Hiera: Add Hiera data to an existing module"
---

[hash merge operator]: ./lang_expressions.html#merging
[class inheritance]: ./lang_classes.html#inheritance
[conditional logic]: ./lang_conditional.html
[module layer]: ./hiera_layers.html#the-module-layer
[custom backend system]: ./hiera_custom_backends.html
[data_hash]: ./hiera_custom_data_dash.html
[functions_puppet]: ./lang_write_functions_in_puppet.html
[automatic class parameter lookup]: ./hiera_automatic.html


Almost every module needs default values for its class parameters. For many years, the preferred way to do this has been the "params.pp" pattern, but Hiera 5 offers some other approaches that you might find more convenient.

This page is a brief illustration of how to replace the "params.pp" pattern with Hiera data in an existing module.

> **Note:** The "params.pp" pattern isn't going anywhere --- it works fine, and all the features it relies on are permanent features of Puppet. But if you've ever wanted to use Hiera data instead, you finally have that option.


## Module data with the "params.pp" pattern

The "params.pp" pattern is an elegant little hack, which takes advantage of Puppet's idiosyncratic [class inheritance][] behavior. In short:

* One class in your module does nothing but set variables for the other classes. By tradition, this class is called `<MODULE>::params` (thus the pattern's nickname), but there's no special behavior based on that name.

    This class can use normal Puppet code to construct these values; usually, it uses [conditional logic][] based on the target operating system.
* The rest of the classes in the module inherits from the params class (or from another class that inherits from it). In their parameter lists, you can use the params class's variables as default values.

An example params class:

``` puppet
# ntp/manifests/params.pp
class ntp::params {
  $autoupdate = false,
  $default_service_name = 'ntpd',

  case $facts['os']['family'] {
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
```

A class that inherits from the params class and uses it to set default parameter values:

``` puppet
# ntp/manifests/init.pp
class ntp (
  $autoupdate   = $ntp::params::autoupdate,
  $service_name = $ntp::params::service_name,
) inherits ntp::params {
 ...
}
```


## Module data with a one-off custom Hiera backend

Hiera 5's [custom backend system][] is much simpler than in earlier Hiera versions. Although a general-purpose backend still takes a certain amount of thought, it's really easy to write a backend that only needs to work for one module. In fact, you can convert an existing params class to a [hash-based Hiera backend][data_hash] in a matter of minutes.

To create a Hiera backend, you need a Puppet function that returns a hash. You can [write that function in the Puppet language][functions_puppet], using the params class as a starting point:

``` puppet
# ntp/functions/params.pp
function ntp::params(
  Hash                  $options, # We ignore both of these arguments, but
  Puppet::LookupContext $context, # the function still needs to accept them.
) {
  $base_params = {
    'ntp::autoupdate'   => false,
      # Keys have to start with the module's namespace, which in this case is `ntp::`.
    'ntp::service_name' => 'ntpd',
      # Use key names that work with automatic class parameter lookup. This
      # key corresponds to the `ntp` class's `$service_name` parameter.
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

  # Merge the hashes, overriding the service name if this platform uses a non-standard one:
  $base_params + $os_params
}
```

Note that the [hash merge operator][] (`+`) is often useful in these functions.

Once you have a function, tell Hiera to use it by adding it to the [module-layer hiera.yaml][module layer]. A simple backend like this one doesn't require `path`, `datadir`, or `options` keys.

``` yaml
# ntp/hiera.yaml
---
version: 5
hierarchy:
  - name: "NTP class parameter defaults"
    data_hash: "ntp::params"
  # We only need one hierarchy level, since one function provides all the data.
```

Now Hiera can use your module's own backend for [automatic class parameter lookup][] --- if a user doesn't set their own value for a parameter (either in Puppet code or in their own Hiera data), the `ntp::params` function can provide a default value.

With Hiera-based defaults, you can simplify your module's main classes:

* They don't need to inherit from any other class.
* You don't need to explicitly set a default value with the `=` operator.

``` puppet
# ntp/manifests/init.pp
class ntp (
  # default values are in ntp/functions/params.pp
  $autoupdate,
  $service_name,
) {
 ...
}
```


## Module data with YAML data files

You can also manage your module's default data with basic Hiera YAML files.

Set up a hierarchy in your [module-layer hiera.yaml][module layer]:

``` yaml
# ntp/hiera.yaml
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "OS family"
    path: "os/%{facts.os.family}.yaml"

  - name: "common"
    path: "common.yaml"
```

Then, put the necessary data files in the datadir:

``` yaml
# ntp/data/common.yaml
---
ntp::autoupdate: false
ntp::service_name: ntpd

# ntp/data/os/AIX.yaml
---
ntp::service_name: xntpd

# ntp/data/os/Debian.yaml
ntp::service_name: ntp
```

With Hiera-based defaults, you can simplify your module's main classes:

* They don't need to inherit from any other class.
* You don't need to explicitly set a default value with the `=` operator.

``` puppet
# ntp/manifests/init.pp
class ntp (
  # default values are in ntp/data
  $autoupdate,
  $service_name,
) {
 ...
}
```

You can also use any other Hiera backend to provide your module's data; if you want to use a custom backend that's distributed as a separate module, you can mark that module as a dependency.
