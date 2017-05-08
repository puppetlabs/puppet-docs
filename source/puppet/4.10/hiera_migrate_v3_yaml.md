---
title: "Hiera: Convert a version 3 hiera.yaml to version 5"
---


[v3]: ./hiera_config_yaml_3.html
[v4]: ./hiera_config_yaml_4.html
[v5]: ./hiera_config_yaml_5.html
[global layer]: ./hiera_layers.html#the-global-layer
[module layer]: ./hiera_layers.html#the-module-layer
[migrate]: ./hiera_migrate.html
[migrate_environment]: ./hiera_migrate_environments.html
[merging]: ./hiera_merging.html
[v5_builtin]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-built-in-backends
[v5_legacy]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-legacy-hiera-3-backends
[backends]: ./hiera_custom_backends.html
[v5_defaults]: ./hiera_config_yaml_5.html#the-defaults-key
[eyaml_v5]: ./hiera_config_yaml_5.html#configuring-a-hierarchy-level-hiera-eyaml

Hiera 5 supports three versions of the hiera.yaml file: [version 3][v3], [version 4][v4], and [version 5][v5]. If you've been using Hiera 3, your existing configuration is a [version 3][v3] hiera.yaml file at the [global layer][].

There are two [migration tasks][migrate] that involve translating a version 3 config to a version 5 one:

* [Creating new v5 hiera.yaml files for environments.][migrate_environment]
* Updating your global configuration to support Hiera 5 backends.

These are essentially the same process, although the global hierarchy has a few special capabilities.

## Starting configuration

To illustrate the conversion process, we'll use this example hiera.yaml (version 3) file:

``` yaml
:backends:
  - mongodb
  - eyaml
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost
:eyaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
  :pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
  :pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
:hierarchy:
  - "nodes/%{trusted.certname}"
  - "location/%{facts.whereami}/%{facts.group}"
  - "groups/%{facts.group}"
  - "os/%{facts.os.family}"
  - "common"
:logger: console
:merge_behavior: native
:deep_merge_options: {}
```

## Use strings instead of symbols for keys

Hiera 3 required you to use Ruby symbols as keys. (Symbols are short strings that start with a colon, like `:hierarchy`.) The version 5 config format lets you use regular strings as keys, although it won't error on symbols.

Go ahead and remove the leading colons as you make the rest of these edits.

## Remove dead settings

Remove everything except the `:hierarchy` setting.

Delete the following settings completely:

* `:logger`
* `:merge_behavior`
* `:deep_merge_options`

These have no equivalent in a version 5 config, and are no longer needed. Delete them if they're present. If you'd like to learn about how Hiera 5 supports deep hash merging, see [Merging data from multiple sources][merging].

Delete the following settings, but paste them into a temporary file for later reference:

* `:backends`
* Any backend-specific setting sections, like `:yaml` or `:mongodb`.

## Add `version: 5`

The version 5 format requires a `version` key, with a value of `5`.

``` yaml
version: 5
hierarchy:
  # ...
```

## Set a default backend and datadir

Most people use one backend for the majority of their data, and it's usually one of the file-based backends like YAML or JSON.

If that's how you use Hiera, [set a `defaults` key][v5_defaults], with values for `datadir` and one of the backend keys:

``` yaml
defaults:
  datadir: data
  data_hash: yaml_data
```

Remember that the names of the backends have changed for Hiera 5, and the `backend` setting itself has been split into three settings:

Hiera 3 backend | Hiera 5 backend setting
----------------|------------------------
`yaml`          | `data_hash: yaml_data`
`json`          | `data_hash: json_data`
`eyaml`         | `lookup_key: eyaml_lookup_key`

## Translate the hierarchy

The version 5 and version 3 hierarchies work completely differently:

* In version 3, hierarchy levels don't have a backend assigned to them, and Hiera loops through the entire hierarchy for each backend.
* In version 5, each hierarchy level has one designated backend, as well as its own independent configuration for that backend.

This means you'll have to put some amount of thought into translating your hierarchy. You'll also need to consult the previous values for the `:backends` key and any backend-specific settings.

In our example above, we had the following hierarchy:

``` yaml
:hierarchy:
  - "nodes/%{trusted.certname}"
  - "location/%{facts.whereami}/%{facts.group}"
  - "groups/%{facts.group}"
  - "os/%{facts.os.family}"
  - "common"
```

...and we used the `yaml`, `eyaml`, and `mongodb` backends. But when we checked into it, we learned that our business only uses Mongo for per-node data, and only uses eyaml for per-group data. The rest of the hierarchy was irrelevant to these backends.

So we only need one Mongo level and one eyaml level, but we still want all five levels in YAML. This means we'll consult multiple backends for per-node and per-group data. After thinking for a bit, we decided that we want the YAML version of per-node data to be authoritative, so we'll put it before the Mongo version. Our eyaml data doesn't overlap at all with the unencrypted per-group data, so it doesn't matter as much where we put it; we'll put it before the YAML levels, because why not.

When you translate your hierarchy, you'll have to make the same kinds of investigations and decisions.

### Remove hierarchy levels with `calling_module` and friends

Hiera 3 could use three special pseudo-variables (which weren't available in Puppet code) in its hierarchy:

* `calling_module`
* `calling_class`
* `calling_class_path`

Hiera.yaml version 5 doesn't support these, so you must drop any hierarchy levels that interpolate them.

These variables were added to support a hacky predecessor of module data; anything you were doing with them is better accomplished with [the module layer][module layer].

### Translating built-in backends

In version 5 configs, the hierarchy is written as an array of hashes. For hierarchy levels that use the built-in backends (YAML and JSON, plus the new HOCON backend), you'll use the `data_hash` key to set the backend. For full syntax details, see [Configuring a hierarchy level (built-in backends)][v5_builtin] in the hiera.yaml (version 5) reference.

The short version is, you need to set the following keys:

* `name` --- A human-readable name.
- `path` or `paths` --- The path you used in your version 3 hiera.yaml hierarchy, **but with a file extension appended.**
* `data_hash` --- The backend to use. `yaml_data` for YAML, `json_data` for JSON.
* `datadir` --- The data directory. In version 5, it's relative to the hiera.yaml file's directory, although in a [global layer][] config it can also be an absolute path.

If you've set default values for `data_hash` and `datadir`, you can omit them.

``` yaml
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/%{trusted.certname}.yaml" # Add file extension.
    # Omitting datadir and data_hash to use defaults.

  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```

### Translating hiera-eyaml

The hiera-eyaml backend works mostly the same as the other built-in backends. The only differences are:

* The `hiera-eyaml` gem has to be installed, and you need a keypair.
* There's a different backend setting. Instead of `data_hash: yaml`, use `lookup_key: eyaml_lookup_key`.
* Each hierarchy level needs an `options` key with paths to the public/private keys. You can't set a global default for this.

``` yaml
  - name: "Per-group secrets"
    path: "groups/%{facts.group}.eyaml"
    lookup_key: eyaml_lookup_key
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
```

For more info, see the [eyaml usage instructions in the hiera.yaml (v5) syntax reference][eyaml_v5].

### Translating custom Hiera 3 backends

First, check to see if the backend's author has published a Hiera 5 update for it. If so, use that; see its documentation for details on how to configure hierarchy levels for it.

If there's no update and you only have the Hiera 3 version, you can use it in a version 5 hierarchy **at the [global layer][]** --- it won't work in the environment layer. You should try to find a Hiera 5 compatible replacement as soon as possible, or [learn how to write Hiera 5 backends yourself][backends].

For full details on how to configure a legacy backend, see [Configuring a hierarchy level (legacy Hiera 3 backends)][v5_legacy] in the hiera.yaml (version 5) reference.

When configuring a legacy backend, you'll need to use the previous value for its backend-specific settings. In our case, the v3 config had the following settings for MongoDB:

``` yaml
:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost
```

So we would write the following for our per-node MongoDB hierarchy level:

``` yaml
  - name: "Per-node data (MongoDB version)"
    path: "nodes/%{trusted.certname}"      # No file extension
    hiera3_backend: mongodb
    options:    # Use old backend-specific options, changing keys to plain strings
      connections:
        dbname: hdata
        collection: config
        host: localhost
```

## Final configuration

After following these steps, we've translated our example configuration into the following v5 config:

``` yaml
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "Per-node data (yaml version)"
    path: "nodes/%{trusted.certname}.yaml" # Add file extension
    # Omitting datadir and data_hash to use defaults.

  - name: "Per-node data (MongoDB version)"
    path: "nodes/%{trusted.certname}"      # No file extension
    hiera3_backend: mongodb
    options:    # Use old backend-specific options, changing keys to plain strings
      connections:
        dbname: hdata
        collection: config
        host: localhost

  - name: "Per-group secrets"
    path: "groups/%{facts.group}.eyaml"
    lookup_key: eyaml_lookup_key
    options:
      pkcs7_private_key: /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
      pkcs7_public_key:  /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of a single one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```

