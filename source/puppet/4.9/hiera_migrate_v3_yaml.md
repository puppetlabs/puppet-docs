---
title: "Hiera: Convert a version 3 hiera.yaml to version 5"
---


[v3]: todo
[v4]: todo
[v5]: todo
[global layer]: todo
[migrate]: todo
[migrate_environment]: todo
[merging]: todo
[v5_builtin]: todo
[v5_legacy]: todo
[backends]: todo
[v5_backend]: todo

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
  - yaml
:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{environment}/hieradata"
:mongodb:
  :connections:
    :dbname: hdata
    :collection: config
    :host: localhost
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

If that's how you use Hiera, set a `defaults` key, with values for `datadir` and [one of the backend keys][v5_backend]:

``` yaml
defaults:
  datadir: data
  data_hash: yaml_data
```

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

...and we used both the `yaml` and `mongodb` backends. But when we checked into it, we learned that our business only uses Mongo for per-node data, using the `nodes/%{trusted.certname}` hierarchy level. The rest of the hierarchy was irrelevant to the Mongo backend.

So we'll only need one Mongo hierarchy level, but we still want all five levels in YAML. This means we'll be consulting _both_ backends for per-node data. After thinking for a bit, we decided that we want the YAML version of per-node data to be authoritative, so we'll put it before the Mongo version.

When you translate your hierarchy, you'll have to make the same kinds of investigations and decisions.

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

### Translating custom Hiera 3 backends

First, check to see if the backend's author has published a Hiera 5 update for it. If so, use that; see its documentation for details on how to configure hierarchy levels for it.

If there's no update and you only have the Hiera 3 version, you can use it in a version 5 hierarchy **at the [global layer][]** --- it won't work in the environment layer. You should try to find a Hiera 5 compatible replacement as soon as possible, or [learn how to write Hiera 5 backends yourself][backends].

For full details on how to configure a legacy backend, see [Configuring a hierarchy level (legacy Hiera 3 backends)][v5_legacy] in the hiera.yaml (version 5) reference.

When configuring a legacy backend, you'll need to use the previous value for its backend-specific settings.

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

  - name: "Other YAML hierarchy levels"
    paths: # Can specify an array of paths instead of a single one.
      - "location/%{facts.whereami}/%{facts.group}.yaml"
      - "groups/%{facts.group}.yaml"
      - "os/%{facts.os.family}.yaml"
      - "common.yaml"
```

