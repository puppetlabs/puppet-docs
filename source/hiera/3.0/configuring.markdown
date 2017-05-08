---
layout: default
title: "Hiera 3: The hiera.yaml Config File"
---

[common_appdata]: /puppet/latest/reference/install_windows.html#the-commonappdata-folder
[yaml]: http://www.yaml.org/YAML_for_ruby.html
[hierarchy]: ./hierarchy.html
[interpolate]: ./variables.html
[custom_backends]: ./custom_backends.html
[puppetserver_gem]: /puppetserver/latest/gems.html#installing-and-removing-gems
[deep_merge_gem_docs]: https://github.com/danielsdeleo/deep_merge/blob/master/README.md

{% partial /hiera/_hiera_update.md %}

Hiera's config file is usually referred to as `hiera.yaml`. Use this file to configure the [hierarchy][], which backend(s) to use, and settings for each backend.

Hiera will fail with an error if the config file can't be found, although an empty config file is allowed.

Location
-----

By default, the config file is:

* `/etc/puppetlabs/code/hiera.yaml` on \*nix systems
* [`COMMON_APPDATA`][common_appdata]`\PuppetLabs\code\hiera.yaml` on Windows

### Changing the Config File Location

You can specify a different config file for Hiera via Puppet, the command line, or Ruby code.

#### In Puppet

You can use [the `hiera_config` setting](/puppet/latest/reference/configuration.html#hieraconfig) in `puppet.conf` to specify a different config file.

#### From the Command Line

You can specify a different config file with the `-c` (`--config`) option.

#### From Ruby Code

You can specify a different config file or a hash of settings when calling `Hiera.new`.

Format
-----

Hiera's config file must be a [YAML][] hash. The file must be valid YAML, but may contain no data.

Each top-level key in the hash **must be a Ruby symbol with a colon (`:`) prefix.** The available settings are listed below, under ["Global Settings"](#global-settings) and ["Backend-Specific Settings"](#backend-specific-settings).

### Example Config File

[example]: #example-config-file

~~~ yaml
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
~~~

### Default Config Values

If the config file exists but has no data, the default settings will be equivalent to the following:

~~~ yaml
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
~~~

Global Settings
-----

The Hiera config file may contain any the following settings. If absent, they will have default values. **Note that each setting must be a Ruby symbol with a colon (`:`) prefix.**

### `:hierarchy`

Must be a **string** or an **array of strings,** where each string is the name of a static or dynamic data source. (A dynamic source is simply one that contains a `%{variable}` interpolation token. [See "Creating Hierarchies" for more details][hierarchy].)

The data sources in the hierarchy are checked in order, top to bottom.

**Default value:** `["nodes/%{::trusted.certname}", "common"]`

### `:backends`

Must be a **string** or an **array of strings,** where each string is the name of an available Hiera backend. The built-in backends are `yaml` and `json`. Additional backends are available as add-ons.

> **Custom backends:** See ["Writing Custom Backends"][custom_backends] for details on writing new backend. Custom backends can interface with nearly any existing data store.

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

Must be one of the following:

* `native` (default) --- merge top-level keys only.
* `deep` --- merge recursively; in the event of conflicting keys, allow **lower priority** values to win. You almost never want this.
* `deeper` --- merge recursively; in the event of a conflict, allow **higher priority** values to win.

Anything but `native` requires the `deep_merge` Ruby gem to be installed. If you're using Puppet Server, you'll need to use the [`puppetserver gem`][puppetserver_gem] command to install the gem.

For more details about hash merge lookup strategies, see ["Hash Merge"](./lookup_types.html#hash-merge) and ["Deep Merging in Hiera"](./lookup_types.html#deep-merging-in-hiera).

### `:deep_merge_options`

Must be a hash of options to pass to the `deep merge` gem, if `:merge_behavior` is set to `deeper` or `deep`. For example:

    :merge_behavior: deeper
    :deep_merge_options:
      :knockout_prefix: '--'

Available options are documented in [the `deep_merge` gem][deep_merge_gem_docs].

**Default value:** An empty hash of options.

Backend-Specific Settings
-----

Any backend can define its own settings and read them from Hiera's config file. If present, the value of a given backend's key must be a **hash,** whose keys are the settings it uses.

The following settings are available for the built-in backends:

### `:yaml` and `:json`

#### `:datadir`

The directory in which to find data source files. This must be a string.

You can [interpolate variables][interpolate] into the datadir using `%{variable}` interpolation tokens. This allows you to, for example, point it at `"/etc/puppetlabs/code/hieradata/%{::environment}"` to keep your production and development data entirely separate.

**Default value:** `"/etc/puppetlabs/code/environments/%{environment}/hieradata"` on \*nix, and `"C:\ProgramData\PuppetLabs\code\environments\%{environment}\hieradata"` on Windows.

