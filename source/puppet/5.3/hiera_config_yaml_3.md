---
title: "Hiera: Legacy config file syntax (hiera.yaml v3)"
---

[hierarchy]: ./hiera_hierarchy.html
[layers]: ./hiera_layers.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html
[merge]: ./hiera_merging.html
[confdir]: ./dirs_confdir.html
[yaml]: http://www.yaml.org/YAML_for_ruby.html
[custom_backends]: {{hiera}}/custom_backends.html
[puppetserver_gem]: {{puppetserver}}/gems.html#installing-and-removing-gems
[deep_merge_gem_docs]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/vendor/deep_merge
[interpolate]: ./hiera_interpolation.html


Hiera's config file is called hiera.yaml. It configures the [hierarchy][] for a given [layer][layers] of data.

This version of Puppet supports three formats for hiera.yaml --- you can use any of them, although [v4][] and v3 are deprecated. This page is about version 3, the legacy version.

Format | Allowed in                    | Description
-------|-------------------------------|------------
[v5][] | All three data layers         | The main version of hiera.yaml, which supports all Hiera 5 features.
[v4][] | Environment and module layers | Deprecated. A transitional format, used in the rough draft of Hiera 5 (when we were calling it "Puppet lookup"). Doesn't support custom backends.
v3     | Global layer                  | Deprecated. The classic version of hiera.yaml, which has some problems.


## Important: version 3 is deprecated.

Version 3 of hiera.yaml is deprecated, and we plan to remove support for it in Puppet 6.

More importantly, it has some major problems:

* The combinatorial hierarchy (run the whole hierarchy in one backend, then run the whole hierarchy in the next, then...) was annoying to reason about, and it made some simple workflows more difficult than necessary.
* Global configuration of deep hash merge behavior was a terrible idea. Hiera 5 has [better ways to configure it on a per-key basis.][merge]
* hiera.yaml v5 can support v3 backends, but not vice-versa.

You should upgrade your global hiera.yaml to [version 5][v5] when you get the chance.

## Location

The v3 hiera.yaml file can only be used at the [global config layer][layers].

The default location for the global hiera.yaml is [`$confdir`][confdir]`/hiera.yaml`. Depending on your platform, that's usually at `/etc/puppetlabs/puppet/hiera.yaml` or `C:\ProgramData\PuppetLabs\puppet\etc\hiera.yaml`.

You can use [the `hiera_config` setting](./configuration.html#hieraconfig) in `puppet.conf` to change the location of the global hiera.yaml.

## Format

hiera.yaml v3 must be a [YAML][] hash.

Each top-level key in the hash **must be a Ruby symbol with a colon (`:`) prefix.** The available settings are listed below, under ["Global Settings"](#global-settings) and ["Backend-Specific Settings"](#backend-specific-settings).

### Example config file

[example]: #example-config-file

``` yaml
---
:backends:
  - yaml
  - json
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{::environment}/hieradata"
:json:
  :datadir: "/etc/puppetlabs/code/environments/%{::environment}/hieradata"
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - "virtual/%{::virtual}"
  - "common"
```

### Default config values

If the config file exists but has no data, Hiera uses the following default settings:

``` yaml
---
:backends: yaml
:yaml:
  # on *nix:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
  # on Windows:
  :datadir: "C:\ProgramData\PuppetLabs\code\environments\%{environment}\hieradata"
:hierarchy:
  - "nodes/%{::trusted.certname}"
  - "common"
:logger: console
:merge_behavior: native
:deep_merge_options: {}
```

## Global settings


hiera.yaml v3 can contain any the following settings. If absent, they use default values as shown above. **Note that each setting must be a Ruby symbol with a colon (`:`) prefix.**

### `:hierarchy`

Must be a **string** or an **array of strings,** where each string is the name of a static or dynamic data source. (A dynamic source is simply one that contains a `%{variable}` interpolation token. [See "Creating Hierarchies" for more details][hierarchy].)

The data sources in the hierarchy are checked in order, top to bottom.

**Default value:** `["nodes/%{::trusted.certname}", "common"]`

### `:backends`

Must be a **string** or an **array of strings,** where each string is the name of an available Hiera backend. The built-in backends are `yaml` and `json`. Additional backends are available as add-ons.

> **Note:** hiera.yaml v3 only supports backends written to support Hiera 3. See the Hiera 3 docs about [custom backends][custom_backends] for details.

The list of backends is processed in order: in the [example above][example], Hiera would check the entire hierarchy in the **yaml** backend before starting again with the **json** backend.

**Default value:** `"yaml"`

### `:logger`

Must be the name of an available logger, as a **string.**

Loggers only control where warnings and debug messages are routed. You can use one of the built-in loggers, or write your own. The built-in loggers are:

* `console` (messages go directly to STDERR)
* `puppet` (messages go to Puppet's logging system)
* `noop` (messages are silenced)

> **Custom loggers:** You can make your own logger by providing a class called, e.g., `Hiera::Foo_logger` (in which case Hiera's internal name for the logger would be `foo`), and giving it class methods called `warn` and `debug`, each of which should accept a single string.

**Default value:** `"console"`; note that Puppet overrides this and sets it to `"puppet"`, regardless of what's in the config file.

### `:merge_behavior`

Which merge behavior the `hiera_hash` function should use. **Note that this does not affect automatic class parameter lookup, the `lookup` function, or the `puppet lookup` command.**

Must be one of the following:

* `native` (default) --- merge top-level keys only.
* `deep` --- merge recursively; in the event of conflicting keys, allow **lower priority** values to win. You almost never want this.
* `deeper` --- merge recursively; in the event of a conflict, allow **higher priority** values to win.

Anything but `native` requires the `deep_merge` Ruby gem to be installed. If you're using Puppet Server, you'll need to use the [`puppetserver gem`][puppetserver_gem] command to install the gem.

For more details about hash merge lookup strategies, see ["Hash Merge"](./lookup_types.html#hash-merge) and ["Deep Merging in Hiera"](./lookup_types.html#deep-merging-in-hiera).

### `:deep_merge_options`

A hash of deep merging options for `hiera_hash`, if `:merge_behavior` is set to `deeper` or `deep`. **Note that this does not affect automatic class parameter lookup, the `lookup` function, or the `puppet lookup` command.**

For example:

    :merge_behavior: deeper
    :deep_merge_options:
      :knockout_prefix: '--'

Available options are documented in [the `deep_merge` gem][deep_merge_gem_docs].

**Default value:** An empty hash of options.

## Backend-specific settings


Any backend can define its own settings and read them from hiera.yaml. If present, the value of a given backend's key must be a **hash,** whose keys are the settings it uses.

The following settings are available for the built-in backends:

### `:yaml` and `:json`

#### `:datadir`

The directory in which to find data source files. This must be a string.

You can [interpolate variables][interpolate] into the datadir using `%{variable}` interpolation tokens. This allows you to, for example, point it at `"/etc/puppetlabs/code/hieradata/%{::environment}"` to keep your production and development data entirely separate.

**Default value:** `"/etc/puppetlabs/code/environments/%{environment}/hieradata"` on \*nix, and `"C:\ProgramData\PuppetLabs\code\environments\%{environment}\hieradata"` on Windows.

