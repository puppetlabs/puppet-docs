---
title: "Hiera: Config file syntax (hiera.yaml v5)"
---

[hierarchy]: ./hiera_hierarchy.html
[layers]: ./hiera_layers.html
[v4]: ./hiera_config_yaml_4.html
[v3]: ./hiera_config_yaml_3.html
[confdir]: ./dirs_confdir.html
[environment]: ./environments.html
[module]: ./modules_fundamentals.html
[yaml]: http://www.yaml.org/YAML_for_ruby.html
[json]: https://www.w3schools.com/js/js_json_syntax.asp
[hocon]: https://github.com/typesafehub/config/blob/master/HOCON.md
[interpolation]: ./hiera_interpolation.html
[dir.glob]: ruby-doc.org/core/Dir.html#method-c-glob
[custom puppet function]: ./functions_basics.html
[backends]: ./hiera_custom_backends.html
[eyaml]: https://github.com/voxpupuli/hiera-eyaml

Hiera's config file is called hiera.yaml. It configures the [hierarchy][] for a given [layer][layers] of data.

This version of Puppet supports three formats for hiera.yaml --- you can use any of them, although [v4][] and [v3][] are deprecated. This page is about version 5, the newest version.

Format | Allowed in                    | Description
-------|-------------------------------|------------
v5     | All three data layers         | The main version of hiera.yaml, which supports all Hiera 5 features.
[v4][] | Environment and module layers | Deprecated. A transitional format, used in the rough draft of Hiera 5 (when we were calling it "Puppet lookup"). Doesn't support custom backends.
[v3][] | Global layer                  | Deprecated. The classic version of hiera.yaml, which has some problems.

## Location

There are several hiera.yaml files in a normal deployment --- Hiera uses three layers of configuration, and the module and environment layers typically have multiple instances.

The config file locations for each layer are as follows:

Layer       | Location                                        | Example
------------|-------------------------------------------------|--------
Global      | [`$confdir`][confdir]`/hiera.yaml`              | `/etc/puppetlabs/puppet/hiera.yaml`, `C:\ProgramData\PuppetLabs\puppet\etc\hiera.yaml`
Environment | [`<ENVIRONMENT>`][environment]`/hiera.yaml` | `/etc/puppetlabs/code/environments/production/hiera.yaml`
Module      | [`<MODULE>`][module]`/hiera.yaml`                           | `/etc/puppetlabs/code/environments/production/modules/ntp/hiera.yaml`

> **Note:** You can change the location for the global layer with Puppet's `hiera_config` setting.

## Syntax

hiera.yaml is a [YAML][] file, containing a hash with up to three top-level keys:

* `version` --- **Required.** Must be the number `5`, with no quotes.
* `hierarchy` --- An array of hashes, which configures the levels of the hierarchy.
* `defaults` --- A hash, which can set a default datadir and backend for hierarchy levels.

{% partial _hiera.yaml_v5.md %}

> **Note:** In hiera.yaml v3, keys had to begin with a colon (like `:hierarchy`). That is no longer needed.

### The default configuration

If you omit the `hierarchy` and/or `defaults` keys, Hiera uses the following default values:

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

These defaults are only used if the file is present and specifies `version: 5`. If hiera.yaml is absent, it disables Hiera for that layer; if it specifies a different version, different defaults might apply.

## The `defaults` key

[inpage_defaults]: #the-defaults-key

The `defaults` key can set default values for the backend and `datadir` keys, which lets you omit those keys in your hierarchy levels.

The value of `defaults` must be a hash, which can have up to two keys:

* `datadir` --- A default value for `datadir`, used for any file-based hierarchy level that doesn't specify its own.
* A backend key, used for any hierarchy level that doesn't specify its own. This must be one of:
    * `data_hash`
    * `lookup_key`
    * `data_dig`
    * `hiera3_backend` (global layer only)

    For the built-in backends (YAML, JSON, and HOCON), the key is always `data_hash` and the value is one of `yaml_data`, `json_data`, or `hocon_data`. If you want to set a custom backend as the default, you'll need to check that backend's documentation.

    Whichever key you use, the value must be the name of the [custom Puppet function][] that implements the backend. For more details, see [How custom backends work][backends].

## The `hierarchy` key

The `hierarchy` key configures the levels of the hierarchy.

For an explanation of how hierarchies work, see [How hierarchies work][hierarchy]. This page focuses on the syntax.

### How to write an array of hashes

The value of `hierarchy` must be an array of hashes.

``` yaml
hierarchy:
  - name: "Per-node data"
    path: "nodes/%{trusted.certname}.yaml"

  - name: "Per-datacenter business group data"
    path: "location/%{facts.whereami}/%{facts.group}.yaml"
```

YAML has several ways to express an array of hashes. You can do whatever works, but here's the easiest way:

* Begin each level of the hierarchy with:
    * Two spaces of indentation.
    * A hyphen (`-`).
    * Another space after the hyphen.
    * The first key of that level's hash.
* Indent the rest of the hash's keys by four spaces, so they line up with the first key.
* Put an empty line between hashes, to visually distinguish them.

### Configuring a hierarchy level (built-in backends)

Hiera has three standard built-in backends: [YAML][], [JSON][], and [HOCON][]. All of these use files as data sources.

You can use any combination of these backends in a hierarchy, and can also combine them with custom backends. But if most of your data is in one file format, be lazy: [set default values for the `datadir` and `data_hash` keys.][inpage_defaults]

Each YAML/JSON/HOCON hierarchy level needs the following keys:

* `name` --- A name for this level, shown to humans in debug messages and `--explain` output.
* `path`, `paths`, `glob`, or `globs` (choose one) --- The data file(s) to use for this hierarchy level.

    These paths are relative to the datadir, they support [variable interpolation][interpolation], and they require a file extension. See below for more details.
* `data_hash` --- Which backend to use; can be omitted if you set a default. The value must be one of the following:
    * `yaml_data` for YAML.
    * `json_data` for JSON.
    * `hocon_data` for HOCON.
* `datadir` --- The directory where data files are kept; can be omitted if you set a default.

    This path is relative to hiera.yaml's directory: if the config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml` and the datadir is set to `data`, the full path to the data directory is `/etc/puppetlabs/code/environments/production/data`.

    In the global layer, you can optionally set the datadir to an absolute path; in the other layers, it must always be relative.

The only key that supports [variable interpolation][interpolation] is the file path.

#### Specifying file paths

There are four options for specifying a file path. You can only use _one_ of these keys in a given hierarchy level.

Key     | Data type | Expected value
--------|-----------|---------------
`path`  | String    | One file path.
`paths` | Array     | Any number of file paths. This acts like a sub-hierarchy: if multiple files exist, Hiera searches all of them, in the order in which they're written.
`glob`  | String    | One shell-like glob pattern, which might match any number of files. If multiple files are found, Hiera searches all of them in alphanumerical order.
`globs` | Array     | Any number of shell-like glob patterns. If multiple files are found, Hiera searches all of them in alphanumerical order (ignoring the order of the globs).

**Explicit file extensions are required** --- use something like `common.yaml`, not just `common`. (This is a change from prior versions of hiera.yaml, which magically guessed file extensions.)

File paths are relative to the `datadir`: if the full datadir is `/etc/puppetlabs/code/environments/production/data` and the file path is set to `"nodes/%{trusted.certname}.yaml"`, the full path to the file is `/etc/puppetlabs/code/environments/production/data/nodes/<NODE NAME>.yaml`. (Absolute file paths are also allowed, but are rarely practical.)

Whichever approach you choose, most of your hierarchy levels should [interpolate][interpolation] variables into the path, since that's what makes Hiera useful. For more information about crafting useful hierarchies, see [How hierarchies work][hierarchy].

Globs are implemented with [Ruby's `Dir.glob` method][dir.glob]. In short:

* One asterisk (`*`) matches a run of characters.
* Two asterisks (`**`) matches any depth of nested directories.
* A question mark (`?`) matches one character.
* Comma-separated lists in curly braces (`{one,two}`) match any option in the list.
* Sets of characters in square brackets (`[abcd]`) match any character in the set.
* A backslash (`\`) escapes special characters.

Example:

{% raw %}
``` yaml
  - name: "Domain or network segment"
    glob: "network/**/{%{facts.networking.domain},%{facts.networking.interfaces.en0.bindings.0.network}}.yaml"
```
{% endraw %}

### Configuring a hierarchy level (hiera-eyaml)

Hiera 5 (Puppet 4.9.3 and later) includes a native interface for the [Hiera eyaml][eyaml] extension, which keeps data encrypted on disk but lets Puppet read it during catalog compilation.

To learn how to create keys and edit encrypted files, see [the Hiera eyaml documentation][eyaml].

Within hiera.yaml, the eyaml backend mostly resembles the standard built-in backends, with a few differences. (It uses `lookup_key` instead of `data_hash`, and requires an `options` key to locate decryption keys.)

> **Important:** To use the eyaml backend, you must have the `hiera-eyaml` gem installed where Puppet can use it. You'll need to install it twice:
>
> * To enable eyaml with Puppet Server, use `sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml`.
> * To enable eyaml on the command line and with `puppet apply`, use `sudo /opt/puppetlabs/puppet/bin/gem install hiera-eyaml`.

Each eyaml hierarchy level needs the following keys:

* `name` --- A name for this level, shown to humans in debug messages and `--explain` output.
* `lookup_key` --- Which backend to use. The value must be `eyaml_lookup_key`. (Use this instead of the `data_hash` setting.)
* `path`, `paths`, `glob`, or `globs` (choose one) --- The data file(s) to use for this hierarchy level.

    These paths are relative to the datadir, they support [variable interpolation][interpolation], and they require a file extension. (In this case, you'll usually use `.eyaml`.) They work the same way they do for the standard backends.
* `datadir` --- The directory where data files are kept; can be omitted if you set a default. Works the same way it does for the standard backends.
* `options` --- A hash of options specific to `hiera-eyaml`, mostly used to configure decryption. For the default encryption method, this hash must have the following keys:
    * `pkcs7_private_key` --- The location of the PKCS7 private key to use.
    * `pkcs7_public_key` ---  The location of the PKCS7 public key to use.

    If you use an alternate encryption plugin, its docs should specify which options to set. You'll usually set an `encrypt_method` option, plus some plugin-specific options to replace the `pkcs7_` ones.

    Note that you can use normal strings as keys in this hash; you don't need to use :symbols.

The file path and the options both support [variable interpolation][interpolation].

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

### Configuring a hierarchy level (legacy Hiera 3 backends)

> **Note:** This feature is a temporary measure, to let you start using Hiera's new features while waiting for backend updates. We expect to remove Hiera 3 backend support in Puppet 6.

If you rely on custom data backends designed for Hiera 3, you can use them in your **global** hierarchy. (They are not supported at the environment or module layers.)

Each legacy hierarchy level needs the following keys:

* `name` --- A name for this level, shown to humans in debug messages and `--explain` output.
* `path` or `paths` (choose one) --- The data file(s) to use for this hierarchy level.

    For file-based backends, **include the file extension,** even though you would have omitted it in the v3 hiera.yaml file.

    For non-file backends, don't use a file extension.
* `hiera3_backend` --- The legacy backend to use. This is the same name you'd use in the v3 config file's `:backends` key.
* `datadir` --- The directory where data files are kept. Only set this if your backend required a `:datadir` setting in its backend-specific options.

    This path is relative to hiera.yaml's directory: if the config file is at `/etc/puppetlabs/code/environments/production/hiera.yaml` and the datadir is set to `data`, the full path to the data directory is `/etc/puppetlabs/code/environments/production/data`.

    In the global layer, you can optionally set the datadir to an absolute path.
* `options` --- A hash, with any backend-specific options (other than `datadir`) required by your backend. In the v3 config, this would have been in a top-level key named after the backend.

    You can use normal strings as keys; Hiera automatically converts them to symbols for the backend.

The following example shows roughly equivalent v3 and v5 hiera.yaml files using legacy backends:

<table><tr>
<td>
{% md %}
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
```
{% endmd %}
</td>

<td>
{% md %}
``` yaml
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
{% endmd %}
</td>
</tr></table>

### Configuring a hierarchy level (general format)

Hiera supports custom backends, which don't always act like the built-in backends.

Your backend's documentation should explain how to configure hierarchy levels for it, so you won't usually have to consult these rules. They're presented here as an aid for backend authors, and as a fallback in case of incomplete backend docs.

Each hierarchy level is represented by a hash, which needs the following keys:

* `name` --- A name for this level, shown to humans in debug messages and `--explain` output.
* A backend key, which must be one of:
    * `data_hash`
    * `lookup_key`
    * `data_dig`
    * `hiera3_backend` (global layer only)

    The backend determines which key you must use, so you'll have to check its documentation. In general, file-based backends usually use `data_hash`, fast non-file backends usually use `lookup_key`, and slow non-file backends usually use `data_dig`.

    Whichever key you use, the value must be the name of the [custom Puppet function][] that implements the backend. For more details, see [How custom backends work][backends].
* A path or URI key (only if required by the backend). **These keys support [variable interpolation][interpolation].** The following path/URI keys are available:
    * `path`
    * `paths`
    * `glob`
    * `globs`
    * `uri`
    * `uris`

    `path(s)` and `glob(s)` work the same way they do for the built-in backends. Hiera handles the work of locating files, so any backend that supports `path` automatically supports `paths`, `glob`, and `globs`.

    `uri` (string) and `uris` (array) can represent any kind of data source. Hiera doesn't ensure URIs are resolvable before calling the backend, and doesn't need to understand any given URI schema.

    It's also possible for a backend to omit the path/URI key, and rely wholly on the `options` key to locate its data.
* `datadir` --- The directory where data files are kept; the path is relative to hiera.yaml's directory. Only required if the backend uses the `path(s)` and `glob(s)` keys, and can be omitted if you set a default.
* `options` --- A hash of arbitrary extra options for the backend; for example, database credentials or the location of a decryption key. See the backend's documentation for details. **All values in the `options` hash support [variable interpolation][interpolation].**

