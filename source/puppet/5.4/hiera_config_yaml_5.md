---
title: "Configuring Hiera"
---

[hierarchy]: ./hiera_intro.html#Hiera-hierarchies
[layers]: ./hiera_intro.html#Hiera's-three-config-layers
[confdir]: ./dirs_confdir.html
[module]: ./modules_fundamentals.html
[yaml]: http://www.yaml.org/YAML_for_ruby.html
[variables]: ./hiera_merging.html#interpolating-variables
[yaml_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/yaml_data.rb
[json_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/json_data.rb
[hocon_data]: https://github.com/puppetlabs/puppet/tree/master/lib/puppet/functions/hocon_data.rb
[interpolation]: ./hiera_interpolation.html
[eyaml]: https://github.com/voxpupuli/hiera-eyaml
[custom puppet function]: ./functions_basics.html
[backends]: ./hiera_custom_backends.html

The Hiera configuration file is called hiera.yaml. It configures the hierarchy for a given layer of data.

Related topics: [hierarchy][hierarchy], [layers][layers].

{:.reference}
## Location of hiera.yaml files

There are several hiera.yaml files in a typical deployment. Hiera uses three layers of configuration, and the module and environment layers typically have multiple instances.

The configuration file locations for each layer:

Layer       | Location                                        | Example
------------|-------------------------------------------------|--------
Global      | [`$confdir`][confdir]`/hiera.yaml`              | `/etc/puppetlabs/puppet/hiera.yaml` `C:\ProgramData\PuppetLabs\puppet\etc\hiera.yaml`
Environment | [`<ENVIRONMENT>`](https://puppet.com/docs/puppet/latest/environments_about.html) `/hiera.yaml` | `/etc/puppetlabs/code/environments/production/hiera.yaml` `C:\ProgramData\PuppetLabs\code\environments\production\hiera.yaml`
Module      | [`<MODULE>`][module]`/hiera.yaml`                           | `/etc/puppetlabs/code/environments/production/modules/ntp/hiera.yaml` `C:\ProgramData\PuppetLabs\code\environments\production\modules\ntp\hiera.yaml`

> Note: You can change the location for the global layer's hiera.yaml with Puppet's `hiera_config` setting.

Hiera searches for data in the following order: global → environment → module. For more information, see [Hiera configuration layers](https://puppet.com/docs/puppet/latest/hiera_intro.html#hiera-s-three-config-layers)

Related topics: [$confdir][confdir], [`<MODULE>`][module].

{:.concept}
## Config file syntax (hiera.yaml v5)

`hiera.yaml` is a YAML file, containing a hash with up to four top-level keys:

-   `version` - Required. Must be the number 5, with no quotes.
-   `hierarchy` - An array of hashes, which configures the levels of the hierarchy.
-   `default_hierarchy` - An array of hashes, which sets a default hierarchy to be used only if the normal hierarchy entries do not result in a value. Only allowed in a module's hiera.yaml.
-   `defaults` - A hash, which can set a default datadir, backend, and options for hierarchy levels.

``` yaml
---
version: 5
defaults:  # Used for any hierarchy level that omits these keys.
  datadir: data         # This path is relative to hiera.yaml's directory.
  data_hash: yaml_data  # Use the built-in YAML backend.

hierarchy:
  - name: "Per-node data"                   # Unique human-readable name.
    path: "nodes/%{trusted.certname}.yaml"  # File path, relative to datadir.
                                   # ^^^ IMPORTANT: include the file extension!

  - name: "Per-datacenter business group data" # Uses custom facts.
    path: "location/%{facts.whereami}/%{facts.group}.yaml"

  - name: "Global business group data"
    path: "groups/%{facts.group}.yaml"

  - name: "Per-datacenter secret data (encrypted)"
    lookup_key: eyaml_lookup_key   # Uses non-default backend.
    path: "secrets/%{facts.whereami}.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Per-OS defaults"
    path: "os/%{facts.os.family}.yaml"

  - name: "Common data"
    path: "common.yaml"
```

Related topics: [YAML][yaml]

### The default configuration

If you omit the `hierarchy` or `defaults` keys, Hiera uses the following default values:

``` yaml
---
version: 5
hierarchy:
  - name: Common
    path: common.yaml
defaults:
  data_hash: yaml_data
  datadir: data
```

These defaults are only used if the file is present and specifies `version: 5`. If hiera.yaml is absent, it disables Hiera for that layer. If it specifies a different version, different defaults apply.

{:.concept}
## The defaults key

The `defaults` key sets default values for the lookup function and `datadir` keys, which lets you omit those keys in your hierarchy levels.

The value of `defaults` must be a hash, which can have up to three keys: `datadir`, `options`, and one of the mutually exclusive lookup function keys.

### datadir

A default value for `datadir`, used for any file-based hierarchy level that doesn't specify its own. If not given, the `datadir` is the directory `data` in the same directory as the `hiera.yaml` configuration file.

### options

A default value for options, used for any hierarchy level that does not specify its own.

### The lookup function keys

Used for any hierarchy level that doesn't specify its own. This must be one of:

-   `data_hash` - produces a hash of key-value pairs (typically from a data file)
-   `lookup_key` - produces values key by key (typically for a custom data provider)
-   `data_dig` - produces values key by key (for a more advanced data provider)
-   `hiera3_backend` - a data provider that calls out to a legacy Hiera 3 backend (global layer only)

For the built-in data providers - YAML, JSON, and HOCON - the key is always `data_hash` and the value is one of `yaml_data`, `json_data`, or `hocon_data`. To set a custom data provider as the default, see the data provider documentation. Whichever key you use, the value must be the name of the custom Puppet function that implements the the lookup function.

Related topics: [custom backends][backends], [custom Puppet function][].

{:.concept}
## The hierarchy key

The `hierarchy` key configures the levels of the hierarchy.

{:.concept}
## The default_hierarchy key

The `default_hierarchy` key is a top-level key. It works exactly like the hierarchy key, but its values are used only if the normal hierarchy entries in the same module, or any of the higher precedence layers (environment or global) does not result in a value. Within this default hierarchy, the normal merging rules apply. However, the `default_hierarchy` is not permitted in environment or global layers.

Related topics: [hierarchies][hierarchy].

{:.task}
## The Hierarchy key: write an array of hashes

The value of `hierarchy` must be an array of hashes.

1.  Begin each level of the hierarchy with:

    -   Two spaces of indentation.
    -   A hyphen (`-`).
    -   Another space after the hyphen.
    -   The first key of that level's hash.

2.  Indent the rest of the hash's keys by four spaces, so they line up with the first key.

3.  Put an empty line between hashes, to visually distinguish them.

    ``` yaml
    hierarchy:
      - name: "Per-node data"
        path: "nodes/%{trusted.certname}.yaml"

      - name: "Per-datacenter business group data"
        path: "location/%{facts.whereami}/%{facts.group}.yaml"
    ```

{:.reference}
## Configuring a hierarchy level: built-in backends

Hiera has three built-in backends: YAML, JSON, and HOCON. All of these use files as data sources.

You can use any combination of these backends in a hierarchy, and can also combine them with custom backends. But if most of your data is in one file format, set default values for the `datadir` and `data_hash` keys.

Each YAML/JSON/HOCON hierarchy level needs the following keys:

-   `name` — A unique name for this level, shown in debug messages and `--explain` output.
-   `path`, `paths`, `glob`, `globs`, or `mapped_paths` (choose one) — The data files to use for this hierarchy level.
    -   These paths are relative to the datadir, they support variable interpolation, and they require a file extension. See “Specifying file paths” for more details.
-   `data_hash` — Which backend to use. Can be omitted if you set a default. The value must be one of the following:
    -   `yaml_data` for YAML.
    -   `json_data` for JSON.
    -   `hocon_data` for HOCON.
-   `datadir` — The directory where data files are kept. Can be omitted if you set a default.
    -   This path is relative to hiera.yaml's directory: if the config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml` and the datadir is set to data, the full path to the data directory is `/etc/puppetlabs/code/environments/production/data`.
    -   In the global layer, you can optionally set the datadir to an absolute path; in the other layers, it must always be relative.

Related topics: [variable interpolation][variables], [YAML][yaml_data], [JSON][json_data], [HOCON][hocon_data].

### Specifying file paths

Options for specifying a file path:

Key     | Data type | Expected value
--------|-----------|---------------
`path`  | String    | One file path.
`paths` | Array     | Any number of file paths. This acts like a sub-hierarchy: if multiple files exist, Hiera searches all of them, in the order in which they're written.
`glob`  | String    | One shell-like glob pattern, which might match any number of files. If multiple files are found, Hiera searches all of them in alphanumerical order.
`globs` | Array     | Any number of shell-like glob patterns. If multiple files are found, Hiera searches all of them in alphanumerical order (ignoring the order of the globs).
`mapped_paths` | Array or Hash     | A fact that is a collection (array or hash) of values. Hiera expands these values to produce an array of paths.

> Note: You can only use one of these keys in a given hierarchy level.

Explicit file extensions are required, for example, `common.yaml`, not `common`.

File paths are relative to the `datadir`: if the full datadir is `/etc/puppetlabs/code/environments/production/data` and the file path is set to `"nodes/%{trusted.certname}.yaml"`, the full path to the file is `/etc/puppetlabs/code/environments/production/data/nodes/<NODE NAME>.yaml`.

> Note: Hierarchy levels should interpolate variables into the path.

Globs are implemented with Ruby's `Dir.glob` method:

-   One asterisk (`*`) matches a run of characters.
-   Two asterisks (`**`) matches any depth of nested directories.
-   A question mark (`?`) matches one character.
-   Comma-separated lists in curly braces (`{one,two}`) match any option in the list.
-   Sets of characters in square brackets (`[abcd]`) match any character in the set.
-   A backslash (`\`) escapes special characters.

Example:

``` yaml
{% raw %}
- name: "Domain or network segment"
    glob: "network/**/{%{facts.networking.domain},%{facts.networking.interfaces.en0.bindings.0.network}}.yaml"
{% endraw %]
```

The `mapped_paths` key must contain three string elements, in the following order:

-   A scope variable that points to a collection of strings.
-   The variable name that will be mapped to each element of the collection.
-   A template where that variable can be used in interpolation expressions.

For example, a fact named `$services` contains the array `[“a”, “b”, “c”]`. The following configuration has the same results as if paths had been specified to be `[service/a/common.yaml, service/b/common.yaml, service/c/common.yaml]`.

``` yaml
- name: Example
    mapped_paths: [services, tmp, "service/%{tmp}/common.yaml"]
```

Related topics: [interpolate][interpolation], [hierarchies][hierarchy].

{:.reference}
## Configuring a hierarchy level: hiera-eyaml

Hiera 5 (Puppet 4.9.3 and later) includes a native interface for the Hiera eyaml extension, which keeps data encrypted on disk but lets Puppet read it during catalog compilation.

To learn how to create keys and edit encrypted files, see the [Hiera eyaml documentation](https://github.com/voxpupuli/hiera-eyaml).

Within `hiera.yaml`, the eyaml backend resembles the standard built-in backends, with a few differences: it uses `lookup_key` instead of `data_hash`, and requires an `options` key to locate decryption keys. Note that the eyaml backend can read regular yaml files as well as yaml files with encrypted data.

> **Important**: To use the eyaml backend, you must have the `hiera-eyaml` gem installed where Puppet can use it. It's included in Puppet Server since version 5.2.0, so you just need to make it available for command line usage. To enable eyaml on the command line and with `puppet apply`, use `sudo /opt/puppetlabs/puppet/bin/gem install hiera-eyaml`.

Each eyaml hierarchy level needs the following keys:

-   `name` — A unique name for this level, shown in debug messages and `--explain` output.
-   `lookup_key` — Which backend to use. The value must be `eyaml_lookup_key`. Use this instead of the `data_hash` setting.
-   `path`, `paths`, `mapped_paths`, `glob`, or `globs` (choose one) — The data files to use for this hierarchy level. These paths are relative to the datadir, they support variable interpolation, and they require a file extension. In this case, you'll usually use `.eyaml`. They work the same way they do for the standard backends.
-   `datadir` — The directory where data files are kept. Can be omitted if you set a default. Works the same way it does for the standard backends.
-   `options` — A hash of options specific to `hiera-eyaml`, mostly used to configure decryption. For the default encryption method, this hash must have the following keys:
    -   `pkcs7_private_key` — The location of the PKCS7 private key to use.
    -   `pkcs7_public_key` — The location of the PKCS7 public key to use.
    -   If you use an alternate encryption plugin, its docs should specify which options to set. Set an `encrypt_method` option, plus some plugin-specific options to replace the `pkcs7` ones.
    -   You can use normal strings as keys in this hash; you don't need to use symbols.

The file path key and the options key both support variable interpolation.

An example hierarchy level:

``` yaml
hierarchy:
  - name: "Per-datacenter secret data (encrypted)"
    lookup_key: eyaml_lookup_key
    path: "secrets/%{facts.whereami}.eyaml"
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
```

Related topics: [Hiera eyaml][eyaml], [variable interpolation][interpolation].

{:.reference}
## Configuring a hierarchy level: legacy Hiera 3 backends

> Note: This feature is a temporary measure to let you start using new features while waiting for backend updates.

If you rely on custom data backends designed for Hiera 3, you can use them in your global hierarchy. They are not supported at the environment or module layers.

Each legacy hierarchy level needs the following keys:

-   `name` — A unique name for this level, shown in debug messages and `--explain` output.
-   `path` or `paths` (choose one) — The data files to use for this hierarchy level.
    -   For file-based backends, include the file extension, even though you would have omitted it in the v3 hiera.yaml file.
    -   For non-file backends, don't use a file extension.
-   `hiera3_backend` — The legacy backend to use. This is the same name you'd use in the v3 config file's `:backends` key.
-   `datadir` — The directory where data files are kept. Set this only if your backend required a `:datadir` setting in its backend-specific options.
    -   This path is relative to hiera.yaml's directory: if the config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml` and the datadir is set to `data`, the full path to the data directory is `/etc/puppetlabs/code/environments/production/data`. Note that Hiera v3 uses  'hieradata' instead of 'data'.
    -   In the global layer, you can optionally set the datadir to an absolute path.
-   `options` — A hash, with any backend-specific options (other than `datadir`) required by your backend. In the v3 config, this would have been in a top-level key named after the backend.
You can use normal strings as keys. Hiera converts them to symbols for the backend.

The following example shows roughly equivalent v3 and v5 hiera.yaml files using legacy backends:

``` yaml
# hiera.yaml v3
---
:backends:
  - mongodb
  - xml

:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost

:xml:
  :datadir: /some/other/dir

:hierarchy:
  - "%{trusted.certname}"
  - "common"


# hiera.yaml v5
---
version: 5
hierarchy:
  - name: MongoDB
    hiera3_backend: mongodb
    paths:
      - "%{trusted.certname}"
      - common
    options:
      connections:
        dbname: hdata
        collection: config
        host: localhost

  - name: Data in XML
    hiera3_backend: xml
    datadir: /some/other/dir
    paths:
      - "%{trusted.certname}.xml"
      - common.xml
```

{:.reference}
## Configuring a hierarchy level: general format

Hiera supports custom backends.

See the backend's documentation for configuring hierarchy levels.

Each hierarchy level is represented by a hash which needs the following keys:

-   `name` — A unique name for this level, shown in debug messages and `--explain` output.
-   A backend key, which must be one of:
    -   `data_hash`
    -   `lookup_key`
    -   `data_dig` - a more specialized form of `lookup_key`, suitable when the backend is for a database. `data_dig`  resolves dot separated keys, whereas `lookup_key` does not.
    -   `hiera3_backend` (global layer only)
-   A path or URI key - only if required by the backend. These keys support variable interpolation. The following path/URI keys are available:
    -   `path`
    -   `paths`
    -   `mapped_paths`
    -   `glob`
    -   `globs`
    -   `uri`
    -   `uris` - these paths or URIs work the same way they do for the built-in backends. Hiera handles the work of locating files, so any backend that supports `path` automatically supports `paths`, `glob`, and `globs`. `uri` (string) and `uris` (array) can represent any kind of data source. Hiera does not ensure URIs are resolvable before calling the backend, and does not need to understand any given URI schema. A backend can omit the path/URI key, and rely wholly on the `options` key to locate its data.
-   `datadir` — The directory where data files are kept: the path is relative to hiera.yaml's directory. Only required if the backend uses the `path`, `paths`, `glob`, and `globs` keys, and can be omitted if you set a default.
-   `options` — A hash of extra options for the backend; for example, database credentials or the location of a decryption key. All values in the `options` hash support variable interpolation.

Whichever key you use, the value must be the name of a function that implements the backend API. Note that the choice here is made by the implementer of the particular backend, not the user.

Related topics: [custom Puppet function][custom puppet function], [custom backends][backends], [variable interpolation][interpolation].
